import win32pipe
import win32file
import pywintypes
import threading
import signal
import sys
import time

# Named pipe names
pipe_server_to_ahk = r'\\.\pipe\server_to_ahk'
pipe_ahk_to_server = r'\\.\pipe\ahk_to_server'

# Global flag to control thread termination
stop_event = threading.Event()

def create_pipe_server(pipe_name):
    try:
        pipe = win32pipe.CreateNamedPipe(
            pipe_name,
            win32pipe.PIPE_ACCESS_DUPLEX,
            win32pipe.PIPE_TYPE_MESSAGE | win32pipe.PIPE_READMODE_MESSAGE | win32pipe.PIPE_WAIT,
            1, 65535, 65535, 0, None
        )
        return pipe
    except pywintypes.error as e:
        print(f"Error creating pipe {pipe_name}: {e}")
        return None

def connect_to_pipe(pipe_name, retries=5, delay=1):
    for attempt in range(retries):
        try:
            handle = win32file.CreateFile(
                pipe_name,
                win32file.GENERIC_READ | win32file.GENERIC_WRITE,
                0, None,
                win32file.OPEN_EXISTING,
                0, None
            )
            return handle
        except pywintypes.error as e:
            print(f"Attempt {attempt+1}/{retries} - Error connecting to pipe {pipe_name}: {e}")
            if attempt < retries - 1:
                time.sleep(delay)
    return None

def listen_for_messages(pipe):
    while not stop_event.is_set():
        try:
            # 确保管道有效
            if pipe is None:
                print("Reconnecting to pipe...")
                pipe = connect_to_pipe(pipe_ahk_to_server)
                if pipe is None:
                    print("Failed to reconnect to pipe, retrying...")
                    time.sleep(1)
                    continue
            
            # 非阻塞检查数据（可选，但需要额外 API 支持）
            data = win32file.ReadFile(pipe, 65535)
            message = data[1].decode('utf-8')
            print(f"Python received: {message}")
        except pywintypes.error as e:
            if not stop_event.is_set():
                print(f"Error reading from pipe: {e}")
                if e.winerror == 109:  # 管道已结束
                    try:
                        win32file.CloseHandle(pipe)
                        print("Client pipe closed due to error 109.")
                    except pywintypes.error:
                        pass
                    pipe = None  # 标记管道无效，触发重连
                time.sleep(1)  # 避免高 CPU 占用
    # 不再在 finally 中关闭 pipe，延迟到主线程

def send_message(pipe, message):
    try:
        # 仅在首次发送时连接
        if not hasattr(send_message, "connected") or not send_message.connected:
            win32pipe.ConnectNamedPipe(pipe, None)
            send_message.connected = True
        win32file.WriteFile(pipe, message.encode('utf-8'))
        # 刷新管道
        win32file.FlushFileBuffers(pipe)
        return True
    except pywintypes.error as e:
        print(f"Error writing to pipe: {e}")
        send_message.connected = False
        if e.winerror == 109:  # 管道已结束
            stop_event.set()
        return False

def signal_handler(sig, frame):
    print("\nReceived termination signal, shutting down...")
    stop_event.set()
    # 确保主线程退出
    sys.exit(0)

if __name__ == "__main__":
    # 注册信号处理
    signal.signal(signal.SIGINT, signal_handler)  # 处理 Ctrl+C
    signal.signal(signal.SIGTERM, signal_handler)  # 处理终止信号

    # Create server pipe (server_to_ahk)
    pipe_server = create_pipe_server(pipe_server_to_ahk)
    if not pipe_server:
        sys.exit(1)
    
    # Connect to AHK's pipe (ahk_to_server)
    pipe_client = connect_to_pipe(pipe_ahk_to_server)
    if not pipe_client:
        win32file.CloseHandle(pipe_server)
        sys.exit(1)
    
    # 启动监听线程
    listen_thread = threading.Thread(target=listen_for_messages, args=(pipe_client,), daemon=True)
    listen_thread.start()
    
    # Send messages to AHK
    print("Python ready. Enter messages to send to AutoHotkey 2.0:")
    while not stop_event.is_set():
        try:
            msg = input("> ")
            if not stop_event.is_set():
                if not send_message(pipe_server, msg):
                    break
        except KeyboardInterrupt:
            print("Shutting down...")
            stop_event.set()
            break
        except EOFError:
            print("EOF detected, shutting down...")
            stop_event.set()
            break
    
    # Cleanup
    try:
        win32file.CloseHandle(pipe_server)
        print("Server pipe closed.")
    except pywintypes.error as e:
        print(f"Error closing server pipe: {e}")
    if pipe_client:
        try:
            win32file.CloseHandle(pipe_client)
            print("Client pipe closed.")
        except pywintypes.error as e:
            print(f"Error closing client pipe: {e}")
    
    print("Python script terminated.")
    sys.exit(0)

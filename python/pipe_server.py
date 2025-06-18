import win32pipe
import win32file
import pywintypes
import time


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

def listen_for_messages(pipe, pipe_ahk_to_server, stop_event):
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
        # if e.winerror == 109:  # 管道已结束
        #     stop_event.set()
        return e.winerror

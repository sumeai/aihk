import win32file
import pywintypes
import threading
import signal
import sys
from fastapi import FastAPI, HTTPException
from fastapi.responses import JSONResponse
from pipe_server import *

app = FastAPI()

# Named pipe names
pipe_server_to_ahk = r'\\.\pipe\server_to_ahk'
pipe_ahk_to_server = r'\\.\pipe\ahk_to_server'

# Global flag to control thread termination
stop_event = threading.Event()

def signal_handler(sig, frame):
    print("\nReceived termination signal, shutting down...")
    stop_event.set()
    # 确保主线程退出
    sys.exit(0)

def cleanup():
    print("Cleaning up...")
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


@app.get("/exit")
async def exitapp(report_no: str):
    if report_no == "exit":
        cleanup()
        return JSONResponse(content={"status": "success", "data": "successfully exited"})
    else:
        return JSONResponse(content={"status": "failed", "data": "请输入正确的报告编号"})


@app.get("/hhh/approve")
async def approve(report_no: str):
    if not stop_event.is_set():
        msg = f"Approve: {report_no}"
        re = send_message(pipe_server, msg)

        if re == 109:  # 管道已结束
            stop_event.set()

        return JSONResponse(content={"status": "success", "data": msg})
        
    return JSONResponse(content={"status": "failed", "data": "审核未成功"})


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
    listen_thread = threading.Thread(target=listen_for_messages, args=(pipe_client, pipe_ahk_to_server, stop_event), daemon=True)
    listen_thread.start()
    
    import uvicorn
    uvicorn.run(app, host="127.0.0.1", port=12701)


    # # Send messages to AHK
    # print("Python ready. Enter messages to send to AutoHotkey 2.0:")
    # while not stop_event.is_set():
    #     try:
    #         msg = input("> ")
    #         if not stop_event.is_set():
    #             if not send_message(pipe_server, msg):
    #                 break
    #     except KeyboardInterrupt:
    #         print("Shutting down...")
    #         stop_event.set()
    #         break
    #     except EOFError:
    #         print("EOF detected, shutting down...")
    #         stop_event.set()
    #         break
    
    # Cleanup
    cleanup()

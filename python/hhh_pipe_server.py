import win32file
import pywintypes
import threading
import signal
import sys
import requests
import json
from load_hhh_config import read_hhh_config
from fastapi import FastAPI, HTTPException
from fastapi.responses import JSONResponse
from fastapi.middleware.cors import CORSMiddleware
from pipe_server import *


app = FastAPI()


# Named pipe names
pipe_server_to_ahk = r'\\.\pipe\server_to_ahk'
pipe_ahk_to_server = r'\\.\pipe\ahk_to_server'

# Global flag to control thread termination
stop_event = threading.Event()

# Read active status from config file
config = read_hhh_config()

HHH_SERVER = config["hhh_server"]
AI_COMMON_SERVER = config["ai_common_server"]
ALLOW_ORIGINS = config["allow_origins"]

# Parse allowed origins from config into array
allow_origin_array = [origin.strip() for origin in ALLOW_ORIGINS.split(',')] if ALLOW_ORIGINS else []

# Add CORS middleware
app.add_middleware(
    CORSMiddleware,
    allow_origins=allow_origin_array,
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)


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


def get_report_no_by_ph_num(ph_num: str):
    try:
        response = requests.get(f"{HHH_SERVER}/hhh/phnum2report?ph_num={ph_num}", timeout=15)
        if response.status_code == 200:
            data = response.json()
            result = data.get('data')
            if isinstance(result, list) and len(result) > 0 and isinstance(result[0], dict):
                return result[0].get('REPORT_NO')
        return None
    except requests.RequestException:
        return None
    


@app.get("/hhh/approve")
async def approve(report_no: str = None, ph_num: str = None):
    if not report_no and not ph_num:
        return JSONResponse(content={"status": "failed", "data": "报告编号和手机号不能同时为空"})

    if not stop_event.is_set():
        # 如果没有报告编号，则通过样品编号查询得到报告编号
        if not report_no:
            report_no = get_report_no_by_ph_num(ph_num)
            if not report_no:
                return JSONResponse(content={"status": "failed", "data": "未查询到该样品的检测报告"})

        # 发送审核消息
        msg = f"Approve: {report_no}"
        re = send_message(pipe_server, msg)

        if re == 109:  # 管道已结束
            stop_event.set()

        return JSONResponse(content={"status": "success", "data": msg})
        
    return JSONResponse(content={"status": "failed", "data": "审核未成功"})



@app.post("/hhh/approve/list")
async def approve_list(reports: list[object]):
    if not reports:
        return JSONResponse(content={"status": "failed", "data": "报告编号列表不能为空"})
    
    # Convert reports list to JSON string
    
    # Convert reports list to JSON string and extract report_no array
    # reports_json = json.dumps([report for report in reports])
    reports_array = [report.get('reportNo') for report in reports if isinstance(report, dict) and report.get('reportNo')]
    # reports_string = json.dumps(reports_array)


    if not stop_event.is_set():
        save_to_db(reports)

        msg = f"ApproveList: {reports_array}"
        re = send_message(pipe_server, msg)

        if re == 109:  # 管道已结束
            stop_event.set()

        return JSONResponse(content={"status": "success", "data": msg})
    
    return JSONResponse(content={"status": "failed", "data": "审核未成功"})


def save_to_db(reports: list[object]):
    # reports_array = [report.get('reportNo') for report in reports if isinstance(report, dict) and report.get('reportNo')]
    # if not reports_array:
    #     return
    # payload = {"reportNoList": reports_array}

    try:
        response = requests.post(f"{AI_COMMON_SERVER}/ai/dify/insertSanheAuditList", json=reports)
        response.raise_for_status()

        print(f"save to DB successfully: {response.text}")

    except requests.RequestException as e:
        print(f"Failed to save to DB: {e}")


@app.post("/hhh/approve/list/check")
async def approve_list(reports: list[str]):
    if not reports:
        return JSONResponse(content={"status": "failed", "data": "报告编号列表不能为空"})
    

    if not stop_event.is_set():

        msg = f"Checkbox: {reports}"
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
    
    print("========== server_to_ahk pipe created. ===========")
    
    # Connect to AHK's pipe (ahk_to_server)
    pipe_client = connect_to_pipe(pipe_ahk_to_server)
    if not pipe_client:
        win32file.CloseHandle(pipe_server)
        sys.exit(1)
    
    # 启动监听线程
    listen_thread = threading.Thread(target=listen_for_messages, args=(pipe_client, pipe_ahk_to_server, stop_event), daemon=True)
    listen_thread.start()
    print("========== listen_for_messages. ===========")
    
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
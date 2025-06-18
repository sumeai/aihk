#Include .\include\python.aik
#Include .\include\pipe_client.aik
#Include .\include\tip.aik

; 初始化日志文件
logFile := "pipe_client.log"
if (FileExist(logFile)) {
    ; 创建logger目录
    loggerDir := "logger"  ; 定义目录路径
    if !DirExist(loggerDir) {
        DirCreate(loggerDir)
    }    
    
    ; 将日志文件移动到logger目录
    newFileName := Format("{}\{}\logFile_{}.log", A_ScriptDir, loggerDir, A_Now)

    FileMove logFile, newFileName
}

FileAppend("[" A_Now "] Starting pipe client...`n", logFile)

; 全局变量跟踪管道连接状态
global pipe_ahk2server_connected := false
global python_pid := 0

pipe_server_to_ahk := "\\.\pipe\server_to_ahk"
pipe_ahk_to_server := "\\.\pipe\ahk_to_server"


; 创建服务器管道 (ahk_to_server)
FileAppend("[" A_Now "] Creating named pipe: " pipe_ahk_to_server "`n", logFile)
hPipeServer := CreateNamedPipe(pipe_ahk_to_server)
if (hPipeServer = -1) {
    FileAppend("[" A_Now "] Failed to create named pipe!`n", logFile)
    ExitApp()
}
FileAppend("[" A_Now "] Named pipe created successfully, handle: " hPipeServer "`n", logFile)
MsgBox "创建ahk_to_server管道成功, 请启动Python创建服务器管道，`n然后再确定准备连接server_to_ahk！"


; hPipeClient := DllCall("CreateFile", "Str", pipe_server_to_ahk, "UInt", 0xC0000000, "UInt", 0, "Ptr", 0, "UInt", 3, "UInt", 0, "Ptr", 0, "Ptr")
; if (hPipeClient = -1) {
;     ; 连接服务器管道失败，则尝试调用python创建服务器管道，然后再重度连接
;     try {
;         python_pid := PythonRun("./python/hhh_pipe_server.py") 
;         MsgBox "Python pid:" python_pid
;     } catch as e {
;         MsgBox("Failed to start Python script: " . e.Message)
;         ExitApp()
;     }


;     ; 尝试连接到 Python 的管道 (server_to_ahk) 并重试
;     hPipeClient := ConnectServerPipe(pipe_server_to_ahk) 
;     if (hPipeClient = -1) {
;         DllCall("CloseHandle", "Ptr", hPipeServer)
;         ProcessClose(python_pid)
;         ExitApp()
;     }
    
; }

; 尝试连接到 Python 的管道 (server_to_ahk) 并重试
FileAppend("[" A_Now "] Attempting to connect to server pipe: " pipe_server_to_ahk "`n", logFile)
hPipeClient := ConnectServerPipe(pipe_server_to_ahk) 
if (hPipeClient = -1) {
    FileAppend("[" A_Now "] Failed to connect to pipe: " pipe_server_to_ahk "`n", logFile)
    MsgBox "退出AHK程序，Failed to connect to pipe \\.\pipe\server_to_ahk."
    DllCall("CloseHandle", "Ptr", hPipeServer)
    ExitApp()
}
FileAppend("[" A_Now "] Successfully connected to server pipe, handle: " hPipeClient "`n", logFile)

; 定时检查 Python 的消息
SetTimer(CheckPipe, 1000)

CheckPipe() {
    global hPipeClient, logFile
    ; FileAppend("[" A_Now "] Checking pipe for messages...`n", logFile)
    ; ToolTip "---"
    msg := CheckPipeReceived(hPipeClient)

    if (msg) {
        FileAppend("[" A_Now "] Received message: " msg "`n", logFile)
        ; talkshow "PIPE[" A_TickCount "]::" msg 

        MessageHandler(msg)
    } else {
        ; FileAppend("[" A_Now "] No message received`n", logFile)
        ; ToolTip "PIPE[" A_TickCount "]:: " msg 
    }
}

MessageHandler(msg) {
    msgarr := StrSplit(msg, ":")
    cmdtype := msgarr[1]
    message := msgarr[2]

    web_pid := 0

    if (cmdtype = "Approve") {
        report_no := Trim(message)
        url := "https://lims-approve.szswgcjc.com/?reportCode=" report_no "&env=DEV&isRetry=false&o_u_token=9dcbf9915878418c9df5c3aef4010b1b&type=approve"
        cmd := "chrome.exe --window-position=100,100 --window-size=800,600 --app=" url
        Run cmd, , , &web_pid
    }

    
}


; 发送消息到 Python
SendMessageToPython(msg) {
    global hPipeServer, pipe_ahk2server_connected, logFile

    FileAppend("[" A_Now "] Preparing to send message: " msg "`n", logFile)

    ; 建立管道连接
    if (!pipe_ahk2server_connected) {
        FileAppend("[" A_Now "] Pipe not connected, attempting to connect...`n", logFile)
        ; 尝试连接管道
        result := DllCall("ConnectNamedPipe", "Ptr", hPipeServer, "Ptr", 0)
        if (result = 0) {
            error := A_LastError
            if (error = 535) {  
                pipe_ahk2server_connected := true
                FileAppend("[" A_Now "] Pipe connected successfully`n", logFile)
            } else if (error != 536) {  ; ERROR_pipe_ahk2server_connected 已连接
                FileAppend("[" A_Now "] ConnectNamedPipe failed with error: " error "`n", logFile)
                MsgBox("ConnectNamedPipe ahk_to_serve  failed with error: " . error)
                return false
            }
        }
        pipe_ahk2server_connected := true
    }

    ; 使用 UTF-8 编码消息，发送消息
    FileAppend("[" A_Now "] Sending message to Python...`n", logFile)
    re := SendMessageToPythonServer(hPipeServer, msg)
    FileAppend("[" A_Now "] Message sent, result: " re "`n", logFile)
    return re
}


; 按 F1 发送消息
F6:: {
    SendMessageToPython("Hello from AHK!")
}


:*?:;exitpipe;::
F4:: {
    MsgBox "退出AHK程序"
    ExitApp()
}


; 清理并退出
OnExit(ExitFunc)

ExitFunc(ExitReason, ExitCode) {
    global hPipeClient, hPipeServer, pipe_ahk2server_connected, python_pid, logFile
    
    FileAppend("[" A_Now "] Starting cleanup, ExitReason: " ExitReason ", ExitCode: " ExitCode "`n", logFile)

    if (hPipeClient > 0) {
        FileAppend("[" A_Now "] Closing client pipe handle: " hPipeClient "`n", logFile)
        DllCall("CloseHandle", "Ptr", hPipeClient)
    }

    if (hPipeServer > 0) {
        if (pipe_ahk2server_connected) {
            FileAppend("[" A_Now "] Disconnecting server pipe`n", logFile)
            DllCall("DisconnectNamedPipe", "Ptr", hPipeServer)
        }        
        FileAppend("[" A_Now "] Closing server pipe handle: " hPipeServer "`n", logFile)
        DllCall("CloseHandle", "Ptr", hPipeServer)
    }

    if (python_pid > 0) {
        FileAppend("[" A_Now "] Terminating Python process: " python_pid "`n", logFile)
        ProcessClose(python_pid)
    }

    FileAppend("[" A_Now "] Cleanup completed, exiting application`n", logFile)
    ExitApp()
}
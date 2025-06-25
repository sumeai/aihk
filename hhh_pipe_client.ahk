#Include ./inc/python.aik
#Include ./inc/pipe_client.aik
#Include ./inc/tip.aik
#include ./lib/UIA.ahk
#include ./lib/UIA_Browser.ahk

; 记录打开过的url和对应的pid
gUrlPidMap := Map()
gUrlPosMap := Map()
gLastOpenUrl := ""


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

MsgBox("创建ahk_to_server管道成功, `n`n请启动Python创建服务器管道，`n`n然后再确定准备连接server_to_ahk！", "请启动Python管道服务器")


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
    global gUrlPosMap
    msgarr := StrSplit(msg, ":")
    cmdtype := msgarr[1]
    message := msgarr[2]

    if (cmdtype = "Approve") {
        report_no := Trim(message)
        ApproveHandler(report_no)
    } else if (cmdtype = "ApproveList") {
        ApproveListHandler(message)
    } else if (cmdType = "Checkbox") {
        CheckboxSelectHandler(message)
    }
}

/**
 * 打开报告审核助手窗口
 * Opens a browser window with the approval URL for the given report number.
 * 
 * @param report_no The report number to generate the approval URL for
 * @returns void
 * @remarks The window will be positioned at (100,100) with size 800x600 if successfully opened
 */
ApproveHandler(report_no) {
    url := "https://192.168.1.70:5173/?reportCode=" report_no "&isRetry=false&company=sanhe"

    web_pid := OpenURLWindow(url)
    if (web_pid > 0) {
        gUrlPidMap[url] := web_pid
        if WinWait("ahk_pid " web_pid, , 3) {
            WinMove 100, 100, 800, 600, "ahk_pid " web_pid
            gUrlPosMap[url] := (100, 100, 800, 600)
        }
    }
}


/**
 * 打开待审核列表窗口
 * Processes and opens an approved list URL in a browser window.
 * 
 * @param message - The raw message containing the list data
 * @returns void - Opens a browser window with the processed URL
 * 
 * The function:
 * 1. Cleans and formats the input message
 * 2. Constructs a URL with the processed data
 * 3. Opens the URL in a browser window
 * 4. Positions and remembers the window location
 */
ApproveListHandler(message) {
    CloseAllUrlWindows()

    reportList := Trim(message)
    reportList := StrReplace(reportList, "`'", "%22")
    reportList := StrReplace(reportList, " ", "")


    url := "https://192.168.1.70:5173/?listData=" reportList

    ; A_Clipboard := url
    ; MsgBox "url: " url
    web_pid := OpenURLWindow(url)
    if (web_pid > 0) {
        ; gUrlPidMap[url] := web_pid
        ; if WinWait("ahk_pid " web_pid, , 3) {
        ;     WinMaximize("ahk_pid " web_pid)
        ;     ; WinMove 500, 500, 800, 500, "ahk_pid " web_pid
        ;     gUrlPosMap[url] := (0, 0, A_ScreenWidth, A_ScreenHeight)
        ; }
        WinWait("AI审批助手")
        if WinExist("AI审批助手 ahk_exe msedge.exe")
            WinMaximize

        if WinExist("AI审批助手 ahk_exe chrome.exe")
            WinMaximize   
    }
}

CheckboxSelectHandler(reports) {
    jsCode := getCheckJS(reports)
    ; MsgBox "getCheckJS: " jsCode

    try {
        browser := UIA_Browser("建设工程质量检测机构管理系统 ahk_exe chrome.exe")
        browser.JSExecute(jsCode)
        CloseAllUrlWindows()
    } catch Error as e {
        MsgBox("操作失败: " e.Message)
    }
}


getCheckJS(reports){
    jsCode := '
(
(function () {
    function simulateClick(el) {
        const events = ['mousedown', 'mouseup', 'click'];
        for (const type of events) {
            el.dispatchEvent(
                new MouseEvent(type, {
                    bubbles: true,
                    cancelable: true,
                    view: window,
                }));
        }    
    }  

  var reportCodeArr = {};
  var matchIndexes = [];

  document.querySelectorAll('div').forEach(parentDiv => {
    const childDivs = Array.from(parentDiv.children).filter(el => el.tagName === 'DIV');

    const hasZIndex2000 = childDivs.some(div => {
      const zIndex = window.getComputedStyle(div).zIndex;
      return zIndex === '2000';
    });

    if (hasZIndex2000 && childDivs.length >= 2) {
      console.log('找到符合条件的父 div:', parentDiv);

      const secondChildDiv = childDivs[1]; 

      Array.from(secondChildDiv.children).forEach((grandchild, index) => {
        const firstInnerDiv = Array.from(grandchild.children).find(el => el.tagName === 'DIV');
        if (firstInnerDiv) {
          const text = firstInnerDiv.textContent.trim();
          if (text && reportCodeArr.includes(text)) {
            console.log("匹配项: ${text}，下标: ${index}");
            matchIndexes.push(index);
          }
        }
      });

      const checkboxes = Array.from(parentDiv.querySelectorAll('div')).filter(div => {
        const bg = window.getComputedStyle(div).backgroundImage;
        return bg.includes('903dd6ca.png') || bg.includes('3655dc8d.png');
      });

      console.log('所有符合条件的 checkbox 数组:', checkboxes);

      matchIndexes.forEach(index => {
        const targetCheckbox = checkboxes[index];
        if (targetCheckbox) {
          console.log("模拟点击 checkbox 下标: ${index}", targetCheckbox);
          simulateClick(targetCheckbox);
        }
      });
    }
  });        

})();
)'
    return Format(jsCode, reports)
}

/**
 * Checks if a process with the given PID exists.
 * @param pid The process ID to check
 * @returns {Boolean} True if the process exists, false otherwise
 */
isPidExist(pid) {
    if WinExist("ahk_pid " pid){
        return true
    } else {
        return false
    }
}

CloseAllUrlWindows() {
    global gUrlPidMap
    for url, pid in gUrlPidMap {
        if (isPidExist(pid)) {
            WinClose "ahk_pid " pid
        }
    }
    if WinExist("AI审批助手 ahk_exe msedge.exe")
        WinClose

    if WinExist("AI审批助手 ahk_exe chrome.exe")
        WinClose

    gUrlPidMap := Map()
}

/**
 * Opens a URL in a Chrome app window, preventing duplicate windows for the same URL.
 * 
 * @param url The URL to open in Chrome app mode
 * @returns The PID of the Chrome process, or 0 if failed
 * @note Maintains a global map of URL to PID to prevent duplicate windows
 */
OpenURLWindow(url) {

    ; 为了防止重复弹出窗口，定义一个MAP记录URL和弹出窗口的WEB_PID。在打开执行下面的弹出窗口之前，检查MAP中是否已经存在该URL，如果存在且WEB_PID还有效，则不弹出窗口，直接返回WEB_PID。
    global gUrlPidMap, gLastOpenUrl
    if !IsObject(gUrlPidMap)
        gUrlPidMap := Map()

    if gUrlPidMap.Has(url) {
        existing_pid := gUrlPidMap[url]
        ; 简单检查进程是否存在，实际可能需要更可靠的检测
        ProcessExistResult := isPidExist(existing_pid)
        if (ProcessExistResult != 0) {
            return existing_pid
        } else {
            gUrlPidMap.Delete(url)
        }
    }

    ; 关闭其他打开的窗口
    CloseAllUrlWindows()

    web_pid := 0
    cmd := "msedge.exe  --app=" url
    Run cmd, , , &web_pid

    if (web_pid > 0) {
        gUrlPidMap[url] := web_pid
        gLastOpenUrl := url
    }

    return web_pid
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
^F6:: {
    SendMessageToPython("Hello from AHK!")
}


; 按 F6 重新打开最近的URL
F6:: {
    if gLastOpenUrl and gUrlPidMap.Has(gLastOpenUrl) {
        urlPid := gUrlPidMap[gLastOpenUrl]
        if (urlPid > 0) {
            if (isPidExist(urlPid) ) {
                WinActivate "ahk_pid " urlPid
            } else {
                web_pid := OpenURLWindow(gLastOpenUrl)
                gUrlPidMap[gLastOpenUrl] := web_pid

                if (gUrlPosMap.Has(gLastOpenUrl)) {
                    winPos := gUrlPosMap[gLastOpenUrl]
                    if WinWaitActive("ahk_pid " web_pid, , 3) {
                        WinMove winPos[1], winPos[2], winPos[3], winPos[4], "ahk_pid " web_pid
                    }
                }
            }
        }
    } else {
        MsgBox "没有打开的URL"
    }
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
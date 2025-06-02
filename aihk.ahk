;; 创建开机自动启动的任务计划 AihkStartupTask
CreateTaskIfNotExists("AihkStartupTask", A_ScriptFullPath)

;; 1. 首先删除 aihk_run.ahk（后续重新创建）
if FileExist("aihk_run.ahk") {
    filedelete("aihk_run.ahk")
}

;; 2. 读取 aihk_main.ahk 内容，用于重新构建 aihk_run.ahk 文件
scriptContent := FileRead("aihk_main.ahk")


;; 3. 读取 /user 目录下所有的.ahk文件，补充到aihk_run.ahk
if DirExist("./user") {
    Loop Files, "./user/*", "D" ; "D" specifies that only directories are returned
    {
        Loop Files, A_LoopFileFullPath "/*.ahk", "R" ; "R" recursively searches subdirectories for .ahk files
        {
            if (!instr(A_LoopFileFullPath, ".ahk~")) 
            {
                scriptContent .= FileRead(A_LoopFileFullPath) "`n"
            }
        }
    }
}



scriptContent .=  "#Hotif"

fileappend(scriptContent, "aihk_run.ahk")

;; 4. 等待 aihk_run.ahk 文件生成，然后执行 aihk_run.ahk文件
loop 5
{
    sleep 500
    if FileExist("aihk_run.ahk") {
        Run "*RunAs aihk_run.ahk", , "Hide"
        exitapp
    }
}


;; 检查 taskName 任务是否已经存在
TaskExists(taskName) {
    output := ""
    RunWait("cmd.exe /c schtasks /Query /TN " taskName, , "Hide", &output)
    return InStr(output, taskName)
}

;; 如果 taskName 不存在，则创建任务计划
CreateTaskIfNotExists(taskName, scriptPath) {
    if TaskExists(taskName) {
        MsgBox "任务已存在: " taskName
        return    
    }

    cmd := Format(
        'cmd.exe /c schtasks /Create /TN "{}" /TR "{}" /SC ONSTART /RL HIGHEST /F /RU SYSTEM',
        taskName, scriptPath
    )
    Run('*RunAs ' cmd, , 'Hide')

    ;; 以下代码执行失败
    ; cmd := Format(
    ;     'schtasks /Create /TN "{}" /TR "{}" /SC ONSTART /RL HIGHEST /F /RU SYSTEM',
    ;     taskName, scriptPath
    ; )
    ; Run('*RunAs ' cmd)

    ; MsgBox "任务已创建: " taskName
}

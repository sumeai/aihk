;; 确保以管理员的身份启动程�?
change_icon("aihk.png")

; if not A_IsAdmin
; {
;     Run "*RunAs " A_ScriptFullPath, , "Hide"
;     ExitApp()
; }

g_root := ""
g_HotkeyList := []

#include ./src/alt_vim.ahk
#include ./src/switch_keyboard.ahk
#include ./src/capslock.ahk
#include ./src/360se.ahk

;; 以下快捷键在suspend状态下依然生效
#SuspendExempt true

;; 退�?
______("Pause & Esc", "退出AiHK")
Pause & Esc::
{
    ExitApp
}

;; 显示当前定义的Hotkey和HotString
______("Pause & ?", "显示所有的热键")
Pause & /::
{
    ShowHotkeyList("飞扬AI司令部所有热键：")
}

;; 挂起
______("+Pause", "Alt+Pause ==> Suspend挂起热键")
+Pause::
{
    if (A_IsSuspended) {
        Suspend false
    } else {
        Suspend true
    }
}

#Hotif NOT WinExist("飞扬魔法键盘 ahk_class AutoHotkeyGUI ahk_exe AutoHotkey64.exe")
______("*Appskey", "启动飞扬魔法键盘")
______("!CapsLock", "Alt+CapsLock ==> 启动飞扬魔法键盘")
______("Capslock & Space", "启动飞扬魔法键盘")
______("Pause & ScrollLock", "启动飞扬魔法键盘")
Pause & ScrollLock::
!CapsLock::
Capslock & Space::
appskey::
{
    filepath := A_scriptDir "\bin\飞扬魔法键盘\飞扬魔法键盘.ahk"
    ; var_temp := change_path_ext(filepath, "exe") 
    ; msgbox "path::" var_temp
    run filepath
    return
}

;; 显示当前定义的Hotkey和HotString
______("Capslock & ?", "显示AiHK所有的热键")
______("右Ctrl + 左Ctrl + ?", "显示AiHK所有的热键")
Capslock & /::
>^<^/::
{
    ShowHotkeyList("飞扬AiHK所有热键：")
}

; *~AppsKey up::Return


; #Hotif WinExist("飞扬魔法键盘 ahk_class AutoHotkeyGUI ahk_exe AutoHotkey64.exe")
; *AppsKey::Return
; *~AppsKey up::Return
; #Hotif

#SuspendExempt false


______("!Pause", "Alt+Pause ==> 重启启动AiHK")
______("::;reload;::", "输入;reload; ==> 重启启动AiHK")
::;reload;:: 
!Pause:: 
{
    talkshow("重启启动AiHK")
    reload
}

::;exitaihk;::
{
    talkshow("退出AiHK")
    ExitApp
}

______("#Pause", "Win+Pause ==> 使用AHK临时执行输入的内�?") 
#Pause:: 
{
    IB := InputBox("临时运行以下AHK脚本", "运行AHK脚本", "w600 h120", A_Clipboard)
    if IB.Result = "Cancel"
    {
        ToolTip "取消运行"
        SetTimer () => ToolTip(), -1000 
    }
    else
    {
        if FileExist("tempscript.ahk")
        {
            filedelete "tempscript.ahk"
            sleep 100
        }
        fileappend IB.value,"tempscript.ahk"
        sleep 100
        run "tempscript.ahk"
    }
}

;:*:ahkhelp2;::run 'https://www.autohotkey.com/docs/v2/index.htm'
______("::;ahkhelp::", "打开AutoHotkey帮助文档")
::;ahkhelp::
:*:ahkhelp;::
{
    run StrReplace(a_ahkpath, "64.exe", ".chm")
}

______("::;ahkspy::", "打开AutoHotkey Spy 查看窗口信息")
::;ahkspy::
:*:ahkspy;::
{
    SplitPath a_ahkpath, &name, &dir, &ext, &name_no_ext, &drive 
    run StrReplace(dir, "v2", "WindowSpy.ahk")
}

______("::;ahkroot::", "打开 AiHK 根文件夹")
::;ahkroot::
{
    run A_scriptDir
}

______("::;ahksrc::", "打开 AiHK/src 文件�?" )
::;ahksrc::
{
    run A_scriptDir . "/src"
}


#include ./src/win/gvim.ahk
#include ./src/win/feishu.ahk
#include ./src/win/vscode.ahk
#include ./include/path.aik
#Include  "./include/hotkey_manage.aik"

#Hotif
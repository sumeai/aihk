;; 确保以管理员的身份启动程序
change_icon("aihk.png")

; if not A_IsAdmin
; {
;     Run "*RunAs " A_ScriptFullPath, , "Hide"
;     ExitApp()
; }

g_root := ""
g_HotkeyList := []



;; 以下快捷键在suspend状态下依然生效
#SuspendExempt true

;; 退出
______("Pause & Esc", "退出AiHK")
Pause & Esc::
{
    ExitApp
}

;; 显示当前定义的Hotkey和HotString
______("Pause & /", "Pause + ? / win + ? ==> 【帮助】显示AiHk所有的热键")
#/::
Pause & /::
{
    ShowHotkeyList("飞扬AI司令部所有热键：")
}

;; 挂起
______("+Pause", "Alt+Pause / win + | ==> Suspend挂起暂停热键")

#\::
#+\::
+Pause::
{
    SwitchSuspend()
}


______("!Pause", "Alt+Pause ==> 重启启动AiHK")
______("#Pause", "Win+Pause ==> 使用AHK临时执行输入的内容") 

#Hotif NOT WinExist("飞扬魔法键盘 ahk_class AutoHotkeyGUI ahk_exe AutoHotkey64.exe")
______("Capslock & Space", "Capslock & Space / Appskey ==> 启动飞扬魔法键盘")
Capslock & Space::
appskey::
:?*:;jp;::
:?*:;aik;::
{
    filepath := A_scriptDir "\bin\飞扬魔法键盘\飞扬魔法键盘.ahk"
    ; var_temp := change_path_ext(filepath, "exe") 
    ; msgbox "path::" var_temp
    run filepath
    return
}

;; 显示当前定义的Hotkey和HotString
______("Capslock & /", "Capslock + ? / 右Ctrl + 左Ctrl + ? ==> 显示AiHK所有的热键")
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


______(";suspend;", "输入;suspend; / `;||`; / `;zt`; ==> 重启启动AiHK")
:*?:;suspend;:: 
:*?:;zt;:: 
:*?:;||;:: 
{
    SwitchSuspend()
}



______(";reload;", "输入;reload; / Alt+Pause ==> 重启启动AiHK")
:*?:;reload;:: 
!Pause:: 
{
    talkshow("重启启动AiHK", "AiHK")
    reload
}


:*?:;exitaihk;::
{
    talkshow("退出AiHK", "AiHK")
    ExitApp
}

______(";run;", "输入`;run; / Win+Pause ==> 使用AHK临时执行输入的内容") 
:?*:;run;::
:?*:;run ::
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

______(";jp;", "输入;jp; / `;aik; ==> 启动飞扬魔法键盘")

;:*:ahkhelp2;::run 'https://www.autohotkey.com/docs/v2/index.htm'
______(";ahkhelp;", "打开AutoHotkey帮助文档")
:?*:;ahkhelp;::
{
    run StrReplace(a_ahkpath, "64.exe", ".chm")
}

______(";ahkspy;", "打开AutoHotkey Spy 查看窗口信息")
:?*:;ahkspy;::
{
    SplitPath a_ahkpath, &name, &dir, &ext, &name_no_ext, &drive 
    run StrReplace(dir, "v2", "WindowSpy.ahk")
}

______(";ahkroot;", "打开 AiHK 根文件夹")
:?*:;ahkroot;::
{
    run A_scriptDir
}

______(";ahksrc;", "打开 AiHK/src 文件夹" )
:?*:;ahksrc;::
{
    run A_scriptDir . "/src"
}

#include ./src/alt_vim.ahk
#include ./src/switch_keyboard.ahk
#include ./src/capslock.ahk
#include ./src/360se.ahk

#include ./src/win/gvim.ahk
#include ./src/win/feishu.ahk
#include ./src/win/vscode.ahk
#include ./inc/path.aik
#Include  "./inc/hotkey_manage.aik"

SwitchSuspend()
{
    if (A_IsSuspended) {
        Suspend false
    } else {
        Suspend true
    }
}

;; 确保以管理员的身份启动程序

/*
if not A_IsAdmin
{
    Run("*RunAs " A_ScriptFullPath)
    ExitApp()
}
*/

#include ./src/alt_vim.ahk
#include ./src/switch_keyboard.ahk
#include ./src/capslock.ahk
#include ./src/360se.ahk


!Pause:: reload
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
:*:ahkhelp;::
{
    run StrReplace(a_ahkpath, "64.exe", ".chm")
}

:*:ahkspy;::
{
    SplitPath a_ahkpath, &name, &dir, &ext, &name_no_ext, &drive 
    run StrReplace(dir, "v2", "WindowSpy.ahk")
}

::;ahkroot::
{
    run A_scriptDir
}

::;ahksrc::
{
    run A_scriptDir . "/src"
}


#include ./src/win/gvim.ahk
#include ./src/win/feishu.ahk
#include ./src/win/vscode.ahk

#Hotif Winactive("Log In to e.coding.net ahk_class SunAwtDialog")

::;x::
{
    send "{Raw}i@xiaersi.com"
    send "{tab}"
    send "{Raw}KR2024@ssjc`""
    return 
}



::;k::
{
    send "{Raw}chenjianping@krstation.com"
    send "{tab}"
    send "{Raw}KR2024@ssjc"
    return 
}


::;s::
{
    send "{Raw}sume.ai@hotmail.com"
    send "{tab}"
    send "{Raw}cjp333000@GH"
    return 
}



#HotIf 


#Hotif
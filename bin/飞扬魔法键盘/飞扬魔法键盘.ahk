/**
 *@file    飞扬魔法键盘.ahk
 *@author  teshorse
 *@date    2025.4.17
 *@brief   飞扬魔法键盘的实现
 *
 * 飞扬魔法键盘是一个能够快速更改键盘各按键的功能的工具
 *
 * 更新日志:
 * - V1.10
 * - 新增功能: RShift键切换键盘大小写状态。
 * - 修正一个Bug，对于[,],\,/,'这些特殊键，没有成功映射到相应的按钮名称，而导致的错误。
 *
 * - V1.00
 * - 实现飞扬魔法键盘的基本功能
 */



g_version := "V2.00"
g_bRightMenu := ""
g_root := ""

g_ImagesDir := A_ScriptDir "\images"
g_HotkeyList := []

#SingleInstance force


#Include "../../"

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; 准备全局变量

;; 键盘名称：参数: 显示或隐藏|键盘名称
;; 例如: 1|默认键盘
g_keyBoard := A_Args.Length > 0 ? A_Args[1] : ""

; msgbox "g_keyBoard = " g_keyBoard


; Changing this font size will make the entire on-screen keyboard get
; larger or smaller:
k_FontSize := 10
k_FontName := "Verdana"
k_FontStyle := "Bold"

; To have the keyboard appear on a monitor other than the primary, specify
; a number such as 2 for the following variable. Leave it blank to use
; the primary:
g_Monitor := ""

g_bAutoPressBtn := true
g_bMoveWindow := false
g_bShiftDown := false
 
; 当前使用的键盘，如果工作上下没有KeyBoard.ini配置文件，
; 则从飞扬魔法键盘程序目录下的KeyBoard.ini复制过去
g_inifile := "KeyBoard.ini"
if !FileExist(g_inifile)
{
    if FileExist(A_ScriptDir "\" g_inifile)
    {
        FileCopy A_ScriptDir "\" g_inifile, g_inifile
    }
}

g_iniContent := IniFileRead(g_inifile)

if not g_keyBoard {
    g_keyBoard := IniRead("temp.ini", "飞扬魔法键盘", "最近键盘", "默认键盘")
}

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; 准备图片资源

FileInstall "KeyBoard.ini", A_ScriptDir "\KeyBoard.ini"

FileInstall ".\images\橙色.ico", g_ImagesDir "\橙色.ico"
FileInstall ".\images\丁香紫.ico", g_ImagesDir "\丁香紫.ico"
FileInstall ".\images\红色.ico", g_ImagesDir "\红色.ico"
FileInstall ".\images\黄色.ico", g_ImagesDir "\黄色.ico"
FileInstall ".\images\蓝色.ico", g_ImagesDir "\蓝色.ico"
FileInstall ".\images\绿色.ico", g_ImagesDir "\绿色.ico"
FileInstall ".\images\玫瑰红.ico", g_ImagesDir "\玫瑰红.ico"
FileInstall ".\images\青色.ico", g_ImagesDir "\青色.ico"
FileInstall ".\images\设置.ico", g_ImagesDir "\设置.ico"
FileInstall ".\images\天蓝.ico", g_ImagesDir "\天蓝.ico"
FileInstall ".\images\银色.ico", g_ImagesDir "\银色.ico"
FileInstall ".\images\紫色.ico", g_ImagesDir "\紫色.ico"

FileInstall ".\images\橙色.png", g_ImagesDir "\橙色.png"
FileInstall ".\images\丁香紫.png", g_ImagesDir "\丁香紫.png"
FileInstall ".\images\红色.png", g_ImagesDir "\红色.png"
FileInstall ".\images\黄色.png", g_ImagesDir "\黄色.png"
FileInstall ".\images\蓝色.png", g_ImagesDir "\蓝色.png"
FileInstall ".\images\绿色.png", g_ImagesDir "\绿色.png"
FileInstall ".\images\玫瑰红.png", g_ImagesDir "\玫瑰红.png"
FileInstall ".\images\青色.png", g_ImagesDir "\青色.png"
FileInstall ".\images\设置.png", g_ImagesDir "\设置.png"
FileInstall ".\images\天蓝.png", g_ImagesDir "\天蓝.png"
FileInstall ".\images\银色.png", g_ImagesDir "\银色.png"
FileInstall ".\images\紫色.png", g_ImagesDir "\紫色.png"

;; 更换图标（根据键盘名称）
change_icon()

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; 创建窗口界面（"飞扬魔法键盘 ahk_class AutoHotkeyGUI ahk_exe AutoHotkey64.exe"）

#include "./bin/飞扬魔法键盘/GuiCreate.aik"
 
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; 设置快捷键
#Include "./bin/飞扬魔法键盘/HotkeyHandle.aik"

return
 
 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
 ;; 以下为响应函数
 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

#Include "./bin/飞扬魔法键盘/ButtonHandle.aik"


 GuiClose(*) {
     保存当前窗口位置()
     ExitApp()
 }
 
 退出菜单项(*) {
     保存当前窗口位置()
     ExitApp()
 }
 
 退出(*) {
    if WinExist("ahk_id " k_ID) {
        保存当前窗口位置()
    }
    ExitApp()
 }
 
 保存当前窗口位置() {
     global k_ID, g_keyBoard_name
     WinGetPos &OutX, &OutY, &OutWidth, &OutHeight, "ahk_id " k_ID
     WriteTempIni("飞扬魔法键盘", g_keyBoard_name "_winx", OutX)
     WriteTempIni("飞扬魔法键盘", g_keyBoard_name "_winy", OutY)
 }
 

 
 
 按键响应(ThisHotkey) {
     global g_bAutoPressBtn, k_ID, g_keyBoard_name
     if WinActive("ahk_id " k_ID)
         return
     if g_bAutoPressBtn
     {
         g_ThisHotkey := StrReplace(ThisHotkey, "~")
         g_ThisHotkey := StrReplace(g_ThisHotkey, "*")
         var_keyName := ""
         caption := ∑获得按键按钮的标题(g_keyBoard_name, g_ThisHotkey, &var_keyName)

        ;  global _key_%var_keyName%
         g_ThisKeyName := GetButtonTextByKeyName(var_keyName)
         if g_ThisKeyName = ""
             g_ThisKeyName := g_ThisHotkey
         SetTitleMatchMode 3
         ControlClick g_ThisKeyName, "ahk_id " k_ID, "", "LEFT", 1, "D"
         ∑执行键盘按键响应(var_keyName)
     }
 }
                             
 模拟点击按钮(*) {
     global g_bAutoPressBtn, k_ID, _key
     if WinActive("ahk_id " k_ID) || WinActive("新增键盘")
         return
     if g_bAutoPressBtn
     {


         g_ThisHotkey := StrReplace(A_ThisHotkey, "~")
         g_ThisHotkey := StrReplace(g_ThisHotkey, "*")

         if (StrLower(g_ThisHotkey) == "lwin"){
            g_ThisHotkey := "Win"
         } else if (StrLower(g_ThisHotkey) == "lshift") {
            g_ThisHotkey := "Shift"
         }

         ctrl := GetButtonCtrlByKeyName(g_ThisHotkey)
         if ctrl {
            AnimateClick(ctrl)
         }

        ;  g_ThisKeyName := _key[StrLower(g_ThisHotkey)].Text
        ;  if g_ThisKeyName = ""
        ;      g_ThisKeyName := g_ThisHotkey
        ;  SetTitleMatchMode 3
        ;  ControlClick g_ThisKeyName, "ahk_id " k_ID, "", "LEFT", 1, "D"
        ;  KeyWait g_ThisHotkey
        ;  ControlClick g_ThisKeyName, "ahk_id " k_ID, "", "LEFT", 1, "U"
     }
 }



 ;; 模拟点击按钮的动画
 AnimateClick(ctrl) {
    hCtrl := ctrl.Hwnd
    WM_LBUTTONDOWN := 0x201
    WM_LBUTTONUP   := 0x202

    ; 模拟按下
    PostMessage(WM_LBUTTONDOWN, 0, 0, , hCtrl)
    Sleep(100)  ; 按下时间，单位毫秒
    ; 模拟弹起
    PostMessage(WM_LBUTTONUP, 0, 0, , hCtrl)
}
 
 响应按键释放(ThisHotkey) {
     global k_ID, g_keyBoard_name, _key
     g_ThisHotkey := StrReplace(A_ThisHotkey, "~")
     g_ThisHotkey := StrReplace(g_ThisHotkey, "*")
     g_ThisHotkey := StrReplace(g_ThisHotkey, A_Space "Up")
     var_keyName := ""
     caption := ∑获得按键按钮的标题(g_keyBoard_name, g_ThisHotkey, &var_keyName)

     g_ThisKeyName := GetButtonTextByKeyName(var_keyName)
     if g_ThisKeyName = ""
         g_ThisKeyName := g_ThisHotkey
     SetTitleMatchMode 3
     ControlClick g_ThisKeyName, "ahk_id " k_ID, "", "LEFT", 1, "U"
 }

 ;; 根据按钮变量名，返回按钮显示的文本（例如：keyName="FXG" ==> "\"）
 GetButtonTextByKeyName(keyName){
    global _key
    if _key.Has(StrLower(keyName)) {
        return _key[StrLower(keyName)].Text
    }
    return ""
 }
 

AppsKeyHandle(*){
    显示或隐藏屏幕键盘()
}


 重新加载(*) {
     Reload()
 }
 



 
 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
 
 新增键盘(*) {
     global g_inifile, g_iniContent
     var_keyboard := myinput("新增键盘", "请输入要新建的键盘名称：")
     if var_keyboard != ""
     {
         if RegExMatch(var_keyboard, "[\[\]]")
         {
             MsgBox "键盘名称中不能包含 “[”和 “]”！"
             return
         }
         var_colorList := "橙色|丁香紫|红色|黄色|蓝色|绿色|玫瑰红|青色|设置|天蓝|银色|紫色"
         var_keycolor := InputListBox(var_colorList, "请选择键盘颜色")
         if var_keycolor != ""
         {
             write_ini(g_inifile, var_keyboard, "Color", var_keycolor)
             g_iniContent := IniFileRead(g_inifile)
             ∑切换键盘(var_keyboard)
         }
     }
 }
 
 选择键盘(ItemName, *) {
     global g_bAutoPressBtn
     g_bAutoPressBtn := false
     var_menuitem := ItemName
     if RegExMatch(ItemName, "i)\&\d+\s+", &var_match)
     {
         var_menuitem := SubStr(ItemName, StrLen(var_match[0]) + 1)
         WriteTempIni("飞扬魔法键盘", "最近键盘", var_menuitem)
     }
     Reload()
     g_bAutoPressBtn := true
 }

 


 
 用飞扬小字典编辑键盘(*) {
     var_root := ∑获取根目录()
     var_file := var_root "\bin\dict\dict.ahk"
     var_param := "file:keyboard.ini`ntitle:编辑飞扬魔法键盘`ncursec:" g_keyboard
     run_ahk(var_file, var_param, A_WorkingDir)
 }
 
 响应按键对应的热键(*) {
     return
 }
 

 
 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
 ∑鼠标单击按键(key_, bForce := false) {

     global g_keyBoard, _key, k_ID, g_bAutoPressBtn, g_bShiftDown
     if !bForce
     {
         MouseGetPos &OutputVarX, &OutputVarY, &OutputVarWin, &OutputVarControl, 1
         if k_ID != OutputVarWin
            ; MsgBox("k_ID = " k_ID )
         
            return
     }


     var_key := key_.Text


     var_ctrlkey := ∑检查按下的控制键()
     if var_ctrlkey != ""
         var_key := var_ctrlkey var_key


     if g_bShiftDown
     {
         if InStr(var_ctrlkey, "+")
             var_key := StrReplace(var_key, "+", "")
         else
             var_key := "+" var_key
     }
     if _key["setting"].Value
     {
         if g_bAutoPressBtn
             ∑编辑按键(var_key)
     }
     else 
     {
        ∑执行按键(var_key)
     }

     return true
 }
 
 ∑编辑按键(key_) {
     global g_bAutoPressBtn, g_inicontent, g_inifile
     if key_ = "" || ∑获取当前键盘名称() = "默认键盘"
         return
     g_bAutoPressBtn := false
     var_value := FindFromIniMem(g_inicontent, ∑获取当前键盘名称(), key_, "")
     var_temp := key_ " ="
     cmdstr := ∑编辑飞扬命令串(var_value, var_temp)
     if cmdstr != ""
     {
         if cmdstr = "$space$"
             cmdstr := ""
         var_value := cmdstr
         write_ini(g_inifile, ∑获取当前键盘名称(), key_, var_value)
         g_iniContent := IniFileRead(g_inifile)
         if InStr(cmdstr, ")")
         {
             cmdStringSplit(cmdstr, &var_opt)
             if RegExMatch(var_opt, "i)(?<=name:).*?(?=$|\)|\|)", &var_match) && var_match != ""
                 _key[StrLower(key_)].Text := var_match
         }
     }
     g_bAutoPressBtn := true
 }
 
 ∑执行按键(key_) {
     var_keyboard := ∑获取当前键盘名称()

    ;  msgbox("key_ = " key_ ", var_keyboard = " var_keyboard)

     cmdstr := var_keyboard != "默认键盘" ? FindFromIniMem(g_iniContent, var_keyboard, key_, "") : ""
     if cmdstr = ""
         cmdstr := "1|send)" ValnameToKeyname(key_)
     RunKeyboardCmdstr(cmdstr)
     TipCmdString(cmdstr)
 }



 ∑执行键盘按键响应(Hotkey_) {

    ; msgbox("Hotkey_ = " Hotkey_ )


     global g_iniContent, g_bShiftDown
     Hotkey_ := StrReplace(Hotkey_, "~")
     Hotkey_ := StrReplace(Hotkey_, "*")
     if Hotkey_ = ""
         return
     var_keyboard := ∑获取当前键盘名称()
     var_ctrlkey := ∑检查按下的控制键()
     if var_ctrlkey != ""
         Hotkey_ := var_ctrlkey Hotkey_
     if g_bShiftDown
     {
         if InStr(var_ctrlkey, "+")
             Hotkey_ := StrReplace(Hotkey_, "+", "")
         else
             Hotkey_ := "+" Hotkey_
     }
     cmdstr := FindFromIniMem(g_iniContent, var_keyboard, Hotkey_, "")
     if cmdstr = ""
     {
         if Hotkey_ ~= "[\^\+!#]"
             SendPlay Hotkey_
         else
         {
             keyname := StrReplace(Hotkey_, "~")
             keyname := StrReplace(keyname, "*")

             if keyname != "Space"
                 cmdstr := "1|send)" StrLower( ValnameToKeyname(keyname) )
         }
     }
     if cmdstr != ""
     {
         TipCmdString(cmdstr)
         RunKeyboardCmdstr(cmdstr)
     }
 }
  

 RunKeyboardCmdstr(cmdstr_) {
     cmdStringSplit(cmdstr_, &var_opt)
     if FindCmdOpt(var_opt, "BeforePress:", &var_value)
         KeyboardCommand(var_value)
     run_cmd(cmdstr_)
     if FindCmdOpt(var_opt, "AfterPress:", &var_value)
         KeyboardCommand(var_value)
 }
 

 KeyboardCommand(cmd_) {
     if cmd_ ~= "^(Exit|Quit|退出)$"
         退出()
     else if cmd_ ~= "^(Set|Setting|Seting|设置)$"
         勾选SettingCheckBox()
     else if cmd_ ~= "^(Hide|隐藏)$"
         显示或隐藏屏幕键盘()
 }
 
 ValnameToKeyname(valname_) {
     if RegExMatch(valname_, "i)(?<=_key_).*$", &var_key)
         valname_ := var_key
     switch valname_ {
         case "bk": return "{BackSpace}"
         case "sub": return "-"
         case "equal": return "="
         case "lf": return "["
         case "rf": return "]"
         case "fxg": return "\"
         case "mh": return ";"
         case "dyh": return "'"
         case "dh": return ","
         case "jh": return "."
         case "xg": return "/"
         case "enter": return "{Enter}"
         case "tab": return "{Tab}"
         case "space": return "{Space}"
         default: return valname_
     }
 }

  KeynameToValname(keyName_) {
     switch keyName_ {
         case "BackSpace": return "bk"
         case "-": return "sub"
         case "=": return "equal"
         case "[": return "lf"
         case "]": return "rf"
         case "\": return "fxg"
         case ";": return "mh"
         case "'": return "dyh"
         case ",": return "dh"
         case ".": return "jh"
         case "/": return "xg"
         case "Enter": return "enter"
         case "Tab": return "tab"
         case "Space": return "space"
         default: return keyName_
     }
 }
 
;; 通过热键名称得到对应按钮的按钮对象，例如： GetButtonCtrlByKeyName("/") == _key["xg"]
 GetButtonCtrlByKeyName(keyName_){
    global _keyNameArray
    
    valueName := KeynameToValname(keyName_)

    ; msgbox ("GetButtonCtrlByKeyName (keyName_ = " keyName_  ") ==>  valueName: " StrLower(valueName))

    if _key.Has(StrLower(valueName)){
        return _key[StrLower(valueName)]
    }
    

    ; if _keyNameArray.has(StrLower(valueName)){
    ;     return _key[StrLower(valueName)]
    ; } else {
    ;     msgbox ("GetButtonCtrlByKeyName (keyName_ = " keyName_  ") ==>  找不到对应按钮 " StrLower(valueName) )
    ; }
 }


 ∑获取当前键盘名称() {
     global g_keyboard
     return g_keyboard = "" ? "默认键盘" : g_keyboard
 }
 
 ∑获取当前键盘颜色() {
     global g_inicontent, g_keyboard
     var_color := FindFromIniMem(g_inicontent, g_keyboard, "Color")
     return var_color = "" ? "银色" : var_color
 }
 
 GetKeyboardColor() {
     global g_inicontent, g_keyboard
     var_color := FindFromIniMem(g_inicontent, g_keyboard, "Color")
     switch var_color {
         case "橙色": return "FF8000"
         case "丁香紫": return "DA70D6"
         case "红色": return "Red"
         case "黄色": return "FFD700"
         case "蓝色": return "Blue"
         case "绿色": return "00FF00"
         case "玫瑰红": return "B03060"
         case "青色": return "03A89E"
         case "天蓝": return "87CEEB"
         case "银色": return "Gray"
         case "紫色": return "6A5ACD"
         default: return ""
     }
 }
 
 ∑获取当前键盘图标() {
     global g_inicontent, g_keyboard
     var_color := FindFromIniMem(g_inicontent, g_keyboard, "Color", "银色")
     return A_ScriptDir "\" var_color ".ico"
 }
 
 ∑获得按键按钮的标题(keyBoard_, keyChar_, &keyname_) {
     global g_bShiftDown, g_iniContent
     switch keyChar_ {
         case "-": keyName := "Sub"
         case "=": keyName := "equal"
         case "[": keyName := "lf"
         case "]": keyName := "rf"
         case "\": keyName := "fxg"
         case ";": keyName := "mh"
         case "'": keyName := "dyh"
         case ",": keyName := "dh"
         case ".": keyName := "jh"
         case "/": keyName := "xg"
         default: keyName := keyChar_
     }
     caption_ := keyChar_
     if keyBoard_ != "默认键盘"
     {
         var_temp := g_bShiftDown ? FindFromIniMem(g_iniContent, keyBoard_, "+" keyName, "") : ""
         if var_temp = "" || !InStr(var_temp, "name:")
             var_temp := FindFromIniMem(g_iniContent, keyBoard_, keyName, "")
         if InStr(var_temp, ")")
         {
             cmdStringSplit(var_temp, &var_opt)
             if RegExMatch(var_opt, "i)(?<=name:).*?(?=$|\)|\|)", &var_match) && var_match != ""
                 caption_ := var_match
         }
     }
     keyname_ := keyName
     return caption_
 }
 
 ∑修改按键按钮的标题(keyBoard_, keyChar_, caption_ := "") {
     var_caption := ∑获得按键按钮的标题(keyBoard_, keyChar_, &keyName)
     if caption_ = ""
         caption_ := var_caption

    if myGui.HasProp("_key_" . keyName)
        myGui["_key_" . keyName].Text := caption_
 }
 
 刷新界面按钮显示(var_keyboard) {
     k_ASCII := 45
     while k_ASCII <= 93
     {
         k_char := Chr(k_ASCII)
         k_char := StrUpper(k_char)
         if k_char ~= "^[^<^>^^^~^?^`]$"
             ∑修改按键按钮的标题(var_keyboard, k_char)
         k_ASCII++
     }
     for char in [",", "Bs", "Tab", "Enter", "Space", "'"]
         ∑修改按键按钮的标题(var_keyboard, char)
 }
 
∑切换键盘(keyboard_) {
    global g_keyboard, g_inicontent
    if keyboard_ = ""
        keyboard_ := "默认键盘"

    if g_keyboard = keyboard_ {
        弹出右键菜单()
        return false
    }

     var_temp := AllSecFromIniMem(g_inicontent)
     if keyboard_ = "默认键盘" || InStr(var_temp, "|" keyboard_ "|")
     {
        ;  保存当前窗口位置()
        var_root := ∑获取根目录()
        ; MsgBox "var_root = " var_root ",  keyboard_ = " keyboard_
         var_file := var_root "\bin\飞扬魔法键盘\飞扬魔法键盘.ahk"
         run_ahk(var_file, keyboard_)
         return true
     } else {
        WriteTempIni("飞扬魔法键盘", "最近键盘", keyboard_)
        Reload()
     }
     return false
 }
 
 
∑空格按钮提示(var_tip) {
    global _key
    _key["space"].Text := var_tip
    SetTimer 定时清除空格按钮提示, -1000
    }
       

;; 从cmdstr_提取提示信息
GetCmdStringTip(cmdstr_, active_ := false) {
     cmd_text := cmdStringSplit(cmdstr_, &var_opt)

     ;; 检查命令是否生效
     if (active_) {
        ;; 如果cmdstr_第1个数字>=1，则表示生效
        if RegExMatch(cmdstr_, "^\d+") < 1 {
            return ""
        }
     }

    ;; 命令类型关键词
    cmd_key := ""
    loop parse var_opt, "|", " *`t`n" 
    {
        ;; 检查命令是否生效
        if A_Index = 1 and IsInteger(A_LoopField) {
            if active_ and A_LoopField <=0
                return ""
        }

        opt_key := ""
        opt_value := ""

        if StrSplit2Sub(A_LoopField, ":", &opt_key, &opt_value) {
            if opt_key = "tip"
            {
                return opt_value
            }
        } else {
            ;; 不是开头的数字，也不是带有:的属性，那么就是命令类型
            ;; 如果有多个命令类型， 用空格连接起来
            msgbox "cmd_key = " cmd_key
            cmd_key := ConcatString(cmd_key, opt_key, " ")
        }
    }

    ;; 没有找到tip属性，那么构造一个提示信息
    var_tip := cmd_key != "" ? "【" cmd_key "】" : ""
    return var_tip cmd_text
}   


 ;; 将cmdstr_的选项缩短后显示
TipCmdString(cmdstr_) {
     var_tip := GetCmdStringTip(cmdstr_)
     ∑空格按钮提示(var_tip)
 }
 
∑检查按下的控制键() {
     keys := ""
     if GetKeyState("Ctrl", "P")
         keys .= "^"
     if GetKeyState("Alt", "P")
         keys .= "!"
     if GetKeyState("Shift", "P")
         keys .= "+"
     return keys
 }
 
定时清除空格按钮提示(*) {
     ∑修改按键按钮的标题(∑获取当前键盘名称(), "Space")
 }
 
切换到默认键盘(*) {
     if ∑获取当前键盘名称() != "默认键盘" {
         ∑切换键盘("默认键盘")
    }
 }
 
切换到最近键盘(*) {
     if ∑获取当前键盘名称() = "默认键盘"
     {
         var_temp := ReadTempIni("飞扬魔法键盘", "最近键盘")
        ;  MsgBox var_temp
         if var_temp != ""
             ∑切换键盘(var_temp)
     } else {
        ∑切换键盘("默认键盘")
     }
 }
 
移动窗口(*) {
     global g_bMoveWindow, g_mouse_x0, g_mouse_y0, g_win_x0, g_win_y0, k_ID, _key
     g_bMoveWindow := !g_bMoveWindow
     if g_bMoveWindow
     {
         CoordMode "Mouse", "Screen"
         MouseGetPos &g_mouse_x0, &g_mouse_y0

         WinGetPos &g_win_x0, &g_win_y0, &OutWidth, &OutHeight, "ahk_id " k_ID

         SetTimer 定时器飞扬魔法键盘窗口跟随鼠标移动, 100
         var_tip := "◇移动鼠标调整键盘窗口位置`n◇按下鼠标左键停止移动窗口`n◇空格键恢复窗口到默认位置"
         TrayTip "移动飞扬魔法键盘窗口", var_tip
         _key["space"].Text := "窗口跟随鼠标移动"
         Hotkey "LButton", 停止移动窗口, "On"
         Hotkey "Space", 移动窗口到默认位置, "On"
     }
     else
         停止移动窗口()
 }

 
停止移动窗口(*) {
     global g_bMoveWindow
     TrayTip()
     g_bMoveWindow := false
     SetTimer 定时器飞扬魔法键盘窗口跟随鼠标移动, 0
     ∑修改按键按钮的标题(∑获取当前键盘名称(), "Space")
     Hotkey "LButton", 停止移动窗口, "Off"
     Hotkey "Space", 移动窗口到默认位置,  "Off"
 }
 
移动窗口到默认位置(*) {
     global k_ID, k_WorkAreaRight, k_WorkAreaLeft, k_WindowWidth, k_WorkAreaBottom, k_WindowHeight
     停止移动窗口()
     k_WindowX := k_WorkAreaRight - k_WorkAreaLeft - k_WindowWidth
     k_WindowX := k_WindowX / 2 + k_WorkAreaLeft
     k_WindowY := k_WorkAreaBottom - k_WindowHeight
     WinMove k_WindowX, k_WindowY, , , "ahk_id " k_ID
 }
 
定时器飞扬魔法键盘窗口跟随鼠标移动(*) {
     global g_bMoveWindow, k_ID, g_mouse_x0, g_mouse_y0, g_win_x0, g_win_y0
     if !g_bMoveWindow || GetKeyState("LButton", "P")
     {
         停止移动窗口()
         return
     }
     if GetKeyState("Ctrl", "P")
     {
         停止移动窗口()
         移动窗口到默认位置()
         return
     }
     CoordMode "Mouse", "Screen"
     MouseGetPos &g_mouse_x, &g_mouse_y
     WinMove g_win_x0 + g_mouse_x - g_mouse_x0, g_win_y0 + g_mouse_y - g_mouse_y0, , , "ahk_id " k_ID
 }


设置所有按钮透明度(*) {
    global _key
    ; 设置所有按钮透明度为 30%
    for key, btn in _key {
        btnHwnd := btn.Hwnd
        WinSetTransparent(76, "ahk_id " btnHwnd)
    }
 }
 
ChangePicture(ctrl, newImagePath) {
    hBitmap := LoadPicture(newImagePath, "GDI+")
    if !hBitmap {
        MsgBox "加载图片失败"
        return
    }
    SendMessage(0x172, 0, hBitmap,, ctrl.Hwnd) ; STM_SETIMAGE
}


切换窗口为键盘模态(*){
    global _key
    ; 设置所有按钮透明度为 30%
    for key, btn in _key {
        btn.Visible  := true
    }

    _GroupBox.Visible := true
 }

切换窗口为语音模态(*){
    global _key, g_keyBoard_setpic, _key_sidepic
    ; 设置所有按钮透明度为 30%
    for key, btn in _key {
        if (key != "ico") {
            btn.Visible  := false
        }
    }

    ; _key_sidepic.Move(9999, 9999)
    _key_sidepic.Visible := false

    ;; _key_sidepic.Hide()
    ; DllCall("ShowWindow", "Ptr", _key_sidepic.Hwnd, "Int", 0) ; 0 = SW_HIDE
    ; ChangePicture(_key_sidepic, g_keyBoard_setpic)

    _GroupBox.Visible := false
 }

切换窗口为输入模态(*){

 }

切换窗口为隐身模态(*){
    显示或隐藏屏幕键盘()
 }

 

 #Include "./include/common.aik"
 #Include "./include/inifile.aik"
 ; #Include "./include/tip.aik"
 #Include "./include/string.aik"
 #Include "./include/cmdstring.aik"
 #Include  "./include/hotkey_manage.aik"
 ; #Include "./include/run.aik"
 ; #Include "./lib/autolable.aik"
 #Include "./subui/23编辑飞扬命令串.aik"
 #Include "./subui/22InputListBox.aik"
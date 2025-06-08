#include ../include/system_cursor.ahk
#include ../include/switch_keyboad.ahk
#Include ../include/hotkey_manage.aik
#Include ../include/tip.aik

;; 切换英文输入法
______("::;e::", "输入;e ==> 切换英文输入法")
______("::;e::", "输入;en ==> 切换英文输入法")
______(":?*:en;::", "输入en; ==> 切换英文输入法")
::;e::
::;en::
:?*:en;::
{
    SetCapsLockState "Off"
    ToolTip "English"
    en_input()
    Sleep 1000
    ToolTip ""
    return
}
:?*:en``;::en`;  ;; en;已经定义为切换中文输入法，要输入en;字符串请用热词en`;



;; 切换中文输入法
______("::;c::", "输入;c ==> 切换中文输入法")
______("::;cn::", "输入;cn ==> 切换中文输入法")
______(":?*:cn;::", "输入cn; ==> 切换中文输入法")
::;c::
::;cn::
:?*:cn;::
{
    ;; 先切换为英文
    en_input()
    
    ;; 再切换为中文
    ToolTip "中文"
    cn_input()
    Sleep 1000
    ToolTip ""
    return
}
:?*:cn``;::cn`;  ;; cn;已经定义为切换中文输入法，要输入cn;字符串请用热词cn`;

;; 打开CapsLock
______("::;l::", "输入;l ==> 切换中文输入法")
::;l::
{
    ; ToolTip "CapsLock 开启"
    ; SetCapsLockState "On"
    ; Sleep 1000
    ; ToolTip ""
    ; return


    ;; 切换CapsLock状态
    isOn := GetKeyState("CapsLock", "T") 


    if isOn
    {
        SetCapsLockState "Off"
        talkshow("【小写】CapsLock:OFF")
    }
    else
    {
        SetCapsLockState "On" 
        talkshow("【大写】CapsLock:ON")
    }

}
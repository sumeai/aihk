#include ../inc/system_cursor.ahk
#include ../inc/switch_keyboad.ahk
#Include ../inc/hotkey_manage.aik
#Include ../inc/tip.aik

;; 切换英文输入法
______(";en", "输入`;en / `;e`; ==> 切换英文输入法")
:*?:;e;::
:*?:;e ::
:*?:;en::
:*:en;::
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
______(";cn", "输入`;cn / `;c`; ==> 切换中文输入法")
:*?:;c;::
:*?:;c ::
:*?:;cn::
:*:cn;::
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
______(";cl", "输入`;cl / `;l; ==> 切换CapsLock状态")
:*?:;l;::
:*?:;cl::
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
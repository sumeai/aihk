﻿#include ../include/switch_keyboad.ahk

; 定义全局变量
global isCapsLockDown := false
global capsLockDownTime := 0
global doubleClickCapsTimeout := 300 ; 双击的时间阈值（毫秒）
global longPressCapsThreshold := 1100 ; 长按的时间阈值（毫秒）
global lastCapsLockPressTime := 0
global isSingleClickCaps := false

; Caps Lock 按下事件
CapsLock::
{
    global isCapsLockDown
    global capsLockDownTime
    global doubleClickCapsTimeout
    global longPressCapsThreshold
    global lastCapsLockPressTime
    global isSingleClickCaps
        
    if (isCapsLockDown)
    {
        ; 忽略重复按键
        return
    }
    isCapsLockDown := true
    capsLockDownTime := A_TickCount

    ; 检查是否双击，双击切换中文输入法
    if (A_TickCount - lastCapsLockPressTime < doubleClickCapsTimeout)
    {
        ; 先切换到英文输出法，再切换到中文输入法
        en_input()
        isSingleClickCaps := false
        sleep 100
        cn_input()
    }
    else
    {
        isSingleClickCaps := true
    }
    lastCapsLockPressTime := A_TickCount
;    tooltip("isSingleClickCaps = " . isSingleClickCaps)
    return
}

; 检查单击计时器
CheckSingleClickCapslock()
{
    ;tooltip(">> " . isSingleClickCaps)
    global isSingleClickCaps 
    if (isSingleClickCaps)
    {
        en_input()
    }
    return
}



; Caps Lock 释放事件
CapsLock Up::
{   
    global isCapsLockDown
    global capsLockDownTime
    global doubleClickCapsTimeout
    global longPressCapsThreshold
    global lastCapsLockPressTime
    global isSingleClickCaps
    
    if (!isCapsLockDown)
    {
        return
    }
    isCapsLockDown := false
    pressDuration := A_TickCount - capsLockDownTime

    ; 长按保持CapsLock原来的功能，也就是切换大小写
    if (pressDuration > longPressCapsThreshold)
    {
        isSingleClickCaps := false

        ; 检查并切换 Caps Lock 状态
        if GetKeyState("CapsLock", "T") {
            SetCapsLockState "Off"
        } else {
            SetCapsLockState "On"
        }
    }
    else if (isSingleClickCaps)
    {
        ; 单击
        SetTimer(CheckSingleClickCapslock, -doubleClickCapsTimeout)
    }
    return
}

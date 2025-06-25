
;; 切换英文输入法，同时将CapsLock设置为小写状态
en_input()
{
    global IDC_IBEAM
    SetCapsLockState "Off"
    PostMessage 0x50, 0, 0x4090409,, "A" 
    return 
}



;; 切换中文输入法
cn_input()
{
    global IDC_NO
    ; 先关闭CapsLock，因为关闭了大写才能输入中文
    SetCapsLockState "Off"
    
    ; 发送切换中文输入法的指令
    PostMessage 0x50, 0, 0x0804,, "A"
    return
}


/**
 * Retrieves the name of the current keyboard layout.
 * The layout name is returned as an 8-character string (e.g., "00000409").
 * 00000409 表示英文（美国）
 * 00000804 表示中文（中国）
 * @returns {string} The keyboard layout name, or an empty string on failure.
 */
GetKeyboardLayoutName()
{
    buf := Buffer(18, 0)  ; 9个 UTF-16 字符 = 18 字节
    if DllCall("GetKeyboardLayoutName", "Ptr", buf.Ptr)
        return StrGet(buf.Ptr, 8, "UTF-16")  ; 最多8个字符（如“00000409”）
    return ""
}

/**
 * Checks if the current keyboard input method is Chinese.
 * @returns {boolean} True if the current input method is Chinese (LCID ends with 0804), false otherwise.
 */
IsChineseInputMethod()
{
    buf := Buffer(18, 0)  ; 分配18字节 = 9个 UTF-16 字符
    if !DllCall("GetKeyboardLayoutName", "Ptr", buf.Ptr)
        return false
    klid := StrGet(buf.Ptr, 8, "UTF-16")  ; 获取输入法布局名，如 00000804
    ; 判断是否为中文（LCID以0804结尾）
    return (SubStr(klid, -3) = "0804")
}

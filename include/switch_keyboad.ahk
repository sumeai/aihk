
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



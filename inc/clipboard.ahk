;; 判断是否有选中文字
CheckIfTextSelected_clipboard(second:=0.6) {
    ; 保存当前剪贴板内容
    ClipSaved := ClipboardAll()
    A_Clipboard := ""  ; 清空剪贴板
    selectText := ""

    ; 发送 Ctrl+C 复制选中的文本
    Send "^c"

    ; 等待剪贴板更新
    if (ClipWait(second)) {
        selectText :=  A_Clipboard
    } else {
        selectText := ""
    }

    ; 恢复剪贴板内容
    A_Clipboard := ClipSaved
    return selectText
}

;; 获得选中的文本，如何没有选中文本，则返回剪贴板的内容
GetSelectTextOrClipboard_clipboard(second:=0.6) {
    ; 保存当前剪贴板内容
    ClipSaved := ClipboardAll()
    oldclip := A_Clipboard
    A_Clipboard := ""  ; 清空剪贴板
    selectText := ""

    ; 发送 Ctrl+C 复制选中的文本
    Send "^c"

    ; 等待剪贴板更新
    if (ClipWait(second)) {
        selectText :=  A_Clipboard
    } else {
        selectText := oldclip
    }

    if (selectText = "") {
        selectText := oldclip
    }

    ; 恢复剪贴板内容
    A_Clipboard := ClipSaved
    return selectText
}


;; 借用剪贴板来输出
SendBy_clipboard(keys_) {
    ; 保存当前剪贴板内容
    ClipSaved := ClipboardAll()
    sleep 50

    A_Clipboard := keys_  ; 清空剪贴板
    sleep 50


    ; 发送 Ctrl+C 复制选中的文本
    Send "^v"

    sleep 100

    ; 恢复剪贴板内容
    A_Clipboard := ClipSaved
}



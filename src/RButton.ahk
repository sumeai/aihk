; 初始化全局变量
global rightButtonHeld := false
global rightDrawHeld := false   ;; 右键长按1秒后，进入右键绘制状态true，松开右键恢复false
global startTime := 0
global lastRButtonClickTime := 0


; 右键按下事件
RButton::
{
    global rightButtonHeld, startTime, lastRButtonClickTime
    ; 获取当前点击时间
    currentClickTime := A_TickCount
    ; 检查是否为右键双击
    if (currentClickTime - lastRButtonClickTime < 300) {
        ; 双击操作：清除Tooltip
        Tooltip("")
        SetTimer(ClearToolTip, -3000)  ; 3秒后自动清除ToolTip
        return
    }
    else if (rightDrawHeld) {
        ToolTipMousePos()  ; 显示鼠标位置
    }
    
    ; 更新最后一次右键点击时间
    lastRButtonClickTime := currentClickTime
    
    ; 标记右键被按住
    rightButtonHeld := true
    ; 记录当前时间
    startTime := A_TickCount
    ; 启动计时检测线程
    SetTimer(CheckRightButton, 100)
    return  ; 防止右键本身的默认行为被执行
}

; 右键松开事件
RButton Up::
{
    global rightButtonHeld, startTime, rightDrawHeld
    rightDrawHeld := false
    ; 检查是否已经显示了提示框
    if (rightButtonHeld) {
        ; 取消标记右键被按住
        rightButtonHeld := false
        ; 关闭计时检测线程
        SetTimer(CheckRightButton, 0)
        ; 如果按住时间小于2秒，发送右键点击
        if (A_TickCount - startTime < 1000) {
            Click("R")
        }

        ClearToolTip()
    }
    return  ; 防止右键本身的默认行为被执行
}

ToolTipMousePos(){
        ; 获取鼠标位置
        MouseGetPos(&xpos, &ypos)
        ; 显示提示框
        Tooltip("Mouse Position: " xpos ", " ypos)
}

; 计时检测线程
CheckRightButton() {
    global rightButtonHeld, startTime, rightDrawHeld
    ; 检查是否按住超过1秒
    if (rightButtonHeld && (A_TickCount - startTime >= 1000)) {
        ; 显示鼠标位置
        ToolTipMousePos()

        ; 取消标记右键被按住
        rightButtonHeld := false
        ; 进入右键绘画状态
        rightDrawHeld := true
    }
}

; 清除ToolTip
ClearToolTip() {
    Tooltip("")
}


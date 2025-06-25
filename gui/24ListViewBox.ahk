#Requires AutoHotkey v2.0
#SingleInstance Force
#Include "../lib/JSON.ahk"
#Include "../inc/inifile.aik"

tempini_file := A_Args.Length > 0 ? A_Args[1] : "temp.ini"
g_title := A_Args.Length > 1 ? A_Args[2] : ""

; MsgBox "tempini_file = " tempini_file ", g_title = " g_title

dataStr := IniRead(tempini_file, "HotkeyList", "HotkeyArray", "")
g_data := JSON.Load(dataStr)

columsStr := IniRead(tempini_file, "HotkeyList", "ColumsArray", "")
; MsgBox  "columsStr = " columsStr
columnsArray := JSON.Load(columsStr)

g_LV := Object
g_keys := []
g_columns := []

g_pre_input := ""

g_wintitle := "列表提示框"

esc:: ExitApp()

;; 生成窗口并显示列表
ShowDynamicListView(g_data, columnsArray)

return

ShowDynamicListView(data, columnsArray) {
    global g_title, g_LV, g_keys, g_columns

    if data.Length = 0 {
        MsgBox "数组为空，无法显示。"
        return
    }
 
    for keyVaue in columnsArray {
        if StrSplit2Sub(keyVaue, ":", &key, &value) {
            g_keys.Push(key)
            g_columns.Push(value)
        }
    }    

    ; 获取所有字段（列）
    fields := []
    if (data.Length > 0){
        for k, v in data[1] {
            fields.Push(k)
        }
    }

    if (g_columns.Length <= 0) {
        if fields.Length > 0 {
            g_keys := fields
            g_columns := fields
        } else {
            g_keys.Push("Key")
            g_keys.Push("Value")

            g_columns.Push("Key")
            g_columns.Push("Value")
        }
    }

    ; MsgBox "keys = " JSON.Dump(keys)  ", columns = " JSON.Dump(columns)

    ; 创建 GUI 和 ListView
    myGui := Gui("+Resize", g_wintitle)
    myGui.SetFont("s10")

    ;; 如果输入了第二title参数，则增加Text控件显示该参数内容
    if (g_title != ""){
        myGui.Add("Text", "w800", g_title)
    }

    ;; 增加输入框，用来查询过滤ListView的内容
    IB := myGui.Add("Edit", "w800")
    IB.OnEvent("Change", 输入过滤条件)

    ;; 增加ListView控件，显示具体的内容
    g_LV := myGui.Add("ListView", "w800 r20", g_columns)

    ;; 填充ListView的内容
    RefreshListView("")
    
    ;; 显示窗口
    myGui.Show()
}


isItemValid(item, inputStr){
    ;; 如果没有传入过滤条件，则返回true
    if inputStr = "" {
        return true
    }

    ; MsgBox "item = " item["desc"]

    ;; 只要item中有一个字段包含了 inputStr 的内容，则返回true
    for key, Value in item {
        if InStr(Value, inputStr) {
            return true
        }
    }

    return false
}


RefreshListView(inputStr){
    global g_LV, g_keys, g_data

    g_LV.Delete()  ; 清空所有行

    ; 填充数据
    for item in g_data {
        ;; 如果过滤条件不为空，则需要过滤出满足条件的数据
        if isItemValid(item, inputStr) {
            row := []
            for col in g_keys {
                row.Push(item.Has(col) ? item[col] : "")
                ; MsgBox "col = " JSON.Dump(col)  ", row = " JSON.Dump(row)  ", item = " JSON.Dump(item)
            }
            ; MsgBox ", row = " JSON.Dump(row) 
            g_LV.Add("", row*)
        }
    }

    ; 自动适应列宽
    for i, _ in g_columns
        g_LV.ModifyCol(i, "AutoHdr")    
}



输入过滤条件(Ctrl, Info) {
    global g_pre_input
    inputStr := Ctrl.Text
    if inputStr = g_pre_input {
        return
    }
    ;; 刷新ListView显示内容
    RefreshListView(inputStr)

    g_pre_input := inputStr
}
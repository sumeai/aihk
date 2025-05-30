#Requires AutoHotkey v2.0
#Include "../include/JSON.ahk"
#Include "../include/inifile.aik"

tempini_file := A_Args.Length > 0 ? A_Args[1] : "temp.ini"

dataStr := IniRead(tempini_file, "HotkeyList", "HotkeyArray", "")
data := JSON.Load(dataStr)

columsStr := IniRead(tempini_file, "HotkeyList", "ColumsArray", "")
; MsgBox  "columsStr = " columsStr
columnsArray := JSON.Load(columsStr)

g_wintitle := "列表提示框"

#HotIf WinActive(g_wintitle " ahk_class AutoHotkeyGUI ahk_exe AutoHotkey64.exe")
esc:: ExitApp()
#HotIf 

; 🚀 生成窗口并显示列表
ShowDynamicListView(data, columnsArray)

return

ShowDynamicListView(data, columnsArray) {
    if data.Length = 0 {
        MsgBox "数组为空，无法显示。"
        return
    }
 

    keys := []
    columns := []
    for keyVaue in columnsArray {
        tempArray := StrSplit(keyVaue, ":")

        ;; tempArray == "key:热键"
        if (tempArray.Length > 1) {
            keys.Push(tempArray[1])
            columns.Push(tempArray[2])
        }
    }    



    ; 获取所有字段（列）
    fields := []
    if (data.Length > 0){
        for key in data[1].OwnProps()
            fields.Push(key)
    }

    if (columns.Length <= 0) {
        if fields.Length > 0 {
            keys := fields
            columns := fields
        } else {
            keys.Push("Key")
            keys.Push("Value")

            columns.Push("Key")
            columns.Push("Value")
        }
    }

    ; MsgBox "keys = " JSON.Dump(keys)  ", columns = " JSON.Dump(columns)

    ; 创建 GUI 和 ListView
    myGui := Gui("+Resize", g_wintitle)
    myGui.SetFont("s10")
    LV := myGui.Add("ListView", "w600 r20", columns)

    ; 填充数据
    for item in data {
        row := []
        for col in keys {
            

            row.Push(item.Has(col) ? item[col] : "")

            ; MsgBox "col = " JSON.Dump(col)  ", row = " JSON.Dump(row)  ", item = " JSON.Dump(item)

        }

        ; MsgBox ", row = " JSON.Dump(row) 
        
        LV.Add("", row*)
    }

    ; 自动适应列宽
    for i, _ in columns
        LV.ModifyCol(i, "AutoHdr")

    myGui.Show()
}

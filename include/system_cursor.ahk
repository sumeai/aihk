


; 定义一些常见光标样式
IDC_ARROW := 32512
IDC_IBEAM := 32513
IDC_WAIT := 32514
IDC_CROSS := 32515
IDC_UPARROW := 32516
IDC_SIZEALL := 32646
IDC_SIZENWSE := 32642
IDC_SIZENESW := 32643
IDC_SIZEWE := 32644
IDC_SIZENS := 32645
IDC_HAND := 32649
IDC_NO := 32648



SetSystemCursor(CursorID)
{
    hCursor := DllCall("LoadCursor", "Ptr", 0, "Int", CursorID, "Ptr")
    DllCall("SetSystemCursor", "Ptr", hCursor, "Int", 0x8000)
}


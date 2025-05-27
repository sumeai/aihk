/**
 *@file    飞扬魔术键盘.ahk
 *@author  teshorse
 *@date    2012.4.1
 *@brief   飞扬魔术键盘的实现
 *
 * 飞扬魔术键盘是一个能够快速更改键盘各按键的功能的工具
 *
 * 更新日志:
 * - V1.10
 * - 新增功能: RShift键切换键盘大小写状态。
 * - 修正一个Bug，对于[,],\,/,'这些特殊键，没有成功映射到相应的按钮名称，而导致的错误。
 *
 * - V1.00
 * - 实现飞扬魔术键盘的基本功能
 */

g_version = V1.10

#SingleInstance force
FileInstall, KeyBoard.ini, %A_ScriptDir%\KeyBoard.ini

FileInstall, 橙色.ico, %A_ScriptDir%\橙色.ico
FileInstall, 丁香紫.ico, %A_ScriptDir%\丁香紫.ico
FileInstall, 红色.ico, %A_ScriptDir%\红色.ico
FileInstall, 黄色.ico, %A_ScriptDir%\黄色.ico
FileInstall, 蓝色.ico, %A_ScriptDir%\蓝色.ico
FileInstall, 绿色.ico, %A_ScriptDir%\绿色.ico
FileInstall, 玫瑰红.ico, %A_ScriptDir%\玫瑰红.ico
FileInstall, 青色.ico, %A_ScriptDir%\青色.ico
FileInstall, 设置.ico, %A_ScriptDir%\设置.ico
FileInstall, 天蓝.ico, %A_ScriptDir%\天蓝.ico
FileInstall, 银色.ico, %A_ScriptDir%\银色.ico
FileInstall, 紫色.ico, %A_ScriptDir%\紫色.ico

FileInstall, 橙色.jpg, %A_ScriptDir%\橙色.jpg
FileInstall, 丁香紫.jpg, %A_ScriptDir%\丁香紫.jpg
FileInstall, 红色.jpg, %A_ScriptDir%\红色.jpg
FileInstall, 黄色.jpg, %A_ScriptDir%\黄色.jpg
FileInstall, 蓝色.jpg, %A_ScriptDir%\蓝色.jpg
FileInstall, 绿色.jpg, %A_ScriptDir%\绿色.jpg
FileInstall, 玫瑰红.jpg, %A_ScriptDir%\玫瑰红.jpg
FileInstall, 青色.jpg, %A_ScriptDir%\青色.jpg
FileInstall, 设置.jpg, %A_ScriptDir%\设置.jpg
FileInstall, 天蓝.jpg, %A_ScriptDir%\天蓝.jpg
FileInstall, 银色.jpg, %A_ScriptDir%\银色.jpg
FileInstall, 紫色.jpg, %A_ScriptDir%\紫色.jpg

#Include ../../

;; 参数: 显示或隐藏|键盘名称
;; 例如: 1|默认键盘
g_keyBoard = %1%


;; 更换图标
change_icon()

; Changing this font size will make the entire on-screen keyboard get
; larger or smaller:
k_FontSize = 10
k_FontName = Verdana ; This can be blank to use the system's default font.
k_FontStyle = Bold    ; Example of an alternative: Italic Underline

; To have the keyboard appear on a monitor other than the primary, specify
; a number such as 2 for the following variable. Leave it blank to use
; the primary:
g_Monitor =

g_bAutoPressBtn := true  	;; 在输入键盘时，是否同时自动模拟点击相应的按钮
g_bMoveWindow := false		;; 当前是否处于移动飞扬魔术键盘的状态
g_bShiftDown := false 		;; Shift按钮是否长期按下

; 当前使用的键盘，如果工作上下没有KeyBoard.ini配置文件，
; 则从飞扬魔术键盘程序目录下的KeyBoard.ini复制过去
g_inifile = KeyBoard.ini
IfNotExist %g_inifile%
{
	IfExist %A_ScriptDir%\%g_inifile%
	{
		FileCopy, %A_ScriptDir%\%g_inifile%, %A_WorkingDir%\%g_inifile%
	}
}


g_iniContent := IniFileRead( g_inifile )
IniRead, g_keyBoard, temp.ini, 飞扬魔术键盘, 最近键盘 , 默认键盘


;---- End of configuration section. Don't change anything below this point
; unless you want to alter the basic nature of the script.

#include ./bin/飞扬魔术键盘/GuiCreate.aik


∑设置热键( )

return ; End of auto-execute section.


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; 退出响应，退出之前先保存当前窗口的位置，以便下次定位到此处。
GuiClose:
【退出菜单项】:
【退出】:
	Gosub 【保存当前窗口位置】
ExitApp


【保存当前窗口位置】:
	WinGetPos winx, winy, , , ahk_id %k_ID%
	WriteTempIni("飞扬魔术键盘", g_keyBoard_name . "_winx", winx)
	WriteTempIni("飞扬魔术键盘", g_keyBoard_name . "_winy", winy)
	Return



;---- When a key is pressed by the user, click the corresponding button on-screen:

~*Backspace::
	IfWinActive 新增键盘
		return

	If g_bAutoPressBtn
	{
		ControlClick, Bk, ahk_id %k_ID%, , LEFT, 1, D
		KeyWait, Backspace
		ControlClick, Bk, ahk_id %k_ID%, , LEFT, 1, U
	}
	return

~*LCtrl:: ; Must use Ctrl not Control to match button names.
~*RCtrl::
~*LAlt::
~*RAlt::
~*LWin::
~*RWin::
	IfWinActive 新增键盘
		return

	;; 当不在设置状态时，点击控制键将模拟用户按下相应的按钮
	Gui submit, nohide
	if not _key_Setting
	{
		StringTrimLeft, g_ThisHotkey, A_ThisHotkey, 3
		ControlClick, %g_ThisHotkey%, ahk_id %k_ID%, , LEFT, 1, D
		KeyWait, %g_ThisHotkey%
		ControlClick, %g_ThisHotkey%, ahk_id %k_ID%, , LEFT, 1, U
	}
	return

; LShift and RShift are used rather than "Shift" because when used as a hotkey,
; "Shift" would default to firing upon release of the key (in older AHK versions):
~*LShift:
【LShift按键响应】:
	IfWinActive 新增键盘
		return

	;; 当不在设置状态时，点击控制键将模拟用户按下相应的按钮
	Gui submit, nohide
	if not _key_Setting
	{
		StringTrimLeft, g_ThisHotkey, A_ThisHotkey, 3
		ControlClick, %g_ThisHotkey%, ahk_id %k_ID%, , LEFT, 1, D
		KeyWait, %g_ThisHotkey%
		ControlClick, %g_ThisHotkey%, ahk_id %k_ID%, , LEFT, 1, U

		;; 刷新按键状态
		if g_bShiftDown
		{
			ControlClick, Shift, ahk_id %k_ID%, , LEFT, 1, D
			GuiControl, Text, _key_shift, SHIFT
		}
		Else
		{
			ControlClick, Shift, ahk_id %k_ID%, , LEFT, 1, U
			GuiControl, Text, _key_shift, Shift
		}
	}
	return


;; 右Shift键长期按下或弹起Shift按钮，即切换g_bShiftDown的值
~*RShift::
	IfWinActive 新增键盘
		return

	;; 当不在设置状态时，点击控制键将模拟用户按下相应的按钮
	Gui submit, nohide
	if _key_Setting
		Return

	;; 默认键盘的右Shift键功能与LShift键相同
	if g_keyBoard_name = 默认键盘
		Goto 【LShift按键响应】

	g_bShiftDown := !g_bShiftDown
	∑刷新界面按钮显示( g_keyBoard_name )

	;; 刷新按键状态
	if g_bShiftDown
	{
		ControlClick, Shift, ahk_id %k_ID%, , LEFT, 1, D
		GuiControl, Text, _key_shift, SHIFT
	}
	Else
	{
		ControlClick, Shift, ahk_id %k_ID%, , LEFT, 1, U
		GuiControl, Text, _key_shift, Shift
	}
	Return


【Shift按钮响应】:
	Return

【按键响应】:
	IfWinActive ahk_id %k_ID%
		return

	If g_bAutoPressBtn
	{
		StringReplace, g_ThisHotkey, A_ThisHotkey, ~
		StringReplace, g_ThisHotkey, g_ThisHotkey, *

		∑获得按键按钮的标题( g_keyBoard_name, g_ThisHotkey, var_keyName )


		GuiControlGet, g_ThisKeyName, , _key_%var_keyName%
		if g_ThisKeyName =
			g_ThisKeyName := g_ThisHotkey

		;tooltip7( "[" . g_ThisKeyName . "]" )
		SetTitleMatchMode, 3 ; Prevents the T and B keys from being confused with Tab and Backspace.

		;ToolTip %A_ThisHotkey% >>> %g_ThisKeyName%
		ControlClick, %g_ThisKeyName%, ahk_id %k_ID%, , LEFT, 1, D
		;KeyWait, %g_ThisHotkey%
		;ControlClick, %g_ThisKeyName%, ahk_id %k_ID%, , LEFT, 1, U

		∑执行键盘按键响应( var_keyName )
	}
	Return

【模拟点击按钮】:
	IfWinActive ahk_id %k_ID%
		return

	IfWinActive 新增键盘
		return

	If g_bAutoPressBtn
	{
		StringReplace, g_ThisHotkey, A_ThisHotkey, ~
		StringReplace, g_ThisHotkey, g_ThisHotkey, *
		GuiControlGet, g_ThisKeyName, , _key_%g_ThisHotkey%
		if g_ThisKeyName =
			g_ThisKeyName := g_ThisHotkey

		;tooltip7( "[" . g_ThisKeyName . "]" )
		SetTitleMatchMode, 3 ; Prevents the T and B keys from being confused with Tab and Backspace.
		ControlClick, %g_ThisKeyName%, ahk_id %k_ID%, , LEFT, 1, D
		KeyWait, %g_ThisHotkey%
		ControlClick, %g_ThisKeyName%, ahk_id %k_ID%, , LEFT, 1, U
	}
	Return

【响应按键释放】:
	;If g_bAutoPressBtn
	{
		StringReplace, g_ThisHotkey, A_ThisHotkey, ~
		StringReplace, g_ThisHotkey, g_ThisHotkey, *
		StringReplace, g_ThisHotkey, g_ThisHotkey, %A_Space%Up

		∑获得按键按钮的标题( g_keyBoard_name, g_ThisHotkey, var_keyName )
		GuiControlGet, g_ThisKeyName, , _key_%var_keyName%

		if g_ThisKeyName =
			g_ThisKeyName := g_ThisHotkey

		;tooltip7( "[" . g_ThisKeyName . "]" )
		SetTitleMatchMode, 3 ; Prevents the T and B keys from being confused with Tab and Backspace.
		ControlClick, %g_ThisKeyName%, ahk_id %k_ID%, , LEFT, 1, U
	}
	Return

【显示或隐藏屏幕键盘】:
if g_IsVisible = y
{
	Gui, Cancel
	Menu, Tray, Rename, %k_MenuItemHide%, %k_MenuItemShow%
	g_IsVisible = n
}
else
{
	Gui, Show
	Menu, Tray, Rename, %k_MenuItemShow%, %k_MenuItemHide%
	g_IsVisible = y
}
return




【重新加载】:
reload
return



【按键单击响应】:
	Gui submit, nohide
	∑鼠标单击按键( a_GuiControl )
	return



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; 右键菜单
【弹出右键菜单】:
	;; 删除以前的右键菜单
	if g_bRightMenu
		Menu, RightMenu, DeleteAll
	Else
		g_bRightMenu := true

	;; 创建新的右键菜单
	Menu, RightMenu, Add, 新增键盘 &A, 【新增键盘】
	Menu, RightMenu, Add, 编辑键盘 &E, 【用飞扬小字典编辑键盘】
	Menu, RightMenu, Add, 隐藏键盘 &H, 【显示或隐藏屏幕键盘】
	Menu, RightMenu, Add, 默认位置 &D, 【移动窗口到默认位置】
	Menu, RightMenu, Add,
	Menu, RightMenu, Add, &0 默认键盘, 【选择键盘】

	var_keyboard := ∑获取当前键盘名称()
	if var_keyboard = 默认键盘
		Menu, RightMenu, Check, &0 默认键盘

	;; 创建键盘列表
	var_temp := AllSecFromIniMem( g_inicontent )
	;MsgBox section = %var_temp%
	loop parse, var_temp, |
	{
		if a_loopfield =
			Continue

		if a_loopfield = 默认键盘
			Continue

		var_line := A_LoopField
		var_menuitem = &%a_index% %var_line%
		Menu, RightMenu, Add, %var_menuitem%, 【选择键盘】

		if ( var_keyboard == var_line )
			Menu, RightMenu, Check, %var_menuitem%
	}
	Menu, RightMenu, Show
	Return

【新增键盘】:
	var_keyboard := myinput("新增键盘","请输入要新建的键盘名称：")
	if var_keyboard <>
	{
		if regexmatch(var_keyboard, "[\[\]]" ) > 0
		{
			MsgBox 键盘名称中不能包含 “[”和 “]”！
			Return
		}
		var_colorList = 橙色|丁香紫|红色|黄色|蓝色|绿色|玫瑰红|青色|设置|天蓝|银色|紫色
		var_keycolor =
		var_keycolor := InputListBox( var_colorList, "请选择键盘颜色" )
		write_ini( g_inifile, var_keyboard, "Color", var_keycolor )
		g_iniContent := IniFileRead( g_inifile )
		∑切换键盘( var_keyboard )
	}
	Return

【选择键盘】:
	g_bAutoPressBtn := false
	var_menuitem := a_thismenuitem
	if RegExMatch( a_thismenuitem, "i)\&\d+\s+", var_match ) > 0
	{
		var_menuitem := SubStr( var_menuitem, StrLen(var_match)+1 )
		WriteTempIni("飞扬魔术键盘", "最近键盘", var_menuitem)
	}
	;∑切换键盘( var_menuitem )
	reload
	g_bAutoPressBtn := true
	Return


【勾选SettingCheckBox】:
	Gui submit, nohide
	var_keyboard := ∑获取当前键盘名称()
	if var_keyboard = 默认键盘
	{
		MsgBox 默认键盘不能编辑！
		Return
	}
	;; 模拟点击CheckBox
	bCheck := !_key_Setting
	Guicontrol, , _key_Setting, %bCheck%
	Gosub 【点击SettingCheckBox】

	;; 如果shift处于按下状态，则弹起之
	GetKeyState, state, Shift
	if state = D
		send {shift up}

	Return

【点击SettingCheckBox】:
	Gui submit, nohide
	if _key_Setting
	{
		;; 更换图标，最后一个参数表示在Suspend时禁止换成默认的S图标
		change_icon( "设置.ico", true, 1 )

		GuiControl , , _btn_setting, 返回
		GuiControl , , _SidePic, %g_keyBoard_setpic%
		GuiControl , -Right, _toptext
		GuiControl , , _toptext, 【 %g_keyBoard_name% 】 处于编辑状态(Alt+RShift返回)，热键被暂停。

		;; 取消窗口透明
		WinSet, TransColor, %TransColor% 255, ahk_id %k_ID%

		;∑设置热键( false )
		Suspend On

		;; 重绘GroupBox，避免上方线条被_toptext遮盖
		GuiControl, , _GroupBox,
		Sleep 10
		GuiControl, , _GroupBox,
	}
	Else
	{
		var_color := ∑获取当前键盘颜色()

		var_icon = %var_color%.ico
		change_icon( var_icon, True )

		GuiControl , , _btn_setting, 设置
		GuiControl , , _SidePic, %g_keyBoard_sidepic%
		GuiControl, +Right, _toptext
		GuiControl , , _toptext, 【 %g_keyBoard_name% 】

		;; 使窗口透明
		WinSet, TransColor, %TransColor% 200, ahk_id %k_ID%

		;∑设置热键( true )
		Suspend Off

		;; 重绘GroupBox，避免上方线条被_toptext遮盖
		GuiControl, , _GroupBox,
		Sleep 10
		GuiControl, , _GroupBox,

	}
	Return


【用飞扬小字典编辑键盘】:
	var_root := ∑获取根目录()
	var_file = %var_root%\bin\dict\dict.ahk

	var_param = 
		(Ltrim
		file:keyboard.ini
		title:编辑飞扬魔术键盘
		cursec:%g_keyboard%
		)

	run_ahk( var_file, var_param, a_workingdir )
	Return


【响应按键对应的热键】:

	Return


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; 函数
∑鼠标单击按键( key_, bForce = false )
{
	global g_keyBoard, _key_Setting, k_ID, g_bAutoPressBtn, g_bShiftDown

	;; 只允许鼠标点击屏幕键盘上的按钮，否则过滤
	if not bForce
	{
		MouseGetPos, OutputVarX, OutputVarY, OutputVarWin, OutputVarControl, 1
		if ( k_ID != OutputVarWin )
		{
			;MsgBox k_ID[%k_ID%] != [%OutputVarWin%]OutputVarWin
			Return
		}
	}

	;; 将key_ = _key_a 分离出_key_后面的a, 代表了a键
	if RegExMatch( key_, "i)(?<=_key_).*$", var_key ) <= 0
		return false

	if var_key =
		return false

	;; 检查是否按下控制键
	var_ctrlkey := ∑检查按下的控制键()
	if var_ctrlkey <>
		var_key = %var_ctrlkey%%var_key%

	;; 如果Shift被按下，var_key要加上Shift符号+
	if g_bShiftDown
	{
		IfInString var_ctrlkey, +
		{
			StringReplace var_key, var_key, +, , All
		}
		Else
		{
			var_key = +%var_key%
		}
	}

	;; 勾选了设置状态复选框，进入编辑状态
	if _key_Setting
	{
		;; if g_bAutoPressBtn == false 说明正有其他按钮处于编辑状态
		if g_bAutoPressBtn
		{
			∑编辑按键( var_key )
		}
	}
	else
		∑执行按键( var_key )

	return true
}

;; 参数key_是从_key_a中分离出来的a
;; 通过点击按钮弹出CmdString编辑框，为对应的按钮设置CmdString，点击时可同时按下控制键
∑编辑按键( key_ )
{
	local var_temp, var_value, cmdstr, var_key, var_keyboard, var_opt, var_match
	if key_ =
		Return

	var_keyboard := ∑获取当前键盘名称()
	if var_keyboard = 默认键盘
	{
		Return ;; 默认键盘，不允许编辑
	}
	g_bAutoPressBtn := false
	var_value := FindFromIniMem( g_inicontent, var_keyboard, key_, "" )
	var_temp = %key_% =
	cmdstr := ∑编辑飞扬命令串( var_value, var_temp )
	if cmdstr <>
	{
		if cmdstr = $space$
			cmdstr =
		var_value := cmdstr
		;; 将新设置的键盘值保存到配置文件中
		write_ini( g_inifile, var_keyboard, key_, var_value )
		g_iniContent := IniFileRead( g_inifile )
		;; 修改按钮的显示名称
		IfInString cmdstr, )
		{
			cmdStringSplit( cmdstr, var_opt )
			;MsgBox cmdstr =  %var_temp% `n opt = %var_opt%
			if RegExMatch( var_opt, "i)(?<=name:).*?(?=$|\)|\|)", var_match ) > 0
			{
				;msgbox var_match = %var_match%
				if var_match <>
				{
					GuiControl, Text, _key_%key_%, %var_match%
				}
			}
		}
	}
	g_bAutoPressBtn := true
}

;; 通过点击按钮执行cmdStr，Enter/Tab/BackSpace/Space有效
∑执行按键( key_ )
{
	local var_keyboard, var_temp, cmdstr

	cmdstr =
	var_keyboard := ∑获取当前键盘名称()
	if var_keyboard <> 默认键盘
	{
		cmdstr := FindFromIniMem( g_iniContent, var_keyboard,  key_, "" )
		TipCmdString( cmdstr )
	}
	if cmdstr =
	{
		cmdstr := ValnameToKeyname(key_)
		cmdstr = 1|send)%cmdstr%
	}
	RunKeyboardCmdstr( cmdstr )
	TipCmdString( cmdstr )
}

;; 通过热键执行cmdStr，Enter/Tab/BackSpace/Space将失效
∑执行键盘按键响应( Hotkey_ )
{
	local cmdstr, var_keyboard, keyname, var_tip, var_ctrlkey


	StringReplace, Hotkey_, Hotkey_, ~
	StringReplace, Hotkey_, Hotkey_, *

	if Hotkey_ =
		Return

	var_keyboard := ∑获取当前键盘名称()

	;; 检查是否按下控制键
	var_ctrlkey := ∑检查按下的控制键()
	if var_ctrlkey <>
		Hotkey_ = %var_ctrlkey%%Hotkey_%

	;; 如果Shift被按下，则Hotkey_前要加上Shift符号+
	if g_bShiftDown
	{
		IfInString var_ctrlkey, +
		{
			StringReplace Hotkey_, Hotkey_, +, , All
		}
		Else
		{
			Hotkey_ = +%Hotkey_%
		}
	}
	cmdstr := FindFromIniMem( g_iniContent, var_keyboard,  Hotkey_, "" )


	if cmdstr =
	{

		if Hotkey_ Contains ^,+,!,#
		{
			SendPlay %Hotkey_%
		}
		else
		{
			StringReplace, keyname, Hotkey_, ~
			StringReplace, keyname, keyname, *
			if keyname <> Space
			{
				cmdstr = 1|send)%keyname%
			}
		}
	}

	if cmdstr <>
	{
		TipCmdString( cmdstr )
		RunKeyboardCmdstr( cmdstr )
	}
}

RunKeyboardCmdstr( cmdstr_ )
{
	cmdStringSplit( cmdstr_, var_opt )
	if FindCmdOpt( var_opt, "BeforePress:", var_value )
	{
		KeyboardCommand( var_value )
	}
	run_cmd( cmdstr_ )
	if FindCmdOpt( var_opt, "AfterPress:", var_value )
	{
		KeyboardCommand( var_value )
	}
}


KeyboardCommand( cmd_ )
{
	global
	IF cmd_ in Exit,Quit,退出
		Gosub 	【退出】
	else if cmd_ in Set,Setting,Seting,设置
		Gosub  	【勾选SettingCheckBox】
	else if cmd_ in Hide,隐藏
		Gosub  	【显示或隐藏屏幕键盘】
}


;; 从Button的变量名(例如：_key_fxg或fxg)，得到对应的按钮名称(例如：\)
ValnameToKeyname( valname_ )
{
	;; 变量名中如果包含_key_前缀，则分离出_key_后面的字母作为按键名称var_key
	if RegExMatch( valname_, "i)(?<=_key_).*$", var_key ) <= 0
		var_key := valname_  ;; 不再_key_前缀则直接将变量名称valname_作为var_key

	if var_key = bk
		var_key = {BackSpace}
	else if var_key = sub
		var_key = -
	else if var_key = equal
		var_key := "="
	else if var_key = lf
		var_key = [
	else if var_key = rf
		var_key = ]
	else if var_key = fxg
		var_key = \
	else if var_key = mh
		var_key = ;
	else if var_key = dyh
		var_key = '
	else if var_key = dh
		var_key = `,
	else if var_key = jh
		var_key = .
	else if var_key = xg
		var_key = /
	else if var_key = Enter
		var_key = {Enter}
	else if var_key = tab
		var_key = {Tab}
	else if var_key = space
		var_key = {Space}

	return var_key
}

∑获取当前键盘名称()
{
	global
	if g_keyboard =
		return "默认键盘"
	return g_keyboard
}

∑获取当前键盘颜色()
{
	local var_color
	var_color := FindFromIniMem( g_inicontent, g_keyboard, "Color" )
	if var_color =
		var_color = 银色

	return var_color
}

;; 获得当前键盘的颜色
GetKeyboardColor()
{
	local var_color
	var_color := FindFromIniMem( g_inicontent, g_keyboard, "Color" )
	if var_color = 橙色
		var_color = FF8000
	else if var_color = 丁香紫
		var_color = DA70D6
	else if var_color = 红色
		var_color = Red
	else if var_color = 黄色
		var_color = FFD700
	else if var_color = 蓝色
		var_color = Blue
	else if var_color = 绿色
		var_color = 00FF00
	else if var_color = 玫瑰红
		var_color = B03060
	else if var_color = 青色
		var_color = 03A89E
	else if var_color = 天蓝
		var_color = 87CEEB
	else if var_color = 银色
		var_color = Gray
	else if var_color = 紫色
		var_color = 6A5ACD
	else
		var_color =
	return var_color
}



∑获取当前键盘图标()
{
	local var_color, var_icon
	var_color := FindFromIniMem( g_inicontent, g_keyboard, "Color" )
	if var_color =
		var_color = 银色

	var_icon = %A_ScriptDir%/%var_color%.ico
	return var_icon
}



∑获得按键按钮的标题( keyBoard_, keyChar_, ByRef _keyname_ )
{
	local keyName, var_temp, var_opt, var_match, caption_, shiftKeyName

	;; 根据 keyChar_ 得到 按键对应按钮的名称
	if keyChar_ = -
		keyName = Sub
	else if keyChar_ = =
		keyName = equal
	else if keyChar_ = [
		keyName = lf
	else if keyChar_ = ]
		keyName = rf
	else if keyChar_ = \
		keyName = fxg
	else if keyChar_ = `;
		keyName = mh
	else if keyChar_ = '
		keyName = dyh
	else if keyChar_ = `,
		keyName = dh
	else if keyChar_ = `.
		keyName = jh
	else if keyChar_ = /
		keyName = xg
	Else
		keyName := keyChar_

	;; 如果没有指定按钮标题，则从配置文件中查找

	caption_ := keyChar_


	if keyBoard_ <> 默认键盘
	{
		;; 如果Shift按键处于按下状态，则切换到
		if g_bShiftDown
		{
			shiftKeyName = +%keyName%
			var_temp := FindFromIniMem( g_iniContent, keyBoard_,  shiftKeyName, "" )

			;; 如果没有找到对应Shift按下的键或者未给定name属性，则使用没有Shift的键名
			if var_temp =
				var_temp := FindFromIniMem( g_iniContent, keyBoard_,  keyName, "" )
			else IfNotInString var_temp, name:
				var_temp := FindFromIniMem( g_iniContent, keyBoard_,  keyName, "" )
		}
		Else
		{
			var_temp := FindFromIniMem( g_iniContent, keyBoard_,  keyName, "" )
		}

		IfInString var_temp, )
		{
			cmdStringSplit( var_temp, var_opt )
			;; MsgBox cmdStringSplit( var_temp, var_opt )`nvar_temp=%var_temp%`nvar_opt=%var_opt%
			if RegExMatch( var_opt, "i)(?<=name:).*?(?=$|\)|\|)", var_match ) > 0
			{
				;msgbox var_match = %var_match%
				if var_match <>
				{
					caption_ := var_match
				}
			}
		}
	}

	_keyname_ := keyName
	return caption_
}



∑修改按键按钮的标题( keyBoard_, keyChar_, caption_="" )
{
	local var_caption, keyName
	;; 为按键按钮设置标题
	var_caption := ∑获得按键按钮的标题( keyBoard_, keyChar_, keyName )
	if caption_ =
		caption_ := var_caption
	GuiControl, Text, _key_%keyName%, %caption_%
}


∑刷新界面按钮显示( var_keyboard )
{
	local k_n = 1
	local k_ASCII = 45
	local keyCaption, keyName            ;; 键盘标题
	local var_opt, var_temp, var_match


	;; 默认键盘显示
	if var_keyboard =
		var_keyboard = 默认键盘



	Loop
	{
		;; - . / 0 1 2 3 4 5 6 7 8 9 : ; = ? @ A B C D E F G H I J K L M N O P Q R S T U V W X Y Z [ \ ]
		Transform, k_char, Chr, %k_ASCII%
		StringUpper, k_char, k_char
		if k_char not in <,>,^,~,?,`,
		{
			∑修改按键按钮的标题( var_keyboard, k_char )
		}
	    ; In the above, the asterisk prefix allows the key to be detected regardless
	    ; of whether the user is holding down modifier keys such as Control and Shift.
		if k_ASCII = 93
		   break
		k_ASCII++
	}
	;; 刷新特殊按钮的标题
	∑修改按键按钮的标题( var_keyboard, "," )
	∑修改按键按钮的标题( var_keyboard, "Bs" )
	∑修改按键按钮的标题( var_keyboard, "Tab" )
	∑修改按键按钮的标题( var_keyboard, "Enter" )
	∑修改按键按钮的标题( var_keyboard, "Space" )

	∑修改按键按钮的标题( var_keyboard, "'" )
}



∑切换键盘( keyboard_ )
{
	local var_temp, var_color
	if keyboard_ =
		keyboard_ = 默认键盘

	if ( g_keyboard == keyboard_  )
	{
		return false      ;; 相同键盘，无需切换
	}
	;; 从配置文件缓存中生成键盘列表
	var_temp := AllSecFromIniMem( g_inicontent )  ;; 所有的键盘列表，以|分隔

	;; 如果指定的键盘存在，则切换之
	if ( keyboard_=="默认键盘" || InStrList( var_temp, keyboard_, "|" ) > 0 )
	{
		Gosub 【保存当前窗口位置】

		;; 重新打开程序，实现键盘切换
		var_root := ∑获取根目录()
		var_file = %var_root%\bin\飞扬魔术键盘\飞扬魔术键盘.ahk
		run_ahk( var_file, keyboard_ )

		return true
	}
	return false
}


∑设置热键( bActive=true )
{
	keyBoard_name := ∑获取当前键盘名称()
	if keyBoard_name = 默认键盘
		bUsers := False
	Else
		bUsers := true

	;; 激活或屏蔽热键
	flag := bActive ? "On" : "Off"

	;---- Set all keys as hotkeys. See www.asciitable.com
	k_n = 1
	k_ASCII = 45

	;; 设置93个键盘按钮的响应热键
	Loop
	{
		Transform, k_char, Chr, %k_ASCII%
		StringUpper, k_char, k_char
		if k_char not in <,>,^,~,?`,
		{
			if bUsers
			{
				;; 如果使用非默认键盘，则打开下面两个热键，使用用户自定义的CMDString
				Hotkey, *%k_char%, 【按键响应】, %flag%
				Hotkey, ~*%k_char% up, 【响应按键释放】, %flag%
			}
			Else
			{
				;; 如果使用的是默认键盘，则仅模块用点点击按钮，但不拦截用户输入的热键
				Hotkey, ~*%k_char% , 【模拟点击按钮】, %flag%
			}
		}
	   ; In the above, the asterisk prefix allows the key to be detected regardless
	   ; of whether the user is holding down modifier keys such as Control and Shift.
		if k_ASCII = 93
		   break
		k_ASCII++
	}

	;; 在配置文件AutoHotString.ini的[全局热键]节中
	;; 寻找关键字“【选择飞扬魔术键盘】”的热键值，将其作为切换最近使用键盘的快捷键
	IniRead, var_ChangeHK, AutoHotString.ini, 全局热键,【选择飞扬魔术键盘】, 1)AppsKey & Space
	var_ChangeHK := cmdStringSplit( var_ChangeHK, var_opt )
	if var_ChangeHK =
		var_ChangeHK = AppsKey & Space

	;; 设置其他热键的响应
	if bUsers
	{
		Hotkey, *`,, 		【按键响应】, %flag%
		Hotkey, *', 		【按键响应】, %flag%
		;Hotkey, *Space, 	【按键响应】, %flag%
		;Hotkey, *Enter, 	【按键响应】, %flag%
		;Hotkey, *Tab, 		【按键响应】, %flag%

		Hotkey, ~*`, up, 		【响应按键释放】, %flag%
		Hotkey, ~*' up, 		【响应按键释放】, %flag%
		;Hotkey, ~*Space up, 	【响应按键释放】, %flag%
		;Hotkey, ~*Enter up, 	【响应按键释放】, %flag%
		;Hotkey, ~*Tab up, 	【响应按键释放】, %flag%

		Hotkey, %var_ChangeHK%, 【切换到默认键盘】, On
	}
	Else
	{
		Hotkey, ~*`,, 		【模拟点击按钮】, %flag%
		Hotkey, ~*', 		【模拟点击按钮】, %flag%
		;Hotkey, ~*Space, 	【模拟点击按钮】, %flag%
		;Hotkey, ~*Enter, 	【模拟点击按钮】, %flag%
		;Hotkey, ~*Tab, 	【模拟点击按钮】, %flag%
		Hotkey, %var_ChangeHK%, 【切换到最近键盘】, On
	}
	Hotkey, ~*Space, 	【模拟点击按钮】, %flag%
	Hotkey, ~*Enter, 	【模拟点击按钮】, %flag%
	Hotkey, ~*Tab, 	【模拟点击按钮】, %flag%
	Hotkey, !RShift, 	【勾选SettingCheckBox】, On
}


∑空格按钮提示( var_tip )
{
	global
	GuiControl, Text, _key_Space, %var_tip%
	SetTimer 【定时清除空格按钮提示】, 1000
}

;; 将cmdstr_的选项缩短后显示
TipCmdString( cmdstr_ )
{
	var_options =
	var_value := cmdStringSplit( cmdstr_, var_opt )
	loop parse, var_opt, |
	{
		;; 如果有tip:选项，则直接显示Tip的内容，否则显示缩短选项后的cmdstring
		if InStr( a_loopfield, "tip:", false ) > 0
		{
			StringMid, var_temp, a_loopfield, 5  ;; 得到tip:后面的内容
			if var_temp <>
			{
				∑空格按钮提示( var_temp )
				Return
			}
		}

		;; 带有冒号的选项太长，过滤掉
		IfInString a_loopfield, :
			Continue

		;; 数字开头的选项过滤掉
		if ( RegExMatch( a_loopfield, "\d" ) > 0 )
			Continue

		if var_options <>
			var_options = %var_options%|

		var_options = %var_options%%a_loopfield%
	}
	if var_options <>
		var_tip = 【%var_options%】
	var_tip = %var_tip%%var_value%

	∑空格按钮提示( var_tip )
}


∑检查按下的控制键()
{
	keys =
	if ( GetKeyState("ctrl","P") = 1 )
	{
		keys = %keys%^
	}
	if ( GetKeyState("Alt","P") = 1 )
	{
		keys = %keys%!
	}
	if ( GetKeyState("shift","P") = 1 )
	{
		keys = %keys%+
	}
	return keys
}

【定时清除空格按钮提示】:
	SetTimer 【定时清除空格按钮提示】, Off
	∑修改按键按钮的标题( ∑获取当前键盘名称(), "Space" )
	;GuiControl, Text, _key_Space, Space
	Return

【切换到默认键盘】:
	var_keyBoard := ∑获取当前键盘名称()
	if var_keyBoard <> 默认键盘
	{
		∑切换键盘( "默认键盘" )
	}
	Return


【切换到最近键盘】:
	var_keyBoard := ∑获取当前键盘名称()
	if var_keyBoard = 默认键盘
	{
		var_temp := ReadTempIni( "飞扬魔术键盘", "最近键盘" )
		if var_temp <>
			∑切换键盘( var_temp )
	}
	Return


【移动窗口】:
	g_bMoveWindow := !g_bMoveWindow
	;MsgBox g_bMoveWindow[%g_bMoveWindow%]
	if g_bMoveWindow
	{
		CoordMode, Mouse, Screen
		MouseGetPos, g_mouse_x0, g_mouse_y0
		WinGetPos , g_win_x0, g_win_y0, , , ahk_id %k_ID%
		SetTimer, 【定时器飞扬魔术键盘窗口跟随鼠标移动】, 100

		var_tip =
(
◇移动鼠标调整键盘窗口位置
◇按下鼠标左键停止移动窗口
◇空格键恢复窗口到默认位置
)
		TrayTip, 移动飞扬魔术键盘窗口, %var_tip%
		GuiControl, Text, _key_Space, 窗口跟随鼠标移动

		Hotkey, LButton, 【停止移动窗口】, On
		Hotkey, Space, 【移动窗口到默认位置】, On
	}
	Else
	{
		Gosub 【停止移动窗口】
	}
	Return


【停止移动窗口】:
	tooltip
	TrayTip
	g_bMoveWindow := false
	SetTimer, 【定时器飞扬魔术键盘窗口跟随鼠标移动】, off
	∑修改按键按钮的标题( ∑获取当前键盘名称(), "Space" )
	Hotkey, LButton, 【停止移动窗口】, Off
	Hotkey, Space, 【移动窗口到默认位置】, Off

	Return

【移动窗口到默认位置】:
	Gosub 【停止移动窗口】
	k_WindowX = %k_WorkAreaRight%
	k_WindowX -= %k_WorkAreaLeft% ; Now k_WindowX contains the width of this monitor.
	k_WindowX -= %k_WindowWidth%
	k_WindowX /= 2 ; Calculate position to center it horizontally.

	; The following is done in case the window will be on a non-primary monitor
	; or if the taskbar is anchored on the left side of the screen:
	k_WindowX += %k_WorkAreaLeft%

	; Calculate window's Y-position:
	k_WindowY = %k_WorkAreaBottom%
	k_WindowY -= %k_WindowHeight%

	WinMove, ahk_id %k_ID%,, %k_WindowX%, %k_WindowY%
	Return

【定时器飞扬魔术键盘窗口跟随鼠标移动】:
	;; 窗口移动过程中，按下鼠标左键停止移动
	if ( !g_bMoveWindow || is_key_down("LButton") )
	{
		Gosub 【停止移动窗口】
		Return
	}
	;; 窗口移动过程中，按下鼠标右键停止移动窗口，并且将窗口定位到默认位置
	if is_key_down("Ctrl")
	{
		Gosub 【停止移动窗口】
		Gosub 【移动窗口到默认位置】
		Return
	}

	CoordMode, Mouse, Screen
	MouseGetPos, g_mouse_x, g_mouse_y
	WinMove, ahk_id %k_ID%, , g_win_x0 + g_mouse_x - g_mouse_x0, g_win_y0 + g_mouse_y - g_mouse_y0
	Return

#Include ./inc/common.aik
#Include ./inc/inifile.aik
#Include ./inc/tip.aik
#Include ./inc/string.aik
#Include ./inc/cmdstring.aik
#Include ./inc/run.aik

#Include ./lib/autolable.aik

#Include ./subui/23编辑飞扬命令串.aik
#Include ./subui/22InputListBox.aik

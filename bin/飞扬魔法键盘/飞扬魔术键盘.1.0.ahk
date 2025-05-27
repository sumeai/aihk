/**
 *@file    ����ħ������.ahk
 *@author  teshorse
 *@date    2012.4.1
 *@brief   ����ħ�����̵�ʵ��
 *
 * ����ħ��������һ���ܹ����ٸ��ļ��̸������Ĺ��ܵĹ���
 *
 * ������־:
 * - V1.10
 * - ��������: RShift���л����̴�Сд״̬��
 * - ����һ��Bug������[,],\,/,'��Щ�������û�гɹ�ӳ�䵽��Ӧ�İ�ť���ƣ������µĴ���
 *
 * - V1.00
 * - ʵ�ַ���ħ�����̵Ļ�������
 */

g_version = V1.10

#SingleInstance force
FileInstall, KeyBoard.ini, %A_ScriptDir%\KeyBoard.ini

FileInstall, ��ɫ.ico, %A_ScriptDir%\��ɫ.ico
FileInstall, ������.ico, %A_ScriptDir%\������.ico
FileInstall, ��ɫ.ico, %A_ScriptDir%\��ɫ.ico
FileInstall, ��ɫ.ico, %A_ScriptDir%\��ɫ.ico
FileInstall, ��ɫ.ico, %A_ScriptDir%\��ɫ.ico
FileInstall, ��ɫ.ico, %A_ScriptDir%\��ɫ.ico
FileInstall, õ���.ico, %A_ScriptDir%\õ���.ico
FileInstall, ��ɫ.ico, %A_ScriptDir%\��ɫ.ico
FileInstall, ����.ico, %A_ScriptDir%\����.ico
FileInstall, ����.ico, %A_ScriptDir%\����.ico
FileInstall, ��ɫ.ico, %A_ScriptDir%\��ɫ.ico
FileInstall, ��ɫ.ico, %A_ScriptDir%\��ɫ.ico

FileInstall, ��ɫ.jpg, %A_ScriptDir%\��ɫ.jpg
FileInstall, ������.jpg, %A_ScriptDir%\������.jpg
FileInstall, ��ɫ.jpg, %A_ScriptDir%\��ɫ.jpg
FileInstall, ��ɫ.jpg, %A_ScriptDir%\��ɫ.jpg
FileInstall, ��ɫ.jpg, %A_ScriptDir%\��ɫ.jpg
FileInstall, ��ɫ.jpg, %A_ScriptDir%\��ɫ.jpg
FileInstall, õ���.jpg, %A_ScriptDir%\õ���.jpg
FileInstall, ��ɫ.jpg, %A_ScriptDir%\��ɫ.jpg
FileInstall, ����.jpg, %A_ScriptDir%\����.jpg
FileInstall, ����.jpg, %A_ScriptDir%\����.jpg
FileInstall, ��ɫ.jpg, %A_ScriptDir%\��ɫ.jpg
FileInstall, ��ɫ.jpg, %A_ScriptDir%\��ɫ.jpg

#Include ../../

;; ����: ��ʾ������|��������
;; ����: 1|Ĭ�ϼ���
g_keyBoard = %1%


;; ����ͼ��
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

g_bAutoPressBtn := true  	;; ���������ʱ���Ƿ�ͬʱ�Զ�ģ������Ӧ�İ�ť
g_bMoveWindow := false		;; ��ǰ�Ƿ����ƶ�����ħ�����̵�״̬
g_bShiftDown := false 		;; Shift��ť�Ƿ��ڰ���

; ��ǰʹ�õļ��̣������������û��KeyBoard.ini�����ļ���
; ��ӷ���ħ�����̳���Ŀ¼�µ�KeyBoard.ini���ƹ�ȥ
g_inifile = KeyBoard.ini
IfNotExist %g_inifile%
{
	IfExist %A_ScriptDir%\%g_inifile%
	{
		FileCopy, %A_ScriptDir%\%g_inifile%, %A_WorkingDir%\%g_inifile%
	}
}


g_iniContent := IniFileRead( g_inifile )


;---- End of configuration section. Don't change anything below this point
; unless you want to alter the basic nature of the script.

#include ./bin/����ħ������/GuiCreate.aik


�������ȼ�( )

return ; End of auto-execute section.


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; �˳���Ӧ���˳�֮ǰ�ȱ��浱ǰ���ڵ�λ�ã��Ա��´ζ�λ���˴���
GuiClose:
���˳��˵��:
���˳���:
	Gosub �����浱ǰ����λ�á�
ExitApp


�����浱ǰ����λ�á�:
	WinGetPos winx, winy, , , ahk_id %k_ID%
	WriteTempIni("����ħ������", g_keyBoard_name . "_winx", winx)
	WriteTempIni("����ħ������", g_keyBoard_name . "_winy", winy)
	Return



;---- When a key is pressed by the user, click the corresponding button on-screen:

~*Backspace::
	IfWinActive ��������
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
	IfWinActive ��������
		return

	;; ����������״̬ʱ��������Ƽ���ģ���û�������Ӧ�İ�ť
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
��LShift������Ӧ��:
	IfWinActive ��������
		return

	;; ����������״̬ʱ��������Ƽ���ģ���û�������Ӧ�İ�ť
	Gui submit, nohide
	if not _key_Setting
	{
		StringTrimLeft, g_ThisHotkey, A_ThisHotkey, 3
		ControlClick, %g_ThisHotkey%, ahk_id %k_ID%, , LEFT, 1, D
		KeyWait, %g_ThisHotkey%
		ControlClick, %g_ThisHotkey%, ahk_id %k_ID%, , LEFT, 1, U

		;; ˢ�°���״̬
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


;; ��Shift�����ڰ��»���Shift��ť�����л�g_bShiftDown��ֵ
~*RShift::
	IfWinActive ��������
		return

	;; ����������״̬ʱ��������Ƽ���ģ���û�������Ӧ�İ�ť
	Gui submit, nohide
	if _key_Setting
		Return

	;; Ĭ�ϼ��̵���Shift��������LShift����ͬ
	if g_keyBoard_name = Ĭ�ϼ���
		Goto ��LShift������Ӧ��

	g_bShiftDown := !g_bShiftDown
	��ˢ�½��水ť��ʾ( g_keyBoard_name )

	;; ˢ�°���״̬
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


��Shift��ť��Ӧ��:
	Return

��������Ӧ��:
	IfWinActive ahk_id %k_ID%
		return

	If g_bAutoPressBtn
	{
		StringReplace, g_ThisHotkey, A_ThisHotkey, ~
		StringReplace, g_ThisHotkey, g_ThisHotkey, *

		�ƻ�ð�����ť�ı���( g_keyBoard_name, g_ThisHotkey, var_keyName )


		GuiControlGet, g_ThisKeyName, , _key_%var_keyName%
		if g_ThisKeyName =
			g_ThisKeyName := g_ThisHotkey

		;tooltip7( "[" . g_ThisKeyName . "]" )
		SetTitleMatchMode, 3 ; Prevents the T and B keys from being confused with Tab and Backspace.

		;ToolTip %A_ThisHotkey% >>> %g_ThisKeyName%
		ControlClick, %g_ThisKeyName%, ahk_id %k_ID%, , LEFT, 1, D
		;KeyWait, %g_ThisHotkey%
		;ControlClick, %g_ThisKeyName%, ahk_id %k_ID%, , LEFT, 1, U

		��ִ�м��̰�����Ӧ( var_keyName )
	}
	Return

��ģ������ť��:
	IfWinActive ahk_id %k_ID%
		return

	IfWinActive ��������
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

����Ӧ�����ͷš�:
	;If g_bAutoPressBtn
	{
		StringReplace, g_ThisHotkey, A_ThisHotkey, ~
		StringReplace, g_ThisHotkey, g_ThisHotkey, *
		StringReplace, g_ThisHotkey, g_ThisHotkey, %A_Space%Up

		�ƻ�ð�����ť�ı���( g_keyBoard_name, g_ThisHotkey, var_keyName )
		GuiControlGet, g_ThisKeyName, , _key_%var_keyName%

		if g_ThisKeyName =
			g_ThisKeyName := g_ThisHotkey

		;tooltip7( "[" . g_ThisKeyName . "]" )
		SetTitleMatchMode, 3 ; Prevents the T and B keys from being confused with Tab and Backspace.
		ControlClick, %g_ThisKeyName%, ahk_id %k_ID%, , LEFT, 1, U
	}
	Return

����ʾ��������Ļ���̡�:
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




�����¼��ء�:
reload
return



������������Ӧ��:
	Gui submit, nohide
	����굥������( a_GuiControl )
	return



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; �Ҽ��˵�
�������Ҽ��˵���:
	;; ɾ����ǰ���Ҽ��˵�
	if g_bRightMenu
		Menu, RightMenu, DeleteAll
	Else
		g_bRightMenu := true

	;; �����µ��Ҽ��˵�
	Menu, RightMenu, Add, �������� &A, ���������̡�
	Menu, RightMenu, Add, �༭���� &E, ���÷���С�ֵ�༭���̡�
	Menu, RightMenu, Add, ���ؼ��� &H, ����ʾ��������Ļ���̡�
	Menu, RightMenu, Add, Ĭ��λ�� &D, ���ƶ����ڵ�Ĭ��λ�á�
	Menu, RightMenu, Add,
	Menu, RightMenu, Add, &0 Ĭ�ϼ���, ��ѡ����̡�

	var_keyboard := �ƻ�ȡ��ǰ��������()
	if var_keyboard = Ĭ�ϼ���
		Menu, RightMenu, Check, &0 Ĭ�ϼ���

	;; ���������б�
	var_temp := AllSecFromIniMem( g_inicontent )
	;MsgBox section = %var_temp%
	loop parse, var_temp, |
	{
		if a_loopfield =
			Continue

		if a_loopfield = Ĭ�ϼ���
			Continue

		var_line := A_LoopField
		var_menuitem = &%a_index% %var_line%
		Menu, RightMenu, Add, %var_menuitem%, ��ѡ����̡�

		if ( var_keyboard == var_line )
			Menu, RightMenu, Check, %var_menuitem%
	}
	Menu, RightMenu, Show
	Return

���������̡�:
	var_keyboard := myinput("��������","������Ҫ�½��ļ������ƣ�")
	if var_keyboard <>
	{
		if regexmatch(var_keyboard, "[\[\]]" ) > 0
		{
			MsgBox ���������в��ܰ��� ��[���� ��]����
			Return
		}
		var_colorList = ��ɫ|������|��ɫ|��ɫ|��ɫ|��ɫ|õ���|��ɫ|����|����|��ɫ|��ɫ
		var_keycolor =
		var_keycolor := InputListBox( var_colorList, "��ѡ�������ɫ" )
		write_ini( g_inifile, var_keyboard, "Color", var_keycolor )
		g_iniContent := IniFileRead( g_inifile )
		���л�����( var_keyboard )
	}
	Return

��ѡ����̡�:
	g_bAutoPressBtn := false
	var_menuitem := a_thismenuitem
	if RegExMatch( a_thismenuitem, "i)\&\d+\s+", var_match ) > 0
	{
		var_menuitem := SubStr( var_menuitem, StrLen(var_match)+1 )
	}
	���л�����( var_menuitem )
	g_bAutoPressBtn := true
	Return


����ѡSettingCheckBox��:
	Gui submit, nohide
	var_keyboard := �ƻ�ȡ��ǰ��������()
	if var_keyboard = Ĭ�ϼ���
	{
		MsgBox Ĭ�ϼ��̲��ܱ༭��
		Return
	}
	;; ģ����CheckBox
	bCheck := !_key_Setting
	Guicontrol, , _key_Setting, %bCheck%
	Gosub �����SettingCheckBox��

	;; ���shift���ڰ���״̬������֮
	GetKeyState, state, Shift
	if state = D
		send {shift up}

	Return

�����SettingCheckBox��:
	Gui submit, nohide
	if _key_Setting
	{
		;; ����ͼ�꣬���һ��������ʾ��Suspendʱ��ֹ����Ĭ�ϵ�Sͼ��
		change_icon( "����.ico", true, 1 )

		GuiControl , , _btn_setting, ����
		GuiControl , , _SidePic, %g_keyBoard_setpic%
		GuiControl , -Right, _toptext
		GuiControl , , _toptext, �� %g_keyBoard_name% �� ���ڱ༭״̬(Alt+RShift����)���ȼ�����ͣ��

		;; ȡ������͸��
		WinSet, TransColor, %TransColor% 255, ahk_id %k_ID%

		;�������ȼ�( false )
		Suspend On

		;; �ػ�GroupBox�������Ϸ�������_toptext�ڸ�
		GuiControl, , _GroupBox,
		Sleep 10
		GuiControl, , _GroupBox,
	}
	Else
	{
		var_color := �ƻ�ȡ��ǰ������ɫ()

		var_icon = %var_color%.ico
		change_icon( var_icon, True )

		GuiControl , , _btn_setting, ����
		GuiControl , , _SidePic, %g_keyBoard_sidepic%
		GuiControl, +Right, _toptext
		GuiControl , , _toptext, �� %g_keyBoard_name% ��

		;; ʹ����͸��
		WinSet, TransColor, %TransColor% 200, ahk_id %k_ID%

		;�������ȼ�( true )
		Suspend Off

		;; �ػ�GroupBox�������Ϸ�������_toptext�ڸ�
		GuiControl, , _GroupBox,
		Sleep 10
		GuiControl, , _GroupBox,

	}
	Return


���÷���С�ֵ�༭���̡�:
	var_root := �ƻ�ȡ��Ŀ¼()
	var_file = %var_root%\bin\dict\dict.ahk

	var_param = 
		(Ltrim
		file:keyboard.ini
		title:�༭����ħ������
		cursec:%g_keyboard%
		)

	run_ahk( var_file, var_param, a_workingdir )
	Return


����Ӧ������Ӧ���ȼ���:

	Return


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; ����
����굥������( key_, bForce = false )
{
	global g_keyBoard, _key_Setting, k_ID, g_bAutoPressBtn, g_bShiftDown

	;; ֻ�����������Ļ�����ϵİ�ť���������
	if not bForce
	{
		MouseGetPos, OutputVarX, OutputVarY, OutputVarWin, OutputVarControl, 1
		if ( k_ID != OutputVarWin )
		{
			;MsgBox k_ID[%k_ID%] != [%OutputVarWin%]OutputVarWin
			Return
		}
	}

	;; ��key_ = _key_a �����_key_�����a, ������a��
	if RegExMatch( key_, "i)(?<=_key_).*$", var_key ) <= 0
		return false

	if var_key =
		return false

	;; ����Ƿ��¿��Ƽ�
	var_ctrlkey := �Ƽ�鰴�µĿ��Ƽ�()
	if var_ctrlkey <>
		var_key = %var_ctrlkey%%var_key%

	;; ���Shift�����£�var_keyҪ����Shift����+
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

	;; ��ѡ������״̬��ѡ�򣬽���༭״̬
	if _key_Setting
	{
		;; if g_bAutoPressBtn == false ˵������������ť���ڱ༭״̬
		if g_bAutoPressBtn
		{
			�Ʊ༭����( var_key )
		}
	}
	else
		��ִ�а���( var_key )

	return true
}

;; ����key_�Ǵ�_key_a�з��������a
;; ͨ�������ť����CmdString�༭��Ϊ��Ӧ�İ�ť����CmdString�����ʱ��ͬʱ���¿��Ƽ�
�Ʊ༭����( key_ )
{
	local var_temp, var_value, cmdstr, var_key, var_keyboard, var_opt, var_match
	if key_ =
		Return

	var_keyboard := �ƻ�ȡ��ǰ��������()
	if var_keyboard = Ĭ�ϼ���
	{
		Return ;; Ĭ�ϼ��̣��������༭
	}
	g_bAutoPressBtn := false
	var_value := FindFromIniMem( g_inicontent, var_keyboard, key_, "" )
	var_temp = %key_% =
	cmdstr := �Ʊ༭�������( var_value, var_temp )
	if cmdstr <>
	{
		if cmdstr = $space$
			cmdstr =
		var_value := cmdstr
		;; �������õļ���ֵ���浽�����ļ���
		write_ini( g_inifile, var_keyboard, key_, var_value )
		g_iniContent := IniFileRead( g_inifile )
		;; �޸İ�ť����ʾ����
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

;; ͨ�������ťִ��cmdStr��Enter/Tab/BackSpace/Space��Ч
��ִ�а���( key_ )
{
	local var_keyboard, var_temp, cmdstr

	cmdstr =
	var_keyboard := �ƻ�ȡ��ǰ��������()
	if var_keyboard <> Ĭ�ϼ���
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

;; ͨ���ȼ�ִ��cmdStr��Enter/Tab/BackSpace/Space��ʧЧ
��ִ�м��̰�����Ӧ( Hotkey_ )
{
	local cmdstr, var_keyboard, keyname, var_tip, var_ctrlkey


	StringReplace, Hotkey_, Hotkey_, ~
	StringReplace, Hotkey_, Hotkey_, *

	if Hotkey_ =
		Return

	var_keyboard := �ƻ�ȡ��ǰ��������()

	;; ����Ƿ��¿��Ƽ�
	var_ctrlkey := �Ƽ�鰴�µĿ��Ƽ�()
	if var_ctrlkey <>
		Hotkey_ = %var_ctrlkey%%Hotkey_%

	;; ���Shift�����£���Hotkey_ǰҪ����Shift����+
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
	if FindCmdOpt( var_opt, "BeforePress:", &var_value )
	{
		KeyboardCommand( var_value )
	}
	run_cmd( cmdstr_ )
	if FindCmdOpt( var_opt, "AfterPress:", &var_value )
	{
		KeyboardCommand( var_value )
	}
}




;; ��Button�ı�����(���磺_key_fxg��fxg)���õ���Ӧ�İ�ť����(���磺\)
ValnameToKeyname( valname_ )
{
	;; ���������������_key_ǰ׺��������_key_�������ĸ��Ϊ��������var_key
	if RegExMatch( valname_, "i)(?<=_key_).*$", var_key ) <= 0
		var_key := valname_  ;; ����_key_ǰ׺��ֱ�ӽ���������valname_��Ϊvar_key

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

�ƻ�ȡ��ǰ��������()
{
	global
	if g_keyboard =
		return "Ĭ�ϼ���"
	return g_keyboard
}

�ƻ�ȡ��ǰ������ɫ()
{
	local var_color
	var_color := FindFromIniMem( g_inicontent, g_keyboard, "Color" )
	if var_color =
		var_color = ��ɫ

	return var_color
}

;; ��õ�ǰ���̵���ɫ
GetKeyboardColor()
{
	local var_color
	var_color := FindFromIniMem( g_inicontent, g_keyboard, "Color" )
	if var_color = ��ɫ
		var_color = FF8000
	else if var_color = ������
		var_color = DA70D6
	else if var_color = ��ɫ
		var_color = Red
	else if var_color = ��ɫ
		var_color = FFD700
	else if var_color = ��ɫ
		var_color = Blue
	else if var_color = ��ɫ
		var_color = 00FF00
	else if var_color = õ���
		var_color = B03060
	else if var_color = ��ɫ
		var_color = 03A89E
	else if var_color = ����
		var_color = 87CEEB
	else if var_color = ��ɫ
		var_color = Gray
	else if var_color = ��ɫ
		var_color = 6A5ACD
	else
		var_color =
	return var_color
}



�ƻ�ȡ��ǰ����ͼ��()
{
	local var_color, var_icon
	var_color := FindFromIniMem( g_inicontent, g_keyboard, "Color" )
	if var_color =
		var_color = ��ɫ

	var_icon = %A_ScriptDir%/%var_color%.ico
	return var_icon
}



�ƻ�ð�����ť�ı���( keyBoard_, keyChar_, ByRef _keyname_ )
{
	local keyName, var_temp, var_opt, var_match, caption_, shiftKeyName

	;; ���� keyChar_ �õ� ������Ӧ��ť������
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

	;; ���û��ָ����ť���⣬��������ļ��в���

	caption_ := keyChar_


	if keyBoard_ <> Ĭ�ϼ���
	{
		;; ���Shift�������ڰ���״̬�����л���
		if g_bShiftDown
		{
			shiftKeyName = +%keyName%
			var_temp := FindFromIniMem( g_iniContent, keyBoard_,  shiftKeyName, "" )

			;; ���û���ҵ���ӦShift���µļ�����δ����name���ԣ���ʹ��û��Shift�ļ���
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



���޸İ�����ť�ı���( keyBoard_, keyChar_, caption_="" )
{
	local var_caption, keyName
	;; Ϊ������ť���ñ���
	var_caption := �ƻ�ð�����ť�ı���( keyBoard_, keyChar_, keyName )
	if caption_ =
		caption_ := var_caption
	GuiControl, Text, _key_%keyName%, %caption_%
}


��ˢ�½��水ť��ʾ( var_keyboard )
{
	local k_n = 1
	local k_ASCII = 45
	local keyCaption, keyName            ;; ���̱���
	local var_opt, var_temp, var_match


	;; Ĭ�ϼ�����ʾ
	if var_keyboard =
		var_keyboard = Ĭ�ϼ���



	Loop
	{
		;; - . / 0 1 2 3 4 5 6 7 8 9 : ; = ? @ A B C D E F G H I J K L M N O P Q R S T U V W X Y Z [ \ ]
		Transform, k_char, Chr, %k_ASCII%
		StringUpper, k_char, k_char
		if k_char not in <,>,^,~,?,`,
		{
			���޸İ�����ť�ı���( var_keyboard, k_char )
		}
	    ; In the above, the asterisk prefix allows the key to be detected regardless
	    ; of whether the user is holding down modifier keys such as Control and Shift.
		if k_ASCII = 93
		   break
		k_ASCII++
	}
	;; ˢ�����ⰴť�ı���
	���޸İ�����ť�ı���( var_keyboard, "," )
	���޸İ�����ť�ı���( var_keyboard, "Bs" )
	���޸İ�����ť�ı���( var_keyboard, "Tab" )
	���޸İ�����ť�ı���( var_keyboard, "Enter" )
	���޸İ�����ť�ı���( var_keyboard, "Space" )

	���޸İ�����ť�ı���( var_keyboard, "'" )
}



���л�����( keyboard_ )
{
	local var_temp, var_color
	if keyboard_ =
		keyboard_ = Ĭ�ϼ���

	if ( g_keyboard == keyboard_  )
	{
		return false      ;; ��ͬ���̣������л�
	}
	;; �������ļ����������ɼ����б�
	var_temp := AllSecFromIniMem( g_inicontent )  ;; ���еļ����б�����|�ָ�

	;; ���ָ���ļ��̴��ڣ����л�֮
	if ( keyboard_=="Ĭ�ϼ���" || InStrList( var_temp, keyboard_, "|" ) > 0 )
	{
		Gosub �����浱ǰ����λ�á�

		;; ���´򿪳���ʵ�ּ����л�
		var_root := �ƻ�ȡ��Ŀ¼()
		var_file = %var_root%\bin\����ħ������\����ħ������.ahk
		run_ahk( var_file, keyboard_ )

		return true
	}
	return false
}


�������ȼ�( bActive=true )
{
	keyBoard_name := �ƻ�ȡ��ǰ��������()
	if keyBoard_name = Ĭ�ϼ���
		bUsers := False
	Else
		bUsers := true

	;; ����������ȼ�
	flag := bActive ? "On" : "Off"

	;---- Set all keys as hotkeys. See www.asciitable.com
	k_n = 1
	k_ASCII = 45

	;; ����93�����̰�ť����Ӧ�ȼ�
	Loop
	{
		Transform, k_char, Chr, %k_ASCII%
		StringUpper, k_char, k_char
		if k_char not in <,>,^,~,?`,
		{
			if bUsers
			{
				;; ���ʹ�÷�Ĭ�ϼ��̣�������������ȼ���ʹ���û��Զ����CMDString
				Hotkey, *%k_char%, ��������Ӧ��, %flag%
				Hotkey, ~*%k_char% up, ����Ӧ�����ͷš�, %flag%
			}
			Else
			{
				;; ���ʹ�õ���Ĭ�ϼ��̣����ģ���õ�����ť�����������û�������ȼ�
				Hotkey, ~*%k_char% , ��ģ������ť��, %flag%
			}
		}
	   ; In the above, the asterisk prefix allows the key to be detected regardless
	   ; of whether the user is holding down modifier keys such as Control and Shift.
		if k_ASCII = 93
		   break
		k_ASCII++
	}

	;; �������ļ�AutoHotString.ini��[ȫ���ȼ�]����
	;; Ѱ�ҹؼ��֡���ѡ�����ħ�����̡������ȼ�ֵ��������Ϊ�л����ʹ�ü��̵Ŀ�ݼ�
	IniRead, var_ChangeHK, AutoHotString.ini, ȫ���ȼ�,��ѡ�����ħ�����̡�, 1)AppsKey & Space
	var_ChangeHK := cmdStringSplit( var_ChangeHK, var_opt )
	if var_ChangeHK =
		var_ChangeHK = AppsKey & Space

	;; ���������ȼ�����Ӧ
	if bUsers
	{
		Hotkey, *`,, 		��������Ӧ��, %flag%
		Hotkey, *', 		��������Ӧ��, %flag%
		;Hotkey, *Space, 	��������Ӧ��, %flag%
		;Hotkey, *Enter, 	��������Ӧ��, %flag%
		;Hotkey, *Tab, 		��������Ӧ��, %flag%

		Hotkey, ~*`, up, 		����Ӧ�����ͷš�, %flag%
		Hotkey, ~*' up, 		����Ӧ�����ͷš�, %flag%
		;Hotkey, ~*Space up, 	����Ӧ�����ͷš�, %flag%
		;Hotkey, ~*Enter up, 	����Ӧ�����ͷš�, %flag%
		;Hotkey, ~*Tab up, 	����Ӧ�����ͷš�, %flag%

		Hotkey, %var_ChangeHK%, ���л���Ĭ�ϼ��̡�, On
	}
	Else
	{
		Hotkey, ~*`,, 		��ģ������ť��, %flag%
		Hotkey, ~*', 		��ģ������ť��, %flag%
		;Hotkey, ~*Space, 	��ģ������ť��, %flag%
		;Hotkey, ~*Enter, 	��ģ������ť��, %flag%
		;Hotkey, ~*Tab, 	��ģ������ť��, %flag%
		Hotkey, %var_ChangeHK%, ���л���������̡�, On
	}
	Hotkey, ~*Space, 	��ģ������ť��, %flag%
	Hotkey, ~*Enter, 	��ģ������ť��, %flag%
	Hotkey, ~*Tab, 	��ģ������ť��, %flag%
	Hotkey, !RShift, 	����ѡSettingCheckBox��, On
}


�ƿո�ť��ʾ( var_tip )
{
	global
	GuiControl, Text, _key_Space, %var_tip%
	SetTimer ����ʱ����ո�ť��ʾ��, 1000
}

;; ��cmdstr_��ѡ�����̺���ʾ
TipCmdString( cmdstr_ )
{
	var_options =
	var_value := cmdStringSplit( cmdstr_, var_opt )
	loop parse, var_opt, |
	{
		;; �����tip:ѡ���ֱ����ʾTip�����ݣ�������ʾ����ѡ����cmdstring
		if InStr( a_loopfield, "tip:", false ) > 0
		{
			StringMid, var_temp, a_loopfield, 5  ;; �õ�tip:���������
			if var_temp <>
			{
				�ƿո�ť��ʾ( var_temp )
				Return
			}
		}

		;; ����ð�ŵ�ѡ��̫�������˵�
		IfInString a_loopfield, :
			Continue

		;; ���ֿ�ͷ��ѡ����˵�
		if ( RegExMatch( a_loopfield, "\d" ) > 0 )
			Continue

		if var_options <>
			var_options = %var_options%|

		var_options = %var_options%%a_loopfield%
	}
	if var_options <>
		var_tip = ��%var_options%��
	var_tip = %var_tip%%var_value%

	�ƿո�ť��ʾ( var_tip )
}


�Ƽ�鰴�µĿ��Ƽ�()
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

����ʱ����ո�ť��ʾ��:
	SetTimer ����ʱ����ո�ť��ʾ��, Off
	���޸İ�����ť�ı���( �ƻ�ȡ��ǰ��������(), "Space" )
	;GuiControl, Text, _key_Space, Space
	Return

���л���Ĭ�ϼ��̡�:
	var_keyBoard := �ƻ�ȡ��ǰ��������()
	if var_keyBoard <> Ĭ�ϼ���
	{
		���л�����( "Ĭ�ϼ���" )
	}
	Return


���л���������̡�:
	var_keyBoard := �ƻ�ȡ��ǰ��������()
	if var_keyBoard = Ĭ�ϼ���
	{
		var_temp := ReadTempIni( "����ħ������", "�������" )
		if var_temp <>
			���л�����( var_temp )
	}
	Return


���ƶ����ڡ�:
	g_bMoveWindow := !g_bMoveWindow
	;MsgBox g_bMoveWindow[%g_bMoveWindow%]
	if g_bMoveWindow
	{
		CoordMode, Mouse, Screen
		MouseGetPos, g_mouse_x0, g_mouse_y0
		WinGetPos , g_win_x0, g_win_y0, , , ahk_id %k_ID%
		SetTimer, ����ʱ������ħ�����̴��ڸ�������ƶ���, 100

		var_tip =
(
���ƶ����������̴���λ��
����������ֹͣ�ƶ�����
��ո���ָ����ڵ�Ĭ��λ��
)
		TrayTip, �ƶ�����ħ�����̴���, %var_tip%
		GuiControl, Text, _key_Space, ���ڸ�������ƶ�

		Hotkey, LButton, ��ֹͣ�ƶ����ڡ�, On
		Hotkey, Space, ���ƶ����ڵ�Ĭ��λ�á�, On
	}
	Else
	{
		Gosub ��ֹͣ�ƶ����ڡ�
	}
	Return


��ֹͣ�ƶ����ڡ�:
	tooltip
	TrayTip
	g_bMoveWindow := false
	SetTimer, ����ʱ������ħ�����̴��ڸ�������ƶ���, off
	���޸İ�����ť�ı���( �ƻ�ȡ��ǰ��������(), "Space" )
	Hotkey, LButton, ��ֹͣ�ƶ����ڡ�, Off
	Hotkey, Space, ���ƶ����ڵ�Ĭ��λ�á�, Off

	Return

���ƶ����ڵ�Ĭ��λ�á�:
	Gosub ��ֹͣ�ƶ����ڡ�
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

����ʱ������ħ�����̴��ڸ�������ƶ���:
	;; �����ƶ������У�����������ֹͣ�ƶ�
	if ( !g_bMoveWindow || is_key_down("LButton") )
	{
		Gosub ��ֹͣ�ƶ����ڡ�
		Return
	}
	;; �����ƶ������У���������Ҽ�ֹͣ�ƶ����ڣ����ҽ����ڶ�λ��Ĭ��λ��
	if is_key_down("Ctrl")
	{
		Gosub ��ֹͣ�ƶ����ڡ�
		Gosub ���ƶ����ڵ�Ĭ��λ�á�
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

#Include ./subui/23�༭�������.aik
#Include ./subui/22InputListBox.aik

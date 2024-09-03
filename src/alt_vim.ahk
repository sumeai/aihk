#include ../include/clipboard.ahk

<!h::send "{left}"
<!l::send "{right}"
<!k::send "{up}"
<!j::send "{down}"
!4::send "{end}"
!0::send "{home}"
!o::    ;; 换行
{
    send "{end}"
    sleep 50
    send "{enter}"
}


;; 左ALT+按键，输出英文字符
;; 右Shift+按键，输出对应的
<!,::SendBy_clipboard(",")        ;; 左ALT+, 输出英文逗号,
>+,::SendBy_clipboard("<")

<!;::SendBy_clipboard(";")        ;; 左ALT+; 输出英文分号;
>+;::SendBy_clipboard(":")

<!.::SendBy_clipboard(".")        ;; 左ALT+. 输出英文句号.
>+.::SendBy_clipboard(">")

<!'::SendBy_clipboard("'")
>+'::SendBy_clipboard('"')
>!':: {
    select_text := GetSelectTextOrClipboard_clipboard()
    SendBy_clipboard('`"' . select_text . '`"')
}

<![::SendBy_clipboard('[')
<!]::SendBy_clipboard(']')
>![:: {
    select_text := GetSelectTextOrClipboard_clipboard()
    SendBy_clipboard('[' . select_text . ']')
}
>!]:: {
    select_text := GetSelectTextOrClipboard_clipboard()
    SendBy_clipboard('{' . select_text . '}')
}

>!`:: {
    select_text := GetSelectTextOrClipboard_clipboard()
    SendBy_clipboard('``' . select_text . '``')
}


>+[::SendBy_clipboard('{')
>+]::SendBy_clipboard('}')

<!\::SendBy_clipboard('\')
<!/::SendBy_clipboard('/')
>+/::SendBy_clipboard('?')
<!=::SendBy_clipboard('=')
>+=::SendBy_clipboard('+')
<!-::SendBy_clipboard('-')
>+-::SendBy_clipboard('_')


<!`::SendBy_clipboard('``')
>+`::SendBy_clipboard('~')
>+1::SendBy_clipboard('!')
>+2::SendBy_clipboard('@')
>+3::SendBy_clipboard('#')
>+4::SendBy_clipboard('$')
>+5::SendBy_clipboard('%')
>+6::SendBy_clipboard('^')
>+7::SendBy_clipboard('&')
>+8::SendBy_clipboard('*')
>+9::SendBy_clipboard('(')
>+0::SendBy_clipboard(')')
>!9:: {
    select_text := GetSelectTextOrClipboard_clipboard()
    SendBy_clipboard('(' . select_text . ')')
}



;; 最大化选中的字符串，没有选中则最大化剪贴板的内容
>!u::
{
    clip := StrUpper(GetSelectTextOrClipboard_clipboard())
    sendtext clip
}

;; 最小化选中的字符串，没有选中则最小化剪贴板的内容
>!l::
{

    clip := StrLower(GetSelectTextOrClipboard_clipboard())
    sendtext clip
}


;; 标题化选中的字符串，没有选中则标题化剪贴板的内容
>!t::
{

    clip := StrTitle(GetSelectTextOrClipboard_clipboard())
    sendtext clip
}






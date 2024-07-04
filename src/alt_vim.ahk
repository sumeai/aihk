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






#include ../../include/clipboard.ahk


arroundwith(_left, _right)
{
    clip := _left . GetSelectTextOrClipboard_clipboard() . _right
    SendBy_clipboard(clip)
}




#Hotif Winactive(".pu ahk_exe Code.exe")



:?*:usec;::
{
    send 'usecase "" as UC'
    en_input()
}

:?*:actor;::
{
    send 'actor "" as A'
    en_input()
}



:?*:cnote;:: \n<color:lightgray>

#Hotif Winactive(".html")

!s::
{
    arroundwith('<slot>', '</slot>')
}


^1::
{
    arroundwith('<h1>', '</h1>')
}

^2::
{
    arroundwith('<h2>', '</h2>')
}

^3::
{
    arroundwith('<h3>', '</h3>')
}


^4::
{
    arroundwith('<h4>', '</h4>')
}


!t::
{
    arroundwith('<template id="">`n', '`n</template>')

}


!p::
{
    arroundwith('<p optional>`n', '`n</p>')
}


#Hotif 

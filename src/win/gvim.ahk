
#Hotif Winactive("ahk_class Vim")

;; 在VIM中，Alt+S 实现 保存 功能
!s::
{
send("{esc}")
PostMessage 0x0050, 0, 0x4090409,, "A" 
sleep 100
send(":w")
sleep 100
send("{enter}")
}



;; 在VIM中，Alt+V 实现 粘贴 功能
!v::
{
send("{esc}")
sleep 100
send("p")
}

#Hotif

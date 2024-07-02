#include ../include/system_cursor.ahk
#include ../include/switch_keyboad.ahk

;; 切换英文输入法
::;e::
::;en::
:?*:en;::
{
    en_input()
}
:?*:en``;::en`;  ;; en;已经定义为切换中文输入法，要输入en;字符串请用热词en`;



;; 切换中文输入法

::;c::
::;cn::
:?*:cn;::
{
    cn_input()
}
:?*:cn``;::cn`;  ;; cn;已经定义为切换中文输入法，要输入cn;字符串请用热词cn`;


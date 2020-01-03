#cs ----------------------------------------------------------------------------

 AutoIt Version: 3.3.14.5
 Author:         myName

 Script Function:
	Template AutoIt script.

#ce ----------------------------------------------------------------------------

; Script Start - Add your code below here
#include "extends\SysExtend.au3"

_Main()

Exit 1 ;返回成功标示


Func _Main()

	_RunDefault()

	_Install()

EndFunc

Func _Install()
	WinWaitActive("GBES客户端驱动","下一步(&N) >")
	Send("!n")
	WinWaitActive("GBES客户端驱动","选择安装位置")
	Send("!n")
	WinWaitActive("GBES客户端驱动","安装(&I)")
	Send("!i")
	WinWaitActive("GBES客户端驱动","完成(&F)")
	Send("!f")
EndFunc
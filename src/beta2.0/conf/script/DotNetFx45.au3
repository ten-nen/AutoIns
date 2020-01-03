#cs ----------------------------------------------------------------------------

 AutoIt Version: 3.3.14.5
 Author:         myName

 Script Function:
	Template AutoIt script.

#ce ----------------------------------------------------------------------------

; Script Start - Add your code below here
#include "extends\SysExtend.au3"

Main()

Exit 1 ;返回成功标示


Func Main()

	RunDefault()

	Install()

EndFunc

Func Install()
	WinWaitActive("Microsoft .NET Framework 4.5.2","我已阅读并接受许可条款(&A)。")
	$aPosition=ControlGetPos("Microsoft .NET Framework 4.5.2","我已阅读并接受许可条款(&A)。","Button3")
	MouseClick("left", $aPosition[0], $aPosition[1])
	WinWaitActive("Microsoft .NET Framework 4.5.2","安装(&I)")
	Send("!i")
	WinWaitActive("Microsoft .NET Framework 4.5.2","安装完毕")
	Send("!f")
EndFunc

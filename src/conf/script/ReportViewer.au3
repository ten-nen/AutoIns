#cs ----------------------------------------------------------------------------

 AutoIt Version: 3.3.14.5
 Author:         myName

 Script Function:
	Template AutoIt script.

#ce ----------------------------------------------------------------------------

; Script Start - Add your code below here
#include "extends\InsExtend.au3"
#include "extends\ExitCode.au3"

_Main()

Exit $EXIT_SUCCESS ;返回成功标示


Func _Main()

	_RunDefault()

	_Install()

EndFunc

Func _Install()
	WinWaitActive("Microsoft ReportViewer 2010 Redistributable 安装程序","下一步(&N) >")
	Send("!n")
	$aPosition=ControlGetPos("Microsoft ReportViewer 2010 Redistributable 安装程序","我已阅读并接受许可条款(&A)。","Button3")
	MouseClick("left", $aPosition[0], $aPosition[1])
	WinWaitActive("Microsoft ReportViewer 2010 Redistributable 安装程序","安装(&I)")
	Send("!i")
	WinWaitActive("Microsoft ReportViewer 2010 Redistributable 安装程序","完成(&F)")
	Send("!f")
EndFunc
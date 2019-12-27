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
	WinWaitActive("","Next")
	Send("{ENTER}")
	WinWaitActive("","Next")
	Send("{ENTER}")
	WinWaitActive("","I have read and accept the terms of the Developer Express License Agreement.")
	$aPosition=ControlGetPos("","","TcpCheckBox1")
	MouseClick("left", $aPosition[0], $aPosition[1])
	;MouseClick("left", 210, 430)
	WinWaitActive("","Next")
	Send("{ENTER}")
	WinWaitActive("","Install")
	Send("{ENTER}")
	WinWaitActive("","Finish")
	$aPosition=ControlGetPos("","Launch the DevExpress Demo Center","TcxCheckBox1")
	MouseClick("left", $aPosition[0], $aPosition[1])
	Sleep(500)
	Send("{ENTER}")
EndFunc
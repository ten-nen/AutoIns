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
	WinWaitActive("Setup - Redis","Welcome to the Redis Setup Wizard")
	Send("{ENTER}")
	WinWaitActive("Setup - Redis","License Agreement")
	$aPosition=ControlGetPos("Setup - Redis","I &accept the agreement","TNewRadioButton1")
	MouseClick("left", $aPosition[0], $aPosition[1])
	WinWaitActive("Setup - Redis","Next >")
	Send("{ENTER}")
	WinWaitActive("Setup - Redis","Select Destination Location")
	Send("D:\Program Files\Redis",0)
	Send("{ENTER}")
	WinWaitActive("Setup - Redis","Select Start Menu Folder")
	Send("{ENTER}")
	WinWaitActive("Setup - Redis","Ready to Install")
	Send("{ENTER}")
	WinWaitActive("Setup - Redis","Completing the Redis Setup Wizard")
	$aPosition=ControlGetPos("Setup - Redis","","TNewCheckListBox1")
	MouseClick("left", $aPosition[0], $aPosition[1])
	Send("{ENTER}")
EndFunc
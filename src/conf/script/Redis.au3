#cs ----------------------------------------------------------------------------

 AutoIt Version: 3.3.14.5
 Author:         myName

 Script Function:
	Template AutoIt script.

#ce ----------------------------------------------------------------------------

; Script Start - Add your code below here

Main()

Exit 1 ;返回成功标示


Func Main()

	Opt("MouseCoordMode", 2); 设置激活窗口的相对坐标位置
	Opt("MouseClickDelay", 500); 设置鼠标点击次数的间隔时长为0.5s

	Local $sFilePath=""
	If Ubound($CmdLine) > 1 Then $sFilePath=$CmdLine[1]
	If $sFilePath="" Then Exit ;获取文件路径

	Install($sFilePath)

EndFunc

Func Install($sFilePath)
	$iResult=Run($sFilePath)
	If Not $iResult Then Exit ;运行文件失败则退出

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
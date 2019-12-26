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
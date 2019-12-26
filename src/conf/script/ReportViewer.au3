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

	WinWaitActive("Microsoft ReportViewer 2010 Redistributable 安装程序","下一步(&N) >")
	Send("!n")
	$aPosition=ControlGetPos("Microsoft ReportViewer 2010 Redistributable 安装程序","我已阅读并接受许可条款(&A)。","Button3")
	MouseClick("left", $aPosition[0], $aPosition[1])
	WinWaitActive("Microsoft ReportViewer 2010 Redistributable 安装程序","安装(&I)")
	Send("!i")
	WinWaitActive("Microsoft ReportViewer 2010 Redistributable 安装程序","完成(&F)")
	Send("!f")
EndFunc
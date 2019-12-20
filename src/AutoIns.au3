#cs ----------------------------------------------------------------------------

 AutoIt Version: 3.3.14.5
 Author:         Ten'nen

 Script Function:
	Template AutoIt script.

#ce ----------------------------------------------------------------------------

; Script Start - Add your code below here

#Region ;**** 编译指令由 by AutoIt3Wrapper_GUI 创建 ****
#AutoIt3Wrapper_Version=Beta
#AutoIt3Wrapper_Icon=l.ico
#AutoIt3Wrapper_Res_Comment=解放你的双手..
#AutoIt3Wrapper_Res_Description=解放你的双手..
#AutoIt3Wrapper_Res_Fileversion=1.0.0.0
#AutoIt3Wrapper_Res_ProductVersion=v1.0
#AutoIt3Wrapper_Res_CompanyName=Ten'nen
#AutoIt3Wrapper_Res_LegalCopyright=Ten'nen
#AutoIt3Wrapper_Res_LegalTradeMarks=Ten'nen
#AutoIt3Wrapper_Res_Language=2052
#EndRegion ;**** 编译指令由 by AutoIt3Wrapper_GUI 创建 ****
#Region ;**** 编译指令由 by AutoIt3Wrapper_GUI 创建 ****
#EndRegion ;**** 编译指令由 by AutoIt3Wrapper_GUI 创建 ****
#include <MsgBoxConstants.au3>
#include <WinAPIFiles.au3>
#include <Process.au3>
#include <File.au3>

Local Const $sConfigPath =@ScriptDir&"\conf\AutoIns.ini"
Local $aInstallArray
Local $hFile = FileOpen(@ScriptDir & "\install.log", 1)


Main()


;func
Func Main()
	If Not IsAdmin() Then
		MsgBox($MB_SYSTEMMODAL,"提示信息","请使用管理员权限运行！")
		Exit
	EndIf

	Load_Config()

	Install_Run()
EndFunc

Func Load_Config()
	_FileWriteLog($hFile, "开始加载配置文件..")
	$iFileExists = FileExists($sConfigPath)
	If Not $iFileExists Then
		;MsgBox($MB_SYSTEMMODAL,"系统提示","未找到配置文件！")
		_FileWriteLog($hFile, "未找到配置文件，自动化安装退出！")
		FileClose($hFile)
		Exit
	EndIf

	$aInstallArray = IniReadSection($sConfigPath, "Install")
	If @error Then
		_FileWriteLog($hFile, "加载配置文件出错，自动化安装退出！")
		FileClose($hFile)
		Exit
	EndIf
	_FileWriteLog($hFile, "加载配置文件完毕..")
EndFunc

Func Install_Run()
    ;BlockInput($BI_DISABLE) ; 禁用用户的鼠标和键盘输入
	Opt("MouseCoordMode", 2); 设置激活窗口的相对坐标位置
	Opt("MouseClickDelay", 500); 设置鼠标点击次数的间隔时长为0.5s

	For $i = 1 To $aInstallArray[0][0]
		_FileWriteLog($hFile, $aInstallArray[$i][0]&" 开始处理..")
		If $aInstallArray[$i][1]=="auto" Then
			AutoRun($aInstallArray[$i][0])
		ElseIf $aInstallArray[$i][1]=="bat" Then
			BatRun($aInstallArray[$i][0])
		EndIf
		_FileWriteLog($hFile, $aInstallArray[$i][0]&" 处理完成..")
		Sleep(1500)
	Next

	;BlockInput($BI_ENABLE) ; 启用户鼠标和键盘输入
	MsgBox($MB_SYSTEMMODAL,'提示信息','自动化安装完成..')
	_FileWriteLog($hFile, "自动化安装完成..")
	FileClose($hFile)
	Exit
EndFunc

Func AutoRun($sType)
	Switch $sType
		Case "DotNetFx45"
			Install_DotNexFx45()
		Case "ReportViewer"
			Install_ReportViewer()
		Case "GBESClient"
			Install_GBESClient()
		Case "Redis"
			Install_Redis()
		Case "DXperience"
			Install_DXperience()
	EndSwitch
EndFunc

Func BatRun($sType)
	$iResult=_RunDos(@ScriptDir&"\conf\"&$sType&".bat")
	If $iResult<>0 Then
		;MsgBox($MB_SYSTEMMODAL,"提示信息","IIS安装失败！")
		_FileWriteLog($hFile, $sType&".bat 处理失败，自动化安装退出！ ")
		FileClose($hFile)
		Exit
	EndIf
EndFunc

Func BatRunObsolete($sType)
	$aCmdLines=FileReadToArray(@ScriptDir&"\conf\"&$sType&".bat")
	$iLineCount = @extended
	If @error Then
		_FileWriteLog($hFile, $sType&".bat 文件读取出错，自动化安装退出！")
		FileClose($hFile)
		Exit
	EndIf
	For $i = 0 To $iLineCount - 1 ;
		$iResult=0
		$sLeft3=StringLower(StringLeft($aCmdLines[$i],3))
		If $sLeft3<>"rem" And $sLeft3<>"" Then ;注释代码不执行
			$iResult=Execute_CmdLine($aCmdLines[$i])
		EndIf
		If $iResult<>0 Then
			;MsgBox($MB_SYSTEMMODAL,"提示信息","IIS安装失败！")
			_FileWriteLog($hFile, $sType&".bat 处理失败，自动化安装退出！ 行："&$aCmdLines[$i])
			FileClose($hFile)
			Exit
		EndIf
	Next
EndFunc

Func Execute_CmdLine($sCmdLine)
	MsgBox($MB_SYSTEMMODAL,"信息",$sCmdLine)
	Return 0
	;$iResult=_RunDos($sCmdLine)
	;Return $iResult
EndFunc

Func Install_DotNexFx45()
	Run(@ScriptDir & "\resources\dotnetfx4.5.2-x86-x64-AllOS-ENU.exe")
	WinWaitActive("Microsoft .NET Framework 4.5.2","我已阅读并接受许可条款(&A)。")
	$aPosition=ControlGetPos("Microsoft .NET Framework 4.5.2","我已阅读并接受许可条款(&A)。","Button3")
	MouseClick("left", $aPosition[0], $aPosition[1])
	WinWaitActive("Microsoft .NET Framework 4.5.2","安装(&I)")
	Send("!i")
	WinWaitActive("Microsoft .NET Framework 4.5.2","安装完毕")
	Send("!f")
EndFunc

Func Install_ReportViewer()
	Run(@ScriptDir & "\resources\ReportViewer.exe")
	WinWaitActive("Microsoft ReportViewer 2010 Redistributable 安装程序","下一步(&N) >")
	Send("!n")
	$aPosition=ControlGetPos("Microsoft ReportViewer 2010 Redistributable 安装程序","我已阅读并接受许可条款(&A)。","Button3")
	MouseClick("left", $aPosition[0], $aPosition[1])
	WinWaitActive("Microsoft ReportViewer 2010 Redistributable 安装程序","安装(&I)")
	Send("!i")
	WinWaitActive("Microsoft ReportViewer 2010 Redistributable 安装程序","完成(&F)")
	Send("!f")
EndFunc

Func Install_GBESClient()
	Run(@ScriptDir & "\resources\GBES客户端安装程序.exe")
	WinWaitActive("GBES客户端驱动","下一步(&N) >")
	Send("!n")
	WinWaitActive("GBES客户端驱动","选择安装位置")
	Send("!n")
	WinWaitActive("GBES客户端驱动","安装(&I)")
	Send("!i")
	WinWaitActive("GBES客户端驱动","完成(&F)")
	Send("!f")
EndFunc

Func Install_Redis()
	Run(@ScriptDir & "\resources\redis-2.4.6-setup-64-bit.exe")
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

Func Install_DXperience()
	Run(@ScriptDir & "\resources\DXperience-11.1.8.exe")
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


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
#AutoIt3Wrapper_Res_ProductVersion=1.0
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
Local Const $sSqlServerIniPath=@ScriptDir&"\conf\sqlserver.ini"
Local Const $sPathAutoIt3=@ScriptDir & "\conf\lib\AutoIt3_x64.exe"
Local $aInstalls,$aInstallFileNames,$aBattFileNames,$aAu3FileNames
Local $hFile = FileOpen(@ScriptDir & "\install.log", 1)

Main()


;func
Func Main()
	If Not IsAdmin() Then MsgToExit("请使用管理员权限运行！")

	Load_Config()

	Install_Run()

	MsgToExit('自动化安装完成..')
EndFunc

Func Load_Config()
	_FileWriteLog($hFile, "开始加载配置文件..")
	$iFileExists = FileExists($sConfigPath)
	If Not $iFileExists Then MsgToExit("未找到配置文件，自动化安装退出！")

	$aInstalls = IniReadSection($sConfigPath, "Install")
	If @error Then MsgToExit("加载配置文件出错，自动化安装退出！")

	$iFileExists = FileExists($sPathAutoIt3)
	If Not $iFileExists Then MsgToExit("未找到AutoIt3.exe文件，自动化安装退出！")

	$aInstallFileNames = _FileListToArray(@ScriptDir&"\resources", "*")
	;_ArrayDisplay($aInstallFileNames, "文件清单") ;测试显示文件清单
    If @error = 1 Then
		MsgToExit("资源目录无效（" & @ScriptDir&"\resources" & "），自动化安装退出！")
    EndIf
    If @error = 4 Then
		MsgToExit("资源目录（" & @ScriptDir&"\resources" & "）未发现文件，自动化安装退出！")
    EndIf

	$aBattFileNames = _FileListToArray(@ScriptDir&"\conf\batt", "*")
    If @error = 1 Then
		MsgToExit("bat模板目录无效（" & @ScriptDir&"\conf\batt" & "），自动化安装退出！")
    EndIf
    If @error = 4 Then
		MsgToExit("bat模板目录（" & @ScriptDir&"\conf\batt" & "）未发现文件，自动化安装退出！")
    EndIf

	$aAu3FileNames = _FileListToArray(@ScriptDir&"\conf\script", "*")
    If @error = 1 Then
		MsgToExit("au3脚本目录无效（" & @ScriptDir&"\conf\script" & "），自动化安装退出！")
    EndIf
    If @error = 4 Then
		MsgToExit("au3脚本目录（" & @ScriptDir&"\conf\script" & "）未发现文件，自动化安装退出！")
    EndIf

	_FileWriteLog($hFile, "加载配置文件完毕..")
EndFunc

Func Install_Run()
    ;BlockInput($BI_DISABLE) ; 禁用用户的鼠标和键盘输入
	;Opt("MouseCoordMode", 2); 设置激活窗口的相对坐标位置
	;Opt("MouseClickDelay", 500); 设置鼠标点击次数的间隔时长为0.5s

	For $i = 1 To $aInstalls[0][0]
		_FileWriteLog($hFile, $aInstalls[$i][0]&" 开始处理..")
		If $aInstalls[$i][1]=="au3" Then
			LoadScript_Run($aInstalls[$i][0])
		ElseIf $aInstalls[$i][1]=="bat" Then
			LoadBatt_Run($aInstalls[$i][0])
		EndIf
		_FileWriteLog($hFile, $aInstalls[$i][0]&" 处理完成..")
		Sleep(3000)
	Next

	;BlockInput($BI_ENABLE) ; 启用户鼠标和键盘输入
EndFunc

Func LoadScript_Run($sType)
	;查找对应安装文件
	$sFileName=FindFileByStart($aInstallFileNames,$sType)
	If StringLen($sFileName)==0 Then MsgToExit($sType&"未找到对应安装文件，自动化安装退出！")

	;查找对应脚本
	$sAu3FileName=FindFileByStart($aAu3FileNames,$sType)
	If StringLen($sAu3FileName)==0 Then MsgToExit($sType&"未找到对应au3脚本文件，自动化安装退出！")

	$sFilePath=@ScriptDir & "\resources\" & $sFileName
	$sAu3FilePath=@ScriptDir & "\conf\script\" & $sAu3FileName

	;执行脚本
	$iRunResult=RunWait($sPathAutoIt3 & " " & $sAu3FilePath & " " & $sFilePath)
	Sleep(500)
	If Not $iRunResult Then MsgToExit($sType&"对应脚本执行失败，自动化安装退出！ ")
EndFunc

Func LoadBatt_Run($sType)
	$sTypeLower= StringLower($sType)
	;如果是sqlserver，需配置sqlserver.ini文件
	If $sTypeLower=="sqlserver" Then ConfigSqlServerIni()

	;查找对应batt文件
	$sBattFileName=FindFileByStart($aBattFileNames,$sType)
	If StringLen($sBattFileName)==0 Then MsgToExit("未找到"&$sType&"对应的batt文件，自动化安装退出！")

	$sBattFilePath=@ScriptDir & "\conf\batt\" & $sBattFileName

	;读取batt文件内容
	$hFileOpen = FileOpen($sBattFilePath, $FO_READ)
    If $hFileOpen = -1 Then MsgToExit($sBattFilePath&"读取时出现错误，自动化安装退出！")
    $sBattContent = FileRead($hFileOpen)

	;替换系统变量
	$aMatchs = StringRegExp($sBattContent, '{{@.+?}}', $STR_REGEXPARRAYFULLMATCH)
	For $i = 0 To UBound($aMatchs) - 1
		$sSysArg=StringReplace($aMatchs[$i],"{{","")
		$sSysArg=StringReplace($sSysArg,"}}","")
		$sBattContent=StringReplace($sBattContent,$aMatchs[$i],Execute($sSysArg))
	Next

	;替换配置变量
	$iMatch= StringRegExp($sBattContent, "{{.+?}}", 0)
	If $iMatch Then
		$aBattArgs = IniReadSection($sConfigPath, $sType)
		$iRows = UBound($aBattArgs, $UBOUND_ROWS)
		If $iRows>0 Then
			For $i = 1 To $aBattArgs[0][0]
				$sBattContent=StringReplace($sBattContent,"{{"&$aBattArgs[$i][0]&"}}",$aBattArgs[$i][1])
			Next
		EndIf
	EndIf
	FileClose($hFileOpen)

	;替换后bat文件内容输出log
	_FileWriteLog($hFile,$sType&".bat"&@CRLF&"-------------------------------------------------------开始-------------------------------------------------------"&@CRLF&$sBattContent&@CRLF&"-------------------------------------------------------结束-------------------------------------------------------")

	;bat内容保存临时文件
	$sTempBatPath=@TempDir & "\" & $sType &'.bat'
	$hFileWrite = FileOpen($sTempBatPath, $FO_OVERWRITE)
	If $hFileWrite = -1 Then MsgToExit("写入临时" & $sType &".bat文件出错，自动化安装退出！")
	FileWrite($hFileWrite,$sBattContent)
	FileClose($hFileWrite)

	;执行临时bat文件
	$iResult=_RunDos($sTempBatPath)
	;删除临时bat文件
	FileDelete($sTempBatPath)
	;$iResult=_RunDos($sBattContent)
	If $iResult<>0 Then MsgToExit($sType&"对应批处理失败，自动化安装退出！ ")
EndFunc

Func ConfigSqlServerIni()
	$hFileOpen = FileOpen($sSqlServerIniPath, $FO_READ)
    If $hFileOpen = -1 Then MsgToExit("sqlserver.ini读取出错，自动化安装退出！")
    $sSqlServerIniContent = FileRead($hFileOpen)
	FileClose($hFileOpen)

	$sSqlServerIniContent=StringRegExpReplace($sSqlServerIniContent,'ASSYSADMINACCOUNTS=".+?"','ASSYSADMINACCOUNTS="'&@ComputerName&'\\'&@UserName&'"')
	$sSqlServerIniContent=StringRegExpReplace($sSqlServerIniContent,'SQLSYSADMINACCOUNTS=".+?"','SQLSYSADMINACCOUNTS="'&@ComputerName&'\\'&@UserName&'"')

	$hFileWrite = FileOpen($sSqlServerIniPath, $FO_OVERWRITE)
    If $hFileWrite = -1 Then MsgToExit("sqlserver.ini写入出错，自动化安装退出！")
	FileWrite($hFileWrite,$sSqlServerIniContent)
	FileClose($hFileWrite)
EndFunc

Func FindFileByStart($aFileNames,$sStart)
	For $sFileName in $aFileNames
		If StringLower(StringLeft($sFileName,StringLen($sStart)))==StringLower($sStart) Then
			Return $sFileName
		EndIf
	Next
	Return ""
EndFunc

Func MsgToExit($sError)
	MsgBox($MB_SYSTEMMODAL,"提示信息",$sError)
	_FileWriteLog($hFile,$sError)
	FileClose($hFile)
	Exit
EndFunc

Func BatRunObsolete($sType)
	$aCmdLines=FileReadToArray(@ScriptDir&"\conf\"&$sType&".bat")
	$iLineCount = @extended
	If @error Then
		_FileWriteLog($hFile, $sType&".bat 文件读取出错，自动化安装退出！")
		FileClose($hFile)
		Exit
		MsgToExit($sType&".bat 文件读取出错，自动化安装退出！")
	EndIf
	For $i = 0 To $iLineCount - 1 ;
		$iResult=0
		$sLeft3=StringLower(StringLeft($aCmdLines[$i],3))
		If $sLeft3<>"rem" And $sLeft3<>"" Then ;注释代码不执行
			$iResult=Execute_CmdLine($aCmdLines[$i])
		EndIf
		If $iResult<>0 Then
			MsgToExit($sType&".bat 处理失败，自动化安装退出！ 行："&$aCmdLines[$i])
		EndIf
	Next
EndFunc

Func Execute_CmdLine($sCmdLine)
	MsgBox($MB_SYSTEMMODAL,"信息",$sCmdLine)
	Return 0
	;$iResult=_RunDos($sCmdLine)
	;Return $iResult
EndFunc



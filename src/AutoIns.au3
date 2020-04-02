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

#include <MsgBoxConstants.au3>
#include <WinAPIFiles.au3>
#include <Process.au3>
#include <File.au3>

#Region ### START Koda GUI include section ### Form=
#include <ButtonConstants.au3>
#include <GUIConstantsEx.au3>
#include <GuiListView.au3>
#include <misc.au3>
#include <ProgressConstants.au3>
#include <StaticConstants.au3>
#include <WindowsConstants.au3>
#include <ListViewConstants.au3>
#include <ProgressConstants.au3>
#include <TrayConstants.au3>
#EndRegion ### END Koda GUI include section ###

Global Const $sConfigPath =@WorkingDir&"\conf\AutoIns.ini"
Global Const $sPathAutoIt3=@WorkingDir & "\lib\AutoIt3\AutoIt3_x64.exe"
Global $aInstalls,$aBattFileNames,$aAu3FileNames
Global $hLogFile = FileOpen(@WorkingDir & "\install.log", 1)
;gui control
Global $hFmMain,$hListInstall,$hBtnStart,$hProgressInstall

OnAutoItExitRegister("_OnExit")

_Main()

;func
Func _Main()
	If Not IsAdmin() Then _MsgToExit("请使用管理员权限运行！")

	_Load_Config()

	_ShowMainForm()

EndFunc

Func _OnExit()
	FileClose($hLogFile)
EndFunc

Func _Load_Config()
	_FileWriteLog($hLogFile, "开始加载配置文件..")
 	Local $iFileExists = FileExists($sConfigPath)
	If Not $iFileExists Then _MsgToExit("未找到配置文件，自动化安装退出！")

	$aInstalls = IniReadSection($sConfigPath, "Install")
	If @error Then _MsgToExit("加载配置文件出错，自动化安装退出！")

	$iFileExists = FileExists($sPathAutoIt3)
	If Not $iFileExists Then _MsgToExit("未找到AutoIt3.exe文件，自动化安装退出！")

	$aBattFileNames = _FileListToArrayRec(@WorkingDir&"\conf\batt", "*.batt", $FLTAR_FILESFOLDERS, $FLTAR_RECUR, $FLTAR_SORT)
    If @error = 1 Then
		_MsgToExit("bat模板目录无效（" & @WorkingDir&"\conf\batt" & "），自动化安装退出！")
    EndIf

	$aAu3FileNames = _FileListToArrayRec(@WorkingDir&"\conf\script", "*.au3", $FLTAR_FILESFOLDERS, $FLTAR_RECUR, $FLTAR_SORT)
    If @error = 1 Then
		_MsgToExit("au3脚本目录无效（" & @WorkingDir&"\conf\script" & "），自动化安装退出！")
    EndIf

	_FileWriteLog($hLogFile, "加载配置文件完毕..")
EndFunc

Func _ShowMainForm()
	;托盘
	Opt("TrayMenuMode", 3)
	Local $iExit = TrayCreateItem("退出")
	TraySetState($TRAY_ICONSTATE_SHOW)

	;主窗体
	$hFmMain = GUICreate("AutoIns", 352, 352, 192, 124)
	$hListInstall = GUICtrlCreateListView("安装选项|安装方式|状态", 0, 0, 350, 320, -1, BitOR($LVS_EX_GRIDLINES, $LVS_EX_FULLROWSELECT, $LVS_EX_CHECKBOXES))
	GUICtrlSendMsg(-1, $LVM_SETCOLUMNWIDTH, 0, 200)
	GUICtrlSendMsg(-1, $LVM_SETCOLUMNWIDTH, 1, 66)
	GUICtrlSendMsg(-1, $LVM_SETCOLUMNWIDTH, 2, 60)

	For $i = 1 To $aInstalls[0][0]
		GUICtrlCreateListViewItem($aInstalls[$i][0]&"|"&$aInstalls[$i][1]&"|", $hListInstall)
		_GUICtrlListView_SetItemChecked($hListInstall,$i-1)
	Next

	$hBtnStart = GUICtrlCreateButton("开始", 0, 323, 350, 25)
	GUICtrlSetCursor (-1, 0)
	GUICtrlSetState($hBtnStart, $GUI_SHOW)
	$hProgressInstall = GUICtrlCreateProgress(0, 323, 350, 25)
	GUICtrlSetState($hProgressInstall, $GUI_HIDE)

	GUISetState(@SW_SHOW)

	While 1
		;窗体信息
		$nMsg = GUIGetMsg()
		Switch $nMsg
			Case $GUI_EVENT_CLOSE
				Exit
			Case $hBtnStart
				_OnStart()
			Case $GUI_EVENT_PRIMARYDOWN
				_Arrange_List()
		EndSwitch
		;托盘信息
		Switch TrayGetMsg()
			Case $iExit
				Exit
		EndSwitch
	WEnd
EndFunc

Func _Arrange_List()
    $Selected = _GUICtrlListView_GetHotItem($hListInstall)
    If $Selected = -1 then Return
	While _IsPressed(1)
    WEnd
    $Dropped = _GUICtrlListView_GetHotItem($hListInstall)
    If $Dropped > -1 then
        _GUICtrlListView_BeginUpdate($hListInstall)
		$aItems=StringSplit(_GUICtrlListView_GetItemTextString($hListInstall, $Selected),"|")
        If $Selected < $Dropped Then
            _GUICtrlListView_InsertItem($hListInstall, $aItems[1], $Dropped + 1)
			_GUICtrlListView_SetItem($hListInstall,$aItems[2], $Dropped + 1,1)
			_GUICtrlListView_SetItem($hListInstall,$aItems[3], $Dropped + 1,2)
            _GUICtrlListView_SetItemChecked($hListInstall, $Dropped + 1, _GUICtrlListView_GetItemChecked($hListInstall, $Selected))
            _GUICtrlListView_DeleteItem($hListInstall, $Selected)
        ElseIf $Selected > $Dropped Then
            _GUICtrlListView_InsertItem($hListInstall, $aItems[1], $Dropped)
			_GUICtrlListView_SetItem($hListInstall,$aItems[2], $Dropped,1)
			_GUICtrlListView_SetItem($hListInstall,$aItems[3], $Dropped,2)
            _GUICtrlListView_SetItemChecked($hListInstall, $Dropped, _GUICtrlListView_GetItemChecked($hListInstall, $Selected + 1))
            _GUICtrlListView_DeleteItem($hListInstall, $Selected + 1)
        EndIf
        _GUICtrlListView_EndUpdate($hListInstall)
    EndIf
EndFunc

Func _OnStart()
	;查询选择安装项的下标集合
	Local $aCheckedIndexArray[0]
	For $i = 0 To _GUICtrlListView_GetItemCount($hListInstall) - 1
        If _GUICtrlListView_GetItemChecked($hListInstall, $i) Then
			_ArrayAdd($aCheckedIndexArray,$i)
        EndIf
    Next
	If UBound($aCheckedIndexArray,1)==0 Then Return
	GUICtrlSetState($hBtnStart, $GUI_HIDE)
	GUICtrlSetState($hProgressInstall, $GUI_SHOW)
	_Install($aCheckedIndexArray)
EndFunc

Func _Install($aCheckedIndexArray)
    ;BlockInput($BI_DISABLE) ; 禁用用户的鼠标和键盘输入
	;Opt("MouseCoordMode", 2); 设置激活窗口的相对坐标位置
	;Opt("MouseClickDelay", 500); 设置鼠标点击次数的间隔时长为0.5s

	GUICtrlSetState($hListInstall,$GUI_DISABLE)
	For $i = 0 To UBound($aCheckedIndexArray,1) - 1
		$sResultMsg=""
		$sType=_GUICtrlListView_GetItem($hListInstall,$aCheckedIndexArray[$i],0)[3]
		$sExcute=_GUICtrlListView_GetItem($hListInstall,$aCheckedIndexArray[$i],1)[3]
		_FileWriteLog($hLogFile, $sType&" 开始处理..")
		_GUICtrlListView_SetItem($hListInstall,"安装中..",$aCheckedIndexArray[$i],2)
		If $sExcute=="au3" Then
			$sResultMsg=_LoadScriptToRun($sType)
		ElseIf $sExcute=="bat" Then
			$sResultMsg=_LoadBattToRun($sType)
		EndIf
		Sleep(1000)
		If $sResultMsg=="" Then
			GUICtrlSetData($hProgressInstall,($i+1)/UBound($aCheckedIndexArray,1)*100)
			_FileWriteLog($hLogFile, $sType&" 处理完成..")
			_GUICtrlListView_SetItem($hListInstall,"安装完成",$aCheckedIndexArray[$i],2)
			_GUICtrlListView_SetItemChecked($hListInstall,$aCheckedIndexArray[$i],False)
		Else
			_FileWriteLog($hLogFile,"安装失败(原因："&$sResultMsg&")，自动化安装停止！")
			_GUICtrlListView_SetItem($hListInstall,"安装失败",$aCheckedIndexArray[$i],2)
			MsgBox($MB_SYSTEMMODAL,"提示信息","安装失败(原因："&$sResultMsg&")，自动化安装停止！")
			GUICtrlSetState($hListInstall,$GUI_ENABLE)
			GUICtrlSetState($hProgressInstall, $GUI_HIDE)
			GUICtrlSetState($hBtnStart, $GUI_SHOW)
			Return
		EndIf
	Next

	;BlockInput($BI_ENABLE) ; 启用户鼠标和键盘输入

	If MsgBox($MB_OKCANCEL,"提示信息","自动化安装完成，确定退出？")==$IDOK Then
		_FileWriteLog($hLogFile,"自动化安装完成..")
		Exit
	EndIf
EndFunc

Func _LoadScriptToRun($sType)
	;查找对应脚本
	$sAu3FileName=_FindFileByStart($aAu3FileNames,$sType)
	If StringLen($sAu3FileName)==0 Then Return $sType&"未找到对应au3脚本文件"

	$sAu3FilePath=@WorkingDir & "\conf\script\" & $sAu3FileName

	;查找兼容脚本
	$sAu3FilePath=_FindCompatibleFile($sAu3FilePath)

	;执行脚本
	Local $iRunResult=RunWait('"' & $sPathAutoIt3 & '" /AutoIt3ExecuteScript "' & $sAu3FilePath & '"', @WorkingDir)
	Sleep(500)
	If $iRunResult<>0 Then Return $sType&"对应脚本执行失败，错误-"&$iRunResult&":"&@error

	Return ""
EndFunc

Func _LoadBattToRun($sType)

	;查找对应batt文件
	$sBattFileName=_FindFileByStart($aBattFileNames,$sType)
	If StringLen($sBattFileName)==0 Then Return "未找到"&$sType&"对应的batt文件"

	$sBattFilePath=@WorkingDir & "\conf\batt\" & $sBattFileName

	;查找兼容batt
	$sBattFilePath=_FindCompatibleFile($sBattFilePath)

	;读取batt文件内容
	$hFileOpen = FileOpen($sBattFilePath, $FO_READ)
    If $hFileOpen = -1 Then Return $sBattFilePath&"读取时出现错误"
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
	_FileWriteLog($hLogFile,$sType&".bat"&@CRLF&"-------------------------------------------------------开始-------------------------------------------------------"&@CRLF&$sBattContent&@CRLF&"-------------------------------------------------------结束-------------------------------------------------------")

	;bat内容保存临时文件
	$sTempBatPath=@TempDir & "\" & $sType & Random(100000, 999999, 1) &'.bat'
	$hFileOpen = FileOpen($sTempBatPath, $FO_OVERWRITE)
	If $hFileOpen = -1 Then Return "获取临时" & $sType &".bat文件句柄出错"
	$hFileWrite = FileWrite($hFileOpen,$sBattContent)
	If Not $hFileWrite Then Return "写入临时" & $sType &".bat文件出错"
	$hFileWrite = FileClose($hFileOpen)
	If Not $hFileWrite Then Return "关闭临时" & $sType &".bat文件出错"
	;执行临时bat文件
	Local $iRunBatResult=RunWait($sTempBatPath)
	If $iRunBatResult<>0 Then Return $sType&"对应批处理失败，错误-"&$iRunBatResult&":"&@error
	;删除临时bat文件
	FileDelete($sTempBatPath)
	;更新环境变量 not work
	;EnvUpdate()
	Return ""
EndFunc

Func _FindFileByStart($aFileNames,$sStart)
	For $sFileName in $aFileNames
		If StringLower(StringLeft($sFileName,StringLen($sStart)))==StringLower($sStart) Then
			Return $sFileName
		EndIf
	Next
	Return ""
EndFunc

Func _FindCompatibleFile($sDefaultFilePath)
	Local $sEmpty,$sExtension
	_PathSplit($sDefaultFilePath, $sEmpty, $sEmpty, $sEmpty, $sExtension)
	Local $sCompatibleFile=StringTrimRight($sDefaultFilePath,StringLen($sExtension)) & "." & @OSVersion & $sExtension
	If	FileExists($sCompatibleFile) Then Return $sCompatibleFile
	Return $sDefaultFilePath
EndFunc

Func _MsgToExit($sError)
	MsgBox($MB_SYSTEMMODAL,"提示信息",$sError)
	_FileWriteLog($hLogFile,$sError)
	Exit
EndFunc
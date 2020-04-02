#cs ----------------------------------------------------------------------------

 AutoIt Version: 3.3.14.5
 Author:         myName

 Script Function:
	Template AutoIt script.

#ce ----------------------------------------------------------------------------

; Script Start - Add your code below here
#include "FileExtend.au3"
#include "ExitCode.au3"

Func _RunDefault()
	Opt("TrayIconHide", 1) ;隐藏托盘图标
	Opt("MouseCoordMode", 2); 设置激活窗口的相对坐标位置
	Opt("MouseClickDelay", 500); 设置鼠标点击次数的间隔时长为0.5s

	$sFilePath=_FindFileFromPath(@WorkingDir&"\resources",StringTrimRight(@ScriptName,4),"*")
	If $sFilePath="" Then Exit $EXIT_NOTFOUND_INSTALLFILE;获取对应文件

	$iResult=Run(@WorkingDir&"\resources\"&$sFilePath)
	If Not $iResult Then Exit $EXIT_RUNRILE_ERROR;运行文件失败则退出
EndFunc

Func _FindConfig($sConfigPath,$sSectionName,$sConfigName)
	Local $aConfigs = IniReadSection($sConfigPath, $sSectionName)
	If @error Then Return ""
	$iRows = UBound($aConfigs, $UBOUND_ROWS)
	If $iRows>0 Then
		For $i = 1 To $aConfigs[0][0]
			If $aConfigs[$i][0]=$sConfigName Then Return $aConfigs[$i][1]
		Next
	EndIf
	Return ""
EndFunc

Func _LoadKeyboardLayout($sLayoutID)
	Local $hWnd = WinGetHandle("[ACTIVE]");$hWnd 为目标窗口句柄，这里设置的是当前活动窗口
	Local $ret = DllCall("user32.dll", "long", "LoadKeyboardLayout", "str", $sLayoutID, "int", 1 + 0)
	DllCall("user32.dll", "ptr", "SendMessage", "hwnd", $hWnd, "int", 0x50, "int", 1, "int", $ret[0])
EndFunc
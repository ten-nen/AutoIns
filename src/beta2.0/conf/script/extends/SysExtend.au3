#cs ----------------------------------------------------------------------------

 AutoIt Version: 3.3.14.5
 Author:         myName

 Script Function:
	Template AutoIt script.

#ce ----------------------------------------------------------------------------

; Script Start - Add your code below here
#include "FileExtend.au3"

Func RunDefault()
	Opt("MouseCoordMode", 2); 设置激活窗口的相对坐标位置
	Opt("MouseClickDelay", 500); 设置鼠标点击次数的间隔时长为0.5s

	$sFilePath=_FindFileFromPath(@WorkingDir&"\resources",StringTrimRight(@ScriptName,4),"*")
	If $sFilePath="" Then Exit ;获取对应文件

	$iResult=Run(@WorkingDir&"\resources\"&$sFilePath)
	If Not $iResult Then Exit ;运行文件失败则退出
EndFunc
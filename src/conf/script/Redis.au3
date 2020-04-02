#cs ----------------------------------------------------------------------------

 AutoIt Version: 3.3.14.5
 Author:         myName

 Script Function:
	Template AutoIt script.

#ce ----------------------------------------------------------------------------

; Script Start - Add your code below here
#include "extends\InsExtend.au3"
#include "extends\ExitCode.au3"
Local $sInstallPath

_Main()

Exit $EXIT_SUCCESS ;返回成功标示


Func _Main()

	;查找配置-安装路径
	$sInstallPath = _FindConfig(@WorkingDir&"\conf\AutoIns.ini",StringTrimRight(@ScriptName,4),"InstallPath")
	If StringLen($sInstallPath)=0 Then Exit $EXIT_NOTFOUND_CONFIG

	_RunDefault()

	_Install()

EndFunc

Func _Install()
	WinWaitActive("Setup - Redis","Welcome to the Redis Setup Wizard")
	Send("{ENTER}")
	WinWaitActive("Setup - Redis","License Agreement")
	$aPosition=ControlGetPos("Setup - Redis","I &accept the agreement","TNewRadioButton1")
	MouseClick("left", $aPosition[0], $aPosition[1])
	WinWaitActive("Setup - Redis","Next >")
	Send("{ENTER}")
	WinWaitActive("Setup - Redis","Select Destination Location")
	_LoadKeyboardLayout("04090409") ;设为美式键盘
	Send($sInstallPath,0) ;Send("D:\Program Files\Redis",0)
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
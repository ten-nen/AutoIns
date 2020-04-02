#cs ----------------------------------------------------------------------------

 AutoIt Version: 3.3.14.5
 Author:         myName

 Script Function:
	Template AutoIt script.

#ce ----------------------------------------------------------------------------

; Script Start - Add your code below here
#include "extends\InsExtend.au3"
#include "extends\ExitCode.au3"
#include <File.au3>

Global Const $sSqlServerIniPath=@WorkingDir&"\conf\SqlServer.ini"

_Main()

Exit $EXIT_SUCCESS ;返回成功标示

Func _Main()

	_ConfigSqlServerIni()

EndFunc

Func _ConfigSqlServerIni()
	$hFileOpen = FileOpen($sSqlServerIniPath, $FO_READ)
    If $hFileOpen = -1 Then Exit $EXIT_INITFILE_READERROR
    $sSqlServerIniContent = FileRead($hFileOpen)
	FileClose($hFileOpen)

	$sSqlServerIniContent=StringRegExpReplace($sSqlServerIniContent,'ASSYSADMINACCOUNTS=".+?"','ASSYSADMINACCOUNTS="'&@ComputerName&'\\'&@UserName&'"')
	$sSqlServerIniContent=StringRegExpReplace($sSqlServerIniContent,'SQLSYSADMINACCOUNTS=".+?"','SQLSYSADMINACCOUNTS="'&@ComputerName&'\\'&@UserName&'"')

	$hFileWrite = FileOpen($sSqlServerIniPath, $FO_OVERWRITE)
    If $hFileWrite = -1 Then Exit $EXIT_INITFILE_WRITEERROR
	FileWrite($hFileWrite,$sSqlServerIniContent)
	FileClose($hFileWrite)
EndFunc
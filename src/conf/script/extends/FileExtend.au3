#cs ----------------------------------------------------------------------------

 AutoIt Version: 3.3.14.5
 Author:         myName

 Script Function:
	Template AutoIt script.

#ce ----------------------------------------------------------------------------

; Script Start - Add your code below here
#include <File.au3>

Func _FindFileFromPath($sPath,$sStart,$sAccept)
	$aFileNames = _FileListToArray($sPath, $sAccept)
	If @error = 1 Then
		Return ""
    EndIf
    If @error = 4 Then
		Return ""
    EndIf
	Return _FindFileByStart($aFileNames,$sStart)
EndFunc

Func _FindFileByStart($aFileNames,$sStart)
	For $sFileName in $aFileNames
		If StringLower(StringLeft($sFileName,StringLen($sStart)))==StringLower($sStart) Then
			Return $sFileName
		EndIf
	Next
	Return ""
EndFunc
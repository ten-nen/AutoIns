#cs ----------------------------------------------------------------------------

 AutoIt Version: 3.3.14.5
 Author:         myName

 Script Function:
	Template AutoIt script.

#ce ----------------------------------------------------------------------------

; Script Start - Add your code below here
Global _
$EXIT_SUCCESS=0, _ ;成功
$EXIT_ERROR=1, _ ;错误
$EXIT_NOTFOUND_INSTALLFILE=2, _ ;未找到对应安装文件
$EXIT_RUNRILE_ERROR=3, _ ;启动安装程序失败
$EXIT_NOTFOUND_CONFIG=4, _ ;未找到配置
$EXIT_INITFILE_WRITEERROR=5, _ ;init文件写入失败
$EXIT_INITFILE_READERROR=6 ;init文件读取失败
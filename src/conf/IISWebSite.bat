rem ƒ¨»œ≈‰÷√
%systemroot%\system32\inetsrv\appcmd set config -section:system.webServer/security/isapiCgiRestriction /[path='%windir%\Microsoft.NET\Framework\v4.0.30319\aspnet_isapi.dll'].allowed:"True" /commit:apphost
%systemroot%\system32\inetsrv\appcmd set config -section:system.webServer/security/isapiCgiRestriction /[path='%windir%\Microsoft.NET\Framework64\v4.0.30319\aspnet_isapi.dll'].allowed:"True" /commit:apphost
%systemroot%\system32\inetsrv\appcmd set config -section:requestFiltering -requestLimits.maxAllowedContentLength:3000000000
rem XJFJ.Web
%systemroot%\system32\inetsrv\appcmd add AppPool /name:XJFJ.Web /managedRuntimeVersion:v4.0 /managedPipelineMode:Classic /enable32BitAppOnWin64:true
%systemroot%\system32\inetsrv\appcmd set AppPool XJFJ.Web -processModel.identityType:LocalSystem -processModel.pingResponseTime:0.00:15:00 -processModel.shutdownTimeLimit:0.00:15:00 -processModel.startupTimeLimit:0.00:15:00
%systemroot%\system32\inetsrv\appcmd add site /name:XJFJ.Web /bindings:"http/*:7501:" /physicalPath:"D:\IISPublish\GLD.GBES.XinJiangFJ.3.0.0.2\Web"
%systemroot%\system32\inetsrv\appcmd set site /site.name:XJFJ.Web /[path='/'].applicationPool:XJFJ.Web
mkdir D:\GBES\upload\XinJiangFangJian
%systemroot%\system32\inetsrv\appcmd set config -section:system.applicationHost/sites /+"[name='XJFJ.Web'].[path='/'].[path='/PDFPath',physicalPath='D:\GBES\upload\XinJiangFangJian']" /commit:apphost
rem XJFJ.Wcf
%systemroot%\system32\inetsrv\appcmd add AppPool /name:XJFJ.Wcf /managedRuntimeVersion:v4.0 /managedPipelineMode:Classic /enable32BitAppOnWin64:true
%systemroot%\system32\inetsrv\appcmd set AppPool XJFJ.Wcf -processModel.pingResponseTime:0.00:15:00 -processModel.shutdownTimeLimit:0.00:15:00 -processModel.startupTimeLimit:0.00:15:00
%systemroot%\system32\inetsrv\appcmd add site /name:XJFJ.Wcf /bindings:"http/*:7502:" /physicalPath:"D:\IISPublish\GLD.GBES.XinJiangFJ.3.0.0.2\Wcf"
%systemroot%\system32\inetsrv\appcmd set site /site.name:XJFJ.Wcf /[path='/'].applicationPool:XJFJ.Wcf
rem XJFJ.File
%systemroot%\system32\inetsrv\appcmd add AppPool /name:XJFJ.File /managedRuntimeVersion:v4.0 /managedPipelineMode:Classic /enable32BitAppOnWin64:true
%systemroot%\system32\inetsrv\appcmd set AppPool XJFJ.File -processModel.identityType:LocalSystem -processModel.pingResponseTime:0.00:15:00 -processModel.shutdownTimeLimit:0.00:15:00 -processModel.startupTimeLimit:0.00:15:00
%systemroot%\system32\inetsrv\appcmd add site /name:XJFJ.File /bindings:"http/*:7503:" /physicalPath:"D:\IISPublish\GLD.GBES.XinJiangFJ.3.0.0.2\File"
%systemroot%\system32\inetsrv\appcmd set site /site.name:XJFJ.File /[path='/'].applicationPool:XJFJ.File
rem XJFJ.WFAdmin
%systemroot%\system32\inetsrv\appcmd add AppPool /name:XJFJ.WFAdmin /managedRuntimeVersion:v4.0 /managedPipelineMode:Classic /enable32BitAppOnWin64:true
%systemroot%\system32\inetsrv\appcmd set AppPool XJFJ.WFAdmin -processModel.pingResponseTime:0.00:15:00 -processModel.shutdownTimeLimit:0.00:15:00 -processModel.startupTimeLimit:0.00:15:00
%systemroot%\system32\inetsrv\appcmd add site /name:XJFJ.WFAdmin /bindings:"http/*:7504:" /physicalPath:"D:\IISPublish\GLD.GBES.XinJiangFJ.3.0.0.2\WFAdmin"
%systemroot%\system32\inetsrv\appcmd set site /site.name:XJFJ.WFAdmin /[path='/'].applicationPool:XJFJ.WFAdmin
rem XJFJ.WFEngine
%systemroot%\system32\inetsrv\appcmd add AppPool /name:XJFJ.WFEngine /managedRuntimeVersion:v4.0 /managedPipelineMode:Classic /enable32BitAppOnWin64:true
%systemroot%\system32\inetsrv\appcmd set AppPool XJFJ.WFEngine -processModel.pingResponseTime:0.00:15:00 -processModel.shutdownTimeLimit:0.00:15:00 -processModel.startupTimeLimit:0.00:15:00
%systemroot%\system32\inetsrv\appcmd add site /name:XJFJ.WFEngine /bindings:"http/*:7505:" /physicalPath:"D:\IISPublish\GLD.GBES.XinJiangFJ.3.0.0.2\WFEngine"
%systemroot%\system32\inetsrv\appcmd set site /site.name:XJFJ.WFEngine /[path='/'].applicationPool:XJFJ.WFEngine
rem XJFJ.Config
%systemroot%\system32\inetsrv\appcmd add AppPool /name:XJFJ.Config /managedRuntimeVersion:v4.0 /managedPipelineMode:Classic /enable32BitAppOnWin64:true
%systemroot%\system32\inetsrv\appcmd set AppPool XJFJ.Config -processModel.pingResponseTime:0.00:15:00 -processModel.shutdownTimeLimit:0.00:15:00 -processModel.startupTimeLimit:0.00:15:00
%systemroot%\system32\inetsrv\appcmd add site /name:XJFJ.Config /bindings:"http/*:7506:" /physicalPath:"D:\IISPublish\GLD.GBES.XinJiangFJ.3.0.0.2\Config"
%systemroot%\system32\inetsrv\appcmd set site /site.name:XJFJ.Config /[path='/'].applicationPool:XJFJ.Config
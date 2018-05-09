#ensure we are working from the correct location
Set-Location $(Split-Path $MyInvocation.MyCommand.Path)

#purge build app sources
Write-Host 'Beginning Office purge' -BackgroundColor DarkGreen
.\purge_office_apps.ps1
Write-Host 'Beginning Ninite purge' -BackgroundColor DarkGreen
.\purge_ninite_apps.ps1
PAUSE
#redownload & package build apps
#.\import_ninite_apps.ps1
#.\import_office_apps.ps1

#update build task sequence & update deployment share
Write-Host 'Beginning build TS update' -BackgroundColor DarkGreen
.\update_build_ts.ps1
PAUSE
#capture WIMs -- pending full environment, need HV in build domain
PAUSE
#update deploy task sequence & update deployment share
Write-Host 'Beginning deploy TS update' -BackgroundColor DarkGreen
.\update_deploy_ts.ps1
PAUSE
#copy deployment share to FOG
Write-Host 'Beginning copy to FOG' -BackgroundColor DarkGreen
.\update_fog.ps1
PAUSE
#end of MDT automation, rest handled by FOG
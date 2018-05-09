#ensure we are working from the correct location
Set-Location $(Split-Path $MyInvocation.MyCommand.Path)

#purge build app sources
.\purge_office_apps.ps1
.\purge_ninite_apps.ps1

#redownload & package build apps
.\import_ninite_apps.ps1
.\import_office_apps.ps1

#update build task sequence & update deployment share
.\update_build_ts.ps1

#capture WIMs -- pending full environment, need HV in build domain

#update deploy task sequence & update deployment share
.\update_deploy_ts.ps1

#copy deployment share to FOG
.\update_fog.ps1

#end of MDT automation, rest handled by FOG
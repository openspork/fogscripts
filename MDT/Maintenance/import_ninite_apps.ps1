#Script variables
$NinitePath = 'M:\Tools\Ninite\NiniteOne.exe'
$OutputDir = 'M:\Sources\Applications\Ninite'
$RootDir = 'M:'

$OutputFileName = "OfflineNiniteInstaller_$((Date -format d).replace('/','-')).exe"
$OutputFilePath = "$OutputDir\$OutputFileName"

#Array of apps to build into installer
$AppList = @(
    'Chrome', 
    'Flash (PPAPI)', 
    'Reader'
    )

#Build arguments
$AppListString = ''
$AppList | % { $AppListString += ('"' + $_ + '" ')}
$Args = "/silent /select $AppListString /freeze $OutputFilePath"

Write-Host 'Running:' $NinitePath $Args 

#Build installer
Start-Process $NinitePath -ArgumentList $Args -Wait

Write-Host 'Created installer, importing ...'

#Import MDT module & create MDT PSDrive
Import-Module "$Env:ProgramFiles\Microsoft Deployment Toolkit\bin\MicrosoftDeploymentToolkit.psd1"
New-PSDrive -Name "MDTSHARE" -PSProvider MDTProvider -Root "$RootDir\MDTBuildLab"

#Remove existing (if present)
Remove-Item -Path "MDTSHARE:\Applications\Ninite\NiniteOfflineInstaller" -Force -Verbose

$versionString = "$(Date -format d)-$($AppList -join ',')"

#Import created installer
Import-MDTApplication -Path "MDTSHARE:\Applications\Ninite" -Enable "True" -Name "Install - NiniteOfflineInstaller" -ShortName "Install - NiniteOfflineInstaller" -Version $versionString -Publisher "" -Language "" -CommandLine "$OutputFileName /silent" -WorkingDirectory '.\Applications\NiniteOfflineInstaller' -ApplicationSourcePath $OutputDir -DestinationFolder "NiniteOfflineInstaller" -Verbose

#Remove created PSDrive
Remove-PSDrive MDTSHARE
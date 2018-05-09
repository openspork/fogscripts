###############################
# MDT Build Environment Setup #
###############################

#Script variables
$RootDir = 'M:'

#Import MDT module
Import-Module "$Env:ProgramFiles\Microsoft Deployment Toolkit\bin\MicrosoftDeploymentToolkit.psd1"

#Create user
#New-ADUser 'MDT_BA' -AccountPassword (Read-Host -AsSecureString "MDT Build Account User Password") -Enabled $true -PasswordNeverExpires $true -CannotChangePassword $true -Description "MDT Build Service Account"

#Create sources share
New-Item -Path "$RootDir\Sources" -ItemType directory
New-SmbShare -Name "Sources$" -Path "$RootDir\Sources" -ChangeAccess Everyone -Description 'MDT Source Files'

#Create sources folder structure
New-Item -Path "$RootDir\Sources\Applications\Office\O365BusinessRetail\" -ItemType Directory
New-Item -Path "$RootDir\Sources\Applications\Office\O365ProPlusRetail\" -ItemType Directory
New-Item -Path "$RootDir\Sources\Applications\Office\HomeBusinessRetail\" -ItemType Directory
New-Item -Path "$RootDir\Sources\Applications\Office\ProPlusRetail\" -ItemType Directory

New-Item -Path "$RootDir\Sources\Applications\Ninite" -ItemType Directory
New-Item -Path "$RootDir\Sources\Applications\Visual C++ Redistributables" -ItemType Directory

New-Item -Path "$RootDir\Sources\Operating Systems" -ItemType Directory
New-Item -Path "$RootDir\Sources\Out-of-Box Drivers" -ItemType Directory
New-Item -Path "$RootDir\Sources\Packages" -ItemType Directory

#Create tools folder structure
<#
M:\Tools\Ninite
#>

#Create logging dir
New-Item -Path $RootDir\Logs\Build -ItemType Directory
New-SmbShare -Name Logs$ -Path M:\Logs -ChangeAccess Everyone -Description 'MDT Log Files'
#Set log dir permissions
icacls "$RootDir\Logs" /grant '"MDT_BA":(OI)(CI)(M)'

#Create deployment share
New-Item -Path "$RootDir\MDTBuildLab" -ItemType Directory
New-SmbShare -Name "MDTBuildLab$" -Path "$RootDir\MDTBuildLab" #TODO set permissions
New-PSDrive -Name 'MDTSHARE' -PSProvider MDTProvider -Root "$RootDir\MDTBuildLab" -Description 'MDT Build Lab' -NetworkPath "\\$Env:ComputerName\MDTBuildLab$" -Verbose | add-MDTPersistentDrive -Verbose

#Set capture dir permissions
icacls "$RootDir\MDTBuildLab\Captures" /grant '"MDT_BA":(OI)(CI)(M)'

#Create folders
New-Item -Path 'MDTSHARE:\Operating Systems' -enable 'True' -Name 'Windows 7 x64' -Comments '' -ItemType 'folder' -Verbose
New-Item -Path 'MDTSHARE:\Operating Systems' -enable 'True' -Name 'Windows 10 x64' -Comments '' -ItemType 'folder' -Verbose

New-Item -Path 'MDTSHARE:\Out-of-Box Drivers' -enable 'True' -Name 'Windows 7 x64' -Comments '' -ItemType 'folder' -Verbose
New-Item -Path 'MDTSHARE:\Out-of-Box Drivers' -enable 'True' -Name 'Windows 10 x64' -Comments '' -ItemType 'folder' -Verbose
New-Item -Path 'MDTSHARE:\Out-of-Box Drivers' -enable 'True' -Name 'WinPE' -Comments '' -ItemType 'folder' -Verbose

New-Item -Path 'MDTSHARE:\Packages' -enable 'True' -Name 'Windows 7 x64' -Comments '' -ItemType 'folder' -Verbose
New-Item -Path 'MDTSHARE:\Packages' -enable 'True' -Name 'Windows 10 x64' -Comments '' -ItemType 'folder' -Verbose

New-Item -Path 'MDTSHARE:\Applications' -enable 'True' -Name 'Visual C++ Redists' -Comments '' -ItemType 'folder' -Verbose
New-Item -Path 'MDTSHARE:\Applications' -enable 'True' -Name 'Ninite' -Comments '' -ItemType 'folder' -Verbose
New-Item -Path 'MDTSHARE:\Applications' -enable 'True' -Name 'Office' -Comments '' -ItemType 'folder' -Verbose
New-Item -Path 'MDTSHARE:\Applications' -enable 'True' -Name 'Misc' -Comments '' -ItemType 'folder' -Verbose

Remove-PSDrive MDTSHARE -Verbose


###############################
# MDT Deploy Environment Setup #
###############################

#Script variables
$RootDir = 'M:'

#Import MDT module
Import-Module "$Env:ProgramFiles\Microsoft Deployment Toolkit\bin\MicrosoftDeploymentToolkit.psd1"

#Create user
New-ADUser 'MDT_DA' -AccountPassword (Read-Host -AsSecureString "MDT Deploy Account User Password") -Enabled $true -PasswordNeverExpires $true -CannotChangePassword $true -Description "MDT Deployment Service Account"

#Create logging dir
New-Item -Path $RootDir\Logs\Deploy -ItemType Directory
#New-SmbShare -Name Logs$ -Path M:\Logs -ChangeAccess Everyone -Description 'MDT Log Files'
#Set log dir permissions
icacls "$RootDir\Logs" /grant '"MDT_DA":(OI)(CI)(M)'

#Create deployment share
New-Item -Path "$RootDir\MDTDeploy" -ItemType Directory
New-SmbShare -Name "MDTDeploy$" -Path "$RootDir\MDTDeploy" 
New-PSDrive -Name 'MDTSHARE' -PSProvider MDTProvider -Root "$RootDir\MDTDeploy" -Description 'MDT Deployment Share' -NetworkPath "\\$Env:ComputerName\MDTDeploy$" -Verbose | add-MDTPersistentDrive -Verbose

#Create folders
New-Item -Path 'MDTSHARE:\Operating Systems' -enable 'True' -Name 'Windows 7' -Comments '' -ItemType 'folder' -Verbose
New-Item -Path 'MDTSHARE:\Operating Systems' -enable 'True' -Name 'Windows 10' -Comments '' -ItemType 'folder' -Verbose

New-Item -Path 'MDTSHARE:\Out-of-Box Drivers' -enable 'True' -Name 'Windows 7' -Comments '' -ItemType 'folder' -Verbose
New-Item -Path 'MDTSHARE:\Out-of-Box Drivers' -enable 'True' -Name 'Windows 10' -Comments '' -ItemType 'folder' -Verbose

Remove-PSDrive MDTSHARE -Verbose


#Script variables
$RootDir = 'M:'
$ApplicationSourcePath = "$RootDir\Sources\Applications\Visual C++ Redistributables"
$ApplicationDestinationPath = '\Applications\Visual C++ Redists'

#Import MDT module & create MDT PSDrive
Import-Module "$Env:ProgramFiles\Microsoft Deployment Toolkit\bin\MicrosoftDeploymentToolkit.psd1"
New-PSDrive -Name "MDTSHARE" -PSProvider MDTProvider -Root "$RootDir\MDTBuildLab"

#Run through folder contents
Get-ChildItem $ApplicationSourcePath | % {
    $ApplicationName = 'Install - ' + $_.BaseName #Generate name for MDT app based on filename
    $CommandLine = "$($_.Name) /q" #Generate command for quiet installation

    Write-Host "Importing:" $CommandLine

    #Run the import
    Import-MDTApplication -Path "MDTSHARE:$ApplicationDestinationPath" -Enable 'True' -Name $ApplicationName -ShortName $ApplicationName -Commandline $Commandline -WorkingDirectory ".\Applications\$ApplicationName" -ApplicationSourcePath $ApplicationSourcePath -DestinationFolder $ApplicationName -Verbose
}

#Remove created PSDrive
Remove-PSDrive MDTSHARE
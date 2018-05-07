
#Script variables
$RootDir = 'M:'
$OfficeDir =  "$RootDir\Sources\Applications\Office"

#Import MDT module & create MDT PSDrive
Import-Module "$Env:ProgramFiles\Microsoft Deployment Toolkit\bin\MicrosoftDeploymentToolkit.psd1"
New-PSDrive -Name "MDTSHARE" -PSProvider MDTProvider -Root "M:\MDTBuildLab"

#For each config file
Get-ChildItem $OfficeDir | Where {$_.Extension -match '.xml'} | % {
    #Set app vars
    $OfficeVer = $_.BaseName
    $ConfigFileName = $_.Name

    #Create a folder for download and populate
    New-Item -Path "$OfficeDir\$OfficeVer" -ItemType Directory
    Copy-Item "$OfficeDir\setup.exe" "$OfficeDir\$OfficeVer"
    Copy-Item $_.FullName "$OfficeDir\$OfficeVer"

    #Assemble download command
    $Dir = "$OfficeDir\$OfficeVer"
    $Exe = "$OfficeDir\$OfficeVer\setup.exe"
    $Args = "/download $OfficeDir\$ConfigFileName"

    #Run in holding dir (command dumps to working dir)
    cd $Dir
    Write-Host "Executing $Cmd"
    Invoke-Expression "$Exe $Args"

    #Import app
    Import-MDTApplication `
        -path "MDTSHARE:\Applications\Office" `
        -enable "True" -Name "Install - Microsoft Office $OfficeVer" `
        -ShortName "Install - Microsoft Office $OfficeVer" `
        -Version "" `
        -Publisher "Microsoft" `
        -Language "" `
        -CommandLine "setup.exe /configure $OfficeVer.xml" `
        -WorkingDirectory ".\Applications\Microsoft $OfficeVer" `
        -ApplicationSourcePath "M:\Sources\Applications\Office\$OfficeVer" `
        -DestinationFolder "Microsoft $OfficeVer" `
        -Verbose
}

Remove-PSDrive MDTShare
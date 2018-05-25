#Script variables
$RootDir = 'M:'

#Import MDT module
Import-Module "$Env:ProgramFiles\Microsoft Deployment Toolkit\bin\MicrosoftDeploymentToolkit.psd1"

#Create PSDrive
New-PSDrive -Name 'MDTSHARE' -PSProvider MDTProvider -Root "$RootDir\MDTFogDeploy"

#Iterate through driver source folders and add to MDT
Get-ChildItem "$RootDir\Sources\Out-of-Box Drivers" | % {
    $OS = $_.Name
    Write-Host "Creating Folder $OS"
    New-Item -Path "MDTSHARE:\Out-of-Box Drivers" -Enable "True" -Name "$OS" -Comments "" -ItemType "Folder" -Verbose

    Get-ChildItem $_.FullName | % {
        if ( $_.Name -eq "Dell" ) { $Manufacturer = 'Dell Inc.' }
        else { $Manufacturer = $_.Name }
        Write-Host "Creating Folder $Manufacturer"
        New-Item -Path "MDTSHARE:\Out-of-Box Drivers\$OS" -Enable "True" -Name $Manufacturer -Comments "" -ItemType "Folder" -Verbose
        
        Get-ChildItem $_.FullName | % {
            $Model = $_.Name
            Write-Host "Creating Folder $Model"
            New-Item -Path "MDTSHARE:\Out-of-Box Drivers\$OS\$Manufacturer" -Enable "True" -Name $Model -Comments "" -ItemType "Folder" -Verbose
            Import-MDTDriver -Path "MDTSHARE:\Out-of-Box Drivers\$OS\$Manufacturer\$Model" -SourcePath "$RootDir\Sources\Out-of-Box Drivers\$OS\$Manufacturer\$Model" -Verbose   
        }
    }
}

Remove-PSDrive MDTShare
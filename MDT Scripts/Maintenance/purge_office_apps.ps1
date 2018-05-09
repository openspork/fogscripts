#Script variables
$RootDir = 'M:'
$mdtOfficePath = "MDTShare:\Applications\Office"
$OfficeDir =  "$RootDir\Sources\Applications\Office"

Add-PSSnapIn Microsoft.BDD.PSSnapIn
New-PSDrive -Name "MDTShare" -PSProvider MDTProvider -Root "$RootDir\MDTBuildLab"

Get-ChildItem -Path $mdtOfficePath | % { 
    Write-Host "Removing $($_.Name)"
    Remove-Item "$mdtOfficePath\$($_.Name)"
}

Get-ChildItem -Path $OfficeDir -Directory | Remove-Item -Recurse
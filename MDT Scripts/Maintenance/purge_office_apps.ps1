#Script variables
$RootDir = 'M:'
$mdtOfficePath = "MDTShare:\Applications\Office"
$OfficeDir =  "$RootDir\Sources\Applications\Office"

Add-PSSnapIn Microsoft.BDD.PSSnapIn
New-PSDrive -Name "MDTShare" -PSProvider MDTProvider -Root "$RootDir\MDTBuildLab" | Out-Null

#FIX DELETION OF ALL
Get-ChildItem -Path $mdtOfficePath | % {
    Write-Host "Removing $mdtOfficePath\$($_.Name)"
    Remove-Item "$mdtOfficePath\$($_.Name)"
}

Get-ChildItem -Path $OfficeDir -Directory | Remove-Item -Recurse

Remove-PSDrive -Name "MDTShare" | Out-Null
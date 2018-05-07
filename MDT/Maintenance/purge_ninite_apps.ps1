#Script variables
$RootDir = 'M:'
$mdtNinitePath = "MDTShare:\Applications\Ninite"
$NiniteDir =  "$RootDir\Sources\Applications\Ninite"

Add-PSSnapIn Microsoft.BDD.PSSnapIn
New-PSDrive -Name "MDTShare" -PSProvider MDTProvider -Root "$RootDir\MDTBuildLab"

Get-ChildItem -Path $mdtNinitePath | % { 
    Write-Host "Removing $($_.Name)"
    Remove-Item "$mdtNinitePath\$($_.Name)"
}

Get-ChildItem -Path $NiniteDir -Directory | Remove-Item -Recurse
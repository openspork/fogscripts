# Purge existing os

#Script variables
$root_dir = 'M:'
$os = 'Windows 10 x64'

Add-PSSnapIn Microsoft.BDD.PSSnapIn
New-PSDrive -Name 'MDTShare' -PSProvider MDTProvider -Root "$root_dir\MDTFogDeploy"
Get-ChildItem "MDTShare:\Operating Systems\$($os)" | % {
    Remove-Item -Path "MDTShare:\Operating Systems\$($os)\$($_.Name)"
}
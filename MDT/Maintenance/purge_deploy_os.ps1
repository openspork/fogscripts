# Purge existing os

#Script variables
$root_dir = 'M:'
$os = 'Windows 10 x64'

Add-PSSnapIn Microsoft.BDD.PSSnapIn
New-PSDrive -Name 'MDTShare' -PSProvider MDTProvider -Root "$root_dir\MDTFogDeploy" | Out-Null
Get-ChildItem "MDTShare:\Operating Systems\$($os)" | Remove-Item -Recurse
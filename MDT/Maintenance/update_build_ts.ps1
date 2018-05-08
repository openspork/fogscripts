# Updates TS for current Office setup
# Updates TS for current Ninite setup

#Script variables
$root_dir = 'M:'
$os = 'Windows 10 x64'
$deploy_ts_name = 'deploy'

Add-PSSnapIn Microsoft.BDD.PSSnapIn
New-PSDrive -Name 'MDTShare' -PSProvider MDTProvider -Root "$root_dir\MDTFogDeploy" | Out-Null
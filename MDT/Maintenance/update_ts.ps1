#Script variables
$root_dir = 'M:'
$os = 'Windows 10 x64'
$deploy_ts_name = 'deploy'

Add-PSSnapIn Microsoft.BDD.PSSnapIn
New-PSDrive -Name 'MDTShare' -PSProvider MDTProvider -Root "$root_dir\MDTFogDeploy"

#find last captured WIM
$latest_wim = (Get-ChildItem -Path "$root_dir\MDTBuildLab\Captures" | sort CreationTime | Select-Object -Last 1)

#generate name from wim name
$latest_wim_name = $latest_wim.Name.Replace('.wim','')

#TODO check it is recent & handle error

#Import last captured WIM
#Import-MDTOperatingSystem -Path "MDTShare:\Operating Systems\$($os)" -SourceFile $latest_wim.FullName -DestinationFolder $latest_wim_name -Verbose

$new_os_guid = (Get-ChildItem "MDTShare:\Operating Systems\$($os)" | ? { $_.Name -match $latest_wim_name }).guid

$ts_xml_path = "M:\MDTFogDeploy\Control\$deploy_ts_name\ts.xml"

$ts_xml = [xml]$(Get-Content $ts_xml_path)

$global_var_os_guid_node = ($ts_xml | Select-Xml -XPath "//sequence/globalVarList/variable[@name='OSGUID']").Node

$global_var_os_guid_node | % {
    Write-Host "Updating global variables: $($_.'#text') to $new_os_guid"
    $_.'#text' = $new_os_guid
}

$install_os_guid_node = ($ts_xml | Select-Xml -XPath "//sequence/group[@name='Install']/step[@type='BDD_InstallOS']/defaultVarList/variable[@name='OSGUID']").Node

Write-Host "Updating install step variable: $($_.'#text') to $new_os_guid"
$install_os_guid_node.'#text' = $new_os_guid

$ts_xml.Save($ts_xml_path)

Remove-PSDrive -Name 'MDTShare'
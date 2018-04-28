#Script variables
$RootDir = 'M:'

Add-PSSnapIn Microsoft.BDD.PSSnapIn
New-PSDrive -Name "MDTShare" -PSProvider MDTProvider -Root "$RootDir\MDTBuildLab"

$ts_xml = [xml]$(Get-Content "$RootDir/MDTBuildLab/Control/TaskSequences.xml")

$ts_list = $ts_xml.tss

$ts_infos = @()

$ts_list.ts | % {
    $ts_info = New-Object PSObject -Property @{
        ID = $_.ID
        Name = $_.Name
        Template = $_.TaskSequenceTemplate
    }
    $ts_infos += $ts_info
}

$ts_infos | Format-Table ID, Name, Template

$source = Read-Host -Prompt 'Enter task sequence ID to copy'
$destination = Read-Host -Prompt 'Enter new task sequence ID'

$source_ts_xml = [xml]$(Get-Content "$RootDir/MDTBuildLab/Control/$source/ts.xml")

$os_guid = ($source_ts_xml | Select-Xml -XPath "//sequence/globalVarList/variable[@name='OSGUID']").Node.'#text'[0]

$os_xml = [xml]$(Get-Content "$RootDir/MDTBuildLab/Control/OperatingSystems.xml")

$os_name = $($os_xml | Select-Xml -XPath "//oss/os[@guid='$os_guid']/Name").Node.'#text'
if ( $os_name -match 'Windows 7' ) { $os_dir = 'Windows 10 x64' }elseif ( $os_name -match 'Windows 8.1' ) { $os_dir = 'Windows 8.1 x64' }elseif ( $os_name -match 'Windows 10' ) { $os_dir = 'Windows 10 x64' }Import-MDTTaskSequence -Template client.xml -name $destination -ID $destination -OperatingSystemPath `
   "MDTShare:\Operating Systems\$os_dir\$os_name" -Path "MDTShare:\Task Sequences" -Version 1.0
Copy-Item -Path "$RootDir\MDTBuildLab\Control\$source\*" -Destination "$RootDir\MDTBuildLab\Control\$destination" -Force

Remove-PSDrive MDTShare

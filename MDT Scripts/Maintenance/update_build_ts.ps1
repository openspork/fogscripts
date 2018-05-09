# Updates TS for current Office setup
# Updates TS for current Ninite setup

#Script variables
$root_dir = 'M:'
$root_app_path = 'MDTShare:\Applications'
$apps = @( 'Office', 'Ninite' )

Add-PSSnapIn Microsoft.BDD.PSSnapIn
New-PSDrive -Name 'MDTShare' -PSProvider MDTProvider -Root "$root_dir\MDTBuildLab" | Out-Null

$names_to_guids = @{} #create dict to store names to guids

#build dict of names to guids
$apps | % {
    #build paths to each application
    $app_path = "$root_app_path\$_"
    Get-ChildItem -Name $app_path | % {
        $guid = (Get-Item "$app_path\$_").guid
        Write-Host "Adding pair: $_ = $guid"
        #add guid to dict with name as key
        $names_to_guids[$_] = $guid
    }
}

function update_ts ($build_ts_name) {
    Write-Host "Processing: $build_ts_name" -ForegroundColor Green
    #open the task sequence XML file for editing
    $ts_xml_path = "M:\MDTBuildLab\Control\$build_ts_name\ts.xml"
    $ts_xml = [xml]$(Get-Content $ts_xml_path)

    #go through each app
    $names_to_guids.Keys | % {
        #get the node containing matching name
        $app_guid_node = ($ts_xml | Select-Xml -XPath "//sequence/group/step[@type='BDD_InstallApplication' and @name='$_']/defaultVarList/variable[@property='ApplicationGUID']").Node
        if ( $app_guid_node ) {
            #set to new guid via dict
            Write-Host "Operating on $_`: updating $($app_guid_node.'#text') to $($names_to_guids[$_])"
            $app_guid_node.'#text' = $names_to_guids[$_]
            }
    }
    $ts_xml.Save($ts_xml_path)
}

#for each task sequence
Get-ChildItem 'MDTShare:\Task Sequences' | % {
    #perform the update
    update_ts $_.Name
}

#update the deployment share
Update-MDTDeploymentShare -path 'MDTShare:'

Remove-PSDrive -Name 'MDTShare'
#Requires -RunAsAdministrator

$root_dir = "$env:HOMEDRIVE/Drivers"
$output_dir = $root_dir + '/' + 'certs'
$exportType = [System.Security.Cryptography.X509Certificates.X509ContentType]::Cert
$thumbprints = @()

$host.ui.RawUI.WindowTitle = 'Installing drivers...'

Write-Host 'Searching for driver certificates...'
if ( ! $(Test-Path $output_dir) ) { New-Item -ItemType Directory -Name certs -Path $root_dir | Out-Null }

$root_dir | Get-ChildItem -Recurse | ? { (Get-AuthenticodeSignature $_.FullName -ErrorAction SilentlyContinue).SignerCertificate } | % {

    $cert = $( Get-AuthenticodeSignature $_.FullName ).SignerCertificate
    if ( $thumbprints -notcontains $cert.Thumbprint ){
    	Write-Host "Certificate found!"
        $output_file = "$output_dir\$($cert.Thumbprint).cer"
        [System.IO.File]::WriteAllBytes($output_file, $cert.Export($exportType))
        $thumbprints += $cert.Thumbprint
    }
}

Write-Host 'Installing Certificates...'
Get-ChildItem $output_dir | % {
    certutil -Enterprise -addstore "TrustedPublisher" $_.FullName | Out-Null
}
Write-Host 'Done'

$registry_path = "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\UnattendSettings\PnPUnattend\DriverPaths\1"

New-Item -Path $registry_path -Force | Out-Null

$registry_path = "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\UnattendSettings\PnPUnattend\DriverPaths\1"
$name = "Path"
$value = "$env:HOMEDRIVE\Drivers"


Write-Host 'Installing drivers...'
New-ItemProperty -Path $registry_path -Name $name -Value $value -PropertyType String -Force | Out-Null
pnpunattend auditsystem /L
Write-Host 'Done'

$registry_path = "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon"
$name = "Shell"
$value = "explorer.exe"

New-ItemProperty -Path $registry_path -Name $name -Value $value -PropertyType String -Force | Out-Null

Write-Host 'Setting Administrator password...'

net user Administrator Pass1234
PAUSE

shutdown -r -t 0
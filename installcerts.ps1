$root_dir = "$env:HOMEDRIVE/Drivers"
$output_dir = $root_dir + '/' + 'certs'
$exportType = [System.Security.Cryptography.X509Certificates.X509ContentType]::Cert
$thumbprints = @()

if ( ! $(Test-Path $output_dir) ) { New-Item -ItemType Directory -Name certs -Path $root_dir -ErrorAction SilentlyContinue }

$root_dir | Get-ChildItem -Recurse | ? { (Get-AuthenticodeSignature $_ -ErrorAction SilentlyContinue).SignerCertificate } | % {
    $cert = $( Get-AuthenticodeSignature $_ ).SignerCertificate
    if ( $thumbprints -notcontains $cert.Thumbprint ){
        $output_file = "$output_dir\$($cert.Thumbprint).cer"
        [System.IO.File]::WriteAllBytes($output_file, $cert.Export($exportType))
        $thumbprints += $cert.Thumbprint
    }
}

Get-ChildItem $output_dir | % {
    Write-Host $_.FullName
    Import-Certificate -CertStoreLocation Cert:\LocalMachine\TrustedPublisher -FilePath $_.FullName
}
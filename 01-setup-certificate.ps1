# ============================================================
# 01-setup-certificate.ps1
# Configuracion del certificado SSL para RDS
# Autor: Raelina Ferrera | ITLA 2021-2371
# ============================================================

Write-Host "`n[PASO 1] Generando certificado SSL self-signed..." -ForegroundColor Cyan

$cert = New-SelfSignedCertificate `
    -DnsName "RDPSERVER" `
    -CertStoreLocation "cert:\LocalMachine\My"

Write-Host "Certificado creado. Thumbprint: $($cert.Thumbprint)" -ForegroundColor Green

Write-Host "`n[PASO 2] Exportando certificado como .pfx..." -ForegroundColor Cyan

$password = ConvertTo-SecureString "Raelina1234*" -AsPlainText -Force

Export-PfxCertificate `
    -Cert "cert:\LocalMachine\My\$($cert.Thumbprint)" `
    -FilePath "C:\rdp-cert.pfx" `
    -Password $password

Write-Host "Certificado exportado en C:\rdp-cert.pfx" -ForegroundColor Green

Write-Host "`n[PASO 3] Asignando certificado a los roles RDS..." -ForegroundColor Cyan

Set-RDCertificate -Role RDRedirector -ImportPath "C:\rdp-cert.pfx" -Password $password -Force
Write-Host "  RDRedirector  -> OK" -ForegroundColor Green

Set-RDCertificate -Role RDWebAccess -ImportPath "C:\rdp-cert.pfx" -Password $password -Force
Write-Host "  RDWebAccess   -> OK" -ForegroundColor Green

Set-RDCertificate -Role RDPublishing -ImportPath "C:\rdp-cert.pfx" -Password $password -Force
Write-Host "  RDPublishing  -> OK" -ForegroundColor Green

Write-Host "`nCertificado SSL configurado exitosamente!" -ForegroundColor Green

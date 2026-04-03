# ============================================================
# 04-verify-configuration.ps1
# Verificacion completa del setup RDP RemoteApp
# Autor: Raelina Ferrera | ITLA 2021-2371
# ============================================================

Write-Host "============================================================" -ForegroundColor Magenta
Write-Host "   VERIFICACION - RDP REMOTEAPP WINDOWS SERVER 2019" -ForegroundColor Magenta
Write-Host "   Autor: Raelina Ferrera | ITLA 2021-2371" -ForegroundColor Magenta
Write-Host "============================================================`n" -ForegroundColor Magenta

# 1. Roles RDS instalados
Write-Host "[1] Roles de Remote Desktop Services instalados:" -ForegroundColor Cyan
Get-WindowsFeature | Where-Object {$_.Installed -eq $true -and $_.Name -like "RDS-*"} | 
    Select-Object Name, DisplayName | Format-Table -AutoSize

# 2. Certificado SSL
Write-Host "[2] Certificado SSL configurado:" -ForegroundColor Cyan
Get-ChildItem "cert:\LocalMachine\My" | 
    Where-Object {$_.Subject -like "*RDPSERVER*"} |
    Select-Object Subject, Thumbprint, NotAfter | Format-Table -AutoSize

# 3. Sitios IIS
Write-Host "[3] Sitio IIS - Portal RemoteApp:" -ForegroundColor Cyan
Get-WebSite | Select-Object Name, State, PhysicalPath | Format-Table -AutoSize

# 4. RemoteApps publicadas
Write-Host "[4] RemoteApps publicadas:" -ForegroundColor Cyan
Get-RDRemoteApp -CollectionName "QuickSessionCollection" | 
    Select-Object DisplayName, FilePath, RequiredCommandLine | Format-Table -AutoSize

# 5. Coleccion RDS
Write-Host "[5] Coleccion RDS activa:" -ForegroundColor Cyan
Get-RDSessionCollection | Select-Object CollectionName, CollectionType | Format-Table -AutoSize

# 6. IP del servidor
Write-Host "[6] Informacion de red:" -ForegroundColor Cyan
Get-NetIPAddress -AddressFamily IPv4 | 
    Where-Object {$_.InterfaceAlias -notlike "*Loopback*"} |
    Select-Object InterfaceAlias, IPAddress | Format-Table -AutoSize

# 7. URLs de acceso
Write-Host "[7] URLs de acceso disponibles:" -ForegroundColor Yellow
$ip = (Get-NetIPAddress -AddressFamily IPv4 | Where-Object {$_.InterfaceAlias -notlike "*Loopback*"}).IPAddress
Write-Host "   RD Web Access          : https://$ip/RDWeb" -ForegroundColor Green
Write-Host "   Portal IIS personalizado: http://$ip`:8080" -ForegroundColor Green

Write-Host "`nVerificacion completada exitosamente!" -ForegroundColor Green
Write-Host "============================================================`n" -ForegroundColor Magenta

# ============================================================
# 03-publish-remoteapp.ps1
# Publicacion de Google Chrome como RemoteApp
# Autor: Raelina Ferrera | ITLA 2021-2371
# ============================================================

Write-Host "`n[PASO 1] Verificando ruta de Google Chrome..." -ForegroundColor Cyan

$chromePath = "C:\Program Files\Google\Chrome\Application\chrome.exe"

if (Test-Path $chromePath) {
    Write-Host "Chrome encontrado en: $chromePath" -ForegroundColor Green
} else {
    Write-Host "Chrome no encontrado en ruta principal, buscando alternativa..." -ForegroundColor Yellow
    $chromePath = "C:\Program Files (x86)\Google\Chrome\Application\chrome.exe"
    if (Test-Path $chromePath) {
        Write-Host "Chrome encontrado en: $chromePath" -ForegroundColor Green
    } else {
        Write-Host "ERROR: Google Chrome no encontrado. Instalalo primero." -ForegroundColor Red
        exit 1
    }
}

Write-Host "`n[PASO 2] Publicando RemoteApp en la coleccion..." -ForegroundColor Cyan

New-RDRemoteApp `
    -CollectionName "QuickSessionCollection" `
    -DisplayName "Portal Web RemoteApp" `
    -FilePath $chromePath `
    -CommandLineSetting Require `
    -RequiredCommandLine "http://localhost:8080"

Write-Host "`nRemoteApp publicada exitosamente!" -ForegroundColor Green

Write-Host "`n[PASO 3] Verificando RemoteApps activas..." -ForegroundColor Cyan
Get-RDRemoteApp -CollectionName "QuickSessionCollection" | 
    Select-Object DisplayName, FilePath, RequiredCommandLine | 
    Format-Table -AutoSize

Write-Host "`nAccede al portal en: https://localhost/RDWeb" -ForegroundColor Yellow

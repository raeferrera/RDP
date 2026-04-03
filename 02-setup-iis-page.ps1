# ============================================================
# 02-setup-iis-page.ps1
# Creacion de pagina personalizada en IIS
# Autor: Raelina Ferrera | ITLA 2021-2371
# ============================================================

Write-Host "`n[PASO 1] Creando directorio del sitio web..." -ForegroundColor Cyan

$path = "C:\inetpub\wwwroot\miapp"
New-Item -ItemType Directory -Path $path -Force | Out-Null

Write-Host "Directorio creado: $path" -ForegroundColor Green

Write-Host "`n[PASO 2] Generando pagina HTML personalizada..." -ForegroundColor Cyan

$html = @"
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Portal RemoteApp</title>
    <style>
        * { margin: 0; padding: 0; box-sizing: border-box; }
        body {
            font-family: 'Segoe UI', Arial, sans-serif;
            background: #f0f4f8;
            min-height: 100vh;
            display: flex;
            flex-direction: column;
            align-items: center;
            justify-content: center;
        }
        .card {
            background: white;
            border-radius: 16px;
            box-shadow: 0 8px 32px rgba(0,0,0,0.10);
            padding: 48px 56px;
            text-align: center;
            max-width: 480px;
            width: 90%;
        }
        .logo {
            width: 80px; height: 80px;
            background: linear-gradient(135deg, #0078D4, #00BCF2);
            border-radius: 20px;
            margin: 0 auto 24px;
            display: flex; align-items: center; justify-content: center;
            font-size: 36px;
        }
        h1 { color: #1a1a2e; font-size: 26px; font-weight: 700; margin-bottom: 8px; }
        .subtitle { color: #666; font-size: 15px; margin-bottom: 32px; }
        .info-box {
            background: #f0f8ff; border: 1.5px solid #B0D4F1;
            border-radius: 10px; padding: 16px 20px;
            margin-bottom: 28px; text-align: left;
        }
        .info-row {
            display: flex; justify-content: space-between;
            padding: 6px 0; font-size: 14px; color: #444;
            border-bottom: 1px solid #ddeeff;
        }
        .info-row:last-child { border-bottom: none; }
        .info-row span:first-child { color: #999; }
        .info-row span:last-child { font-weight: 600; color: #0078D4; }
        .btn {
            display: inline-block;
            background: linear-gradient(135deg, #0078D4, #00BCF2);
            color: white; padding: 14px 40px; border-radius: 30px;
            font-size: 15px; font-weight: 600; text-decoration: none;
            box-shadow: 0 4px 15px rgba(0,120,212,0.3);
        }
        .footer { margin-top: 36px; color: #aaa; font-size: 12px; }
    </style>
</head>
<body>
    <div class="card">
        <div class="logo">&#x1F5A5;&#xFE0F;</div>
        <h1>Portal RemoteApp</h1>
        <p class="subtitle">Acceso Remoto Corporativo</p>
        <div class="info-box">
            <div class="info-row"><span>Servidor</span><span>RDPSERVER</span></div>
            <div class="info-row"><span>Estado</span><span>&#x2705; En linea</span></div>
            <div class="info-row"><span>Protocolo</span><span>RDP RemoteApp</span></div>
            <div class="info-row"><span>Puerto</span><span>8080</span></div>
        </div>
        <a class="btn" href="https://localhost/RDWeb" target="_blank">Acceder a RemoteApp</a>
        <div class="footer">&copy; 2026 Portal RemoteApp &mdash; Todos los derechos reservados</div>
    </div>
</body>
</html>
"@

$html | Out-File "$path\index.html" -Encoding UTF8 -Force
Write-Host "Pagina HTML generada en $path\index.html" -ForegroundColor Green

Write-Host "`n[PASO 3] Creando sitio en IIS en puerto 8080..." -ForegroundColor Cyan

Import-Module WebAdministration
New-WebSite -Name "PortalRemoteApp" -Port 8080 -PhysicalPath $path -Force | Out-Null

Write-Host "Sitio IIS creado: PortalRemoteApp -> Puerto 8080" -ForegroundColor Green
Write-Host "`nAccede en: http://localhost:8080" -ForegroundColor Yellow

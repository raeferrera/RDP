# 🖥️ RDP RemoteApp - Windows Server 2019

**Autor:** Raelina Ferrera  
**Carnet:** 2021-2371  
**Institución:** Instituto Tecnológico de las Américas (ITLA)  
**Fecha:** Abril 2026

---

## 📋 Objetivo de la tarea

Configurar el servicio de **RDP RemoteApp** en Windows Server 2019, incluyendo:

- Instalación y configuración de Remote Desktop Services (RDS)
- Configuración del servicio RD Web Access
- Creación de una página personalizada en IIS
- Publicación de la página IIS como RemoteApp
- Acceso al servicio desde un cliente externo (máquina host)

---

## 🗺️ Topología

```
┌─────────────────────┐          ┌──────────────────────────┐
│   Cliente / Host    │          │   Windows Server 2019    │
│   192.168.153.x     │◄────────►│   192.168.153.147        │
│   (Máquina Host)    │   RDP    │   Hostname: RDPSERVER    │
└─────────────────────┘          │                          │
                                 │  ┌──────────────────┐   │
                                 │  │ RD Session Host  │   │
                                 │  │ RD Web Access    │   │
                                 │  │ IIS Puerto 8080  │   │
                                 │  └──────────────────┘   │
                                 └──────────────────────────┘
```

### Interfaces y direccionamiento IP

| Componente | IP | Puerto | Protocolo |
|---|---|---|---|
| Windows Server 2019 | 192.168.153.147 | - | - |
| RD Web Access | 192.168.153.147 | 443 | HTTPS |
| Portal IIS personalizado | 192.168.153.147 | 8080 | HTTP |
| RD Session Host | 192.168.153.147 | 3389 | RDP |

---

## ⚙️ Configuraciones utilizadas

### Roles instalados en Windows Server

| Rol | Descripción |
|---|---|
| RD Session Host | Permite ejecutar aplicaciones remotas en el servidor |
| RD Web Access | Portal web para acceder a las RemoteApps desde el navegador |

### Certificado SSL

- Tipo: Self-signed certificate
- DnsName: RDPSERVER
- Thumbprint: `D0AE80EF42145F1C121DE0A6D1B38BBFF479671A`
- Asignado a: RDRedirector, RDWebAccess, RDPublishing

### RemoteApp publicada

| Campo | Valor |
|---|---|
| Nombre | Portal Web RemoteApp |
| Colección | QuickSessionCollection |
| Aplicación | Google Chrome |
| Argumento | http://localhost:8080 |

### Página IIS personalizada

- **Nombre del sitio:** PortalRemoteApp
- **Puerto:** 8080
- **Ruta física:** `C:\inetpub\wwwroot\miapp`
- **Contenido:** Portal de acceso remoto corporativo

---

## 🚀 Pasos de configuración

### 1. Cambio de contraseña de Administrator

```powershell
net user Administrator Raelina1234*
```

### 2. Instalación de roles RDS

En Server Manager → Add Roles and Features → Remote Desktop Services → Quick Start → Session-based desktop deployment

### 3. Configuración del certificado SSL

```powershell
# Crear certificado self-signed
$cert = New-SelfSignedCertificate -DnsName "RDPSERVER" -CertStoreLocation "cert:\LocalMachine\My"

# Exportar como .pfx
$password = ConvertTo-SecureString "Raelina1234*" -AsPlainText -Force
Export-PfxCertificate -Cert "cert:\LocalMachine\My\$($cert.Thumbprint)" `
    -FilePath "C:\rdp-cert.pfx" -Password $password

# Asignar a los roles RDS
Set-RDCertificate -Role RDRedirector -ImportPath "C:\rdp-cert.pfx" -Password $password -Force
Set-RDCertificate -Role RDWebAccess -ImportPath "C:\rdp-cert.pfx" -Password $password -Force
Set-RDCertificate -Role RDPublishing -ImportPath "C:\rdp-cert.pfx" -Password $password -Force
```

### 4. Creación de página IIS personalizada

```powershell
$path = "C:\inetpub\wwwroot\miapp"
New-Item -ItemType Directory -Path $path -Force
Import-Module WebAdministration
New-WebSite -Name "PortalRemoteApp" -Port 8080 -PhysicalPath $path -Force
```

### 5. Publicación de RemoteApp

```powershell
New-RDRemoteApp -CollectionName "QuickSessionCollection" `
    -DisplayName "Portal Web RemoteApp" `
    -FilePath "C:\Program Files\Google\Chrome\Application\chrome.exe" `
    -CommandLineSetting Require `
    -RequiredCommandLine "http://localhost:8080"
```

---

## 🌐 URLs de acceso

| Servicio | URL |
|---|---|
| RD Web Access | `https://192.168.153.147/RDWeb` |
| Portal IIS personalizado | `http://192.168.153.147:8080` |

### Credenciales de acceso

- **Usuario:** `RDPSERVER\Administrator`
- **Contraseña:** `Raelina1234*`

---

## 📁 Estructura del repositorio

```
RDP/
├── README.md                          # Documentación técnica
├── scripts/
│   ├── 01-setup-certificate.ps1       # Configuración SSL
│   ├── 02-setup-iis-page.ps1          # Página IIS personalizada
│   ├── 03-publish-remoteapp.ps1       # Publicar RemoteApp
│   └── 04-verify-configuration.ps1   # Verificación del setup
└── assets/
    └── screenshots/                   # Capturas de pantalla
```

---

## ✅ Verificación del funcionamiento

```powershell
# Verificar roles instalados
Get-WindowsFeature | Where-Object {$_.Installed -eq $true -and $_.Name -like "RDS-*"}

# Verificar RemoteApps publicadas
Get-RDRemoteApp -CollectionName "QuickSessionCollection"

# Verificar sitios IIS
Get-WebSite
```

---

## 📸 Evidencia

Las capturas de pantalla del funcionamiento se encuentran en la carpeta `assets/screenshots/`.

El video de demostración muestra:
- Hora y fecha del sistema
- Configuración completa via PowerShell
- Acceso exitoso desde cliente externo via RD Web Access
- Lanzamiento de la RemoteApp (Portal Web)

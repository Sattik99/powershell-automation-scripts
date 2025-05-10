# 🛠️ Utilities

This folder contains general-purpose PowerShell scripts used for system cleanup, update, and automation tasks. These are helpful for improving system health, automating maintenance, and supporting IT workflows.

## 📄 Scripts Included

### 🔹 `Update-Windows.ps1`
Installs all available Windows Updates using the PSWindowsUpdate module.

- Installs the module if not present
- Bypasses execution policy for smoother runs
- Uses Microsoft Update as the source
- Accepts and installs all updates silently

**How to run:**

```powershell
Set-ExecutionPolicy Bypass -Force;
Install-Module PSWindowsUpdate -Force | Out-Null;
Import-Module PSWindowsUpdate;
Get-WindowsUpdate -Install -AcceptAll -MicrosoftUpdate;

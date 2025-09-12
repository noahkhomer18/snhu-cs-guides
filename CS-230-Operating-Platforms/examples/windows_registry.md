# CS-230 Windows Registry Management

## 🎯 Purpose
Demonstrate Windows registry operations, backup, and management using PowerShell.

## 📝 Command Examples

### Registry Navigation
```powershell
# Navigate registry hives
Set-Location HKCU:\  # Current user
Set-Location HKLM:\  # Local machine
Set-Location HKCR:\  # Classes root
Set-Location HKU:\   # Users
Set-Location HKCC:\  # Current config

# List registry keys
Get-ChildItem HKCU:\Software
Get-ChildItem HKLM:\SOFTWARE\Microsoft
```

### Registry Value Operations
```powershell
# Read registry values
Get-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer"
Get-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion" -Name "ProductName"

# Write registry values
Set-ItemProperty -Path "HKCU:\Software\TestKey" -Name "TestValue" -Value "TestData"
New-ItemProperty -Path "HKCU:\Software\TestKey" -Name "NewValue" -Value "NewData" -PropertyType String

# Remove registry values
Remove-ItemProperty -Path "HKCU:\Software\TestKey" -Name "TestValue"
```

### Registry Key Management
```powershell
# Create registry keys
New-Item -Path "HKCU:\Software\CS230" -Force
New-Item -Path "HKCU:\Software\CS230\Lab1" -Force

# Remove registry keys
Remove-Item -Path "HKCU:\Software\CS230\Lab1" -Recurse
Remove-Item -Path "HKCU:\Software\CS230" -Recurse
```

### Registry Backup and Restore
```powershell
# Export registry keys
reg export "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer" "explorer_backup.reg"
reg export "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion" "system_backup.reg"

# Import registry files
reg import "explorer_backup.reg"
reg import "system_backup.reg"

# PowerShell registry backup
$regPath = "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer"
$backupFile = "explorer_backup.xml"
Get-ItemProperty -Path $regPath | Export-Clixml -Path $backupFile
```

### System Registry Monitoring
```powershell
# Monitor registry changes
$regPath = "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer"
$watcher = Register-ObjectEvent -InputObject (Get-Item $regPath) -EventName Changed -Action {
    Write-Host "Registry key changed: $($Event.SourceEventArgs.FullPath)"
}

# Stop monitoring
Unregister-Event -SourceIdentifier $watcher.Name
```

### Registry Security
```powershell
# View registry permissions
Get-Acl "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer"

# Set registry permissions
$acl = Get-Acl "HKCU:\Software\TestKey"
$accessRule = New-Object System.Security.AccessControl.RegistryAccessRule("Users", "FullControl", "Allow")
$acl.SetAccessRule($accessRule)
Set-Acl "HKCU:\Software\TestKey" $acl
```

## 🔍 Key Concepts
- **Registry Hives**: HKCU, HKLM, HKCR, HKU, HKCC
- **Data Types**: String, DWORD, Binary, Multi-String
- **Security**: Registry permissions and access control
- **Backup**: Export/import for registry backup and restore

## 💡 Learning Points
- Windows registry structure
- Registry operations and management
- Security considerations
- Backup and recovery procedures

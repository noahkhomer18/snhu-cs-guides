# CS-230 Windows PowerShell Basics

## 🎯 Purpose
Demonstrate essential PowerShell commands and scripting for Windows administration.

## 📝 Command Examples

### File and Directory Operations
```powershell
# Navigate directories
Set-Location C:\Users\Student\Documents
Get-Location  # Show current directory
Get-ChildItem  # List files and directories
Get-ChildItem -Force  # Include hidden files

# Create directories and files
New-Item -ItemType Directory -Path "CS230\Lab1"
New-Item -ItemType File -Path "CS230\Lab1\assignment.txt"
"Hello, PowerShell!" | Out-File -FilePath "CS230\Lab1\greeting.txt"

# Copy and move files
Copy-Item "CS230\Lab1\assignment.txt" "CS230\Lab2\"
Move-Item "CS230\Lab1\greeting.txt" "CS230\Lab1\welcome.txt"
Remove-Item "CS230\Lab1\assignment.txt"
```

### File Permissions and Properties
```powershell
# View file properties
Get-ItemProperty "CS230\Lab1\welcome.txt"
Get-Acl "CS230\Lab1\welcome.txt"  # Access control list

# Set file permissions
$acl = Get-Acl "CS230\Lab1\welcome.txt"
$accessRule = New-Object System.Security.AccessControl.FileSystemAccessRule("Users", "FullControl", "Allow")
$acl.SetAccessRule($accessRule)
Set-Acl "CS230\Lab1\welcome.txt" $acl

# File attributes
Set-ItemProperty "CS230\Lab1\welcome.txt" -Name Attributes -Value Hidden
Get-ItemProperty "CS230\Lab1\welcome.txt" | Select-Object Attributes
```

### Process Management
```powershell
# List processes
Get-Process
Get-Process | Where-Object {$_.CPU -gt 10}  # High CPU processes
Get-Process | Sort-Object CPU -Descending | Select-Object -First 10

# Start and stop processes
Start-Process notepad.exe
Stop-Process -Name "notepad" -Force
Get-Process -Name "chrome" | Stop-Process

# Process details
Get-Process -Id 1234 | Format-List *
Get-WmiObject Win32_Process | Where-Object {$_.Name -eq "chrome.exe"}
```

### System Information
```powershell
# System information
Get-ComputerInfo
Get-WmiObject Win32_OperatingSystem
Get-WmiObject Win32_ComputerSystem

# Hardware information
Get-WmiObject Win32_Processor
Get-WmiObject Win32_PhysicalMemory
Get-WmiObject Win32_DiskDrive

# Network information
Get-NetAdapter
Get-NetIPAddress
Test-NetConnection google.com
```

### PowerShell Scripting
```powershell
# Simple script example
$script = @"
# Get system information
Write-Host "Computer Name: $env:COMPUTERNAME"
Write-Host "User: $env:USERNAME"
Write-Host "OS Version: $((Get-WmiObject Win32_OperatingSystem).Version)"

# List running processes
Write-Host "`nTop 5 processes by CPU usage:"
Get-Process | Sort-Object CPU -Descending | Select-Object -First 5 | Format-Table Name, CPU, WorkingSet
"@

$script | Out-File -FilePath "system_info.ps1"
.\system_info.ps1
```

### Registry Operations
```powershell
# Read registry values
Get-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer"
Get-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion" -Name "ProductName"

# Write registry values (requires admin)
Set-ItemProperty -Path "HKCU:\Software\TestKey" -Name "TestValue" -Value "TestData"
New-Item -Path "HKCU:\Software\TestKey" -Force
Remove-Item -Path "HKCU:\Software\TestKey" -Recurse
```

### Event Logs
```powershell
# View event logs
Get-EventLog -LogName System -Newest 10
Get-EventLog -LogName Application -EntryType Error
Get-WinEvent -FilterHashtable @{LogName='System'; Level=2} -MaxEvents 5

# Create custom event log
New-EventLog -LogName "CS230" -Source "LabScript"
Write-EventLog -LogName "CS230" -Source "LabScript" -EventId 1001 -Message "Lab script executed successfully"
```

## 🔍 Key Concepts
- **Cmdlets**: Verb-Noun naming convention (Get-Process, Set-Location)
- **Pipeline**: Passing objects between commands with |
- **Objects**: PowerShell works with .NET objects, not just text
- **Execution Policy**: Security feature controlling script execution

## 💡 Learning Points
- PowerShell vs traditional command prompt
- Object-oriented approach to system administration
- Scripting capabilities and automation
- Integration with Windows management tools

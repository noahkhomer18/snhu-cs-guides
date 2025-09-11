# PowerShell example: get system info
Get-ComputerInfo | Select-Object CsName, WindowsVersion, OsArchitecture

# List running processes
Get-Process

# Kill process by name
Stop-Process -Name "notepad" -Force

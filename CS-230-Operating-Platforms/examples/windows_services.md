# CS-230 Windows Services Management

## 🎯 Purpose
Demonstrate Windows service management using PowerShell and command line tools.

## 📝 Command Examples

### Service Management with PowerShell
```powershell
# List all services
Get-Service
Get-Service | Where-Object {$_.Status -eq "Running"}
Get-Service | Sort-Object Status, Name

# Service details
Get-Service -Name "Spooler"
Get-Service -Name "Spooler" | Format-List *
Get-WmiObject Win32_Service | Where-Object {$_.Name -eq "Spooler"}

# Start and stop services
Start-Service -Name "Spooler"
Stop-Service -Name "Spooler" -Force
Restart-Service -Name "Spooler"
Set-Service -Name "Spooler" -StartupType Automatic
```

### Service Control with SC Command
```cmd
# List services
sc query
sc query spooler
sc query state= all

# Service control
sc start spooler
sc stop spooler
sc pause spooler
sc continue spooler

# Service configuration
sc config spooler start= auto
sc config spooler start= demand
sc config spooler start= disabled
sc qc spooler  # Query service configuration
```

### Service Dependencies
```powershell
# View service dependencies
Get-Service -Name "Spooler" | Select-Object -ExpandProperty ServicesDependedOn
Get-Service -Name "Spooler" | Select-Object -ExpandProperty DependentServices

# Find services that depend on a service
Get-Service | Where-Object {$_.ServicesDependedOn -contains (Get-Service -Name "Spooler")}
```

### Service Logs and Events
```powershell
# View service-related events
Get-WinEvent -FilterHashtable @{LogName='System'; ProviderName='Service Control Manager'} -MaxEvents 10
Get-EventLog -LogName System -Source "Service Control Manager" -Newest 5

# Service startup events
Get-WinEvent -FilterHashtable @{LogName='System'; ID=7036} -MaxEvents 5
```

### Custom Service Creation
```powershell
# Create a simple service (requires admin privileges)
$serviceName = "CS230TestService"
$serviceDisplayName = "CS230 Test Service"
$serviceDescription = "A test service for CS230 lab"

# Create service using New-Service
New-Service -Name $serviceName -DisplayName $serviceDisplayName -Description $serviceDescription -BinaryPathName "C:\Windows\System32\notepad.exe" -StartupType Manual

# Verify service creation
Get-Service -Name $serviceName

# Remove service
Remove-Service -Name $serviceName
```

### Service Monitoring Script
```powershell
# Service monitoring script
$services = @("Spooler", "Themes", "AudioSrv")
$logFile = "C:\temp\service_monitor.log"

foreach ($service in $services) {
    $serviceObj = Get-Service -Name $service -ErrorAction SilentlyContinue
    if ($serviceObj) {
        $status = $serviceObj.Status
        $startType = $serviceObj.StartType
        $timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
        
        $logEntry = "$timestamp - Service: $service, Status: $status, StartType: $startType"
        Write-Host $logEntry
        Add-Content -Path $logFile -Value $logEntry
    } else {
        $logEntry = "$(Get-Date -Format 'yyyy-MM-dd HH:mm:ss') - Service: $service, Status: NOT FOUND"
        Write-Host $logEntry
        Add-Content -Path $logFile -Value $logEntry
    }
}
```

### Service Performance Monitoring
```powershell
# Monitor service performance
Get-Counter "\Process(Spooler)\% Processor Time"
Get-Counter "\Process(Spooler)\Working Set"
Get-Counter "\Process(Spooler)\Handle Count"

# Continuous monitoring
Get-Counter "\Process(Spooler)\% Processor Time" -Continuous -SampleInterval 5
```

## 🔍 Key Concepts
- **Service States**: Stopped, Starting, Running, Stopping, Paused, Pausing, Continuing
- **Startup Types**: Automatic, Manual, Disabled, Automatic (Delayed Start)
- **Service Dependencies**: Services that must be running before this service starts
- **Service Accounts**: Local System, Local Service, Network Service, or custom accounts

## 💡 Learning Points
- Windows service architecture
- Service lifecycle management
- Dependency management
- Service monitoring and troubleshooting
- Security implications of service accounts

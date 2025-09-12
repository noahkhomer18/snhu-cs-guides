# CS-230 Windows Task Scheduler

## 🎯 Purpose
Demonstrate Windows Task Scheduler management using PowerShell and GUI.

## 📝 Command Examples

### Task Scheduler with PowerShell
```powershell
# List all tasks
Get-ScheduledTask
Get-ScheduledTask | Where-Object {$_.State -eq "Running"}
Get-ScheduledTask | Sort-Object TaskName

# Get task details
Get-ScheduledTask -TaskName "TaskName"
Get-ScheduledTaskInfo -TaskName "TaskName"
Get-ScheduledTask -TaskName "TaskName" | Get-ScheduledTaskInfo

# Task actions and triggers
(Get-ScheduledTask -TaskName "TaskName").Actions
(Get-ScheduledTask -TaskName "TaskName").Triggers
```

### Create Scheduled Tasks
```powershell
# Create a simple task
$action = New-ScheduledTaskAction -Execute "notepad.exe"
$trigger = New-ScheduledTaskTrigger -Once -At (Get-Date).AddMinutes(1)
$settings = New-ScheduledTaskSettingsSet -AllowStartIfOnBatteries -DontStopIfGoingOnBatteries

Register-ScheduledTask -Action $action -Trigger $trigger -TaskName "TestTask" -Description "Test scheduled task" -Settings $settings

# Create task with daily trigger
$action = New-ScheduledTaskAction -Execute "powershell.exe" -Argument "-File C:\Scripts\backup.ps1"
$trigger = New-ScheduledTaskTrigger -Daily -At "02:00"
$principal = New-ScheduledTaskPrincipal -UserId "SYSTEM" -LogonType ServiceAccount -RunLevel Highest

Register-ScheduledTask -Action $action -Trigger $trigger -TaskName "DailyBackup" -Description "Daily backup task" -Principal $principal
```

### Task Management
```powershell
# Start and stop tasks
Start-ScheduledTask -TaskName "TestTask"
Stop-ScheduledTask -TaskName "TestTask"
Disable-ScheduledTask -TaskName "TestTask"
Enable-ScheduledTask -TaskName "TestTask"

# Remove tasks
Unregister-ScheduledTask -TaskName "TestTask" -Confirm:$false
```

### Task Monitoring
```powershell
# Get task execution history
Get-ScheduledTask | Get-ScheduledTaskInfo | Where-Object {$_.LastRunTime -ne $null}

# Monitor task status
$tasks = Get-ScheduledTask
foreach ($task in $tasks) {
    $info = Get-ScheduledTaskInfo -TaskName $task.TaskName
    Write-Host "Task: $($task.TaskName), State: $($task.State), Last Run: $($info.LastRunTime)"
}
```

### Advanced Task Configuration
```powershell
# Create task with multiple triggers
$action = New-ScheduledTaskAction -Execute "powershell.exe" -Argument "-File C:\Scripts\monitor.ps1"

# Daily trigger at 9 AM
$dailyTrigger = New-ScheduledTaskTrigger -Daily -At "09:00"

# Weekly trigger on Monday at 10 AM
$weeklyTrigger = New-ScheduledTaskTrigger -Weekly -DaysOfWeek Monday -At "10:00"

# At startup trigger
$startupTrigger = New-ScheduledTaskTrigger -AtStartup

$settings = New-ScheduledTaskSettingsSet -ExecutionTimeLimit (New-TimeSpan -Minutes 30) -RestartCount 3 -RestartInterval (New-TimeSpan -Minutes 5)

Register-ScheduledTask -Action $action -Trigger $dailyTrigger, $weeklyTrigger, $startupTrigger -TaskName "MultiTriggerTask" -Description "Task with multiple triggers" -Settings $settings
```

### Task Export and Import
```powershell
# Export task
Export-ScheduledTask -TaskName "TestTask" | Out-File -FilePath "C:\temp\TestTask.xml"

# Import task
Register-ScheduledTask -Xml (Get-Content "C:\temp\TestTask.xml" -Raw) -TaskName "ImportedTask"
```

### Task Scheduler Events
```powershell
# Monitor Task Scheduler events
Get-WinEvent -FilterHashtable @{LogName='Microsoft-Windows-TaskScheduler/Operational'} -MaxEvents 10

# Filter by event ID
Get-WinEvent -FilterHashtable @{LogName='Microsoft-Windows-TaskScheduler/Operational'; ID=200} -MaxEvents 5
```

## 🔍 Key Concepts
- **Task Actions**: What the task executes
- **Triggers**: When the task runs (time, event, startup)
- **Settings**: Task behavior and constraints
- **Principal**: Security context for task execution
- **Task State**: Ready, Running, Disabled

## 💡 Learning Points
- Task Scheduler architecture
- Task creation and management
- Trigger types and scheduling
- Security considerations
- Monitoring and troubleshooting

# PowerShell script to start PostgreSQL service
# Usage: .\start_postgresql.ps1

Write-Host "Starting PostgreSQL Service..." -ForegroundColor Green

# Check if PostgreSQL is installed
try {
    $psqlVersion = psql --version
    Write-Host "PostgreSQL version found" -ForegroundColor Cyan
} catch {
    Write-Host "Error: PostgreSQL is not installed or not in PATH" -ForegroundColor Red
    Write-Host "Please install PostgreSQL from https://www.postgresql.org/download/windows/" -ForegroundColor Yellow
    exit 1
}

# Check if PostgreSQL service is already running
$pgService = Get-Service -Name "postgresql*" -ErrorAction SilentlyContinue
if ($pgService -and $pgService.Status -eq "Running") {
    Write-Host "PostgreSQL service is already running" -ForegroundColor Green
    Write-Host "Service Status: $($pgService.Status)" -ForegroundColor Cyan
    exit 0
}

# Try to start PostgreSQL service
Write-Host "Starting PostgreSQL service..." -ForegroundColor Yellow
try {
    # Try different possible service names
    $serviceNames = @("postgresql", "postgresql-x64-*", "postgresql-*")
    
    foreach ($serviceName in $serviceNames) {
        $service = Get-Service -Name $serviceName -ErrorAction SilentlyContinue
        if ($service) {
            Write-Host "Found PostgreSQL service: $($service.Name)" -ForegroundColor Cyan
            Start-Service -Name $service.Name
            Write-Host "PostgreSQL service started successfully!" -ForegroundColor Green
            break
        }
    }
    
    if (-not $service) {
        throw "PostgreSQL service not found"
    }
} catch {
    Write-Host "Failed to start PostgreSQL service. Trying alternative methods..." -ForegroundColor Yellow
    
    # Try starting with pg_ctl
    Write-Host "Attempting to start PostgreSQL with pg_ctl..." -ForegroundColor Cyan
    
    # Find PostgreSQL installation directory
    $pgPath = Get-Command psql | Select-Object -ExpandProperty Source | Split-Path -Parent
    $pgData = Join-Path $pgPath "data"
    
    if (Test-Path $pgData) {
        Write-Host "Starting PostgreSQL with data directory: $pgData" -ForegroundColor Green
        & "$pgPath\pg_ctl.exe" start -D $pgData
    } else {
        Write-Host "PostgreSQL data directory not found at: $pgData" -ForegroundColor Red
        Write-Host "Please check your PostgreSQL installation" -ForegroundColor Yellow
        exit 1
    }
}

# Display connection information
Write-Host "`nPostgreSQL Connection Information:" -ForegroundColor Cyan
Write-Host "Host: localhost" -ForegroundColor White
Write-Host "Port: 5432" -ForegroundColor White
Write-Host "Database: postgres (default)" -ForegroundColor White
Write-Host "Username: postgres (default)" -ForegroundColor White
Write-Host "`nTo connect using psql:" -ForegroundColor Yellow
Write-Host "psql -U postgres -h localhost" -ForegroundColor White

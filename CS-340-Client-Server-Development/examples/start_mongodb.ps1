# PowerShell script to start MongoDB service
# Usage: .\start_mongodb.ps1

Write-Host "Starting MongoDB Service..." -ForegroundColor Green

# Check if MongoDB is installed
try {
    $mongoVersion = mongod --version
    Write-Host "MongoDB version found" -ForegroundColor Cyan
} catch {
    Write-Host "Error: MongoDB is not installed or not in PATH" -ForegroundColor Red
    Write-Host "Please install MongoDB from https://www.mongodb.com/try/download/community" -ForegroundColor Yellow
    exit 1
}

# Check if MongoDB service is already running
$mongoService = Get-Service -Name "MongoDB" -ErrorAction SilentlyContinue
if ($mongoService -and $mongoService.Status -eq "Running") {
    Write-Host "MongoDB service is already running" -ForegroundColor Green
    Write-Host "Service Status: $($mongoService.Status)" -ForegroundColor Cyan
    exit 0
}

# Try to start MongoDB service
Write-Host "Starting MongoDB service..." -ForegroundColor Yellow
try {
    Start-Service -Name "MongoDB"
    Write-Host "MongoDB service started successfully!" -ForegroundColor Green
} catch {
    Write-Host "Failed to start MongoDB service. Trying alternative methods..." -ForegroundColor Yellow
    
    # Try starting with mongod directly
    Write-Host "Attempting to start MongoDB daemon directly..." -ForegroundColor Cyan
    
    # Create data directory if it doesn't exist
    $dataDir = "C:\data\db"
    if (-not (Test-Path $dataDir)) {
        Write-Host "Creating data directory: $dataDir" -ForegroundColor Yellow
        New-Item -ItemType Directory -Path $dataDir -Force
    }
    
    # Start mongod in background
    Write-Host "Starting MongoDB daemon..." -ForegroundColor Green
    Start-Process -FilePath "mongod" -ArgumentList "--dbpath", $dataDir -WindowStyle Hidden
    
    # Wait a moment for MongoDB to start
    Start-Sleep -Seconds 3
    
    # Check if MongoDB is running
    try {
        $mongoClient = mongo --eval "db.runCommand('ping')" --quiet
        if ($LASTEXITCODE -eq 0) {
            Write-Host "MongoDB is running successfully!" -ForegroundColor Green
        } else {
            Write-Host "MongoDB may not be running properly" -ForegroundColor Red
        }
    } catch {
        Write-Host "Could not verify MongoDB connection" -ForegroundColor Yellow
    }
}

# Display connection information
Write-Host "`nMongoDB Connection Information:" -ForegroundColor Cyan
Write-Host "Host: localhost" -ForegroundColor White
Write-Host "Port: 27017" -ForegroundColor White
Write-Host "Database: admin (default)" -ForegroundColor White
Write-Host "`nTo connect using MongoDB Compass:" -ForegroundColor Yellow
Write-Host "mongodb://localhost:27017" -ForegroundColor White

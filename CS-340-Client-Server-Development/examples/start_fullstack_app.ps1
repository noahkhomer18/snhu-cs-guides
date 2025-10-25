# PowerShell script to start a full-stack application (frontend + backend)
# Usage: .\start_fullstack_app.ps1

Write-Host "Starting Full-Stack Application..." -ForegroundColor Green

# Check if Node.js is installed
try {
    $nodeVersion = node --version
    Write-Host "Node.js version: $nodeVersion" -ForegroundColor Cyan
} catch {
    Write-Host "Error: Node.js is not installed or not in PATH" -ForegroundColor Red
    Write-Host "Please install Node.js from https://nodejs.org/" -ForegroundColor Yellow
    exit 1
}

# Function to start backend server
function Start-Backend {
    Write-Host "`nStarting Backend Server..." -ForegroundColor Cyan
    
    # Check if backend directory exists
    if (Test-Path "backend") {
        Set-Location "backend"
        Write-Host "Found backend directory, starting backend server..." -ForegroundColor Green
        
        # Install dependencies
        if (-not (Test-Path "node_modules")) {
            Write-Host "Installing backend dependencies..." -ForegroundColor Yellow
            npm install
        }
        
        # Start backend server
        Write-Host "Starting backend server..." -ForegroundColor Green
        Start-Process -FilePath "npm" -ArgumentList "start" -WindowStyle Normal
        Set-Location ".."
    } elseif (Test-Path "server") {
        Set-Location "server"
        Write-Host "Found server directory, starting server..." -ForegroundColor Green
        
        # Install dependencies
        if (-not (Test-Path "node_modules")) {
            Write-Host "Installing server dependencies..." -ForegroundColor Yellow
            npm install
        }
        
        # Start server
        Write-Host "Starting server..." -ForegroundColor Green
        Start-Process -FilePath "npm" -ArgumentList "start" -WindowStyle Normal
        Set-Location ".."
    } else {
        Write-Host "No backend/server directory found. Starting from root..." -ForegroundColor Yellow
        
        # Install dependencies
        if (-not (Test-Path "node_modules")) {
            Write-Host "Installing dependencies..." -ForegroundColor Yellow
            npm install
        }
        
        # Start server
        Write-Host "Starting server..." -ForegroundColor Green
        Start-Process -FilePath "npm" -ArgumentList "start" -WindowStyle Normal
    }
}

# Function to start frontend server
function Start-Frontend {
    Write-Host "`nStarting Frontend Server..." -ForegroundColor Cyan
    
    # Check if frontend directory exists
    if (Test-Path "frontend") {
        Set-Location "frontend"
        Write-Host "Found frontend directory, starting frontend server..." -ForegroundColor Green
        
        # Install dependencies
        if (-not (Test-Path "node_modules")) {
            Write-Host "Installing frontend dependencies..." -ForegroundColor Yellow
            npm install
        }
        
        # Start frontend server
        Write-Host "Starting frontend server..." -ForegroundColor Green
        Start-Process -FilePath "npm" -ArgumentList "start" -WindowStyle Normal
        Set-Location ".."
    } elseif (Test-Path "client") {
        Set-Location "client"
        Write-Host "Found client directory, starting client server..." -ForegroundColor Green
        
        # Install dependencies
        if (-not (Test-Path "node_modules")) {
            Write-Host "Installing client dependencies..." -ForegroundColor Yellow
            npm install
        }
        
        # Start client server
        Write-Host "Starting client server..." -ForegroundColor Green
        Start-Process -FilePath "npm" -ArgumentList "start" -WindowStyle Normal
        Set-Location ".."
    } else {
        Write-Host "No frontend/client directory found." -ForegroundColor Yellow
        Write-Host "Assuming single-page application structure..." -ForegroundColor Cyan
    }
}

# Start both servers
Start-Backend
Start-Sleep -Seconds 2
Start-Frontend

# Display application information
Write-Host "`nFull-Stack Application Started!" -ForegroundColor Green
Write-Host "`nApplication URLs:" -ForegroundColor Cyan
Write-Host "Backend API: http://localhost:3000 (or 5000)" -ForegroundColor White
Write-Host "Frontend App: http://localhost:3001 (or 3000)" -ForegroundColor White
Write-Host "`nPress Ctrl+C to stop all servers" -ForegroundColor Yellow

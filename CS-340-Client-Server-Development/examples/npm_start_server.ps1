# PowerShell script to start a Node.js development server
# Usage: .\npm_start_server.ps1

Write-Host "Starting Node.js Development Server..." -ForegroundColor Green

# Check if Node.js is installed
try {
    $nodeVersion = node --version
    Write-Host "Node.js version: $nodeVersion" -ForegroundColor Cyan
} catch {
    Write-Host "Error: Node.js is not installed or not in PATH" -ForegroundColor Red
    Write-Host "Please install Node.js from https://nodejs.org/" -ForegroundColor Yellow
    exit 1
}

# Check if npm is available
try {
    $npmVersion = npm --version
    Write-Host "npm version: $npmVersion" -ForegroundColor Cyan
} catch {
    Write-Host "Error: npm is not available" -ForegroundColor Red
    exit 1
}

# Check if package.json exists
if (-not (Test-Path "package.json")) {
    Write-Host "Error: package.json not found in current directory" -ForegroundColor Red
    Write-Host "Please run this script from your project root directory" -ForegroundColor Yellow
    exit 1
}

# Install dependencies if node_modules doesn't exist
if (-not (Test-Path "node_modules")) {
    Write-Host "Installing dependencies..." -ForegroundColor Yellow
    npm install
    if ($LASTEXITCODE -ne 0) {
        Write-Host "Error: Failed to install dependencies" -ForegroundColor Red
        exit 1
    }
}

# Start the development server
Write-Host "Starting development server with 'npm start'..." -ForegroundColor Green
npm start

# If npm start fails, try alternative commands
if ($LASTEXITCODE -ne 0) {
    Write-Host "npm start failed, trying 'npm run dev'..." -ForegroundColor Yellow
    npm run dev
    
    if ($LASTEXITCODE -ne 0) {
        Write-Host "npm run dev failed, trying 'node server.js'..." -ForegroundColor Yellow
        node server.js
        
        if ($LASTEXITCODE -ne 0) {
            Write-Host "All start methods failed. Check your package.json scripts." -ForegroundColor Red
            exit 1
        }
    }
}

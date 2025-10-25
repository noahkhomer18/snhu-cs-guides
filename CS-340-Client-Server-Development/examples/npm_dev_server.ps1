# PowerShell script to start a Node.js development server with hot reload
# Usage: .\npm_dev_server.ps1

Write-Host "Starting Node.js Development Server with Hot Reload..." -ForegroundColor Green

# Check if Node.js is installed
try {
    $nodeVersion = node --version
    Write-Host "Node.js version: $nodeVersion" -ForegroundColor Cyan
} catch {
    Write-Host "Error: Node.js is not installed or not in PATH" -ForegroundColor Red
    Write-Host "Please install Node.js from https://nodejs.org/" -ForegroundColor Yellow
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

# Try different development server commands
Write-Host "Attempting to start development server..." -ForegroundColor Green

# Try npm run dev first
Write-Host "Trying 'npm run dev'..." -ForegroundColor Cyan
npm run dev

if ($LASTEXITCODE -ne 0) {
    # Try npm run start:dev
    Write-Host "Trying 'npm run start:dev'..." -ForegroundColor Cyan
    npm run start:dev
    
    if ($LASTEXITCODE -ne 0) {
        # Try npm run development
        Write-Host "Trying 'npm run development'..." -ForegroundColor Cyan
        npm run development
        
        if ($LASTEXITCODE -ne 0) {
            # Try with nodemon if available
            Write-Host "Trying 'npx nodemon server.js'..." -ForegroundColor Cyan
            npx nodemon server.js
            
            if ($LASTEXITCODE -ne 0) {
                Write-Host "All development server methods failed." -ForegroundColor Red
                Write-Host "Please check your package.json scripts or install nodemon:" -ForegroundColor Yellow
                Write-Host "npm install --save-dev nodemon" -ForegroundColor Yellow
                exit 1
            }
        }
    }
}

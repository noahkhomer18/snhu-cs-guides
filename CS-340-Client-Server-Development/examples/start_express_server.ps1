# PowerShell script to start an Express.js server
# Usage: .\start_express_server.ps1

Write-Host "Starting Express.js Server..." -ForegroundColor Green

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

# Check if Express is installed
$expressInstalled = npm list express --depth=0 2>$null
if (-not $expressInstalled) {
    Write-Host "Express.js not found. Installing Express..." -ForegroundColor Yellow
    npm install express
    if ($LASTEXITCODE -ne 0) {
        Write-Host "Error: Failed to install Express" -ForegroundColor Red
        exit 1
    }
}

# Try different ways to start the Express server
Write-Host "Starting Express server..." -ForegroundColor Green

# Try npm start first
Write-Host "Trying 'npm start'..." -ForegroundColor Cyan
npm start

if ($LASTEXITCODE -ne 0) {
    # Try npm run dev
    Write-Host "Trying 'npm run dev'..." -ForegroundColor Cyan
    npm run dev
    
    if ($LASTEXITCODE -ne 0) {
        # Try node app.js
        Write-Host "Trying 'node app.js'..." -ForegroundColor Cyan
        node app.js
        
        if ($LASTEXITCODE -ne 0) {
            # Try node server.js
            Write-Host "Trying 'node server.js'..." -ForegroundColor Cyan
            node server.js
            
            if ($LASTEXITCODE -ne 0) {
                # Try node index.js
                Write-Host "Trying 'node index.js'..." -ForegroundColor Cyan
                node index.js
                
                if ($LASTEXITCODE -ne 0) {
                    Write-Host "All server start methods failed." -ForegroundColor Red
                    Write-Host "Please check your package.json scripts or create a server file." -ForegroundColor Yellow
                    exit 1
                }
            }
        }
    }
}

# Display server information
Write-Host "`nExpress Server Information:" -ForegroundColor Cyan
Write-Host "Default URL: http://localhost:3000" -ForegroundColor White
Write-Host "Press Ctrl+C to stop the server" -ForegroundColor Yellow

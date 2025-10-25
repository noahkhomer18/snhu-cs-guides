# PowerShell script to start a React development server
# Usage: .\start_react_app.ps1

Write-Host "Starting React Development Server..." -ForegroundColor Green

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

# Check if React is installed
$reactInstalled = npm list react --depth=0 2>$null
if (-not $reactInstalled) {
    Write-Host "React not found. Installing React..." -ForegroundColor Yellow
    npm install react react-dom react-scripts
    if ($LASTEXITCODE -ne 0) {
        Write-Host "Error: Failed to install React" -ForegroundColor Red
        exit 1
    }
}

# Try different ways to start the React server
Write-Host "Starting React development server..." -ForegroundColor Green

# Try npm start first
Write-Host "Trying 'npm start'..." -ForegroundColor Cyan
npm start

if ($LASTEXITCODE -ne 0) {
    # Try npm run dev
    Write-Host "Trying 'npm run dev'..." -ForegroundColor Cyan
    npm run dev
    
    if ($LASTEXITCODE -ne 0) {
        # Try npm run start:dev
        Write-Host "Trying 'npm run start:dev'..." -ForegroundColor Cyan
        npm run start:dev
        
        if ($LASTEXITCODE -ne 0) {
            Write-Host "All React start methods failed." -ForegroundColor Red
            Write-Host "Please check your package.json scripts or create a React app with:" -ForegroundColor Yellow
            Write-Host "npx create-react-app my-app" -ForegroundColor White
            exit 1
        }
    }
}

# Display server information
Write-Host "`nReact Development Server Information:" -ForegroundColor Cyan
Write-Host "Default URL: http://localhost:3000" -ForegroundColor White
Write-Host "Hot reload is enabled" -ForegroundColor Green
Write-Host "Press Ctrl+C to stop the server" -ForegroundColor Yellow

# PowerShell script to deploy application to production
# Usage: .\deploy_to_production.ps1

Write-Host "Deploying Application to Production..." -ForegroundColor Green

# Check if Node.js is installed
try {
    $nodeVersion = node --version
    Write-Host "Node.js version: $nodeVersion" -ForegroundColor Cyan
} catch {
    Write-Host "Error: Node.js is not installed or not in PATH" -ForegroundColor Red
    exit 1
}

# Check if package.json exists
if (-not (Test-Path "package.json")) {
    Write-Host "Error: package.json not found in current directory" -ForegroundColor Red
    exit 1
}

# Build the application
Write-Host "Building application for production..." -ForegroundColor Yellow
npm run build

if ($LASTEXITCODE -ne 0) {
    Write-Host "Error: Build failed" -ForegroundColor Red
    exit 1
}

# Install production dependencies
Write-Host "Installing production dependencies..." -ForegroundColor Yellow
npm ci --only=production

if ($LASTEXITCODE -ne 0) {
    Write-Host "Error: Failed to install production dependencies" -ForegroundColor Red
    exit 1
}

# Create production package
Write-Host "Creating production package..." -ForegroundColor Yellow
npm pack

if ($LASTEXITCODE -ne 0) {
    Write-Host "Error: Failed to create production package" -ForegroundColor Red
    exit 1
}

# Display deployment information
Write-Host "`nProduction Deployment Completed!" -ForegroundColor Green
Write-Host "`nDeployment Information:" -ForegroundColor Cyan
Write-Host "Build directory: dist/ (or build/)" -ForegroundColor White
Write-Host "Package file: *.tgz" -ForegroundColor White
Write-Host "`nNext steps:" -ForegroundColor Yellow
Write-Host "1. Upload the package to your production server" -ForegroundColor White
Write-Host "2. Install dependencies: npm install --production" -ForegroundColor White
Write-Host "3. Start the application: npm start" -ForegroundColor White
Write-Host "4. Set up process manager (PM2) for production" -ForegroundColor White

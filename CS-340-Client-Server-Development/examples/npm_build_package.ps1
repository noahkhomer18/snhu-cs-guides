# PowerShell script to build and package a Node.js application
# Usage: .\npm_build_package.ps1

Write-Host "Building and Packaging Node.js Application..." -ForegroundColor Green

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
    Write-Host "Please run this script from your project root directory" -ForegroundColor Yellow
    exit 1
}

# Clean previous builds
if (Test-Path "dist") {
    Write-Host "Cleaning previous build..." -ForegroundColor Yellow
    Remove-Item -Recurse -Force "dist"
}

if (Test-Path "build") {
    Write-Host "Cleaning previous build..." -ForegroundColor Yellow
    Remove-Item -Recurse -Force "build"
}

# Install dependencies
Write-Host "Installing dependencies..." -ForegroundColor Yellow
npm install
if ($LASTEXITCODE -ne 0) {
    Write-Host "Error: Failed to install dependencies" -ForegroundColor Red
    exit 1
}

# Run build command
Write-Host "Building application..." -ForegroundColor Green
npm run build

if ($LASTEXITCODE -ne 0) {
    Write-Host "Error: Build failed" -ForegroundColor Red
    Write-Host "Please check your build script in package.json" -ForegroundColor Yellow
    exit 1
}

# Check if build was successful
if (Test-Path "dist" -or Test-Path "build") {
    Write-Host "Build completed successfully!" -ForegroundColor Green
    
    # Show build output size
    if (Test-Path "dist") {
        $distSize = (Get-ChildItem -Recurse "dist" | Measure-Object -Property Length -Sum).Sum
        Write-Host "Build size: $([math]::Round($distSize/1MB, 2)) MB" -ForegroundColor Cyan
    }
    
    if (Test-Path "build") {
        $buildSize = (Get-ChildItem -Recurse "build" | Measure-Object -Property Length -Sum).Sum
        Write-Host "Build size: $([math]::Round($buildSize/1MB, 2)) MB" -ForegroundColor Cyan
    }
} else {
    Write-Host "Warning: No build output directory found" -ForegroundColor Yellow
}

# Optional: Create production package
$createPackage = Read-Host "Do you want to create a production package? (y/n)"
if ($createPackage -eq "y" -or $createPackage -eq "Y") {
    Write-Host "Creating production package..." -ForegroundColor Green
    
    # Install production dependencies only
    npm ci --only=production
    
    # Create tarball
    npm pack
    
    if ($LASTEXITCODE -eq 0) {
        Write-Host "Production package created successfully!" -ForegroundColor Green
    } else {
        Write-Host "Failed to create production package" -ForegroundColor Red
    }
}

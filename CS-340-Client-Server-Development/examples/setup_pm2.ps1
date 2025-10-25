# PowerShell script to set up PM2 process manager for production
# Usage: .\setup_pm2.ps1

Write-Host "Setting up PM2 Process Manager..." -ForegroundColor Green

# Check if Node.js is installed
try {
    $nodeVersion = node --version
    Write-Host "Node.js version: $nodeVersion" -ForegroundColor Cyan
} catch {
    Write-Host "Error: Node.js is not installed or not in PATH" -ForegroundColor Red
    exit 1
}

# Install PM2 globally
Write-Host "Installing PM2 globally..." -ForegroundColor Yellow
npm install -g pm2

if ($LASTEXITCODE -ne 0) {
    Write-Host "Error: Failed to install PM2" -ForegroundColor Red
    exit 1
}

# Create PM2 ecosystem file
Write-Host "Creating PM2 ecosystem file..." -ForegroundColor Yellow
$ecosystemContent = @"
module.exports = {
  apps: [{
    name: 'cs340-app',
    script: 'server.js',
    instances: 'max',
    exec_mode: 'cluster',
    env: {
      NODE_ENV: 'development',
      PORT: 3000
    },
    env_production: {
      NODE_ENV: 'production',
      PORT: 3000
    },
    error_file: './logs/err.log',
    out_file: './logs/out.log',
    log_file: './logs/combined.log',
    time: true
  }]
}
"@

$ecosystemContent | Out-File -FilePath "ecosystem.config.js" -Encoding UTF8

# Create logs directory
if (-not (Test-Path "logs")) {
    New-Item -ItemType Directory -Path "logs" -Force
    Write-Host "Created logs directory" -ForegroundColor Green
}

# Start application with PM2
Write-Host "Starting application with PM2..." -ForegroundColor Green
pm2 start ecosystem.config.js

if ($LASTEXITCODE -eq 0) {
    Write-Host "Application started with PM2 successfully!" -ForegroundColor Green
} else {
    Write-Host "Failed to start application with PM2" -ForegroundColor Red
    exit 1
}

# Save PM2 configuration
Write-Host "Saving PM2 configuration..." -ForegroundColor Yellow
pm2 save

# Setup PM2 startup
Write-Host "Setting up PM2 startup..." -ForegroundColor Yellow
pm2 startup

# Display PM2 status
Write-Host "`nPM2 Status:" -ForegroundColor Cyan
pm2 status

Write-Host "`nPM2 Commands:" -ForegroundColor Cyan
Write-Host "pm2 status          - Show running processes" -ForegroundColor White
Write-Host "pm2 restart all     - Restart all processes" -ForegroundColor White
Write-Host "pm2 stop all        - Stop all processes" -ForegroundColor White
Write-Host "pm2 logs            - Show logs" -ForegroundColor White
Write-Host "pm2 monit           - Monitor processes" -ForegroundColor White

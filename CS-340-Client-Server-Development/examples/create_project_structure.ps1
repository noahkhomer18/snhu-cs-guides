# PowerShell script to create a new CS-340 project structure
# Usage: .\create_project_structure.ps1

param(
    [Parameter(Mandatory=$true)]
    [string]$ProjectName
)

Write-Host "Creating CS-340 Project Structure for: $ProjectName" -ForegroundColor Green

# Create main project directory
if (-not (Test-Path $ProjectName)) {
    New-Item -ItemType Directory -Path $ProjectName -Force
    Write-Host "Created project directory: $ProjectName" -ForegroundColor Green
} else {
    Write-Host "Project directory already exists: $ProjectName" -ForegroundColor Yellow
}

Set-Location $ProjectName

# Create standard project structure
$directories = @(
    "src",
    "src/controllers",
    "src/models", 
    "src/routes",
    "src/middleware",
    "src/utils",
    "src/config",
    "public",
    "public/css",
    "public/js",
    "public/images",
    "views",
    "tests",
    "tests/unit",
    "tests/integration",
    "logs",
    "docs",
    "scripts"
)

foreach ($dir in $directories) {
    if (-not (Test-Path $dir)) {
        New-Item -ItemType Directory -Path $dir -Force
        Write-Host "Created directory: $dir" -ForegroundColor Cyan
    }
}

# Create essential files
Write-Host "`nCreating essential project files..." -ForegroundColor Yellow

# package.json
$packageJson = @"
{
  "name": "$($ProjectName.ToLower())",
  "version": "1.0.0",
  "description": "CS-340 Client-Server Development Project",
  "main": "src/app.js",
  "scripts": {
    "start": "node src/app.js",
    "dev": "nodemon src/app.js",
    "test": "jest",
    "build": "npm run build:css && npm run build:js",
    "build:css": "sass public/css/styles.scss public/css/styles.css",
    "build:js": "webpack --mode production"
  },
  "keywords": ["cs340", "nodejs", "express", "client-server"],
  "author": "",
  "license": "MIT",
  "dependencies": {
    "express": "^4.18.2",
    "mongoose": "^7.5.0",
    "cors": "^2.8.5",
    "dotenv": "^16.3.1"
  },
  "devDependencies": {
    "nodemon": "^3.0.1",
    "jest": "^29.6.2",
    "webpack": "^5.88.2",
    "sass": "^1.66.1"
  }
}
"@

$packageJson | Out-File -FilePath "package.json" -Encoding UTF8
Write-Host "Created package.json" -ForegroundColor Green

# .env template
$envTemplate = @"
# Database Configuration
DB_HOST=localhost
DB_PORT=27017
DB_NAME=$($ProjectName.ToLower())_db

# Server Configuration
PORT=3000
NODE_ENV=development

# API Keys (add your keys here)
API_KEY=your_api_key_here
"@

$envTemplate | Out-File -FilePath ".env.example" -Encoding UTF8
Write-Host "Created .env.example" -ForegroundColor Green

# .gitignore
$gitignore = @"
node_modules/
.env
logs/
*.log
.DS_Store
Thumbs.db
dist/
build/
coverage/
.nyc_output/
"@

$gitignore | Out-File -FilePath ".gitignore" -Encoding UTF8
Write-Host "Created .gitignore" -ForegroundColor Green

# README.md
$readme = @"
# $ProjectName

CS-340 Client-Server Development Project

## Setup

1. Install dependencies:
   ```bash
   npm install
   ```

2. Copy environment file:
   ```bash
   copy .env.example .env
   ```

3. Start development server:
   ```bash
   npm run dev
   ```

## Project Structure

- `src/` - Source code
- `public/` - Static assets
- `views/` - Templates
- `tests/` - Test files
- `docs/` - Documentation
- `scripts/` - Utility scripts

## Scripts

- `npm start` - Start production server
- `npm run dev` - Start development server with hot reload
- `npm test` - Run tests
- `npm run build` - Build for production
"@

$readme | Out-File -FilePath "README.md" -Encoding UTF8
Write-Host "Created README.md" -ForegroundColor Green

Write-Host "`nProject structure created successfully!" -ForegroundColor Green
Write-Host "`nNext steps:" -ForegroundColor Cyan
Write-Host "1. cd $ProjectName" -ForegroundColor White
Write-Host "2. npm install" -ForegroundColor White
Write-Host "3. copy .env.example .env" -ForegroundColor White
Write-Host "4. npm run dev" -ForegroundColor White

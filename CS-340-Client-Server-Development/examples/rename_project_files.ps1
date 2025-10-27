# PowerShell script to rename and reorganize project files
# Usage: .\rename_project_files.ps1

Write-Host "CS-340 Project File Renaming and Organization Tool" -ForegroundColor Green

# Function to rename files with proper naming conventions
function Rename-ProjectFiles {
    Write-Host "`nRenaming files to follow CS-340 conventions..." -ForegroundColor Yellow
    
    # Rename common files to follow conventions
    $renameMap = @{
        "app.js" = "server.js"
        "index.js" = "app.js"
        "main.js" = "index.js"
        "config.js" = "database.js"
        "db.js" = "connection.js"
    }
    
    foreach ($oldName in $renameMap.Keys) {
        $newName = $renameMap[$oldName]
        if (Test-Path $oldName) {
            Rename-Item -Path $oldName -NewName $newName
            Write-Host "Renamed: $oldName -> $newName" -ForegroundColor Cyan
        }
    }
}

# Function to organize files into proper directories
function Organize-ProjectFiles {
    Write-Host "`nOrganizing files into proper directory structure..." -ForegroundColor Yellow
    
    # Move JavaScript files to src directory
    $jsFiles = Get-ChildItem -Filter "*.js" -File | Where-Object { $_.Name -ne "package.json" }
    foreach ($file in $jsFiles) {
        if (-not (Test-Path "src")) {
            New-Item -ItemType Directory -Path "src" -Force
        }
        Move-Item -Path $file.FullName -Destination "src\" -Force
        Write-Host "Moved: $($file.Name) -> src/" -ForegroundColor Cyan
    }
    
    # Move CSS files to public/css
    $cssFiles = Get-ChildItem -Filter "*.css" -File
    foreach ($file in $cssFiles) {
        if (-not (Test-Path "public/css")) {
            New-Item -ItemType Directory -Path "public/css" -Force
        }
        Move-Item -Path $file.FullName -Destination "public/css\" -Force
        Write-Host "Moved: $($file.Name) -> public/css/" -ForegroundColor Cyan
    }
    
    # Move HTML files to views
    $htmlFiles = Get-ChildItem -Filter "*.html" -File
    foreach ($file in $htmlFiles) {
        if (-not (Test-Path "views")) {
            New-Item -ItemType Directory -Path "views" -Force
        }
        Move-Item -Path $file.FullName -Destination "views\" -Force
        Write-Host "Moved: $($file.Name) -> views/" -ForegroundColor Cyan
    }
}

# Function to create missing directories
function Create-MissingDirectories {
    Write-Host "`nCreating missing directories..." -ForegroundColor Yellow
    
    $directories = @(
        "src/controllers",
        "src/models",
        "src/routes", 
        "src/middleware",
        "src/utils",
        "src/config",
        "public/css",
        "public/js",
        "public/images",
        "views",
        "tests",
        "logs",
        "docs"
    )
    
    foreach ($dir in $directories) {
        if (-not (Test-Path $dir)) {
            New-Item -ItemType Directory -Path $dir -Force
            Write-Host "Created directory: $dir" -ForegroundColor Green
        }
    }
}

# Function to update package.json scripts
function Update-PackageScripts {
    Write-Host "`nUpdating package.json scripts..." -ForegroundColor Yellow
    
    if (Test-Path "package.json") {
        $packageContent = Get-Content "package.json" -Raw | ConvertFrom-Json
        
        # Update scripts section
        $packageContent.scripts = @{
            "start" = "node src/server.js"
            "dev" = "nodemon src/server.js"
            "test" = "jest"
            "build" = "npm run build:css"
            "build:css" = "sass public/css/styles.scss public/css/styles.css"
            "lint" = "eslint src/"
            "format" = "prettier --write src/"
        }
        
        $packageContent | ConvertTo-Json -Depth 10 | Out-File -FilePath "package.json" -Encoding UTF8
        Write-Host "Updated package.json scripts" -ForegroundColor Green
    }
}

# Main execution
Write-Host "Starting project file organization..." -ForegroundColor Green

# Check if we're in a project directory
if (-not (Test-Path "package.json")) {
    Write-Host "Error: No package.json found. Please run this script from your project root directory." -ForegroundColor Red
    exit 1
}

# Execute organization functions
Create-MissingDirectories
Rename-ProjectFiles
Organize-ProjectFiles
Update-PackageScripts

Write-Host "`nProject organization completed!" -ForegroundColor Green
Write-Host "`nYour project now follows CS-340 best practices:" -ForegroundColor Cyan
Write-Host "✓ Proper directory structure" -ForegroundColor White
Write-Host "✓ Files organized by type" -ForegroundColor White
Write-Host "✓ Updated package.json scripts" -ForegroundColor White
Write-Host "✓ Consistent naming conventions" -ForegroundColor White

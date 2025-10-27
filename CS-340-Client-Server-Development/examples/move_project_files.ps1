# PowerShell script to move and organize project files
# Usage: .\move_project_files.ps1

Write-Host "CS-340 Project File Movement and Organization Tool" -ForegroundColor Green

# Function to move files to appropriate directories
function Move-FilesToDirectories {
    Write-Host "`nMoving files to appropriate directories..." -ForegroundColor Yellow
    
    # Move JavaScript files to src
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
    
    # Move SCSS files to public/css
    $scssFiles = Get-ChildItem -Filter "*.scss" -File
    foreach ($file in $scssFiles) {
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
    
    # Move image files to public/images
    $imageFiles = Get-ChildItem -Filter "*.jpg", "*.jpeg", "*.png", "*.gif", "*.svg" -File
    foreach ($file in $imageFiles) {
        if (-not (Test-Path "public/images")) {
            New-Item -ItemType Directory -Path "public/images" -Force
        }
        Move-Item -Path $file.FullName -Destination "public/images\" -Force
        Write-Host "Moved: $($file.Name) -> public/images/" -ForegroundColor Cyan
    }
    
    # Move test files to tests
    $testFiles = Get-ChildItem -Filter "*test*.js", "*spec*.js" -File
    foreach ($file in $testFiles) {
        if (-not (Test-Path "tests")) {
            New-Item -ItemType Directory -Path "tests" -Force
        }
        Move-Item -Path $file.FullName -Destination "tests\" -Force
        Write-Host "Moved: $($file.Name) -> tests/" -ForegroundColor Cyan
    }
}

# Function to organize by file type
function Organize-ByFileType {
    Write-Host "`nOrganizing files by type..." -ForegroundColor Yellow
    
    # Create type-specific directories
    $typeDirectories = @{
        "controllers" = "src/controllers"
        "models" = "src/models"
        "routes" = "src/routes"
        "middleware" = "src/middleware"
        "utils" = "src/utils"
        "config" = "src/config"
    }
    
    foreach ($type in $typeDirectories.Keys) {
        $dir = $typeDirectories[$type]
        if (-not (Test-Path $dir)) {
            New-Item -ItemType Directory -Path $dir -Force
            Write-Host "Created directory: $dir" -ForegroundColor Green
        }
    }
    
    # Move files based on naming patterns
    $patterns = @{
        "*controller*" = "src/controllers"
        "*model*" = "src/models"
        "*route*" = "src/routes"
        "*middleware*" = "src/middleware"
        "*util*" = "src/utils"
        "*config*" = "src/config"
    }
    
    foreach ($pattern in $patterns.Keys) {
        $destination = $patterns[$pattern]
        $files = Get-ChildItem -Filter $pattern -File -Recurse
        foreach ($file in $files) {
            if ($file.DirectoryName -ne (Resolve-Path $destination)) {
                Move-Item -Path $file.FullName -Destination $destination -Force
                Write-Host "Moved: $($file.Name) -> $destination" -ForegroundColor Cyan
            }
        }
    }
}

# Function to flatten directory structure
function Flatten-DirectoryStructure {
    Write-Host "`nFlattening directory structure..." -ForegroundColor Yellow
    
    $flatten = Read-Host "Do you want to flatten the directory structure? (y/n)"
    if ($flatten -eq "y" -or $flatten -eq "Y") {
        # Move all files from subdirectories to root
        $subdirs = Get-ChildItem -Directory | Where-Object { $_.Name -ne "node_modules" -and $_.Name -ne ".git" }
        
        foreach ($subdir in $subdirs) {
            $files = Get-ChildItem -Path $subdir.FullName -File -Recurse
            foreach ($file in $files) {
                $newName = "$($subdir.Name)_$($file.Name)"
                Move-Item -Path $file.FullName -Destination $newName -Force
                Write-Host "Moved: $($file.Name) -> $newName" -ForegroundColor Cyan
            }
            
            # Remove empty subdirectory
            if ((Get-ChildItem -Path $subdir.FullName -Recurse | Measure-Object).Count -eq 0) {
                Remove-Item -Path $subdir.FullName -Force
                Write-Host "Removed empty directory: $($subdir.Name)" -ForegroundColor Red
            }
        }
    }
}

# Function to create symbolic links
function Create-SymbolicLinks {
    Write-Host "`nCreating symbolic links for common files..." -ForegroundColor Yellow
    
    $links = @{
        "src/app.js" = "server.js"
        "src/index.js" = "app.js"
        "public/index.html" = "index.html"
    }
    
    foreach ($target in $links.Keys) {
        $link = $links[$target]
        if (Test-Path $target -and -not (Test-Path $link)) {
            New-Item -ItemType SymbolicLink -Path $link -Target $target -Force
            Write-Host "Created symbolic link: $link -> $target" -ForegroundColor Green
        }
    }
}

# Main execution
Write-Host "Starting file organization..." -ForegroundColor Green

# Check if we're in a project directory
if (-not (Test-Path "package.json")) {
    Write-Host "Error: No package.json found. Please run this script from your project root directory." -ForegroundColor Red
    exit 1
}

# Execute organization functions
Move-FilesToDirectories
Organize-ByFileType
Create-SymbolicLinks

# Ask about flattening
Flatten-DirectoryStructure

Write-Host "`nFile organization completed!" -ForegroundColor Green
Write-Host "`nYour project files are now organized:" -ForegroundColor Cyan
Write-Host "✓ Files moved to appropriate directories" -ForegroundColor White
Write-Host "✓ Type-based organization applied" -ForegroundColor White
Write-Host "✓ Symbolic links created for common files" -ForegroundColor White
Write-Host "✓ Directory structure optimized" -ForegroundColor White

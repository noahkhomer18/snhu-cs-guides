# PowerShell script to clean up development files and optimize project
# Usage: .\cleanup_project.ps1

Write-Host "CS-340 Project Cleanup and Optimization Tool" -ForegroundColor Green

# Function to remove unnecessary files
function Remove-UnnecessaryFiles {
    Write-Host "`nRemoving unnecessary development files..." -ForegroundColor Yellow
    
    $filesToRemove = @(
        "*.log",
        "*.tmp",
        "*.temp",
        "*.cache",
        "*.swp",
        "*.swo",
        "*~",
        ".DS_Store",
        "Thumbs.db",
        "desktop.ini"
    )
    
    foreach ($pattern in $filesToRemove) {
        $files = Get-ChildItem -Filter $pattern -Recurse -Force -ErrorAction SilentlyContinue
        foreach ($file in $files) {
            Remove-Item -Path $file.FullName -Force
            Write-Host "Removed: $($file.Name)" -ForegroundColor Red
        }
    }
}

# Function to clean node_modules and reinstall
function Clean-NodeModules {
    Write-Host "`nCleaning node_modules..." -ForegroundColor Yellow
    
    if (Test-Path "node_modules") {
        Write-Host "Removing node_modules directory..." -ForegroundColor Cyan
        Remove-Item -Path "node_modules" -Recurse -Force
        
        Write-Host "Removing package-lock.json..." -ForegroundColor Cyan
        if (Test-Path "package-lock.json") {
            Remove-Item -Path "package-lock.json" -Force
        }
        
        Write-Host "Reinstalling dependencies..." -ForegroundColor Cyan
        npm install
        
        if ($LASTEXITCODE -eq 0) {
            Write-Host "Dependencies reinstalled successfully!" -ForegroundColor Green
        } else {
            Write-Host "Failed to reinstall dependencies" -ForegroundColor Red
        }
    }
}

# Function to optimize package.json
function Optimize-PackageJson {
    Write-Host "`nOptimizing package.json..." -ForegroundColor Yellow
    
    if (Test-Path "package.json") {
        $packageContent = Get-Content "package.json" -Raw | ConvertFrom-Json
        
        # Remove unused scripts
        $unusedScripts = @("postinstall", "preinstall", "prestart", "poststart")
        foreach ($script in $unusedScripts) {
            if ($packageContent.scripts.PSObject.Properties.Name -contains $script) {
                $packageContent.scripts.PSObject.Properties.Remove($script)
                Write-Host "Removed unused script: $script" -ForegroundColor Cyan
            }
        }
        
        # Sort dependencies alphabetically
        if ($packageContent.dependencies) {
            $sortedDeps = [ordered]@{}
            $packageContent.dependencies.PSObject.Properties | Sort-Object Name | ForEach-Object {
                $sortedDeps[$_.Name] = $_.Value
            }
            $packageContent.dependencies = $sortedDeps
        }
        
        $packageContent | ConvertTo-Json -Depth 10 | Out-File -FilePath "package.json" -Encoding UTF8
        Write-Host "Package.json optimized" -ForegroundColor Green
    }
}

# Function to create .gitignore if missing
function Create-GitIgnore {
    Write-Host "`nCreating/updating .gitignore..." -ForegroundColor Yellow
    
    $gitignoreContent = @"
# Dependencies
node_modules/
npm-debug.log*
yarn-debug.log*
yarn-error.log*

# Environment variables
.env
.env.local
.env.development.local
.env.test.local
.env.production.local

# Logs
logs/
*.log

# Runtime data
pids/
*.pid
*.seed
*.pid.lock

# Coverage directory used by tools like istanbul
coverage/
.nyc_output/

# Build outputs
dist/
build/

# OS generated files
.DS_Store
.DS_Store?
._*
.Spotlight-V100
.Trashes
ehthumbs.db
Thumbs.db

# IDE files
.vscode/
.idea/
*.swp
*.swo
*~

# Temporary files
*.tmp
*.temp
"@

    $gitignoreContent | Out-File -FilePath ".gitignore" -Encoding UTF8
    Write-Host "Created/updated .gitignore" -ForegroundColor Green
}

# Function to analyze project size
function Analyze-ProjectSize {
    Write-Host "`nAnalyzing project size..." -ForegroundColor Yellow
    
    $totalSize = (Get-ChildItem -Recurse | Measure-Object -Property Length -Sum).Sum
    $nodeModulesSize = if (Test-Path "node_modules") { (Get-ChildItem -Recurse "node_modules" | Measure-Object -Property Length -Sum).Sum } else { 0 }
    $sourceSize = $totalSize - $nodeModulesSize
    
    Write-Host "Total project size: $([math]::Round($totalSize/1MB, 2)) MB" -ForegroundColor Cyan
    Write-Host "Source code size: $([math]::Round($sourceSize/1MB, 2)) MB" -ForegroundColor Cyan
    Write-Host "node_modules size: $([math]::Round($nodeModulesSize/1MB, 2)) MB" -ForegroundColor Cyan
    
    if ($nodeModulesSize -gt 100MB) {
        Write-Host "Warning: node_modules is quite large. Consider using .npmrc to optimize." -ForegroundColor Yellow
    }
}

# Function to check for security issues
function Check-SecurityIssues {
    Write-Host "`nChecking for security issues..." -ForegroundColor Yellow
    
    if (Test-Path "package.json") {
        Write-Host "Running npm audit..." -ForegroundColor Cyan
        npm audit
        
        if ($LASTEXITCODE -ne 0) {
            Write-Host "Security vulnerabilities found. Run 'npm audit fix' to resolve." -ForegroundColor Red
        } else {
            Write-Host "No security vulnerabilities found!" -ForegroundColor Green
        }
    }
}

# Main execution
Write-Host "Starting project cleanup..." -ForegroundColor Green

# Check if we're in a project directory
if (-not (Test-Path "package.json")) {
    Write-Host "Error: No package.json found. Please run this script from your project root directory." -ForegroundColor Red
    exit 1
}

# Execute cleanup functions
Remove-UnnecessaryFiles
Create-GitIgnore
Optimize-PackageJson
Analyze-ProjectSize
Check-SecurityIssues

# Ask if user wants to clean node_modules
$cleanNodeModules = Read-Host "`nDo you want to clean and reinstall node_modules? (y/n)"
if ($cleanNodeModules -eq "y" -or $cleanNodeModules -eq "Y") {
    Clean-NodeModules
}

Write-Host "`nProject cleanup completed!" -ForegroundColor Green
Write-Host "`nYour project is now optimized:" -ForegroundColor Cyan
Write-Host "✓ Unnecessary files removed" -ForegroundColor White
Write-Host "✓ .gitignore updated" -ForegroundColor White
Write-Host "✓ package.json optimized" -ForegroundColor White
Write-Host "✓ Security audit completed" -ForegroundColor White
Write-Host "✓ Project size analyzed" -ForegroundColor White

# PowerShell script to copy and backup project files
# Usage: .\backup_project.ps1

param(
    [string]$BackupLocation = ".\backups",
    [switch]$IncludeNodeModules = $false
)

Write-Host "CS-340 Project Backup Tool" -ForegroundColor Green

# Function to create backup directory
function Create-BackupDirectory {
    $timestamp = Get-Date -Format "yyyy-MM-dd_HH-mm-ss"
    $backupDir = Join-Path $BackupLocation "backup_$timestamp"
    
    if (-not (Test-Path $BackupLocation)) {
        New-Item -ItemType Directory -Path $BackupLocation -Force
        Write-Host "Created backup directory: $BackupLocation" -ForegroundColor Green
    }
    
    New-Item -ItemType Directory -Path $backupDir -Force
    Write-Host "Created backup folder: $backupDir" -ForegroundColor Green
    
    return $backupDir
}

# Function to copy project files
function Copy-ProjectFiles {
    param($BackupDir)
    
    Write-Host "`nCopying project files..." -ForegroundColor Yellow
    
    # Files to always copy
    $filesToCopy = @(
        "package.json",
        "package-lock.json",
        "README.md",
        ".env",
        ".env.example",
        ".gitignore",
        "*.js",
        "*.json",
        "*.md"
    )
    
    foreach ($pattern in $filesToCopy) {
        $files = Get-ChildItem -Filter $pattern -File -ErrorAction SilentlyContinue
        foreach ($file in $files) {
            Copy-Item -Path $file.FullName -Destination $BackupDir -Force
            Write-Host "Copied: $($file.Name)" -ForegroundColor Cyan
        }
    }
    
    # Directories to copy
    $dirsToCopy = @(
        "src",
        "public",
        "views",
        "tests",
        "docs",
        "scripts"
    )
    
    foreach ($dir in $dirsToCopy) {
        if (Test-Path $dir) {
            Copy-Item -Path $dir -Destination $BackupDir -Recurse -Force
            Write-Host "Copied directory: $dir" -ForegroundColor Cyan
        }
    }
    
    # Copy node_modules if requested
    if ($IncludeNodeModules -and (Test-Path "node_modules")) {
        Write-Host "Copying node_modules (this may take a while)..." -ForegroundColor Yellow
        Copy-Item -Path "node_modules" -Destination $BackupDir -Recurse -Force
        Write-Host "Copied node_modules" -ForegroundColor Cyan
    }
}

# Function to create backup manifest
function Create-BackupManifest {
    param($BackupDir)
    
    $manifest = @{
        "backup_date" = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
        "project_name" = if (Test-Path "package.json") { (Get-Content "package.json" | ConvertFrom-Json).name } else { "Unknown" }
        "backup_location" = $BackupDir
        "files_copied" = (Get-ChildItem -Path $BackupDir -Recurse -File).Count
        "include_node_modules" = $IncludeNodeModules
    }
    
    $manifest | ConvertTo-Json | Out-File -FilePath (Join-Path $BackupDir "backup_manifest.json") -Encoding UTF8
    Write-Host "Created backup manifest" -ForegroundColor Green
}

# Function to compress backup
function Compress-Backup {
    param($BackupDir)
    
    $compress = Read-Host "`nDo you want to compress the backup? (y/n)"
    if ($compress -eq "y" -or $compress -eq "Y") {
        Write-Host "Compressing backup..." -ForegroundColor Yellow
        $zipFile = "$BackupDir.zip"
        Compress-Archive -Path $BackupDir -DestinationPath $zipFile -Force
        Write-Host "Backup compressed to: $zipFile" -ForegroundColor Green
        
        # Remove uncompressed folder
        Remove-Item -Path $BackupDir -Recurse -Force
        Write-Host "Removed uncompressed backup folder" -ForegroundColor Cyan
    }
}

# Main execution
Write-Host "Starting project backup..." -ForegroundColor Green

# Check if we're in a project directory
if (-not (Test-Path "package.json")) {
    Write-Host "Error: No package.json found. Please run this script from your project root directory." -ForegroundColor Red
    exit 1
}

# Create backup
$backupDir = Create-BackupDirectory
Copy-ProjectFiles -BackupDir $backupDir
Create-BackupManifest -BackupDir $backupDir
Compress-Backup -BackupDir $backupDir

Write-Host "`nBackup completed successfully!" -ForegroundColor Green
Write-Host "`nBackup location: $BackupLocation" -ForegroundColor Cyan

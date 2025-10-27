# PowerShell script to run tests and development workflow tasks
# Usage: .\run_tests.ps1

Write-Host "CS-340 Development Testing and Workflow Tool" -ForegroundColor Green

# Function to run unit tests
function Run-UnitTests {
    Write-Host "`nRunning unit tests..." -ForegroundColor Yellow
    
    if (Test-Path "tests/unit") {
        Write-Host "Running Jest unit tests..." -ForegroundColor Cyan
        npm test -- tests/unit
        
        if ($LASTEXITCODE -eq 0) {
            Write-Host "Unit tests passed!" -ForegroundColor Green
        } else {
            Write-Host "Unit tests failed!" -ForegroundColor Red
        }
    } else {
        Write-Host "No unit tests directory found" -ForegroundColor Yellow
    }
}

# Function to run integration tests
function Run-IntegrationTests {
    Write-Host "`nRunning integration tests..." -ForegroundColor Yellow
    
    if (Test-Path "tests/integration") {
        Write-Host "Running integration tests..." -ForegroundColor Cyan
        npm test -- tests/integration
        
        if ($LASTEXITCODE -eq 0) {
            Write-Host "Integration tests passed!" -ForegroundColor Green
        } else {
            Write-Host "Integration tests failed!" -ForegroundColor Red
        }
    } else {
        Write-Host "No integration tests directory found" -ForegroundColor Yellow
    }
}

# Function to run linting
function Run-Linting {
    Write-Host "`nRunning code linting..." -ForegroundColor Yellow
    
    # Check if ESLint is installed
    $eslintInstalled = npm list eslint --depth=0 2>$null
    if ($eslintInstalled) {
        Write-Host "Running ESLint..." -ForegroundColor Cyan
        npm run lint
        
        if ($LASTEXITCODE -eq 0) {
            Write-Host "Linting passed!" -ForegroundColor Green
        } else {
            Write-Host "Linting failed!" -ForegroundColor Red
        }
    } else {
        Write-Host "ESLint not installed. Installing..." -ForegroundColor Yellow
        npm install --save-dev eslint
        npm run lint
    }
}

# Function to run code formatting
function Run-CodeFormatting {
    Write-Host "`nRunning code formatting..." -ForegroundColor Yellow
    
    # Check if Prettier is installed
    $prettierInstalled = npm list prettier --depth=0 2>$null
    if ($prettierInstalled) {
        Write-Host "Running Prettier..." -ForegroundColor Cyan
        npm run format
        
        if ($LASTEXITCODE -eq 0) {
            Write-Host "Code formatting completed!" -ForegroundColor Green
        } else {
            Write-Host "Code formatting failed!" -ForegroundColor Red
        }
    } else {
        Write-Host "Prettier not installed. Installing..." -ForegroundColor Yellow
        npm install --save-dev prettier
        npm run format
    }
}

# Function to run security audit
function Run-SecurityAudit {
    Write-Host "`nRunning security audit..." -ForegroundColor Yellow
    
    Write-Host "Running npm audit..." -ForegroundColor Cyan
    npm audit
    
    if ($LASTEXITCODE -eq 0) {
        Write-Host "No security vulnerabilities found!" -ForegroundColor Green
    } else {
        Write-Host "Security vulnerabilities found!" -ForegroundColor Red
        $fixAudit = Read-Host "Do you want to fix vulnerabilities automatically? (y/n)"
        if ($fixAudit -eq "y" -or $fixAudit -eq "Y") {
            npm audit fix
        }
    }
}

# Function to run build process
function Run-BuildProcess {
    Write-Host "`nRunning build process..." -ForegroundColor Yellow
    
    Write-Host "Building application..." -ForegroundColor Cyan
    npm run build
    
    if ($LASTEXITCODE -eq 0) {
        Write-Host "Build completed successfully!" -ForegroundColor Green
    } else {
        Write-Host "Build failed!" -ForegroundColor Red
    }
}

# Function to generate test coverage report
function Generate-TestCoverage {
    Write-Host "`nGenerating test coverage report..." -ForegroundColor Yellow
    
    # Check if Jest is installed
    $jestInstalled = npm list jest --depth=0 2>$null
    if ($jestInstalled) {
        Write-Host "Running tests with coverage..." -ForegroundColor Cyan
        npm test -- --coverage
        
        if ($LASTEXITCODE -eq 0) {
            Write-Host "Coverage report generated!" -ForegroundColor Green
            Write-Host "Check the coverage/ directory for detailed reports" -ForegroundColor Cyan
        } else {
            Write-Host "Coverage report generation failed!" -ForegroundColor Red
        }
    } else {
        Write-Host "Jest not installed. Installing..." -ForegroundColor Yellow
        npm install --save-dev jest
        npm test -- --coverage
    }
}

# Function to run all checks
function Run-AllChecks {
    Write-Host "`nRunning all development checks..." -ForegroundColor Yellow
    
    Run-Linting
    Run-CodeFormatting
    Run-SecurityAudit
    Run-UnitTests
    Run-IntegrationTests
    Run-BuildProcess
    Generate-TestCoverage
    
    Write-Host "`nAll development checks completed!" -ForegroundColor Green
}

# Main execution
Write-Host "Starting development testing workflow..." -ForegroundColor Green

# Check if we're in a project directory
if (-not (Test-Path "package.json")) {
    Write-Host "Error: No package.json found. Please run this script from your project root directory." -ForegroundColor Red
    exit 1
}

# Menu for selecting what to run
Write-Host "`nSelect what to run:" -ForegroundColor Cyan
Write-Host "1. Run all checks" -ForegroundColor White
Write-Host "2. Run unit tests only" -ForegroundColor White
Write-Host "3. Run integration tests only" -ForegroundColor White
Write-Host "4. Run linting only" -ForegroundColor White
Write-Host "5. Run code formatting only" -ForegroundColor White
Write-Host "6. Run security audit only" -ForegroundColor White
Write-Host "7. Run build process only" -ForegroundColor White
Write-Host "8. Generate test coverage only" -ForegroundColor White

$choice = Read-Host "Enter your choice (1-8)"

switch ($choice) {
    "1" { Run-AllChecks }
    "2" { Run-UnitTests }
    "3" { Run-IntegrationTests }
    "4" { Run-Linting }
    "5" { Run-CodeFormatting }
    "6" { Run-SecurityAudit }
    "7" { Run-BuildProcess }
    "8" { Generate-TestCoverage }
    default { 
        Write-Host "Invalid choice. Running all checks..." -ForegroundColor Yellow
        Run-AllChecks 
    }
}

Write-Host "`nDevelopment workflow completed!" -ForegroundColor Green

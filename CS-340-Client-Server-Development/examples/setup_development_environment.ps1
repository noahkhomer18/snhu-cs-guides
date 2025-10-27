# PowerShell script to set up development environment and tools
# Usage: .\setup_development_environment.ps1

Write-Host "CS-340 Development Environment Setup Tool" -ForegroundColor Green

# Function to check Node.js installation
function Check-NodeInstallation {
    Write-Host "`nChecking Node.js installation..." -ForegroundColor Yellow
    
    try {
        $nodeVersion = node --version
        Write-Host "Node.js version: $nodeVersion" -ForegroundColor Green
        
        $npmVersion = npm --version
        Write-Host "npm version: $npmVersion" -ForegroundColor Green
        
        return $true
    } catch {
        Write-Host "Node.js is not installed or not in PATH" -ForegroundColor Red
        Write-Host "Please install Node.js from https://nodejs.org/" -ForegroundColor Yellow
        return $false
    }
}

# Function to install development dependencies
function Install-DevDependencies {
    Write-Host "`nInstalling development dependencies..." -ForegroundColor Yellow
    
    $devDependencies = @(
        "nodemon",
        "jest",
        "eslint",
        "prettier",
        "webpack",
        "webpack-cli",
        "sass",
        "nodemon"
    )
    
    foreach ($dep in $devDependencies) {
        Write-Host "Installing $dep..." -ForegroundColor Cyan
        npm install --save-dev $dep
        
        if ($LASTEXITCODE -eq 0) {
            Write-Host "$dep installed successfully!" -ForegroundColor Green
        } else {
            Write-Host "Failed to install $dep" -ForegroundColor Red
        }
    }
}

# Function to set up ESLint configuration
function Setup-ESLint {
    Write-Host "`nSetting up ESLint configuration..." -ForegroundColor Yellow
    
    $eslintConfig = @"
{
  "env": {
    "browser": true,
    "commonjs": true,
    "es6": true,
    "node": true
  },
  "extends": "eslint:recommended",
  "parserOptions": {
    "ecmaVersion": 2018,
    "sourceType": "module"
  },
  "rules": {
    "indent": ["error", 2],
    "linebreak-style": ["error", "unix"],
    "quotes": ["error", "single"],
    "semi": ["error", "always"],
    "no-unused-vars": "warn",
    "no-console": "off"
  }
}
"@

    $eslintConfig | Out-File -FilePath ".eslintrc.json" -Encoding UTF8
    Write-Host "ESLint configuration created" -ForegroundColor Green
}

# Function to set up Prettier configuration
function Setup-Prettier {
    Write-Host "`nSetting up Prettier configuration..." -ForegroundColor Yellow
    
    $prettierConfig = @"
{
  "semi": true,
  "trailingComma": "es5",
  "singleQuote": true,
  "printWidth": 80,
  "tabWidth": 2,
  "useTabs": false
}
"@

    $prettierConfig | Out-File -FilePath ".prettierrc" -Encoding UTF8
    Write-Host "Prettier configuration created" -ForegroundColor Green
}

# Function to set up Jest configuration
function Setup-Jest {
    Write-Host "`nSetting up Jest configuration..." -ForegroundColor Yellow
    
    $jestConfig = @"
{
  "testEnvironment": "node",
  "collectCoverage": true,
  "coverageDirectory": "coverage",
  "coverageReporters": ["text", "lcov", "html"],
  "testMatch": [
    "**/tests/**/*.test.js",
    "**/tests/**/*.spec.js"
  ],
  "verbose": true
}
"@

    $jestConfig | Out-File -FilePath "jest.config.json" -Encoding UTF8
    Write-Host "Jest configuration created" -ForegroundColor Green
}

# Function to set up Webpack configuration
function Setup-Webpack {
    Write-Host "`nSetting up Webpack configuration..." -ForegroundColor Yellow
    
    $webpackConfig = @"
const path = require('path');

module.exports = {
  entry: './src/index.js',
  output: {
    filename: 'bundle.js',
    path: path.resolve(__dirname, 'public/js'),
  },
  mode: 'development',
  devtool: 'source-map',
  module: {
    rules: [
      {
        test: /\.css$/i,
        use: ['style-loader', 'css-loader'],
      },
      {
        test: /\.(png|svg|jpg|jpeg|gif)$/i,
        type: 'asset/resource',
      },
    ],
  },
};
"@

    $webpackConfig | Out-File -FilePath "webpack.config.js" -Encoding UTF8
    Write-Host "Webpack configuration created" -ForegroundColor Green
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
            "test:watch" = "jest --watch"
            "test:coverage" = "jest --coverage"
            "lint" = "eslint src/"
            "lint:fix" = "eslint src/ --fix"
            "format" = "prettier --write src/"
            "build" = "webpack --mode production"
            "build:dev" = "webpack --mode development"
            "build:watch" = "webpack --mode development --watch"
        }
        
        $packageContent | ConvertTo-Json -Depth 10 | Out-File -FilePath "package.json" -Encoding UTF8
        Write-Host "Package.json scripts updated" -ForegroundColor Green
    }
}

# Function to create development directories
function Create-DevDirectories {
    Write-Host "`nCreating development directories..." -ForegroundColor Yellow
    
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
        "tests/unit",
        "tests/integration",
        "logs",
        "docs",
        "scripts",
        "coverage"
    )
    
    foreach ($dir in $directories) {
        if (-not (Test-Path $dir)) {
            New-Item -ItemType Directory -Path $dir -Force
            Write-Host "Created directory: $dir" -ForegroundColor Green
        }
    }
}

# Function to create sample files
function Create-SampleFiles {
    Write-Host "`nCreating sample files..." -ForegroundColor Yellow
    
    # Sample server file
    $serverContent = @"
const express = require('express');
const cors = require('cors');
require('dotenv').config();

const app = express();
const PORT = process.env.PORT || 3000;

// Middleware
app.use(cors());
app.use(express.json());
app.use(express.static('public'));

// Routes
app.get('/', (req, res) => {
  res.sendFile(__dirname + '/views/index.html');
});

app.get('/api/health', (req, res) => {
  res.json({ status: 'OK', timestamp: new Date().toISOString() });
});

// Start server
app.listen(PORT, () => {
  console.log(`Server running on port ${PORT}`);
});
"@

    $serverContent | Out-File -FilePath "src/server.js" -Encoding UTF8
    Write-Host "Created sample server file" -ForegroundColor Green
    
    # Sample test file
    $testContent = @"
const request = require('supertest');
const app = require('../src/server');

describe('API Tests', () => {
  test('GET /api/health should return 200', async () => {
    const response = await request(app).get('/api/health');
    expect(response.status).toBe(200);
    expect(response.body.status).toBe('OK');
  });
});
"@

    $testContent | Out-File -FilePath "tests/unit/server.test.js" -Encoding UTF8
    Write-Host "Created sample test file" -ForegroundColor Green
}

# Main execution
Write-Host "Starting development environment setup..." -ForegroundColor Green

# Check if we're in a project directory
if (-not (Test-Path "package.json")) {
    Write-Host "Error: No package.json found. Please run this script from your project root directory." -ForegroundColor Red
    exit 1
}

# Check Node.js installation
if (-not (Check-NodeInstallation)) {
    exit 1
}

# Set up development environment
Create-DevDirectories
Install-DevDependencies
Setup-ESLint
Setup-Prettier
Setup-Jest
Setup-Webpack
Update-PackageScripts
Create-SampleFiles

Write-Host "`nDevelopment environment setup completed!" -ForegroundColor Green
Write-Host "`nYour development environment is now ready:" -ForegroundColor Cyan
Write-Host "✓ Development dependencies installed" -ForegroundColor White
Write-Host "✓ ESLint configured" -ForegroundColor White
Write-Host "✓ Prettier configured" -ForegroundColor White
Write-Host "✓ Jest configured" -ForegroundColor White
Write-Host "✓ Webpack configured" -ForegroundColor White
Write-Host "✓ Package.json scripts updated" -ForegroundColor White
Write-Host "✓ Sample files created" -ForegroundColor White
Write-Host "`nNext steps:" -ForegroundColor Yellow
Write-Host "1. npm run dev - Start development server" -ForegroundColor White
Write-Host "2. npm test - Run tests" -ForegroundColor White
Write-Host "3. npm run lint - Check code quality" -ForegroundColor White
Write-Host "4. npm run build - Build for production" -ForegroundColor White

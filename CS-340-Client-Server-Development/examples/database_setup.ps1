# PowerShell script to set up development databases
# Usage: .\database_setup.ps1

Write-Host "Setting up Development Databases..." -ForegroundColor Green

# Function to check if a command exists
function Test-Command($cmdname) {
    return [bool](Get-Command -Name $cmdname -ErrorAction SilentlyContinue)
}

# Function to setup MongoDB
function Setup-MongoDB {
    Write-Host "`nSetting up MongoDB..." -ForegroundColor Cyan
    
    if (Test-Command "mongod") {
        Write-Host "MongoDB is available" -ForegroundColor Green
        
        # Create a test database
        Write-Host "Creating test database..." -ForegroundColor Yellow
        mongo --eval "use testdb; db.testcollection.insertOne({name: 'test', value: 123})" --quiet
        
        if ($LASTEXITCODE -eq 0) {
            Write-Host "MongoDB test database created successfully!" -ForegroundColor Green
        } else {
            Write-Host "Failed to create MongoDB test database" -ForegroundColor Red
        }
    } else {
        Write-Host "MongoDB not found. Please install MongoDB first." -ForegroundColor Red
    }
}

# Function to setup PostgreSQL
function Setup-PostgreSQL {
    Write-Host "`nSetting up PostgreSQL..." -ForegroundColor Cyan
    
    if (Test-Command "psql") {
        Write-Host "PostgreSQL is available" -ForegroundColor Green
        
        # Create a test database
        Write-Host "Creating test database..." -ForegroundColor Yellow
        createdb testdb
        
        if ($LASTEXITCODE -eq 0) {
            Write-Host "PostgreSQL test database created successfully!" -ForegroundColor Green
            
            # Create a test table
            Write-Host "Creating test table..." -ForegroundColor Yellow
            psql -d testdb -c "CREATE TABLE test_table (id SERIAL PRIMARY KEY, name VARCHAR(100), value INTEGER);"
            
            if ($LASTEXITCODE -eq 0) {
                Write-Host "Test table created successfully!" -ForegroundColor Green
            }
        } else {
            Write-Host "Failed to create PostgreSQL test database" -ForegroundColor Red
        }
    } else {
        Write-Host "PostgreSQL not found. Please install PostgreSQL first." -ForegroundColor Red
    }
}

# Function to setup SQLite
function Setup-SQLite {
    Write-Host "`nSetting up SQLite..." -ForegroundColor Cyan
    
    if (Test-Command "sqlite3") {
        Write-Host "SQLite is available" -ForegroundColor Green
        
        # Create a test database
        Write-Host "Creating test database..." -ForegroundColor Yellow
        sqlite3 test.db "CREATE TABLE test_table (id INTEGER PRIMARY KEY, name TEXT, value INTEGER);"
        
        if ($LASTEXITCODE -eq 0) {
            Write-Host "SQLite test database created successfully!" -ForegroundColor Green
        } else {
            Write-Host "Failed to create SQLite test database" -ForegroundColor Red
        }
    } else {
        Write-Host "SQLite not found. Please install SQLite first." -ForegroundColor Red
    }
}

# Main setup process
Write-Host "Checking available database systems..." -ForegroundColor Green

# Setup each database system
Setup-MongoDB
Setup-PostgreSQL
Setup-SQLite

Write-Host "`nDatabase setup completed!" -ForegroundColor Green
Write-Host "`nConnection strings for your applications:" -ForegroundColor Cyan
Write-Host "MongoDB: mongodb://localhost:27017/testdb" -ForegroundColor White
Write-Host "PostgreSQL: postgresql://postgres@localhost:5432/testdb" -ForegroundColor White
Write-Host "SQLite: ./test.db" -ForegroundColor White

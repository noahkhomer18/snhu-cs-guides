# PowerShell Scripts Guide for CS-340 Client-Server Development

This guide provides comprehensive PowerShell scripts for common development tasks in CS-340. Each script is designed to automate common development workflows and reduce manual setup time.

## Table of Contents

1. [NPM Scripts](#npm-scripts)
2. [Database Scripts](#database-scripts)
3. [Server Scripts](#server-scripts)
4. [Deployment Scripts](#deployment-scripts)
5. [Usage Examples](#usage-examples)

## NPM Scripts

### npm_start_server.ps1
**Purpose**: Start a Node.js development server with automatic dependency installation.

**Features**:
- Checks for Node.js and npm installation
- Automatically installs dependencies if `node_modules` doesn't exist
- Tries multiple start methods (`npm start`, `npm run dev`, `node server.js`)
- Provides clear error messages and troubleshooting

**Usage**:
```powershell
.\npm_start_server.ps1
```

**What it does**:
1. Verifies Node.js and npm are installed
2. Checks for `package.json` in current directory
3. Installs dependencies if needed
4. Attempts to start the server using various methods
5. Provides feedback on success/failure

### npm_dev_server.ps1
**Purpose**: Start a Node.js development server with hot reload capabilities.

**Features**:
- Similar to start server but optimized for development
- Tries development-specific commands first
- Includes nodemon support for automatic restarts
- Better suited for active development

**Usage**:
```powershell
.\npm_dev_server.ps1
```

### npm_build_package.ps1
**Purpose**: Build and package a Node.js application for production.

**Features**:
- Cleans previous builds
- Installs dependencies
- Runs build process
- Creates production packages
- Shows build statistics

**Usage**:
```powershell
.\npm_build_package.ps1
```

## Database Scripts

### start_mongodb.ps1
**Purpose**: Start MongoDB service on Windows.

**Features**:
- Checks if MongoDB is installed
- Attempts to start MongoDB service
- Falls back to direct mongod execution
- Creates data directory if needed
- Provides connection information

**Usage**:
```powershell
.\start_mongodb.ps1
```

**Prerequisites**:
- MongoDB must be installed
- Service may need to be configured

### start_postgresql.ps1
**Purpose**: Start PostgreSQL service on Windows.

**Features**:
- Checks for PostgreSQL installation
- Attempts to start PostgreSQL service
- Falls back to pg_ctl if service fails
- Provides connection details

**Usage**:
```powershell
.\start_postgresql.ps1
```

### database_setup.ps1
**Purpose**: Set up development databases (MongoDB, PostgreSQL, SQLite).

**Features**:
- Creates test databases
- Sets up sample tables
- Provides connection strings
- Supports multiple database types

**Usage**:
```powershell
.\database_setup.ps1
```

## Server Scripts

### start_express_server.ps1
**Purpose**: Start an Express.js server with proper error handling.

**Features**:
- Checks for Express.js installation
- Installs Express if missing
- Tries multiple start methods
- Provides server information

**Usage**:
```powershell
.\start_express_server.ps1
```

### start_react_app.ps1
**Purpose**: Start a React development server.

**Features**:
- Checks for React installation
- Installs React if missing
- Starts development server with hot reload
- Provides development URLs

**Usage**:
```powershell
.\start_react_app.ps1
```

### start_fullstack_app.ps1
**Purpose**: Start both frontend and backend servers for full-stack applications.

**Features**:
- Detects project structure (frontend/backend or client/server)
- Starts both servers simultaneously
- Provides URLs for both services
- Handles different project layouts

**Usage**:
```powershell
.\start_fullstack_app.ps1
```

## Deployment Scripts

### deploy_to_production.ps1
**Purpose**: Build and package application for production deployment.

**Features**:
- Builds application for production
- Installs production dependencies only
- Creates deployment package
- Provides deployment instructions

**Usage**:
```powershell
.\deploy_to_production.ps1
```

### setup_pm2.ps1
**Purpose**: Set up PM2 process manager for production applications.

**Features**:
- Installs PM2 globally
- Creates ecosystem configuration
- Sets up logging
- Configures cluster mode
- Provides PM2 commands

**Usage**:
```powershell
.\setup_pm2.ps1
```

### docker_setup.ps1
**Purpose**: Set up Docker environment for CS-340 development.

**Features**:
- Creates Dockerfile
- Sets up docker-compose.yml
- Configures nginx reverse proxy
- Sets up MongoDB and Redis
- Builds and runs application

**Usage**:
```powershell
.\docker_setup.ps1
```

## Usage Examples

### Starting a New Project
1. Create your project directory
2. Initialize with `npm init`
3. Install dependencies
4. Use appropriate start script

### Development Workflow
1. Start database: `.\start_mongodb.ps1`
2. Start backend: `.\start_express_server.ps1`
3. Start frontend: `.\start_react_app.ps1`

### Production Deployment
1. Build application: `.\npm_build_package.ps1`
2. Set up PM2: `.\setup_pm2.ps1`
3. Deploy: `.\deploy_to_production.ps1`

### Docker Development
1. Set up Docker: `.\docker_setup.ps1`
2. Start services: `docker-compose up -d`
3. Access application at http://localhost

## Troubleshooting

### Common Issues

**Node.js not found**:
- Install Node.js from https://nodejs.org/
- Restart PowerShell after installation

**MongoDB service not starting**:
- Check if MongoDB is installed
- Run as administrator
- Check Windows services

**Port already in use**:
- Change port in your application
- Kill process using the port
- Use different port

**Permission denied**:
- Run PowerShell as administrator
- Check file permissions
- Ensure scripts are not blocked

### Getting Help

1. Check script output for specific error messages
2. Verify all prerequisites are installed
3. Check if services are running
4. Review application logs

## Best Practices

1. **Always run scripts from project root directory**
2. **Check prerequisites before running scripts**
3. **Read error messages carefully**
4. **Keep scripts updated with your project structure**
5. **Test scripts in development environment first**

## Customization

These scripts can be customized for your specific needs:

1. **Modify port numbers** in server scripts
2. **Add environment variables** for configuration
3. **Include additional database types** in setup scripts
4. **Add custom build steps** in deployment scripts

## Security Notes

- Scripts include basic error handling
- No sensitive information is hardcoded
- Always review scripts before running
- Use environment variables for configuration
- Keep dependencies updated

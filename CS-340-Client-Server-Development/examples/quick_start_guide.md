# Quick Start Guide - CS-340 PowerShell Scripts

This guide provides quick reference for using PowerShell scripts in CS-340 Client-Server Development.

## 🚀 Quick Commands

### Start Development Environment
```powershell
# Start MongoDB
.\start_mongodb.ps1

# Start your Node.js server
.\npm_start_server.ps1

# Or start with hot reload
.\npm_dev_server.ps1
```

### Start Full-Stack Application
```powershell
# Start both frontend and backend
.\start_fullstack_app.ps1
```

### Build and Deploy
```powershell
# Build for production
.\npm_build_package.ps1

# Deploy to production
.\deploy_to_production.ps1

# Set up PM2 for production
.\setup_pm2.ps1
```

## 📋 Prerequisites Checklist

Before running any scripts, ensure you have:

- [ ] Node.js installed (https://nodejs.org/)
- [ ] npm available in PATH
- [ ] MongoDB installed (for database scripts)
- [ ] PostgreSQL installed (for database scripts)
- [ ] Docker installed (for Docker scripts)

## 🔧 Common Workflows

### 1. New Project Setup
```powershell
# 1. Create project directory
mkdir my-cs340-project
cd my-cs340-project

# 2. Initialize npm
npm init -y

# 3. Install dependencies
npm install express mongoose

# 4. Start development
.\npm_start_server.ps1
```

### 2. Database Development
```powershell
# Start MongoDB
.\start_mongodb.ps1

# Set up development databases
.\database_setup.ps1

# Start your application
.\npm_dev_server.ps1
```

### 3. Full-Stack Development
```powershell
# Start backend
.\start_express_server.ps1

# In another terminal, start frontend
.\start_react_app.ps1

# Or use the full-stack script
.\start_fullstack_app.ps1
```

### 4. Production Deployment
```powershell
# Build application
.\npm_build_package.ps1

# Set up PM2
.\setup_pm2.ps1

# Deploy
.\deploy_to_production.ps1
```

## 🐳 Docker Development
```powershell
# Set up Docker environment
.\docker_setup.ps1

# Start all services
docker-compose up -d

# View logs
docker-compose logs

# Stop services
docker-compose down
```

## 📊 Script Reference

| Script | Purpose | When to Use |
|--------|---------|-------------|
| `npm_start_server.ps1` | Start Node.js server | Basic server startup |
| `npm_dev_server.ps1` | Start with hot reload | Active development |
| `npm_build_package.ps1` | Build for production | Before deployment |
| `start_mongodb.ps1` | Start MongoDB | Database development |
| `start_postgresql.ps1` | Start PostgreSQL | Database development |
| `database_setup.ps1` | Set up dev databases | New project setup |
| `start_express_server.ps1` | Start Express server | Backend development |
| `start_react_app.ps1` | Start React app | Frontend development |
| `start_fullstack_app.ps1` | Start both servers | Full-stack development |
| `deploy_to_production.ps1` | Deploy to production | Production deployment |
| `setup_pm2.ps1` | Set up PM2 | Production process management |
| `docker_setup.ps1` | Set up Docker | Containerized development |

## ⚡ Quick Troubleshooting

### Script won't run?
- Check if PowerShell execution policy allows scripts
- Run: `Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser`

### Node.js not found?
- Install Node.js from https://nodejs.org/
- Restart PowerShell after installation

### MongoDB won't start?
- Check if MongoDB service is running
- Run as administrator
- Check Windows services

### Port already in use?
- Change port in your application
- Kill process using the port
- Use different port

## 🎯 Best Practices

1. **Always run scripts from project root directory**
2. **Check prerequisites before running scripts**
3. **Read error messages carefully**
4. **Keep scripts updated with your project structure**
5. **Test scripts in development environment first**

## 📚 Additional Resources

- [PowerShell Scripts Guide](powershell_scripts_guide.md) - Detailed documentation
- [CS-340 Guide](../guide.md) - Course-specific guidance
- [Resources](../resources.md) - Additional learning materials

## 🆘 Getting Help

If you encounter issues:

1. Check the script output for specific error messages
2. Verify all prerequisites are installed
3. Check if services are running
4. Review application logs
5. Consult the detailed guide for troubleshooting steps

# PowerShell script to set up Docker for CS-340 development
# Usage: .\docker_setup.ps1

Write-Host "Setting up Docker for CS-340 Development..." -ForegroundColor Green

# Check if Docker is installed
try {
    $dockerVersion = docker --version
    Write-Host "Docker version: $dockerVersion" -ForegroundColor Cyan
} catch {
    Write-Host "Error: Docker is not installed or not in PATH" -ForegroundColor Red
    Write-Host "Please install Docker Desktop from https://www.docker.com/products/docker-desktop" -ForegroundColor Yellow
    exit 1
}

# Check if Docker is running
try {
    docker ps
    Write-Host "Docker is running" -ForegroundColor Green
} catch {
    Write-Host "Error: Docker is not running" -ForegroundColor Red
    Write-Host "Please start Docker Desktop" -ForegroundColor Yellow
    exit 1
}

# Create Dockerfile for Node.js application
Write-Host "Creating Dockerfile..." -ForegroundColor Yellow
$dockerfileContent = @"
FROM node:18-alpine

WORKDIR /app

COPY package*.json ./
RUN npm ci --only=production

COPY . .

EXPOSE 3000

CMD ["npm", "start"]
"@

$dockerfileContent | Out-File -FilePath "Dockerfile" -Encoding UTF8

# Create docker-compose.yml for full-stack application
Write-Host "Creating docker-compose.yml..." -ForegroundColor Yellow
$dockerComposeContent = @"
version: '3.8'

services:
  app:
    build: .
    ports:
      - "3000:3000"
    environment:
      - NODE_ENV=production
    depends_on:
      - mongodb
      - redis

  mongodb:
    image: mongo:latest
    ports:
      - "27017:27017"
    volumes:
      - mongodb_data:/data/db

  redis:
    image: redis:alpine
    ports:
      - "6379:6379"

  nginx:
    image: nginx:alpine
    ports:
      - "80:80"
    volumes:
      - ./nginx.conf:/etc/nginx/nginx.conf
    depends_on:
      - app

volumes:
  mongodb_data:
"@

$dockerComposeContent | Out-File -FilePath "docker-compose.yml" -Encoding UTF8

# Create .dockerignore
Write-Host "Creating .dockerignore..." -ForegroundColor Yellow
$dockerIgnoreContent = @"
node_modules
npm-debug.log
.git
.gitignore
README.md
.env
.nyc_output
coverage
.nyc_output
.coverage
.coverage/
*.log
"@

$dockerIgnoreContent | Out-File -FilePath ".dockerignore" -Encoding UTF8

# Create nginx configuration
Write-Host "Creating nginx configuration..." -ForegroundColor Yellow
$nginxConfig = @"
events {
    worker_connections 1024;
}

http {
    upstream app {
        server app:3000;
    }

    server {
        listen 80;
        server_name localhost;

        location / {
            proxy_pass http://app;
            proxy_set_header Host `$host;
            proxy_set_header X-Real-IP `$remote_addr;
            proxy_set_header X-Forwarded-For `$proxy_add_x_forwarded_for;
            proxy_set_header X-Forwarded-Proto `$scheme;
        }
    }
}
"@

$nginxConfig | Out-File -FilePath "nginx.conf" -Encoding UTF8

# Build and run the application
Write-Host "Building Docker image..." -ForegroundColor Green
docker build -t cs340-app .

if ($LASTEXITCODE -eq 0) {
    Write-Host "Docker image built successfully!" -ForegroundColor Green
} else {
    Write-Host "Failed to build Docker image" -ForegroundColor Red
    exit 1
}

# Start the application with docker-compose
Write-Host "Starting application with docker-compose..." -ForegroundColor Green
docker-compose up -d

if ($LASTEXITCODE -eq 0) {
    Write-Host "Application started successfully!" -ForegroundColor Green
} else {
    Write-Host "Failed to start application" -ForegroundColor Red
    exit 1
}

# Display application information
Write-Host "`nDocker Application Information:" -ForegroundColor Cyan
Write-Host "Application URL: http://localhost" -ForegroundColor White
Write-Host "MongoDB: localhost:27017" -ForegroundColor White
Write-Host "Redis: localhost:6379" -ForegroundColor White
Write-Host "`nDocker Commands:" -ForegroundColor Cyan
Write-Host "docker-compose up -d     - Start all services" -ForegroundColor White
Write-Host "docker-compose down      - Stop all services" -ForegroundColor White
Write-Host "docker-compose logs      - View logs" -ForegroundColor White
Write-Host "docker-compose ps        - Show running containers" -ForegroundColor White

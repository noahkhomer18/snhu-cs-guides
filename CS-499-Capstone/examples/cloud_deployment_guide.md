# CS-499 Cloud Deployment Guide

## 🎯 Purpose
Complete guide for deploying applications to cloud platforms, containerization, and production deployment strategies.

## ☁️ Cloud Platform Overview

### Popular Cloud Providers
- **AWS (Amazon Web Services)**: Most comprehensive, enterprise-focused
- **Azure (Microsoft)**: Great for Microsoft stack, hybrid cloud
- **Google Cloud Platform (GCP)**: Strong in AI/ML, data analytics
- **Heroku**: Simple PaaS, great for beginners
- **Vercel**: Excellent for frontend and serverless
- **Netlify**: Great for static sites and JAMstack

## 🚀 Heroku Deployment

### Setup & Installation
```bash
# Install Heroku CLI
# Windows: Download from https://devcenter.heroku.com/articles/heroku-cli
# Mac: brew install heroku/brew/heroku
# Linux: curl https://cli-assets.heroku.com/install.sh | sh

# Login to Heroku
heroku login

# Verify installation
heroku --version
```

### Node.js Application Deployment
```bash
# Create new Heroku app
heroku create my-capstone-app

# Set environment variables
heroku config:set NODE_ENV=production
heroku config:set DATABASE_URL=postgres://user:pass@host:port/db

# Add PostgreSQL addon
heroku addons:create heroku-postgresql:hobby-dev

# Deploy application
git push heroku main

# Open application
heroku open

# View logs
heroku logs --tail
```

### Python Application Deployment
```bash
# Create requirements.txt
echo "Flask==2.3.2" > requirements.txt
echo "gunicorn==21.2.0" >> requirements.txt

# Create Procfile
echo "web: gunicorn app:app" > Procfile

# Deploy
git add .
git commit -m "Add Heroku configuration"
git push heroku main
```

### Heroku Configuration Files
```python
# runtime.txt
python-3.11.4

# Procfile
web: gunicorn app:app
worker: python worker.py

# app.json (for one-click deploy)
{
  "name": "CS-499 Capstone App",
  "description": "A web application for CS-499 capstone project",
  "repository": "https://github.com/username/capstone-app",
  "logo": "https://example.com/logo.png",
  "keywords": ["python", "flask", "web"],
  "env": {
    "FLASK_ENV": {
      "description": "Flask environment",
      "value": "production"
    }
  },
  "addons": [
    "heroku-postgresql:hobby-dev"
  ]
}
```

## 🌐 Vercel Deployment

### Setup
```bash
# Install Vercel CLI
npm install -g vercel

# Login to Vercel
vercel login

# Deploy project
vercel

# Deploy to production
vercel --prod
```

### Next.js Application
```bash
# Create Next.js app
npx create-next-app@latest my-capstone-app
cd my-capstone-app

# Deploy to Vercel
vercel

# Configure environment variables
vercel env add DATABASE_URL
vercel env add API_SECRET_KEY
```

### Vercel Configuration
```json
// vercel.json
{
  "version": 2,
  "builds": [
    {
      "src": "package.json",
      "use": "@vercel/node"
    }
  ],
  "routes": [
    {
      "src": "/api/(.*)",
      "dest": "/api/$1"
    }
  ],
  "env": {
    "NODE_ENV": "production"
  }
}
```

## 🐳 Docker Containerization

### Docker Installation
```bash
# Windows: Download Docker Desktop from https://www.docker.com/products/docker-desktop
# Mac: Download Docker Desktop or brew install --cask docker
# Linux: curl -fsSL https://get.docker.com -o get-docker.sh && sh get-docker.sh

# Verify installation
docker --version
docker-compose --version
```

### Node.js Dockerfile
```dockerfile
# Dockerfile
FROM node:18-alpine

# Set working directory
WORKDIR /app

# Copy package files
COPY package*.json ./

# Install dependencies
RUN npm ci --only=production

# Copy source code
COPY . .

# Expose port
EXPOSE 3000

# Create non-root user
RUN addgroup -g 1001 -S nodejs
RUN adduser -S nextjs -u 1001
USER nextjs

# Start application
CMD ["npm", "start"]
```

### Python Dockerfile
```dockerfile
# Dockerfile
FROM python:3.11-slim

# Set working directory
WORKDIR /app

# Install system dependencies
RUN apt-get update && apt-get install -y \
    gcc \
    && rm -rf /var/lib/apt/lists/*

# Copy requirements and install Python dependencies
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Copy source code
COPY . .

# Create non-root user
RUN useradd --create-home --shell /bin/bash app
USER app

# Expose port
EXPOSE 8000

# Start application
CMD ["gunicorn", "--bind", "0.0.0.0:8000", "app:app"]
```

### Docker Compose
```yaml
# docker-compose.yml
version: '3.8'

services:
  web:
    build: .
    ports:
      - "3000:3000"
    environment:
      - NODE_ENV=production
      - DATABASE_URL=postgres://user:pass@db:5432/mydb
    depends_on:
      - db
      - redis

  db:
    image: postgres:15
    environment:
      - POSTGRES_DB=mydb
      - POSTGRES_USER=user
      - POSTGRES_PASSWORD=pass
    volumes:
      - postgres_data:/var/lib/postgresql/data
    ports:
      - "5432:5432"

  redis:
    image: redis:7-alpine
    ports:
      - "6379:6379"

volumes:
  postgres_data:
```

### Docker Commands
```bash
# Build image
docker build -t my-capstone-app .

# Run container
docker run -p 3000:3000 my-capstone-app

# Run with environment variables
docker run -p 3000:3000 -e NODE_ENV=production my-capstone-app

# Run in background
docker run -d -p 3000:3000 --name capstone-app my-capstone-app

# View running containers
docker ps

# View logs
docker logs capstone-app

# Stop container
docker stop capstone-app

# Remove container
docker rm capstone-app

# Run with docker-compose
docker-compose up -d
docker-compose down
```

## ☁️ AWS Deployment

### AWS CLI Setup
```bash
# Install AWS CLI
# Windows: Download from https://aws.amazon.com/cli/
# Mac: brew install awscli
# Linux: pip install awscli

# Configure AWS CLI
aws configure
# Enter Access Key ID, Secret Access Key, Region, Output format

# Verify configuration
aws sts get-caller-identity
```

### Elastic Beanstalk Deployment
```bash
# Install EB CLI
pip install awsebcli

# Initialize EB application
eb init

# Create environment
eb create production

# Deploy application
eb deploy

# Open application
eb open

# View logs
eb logs
```

### AWS Configuration Files
```yaml
# .elasticbeanstalk/config.yml
branch-defaults:
  main:
    environment: my-app-production
    group_suffix: null
global:
  application_name: my-capstone-app
  default_platform: Node.js 18
  default_region: us-east-1
  include_git_submodules: true
  instance_profile: null
  platform_name: null
  platform_version: null
  profile: null
  sc: git
  workspace_type: Application
```

```json
// .ebextensions/01-packages.config
{
  "packages": {
    "yum": {
      "git": []
    }
  }
}
```

### S3 Static Website Hosting
```bash
# Create S3 bucket
aws s3 mb s3://my-capstone-app-static

# Enable static website hosting
aws s3 website s3://my-capstone-app-static --index-document index.html --error-document error.html

# Upload files
aws s3 sync ./dist s3://my-capstone-app-static --delete

# Set bucket policy for public read
aws s3api put-bucket-policy --bucket my-capstone-app-static --policy file://bucket-policy.json
```

## 🔧 Environment Configuration

### Environment Variables
```bash
# .env file
NODE_ENV=production
PORT=3000
DATABASE_URL=postgres://user:pass@host:port/db
JWT_SECRET=your-secret-key
API_KEY=your-api-key
REDIS_URL=redis://localhost:6379
```

### Configuration Management
```javascript
// config/index.js
const config = {
  development: {
    database: {
      url: process.env.DATABASE_URL || 'postgres://localhost:5432/dev_db'
    },
    redis: {
      url: process.env.REDIS_URL || 'redis://localhost:6379'
    },
    jwt: {
      secret: process.env.JWT_SECRET || 'dev-secret'
    }
  },
  production: {
    database: {
      url: process.env.DATABASE_URL
    },
    redis: {
      url: process.env.REDIS_URL
    },
    jwt: {
      secret: process.env.JWT_SECRET
    }
  }
};

module.exports = config[process.env.NODE_ENV || 'development'];
```

## 📊 Monitoring & Logging

### Application Monitoring
```javascript
// monitoring.js
const express = require('express');
const prometheus = require('prom-client');

// Create metrics
const httpRequestDuration = new prometheus.Histogram({
  name: 'http_request_duration_seconds',
  help: 'Duration of HTTP requests in seconds',
  labelNames: ['method', 'route', 'status_code']
});

const httpRequestTotal = new prometheus.Counter({
  name: 'http_requests_total',
  help: 'Total number of HTTP requests',
  labelNames: ['method', 'route', 'status_code']
});

// Middleware to collect metrics
app.use((req, res, next) => {
  const start = Date.now();
  
  res.on('finish', () => {
    const duration = (Date.now() - start) / 1000;
    httpRequestDuration
      .labels(req.method, req.route?.path || req.path, res.statusCode)
      .observe(duration);
    httpRequestTotal
      .labels(req.method, req.route?.path || req.path, res.statusCode)
      .inc();
  });
  
  next();
});

// Metrics endpoint
app.get('/metrics', (req, res) => {
  res.set('Content-Type', prometheus.register.contentType);
  res.end(prometheus.register.metrics());
});
```

### Logging Configuration
```javascript
// logger.js
const winston = require('winston');

const logger = winston.createLogger({
  level: process.env.LOG_LEVEL || 'info',
  format: winston.format.combine(
    winston.format.timestamp(),
    winston.format.errors({ stack: true }),
    winston.format.json()
  ),
  defaultMeta: { service: 'capstone-app' },
  transports: [
    new winston.transports.File({ filename: 'error.log', level: 'error' }),
    new winston.transports.File({ filename: 'combined.log' }),
  ],
});

if (process.env.NODE_ENV !== 'production') {
  logger.add(new winston.transports.Console({
    format: winston.format.simple()
  }));
}

module.exports = logger;
```

## 🔒 Security Configuration

### HTTPS Setup
```javascript
// https.js
const https = require('https');
const fs = require('fs');

const options = {
  key: fs.readFileSync('private-key.pem'),
  cert: fs.readFileSync('certificate.pem')
};

https.createServer(options, app).listen(443);
```

### Security Headers
```javascript
// security.js
const helmet = require('helmet');

app.use(helmet({
  contentSecurityPolicy: {
    directives: {
      defaultSrc: ["'self'"],
      styleSrc: ["'self'", "'unsafe-inline'"],
      scriptSrc: ["'self'"],
      imgSrc: ["'self'", "data:", "https:"]
    }
  },
  hsts: {
    maxAge: 31536000,
    includeSubDomains: true,
    preload: true
  }
}));
```

### Environment Security
```bash
# Generate secure random secrets
openssl rand -hex 32  # For JWT secret
openssl rand -base64 32  # For API keys

# Set secure environment variables
export JWT_SECRET=$(openssl rand -hex 32)
export API_SECRET=$(openssl rand -base64 32)
```

## 🚀 CI/CD Pipeline

### GitHub Actions
```yaml
# .github/workflows/deploy.yml
name: Deploy to Production

on:
  push:
    branches: [ main ]

jobs:
  test:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      - name: Setup Node.js
        uses: actions/setup-node@v3
        with:
          node-version: '18'
          cache: 'npm'
      - name: Install dependencies
        run: npm ci
      - name: Run tests
        run: npm test
      - name: Run linting
        run: npm run lint

  deploy:
    needs: test
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      - name: Deploy to Heroku
        uses: akhileshns/heroku-deploy@v3.12.12
        with:
          heroku_api_key: ${{secrets.HEROKU_API_KEY}}
          heroku_app_name: "my-capstone-app"
          heroku_email: "your-email@example.com"
```

### Docker Hub Deployment
```yaml
# .github/workflows/docker-deploy.yml
name: Build and Push Docker Image

on:
  push:
    branches: [ main ]

jobs:
  build:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      - name: Build Docker image
        run: docker build -t my-capstone-app .
      - name: Login to Docker Hub
        run: echo ${{ secrets.DOCKER_PASSWORD }} | docker login -u ${{ secrets.DOCKER_USERNAME }} --password-stdin
      - name: Push to Docker Hub
        run: |
          docker tag my-capstone-app ${{ secrets.DOCKER_USERNAME }}/my-capstone-app:latest
          docker push ${{ secrets.DOCKER_USERNAME }}/my-capstone-app:latest
```

## 📚 Learning Resources

### Cloud Platforms
- **AWS Documentation**: https://docs.aws.amazon.com/
- **Azure Documentation**: https://docs.microsoft.com/en-us/azure/
- **Google Cloud Documentation**: https://cloud.google.com/docs
- **Heroku Dev Center**: https://devcenter.heroku.com/

### Containerization
- **Docker Documentation**: https://docs.docker.com/
- **Kubernetes Documentation**: https://kubernetes.io/docs/
- **Docker Compose**: https://docs.docker.com/compose/

### DevOps
- **GitHub Actions**: https://docs.github.com/en/actions
- **Jenkins**: https://www.jenkins.io/doc/
- **Terraform**: https://www.terraform.io/docs

## 🎯 CS-499 Deployment Checklist

### Phase 1: Preparation
- [ ] Choose deployment platform
- [ ] Set up development environment
- [ ] Configure environment variables
- [ ] Set up version control

### Phase 2: Containerization
- [ ] Create Dockerfile
- [ ] Set up docker-compose
- [ ] Test container locally
- [ ] Optimize image size

### Phase 3: Cloud Setup
- [ ] Create cloud account
- [ ] Set up CLI tools
- [ ] Configure security settings
- [ ] Set up monitoring

### Phase 4: Deployment
- [ ] Deploy to staging environment
- [ ] Test all functionality
- [ ] Deploy to production
- [ ] Set up domain and SSL

### Phase 5: Monitoring
- [ ] Set up logging
- [ ] Configure monitoring
- [ ] Set up alerts
- [ ] Create backup strategy

## 💡 Pro Tips

1. **Start Simple**: Begin with Heroku or Vercel for easy deployment
2. **Use Environment Variables**: Never hardcode secrets
3. **Test Locally**: Always test with production-like environment
4. **Monitor Performance**: Set up monitoring from day one
5. **Automate Everything**: Use CI/CD for consistent deployments
6. **Plan for Scale**: Design with scalability in mind
7. **Security First**: Implement security best practices
8. **Document Everything**: Keep deployment docs updated
9. **Backup Strategy**: Regular backups of data and configuration
10. **Cost Optimization**: Monitor and optimize cloud costs

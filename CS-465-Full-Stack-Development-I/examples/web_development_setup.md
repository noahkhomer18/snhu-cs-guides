# CS-465 Web Development Stack Setup Guide

## 🎯 Purpose
Complete setup guide for full-stack web development using MEAN stack and modern web technologies.

## 🌐 Frontend Technologies

### HTML5 & CSS3
**Essential Tools:**
- **VS Code**: https://code.visualstudio.com/
- **Live Server Extension**: Real-time preview
- **Prettier**: Code formatting
- **Emmet**: HTML/CSS shortcuts

**Learning Resources:**
- **MDN Web Docs**: https://developer.mozilla.org/
- **W3Schools**: https://www.w3schools.com/
- **CSS-Tricks**: https://css-tricks.com/
- **Flexbox Froggy**: https://flexboxfroggy.com/
- **Grid Garden**: https://cssgridgarden.com/

### JavaScript & TypeScript
**Setup:**
```bash
# Install Node.js (includes npm)
# Download from: https://nodejs.org/

# Verify installation
node --version
npm --version

# Install TypeScript globally
npm install -g typescript

# Verify TypeScript
tsc --version
```

**Essential Packages:**
```bash
# Create new project
mkdir cs465-web-project
cd cs465-web-project
npm init -y

# Install essential packages
npm install express cors dotenv
npm install -D typescript @types/node @types/express
npm install -D nodemon ts-node

# Install Angular CLI
npm install -g @angular/cli
```

### Angular Framework
**Installation:**
```bash
# Install Angular CLI globally
npm install -g @angular/cli

# Create new Angular project
ng new cs465-angular-app
cd cs465-angular-app

# Start development server
ng serve
```

**Angular Essentials:**
```bash
# Install additional Angular packages
ng add @angular/material
ng add @angular/pwa

# Generate components
ng generate component my-component
ng generate service my-service
ng generate guard my-guard
```

**Learning Resources:**
- **Angular Documentation**: https://angular.io/docs
- **Angular University**: https://angular-university.io/
- **Angular Material**: https://material.angular.io/
- **Angular CLI Reference**: https://angular.io/cli

## 🖥️ Backend Technologies

### Node.js & Express.js
**Setup:**
```bash
# Create backend project
mkdir cs465-backend
cd cs465-backend
npm init -y

# Install Express and dependencies
npm install express cors dotenv helmet morgan
npm install mongoose jsonwebtoken bcryptjs
npm install -D nodemon typescript @types/express @types/node
```

**Express.js Project Structure:**
```
cs465-backend/
├── src/
│   ├── controllers/
│   ├── models/
│   ├── routes/
│   ├── middleware/
│   ├── utils/
│   └── app.ts
├── package.json
├── tsconfig.json
├── .env
└── README.md
```

**Basic Express Server:**
```typescript
// src/app.ts
import express from 'express';
import cors from 'cors';
import dotenv from 'dotenv';

dotenv.config();

const app = express();
const PORT = process.env.PORT || 3000;

// Middleware
app.use(cors());
app.use(express.json());

// Routes
app.get('/api/health', (req, res) => {
  res.json({ message: 'Server is running!' });
});

app.listen(PORT, () => {
  console.log(`Server running on port ${PORT}`);
});
```

### REST API Development
**Essential Tools:**
- **Postman**: https://www.postman.com/downloads/
- **Thunder Client** (VS Code Extension)
- **Insomnia**: https://insomnia.rest/download

**API Testing Commands:**
```bash
# Test API endpoints
curl -X GET http://localhost:3000/api/health
curl -X POST http://localhost:3000/api/users -H "Content-Type: application/json" -d '{"name":"John","email":"john@example.com"}'
```

## 🗄️ Database Technologies

### MongoDB Setup
**Local Installation:**
```bash
# Windows (using Chocolatey)
choco install mongodb

# Mac (using Homebrew)
brew tap mongodb/brew
brew install mongodb-community

# Start MongoDB
mongod --dbpath /data/db
```

**MongoDB Atlas (Cloud):**
1. Sign up at https://www.mongodb.com/atlas
2. Create free cluster
3. Get connection string
4. Install MongoDB Compass (GUI tool)

**Mongoose Setup:**
```typescript
// src/models/connection.ts
import mongoose from 'mongoose';

const connectDB = async () => {
  try {
    await mongoose.connect(process.env.MONGODB_URI!);
    console.log('MongoDB connected successfully');
  } catch (error) {
    console.error('MongoDB connection error:', error);
    process.exit(1);
  }
};

export default connectDB;
```

### MySQL Setup
**Local Installation:**
```bash
# Windows (using Chocolatey)
choco install mysql

# Mac (using Homebrew)
brew install mysql

# Start MySQL
mysql.server start
```

**MySQL Workbench:**
- Download: https://dev.mysql.com/downloads/workbench/
- GUI for database management
- Query editor and visual designer

## 🧪 Testing Frameworks

### Frontend Testing
**Jest & Angular Testing:**
```bash
# Angular comes with Jasmine/Karma by default
ng test

# Install additional testing tools
npm install -D jasmine-core karma karma-chrome-launcher
```

**Testing Example:**
```typescript
// src/app/components/my-component.component.spec.ts
import { ComponentFixture, TestBed } from '@angular/core/testing';
import { MyComponent } from './my-component.component';

describe('MyComponent', () => {
  let component: MyComponent;
  let fixture: ComponentFixture<MyComponent>;

  beforeEach(async () => {
    await TestBed.configureTestingModule({
      declarations: [ MyComponent ]
    })
    .compileComponents();
  });

  beforeEach(() => {
    fixture = TestBed.createComponent(MyComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
```

### Backend Testing
**Jest for Node.js:**
```bash
npm install -D jest @types/jest supertest @types/supertest
```

**Testing Example:**
```typescript
// tests/app.test.ts
import request from 'supertest';
import app from '../src/app';

describe('API Endpoints', () => {
  test('GET /api/health', async () => {
    const response = await request(app).get('/api/health');
    expect(response.status).toBe(200);
    expect(response.body.message).toBe('Server is running!');
  });
});
```

## 🚀 Development Workflow

### Git & GitHub
**Repository Setup:**
```bash
# Initialize repository
git init
git add .
git commit -m "Initial commit"

# Connect to GitHub
git remote add origin https://github.com/username/cs465-project.git
git push -u origin main
```

**Branching Strategy:**
```bash
# Create feature branch
git checkout -b feature/user-authentication

# Work on feature
git add .
git commit -m "Add user authentication"

# Push and create PR
git push origin feature/user-authentication
```

### Environment Configuration
**Environment Variables (.env):**
```env
# Database
MONGODB_URI=mongodb://localhost:27017/cs465-db
MYSQL_HOST=localhost
MYSQL_USER=root
MYSQL_PASSWORD=REPLACE_WITH_ACTUAL_PASSWORD
# WARNING: Never commit real passwords to version control
MYSQL_DATABASE=cs465_db

# JWT
# WARNING: Generate a strong random secret for production
# Use: openssl rand -base64 32
JWT_SECRET=REPLACE_WITH_STRONG_RANDOM_SECRET
JWT_EXPIRES_IN=24h

# Server
PORT=3000
NODE_ENV=development

# Frontend
API_URL=http://localhost:3000/api
```

### Package.json Scripts
```json
{
  "scripts": {
    "start": "node dist/app.js",
    "dev": "nodemon src/app.ts",
    "build": "tsc",
    "test": "jest",
    "test:watch": "jest --watch",
    "lint": "eslint src/**/*.ts",
    "format": "prettier --write src/**/*.ts"
  }
}
```

## ☁️ Deployment Platforms

### Heroku
**Setup:**
```bash
# Install Heroku CLI
# Download from: https://devcenter.heroku.com/articles/heroku-cli

# Login
heroku login

# Create app
heroku create cs465-my-app

# Deploy
git push heroku main
```

**Heroku Configuration:**
```json
// package.json
{
  "engines": {
    "node": "18.x"
  }
}
```

### Netlify (Frontend)
**Setup:**
1. Connect GitHub repository
2. Build command: `ng build --prod`
3. Publish directory: `dist/cs465-angular-app`

### Vercel (Full Stack)
**Setup:**
```bash
# Install Vercel CLI
npm install -g vercel

# Deploy
vercel

# Configure vercel.json
{
  "version": 2,
  "builds": [
    {
      "src": "package.json",
      "use": "@vercel/node"
    }
  ]
}
```

## 🛠️ Development Tools

### VS Code Extensions
**Essential Extensions:**
- **Angular Language Service**
- **TypeScript Importer**
- **Prettier - Code formatter**
- **ESLint**
- **Thunder Client**
- **GitLens**
- **Auto Rename Tag**
- **Bracket Pair Colorizer**

### Browser DevTools
**Chrome DevTools:**
- **Elements**: Inspect HTML/CSS
- **Console**: JavaScript debugging
- **Network**: API monitoring
- **Application**: Local storage, cookies
- **Lighthouse**: Performance auditing

### API Documentation
**Swagger/OpenAPI:**
```bash
# Install Swagger
npm install swagger-jsdoc swagger-ui-express
npm install -D @types/swagger-jsdoc @types/swagger-ui-express
```

## 📚 Learning Resources

### Web Development
- **MDN Web Docs**: https://developer.mozilla.org/
- **W3Schools**: https://www.w3schools.com/
- **FreeCodeCamp**: https://www.freecodecamp.org/
- **The Odin Project**: https://www.theodinproject.com/

### Angular
- **Angular Documentation**: https://angular.io/docs
- **Angular University**: https://angular-university.io/
- **Angular Material**: https://material.angular.io/
- **Angular DevTools**: https://angular.io/guide/devtools

### Node.js
- **Node.js Documentation**: https://nodejs.org/docs/
- **Express.js Guide**: https://expressjs.com/
- **MongoDB University**: https://university.mongodb.com/
- **Jest Documentation**: https://jestjs.io/docs/getting-started

### Deployment
- **Heroku Dev Center**: https://devcenter.heroku.com/
- **Netlify Docs**: https://docs.netlify.com/
- **Vercel Docs**: https://vercel.com/docs

## 🎯 CS-465 Project Checklist

### Phase 1: Setup
- [ ] Install Node.js and npm
- [ ] Install Angular CLI
- [ ] Set up MongoDB (local or Atlas)
- [ ] Create GitHub repository
- [ ] Configure VS Code with extensions

### Phase 2: Backend Development
- [ ] Create Express.js server
- [ ] Set up MongoDB connection
- [ ] Create API endpoints
- [ ] Implement authentication
- [ ] Add input validation
- [ ] Write unit tests

### Phase 3: Frontend Development
- [ ] Create Angular application
- [ ] Set up routing
- [ ] Create components and services
- [ ] Implement API integration
- [ ] Add responsive design
- [ ] Write component tests

### Phase 4: Integration & Deployment
- [ ] Connect frontend to backend
- [ ] Test full application
- [ ] Deploy to cloud platform
- [ ] Set up CI/CD pipeline
- [ ] Document API endpoints
- [ ] Create user documentation

## 💡 Pro Tips

1. **Start Simple**: Begin with basic CRUD operations
2. **Use TypeScript**: Better development experience and fewer bugs
3. **Test Early**: Write tests as you develop features
4. **Version Control**: Commit frequently with meaningful messages
5. **Documentation**: Keep README files updated
6. **Security**: Always validate input and use HTTPS
7. **Performance**: Monitor and optimize loading times
8. **Mobile First**: Design for mobile devices first
9. **Accessibility**: Follow WCAG guidelines
10. **Backup**: Regular database backups and code repositories

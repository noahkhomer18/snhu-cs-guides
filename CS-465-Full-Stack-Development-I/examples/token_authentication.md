# Token-Based Authentication - Complete Implementation Guide

## Overview
Token-based authentication provides secure access control for your full stack application. This guide covers JWT (JSON Web Token) implementation for both frontend and backend.

## Backend Authentication Implementation

### JWT Token Generation
```javascript
// utils/jwt.js
const jwt = require('jsonwebtoken');

const generateToken = (userId) => {
  return jwt.sign(
    { id: userId },
    process.env.JWT_SECRET || 'your-secret-key',
    {
      expiresIn: process.env.JWT_EXPIRES_IN || '24h'
    }
  );
};

const verifyToken = (token) => {
  try {
    return jwt.verify(token, process.env.JWT_SECRET || 'your-secret-key');
  } catch (error) {
    throw new Error('Invalid or expired token');
  }
};

module.exports = { generateToken, verifyToken };
```

### Authentication Middleware
```javascript
// middleware/auth.middleware.js
const User = require('../models/User');
const { verifyToken } = require('../utils/jwt');

const authenticate = async (req, res, next) => {
  try {
    // Get token from header
    const authHeader = req.header('Authorization');
    
    if (!authHeader || !authHeader.startsWith('Bearer ')) {
      return res.status(401).json({
        success: false,
        message: 'No token provided, authorization denied'
      });
    }

    // Extract token
    const token = authHeader.substring(7); // Remove 'Bearer ' prefix

    // Verify token
    const decoded = verifyToken(token);

    // Get user from database
    const user = await User.findById(decoded.id).select('-password');

    if (!user) {
      return res.status(401).json({
        success: false,
        message: 'User not found'
      });
    }

    // Attach user to request
    req.user = user;
    next();
  } catch (error) {
    res.status(401).json({
      success: false,
      message: 'Token is not valid'
    });
  }
};

// Role-based authorization
const authorize = (...roles) => {
  return (req, res, next) => {
    if (!req.user) {
      return res.status(401).json({
        success: false,
        message: 'Not authenticated'
      });
    }

    if (!roles.includes(req.user.role)) {
      return res.status(403).json({
        success: false,
        message: 'Access denied. Insufficient permissions.'
      });
    }

    next();
  };
};

module.exports = { authenticate, authorize };
```

### Login Controller
```javascript
// controllers/auth.controller.js
const User = require('../models/User');
const { generateToken } = require('../utils/jwt');

const login = async (req, res) => {
  try {
    const { username, password } = req.body;

    // Validate input
    if (!username || !password) {
      return res.status(400).json({
        success: false,
        message: 'Please provide username and password'
      });
    }

    // Find user and include password field
    const user = await User.findOne({ username }).select('+password');

    if (!user) {
      return res.status(401).json({
        success: false,
        message: 'Invalid credentials'
      });
    }

    // Check password
    const isMatch = await user.comparePassword(password);

    if (!isMatch) {
      return res.status(401).json({
        success: false,
        message: 'Invalid credentials'
      });
    }

    // Generate token
    const token = generateToken(user._id);

    // Return token and user data (without password)
    res.json({
      success: true,
      token,
      user: {
        _id: user._id,
        username: user.username,
        email: user.email,
        role: user.role
      }
    });
  } catch (error) {
    res.status(500).json({
      success: false,
      message: error.message
    });
  }
};

module.exports = { login };
```

### Protected Routes Example
```javascript
// routes/packages.routes.js
const express = require('express');
const router = express.Router();
const { authenticate, authorize } = require('../middleware/auth.middleware');
const {
  getPackages,
  getPackage,
  createPackage,
  updatePackage,
  deletePackage
} = require('../controllers/packages.controller');

// Public routes
router.get('/', getPackages);
router.get('/:id', getPackage);

// Protected admin routes
router.post(
  '/',
  authenticate,           // Check if user is authenticated
  authorize('admin'),     // Check if user has admin role
  createPackage
);

router.put(
  '/:id',
  authenticate,
  authorize('admin'),
  updatePackage
);

router.delete(
  '/:id',
  authenticate,
  authorize('admin'),
  deletePackage
);

module.exports = router;
```

## Frontend Authentication Implementation

### Auth Service (Angular)
```typescript
// services/auth.service.ts
import { Injectable } from '@angular/core';
import { HttpClient } from '@angular/common/http';
import { BehaviorSubject, Observable } from 'rxjs';
import { tap } from 'rxjs/operators';
import { Router } from '@angular/router';

export interface LoginResponse {
  success: boolean;
  token: string;
  user: {
    _id: string;
    username: string;
    email: string;
    role: string;
  };
}

export interface User {
  _id: string;
  username: string;
  email: string;
  role: string;
}

@Injectable({
  providedIn: 'root'
})
export class AuthService {
  private apiUrl = 'http://localhost:3000/api/auth';
  private tokenKey = 'auth_token';
  private userKey = 'current_user';
  
  private currentUserSubject = new BehaviorSubject<User | null>(this.getStoredUser());
  public currentUser$ = this.currentUserSubject.asObservable();

  constructor(
    private http: HttpClient,
    private router: Router
  ) { }

  login(username: string, password: string): Observable<LoginResponse> {
    return this.http.post<LoginResponse>(`${this.apiUrl}/login`, {
      username,
      password
    }).pipe(
      tap(response => {
        if (response.success) {
          this.setAuthData(response.token, response.user);
        }
      })
    );
  }

  logout(): void {
    localStorage.removeItem(this.tokenKey);
    localStorage.removeItem(this.userKey);
    this.currentUserSubject.next(null);
    this.router.navigate(['/login']);
  }

  getToken(): string | null {
    return localStorage.getItem(this.tokenKey);
  }

  isAuthenticated(): boolean {
    return !!this.getToken();
  }

  private setAuthData(token: string, user: User): void {
    localStorage.setItem(this.tokenKey, token);
    localStorage.setItem(this.userKey, JSON.stringify(user));
    this.currentUserSubject.next(user);
  }

  private getStoredUser(): User | null {
    const userStr = localStorage.getItem(this.userKey);
    return userStr ? JSON.parse(userStr) : null;
  }

  getCurrentUser(): User | null {
    return this.currentUserSubject.value;
  }

  isAdmin(): boolean {
    const user = this.getCurrentUser();
    return user?.role === 'admin';
  }
}
```

### Auth Interceptor (Angular)
```typescript
// interceptors/auth.interceptor.ts
import { Injectable } from '@angular/core';
import {
  HttpInterceptor,
  HttpRequest,
  HttpHandler,
  HttpEvent
} from '@angular/common/http';
import { Observable } from 'rxjs';
import { AuthService } from '../services/auth.service';

@Injectable()
export class AuthInterceptor implements HttpInterceptor {
  constructor(private authService: AuthService) { }

  intercept(
    request: HttpRequest<any>,
    next: HttpHandler
  ): Observable<HttpEvent<any>> {
    const token = this.authService.getToken();

    if (token) {
      // Clone request and add authorization header
      request = request.clone({
        setHeaders: {
          Authorization: `Bearer ${token}`
        }
      });
    }

    return next.handle(request);
  }
}
```

### Auth Guard (Angular)
```typescript
// guards/auth.guard.ts
import { Injectable } from '@angular/core';
import {
  CanActivate,
  ActivatedRouteSnapshot,
  RouterStateSnapshot,
  Router
} from '@angular/router';
import { AuthService } from '../services/auth.service';

@Injectable({
  providedIn: 'root'
})
export class AuthGuard implements CanActivate {
  constructor(
    private authService: AuthService,
    private router: Router
  ) { }

  canActivate(
    route: ActivatedRouteSnapshot,
    state: RouterStateSnapshot
  ): boolean {
    if (this.authService.isAuthenticated()) {
      return true;
    }

    // Redirect to login with return URL
    this.router.navigate(['/login'], {
      queryParams: { returnUrl: state.url }
    });
    return false;
  }
}
```

### Admin Guard (Angular)
```typescript
// guards/admin.guard.ts
import { Injectable } from '@angular/core';
import {
  CanActivate,
  ActivatedRouteSnapshot,
  RouterStateSnapshot,
  Router
} from '@angular/router';
import { AuthService } from '../services/auth.service';

@Injectable({
  providedIn: 'root'
})
export class AdminGuard implements CanActivate {
  constructor(
    private authService: AuthService,
    private router: Router
  ) { }

  canActivate(
    route: ActivatedRouteSnapshot,
    state: RouterStateSnapshot
  ): boolean {
    if (this.authService.isAuthenticated() && this.authService.isAdmin()) {
      return true;
    }

    this.router.navigate(['/dashboard']);
    return false;
  }
}
```

### Login Component
```typescript
// components/login/login.component.ts
import { Component, OnInit } from '@angular/core';
import { FormBuilder, FormGroup, Validators } from '@angular/forms';
import { Router, ActivatedRoute } from '@angular/router';
import { AuthService } from '../../services/auth.service';
import { MatSnackBar } from '@angular/material/snack-bar';

@Component({
  selector: 'app-login',
  templateUrl: './login.component.html',
  styleUrls: ['./login.component.css']
})
export class LoginComponent implements OnInit {
  loginForm: FormGroup;
  loading = false;
  returnUrl: string = '/dashboard';

  constructor(
    private fb: FormBuilder,
    private authService: AuthService,
    private router: Router,
    private route: ActivatedRoute,
    private snackBar: MatSnackBar
  ) {
    this.loginForm = this.fb.group({
      username: ['', [Validators.required]],
      password: ['', [Validators.required]]
    });
  }

  ngOnInit(): void {
    // Get return URL from route parameters or default to '/dashboard'
    this.returnUrl = this.route.snapshot.queryParams['returnUrl'] || '/dashboard';

    // Redirect if already logged in
    if (this.authService.isAuthenticated()) {
      this.router.navigate([this.returnUrl]);
    }
  }

  onSubmit(): void {
    if (this.loginForm.valid) {
      this.loading = true;
      const { username, password } = this.loginForm.value;

      this.authService.login(username, password).subscribe({
        next: (response) => {
          if (response.success) {
            this.router.navigate([this.returnUrl]);
          }
          this.loading = false;
        },
        error: (error) => {
          this.snackBar.open(
            error.error?.message || 'Login failed. Please check your credentials.',
            'Close',
            { duration: 3000 }
          );
          this.loading = false;
        }
      });
    }
  }
}
```

## Testing Authentication

### Testing with Valid Credentials
```javascript
// Test login endpoint
const testLogin = async () => {
  const response = await fetch('http://localhost:3000/api/auth/login', {
    method: 'POST',
    headers: {
      'Content-Type': 'application/json'
    },
    body: JSON.stringify({
      username: 'admin',
      password: 'password123'
    })
  });

  const data = await response.json();
  console.log('Login response:', data);
  
  if (data.success) {
    // Store token
    localStorage.setItem('token', data.token);
    console.log('Token stored:', data.token);
  }
};
```

### Testing Protected Endpoints
```javascript
// Test protected endpoint with token
const testProtectedEndpoint = async () => {
  const token = localStorage.getItem('token');

  const response = await fetch('http://localhost:3000/api/packages', {
    method: 'POST',
    headers: {
      'Content-Type': 'application/json',
      'Authorization': `Bearer ${token}`
    },
    body: JSON.stringify({
      name: 'Test Package',
      location: 'Test Location',
      price: 100,
      duration: 3
    })
  });

  const data = await response.json();
  console.log('Protected endpoint response:', data);
};
```

### Testing Invalid Token
```javascript
// Test with invalid token
const testInvalidToken = async () => {
  const response = await fetch('http://localhost:3000/api/packages', {
    method: 'POST',
    headers: {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer invalid-token-here'
    },
    body: JSON.stringify({
      name: 'Test Package'
    })
  });

  const data = await response.json();
  console.log('Invalid token response:', data);
  // Should return 401 Unauthorized
};
```

## Security Best Practices

### 1. Secure Token Storage
```typescript
// Use httpOnly cookies in production (more secure than localStorage)
// For client-side apps, localStorage is acceptable but less secure

// Backend: Set httpOnly cookie
res.cookie('token', token, {
  httpOnly: true,
  secure: process.env.NODE_ENV === 'production',
  sameSite: 'strict',
  maxAge: 24 * 60 * 60 * 1000 // 24 hours
});
```

### 2. Token Refresh
```typescript
// Implement token refresh mechanism
refreshToken(): Observable<LoginResponse> {
  return this.http.post<LoginResponse>(`${this.apiUrl}/refresh`, {
    refreshToken: this.getRefreshToken()
  }).pipe(
    tap(response => {
      if (response.success) {
        this.setAuthData(response.token, response.user);
      }
    })
  );
}
```

### 3. Token Expiration Handling
```typescript
// Interceptor to handle token expiration
intercept(request: HttpRequest<any>, next: HttpHandler): Observable<HttpEvent<any>> {
  return next.handle(request).pipe(
    catchError((error: HttpErrorResponse) => {
      if (error.status === 401) {
        // Token expired or invalid
        this.authService.logout();
        this.router.navigate(['/login']);
      }
      return throwError(() => error);
    })
  );
}
```

### 4. Password Security
```javascript
// Always hash passwords (using bcrypt)
const bcrypt = require('bcryptjs');

// Hash password before saving
userSchema.pre('save', async function(next) {
  if (!this.isModified('password')) return next();
  
  const salt = await bcrypt.genSalt(10);
  this.password = await bcrypt.hash(this.password, salt);
  next();
});

// Compare password method
userSchema.methods.comparePassword = async function(candidatePassword) {
  return bcrypt.compare(candidatePassword, this.password);
};
```

This comprehensive guide provides secure token-based authentication implementation for both frontend and backend, ensuring your application has proper access control and security measures.


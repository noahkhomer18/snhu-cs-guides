# JSON Data Handling and API Communication Guide

## Overview
JSON (JavaScript Object Notation) serves as the bridge between frontend and backend in full stack development. This guide covers JSON data handling, API communication patterns, and best practices.

## Understanding JSON vs JavaScript

### JSON Structure
```json
{
  "name": "Beach Paradise",
  "location": "Hawaii",
  "price": 599,
  "duration": 7,
  "images": [
    "https://example.com/image1.jpg",
    "https://example.com/image2.jpg"
  ],
  "itinerary": [
    "Day 1: Arrival and beach activities",
    "Day 2: Snorkeling adventure"
  ],
  "active": true
}
```

### Key Differences
- **JSON**: Data format only (no functions, no undefined, no comments)
- **JavaScript**: Can include functions, logic, and more data types
- **JSON**: Keys must be strings (in double quotes)
- **JSON**: Values can be strings, numbers, booleans, arrays, objects, or null

## Frontend JSON Handling

### Fetching JSON from API (JavaScript)
```javascript
// Basic fetch request
async function fetchPackages() {
  try {
    const response = await fetch('http://localhost:3000/api/packages');
    
    if (!response.ok) {
      throw new Error(`HTTP error! status: ${response.status}`);
    }
    
    const packages = await response.json();
    console.log('Packages:', packages);
    return packages;
  } catch (error) {
    console.error('Error fetching packages:', error);
    throw error;
  }
}

// Using the function
fetchPackages()
  .then(packages => {
    packages.data.forEach(pkg => {
      console.log(`${pkg.name} - $${pkg.price}`);
    });
  })
  .catch(error => {
    console.error('Failed to load packages:', error);
  });
```

### POST Request with JSON (JavaScript)
```javascript
async function createPackage(packageData) {
  try {
    const response = await fetch('http://localhost:3000/api/packages', {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json',
        'Authorization': `Bearer ${getToken()}`
      },
      body: JSON.stringify(packageData)
    });

    if (!response.ok) {
      const error = await response.json();
      throw new Error(error.message || 'Failed to create package');
    }

    const newPackage = await response.json();
    return newPackage;
  } catch (error) {
    console.error('Error creating package:', error);
    throw error;
  }
}

// Usage
const newPackage = {
  name: "Mountain Adventure",
  location: "Switzerland",
  price: 799,
  duration: 5,
  description: "Amazing mountain experience",
  images: [],
  itinerary: [],
  status: "active"
};

createPackage(newPackage)
  .then(result => {
    console.log('Package created:', result);
  })
  .catch(error => {
    console.error('Error:', error);
  });
```

### PUT Request with JSON (JavaScript)
```javascript
async function updatePackage(id, updates) {
  try {
    const response = await fetch(`http://localhost:3000/api/packages/${id}`, {
      method: 'PUT',
      headers: {
        'Content-Type': 'application/json',
        'Authorization': `Bearer ${getToken()}`
      },
      body: JSON.stringify(updates)
    });

    if (!response.ok) {
      const error = await response.json();
      throw new Error(error.message || 'Failed to update package');
    }

    const updatedPackage = await response.json();
    return updatedPackage;
  } catch (error) {
    console.error('Error updating package:', error);
    throw error;
  }
}

// Usage
updatePackage('507f1f77bcf86cd799439011', {
  price: 899,
  status: 'active'
})
  .then(result => {
    console.log('Package updated:', result);
  });
```

## Angular HTTP Client

### Package Service with JSON (Angular)
```typescript
import { Injectable } from '@angular/core';
import { HttpClient, HttpHeaders, HttpErrorResponse } from '@angular/common/http';
import { Observable, throwError } from 'rxjs';
import { catchError, map } from 'rxjs/operators';
import { Package } from '../models/package.model';

@Injectable({
  providedIn: 'root'
})
export class PackageService {
  private apiUrl = 'http://localhost:3000/api/packages';
  private headers = new HttpHeaders({
    'Content-Type': 'application/json'
  });

  constructor(private http: HttpClient) { }

  // GET - Fetch all packages
  getPackages(): Observable<Package[]> {
    return this.http.get<{ success: boolean; data: Package[] }>(this.apiUrl)
      .pipe(
        map(response => response.data),
        catchError(this.handleError)
      );
  }

  // GET - Fetch single package
  getPackage(id: string): Observable<Package> {
    return this.http.get<{ success: boolean; data: Package }>(`${this.apiUrl}/${id}`)
      .pipe(
        map(response => response.data),
        catchError(this.handleError)
      );
  }

  // POST - Create new package
  createPackage(packageData: Package): Observable<Package> {
    return this.http.post<{ success: boolean; data: Package }>(
      this.apiUrl,
      packageData,
      { headers: this.headers }
    ).pipe(
      map(response => response.data),
      catchError(this.handleError)
    );
  }

  // PUT - Update package
  updatePackage(id: string, packageData: Partial<Package>): Observable<Package> {
    return this.http.put<{ success: boolean; data: Package }>(
      `${this.apiUrl}/${id}`,
      packageData,
      { headers: this.headers }
    ).pipe(
      map(response => response.data),
      catchError(this.handleError)
    );
  }

  // DELETE - Delete package
  deletePackage(id: string): Observable<void> {
    return this.http.delete<{ success: boolean }>(`${this.apiUrl}/${id}`)
      .pipe(
        map(() => undefined),
        catchError(this.handleError)
      );
  }

  // Error handling
  private handleError(error: HttpErrorResponse): Observable<never> {
    let errorMessage = 'An unknown error occurred';
    
    if (error.error instanceof ErrorEvent) {
      // Client-side error
      errorMessage = `Error: ${error.error.message}`;
    } else {
      // Server-side error
      errorMessage = error.error?.message || `Error Code: ${error.status}\nMessage: ${error.message}`;
    }
    
    console.error(errorMessage);
    return throwError(() => new Error(errorMessage));
  }
}
```

### Using the Service in Component
```typescript
import { Component, OnInit } from '@angular/core';
import { PackageService } from '../services/package.service';
import { Package } from '../models/package.model';

@Component({
  selector: 'app-package-list',
  templateUrl: './package-list.component.html'
})
export class PackageListComponent implements OnInit {
  packages: Package[] = [];
  loading = false;
  error: string | null = null;

  constructor(private packageService: PackageService) { }

  ngOnInit(): void {
    this.loadPackages();
  }

  loadPackages(): void {
    this.loading = true;
    this.error = null;

    this.packageService.getPackages().subscribe({
      next: (packages) => {
        this.packages = packages;
        this.loading = false;
      },
      error: (error) => {
        this.error = error.message;
        this.loading = false;
      }
    });
  }

  createPackage(): void {
    const newPackage: Package = {
      name: 'New Package',
      location: 'Destination',
      description: 'Description here',
      price: 500,
      duration: 3,
      images: [],
      itinerary: [],
      status: 'active'
    };

    this.packageService.createPackage(newPackage).subscribe({
      next: (created) => {
        console.log('Created:', created);
        this.loadPackages(); // Refresh list
      },
      error: (error) => {
        console.error('Error creating:', error);
      }
    });
  }
}
```

## Backend JSON Handling

### Express.js JSON Middleware
```javascript
const express = require('express');
const app = express();

// Parse JSON bodies (built-in middleware)
app.use(express.json());

// Parse URL-encoded bodies
app.use(express.urlencoded({ extended: true }));

// Custom JSON response helper
app.use((req, res, next) => {
  res.jsonSuccess = (data, message = 'Success') => {
    res.json({
      success: true,
      message,
      data
    });
  };

  res.jsonError = (message = 'Error', statusCode = 400) => {
    res.status(statusCode).json({
      success: false,
      message
    });
  };

  next();
});

// Example route using helpers
app.post('/api/packages', (req, res) => {
  const packageData = req.body; // Already parsed JSON

  // Validate JSON structure
  if (!packageData.name || !packageData.price) {
    return res.jsonError('Name and price are required', 400);
  }

  // Process and save...
  const savedPackage = { ...packageData, id: Date.now() };

  res.jsonSuccess(savedPackage, 'Package created successfully');
});
```

### JSON Validation
```javascript
const express = require('express');
const { body, validationResult } = require('express-validator');

app.post('/api/packages',
  [
    body('name')
      .trim()
      .notEmpty()
      .withMessage('Name is required')
      .isLength({ min: 3, max: 100 })
      .withMessage('Name must be between 3 and 100 characters'),
    body('price')
      .isFloat({ min: 0 })
      .withMessage('Price must be a positive number'),
    body('location')
      .trim()
      .notEmpty()
      .withMessage('Location is required'),
    body('images')
      .optional()
      .isArray()
      .withMessage('Images must be an array'),
    body('images.*')
      .optional()
      .isURL()
      .withMessage('Each image must be a valid URL')
  ],
  (req, res) => {
    const errors = validationResult(req);
    
    if (!errors.isEmpty()) {
      return res.status(400).json({
        success: false,
        errors: errors.array()
      });
    }

    // Process valid JSON data
    const packageData = req.body;
    // ... save to database
    res.jsonSuccess(packageData);
  }
);
```

## JSON Data Transformation

### Transforming Data Before Sending
```javascript
// Backend: Transform MongoDB document to JSON response
app.get('/api/packages/:id', async (req, res) => {
  try {
    const package = await Package.findById(req.params.id);

    if (!package) {
      return res.status(404).json({
        success: false,
        message: 'Package not found'
      });
    }

    // Transform to desired JSON structure
    const packageJSON = {
      id: package._id.toString(),
      name: package.name,
      location: package.location,
      price: package.price,
      duration: package.duration,
      description: package.description,
      images: package.images || [],
      itinerary: package.itinerary || [],
      status: package.status,
      createdAt: package.createdAt.toISOString(),
      updatedAt: package.updatedAt.toISOString()
    };

    res.json({
      success: true,
      data: packageJSON
    });
  } catch (error) {
    res.status(500).json({
      success: false,
      message: error.message
    });
  }
});
```

### Transforming Data on Frontend
```typescript
// Angular: Transform API response
transformPackageResponse(response: any): Package {
  return {
    id: response._id || response.id,
    name: response.name,
    location: response.location,
    price: Number(response.price),
    duration: Number(response.duration),
    description: response.description || '',
    images: Array.isArray(response.images) ? response.images : [],
    itinerary: Array.isArray(response.itinerary) ? response.itinerary : [],
    status: response.status || 'active',
    createdAt: new Date(response.createdAt),
    updatedAt: new Date(response.updatedAt)
  };
}

// Use in service
getPackage(id: string): Observable<Package> {
  return this.http.get(`${this.apiUrl}/${id}`).pipe(
    map((response: any) => this.transformPackageResponse(response.data))
  );
}
```

## Error Handling with JSON

### Standardized Error Response Format
```javascript
// Backend error middleware
app.use((err, req, res, next) => {
  const errorResponse = {
    success: false,
    message: err.message || 'Internal Server Error',
    ...(process.env.NODE_ENV === 'development' && {
      stack: err.stack,
      details: err
    })
  };

  res.status(err.statusCode || 500).json(errorResponse);
});
```

### Frontend Error Handling
```typescript
// Angular error interceptor
import { Injectable } from '@angular/core';
import { HttpInterceptor, HttpRequest, HttpHandler, HttpErrorResponse } from '@angular/common/http';
import { Observable, throwError } from 'rxjs';
import { catchError } from 'rxjs/operators';
import { MatSnackBar } from '@angular/material/snack-bar';

@Injectable()
export class ErrorInterceptor implements HttpInterceptor {
  constructor(private snackBar: MatSnackBar) { }

  intercept(req: HttpRequest<any>, next: HttpHandler): Observable<any> {
    return next.handle(req).pipe(
      catchError((error: HttpErrorResponse) => {
        let errorMessage = 'An error occurred';

        if (error.error instanceof ErrorEvent) {
          // Client-side error
          errorMessage = error.error.message;
        } else {
          // Server-side error
          const serverError = error.error;
          errorMessage = serverError?.message || `Error Code: ${error.status}`;
        }

        this.snackBar.open(errorMessage, 'Close', {
          duration: 5000
        });

        return throwError(() => error);
      })
    );
  }
}
```

## JSON Best Practices

### 1. Consistent Response Format
```javascript
// Always use consistent structure
{
  "success": true/false,
  "message": "Optional message",
  "data": { /* actual data */ },
  "errors": [ /* if any */ ]
}
```

### 2. Proper Content-Type Headers
```javascript
// Always set Content-Type for JSON
headers: {
  'Content-Type': 'application/json'
}
```

### 3. Validate JSON Structure
```javascript
// Validate before processing
function isValidPackage(data) {
  return (
    typeof data === 'object' &&
    data !== null &&
    typeof data.name === 'string' &&
    typeof data.price === 'number' &&
    Array.isArray(data.images)
  );
}
```

### 4. Handle Large JSON Responses
```javascript
// Use pagination for large datasets
app.get('/api/packages', async (req, res) => {
  const page = parseInt(req.query.page) || 1;
  const limit = parseInt(req.query.limit) || 10;
  const skip = (page - 1) * limit;

  const packages = await Package.find()
    .skip(skip)
    .limit(limit);

  const total = await Package.countDocuments();

  res.json({
    success: true,
    data: packages,
    pagination: {
      page,
      limit,
      total,
      pages: Math.ceil(total / limit)
    }
  });
});
```

### 5. Sanitize JSON Input
```javascript
// Remove unwanted fields
function sanitizePackageInput(data) {
  const allowed = ['name', 'location', 'price', 'duration', 'description', 'images', 'itinerary'];
  const sanitized = {};
  
  allowed.forEach(key => {
    if (data[key] !== undefined) {
      sanitized[key] = data[key];
    }
  });
  
  return sanitized;
}
```

This guide provides comprehensive examples of JSON handling and API communication patterns essential for full stack development.


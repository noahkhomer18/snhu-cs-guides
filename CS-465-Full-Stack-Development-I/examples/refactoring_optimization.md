# Refactoring and Optimization Guide

## Overview
This guide covers refactoring techniques and optimization strategies for improving code quality, reusability, and performance in your full stack application.

## Component Reusability

### Before: Duplicated Code
```typescript
// package-list.component.ts - BEFORE
export class PackageListComponent {
  packages: Package[] = [];
  loading = false;

  ngOnInit() {
    this.loading = true;
    this.http.get('/api/packages').subscribe(
      (response: any) => {
        this.packages = response.data;
        this.loading = false;
      },
      (error) => {
        console.error(error);
        this.loading = false;
      }
    );
  }
}

// booking-list.component.ts - BEFORE (duplicated code)
export class BookingListComponent {
  bookings: Booking[] = [];
  loading = false;

  ngOnInit() {
    this.loading = true;
    this.http.get('/api/bookings').subscribe(
      (response: any) => {
        this.bookings = response.data;
        this.loading = false;
      },
      (error) => {
        console.error(error);
        this.loading = false;
      }
    );
  }
}
```

### After: Reusable Service
```typescript
// base.service.ts - Reusable base service
export abstract class BaseService<T> {
  protected apiUrl: string;

  constructor(
    protected http: HttpClient,
    endpoint: string
  ) {
    this.apiUrl = `http://localhost:3000/api/${endpoint}`;
  }

  getAll(): Observable<T[]> {
    return this.http.get<{ success: boolean; data: T[] }>(this.apiUrl)
      .pipe(
        map(response => response.data),
        catchError(this.handleError)
      );
  }

  getById(id: string): Observable<T> {
    return this.http.get<{ success: boolean; data: T }>(`${this.apiUrl}/${id}`)
      .pipe(
        map(response => response.data),
        catchError(this.handleError)
      );
  }

  create(item: T): Observable<T> {
    return this.http.post<{ success: boolean; data: T }>(this.apiUrl, item)
      .pipe(
        map(response => response.data),
        catchError(this.handleError)
      );
  }

  update(id: string, item: Partial<T>): Observable<T> {
    return this.http.put<{ success: boolean; data: T }>(`${this.apiUrl}/${id}`, item)
      .pipe(
        map(response => response.data),
        catchError(this.handleError)
      );
  }

  delete(id: string): Observable<void> {
    return this.http.delete(`${this.apiUrl}/${id}`)
      .pipe(
        map(() => undefined),
        catchError(this.handleError)
      );
  }

  protected handleError(error: HttpErrorResponse): Observable<never> {
    console.error('Service error:', error);
    return throwError(() => new Error(error.error?.message || 'An error occurred'));
  }
}

// package.service.ts - Extends base service
@Injectable({ providedIn: 'root' })
export class PackageService extends BaseService<Package> {
  constructor(http: HttpClient) {
    super(http, 'packages');
  }

  // Add package-specific methods
  getActivePackages(): Observable<Package[]> {
    return this.http.get<{ success: boolean; data: Package[] }>(`${this.apiUrl}?status=active`)
      .pipe(
        map(response => response.data),
        catchError(this.handleError)
      );
  }
}

// booking.service.ts - Extends base service
@Injectable({ providedIn: 'root' })
export class BookingService extends BaseService<Booking> {
  constructor(http: HttpClient) {
    super(http, 'bookings');
  }
}
```

### Reusable UI Components
```typescript
// shared/loading-spinner.component.ts
@Component({
  selector: 'app-loading-spinner',
  template: `
    <div *ngIf="loading" class="loading-spinner">
      <mat-spinner></mat-spinner>
      <p>{{message}}</p>
    </div>
  `
})
export class LoadingSpinnerComponent {
  @Input() loading = false;
  @Input() message = 'Loading...';
}

// shared/error-message.component.ts
@Component({
  selector: 'app-error-message',
  template: `
    <div *ngIf="error" class="error-message">
      <mat-icon>error</mat-icon>
      <p>{{error}}</p>
      <button mat-button (click)="onRetry.emit()">Retry</button>
    </div>
  `
})
export class ErrorMessageComponent {
  @Input() error: string | null = null;
  @Output() onRetry = new EventEmitter<void>();
}

// Usage in components
@Component({
  template: `
    <app-loading-spinner [loading]="loading" message="Loading packages..."></app-loading-spinner>
    <app-error-message [error]="error" (onRetry)="loadPackages()"></app-error-message>
    <div *ngIf="!loading && !error">
      <!-- Package list content -->
    </div>
  `
})
export class PackageListComponent {
  loading = false;
  error: string | null = null;
  // ...
}
```

## Database Query Optimization

### Before: Inefficient Queries
```javascript
// BEFORE: Multiple queries, no indexing
app.get('/api/packages', async (req, res) => {
  try {
    // Fetch all packages
    const packages = await Package.find();
    
    // For each package, fetch related bookings (N+1 problem)
    const packagesWithBookings = await Promise.all(
      packages.map(async (pkg) => {
        const bookings = await Booking.find({ package: pkg._id });
        return {
          ...pkg.toObject(),
          bookingCount: bookings.length
        };
      })
    );
    
    res.json(packagesWithBookings);
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
});
```

### After: Optimized Queries with Indexing
```javascript
// AFTER: Single query with aggregation, proper indexing
// First, ensure indexes are created in the model
const PackageSchema = new Schema({
  // ... fields
}, { timestamps: true });

// Create indexes for frequently queried fields
PackageSchema.index({ status: 1 });
PackageSchema.index({ location: 1 });
PackageSchema.index({ price: 1 });
PackageSchema.index({ createdAt: -1 });

// Optimized route handler
app.get('/api/packages', async (req, res) => {
  try {
    const { status, location, minPrice, maxPrice, page = 1, limit = 10 } = req.query;
    
    // Build query
    const query = {};
    if (status) query.status = status;
    if (location) query.location = { $regex: location, $options: 'i' };
    if (minPrice || maxPrice) {
      query.price = {};
      if (minPrice) query.price.$gte = Number(minPrice);
      if (maxPrice) query.price.$lte = Number(maxPrice);
    }

    // Use aggregation for efficient data retrieval
    const packages = await Package.aggregate([
      { $match: query },
      {
        $lookup: {
          from: 'bookings',
          localField: '_id',
          foreignField: 'package',
          as: 'bookings'
        }
      },
      {
        $addFields: {
          bookingCount: { $size: '$bookings' }
        }
      },
      {
        $project: {
          bookings: 0 // Exclude bookings array from response
        }
      },
      { $sort: { createdAt: -1 } },
      { $skip: (page - 1) * limit },
      { $limit: Number(limit) }
    ]);

    // Get total count for pagination
    const total = await Package.countDocuments(query);

    res.json({
      success: true,
      data: packages,
      pagination: {
        page: Number(page),
        limit: Number(limit),
        total,
        pages: Math.ceil(total / limit)
      }
    });
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
});
```

### Using Lean Queries for Performance
```javascript
// Use lean() for read-only operations (faster, returns plain objects)
app.get('/api/packages', async (req, res) => {
  try {
    const packages = await Package.find({ status: 'active' })
      .select('name location price duration images') // Only select needed fields
      .sort({ createdAt: -1 })
      .limit(20)
      .lean(); // Returns plain JavaScript objects (faster)

    res.json({
      success: true,
      data: packages
    });
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
});
```

## Code Organization Refactoring

### Before: Monolithic Controller
```javascript
// BEFORE: Everything in one file
app.post('/api/packages', async (req, res) => {
  // Validation
  if (!req.body.name) {
    return res.status(400).json({ error: 'Name is required' });
  }
  // ... more validation

  // Business logic
  const package = new Package(req.body);
  await package.save();

  // Response
  res.json(package);
});
```

### After: Separated Concerns
```javascript
// middleware/validation.middleware.js
const { body, validationResult } = require('express-validator');

const validatePackage = [
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
    .withMessage('Location is required')
];

// controllers/packages.controller.js
const Package = require('../models/Package');

exports.createPackage = async (req, res, next) => {
  try {
    const package = await Package.create(req.body);
    res.status(201).json({
      success: true,
      data: package
    });
  } catch (error) {
    next(error);
  }
};

// routes/packages.routes.js
const express = require('express');
const router = express.Router();
const { createPackage } = require('../controllers/packages.controller');
const { validatePackage } = require('../middleware/validation.middleware');
const { validate } = require('../middleware/validation.middleware');

router.post('/', validatePackage, validate, createPackage);

// app.js
app.use('/api/packages', require('./routes/packages.routes'));
```

## Frontend State Management

### Before: Props Drilling
```typescript
// BEFORE: Passing data through multiple components
@Component({
  selector: 'app-parent',
  template: `
    <app-child [data]="data" [onUpdate]="handleUpdate"></app-child>
  `
})
export class ParentComponent {
  data: any;
  handleUpdate(data: any) { /* ... */ }
}

@Component({
  selector: 'app-child',
  template: `
    <app-grandchild [data]="data" [onUpdate]="onUpdate"></app-grandchild>
  `
})
export class ChildComponent {
  @Input() data: any;
  @Input() onUpdate: (data: any) => void;
}

@Component({
  selector: 'app-grandchild',
  template: `<!-- uses data and onUpdate -->`
})
export class GrandChildComponent {
  @Input() data: any;
  @Input() onUpdate: (data: any) => void;
}
```

### After: Service-Based State Management
```typescript
// services/package-state.service.ts
@Injectable({ providedIn: 'root' })
export class PackageStateService {
  private packagesSubject = new BehaviorSubject<Package[]>([]);
  public packages$ = this.packagesSubject.asObservable();

  private loadingSubject = new BehaviorSubject<boolean>(false);
  public loading$ = this.loadingSubject.asObservable();

  constructor(private packageService: PackageService) { }

  loadPackages(): void {
    this.loadingSubject.next(true);
    this.packageService.getPackages().subscribe({
      next: (packages) => {
        this.packagesSubject.next(packages);
        this.loadingSubject.next(false);
      },
      error: (error) => {
        this.loadingSubject.next(false);
        console.error(error);
      }
    });
  }

  addPackage(package: Package): void {
    const current = this.packagesSubject.value;
    this.packagesSubject.next([...current, package]);
  }

  updatePackage(id: string, updates: Partial<Package>): void {
    const current = this.packagesSubject.value;
    const updated = current.map(pkg =>
      pkg._id === id ? { ...pkg, ...updates } : pkg
    );
    this.packagesSubject.next(updated);
  }

  getPackages(): Package[] {
    return this.packagesSubject.value;
  }
}

// Components can now directly use the service
@Component({
  selector: 'app-package-list',
  template: `<!-- ... -->`
})
export class PackageListComponent {
  packages$ = this.stateService.packages$;
  loading$ = this.stateService.loading$;

  constructor(private stateService: PackageStateService) {
    this.stateService.loadPackages();
  }
}
```

## API Response Optimization

### Before: Sending Unnecessary Data
```javascript
// BEFORE: Sending entire document with all fields
app.get('/api/packages', async (req, res) => {
  const packages = await Package.find();
  res.json(packages); // Sends all fields including internal ones
});
```

### After: Selective Field Projection
```javascript
// AFTER: Only send necessary fields
app.get('/api/packages', async (req, res) => {
  const packages = await Package.find()
    .select('name location price duration images status') // Only selected fields
    .lean();

  res.json({
    success: true,
    data: packages
  });
});

// Or use transformation
app.get('/api/packages', async (req, res) => {
  const packages = await Package.find().lean();
  
  const transformed = packages.map(pkg => ({
    id: pkg._id.toString(),
    name: pkg.name,
    location: pkg.location,
    price: pkg.price,
    duration: pkg.duration,
    image: pkg.images[0] || null, // Only first image
    status: pkg.status
    // Exclude: description, itinerary, createdAt, updatedAt, etc.
  }));

  res.json({
    success: true,
    data: transformed
  });
});
```

## Caching Strategies

### Backend Caching
```javascript
// utils/cache.js
const NodeCache = require('node-cache');
const cache = new NodeCache({ stdTTL: 600 }); // 10 minutes

const getCachedData = async (key, fetchFunction) => {
  const cached = cache.get(key);
  if (cached) {
    return cached;
  }

  const data = await fetchFunction();
  cache.set(key, data);
  return data;
};

// Usage in route
app.get('/api/packages', async (req, res) => {
  try {
    const packages = await getCachedData('packages', async () => {
      return await Package.find({ status: 'active' }).lean();
    });

    res.json({
      success: true,
      data: packages
    });
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
});
```

### Frontend Caching
```typescript
// services/cache.service.ts
@Injectable({ providedIn: 'root' })
export class CacheService {
  private cache = new Map<string, { data: any; timestamp: number }>();
  private TTL = 5 * 60 * 1000; // 5 minutes

  get<T>(key: string): T | null {
    const cached = this.cache.get(key);
    if (!cached) return null;

    if (Date.now() - cached.timestamp > this.TTL) {
      this.cache.delete(key);
      return null;
    }

    return cached.data as T;
  }

  set(key: string, data: any): void {
    this.cache.set(key, {
      data,
      timestamp: Date.now()
    });
  }

  clear(): void {
    this.cache.clear();
  }
}

// Usage in service
@Injectable({ providedIn: 'root' })
export class PackageService {
  constructor(
    private http: HttpClient,
    private cache: CacheService
  ) { }

  getPackages(): Observable<Package[]> {
    const cached = this.cache.get<Package[]>('packages');
    if (cached) {
      return of(cached);
    }

    return this.http.get<{ success: boolean; data: Package[] }>('/api/packages')
      .pipe(
        map(response => response.data),
        tap(data => this.cache.set('packages', data))
      );
  }
}
```

## Performance Monitoring

### Backend Performance Logging
```javascript
// middleware/performance.middleware.js
const performanceMonitor = (req, res, next) => {
  const start = Date.now();

  res.on('finish', () => {
    const duration = Date.now() - start;
    console.log(`${req.method} ${req.path} - ${duration}ms`);

    // Log slow queries
    if (duration > 1000) {
      console.warn(`Slow request detected: ${req.method} ${req.path} took ${duration}ms`);
    }
  });

  next();
};

app.use(performanceMonitor);
```

### Frontend Performance Monitoring
```typescript
// utils/performance.ts
export class PerformanceMonitor {
  static startMeasure(label: string): void {
    performance.mark(`${label}-start`);
  }

  static endMeasure(label: string): number {
    performance.mark(`${label}-end`);
    performance.measure(label, `${label}-start`, `${label}-end`);
    const measure = performance.getEntriesByName(label)[0];
    return measure.duration;
  }
}

// Usage
PerformanceMonitor.startMeasure('loadPackages');
this.packageService.getPackages().subscribe({
  next: () => {
    const duration = PerformanceMonitor.endMeasure('loadPackages');
    console.log(`Packages loaded in ${duration}ms`);
  }
});
```

## Best Practices Summary

1. **DRY Principle**: Don't Repeat Yourself - extract common code
2. **Single Responsibility**: Each function/class should do one thing
3. **Separation of Concerns**: Separate validation, business logic, and data access
4. **Database Indexing**: Create indexes on frequently queried fields
5. **Query Optimization**: Use aggregation, lean queries, and projection
6. **Caching**: Cache frequently accessed data
7. **Error Handling**: Centralize error handling
8. **Type Safety**: Use TypeScript for better code quality
9. **Code Reusability**: Create reusable components and services
10. **Performance Monitoring**: Track and optimize slow operations

This guide provides comprehensive refactoring and optimization strategies to improve your full stack application's code quality, performance, and maintainability.


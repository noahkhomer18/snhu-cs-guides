# Angular SPA for Admin Panel - Complete Guide

## Overview
This guide covers building a Single Page Application (SPA) using Angular for the admin side of your full stack application. The admin panel allows secure login and content management with reusable components.

## Project Setup

### Creating Angular Admin Application
```bash
# Install Angular CLI globally
npm install -g @angular/cli

# Create new Angular project
ng new admin-panel
cd admin-panel

# Install additional dependencies
npm install @angular/material @angular/cdk
npm install @angular/animations
npm install rxjs
```

### Project Structure
```
admin-panel/
├── src/
│   ├── app/
│   │   ├── components/
│   │   │   ├── login/
│   │   │   ├── dashboard/
│   │   │   ├── package-list/
│   │   │   ├── package-form/
│   │   │   ├── navigation/
│   │   │   └── shared/
│   │   ├── services/
│   │   │   ├── auth.service.ts
│   │   │   ├── package.service.ts
│   │   │   └── api.service.ts
│   │   ├── guards/
│   │   │   └── auth.guard.ts
│   │   ├── interceptors/
│   │   │   └── auth.interceptor.ts
│   │   ├── models/
│   │   │   ├── package.model.ts
│   │   │   └── user.model.ts
│   │   ├── app-routing.module.ts
│   │   ├── app.module.ts
│   │   └── app.component.ts
│   ├── assets/
│   └── environments/
└── angular.json
```

## Core Module Setup

### App Module (app.module.ts)
```typescript
import { NgModule } from '@angular/core';
import { BrowserModule } from '@angular/platform-browser';
import { BrowserAnimationsModule } from '@angular/platform-browser/animations';
import { HttpClientModule, HTTP_INTERCEPTORS } from '@angular/common/http';
import { FormsModule, ReactiveFormsModule } from '@angular/forms';
import { AppRoutingModule } from './app-routing.module';

// Angular Material
import { MatToolbarModule } from '@angular/material/toolbar';
import { MatButtonModule } from '@angular/material/button';
import { MatCardModule } from '@angular/material/card';
import { MatFormFieldModule } from '@angular/material/form-field';
import { MatInputModule } from '@angular/material/input';
import { MatTableModule } from '@angular/material/table';
import { MatDialogModule } from '@angular/material/dialog';
import { MatSnackBarModule } from '@angular/material/snack-bar';

import { AppComponent } from './app.component';
import { LoginComponent } from './components/login/login.component';
import { DashboardComponent } from './components/dashboard/dashboard.component';
import { PackageListComponent } from './components/package-list/package-list.component';
import { PackageFormComponent } from './components/package-form/package-form.component';
import { NavigationComponent } from './components/navigation/navigation.component';

import { AuthService } from './services/auth.service';
import { PackageService } from './services/package.service';
import { AuthGuard } from './guards/auth.guard';
import { AuthInterceptor } from './interceptors/auth.interceptor';

@NgModule({
  declarations: [
    AppComponent,
    LoginComponent,
    DashboardComponent,
    PackageListComponent,
    PackageFormComponent,
    NavigationComponent
  ],
  imports: [
    BrowserModule,
    BrowserAnimationsModule,
    AppRoutingModule,
    HttpClientModule,
    FormsModule,
    ReactiveFormsModule,
    MatToolbarModule,
    MatButtonModule,
    MatCardModule,
    MatFormFieldModule,
    MatInputModule,
    MatTableModule,
    MatDialogModule,
    MatSnackBarModule
  ],
  providers: [
    AuthService,
    PackageService,
    AuthGuard,
    {
      provide: HTTP_INTERCEPTORS,
      useClass: AuthInterceptor,
      multi: true
    }
  ],
  bootstrap: [AppComponent]
})
export class AppModule { }
```

## Routing Configuration

### App Routing (app-routing.module.ts)
```typescript
import { NgModule } from '@angular/core';
import { RouterModule, Routes } from '@angular/router';
import { LoginComponent } from './components/login/login.component';
import { DashboardComponent } from './components/dashboard/dashboard.component';
import { PackageListComponent } from './components/package-list/package-list.component';
import { PackageFormComponent } from './components/package-form/package-form.component';
import { AuthGuard } from './guards/auth.guard';

const routes: Routes = [
  { path: 'login', component: LoginComponent },
  { 
    path: 'dashboard', 
    component: DashboardComponent,
    canActivate: [AuthGuard]
  },
  { 
    path: 'packages', 
    component: PackageListComponent,
    canActivate: [AuthGuard]
  },
  { 
    path: 'packages/new', 
    component: PackageFormComponent,
    canActivate: [AuthGuard]
  },
  { 
    path: 'packages/edit/:id', 
    component: PackageFormComponent,
    canActivate: [AuthGuard]
  },
  { path: '', redirectTo: '/dashboard', pathMatch: 'full' },
  { path: '**', redirectTo: '/dashboard' }
];

@NgModule({
  imports: [RouterModule.forRoot(routes)],
  exports: [RouterModule]
})
export class AppRoutingModule { }
```

## Models

### Package Model (models/package.model.ts)
```typescript
export interface Package {
  _id?: string;
  name: string;
  location: string;
  description: string;
  price: number;
  duration: number;
  images: string[];
  itinerary: string[];
  status: 'active' | 'inactive';
  createdAt?: Date;
  updatedAt?: Date;
}
```

### User Model (models/user.model.ts)
```typescript
export interface User {
  _id?: string;
  username: string;
  email: string;
  role: 'admin' | 'user';
}

export interface LoginResponse {
  token: string;
  user: User;
}
```

## Services

### API Service (services/api.service.ts)
```typescript
import { Injectable } from '@angular/core';
import { HttpClient } from '@angular/common/http';
import { Observable } from 'rxjs';
import { environment } from '../../environments/environment';

@Injectable({
  providedIn: 'root'
})
export class ApiService {
  private apiUrl = environment.apiUrl;

  constructor(private http: HttpClient) { }

  get<T>(endpoint: string): Observable<T> {
    return this.http.get<T>(`${this.apiUrl}${endpoint}`);
  }

  post<T>(endpoint: string, data: any): Observable<T> {
    return this.http.post<T>(`${this.apiUrl}${endpoint}`, data);
  }

  put<T>(endpoint: string, data: any): Observable<T> {
    return this.http.put<T>(`${this.apiUrl}${endpoint}`, data);
  }

  delete<T>(endpoint: string): Observable<T> {
    return this.http.delete<T>(`${this.apiUrl}${endpoint}`);
  }
}
```

### Auth Service (services/auth.service.ts)
```typescript
import { Injectable } from '@angular/core';
import { Router } from '@angular/router';
import { BehaviorSubject, Observable } from 'rxjs';
import { ApiService } from './api.service';
import { User, LoginResponse } from '../models/user.model';

@Injectable({
  providedIn: 'root'
})
export class AuthService {
  private currentUserSubject: BehaviorSubject<User | null>;
  public currentUser$: Observable<User | null>;
  private tokenKey = 'auth_token';

  constructor(
    private apiService: ApiService,
    private router: Router
  ) {
    const user = this.getStoredUser();
    this.currentUserSubject = new BehaviorSubject<User | null>(user);
    this.currentUser$ = this.currentUserSubject.asObservable();
  }

  login(username: string, password: string): Observable<LoginResponse> {
    return this.apiService.post<LoginResponse>('/auth/login', {
      username,
      password
    });
  }

  logout(): void {
    localStorage.removeItem(this.tokenKey);
    localStorage.removeItem('current_user');
    this.currentUserSubject.next(null);
    this.router.navigate(['/login']);
  }

  getToken(): string | null {
    return localStorage.getItem(this.tokenKey);
  }

  isAuthenticated(): boolean {
    return !!this.getToken();
  }

  setAuthData(token: string, user: User): void {
    localStorage.setItem(this.tokenKey, token);
    localStorage.setItem('current_user', JSON.stringify(user));
    this.currentUserSubject.next(user);
  }

  private getStoredUser(): User | null {
    const userStr = localStorage.getItem('current_user');
    return userStr ? JSON.parse(userStr) : null;
  }

  getCurrentUser(): User | null {
    return this.currentUserSubject.value;
  }
}
```

### Package Service (services/package.service.ts)
```typescript
import { Injectable } from '@angular/core';
import { Observable } from 'rxjs';
import { ApiService } from './api.service';
import { Package } from '../models/package.model';

@Injectable({
  providedIn: 'root'
})
export class PackageService {
  constructor(private apiService: ApiService) { }

  getPackages(): Observable<Package[]> {
    return this.apiService.get<Package[]>('/packages');
  }

  getPackage(id: string): Observable<Package> {
    return this.apiService.get<Package>(`/packages/${id}`);
  }

  createPackage(packageData: Package): Observable<Package> {
    return this.apiService.post<Package>('/packages', packageData);
  }

  updatePackage(id: string, packageData: Partial<Package>): Observable<Package> {
    return this.apiService.put<Package>(`/packages/${id}`, packageData);
  }

  deletePackage(id: string): Observable<void> {
    return this.apiService.delete<void>(`/packages/${id}`);
  }
}
```

## Guards

### Auth Guard (guards/auth.guard.ts)
```typescript
import { Injectable } from '@angular/core';
import { Router, CanActivate, ActivatedRouteSnapshot, RouterStateSnapshot } from '@angular/router';
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

    this.router.navigate(['/login'], {
      queryParams: { returnUrl: state.url }
    });
    return false;
  }
}
```

## Interceptors

### Auth Interceptor (interceptors/auth.interceptor.ts)
```typescript
import { Injectable } from '@angular/core';
import { HttpInterceptor, HttpRequest, HttpHandler, HttpEvent } from '@angular/common/http';
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

## Reusable Components

### Navigation Component (components/navigation/navigation.component.ts)
```typescript
import { Component, OnInit } from '@angular/core';
import { Router } from '@angular/router';
import { AuthService } from '../../services/auth.service';
import { User } from '../../models/user.model';

@Component({
  selector: 'app-navigation',
  templateUrl: './navigation.component.html',
  styleUrls: ['./navigation.component.css']
})
export class NavigationComponent implements OnInit {
  currentUser: User | null = null;

  constructor(
    private authService: AuthService,
    private router: Router
  ) { }

  ngOnInit(): void {
    this.authService.currentUser$.subscribe(user => {
      this.currentUser = user;
    });
  }

  logout(): void {
    this.authService.logout();
  }
}
```

### Navigation Template (components/navigation/navigation.component.html)
```html
<mat-toolbar color="primary">
  <span>Admin Panel</span>
  <span class="spacer"></span>
  <nav>
    <a mat-button routerLink="/dashboard" routerLinkActive="active">Dashboard</a>
    <a mat-button routerLink="/packages" routerLinkActive="active">Packages</a>
  </nav>
  <span class="spacer"></span>
  <span *ngIf="currentUser">{{currentUser.username}}</span>
  <button mat-button (click)="logout()">Logout</button>
</mat-toolbar>
```

### Login Component (components/login/login.component.ts)
```typescript
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
    this.returnUrl = this.route.snapshot.queryParams['returnUrl'] || '/dashboard';
    
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
          this.authService.setAuthData(response.token, response.user);
          this.router.navigate([this.returnUrl]);
          this.loading = false;
        },
        error: (error) => {
          this.snackBar.open('Login failed. Please check your credentials.', 'Close', {
            duration: 3000
          });
          this.loading = false;
        }
      });
    }
  }
}
```

### Login Template (components/login/login.component.html)
```html
<div class="login-container">
  <mat-card class="login-card">
    <mat-card-header>
      <mat-card-title>Admin Login</mat-card-title>
    </mat-card-header>
    <mat-card-content>
      <form [formGroup]="loginForm" (ngSubmit)="onSubmit()">
        <mat-form-field appearance="outline" class="full-width">
          <mat-label>Username</mat-label>
          <input matInput formControlName="username" required>
          <mat-error *ngIf="loginForm.get('username')?.hasError('required')">
            Username is required
          </mat-error>
        </mat-form-field>

        <mat-form-field appearance="outline" class="full-width">
          <mat-label>Password</mat-label>
          <input matInput type="password" formControlName="password" required>
          <mat-error *ngIf="loginForm.get('password')?.hasError('required')">
            Password is required
          </mat-error>
        </mat-form-field>

        <button 
          mat-raised-button 
          color="primary" 
          type="submit" 
          class="full-width"
          [disabled]="loginForm.invalid || loading">
          {{ loading ? 'Logging in...' : 'Login' }}
        </button>
      </form>
    </mat-card-content>
  </mat-card>
</div>
```

### Package List Component (components/package-list/package-list.component.ts)
```typescript
import { Component, OnInit } from '@angular/core';
import { Router } from '@angular/router';
import { PackageService } from '../../services/package.service';
import { Package } from '../../models/package.model';
import { MatSnackBar } from '@angular/material/snack-bar';

@Component({
  selector: 'app-package-list',
  templateUrl: './package-list.component.html',
  styleUrls: ['./package-list.component.css']
})
export class PackageListComponent implements OnInit {
  packages: Package[] = [];
  displayedColumns: string[] = ['name', 'location', 'price', 'duration', 'status', 'actions'];
  loading = false;

  constructor(
    private packageService: PackageService,
    private router: Router,
    private snackBar: MatSnackBar
  ) { }

  ngOnInit(): void {
    this.loadPackages();
  }

  loadPackages(): void {
    this.loading = true;
    this.packageService.getPackages().subscribe({
      next: (packages) => {
        this.packages = packages;
        this.loading = false;
      },
      error: (error) => {
        this.snackBar.open('Error loading packages', 'Close', { duration: 3000 });
        this.loading = false;
      }
    });
  }

  editPackage(id: string): void {
    this.router.navigate(['/packages/edit', id]);
  }

  deletePackage(id: string): void {
    if (confirm('Are you sure you want to delete this package?')) {
      this.packageService.deletePackage(id).subscribe({
        next: () => {
          this.snackBar.open('Package deleted successfully', 'Close', { duration: 3000 });
          this.loadPackages();
        },
        error: (error) => {
          this.snackBar.open('Error deleting package', 'Close', { duration: 3000 });
        }
      });
    }
  }

  createNew(): void {
    this.router.navigate(['/packages/new']);
  }
}
```

### Package List Template (components/package-list/package-list.component.html)
```html
<div class="package-list-container">
  <div class="header">
    <h1>Travel Packages</h1>
    <button mat-raised-button color="primary" (click)="createNew()">
      Add New Package
    </button>
  </div>

  <div *ngIf="loading" class="loading">Loading packages...</div>

  <table mat-table [dataSource]="packages" class="packages-table">
    <ng-container matColumnDef="name">
      <th mat-header-cell *matHeaderCellDef>Name</th>
      <td mat-cell *matCellDef="let package">{{ package.name }}</td>
    </ng-container>

    <ng-container matColumnDef="location">
      <th mat-header-cell *matHeaderCellDef>Location</th>
      <td mat-cell *matCellDef="let package">{{ package.location }}</td>
    </ng-container>

    <ng-container matColumnDef="price">
      <th mat-header-cell *matHeaderCellDef>Price</th>
      <td mat-cell *matCellDef="let package">${{ package.price }}</td>
    </ng-container>

    <ng-container matColumnDef="duration">
      <th mat-header-cell *matHeaderCellDef>Duration</th>
      <td mat-cell *matCellDef="let package">{{ package.duration }} days</td>
    </ng-container>

    <ng-container matColumnDef="status">
      <th mat-header-cell *matHeaderCellDef>Status</th>
      <td mat-cell *matCellDef="let package">
        <span [class]="'status-' + package.status">{{ package.status }}</span>
      </td>
    </ng-container>

    <ng-container matColumnDef="actions">
      <th mat-header-cell *matHeaderCellDef>Actions</th>
      <td mat-cell *matCellDef="let package">
        <button mat-icon-button (click)="editPackage(package._id!)">
          <mat-icon>edit</mat-icon>
        </button>
        <button mat-icon-button color="warn" (click)="deletePackage(package._id!)">
          <mat-icon>delete</mat-icon>
        </button>
      </td>
    </ng-container>

    <tr mat-header-row *matHeaderRowDef="displayedColumns"></tr>
    <tr mat-row *matRowDef="let row; columns: displayedColumns"></tr>
  </table>
</div>
```

### Package Form Component (components/package-form/package-form.component.ts)
```typescript
import { Component, OnInit } from '@angular/core';
import { FormBuilder, FormGroup, Validators } from '@angular/forms';
import { ActivatedRoute, Router } from '@angular/router';
import { PackageService } from '../../services/package.service';
import { Package } from '../../models/package.model';
import { MatSnackBar } from '@angular/material/snack-bar';

@Component({
  selector: 'app-package-form',
  templateUrl: './package-form.component.html',
  styleUrls: ['./package-form.component.css']
})
export class PackageFormComponent implements OnInit {
  packageForm: FormGroup;
  packageId: string | null = null;
  isEditMode = false;
  loading = false;

  constructor(
    private fb: FormBuilder,
    private route: ActivatedRoute,
    private router: Router,
    private packageService: PackageService,
    private snackBar: MatSnackBar
  ) {
    this.packageForm = this.fb.group({
      name: ['', [Validators.required]],
      location: ['', [Validators.required]],
      description: ['', [Validators.required]],
      price: [0, [Validators.required, Validators.min(0)]],
      duration: [0, [Validators.required, Validators.min(1)]],
      images: [''],
      itinerary: [''],
      status: ['active', [Validators.required]]
    });
  }

  ngOnInit(): void {
    this.packageId = this.route.snapshot.paramMap.get('id');
    this.isEditMode = !!this.packageId;

    if (this.isEditMode && this.packageId) {
      this.loadPackage(this.packageId);
    }
  }

  loadPackage(id: string): void {
    this.loading = true;
    this.packageService.getPackage(id).subscribe({
      next: (pkg) => {
        this.packageForm.patchValue({
          name: pkg.name,
          location: pkg.location,
          description: pkg.description,
          price: pkg.price,
          duration: pkg.duration,
          images: pkg.images.join(','),
          itinerary: pkg.itinerary.join('\n'),
          status: pkg.status
        });
        this.loading = false;
      },
      error: (error) => {
        this.snackBar.open('Error loading package', 'Close', { duration: 3000 });
        this.loading = false;
      }
    });
  }

  onSubmit(): void {
    if (this.packageForm.valid) {
      this.loading = true;
      const formValue = this.packageForm.value;
      const packageData: Package = {
        name: formValue.name,
        location: formValue.location,
        description: formValue.description,
        price: formValue.price,
        duration: formValue.duration,
        images: formValue.images.split(',').map((img: string) => img.trim()),
        itinerary: formValue.itinerary.split('\n').filter((item: string) => item.trim()),
        status: formValue.status
      };

      const operation = this.isEditMode && this.packageId
        ? this.packageService.updatePackage(this.packageId, packageData)
        : this.packageService.createPackage(packageData);

      operation.subscribe({
        next: () => {
          this.snackBar.open(
            `Package ${this.isEditMode ? 'updated' : 'created'} successfully`,
            'Close',
            { duration: 3000 }
          );
          this.router.navigate(['/packages']);
        },
        error: (error) => {
          this.snackBar.open('Error saving package', 'Close', { duration: 3000 });
          this.loading = false;
        }
      });
    }
  }
}
```

## Environment Configuration

### Environment Files (environments/environment.ts)
```typescript
export const environment = {
  production: false,
  apiUrl: 'http://localhost:3000/api'
};
```

### Production Environment (environments/environment.prod.ts)
```typescript
export const environment = {
  production: true,
  apiUrl: 'https://your-api-domain.com/api'
};
```

## Best Practices

1. **Component Reusability**: Create shared components for common UI elements
2. **Service Layer**: Keep business logic in services, not components
3. **Type Safety**: Use TypeScript interfaces for all data models
4. **Error Handling**: Implement proper error handling with user-friendly messages
5. **Loading States**: Show loading indicators during API calls
6. **Form Validation**: Use reactive forms with validators
7. **Route Guards**: Protect routes that require authentication
8. **Interceptors**: Handle authentication tokens automatically

This Angular SPA structure provides a solid foundation for your admin panel with reusable components, secure authentication, and efficient data management.


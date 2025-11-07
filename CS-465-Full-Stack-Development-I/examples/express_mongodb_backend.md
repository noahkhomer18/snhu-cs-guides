# Express.js Backend with MongoDB - Complete Implementation Guide

## Overview
This guide covers building a robust Express.js backend with MongoDB integration, including API endpoints, database models, authentication, and optimization techniques.

## Project Setup

### Initial Setup
```bash
# Create project directory
mkdir travel-backend
cd travel-backend

# Initialize npm project
npm init -y

# Install dependencies
npm install express mongoose cors dotenv helmet morgan
npm install jsonwebtoken bcryptjs express-validator
npm install -D nodemon typescript @types/express @types/node
npm install -D @types/mongoose @types/jsonwebtoken @types/bcryptjs
npm install -D @types/cors @types/morgan
```

### Project Structure
```
travel-backend/
├── src/
│   ├── config/
│   │   └── database.ts
│   ├── models/
│   │   ├── Package.ts
│   │   ├── User.ts
│   │   └── Booking.ts
│   ├── routes/
│   │   ├── auth.routes.ts
│   │   ├── packages.routes.ts
│   │   └── bookings.routes.ts
│   ├── controllers/
│   │   ├── auth.controller.ts
│   │   ├── packages.controller.ts
│   │   └── bookings.controller.ts
│   ├── middleware/
│   │   ├── auth.middleware.ts
│   │   ├── error.middleware.ts
│   │   └── validation.middleware.ts
│   ├── utils/
│   │   └── helpers.ts
│   └── app.ts
├── .env
├── .gitignore
├── package.json
└── tsconfig.json
```

## Database Configuration

### MongoDB Connection (src/config/database.ts)
```typescript
import mongoose from 'mongoose';

const connectDB = async (): Promise<void> => {
  try {
    const conn = await mongoose.connect(process.env.MONGODB_URI || 'mongodb://localhost:27017/travel', {
      // Remove deprecated options in newer versions
    });

    console.log(`MongoDB Connected: ${conn.connection.host}`);
  } catch (error) {
    console.error('MongoDB connection error:', error);
    process.exit(1);
  }
};

export default connectDB;
```

## Mongoose Models

### Package Model (src/models/Package.ts)
```typescript
import mongoose, { Schema, Document } from 'mongoose';

export interface IPackage extends Document {
  name: string;
  location: string;
  description: string;
  price: number;
  duration: number;
  images: string[];
  itinerary: string[];
  status: 'active' | 'inactive';
  createdAt: Date;
  updatedAt: Date;
}

const PackageSchema: Schema = new Schema({
  name: {
    type: String,
    required: [true, 'Package name is required'],
    trim: true,
    maxlength: [100, 'Name cannot exceed 100 characters']
  },
  location: {
    type: String,
    required: [true, 'Location is required'],
    trim: true
  },
  description: {
    type: String,
    required: [true, 'Description is required'],
    trim: true
  },
  price: {
    type: Number,
    required: [true, 'Price is required'],
    min: [0, 'Price cannot be negative']
  },
  duration: {
    type: Number,
    required: [true, 'Duration is required'],
    min: [1, 'Duration must be at least 1 day']
  },
  images: [{
    type: String,
    trim: true
  }],
  itinerary: [{
    type: String,
    trim: true
  }],
  status: {
    type: String,
    enum: ['active', 'inactive'],
    default: 'active'
  }
}, {
  timestamps: true
});

// Create indexes for better query performance
PackageSchema.index({ name: 1 });
PackageSchema.index({ location: 1 });
PackageSchema.index({ status: 1 });
PackageSchema.index({ price: 1 });

export default mongoose.model<IPackage>('Package', PackageSchema);
```

### User Model (src/models/User.ts)
```typescript
import mongoose, { Schema, Document } from 'mongoose';
import bcrypt from 'bcryptjs';

export interface IUser extends Document {
  username: string;
  email: string;
  password: string;
  role: 'admin' | 'user';
  comparePassword(candidatePassword: string): Promise<boolean>;
}

const UserSchema: Schema = new Schema({
  username: {
    type: String,
    required: [true, 'Username is required'],
    unique: true,
    trim: true,
    minlength: [3, 'Username must be at least 3 characters'],
    maxlength: [30, 'Username cannot exceed 30 characters']
  },
  email: {
    type: String,
    required: [true, 'Email is required'],
    unique: true,
    lowercase: true,
    trim: true,
    match: [/^\S+@\S+\.\S+$/, 'Please provide a valid email']
  },
  password: {
    type: String,
    required: [true, 'Password is required'],
    minlength: [6, 'Password must be at least 6 characters'],
    select: false // Don't return password by default
  },
  role: {
    type: String,
    enum: ['admin', 'user'],
    default: 'user'
  }
}, {
  timestamps: true
});

// Hash password before saving
UserSchema.pre('save', async function(next) {
  if (!this.isModified('password')) {
    return next();
  }
  
  try {
    const salt = await bcrypt.genSalt(10);
    this.password = await bcrypt.hash(this.password, salt);
    next();
  } catch (error: any) {
    next(error);
  }
});

// Method to compare passwords
UserSchema.methods.comparePassword = async function(candidatePassword: string): Promise<boolean> {
  return bcrypt.compare(candidatePassword, this.password);
};

// Create indexes
UserSchema.index({ username: 1 });
UserSchema.index({ email: 1 });

export default mongoose.model<IUser>('User', UserSchema);
```

### Booking Model (src/models/Booking.ts)
```typescript
import mongoose, { Schema, Document, Types } from 'mongoose';

export interface IBooking extends Document {
  user: Types.ObjectId;
  package: Types.ObjectId;
  bookingDate: Date;
  travelers: number;
  totalPrice: number;
  status: 'pending' | 'confirmed' | 'cancelled';
  createdAt: Date;
  updatedAt: Date;
}

const BookingSchema: Schema = new Schema({
  user: {
    type: Schema.Types.ObjectId,
    ref: 'User',
    required: true
  },
  package: {
    type: Schema.Types.ObjectId,
    ref: 'Package',
    required: true
  },
  bookingDate: {
    type: Date,
    required: true,
    default: Date.now
  },
  travelers: {
    type: Number,
    required: true,
    min: [1, 'Must have at least 1 traveler']
  },
  totalPrice: {
    type: Number,
    required: true
  },
  status: {
    type: String,
    enum: ['pending', 'confirmed', 'cancelled'],
    default: 'pending'
  }
}, {
  timestamps: true
});

// Indexes for efficient queries
BookingSchema.index({ user: 1 });
BookingSchema.index({ package: 1 });
BookingSchema.index({ bookingDate: 1 });
BookingSchema.index({ status: 1 });

export default mongoose.model<IBooking>('Booking', BookingSchema);
```

## Middleware

### Authentication Middleware (src/middleware/auth.middleware.ts)
```typescript
import { Request, Response, NextFunction } from 'express';
import jwt from 'jsonwebtoken';
import User, { IUser } from '../models/User';

export interface AuthRequest extends Request {
  user?: IUser;
}

export const authenticate = async (
  req: AuthRequest,
  res: Response,
  next: NextFunction
): Promise<void> => {
  try {
    const token = req.header('Authorization')?.replace('Bearer ', '');

    if (!token) {
      res.status(401).json({ message: 'No token provided, authorization denied' });
      return;
    }

    const decoded = jwt.verify(token, process.env.JWT_SECRET || 'REPLACE_WITH_STRONG_SECRET') as { id: string };
    const user = await User.findById(decoded.id).select('-password');

    if (!user) {
      res.status(401).json({ message: 'User not found' });
      return;
    }

    req.user = user;
    next();
  } catch (error) {
    res.status(401).json({ message: 'Token is not valid' });
  }
};

export const authorize = (...roles: string[]) => {
  return (req: AuthRequest, res: Response, next: NextFunction): void => {
    if (!req.user) {
      res.status(401).json({ message: 'Not authenticated' });
      return;
    }

    if (!roles.includes(req.user.role)) {
      res.status(403).json({ message: 'Access denied. Insufficient permissions.' });
      return;
    }

    next();
  };
};
```

### Error Middleware (src/middleware/error.middleware.ts)
```typescript
import { Request, Response, NextFunction } from 'express';

export interface AppError extends Error {
  statusCode?: number;
}

export const errorHandler = (
  err: AppError,
  req: Request,
  res: Response,
  next: NextFunction
): void => {
  const statusCode = err.statusCode || 500;
  const message = err.message || 'Internal Server Error';

  res.status(statusCode).json({
    success: false,
    error: message,
    ...(process.env.NODE_ENV === 'development' && { stack: err.stack })
  });
};

export const notFound = (req: Request, res: Response, next: NextFunction): void => {
  const error: AppError = new Error(`Not Found - ${req.originalUrl}`);
  error.statusCode = 404;
  next(error);
};
```

### Validation Middleware (src/middleware/validation.middleware.ts)
```typescript
import { Request, Response, NextFunction } from 'express';
import { validationResult } from 'express-validator';

export const validate = (req: Request, res: Response, next: NextFunction): void => {
  const errors = validationResult(req);
  
  if (!errors.isEmpty()) {
    res.status(400).json({
      success: false,
      errors: errors.array()
    });
    return;
  }
  
  next();
};
```

## Controllers

### Auth Controller (src/controllers/auth.controller.ts)
```typescript
import { Request, Response, NextFunction } from 'express';
import jwt from 'jsonwebtoken';
import User from '../models/User';
import { AppError } from '../middleware/error.middleware';

// Generate JWT Token
const generateToken = (id: string): string => {
  // WARNING: JWT_SECRET should be set in environment variables
  // Never use default values in production
  return jwt.sign({ id }, process.env.JWT_SECRET || 'REPLACE_WITH_STRONG_SECRET', {
    expiresIn: process.env.JWT_EXPIRES_IN || '24h'
  });
};

// Register User
export const register = async (
  req: Request,
  res: Response,
  next: NextFunction
): Promise<void> => {
  try {
    const { username, email, password, role } = req.body;

    // Check if user exists
    const existingUser = await User.findOne({
      $or: [{ email }, { username }]
    });

    if (existingUser) {
      res.status(400).json({
        success: false,
        message: 'User already exists with this email or username'
      });
      return;
    }

    // Create user
    const user = await User.create({
      username,
      email,
      password,
      role: role || 'user'
    });

    const token = generateToken(user._id.toString());

    res.status(201).json({
      success: true,
      token,
      user: {
        _id: user._id,
        username: user.username,
        email: user.email,
        role: user.role
      }
    });
  } catch (error: any) {
    next(error);
  }
};

// Login User
export const login = async (
  req: Request,
  res: Response,
  next: NextFunction
): Promise<void> => {
  try {
    const { username, password } = req.body;

    if (!username || !password) {
      res.status(400).json({
        success: false,
        message: 'Please provide username and password'
      });
      return;
    }

    // Find user and include password
    const user = await User.findOne({ username }).select('+password');

    if (!user || !(await user.comparePassword(password))) {
      res.status(401).json({
        success: false,
        message: 'Invalid credentials'
      });
      return;
    }

    const token = generateToken(user._id.toString());

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
  } catch (error: any) {
    next(error);
  }
};

// Get Current User
export const getMe = async (
  req: Request,
  res: Response,
  next: NextFunction
): Promise<void> => {
  try {
    // This assumes req.user is set by auth middleware
    const user = (req as any).user;
    
    res.json({
      success: true,
      user
    });
  } catch (error: any) {
    next(error);
  }
};
```

### Packages Controller (src/controllers/packages.controller.ts)
```typescript
import { Request, Response, NextFunction } from 'express';
import Package from '../models/Package';
import { AppError } from '../middleware/error.middleware';

// Get All Packages
export const getPackages = async (
  req: Request,
  res: Response,
  next: NextFunction
): Promise<void> => {
  try {
    const { status, location, minPrice, maxPrice, sort } = req.query;

    // Build query
    const query: any = {};
    
    if (status) {
      query.status = status;
    }
    
    if (location) {
      query.location = { $regex: location, $options: 'i' };
    }
    
    if (minPrice || maxPrice) {
      query.price = {};
      if (minPrice) query.price.$gte = Number(minPrice);
      if (maxPrice) query.price.$lte = Number(maxPrice);
    }

    // Build sort
    let sortBy: any = { createdAt: -1 };
    if (sort === 'price-asc') sortBy = { price: 1 };
    if (sort === 'price-desc') sortBy = { price: -1 };
    if (sort === 'name') sortBy = { name: 1 };

    const packages = await Package.find(query)
      .sort(sortBy)
      .limit(Number(req.query.limit) || 100)
      .skip(Number(req.query.skip) || 0);

    res.json({
      success: true,
      count: packages.length,
      data: packages
    });
  } catch (error: any) {
    next(error);
  }
};

// Get Single Package
export const getPackage = async (
  req: Request,
  res: Response,
  next: NextFunction
): Promise<void> => {
  try {
    const package = await Package.findById(req.params.id);

    if (!package) {
      res.status(404).json({
        success: false,
        message: 'Package not found'
      });
      return;
    }

    res.json({
      success: true,
      data: package
    });
  } catch (error: any) {
    next(error);
  }
};

// Create Package (Admin only)
export const createPackage = async (
  req: Request,
  res: Response,
  next: NextFunction
): Promise<void> => {
  try {
    const package = await Package.create(req.body);

    res.status(201).json({
      success: true,
      data: package
    });
  } catch (error: any) {
    next(error);
  }
};

// Update Package (Admin only)
export const updatePackage = async (
  req: Request,
  res: Response,
  next: NextFunction
): Promise<void> => {
  try {
    const package = await Package.findByIdAndUpdate(
      req.params.id,
      req.body,
      {
        new: true,
        runValidators: true
      }
    );

    if (!package) {
      res.status(404).json({
        success: false,
        message: 'Package not found'
      });
      return;
    }

    res.json({
      success: true,
      data: package
    });
  } catch (error: any) {
    next(error);
  }
};

// Delete Package (Admin only)
export const deletePackage = async (
  req: Request,
  res: Response,
  next: NextFunction
): Promise<void> => {
  try {
    const package = await Package.findByIdAndDelete(req.params.id);

    if (!package) {
      res.status(404).json({
        success: false,
        message: 'Package not found'
      });
      return;
    }

    res.json({
      success: true,
      message: 'Package deleted successfully'
    });
  } catch (error: any) {
    next(error);
  }
};
```

## Routes

### Auth Routes (src/routes/auth.routes.ts)
```typescript
import express from 'express';
import { body } from 'express-validator';
import { register, login, getMe } from '../controllers/auth.controller';
import { authenticate } from '../middleware/auth.middleware';
import { validate } from '../middleware/validation.middleware';

const router = express.Router();

router.post(
  '/register',
  [
    body('username')
      .trim()
      .isLength({ min: 3, max: 30 })
      .withMessage('Username must be between 3 and 30 characters'),
    body('email')
      .isEmail()
      .normalizeEmail()
      .withMessage('Please provide a valid email'),
    body('password')
      .isLength({ min: 6 })
      .withMessage('Password must be at least 6 characters')
  ],
  validate,
  register
);

router.post(
  '/login',
  [
    body('username').notEmpty().withMessage('Username is required'),
    body('password').notEmpty().withMessage('Password is required')
  ],
  validate,
  login
);

router.get('/me', authenticate, getMe);

export default router;
```

### Packages Routes (src/routes/packages.routes.ts)
```typescript
import express from 'express';
import { body } from 'express-validator';
import {
  getPackages,
  getPackage,
  createPackage,
  updatePackage,
  deletePackage
} from '../controllers/packages.controller';
import { authenticate, authorize } from '../middleware/auth.middleware';
import { validate } from '../middleware/validation.middleware';

const router = express.Router();

// Public routes
router.get('/', getPackages);
router.get('/:id', getPackage);

// Protected admin routes
router.post(
  '/',
  authenticate,
  authorize('admin'),
  [
    body('name').notEmpty().withMessage('Name is required'),
    body('location').notEmpty().withMessage('Location is required'),
    body('price').isNumeric().withMessage('Price must be a number'),
    body('duration').isInt({ min: 1 }).withMessage('Duration must be at least 1')
  ],
  validate,
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

export default router;
```

## Main Application

### Express App (src/app.ts)
```typescript
import express, { Application } from 'express';
import cors from 'cors';
import helmet from 'helmet';
import morgan from 'morgan';
import dotenv from 'dotenv';
import connectDB from './config/database';
import { errorHandler, notFound } from './middleware/error.middleware';

// Import routes
import authRoutes from './routes/auth.routes';
import packagesRoutes from './routes/packages.routes';

// Load environment variables
dotenv.config();

// Connect to database
connectDB();

// Initialize Express app
const app: Application = express();

// Middleware
app.use(helmet()); // Security headers
app.use(cors()); // Enable CORS
app.use(morgan('dev')); // Logging
app.use(express.json()); // Parse JSON bodies
app.use(express.urlencoded({ extended: true })); // Parse URL-encoded bodies

// Routes
app.use('/api/auth', authRoutes);
app.use('/api/packages', packagesRoutes);

// Health check endpoint
app.get('/api/health', (req, res) => {
  res.json({
    success: true,
    message: 'Server is running',
    timestamp: new Date().toISOString()
  });
});

// Error handling
app.use(notFound);
app.use(errorHandler);

// Start server
const PORT = process.env.PORT || 3000;
app.listen(PORT, () => {
  console.log(`Server running on port ${PORT}`);
});

export default app;
```

## Environment Variables (.env)
```env
# Server
PORT=3000
NODE_ENV=development

# Database
MONGODB_URI=mongodb://localhost:27017/travel
# Or for MongoDB Atlas:
# MONGODB_URI=mongodb+srv://YOUR_USERNAME:YOUR_PASSWORD@cluster.mongodb.net/travel?retryWrites=true&w=majority
# WARNING: Replace YOUR_USERNAME and YOUR_PASSWORD with actual credentials
# NEVER commit real credentials to version control

# JWT
# WARNING: Generate a strong random secret for production
# Use: openssl rand -base64 32
JWT_SECRET=REPLACE_WITH_STRONG_RANDOM_SECRET_IN_PRODUCTION
JWT_EXPIRES_IN=24h
```

## Database Optimization

### Query Optimization Example
```typescript
// Optimized query with projection and population
export const getPackagesOptimized = async (
  req: Request,
  res: Response
): Promise<void> => {
  try {
    // Use select to only get needed fields
    // Use lean() for better performance (returns plain JS objects)
    const packages = await Package.find({ status: 'active' })
      .select('name location price duration images')
      .sort({ createdAt: -1 })
      .limit(20)
      .lean();

    res.json({
      success: true,
      data: packages
    });
  } catch (error: any) {
    res.status(500).json({
      success: false,
      message: error.message
    });
  }
};

// Aggregation example for complex queries
export const getPackageStats = async (
  req: Request,
  res: Response
): Promise<void> => {
  try {
    const stats = await Package.aggregate([
      {
        $group: {
          _id: '$status',
          count: { $sum: 1 },
          avgPrice: { $avg: '$price' },
          totalValue: { $sum: '$price' }
        }
      }
    ]);

    res.json({
      success: true,
      data: stats
    });
  } catch (error: any) {
    res.status(500).json({
      success: false,
      message: error.message
    });
  }
};
```

## Package.json Scripts
```json
{
  "scripts": {
    "start": "node dist/app.js",
    "dev": "nodemon --exec ts-node src/app.ts",
    "build": "tsc",
    "test": "jest",
    "lint": "eslint src/**/*.ts"
  }
}
```

## Best Practices

1. **Indexing**: Create indexes on frequently queried fields
2. **Validation**: Always validate input data
3. **Error Handling**: Use consistent error handling middleware
4. **Security**: Use helmet, validate input, hash passwords
5. **Performance**: Use lean() queries, projection, pagination
6. **Code Organization**: Separate concerns (routes, controllers, models)
7. **Environment Variables**: Never commit secrets to version control
8. **TypeScript**: Use TypeScript for type safety

This backend structure provides a solid foundation for your full stack application with proper authentication, validation, and database optimization.


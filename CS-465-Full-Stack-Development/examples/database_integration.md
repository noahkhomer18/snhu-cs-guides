# CS-465 Database Integration

## 🎯 Purpose
Demonstrate database integration patterns, ORM usage, and database design principles for full-stack applications.

## 📝 Database Integration Examples

### MongoDB with Mongoose (Node.js)

#### Database Models and Schemas
```javascript
// models/User.js
const mongoose = require('mongoose');
const bcrypt = require('bcryptjs');

const userSchema = new mongoose.Schema({
  name: {
    type: String,
    required: [true, 'Name is required'],
    trim: true,
    minlength: [2, 'Name must be at least 2 characters'],
    maxlength: [50, 'Name cannot exceed 50 characters']
  },
  email: {
    type: String,
    required: [true, 'Email is required'],
    unique: true,
    lowercase: true,
    match: [/^\w+([.-]?\w+)*@\w+([.-]?\w+)*(\.\w{2,3})+$/, 'Please enter a valid email']
  },
  password: {
    type: String,
    required: [true, 'Password is required'],
    minlength: [6, 'Password must be at least 6 characters'],
    select: false // Don't include password in queries by default
  },
  age: {
    type: Number,
    min: [0, 'Age must be positive'],
    max: [120, 'Age must be less than 120']
  },
  role: {
    type: String,
    enum: ['user', 'admin', 'moderator'],
    default: 'user'
  },
  profile: {
    bio: String,
    avatar: String,
    location: String,
    website: String,
    social: {
      twitter: String,
      linkedin: String,
      github: String
    }
  },
  preferences: {
    theme: {
      type: String,
      enum: ['light', 'dark'],
      default: 'light'
    },
    notifications: {
      email: { type: Boolean, default: true },
      push: { type: Boolean, default: true },
      sms: { type: Boolean, default: false }
    },
    language: { type: String, default: 'en' }
  },
  isActive: {
    type: Boolean,
    default: true
  },
  lastLogin: Date,
  loginAttempts: {
    type: Number,
    default: 0
  },
  lockUntil: Date
}, {
  timestamps: true,
  toJSON: { virtuals: true },
  toObject: { virtuals: true }
});

// Virtual for account lock status
userSchema.virtual('isLocked').get(function() {
  return !!(this.lockUntil && this.lockUntil > Date.now());
});

// Indexes for better query performance
userSchema.index({ email: 1 });
userSchema.index({ name: 'text', email: 'text' });
userSchema.index({ createdAt: -1 });
userSchema.index({ role: 1, isActive: 1 });

// Pre-save middleware to hash password
userSchema.pre('save', async function(next) {
  if (!this.isModified('password')) return next();
  
  try {
    const salt = await bcrypt.genSalt(12);
    this.password = await bcrypt.hash(this.password, salt);
    next();
  } catch (error) {
    next(error);
  }
});

// Instance method to compare password
userSchema.methods.comparePassword = async function(candidatePassword) {
  return await bcrypt.compare(candidatePassword, this.password);
};

// Instance method to increment login attempts
userSchema.methods.incLoginAttempts = function() {
  // If we have a previous lock that has expired, restart at 1
  if (this.lockUntil && this.lockUntil < Date.now()) {
    return this.updateOne({
      $unset: { lockUntil: 1 },
      $set: { loginAttempts: 1 }
    });
  }
  
  const updates = { $inc: { loginAttempts: 1 } };
  
  // Lock account after 5 failed attempts for 2 hours
  if (this.loginAttempts + 1 >= 5 && !this.isLocked) {
    updates.$set = { lockUntil: Date.now() + 2 * 60 * 60 * 1000 }; // 2 hours
  }
  
  return this.updateOne(updates);
};

// Static method to reset login attempts
userSchema.statics.resetLoginAttempts = function(email) {
  return this.updateOne(
    { email },
    { $unset: { loginAttempts: 1, lockUntil: 1 } }
  );
};

// Static method to find active users
userSchema.statics.findActiveUsers = function() {
  return this.find({ isActive: true, isLocked: false });
};

// Static method to search users
userSchema.statics.searchUsers = function(query, options = {}) {
  const {
    page = 1,
    limit = 10,
    sortBy = 'createdAt',
    sortOrder = 'desc',
    role,
    isActive
  } = options;
  
  const searchQuery = {
    $or: [
      { name: { $regex: query, $options: 'i' } },
      { email: { $regex: query, $options: 'i' } }
    ]
  };
  
  if (role) searchQuery.role = role;
  if (isActive !== undefined) searchQuery.isActive = isActive;
  
  return this.find(searchQuery)
    .sort({ [sortBy]: sortOrder === 'desc' ? -1 : 1 })
    .skip((page - 1) * limit)
    .limit(limit)
    .select('-password');
};

module.exports = mongoose.model('User', userSchema);
```

#### Advanced Query Patterns
```javascript
// services/UserService.js
const User = require('../models/User');
const mongoose = require('mongoose');

class UserService {
  // Create user with validation
  async createUser(userData) {
    try {
      const user = new User(userData);
      await user.save();
      return user;
    } catch (error) {
      if (error.code === 11000) {
        throw new Error('Email already exists');
      }
      throw error;
    }
  }

  // Find user by email with password
  async findUserByEmail(email, includePassword = false) {
    const query = User.findOne({ email });
    if (includePassword) {
      query.select('+password');
    }
    return await query.exec();
  }

  // Get users with pagination and filtering
  async getUsers(filters = {}) {
    const {
      page = 1,
      limit = 10,
      search,
      role,
      isActive,
      sortBy = 'createdAt',
      sortOrder = 'desc'
    } = filters;

    const query = {};
    
    if (search) {
      query.$or = [
        { name: { $regex: search, $options: 'i' } },
        { email: { $regex: search, $options: 'i' } }
      ];
    }
    
    if (role) query.role = role;
    if (isActive !== undefined) query.isActive = isActive;

    const options = {
      page: parseInt(page),
      limit: parseInt(limit),
      sort: { [sortBy]: sortOrder === 'desc' ? -1 : 1 },
      select: '-password'
    };

    return await User.paginate(query, options);
  }

  // Get user statistics
  async getUserStats() {
    const stats = await User.aggregate([
      {
        $group: {
          _id: null,
          totalUsers: { $sum: 1 },
          activeUsers: {
            $sum: { $cond: [{ $eq: ['$isActive', true] }, 1, 0] }
          },
          adminUsers: {
            $sum: { $cond: [{ $eq: ['$role', 'admin'] }, 1, 0] }
          },
          averageAge: { $avg: '$age' }
        }
      }
    ]);

    const roleDistribution = await User.aggregate([
      {
        $group: {
          _id: '$role',
          count: { $sum: 1 }
        }
      }
    ]);

    const monthlyRegistrations = await User.aggregate([
      {
        $group: {
          _id: {
            year: { $year: '$createdAt' },
            month: { $month: '$createdAt' }
          },
          count: { $sum: 1 }
        }
      },
      { $sort: { '_id.year': 1, '_id.month': 1 } }
    ]);

    return {
      ...stats[0],
      roleDistribution,
      monthlyRegistrations
    };
  }

  // Update user with validation
  async updateUser(userId, updateData) {
    const allowedUpdates = ['name', 'age', 'profile', 'preferences'];
    const updates = {};
    
    Object.keys(updateData).forEach(key => {
      if (allowedUpdates.includes(key)) {
        updates[key] = updateData[key];
      }
    });

    return await User.findByIdAndUpdate(
      userId,
      { $set: updates },
      { new: true, runValidators: true }
    ).select('-password');
  }

  // Soft delete user
  async deleteUser(userId) {
    return await User.findByIdAndUpdate(
      userId,
      { $set: { isActive: false, deletedAt: new Date() } },
      { new: true }
    );
  }

  // Bulk operations
  async bulkUpdateUsers(userIds, updateData) {
    return await User.updateMany(
      { _id: { $in: userIds } },
      { $set: updateData }
    );
  }

  // Text search with ranking
  async searchUsers(searchTerm, options = {}) {
    const { page = 1, limit = 10 } = options;
    
    return await User.aggregate([
      {
        $match: {
          $text: { $search: searchTerm },
          isActive: true
        }
      },
      {
        $addFields: {
          score: { $meta: 'textScore' }
        }
      },
      {
        $sort: { score: { $meta: 'textScore' } }
      },
      {
        $skip: (page - 1) * limit
      },
      {
        $limit: limit
      },
      {
        $project: {
          password: 0,
          loginAttempts: 0,
          lockUntil: 0
        }
      }
    ]);
  }
}

module.exports = new UserService();
```

### PostgreSQL with Prisma (Node.js)

#### Prisma Schema
```prisma
// prisma/schema.prisma
generator client {
  provider = "prisma-client-js"
}

datasource db {
  provider = "postgresql"
  url      = env("DATABASE_URL")
}

model User {
  id        Int      @id @default(autoincrement())
  name      String   @db.VarChar(100)
  email     String   @unique @db.VarChar(255)
  password  String   @db.VarChar(255)
  age       Int?
  role      Role     @default(USER)
  isActive  Boolean  @default(true)
  createdAt DateTime @default(now())
  updatedAt DateTime @updatedAt
  
  // Relations
  posts     Post[]
  comments  Comment[]
  profile   UserProfile?
  
  @@map("users")
  @@index([email])
  @@index([role, isActive])
}

model UserProfile {
  id       Int    @id @default(autoincrement())
  userId   Int    @unique
  bio      String? @db.Text
  avatar   String? @db.VarChar(500)
  location String? @db.VarChar(100)
  website  String? @db.VarChar(255)
  
  // Social links
  twitter  String? @db.VarChar(100)
  linkedin String? @db.VarChar(100)
  github   String? @db.VarChar(100)
  
  // Preferences
  theme        String @default("light") @db.VarChar(10)
  language     String @default("en") @db.VarChar(5)
  emailNotify  Boolean @default(true)
  pushNotify   Boolean @default(true)
  smsNotify    Boolean @default(false)
  
  user User @relation(fields: [userId], references: [id], onDelete: Cascade)
  
  @@map("user_profiles")
}

model Post {
  id        Int      @id @default(autoincrement())
  title     String   @db.VarChar(255)
  content   String   @db.Text
  published Boolean  @default(false)
  createdAt DateTime @default(now())
  updatedAt DateTime @updatedAt
  
  // Relations
  authorId  Int
  author    User      @relation(fields: [authorId], references: [id], onDelete: Cascade)
  comments  Comment[]
  tags      PostTag[]
  
  @@map("posts")
  @@index([authorId])
  @@index([published, createdAt])
}

model Comment {
  id        Int      @id @default(autoincrement())
  content   String   @db.Text
  createdAt DateTime @default(now())
  updatedAt DateTime @updatedAt
  
  // Relations
  authorId  Int
  author    User   @relation(fields: [authorId], references: [id], onDelete: Cascade)
  postId    Int
  post      Post   @relation(fields: [postId], references: [id], onDelete: Cascade)
  
  @@map("comments")
  @@index([postId])
  @@index([authorId])
}

model Tag {
  id    Int    @id @default(autoincrement())
  name  String @unique @db.VarChar(50)
  color String @default("#007bff") @db.VarChar(7)
  
  posts PostTag[]
  
  @@map("tags")
}

model PostTag {
  postId Int
  tagId  Int
  
  post Post @relation(fields: [postId], references: [id], onDelete: Cascade)
  tag  Tag  @relation(fields: [tagId], references: [id], onDelete: Cascade)
  
  @@id([postId, tagId])
  @@map("post_tags")
}

enum Role {
  USER
  ADMIN
  MODERATOR
}
```

#### Prisma Service Layer
```javascript
// services/PrismaUserService.js
const { PrismaClient } = require('@prisma/client');
const bcrypt = require('bcryptjs');

class PrismaUserService {
  constructor() {
    this.prisma = new PrismaClient();
  }

  async createUser(userData) {
    const hashedPassword = await bcrypt.hash(userData.password, 12);
    
    return await this.prisma.user.create({
      data: {
        ...userData,
        password: hashedPassword,
        profile: {
          create: {
            theme: 'light',
            language: 'en'
          }
        }
      },
      include: {
        profile: true,
        _count: {
          select: {
            posts: true,
            comments: true
          }
        }
      }
    });
  }

  async findUserByEmail(email, includePassword = false) {
    const select = {
      id: true,
      name: true,
      email: true,
      age: true,
      role: true,
      isActive: true,
      createdAt: true,
      updatedAt: true,
      profile: true
    };

    if (includePassword) {
      select.password = true;
    }

    return await this.prisma.user.findUnique({
      where: { email },
      select
    });
  }

  async getUsers(filters = {}) {
    const {
      page = 1,
      limit = 10,
      search,
      role,
      isActive,
      sortBy = 'createdAt',
      sortOrder = 'desc'
    } = filters;

    const where = {};
    
    if (search) {
      where.OR = [
        { name: { contains: search, mode: 'insensitive' } },
        { email: { contains: search, mode: 'insensitive' } }
      ];
    }
    
    if (role) where.role = role;
    if (isActive !== undefined) where.isActive = isActive;

    const [users, total] = await Promise.all([
      this.prisma.user.findMany({
        where,
        skip: (page - 1) * limit,
        take: limit,
        orderBy: { [sortBy]: sortOrder },
        select: {
          id: true,
          name: true,
          email: true,
          age: true,
          role: true,
          isActive: true,
          createdAt: true,
          updatedAt: true,
          profile: true,
          _count: {
            select: {
              posts: true,
              comments: true
            }
          }
        }
      }),
      this.prisma.user.count({ where })
    ]);

    return {
      users,
      pagination: {
        page: parseInt(page),
        limit: parseInt(limit),
        total,
        pages: Math.ceil(total / limit)
      }
    };
  }

  async getUserStats() {
    const [
      totalUsers,
      activeUsers,
      roleDistribution,
      monthlyRegistrations
    ] = await Promise.all([
      this.prisma.user.count(),
      this.prisma.user.count({ where: { isActive: true } }),
      this.prisma.user.groupBy({
        by: ['role'],
        _count: { role: true }
      }),
      this.prisma.user.groupBy({
        by: ['createdAt'],
        _count: { createdAt: true },
        where: {
          createdAt: {
            gte: new Date(new Date().getFullYear(), 0, 1) // Current year
          }
        }
      })
    ]);

    const averageAge = await this.prisma.user.aggregate({
      _avg: { age: true }
    });

    return {
      totalUsers,
      activeUsers,
      averageAge: averageAge._avg.age,
      roleDistribution,
      monthlyRegistrations
    };
  }

  async updateUser(userId, updateData) {
    const { profile, ...userData } = updateData;
    
    return await this.prisma.user.update({
      where: { id: userId },
      data: {
        ...userData,
        ...(profile && {
          profile: {
            upsert: {
              create: profile,
              update: profile
            }
          }
        })
      },
      include: {
        profile: true
      }
    });
  }

  async deleteUser(userId) {
    return await this.prisma.user.update({
      where: { id: userId },
      data: { isActive: false },
      include: {
        profile: true
      }
    });
  }

  async getUserWithPosts(userId, postFilters = {}) {
    const { page = 1, limit = 10, published } = postFilters;
    
    return await this.prisma.user.findUnique({
      where: { id: userId },
      include: {
        profile: true,
        posts: {
          where: published !== undefined ? { published } : {},
          skip: (page - 1) * limit,
          take: limit,
          orderBy: { createdAt: 'desc' },
          include: {
            tags: {
              include: {
                tag: true
              }
            },
            _count: {
              select: {
                comments: true
              }
            }
          }
        },
        _count: {
          select: {
            posts: true,
            comments: true
          }
        }
      }
    });
  }

  async searchUsers(searchTerm, options = {}) {
    const { page = 1, limit = 10 } = options;
    
    return await this.prisma.user.findMany({
      where: {
        AND: [
          { isActive: true },
          {
            OR: [
              { name: { contains: searchTerm, mode: 'insensitive' } },
              { email: { contains: searchTerm, mode: 'insensitive' } },
              {
                profile: {
                  bio: { contains: searchTerm, mode: 'insensitive' }
                }
              }
            ]
          }
        ]
      },
      skip: (page - 1) * limit,
      take: limit,
      include: {
        profile: true,
        _count: {
          select: {
            posts: true,
            comments: true
          }
        }
      }
    });
  }

  async close() {
    await this.prisma.$disconnect();
  }
}

module.exports = new PrismaUserService();
```

### Redis Caching Layer

#### Redis Service
```javascript
// services/RedisService.js
const redis = require('redis');
const { promisify } = require('util');

class RedisService {
  constructor() {
    this.client = redis.createClient({
      host: process.env.REDIS_HOST || 'localhost',
      port: process.env.REDIS_PORT || 6379,
      password: process.env.REDIS_PASSWORD
    });
    
    this.client.on('error', (err) => {
      console.error('Redis Client Error:', err);
    });
    
    // Promisify Redis methods
    this.get = promisify(this.client.get).bind(this.client);
    this.set = promisify(this.client.set).bind(this.client);
    this.del = promisify(this.client.del).bind(this.client);
    this.exists = promisify(this.client.exists).bind(this.client);
    this.expire = promisify(this.client.expire).bind(this.client);
    this.keys = promisify(this.client.keys).bind(this.client);
  }

  async cache(key, data, ttl = 3600) {
    try {
      const serializedData = JSON.stringify(data);
      await this.set(key, serializedData);
      await this.expire(key, ttl);
      return true;
    } catch (error) {
      console.error('Redis cache error:', error);
      return false;
    }
  }

  async getCached(key) {
    try {
      const data = await this.get(key);
      return data ? JSON.parse(data) : null;
    } catch (error) {
      console.error('Redis get error:', error);
      return null;
    }
  }

  async invalidate(pattern) {
    try {
      const keys = await this.keys(pattern);
      if (keys.length > 0) {
        await this.client.del(...keys);
      }
      return keys.length;
    } catch (error) {
      console.error('Redis invalidate error:', error);
      return 0;
    }
  }

  async invalidateUser(userId) {
    const patterns = [
      `user:${userId}:*`,
      `users:*`,
      `stats:*`
    ];
    
    let totalInvalidated = 0;
    for (const pattern of patterns) {
      totalInvalidated += await this.invalidate(pattern);
    }
    
    return totalInvalidated;
  }

  // Cache with automatic key generation
  async cacheUser(userId, userData, ttl = 3600) {
    const key = `user:${userId}:profile`;
    return await this.cache(key, userData, ttl);
  }

  async getCachedUser(userId) {
    const key = `user:${userId}:profile`;
    return await this.getCached(key);
  }

  async cacheUsersList(filters, usersData, ttl = 300) {
    const key = `users:${JSON.stringify(filters)}`;
    return await this.cache(key, usersData, ttl);
  }

  async getCachedUsersList(filters) {
    const key = `users:${JSON.stringify(filters)}`;
    return await this.getCached(key);
  }
}

module.exports = new RedisService();
```

#### Cached User Service
```javascript
// services/CachedUserService.js
const UserService = require('./UserService');
const RedisService = require('./RedisService');

class CachedUserService {
  async getUser(userId) {
    // Try cache first
    let user = await RedisService.getCachedUser(userId);
    
    if (!user) {
      // Cache miss - get from database
      user = await UserService.getUserById(userId);
      if (user) {
        await RedisService.cacheUser(userId, user);
      }
    }
    
    return user;
  }

  async getUsers(filters) {
    // Try cache first
    let result = await RedisService.getCachedUsersList(filters);
    
    if (!result) {
      // Cache miss - get from database
      result = await UserService.getUsers(filters);
      await RedisService.cacheUsersList(filters, result);
    }
    
    return result;
  }

  async updateUser(userId, updateData) {
    // Update in database
    const user = await UserService.updateUser(userId, updateData);
    
    if (user) {
      // Update cache
      await RedisService.cacheUser(userId, user);
      // Invalidate related caches
      await RedisService.invalidateUser(userId);
    }
    
    return user;
  }

  async deleteUser(userId) {
    // Delete from database
    const result = await UserService.deleteUser(userId);
    
    if (result) {
      // Invalidate all user-related caches
      await RedisService.invalidateUser(userId);
    }
    
    return result;
  }

  async getUserStats() {
    const cacheKey = 'stats:users';
    let stats = await RedisService.getCached(cacheKey);
    
    if (!stats) {
      stats = await UserService.getUserStats();
      await RedisService.cache(cacheKey, stats, 1800); // 30 minutes
    }
    
    return stats;
  }
}

module.exports = new CachedUserService();
```

## 🔍 Database Integration Concepts
- **ORM/ODM**: Object-Relational/Object-Document Mapping
- **Database Design**: Normalization, indexing, and relationships
- **Query Optimization**: Efficient queries and database performance
- **Caching**: Redis for improved performance
- **Data Validation**: Schema validation and constraints

## 💡 Learning Points
- ORMs provide abstraction over raw database queries
- Proper indexing improves query performance
- Caching reduces database load and improves response times
- Database relationships should be carefully designed
- Data validation prevents inconsistent data states

# Handlebars (HBS) Templating Guide for Customer-Facing Pages

## Overview
Handlebars is a lightweight templating engine that simplifies rendering dynamic JSON data into HTML. It's perfect for the customer-facing side of your full stack application where you need to display travel content dynamically.

## Setup and Installation

### Installing Handlebars
```bash
# Install Handlebars for Express
npm install express-handlebars
npm install -D @types/express-handlebars
```

### Basic Express Server with Handlebars
```javascript
// server.js
const express = require('express');
const exphbs = require('express-handlebars');
const path = require('path');

const app = express();
const PORT = process.env.PORT || 3000;

// Configure Handlebars
app.engine('hbs', exphbs({
  extname: '.hbs',
  defaultLayout: 'main',
  layoutsDir: path.join(__dirname, 'views/layouts'),
  partialsDir: path.join(__dirname, 'views/partials')
}));

app.set('view engine', 'hbs');
app.set('views', path.join(__dirname, 'views'));

// Serve static files
app.use(express.static('public'));

// Routes
app.get('/', (req, res) => {
  res.render('home', {
    title: 'Travel Getaways',
    packages: [
      { name: 'Beach Paradise', price: 599, location: 'Hawaii' },
      { name: 'Mountain Adventure', price: 799, location: 'Switzerland' }
    ]
  });
});

app.listen(PORT, () => {
  console.log(`Server running on port ${PORT}`);
});
```

## Project Structure
```
project/
├── views/
│   ├── layouts/
│   │   └── main.hbs          # Main layout template
│   ├── partials/
│   │   ├── header.hbs        # Reusable header
│   │   ├── footer.hbs        # Reusable footer
│   │   └── package-card.hbs  # Reusable package card
│   ├── home.hbs              # Home page
│   ├── packages.hbs          # Packages listing
│   └── package-detail.hbs    # Package detail page
├── public/
│   ├── css/
│   ├── js/
│   └── images/
└── server.js
```

## Basic Templates

### Main Layout (views/layouts/main.hbs)
```handlebars
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>{{title}} - Travel Getaways</title>
  <link rel="stylesheet" href="/css/style.css">
</head>
<body>
  {{> header}}
  
  <main>
    {{{body}}}
  </main>
  
  {{> footer}}
  
  <script src="/js/main.js"></script>
</body>
</html>
```

### Header Partial (views/partials/header.hbs)
```handlebars
<header class="navbar">
  <div class="container">
    <h1 class="logo">Travel Getaways</h1>
    <nav>
      <a href="/">Home</a>
      <a href="/packages">Packages</a>
      <a href="/about">About</a>
    </nav>
  </div>
</header>
```

### Footer Partial (views/partials/footer.hbs)
```handlebars
<footer class="footer">
  <div class="container">
    <p>&copy; {{currentYear}} Travel Getaways. All rights reserved.</p>
  </div>
</footer>
```

## Rendering JSON Data

### Home Page Template (views/home.hbs)
```handlebars
<div class="hero">
  <h1>Welcome to Travel Getaways</h1>
  <p>Discover amazing destinations around the world</p>
</div>

<section class="featured-packages">
  <h2>Featured Packages</h2>
  <div class="packages-grid">
    {{#each packages}}
      {{> package-card}}
    {{/each}}
  </div>
</section>
```

### Package Card Partial (views/partials/package-card.hbs)
```handlebars
<div class="package-card">
  <img src="{{image}}" alt="{{name}}" />
  <div class="package-info">
    <h3>{{name}}</h3>
    <p class="location">{{location}}</p>
    <p class="price">${{price}}</p>
    <a href="/packages/{{id}}" class="btn">View Details</a>
  </div>
</div>
```

### Packages Listing Page (views/packages.hbs)
```handlebars
<div class="packages-page">
  <h1>All Travel Packages</h1>
  
  {{#if packages}}
    <div class="packages-list">
      {{#each packages}}
        <div class="package-item">
          <h3>{{name}}</h3>
          <p><strong>Location:</strong> {{location}}</p>
          <p><strong>Duration:</strong> {{duration}} days</p>
          <p><strong>Price:</strong> ${{price}}</p>
          <p>{{description}}</p>
          <a href="/packages/{{_id}}" class="btn-primary">Book Now</a>
        </div>
      {{/each}}
    </div>
  {{else}}
    <p class="no-packages">No packages available at this time.</p>
  {{/if}}
</div>
```

## Advanced Handlebars Features

### Conditional Rendering
```handlebars
{{#if user}}
  <div class="user-menu">
    <p>Welcome, {{user.name}}!</p>
    <a href="/logout">Logout</a>
  </div>
{{else}}
  <div class="auth-buttons">
    <a href="/login">Login</a>
    <a href="/register">Register</a>
  </div>
{{/if}}
```

### Helper Functions
```javascript
// server.js - Register custom helpers
const hbs = exphbs.create({
  helpers: {
    // Format currency
    formatCurrency: (price) => {
      return new Intl.NumberFormat('en-US', {
        style: 'currency',
        currency: 'USD'
      }).format(price);
    },
    
    // Format date
    formatDate: (date) => {
      return new Date(date).toLocaleDateString('en-US', {
        year: 'numeric',
        month: 'long',
        day: 'numeric'
      });
    },
    
    // Check if value equals
    eq: (a, b) => a === b,
    
    // Increment index (for arrays)
    increment: (value) => parseInt(value) + 1
  }
});

app.engine('hbs', hbs.engine);
```

### Using Helpers in Templates
```handlebars
<div class="package">
  <h3>{{name}}</h3>
  <p class="price">{{formatCurrency price}}</p>
  <p class="date">Available: {{formatDate availableDate}}</p>
  
  {{#if (eq status "active")}}
    <span class="badge badge-success">Available</span>
  {{else}}
    <span class="badge badge-disabled">Sold Out</span>
  {{/if}}
</div>
```

### Looping with Index
```handlebars
{{#each packages}}
  <div class="package-item package-{{increment @index}}">
    <span class="rank">#{{increment @index}}</span>
    <h3>{{name}}</h3>
  </div>
{{/each}}
```

## Integrating with Backend API

### Fetching Data from MongoDB
```javascript
// routes/packages.js
const express = require('express');
const router = express.Router();
const Package = require('../models/Package');

// Render packages page with data from database
router.get('/', async (req, res) => {
  try {
    const packages = await Package.find({ status: 'active' });
    res.render('packages', {
      title: 'Travel Packages',
      packages: packages,
      user: req.session.user || null
    });
  } catch (error) {
    res.status(500).render('error', {
      title: 'Error',
      message: 'Failed to load packages'
    });
  }
});

// Package detail page
router.get('/:id', async (req, res) => {
  try {
    const package = await Package.findById(req.params.id);
    if (!package) {
      return res.status(404).render('error', {
        title: 'Not Found',
        message: 'Package not found'
      });
    }
    res.render('package-detail', {
      title: package.name,
      package: package
    });
  } catch (error) {
    res.status(500).render('error', {
      title: 'Error',
      message: 'Failed to load package details'
    });
  }
});

module.exports = router;
```

### Package Detail Template (views/package-detail.hbs)
```handlebars
<div class="package-detail">
  <div class="package-header">
    <h1>{{package.name}}</h1>
    <p class="location">{{package.location}}</p>
  </div>
  
  <div class="package-content">
    <div class="package-images">
      {{#each package.images}}
        <img src="{{this}}" alt="{{../package.name}}" />
      {{/each}}
    </div>
    
    <div class="package-info">
      <div class="price-section">
        <span class="price">${{formatCurrency package.price}}</span>
        <span class="duration">{{package.duration}} days</span>
      </div>
      
      <div class="description">
        <h2>Description</h2>
        <p>{{package.description}}</p>
      </div>
      
      <div class="itinerary">
        <h2>Itinerary</h2>
        <ul>
          {{#each package.itinerary}}
            <li>
              <strong>Day {{increment @index}}:</strong> {{this}}
            </li>
          {{/each}}
        </ul>
      </div>
      
      <div class="booking-section">
        <button class="btn-book" onclick="bookPackage('{{package._id}}')">
          Book Now
        </button>
      </div>
    </div>
  </div>
</div>
```

## JSON Data Integration

### Passing JSON from API to Template
```javascript
// Fetch data from external API or database
router.get('/api/packages', async (req, res) => {
  try {
    const packages = await Package.find();
    res.json(packages);
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
});

// Render page with JSON data
router.get('/packages', async (req, res) => {
  try {
    // Fetch from database
    const packages = await Package.find({ status: 'active' });
    
    // Transform data if needed
    const formattedPackages = packages.map(pkg => ({
      id: pkg._id,
      name: pkg.name,
      location: pkg.location,
      price: pkg.price,
      image: pkg.images[0] || '/images/default.jpg',
      description: pkg.description.substring(0, 150) + '...'
    }));
    
    res.render('packages', {
      title: 'Travel Packages',
      packages: formattedPackages
    });
  } catch (error) {
    res.status(500).render('error', {
      title: 'Error',
      message: 'Failed to load packages'
    });
  }
});
```

### Client-Side JSON Fetching
```javascript
// public/js/main.js
async function loadPackages() {
  try {
    const response = await fetch('/api/packages');
    const packages = await response.json();
    
    const container = document.getElementById('packages-container');
    container.innerHTML = '';
    
    packages.forEach(pkg => {
      const card = createPackageCard(pkg);
      container.appendChild(card);
    });
  } catch (error) {
    console.error('Error loading packages:', error);
  }
}

function createPackageCard(package) {
  const card = document.createElement('div');
  card.className = 'package-card';
  card.innerHTML = `
    <img src="${package.image}" alt="${package.name}" />
    <h3>${package.name}</h3>
    <p>${package.location}</p>
    <p class="price">$${package.price}</p>
    <a href="/packages/${package._id}" class="btn">View Details</a>
  `;
  return card;
}
```

## Best Practices

### 1. Organize Partials
Create reusable partials for common UI elements:
- Navigation menus
- Cards and list items
- Forms
- Modals
- Alerts

### 2. Use Layouts
Create different layouts for different page types:
- Main layout (with header/footer)
- Admin layout (with sidebar)
- Minimal layout (for login/register)

### 3. Data Validation
Always validate and sanitize data before passing to templates:
```javascript
router.get('/packages/:id', async (req, res) => {
  // Validate ID format
  if (!req.params.id.match(/^[0-9a-fA-F]{24}$/)) {
    return res.status(400).render('error', {
      message: 'Invalid package ID'
    });
  }
  
  // Continue with database query...
});
```

### 4. Error Handling
Create error templates for different scenarios:
```handlebars
<!-- views/error.hbs -->
<div class="error-page">
  <h1>{{title}}</h1>
  <p>{{message}}</p>
  <a href="/" class="btn">Return Home</a>
</div>
```

### 5. Performance Optimization
- Cache rendered templates when possible
- Minimize database queries
- Use pagination for large datasets
- Optimize images and assets

## Complete Example: Travel Package System

### Server Setup
```javascript
// server.js
const express = require('express');
const exphbs = require('express-handlebars');
const mongoose = require('mongoose');
const path = require('path');

const app = express();

// MongoDB connection
mongoose.connect(process.env.MONGODB_URI || 'mongodb://localhost:27017/travel', {
  useNewUrlParser: true,
  useUnifiedTopology: true
});

// Handlebars configuration
app.engine('hbs', exphbs({
  extname: '.hbs',
  defaultLayout: 'main',
  layoutsDir: path.join(__dirname, 'views/layouts'),
  partialsDir: path.join(__dirname, 'views/partials'),
  helpers: {
    formatCurrency: (price) => `$${price.toLocaleString()}`,
    formatDate: (date) => new Date(date).toLocaleDateString(),
    eq: (a, b) => a === b
  }
}));

app.set('view engine', 'hbs');
app.set('views', path.join(__dirname, 'views'));

// Middleware
app.use(express.json());
app.use(express.urlencoded({ extended: true }));
app.use(express.static('public'));

// Routes
app.use('/', require('./routes/index'));
app.use('/packages', require('./routes/packages'));
app.use('/api', require('./routes/api'));

const PORT = process.env.PORT || 3000;
app.listen(PORT, () => {
  console.log(`Server running on port ${PORT}`);
});
```

This guide provides a complete foundation for using Handlebars in your customer-facing pages, allowing you to dynamically render JSON data from your MongoDB database into beautiful HTML templates.


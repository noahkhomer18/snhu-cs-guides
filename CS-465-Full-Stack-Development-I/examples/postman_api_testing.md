# Postman API Testing Guide - Complete Reference

## Overview
Postman is an essential tool for testing RESTful APIs. This guide covers testing GET, POST, PUT, DELETE requests, authentication, and handling security challenges in your full stack application.

## Postman Setup

### Installing Postman
1. Download from: https://www.postman.com/downloads/
2. Create a free account (optional but recommended)
3. Install the desktop app or use the web version

### Creating a New Collection
1. Click "New" → "Collection"
2. Name it "Travel API Tests"
3. Add description: "API tests for travel booking application"

## Environment Variables

### Setting Up Environments
1. Click "Environments" in the sidebar
2. Click "+" to create new environment
3. Name it "Local Development"
4. Add variables:
   - `base_url`: `http://localhost:3000`
   - `api_url`: `http://localhost:3000/api`
   - `token`: (leave empty, will be set automatically)

### Using Variables in Requests
Use `{{variable_name}}` syntax:
- URL: `{{api_url}}/packages`
- Header: `Bearer {{token}}`

## Testing GET Requests

### Get All Packages
**Request Setup:**
- Method: `GET`
- URL: `{{api_url}}/packages`
- Headers: None required

**Expected Response:**
```json
{
  "success": true,
  "count": 5,
  "data": [
    {
      "_id": "507f1f77bcf86cd799439011",
      "name": "Beach Paradise",
      "location": "Hawaii",
      "price": 599,
      "duration": 7,
      "status": "active"
    }
  ]
}
```

**Tests Tab (JavaScript):**
```javascript
// Test status code
pm.test("Status code is 200", function () {
    pm.response.to.have.status(200);
});

// Test response structure
pm.test("Response has success property", function () {
    var jsonData = pm.response.json();
    pm.expect(jsonData).to.have.property('success');
    pm.expect(jsonData.success).to.be.true;
});

// Test data array
pm.test("Response contains data array", function () {
    var jsonData = pm.response.json();
    pm.expect(jsonData).to.have.property('data');
    pm.expect(jsonData.data).to.be.an('array');
});

// Test package structure
pm.test("Packages have required fields", function () {
    var jsonData = pm.response.json();
    if (jsonData.data.length > 0) {
        var package = jsonData.data[0];
        pm.expect(package).to.have.property('name');
        pm.expect(package).to.have.property('location');
        pm.expect(package).to.have.property('price');
    }
});
```

### Get Single Package by ID
**Request Setup:**
- Method: `GET`
- URL: `{{api_url}}/packages/507f1f77bcf86cd799439011`
- Headers: None required

**Tests:**
```javascript
pm.test("Status code is 200", function () {
    pm.response.to.have.status(200);
});

pm.test("Package has all required fields", function () {
    var jsonData = pm.response.json();
    pm.expect(jsonData.data).to.have.property('_id');
    pm.expect(jsonData.data).to.have.property('name');
    pm.expect(jsonData.data).to.have.property('location');
    pm.expect(jsonData.data).to.have.property('price');
    pm.expect(jsonData.data).to.have.property('duration');
});

pm.test("Price is a number", function () {
    var jsonData = pm.response.json();
    pm.expect(jsonData.data.price).to.be.a('number');
});
```

### Get Package with Invalid ID
**Request Setup:**
- Method: `GET`
- URL: `{{api_url}}/packages/invalid-id`

**Tests:**
```javascript
pm.test("Status code is 404 or 400", function () {
    pm.expect(pm.response.code).to.be.oneOf([400, 404]);
});

pm.test("Error message is present", function () {
    var jsonData = pm.response.json();
    pm.expect(jsonData).to.have.property('message');
});
```

## Testing POST Requests

### Create New Package (Admin Only)
**Request Setup:**
- Method: `POST`
- URL: `{{api_url}}/packages`
- Headers:
  - `Content-Type`: `application/json`
  - `Authorization`: `Bearer {{token}}`
- Body (raw JSON):
```json
{
  "name": "Mountain Adventure",
  "location": "Switzerland",
  "description": "Amazing mountain experience with hiking and skiing",
  "price": 799,
  "duration": 5,
  "images": [
    "https://example.com/image1.jpg",
    "https://example.com/image2.jpg"
  ],
  "itinerary": [
    "Day 1: Arrival and check-in",
    "Day 2: Mountain hiking",
    "Day 3: Skiing adventure"
  ],
  "status": "active"
}
```

**Tests:**
```javascript
pm.test("Status code is 201", function () {
    pm.response.to.have.status(201);
});

pm.test("Package created successfully", function () {
    var jsonData = pm.response.json();
    pm.expect(jsonData.success).to.be.true;
    pm.expect(jsonData.data).to.have.property('_id');
    pm.expect(jsonData.data.name).to.eql("Mountain Adventure");
});

// Save package ID for later use
if (pm.response.code === 201) {
    var jsonData = pm.response.json();
    pm.environment.set("package_id", jsonData.data._id);
}
```

### Test POST with Missing Required Fields
**Request Setup:**
- Method: `POST`
- URL: `{{api_url}}/packages`
- Headers:
  - `Content-Type`: `application/json`
  - `Authorization`: `Bearer {{token}}`
- Body (missing required fields):
```json
{
  "name": "Test Package"
}
```

**Tests:**
```javascript
pm.test("Status code is 400", function () {
    pm.response.to.have.status(400);
});

pm.test("Error message indicates missing fields", function () {
    var jsonData = pm.response.json();
    pm.expect(jsonData.success).to.be.false;
    pm.expect(jsonData).to.have.property('message');
});
```

### Test POST without Authentication
**Request Setup:**
- Method: `POST`
- URL: `{{api_url}}/packages`
- Headers:
  - `Content-Type`: `application/json`
  - (No Authorization header)
- Body: (any valid JSON)

**Tests:**
```javascript
pm.test("Status code is 401", function () {
    pm.response.to.have.status(401);
});

pm.test("Error message indicates authentication required", function () {
    var jsonData = pm.response.json();
    pm.expect(jsonData.success).to.be.false;
    pm.expect(jsonData.message).to.include('authorization');
});
```

## Testing PUT Requests

### Update Package
**Request Setup:**
- Method: `PUT`
- URL: `{{api_url}}/packages/{{package_id}}`
- Headers:
  - `Content-Type`: `application/json`
  - `Authorization`: `Bearer {{token}}`
- Body (raw JSON):
```json
{
  "price": 899,
  "status": "active",
  "description": "Updated description with more details"
}
```

**Tests:**
```javascript
pm.test("Status code is 200", function () {
    pm.response.to.have.status(200);
});

pm.test("Package updated successfully", function () {
    var jsonData = pm.response.json();
    pm.expect(jsonData.success).to.be.true;
    pm.expect(jsonData.data.price).to.eql(899);
});

pm.test("Updated fields are reflected", function () {
    var jsonData = pm.response.json();
    pm.expect(jsonData.data.description).to.include("Updated");
});
```

### Test PUT with Invalid ID
**Request Setup:**
- Method: `PUT`
- URL: `{{api_url}}/packages/invalid-id`
- Headers:
  - `Content-Type`: `application/json`
  - `Authorization`: `Bearer {{token}}`
- Body: (any valid JSON)

**Tests:**
```javascript
pm.test("Status code is 404", function () {
    pm.response.to.have.status(404);
});
```

## Testing DELETE Requests

### Delete Package
**Request Setup:**
- Method: `DELETE`
- URL: `{{api_url}}/packages/{{package_id}}`
- Headers:
  - `Authorization`: `Bearer {{token}}`

**Tests:**
```javascript
pm.test("Status code is 200", function () {
    pm.response.to.have.status(200);
});

pm.test("Package deleted successfully", function () {
    var jsonData = pm.response.json();
    pm.expect(jsonData.success).to.be.true;
    pm.expect(jsonData.message).to.include('deleted');
});

// Verify deletion with GET request
pm.test("Package no longer exists", function () {
    pm.sendRequest({
        url: pm.environment.get("api_url") + "/packages/" + pm.environment.get("package_id"),
        method: 'GET'
    }, function (err, res) {
        pm.expect(res.code).to.be.oneOf([404, 400]);
    });
});
```

## Authentication Testing

### Login Request
**Request Setup:**
- Method: `POST`
- URL: `{{api_url}}/auth/login`
- Headers:
  - `Content-Type`: `application/json`
- Body (raw JSON):
```json
{
  "username": "admin",
  "password": "password123"
}
```

**Tests:**
```javascript
pm.test("Status code is 200", function () {
    pm.response.to.have.status(200);
});

pm.test("Login successful", function () {
    var jsonData = pm.response.json();
    pm.expect(jsonData.success).to.be.true;
    pm.expect(jsonData).to.have.property('token');
    pm.expect(jsonData).to.have.property('user');
});

// Save token for subsequent requests
if (pm.response.code === 200) {
    var jsonData = pm.response.json();
    pm.environment.set("token", jsonData.token);
    pm.environment.set("user_id", jsonData.user._id);
}

pm.test("Token is not empty", function () {
    var jsonData = pm.response.json();
    pm.expect(jsonData.token).to.not.be.empty;
});

pm.test("User object has required fields", function () {
    var jsonData = pm.response.json();
    pm.expect(jsonData.user).to.have.property('_id');
    pm.expect(jsonData.user).to.have.property('username');
    pm.expect(jsonData.user).to.have.property('role');
});
```

### Test Login with Invalid Credentials
**Request Setup:**
- Method: `POST`
- URL: `{{api_url}}/auth/login`
- Headers:
  - `Content-Type`: `application/json`
- Body:
```json
{
  "username": "wronguser",
  "password": "wrongpassword"
}
```

**Tests:**
```javascript
pm.test("Status code is 401", function () {
    pm.response.to.have.status(401);
});

pm.test("Login failed", function () {
    var jsonData = pm.response.json();
    pm.expect(jsonData.success).to.be.false;
    pm.expect(jsonData.message).to.include('Invalid');
});
```

### Test Login with Missing Fields
**Request Setup:**
- Method: `POST`
- URL: `{{api_url}}/auth/login`
- Headers:
  - `Content-Type`: `application/json`
- Body:
```json
{
  "username": "admin"
}
```

**Tests:**
```javascript
pm.test("Status code is 400", function () {
    pm.response.to.have.status(400);
});
```

### Test Protected Endpoint with Valid Token
**Request Setup:**
- Method: `POST`
- URL: `{{api_url}}/packages`
- Headers:
  - `Content-Type`: `application/json`
  - `Authorization`: `Bearer {{token}}`
- Body: (valid package data)

**Tests:**
```javascript
pm.test("Status code is 201", function () {
    pm.response.to.have.status(201);
});

pm.test("Request authorized", function () {
    var jsonData = pm.response.json();
    pm.expect(jsonData.success).to.be.true;
});
```

### Test Protected Endpoint with Invalid Token
**Request Setup:**
- Method: `POST`
- URL: `{{api_url}}/packages`
- Headers:
  - `Content-Type`: `application/json`
  - `Authorization`: `Bearer invalid-token-here`
- Body: (any JSON)

**Tests:**
```javascript
pm.test("Status code is 401", function () {
    pm.response.to.have.status(401);
});

pm.test("Access denied", function () {
    var jsonData = pm.response.json();
    pm.expect(jsonData.success).to.be.false;
    pm.expect(jsonData.message).to.include('valid');
});
```

### Test Protected Endpoint without Token
**Request Setup:**
- Method: `POST`
- URL: `{{api_url}}/packages`
- Headers:
  - `Content-Type`: `application/json`
  - (No Authorization header)
- Body: (any JSON)

**Tests:**
```javascript
pm.test("Status code is 401", function () {
    pm.response.to.have.status(401);
});

pm.test("No token provided error", function () {
    var jsonData = pm.response.json();
    pm.expect(jsonData.message).to.include('token');
});
```

## Advanced Testing Scenarios

### Testing with Query Parameters
**Request Setup:**
- Method: `GET`
- URL: `{{api_url}}/packages?status=active&minPrice=500&maxPrice=1000&sort=price-asc`
- Headers: None

**Tests:**
```javascript
pm.test("Status code is 200", function () {
    pm.response.to.have.status(200);
});

pm.test("All packages are active", function () {
    var jsonData = pm.response.json();
    jsonData.data.forEach(pkg => {
        pm.expect(pkg.status).to.eql('active');
    });
});

pm.test("Prices are within range", function () {
    var jsonData = pm.response.json();
    jsonData.data.forEach(pkg => {
        pm.expect(pkg.price).to.be.at.least(500);
        pm.expect(pkg.price).to.be.at.most(1000);
    });
});

pm.test("Packages are sorted by price ascending", function () {
    var jsonData = pm.response.json();
    if (jsonData.data.length > 1) {
        for (let i = 1; i < jsonData.data.length; i++) {
            pm.expect(jsonData.data[i].price).to.be.at.least(jsonData.data[i-1].price);
        }
    }
});
```

### Testing Response Time
```javascript
pm.test("Response time is less than 500ms", function () {
    pm.expect(pm.response.responseTime).to.be.below(500);
});
```

### Testing Response Headers
```javascript
pm.test("Content-Type is application/json", function () {
    pm.expect(pm.response.headers.get("Content-Type")).to.include("application/json");
});
```

## Creating Test Collections

### Collection Structure
```
Travel API Tests/
├── Authentication/
│   ├── Login - Valid Credentials
│   ├── Login - Invalid Credentials
│   └── Login - Missing Fields
├── Packages (Public)/
│   ├── Get All Packages
│   ├── Get Package by ID
│   └── Get Package - Invalid ID
└── Packages (Admin)/
    ├── Create Package
    ├── Update Package
    ├── Delete Package
    └── Create Package - No Auth
```

### Collection-Level Scripts
**Pre-request Script (Collection Level):**
```javascript
// Set base URL if not already set
if (!pm.environment.get("base_url")) {
    pm.environment.set("base_url", "http://localhost:3000");
}

if (!pm.environment.get("api_url")) {
    pm.environment.set("api_url", pm.environment.get("base_url") + "/api");
}
```

**Test Script (Collection Level):**
```javascript
// Global test for all requests
pm.test("Response time is acceptable", function () {
    pm.expect(pm.response.responseTime).to.be.below(2000);
});

pm.test("Response is valid JSON", function () {
    pm.response.to.be.json;
});
```

## Automated Testing with Newman

### Installing Newman
```bash
npm install -g newman
```

### Running Collection
```bash
# Run collection
newman run "Travel API Tests.postman_collection.json" -e "Local Development.postman_environment.json"

# Run with HTML report
newman run "Travel API Tests.postman_collection.json" \
  -e "Local Development.postman_environment.json" \
  --reporters html \
  --reporter-html-export report.html
```

### CI/CD Integration
```yaml
# GitHub Actions example
name: API Tests
on: [push, pull_request]
jobs:
  test:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v2
      - name: Install Newman
        run: npm install -g newman
      - name: Run API Tests
        run: |
          newman run "Travel API Tests.postman_collection.json" \
            -e "Local Development.postman_environment.json"
```

## Best Practices

1. **Organize Requests**: Group related requests in folders
2. **Use Variables**: Store reusable values in environment variables
3. **Write Tests**: Always write tests for each request
4. **Document Requests**: Add descriptions to explain purpose
5. **Use Pre-request Scripts**: Set up data before requests
6. **Save Responses**: Use tests to save IDs for subsequent requests
7. **Test Edge Cases**: Test invalid inputs, missing fields, etc.
8. **Version Control**: Export and commit collections to Git

## Common Test Patterns

### Check Response Schema
```javascript
pm.test("Response matches schema", function () {
    var schema = {
        "type": "object",
        "properties": {
            "success": {"type": "boolean"},
            "data": {"type": "array"}
        },
        "required": ["success", "data"]
    };
    pm.response.to.have.jsonSchema(schema);
});
```

### Validate Array Length
```javascript
pm.test("Returns at least one package", function () {
    var jsonData = pm.response.json();
    pm.expect(jsonData.data.length).to.be.at.least(1);
});
```

### Check Data Types
```javascript
pm.test("All prices are numbers", function () {
    var jsonData = pm.response.json();
    jsonData.data.forEach(pkg => {
        pm.expect(pkg.price).to.be.a('number');
    });
});
```

This comprehensive Postman guide provides everything you need to thoroughly test your API endpoints, including authentication, error cases, and edge scenarios.


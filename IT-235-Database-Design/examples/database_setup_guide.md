# IT-235 Database Setup Guide

## 🎯 Purpose
Complete setup guide for database design, implementation, and management using MySQL and MongoDB.

## 🗄️ MySQL Setup

### Installation
**Windows:**
```bash
# Using Chocolatey
choco install mysql

# Or download from: https://dev.mysql.com/downloads/mysql/
# Choose MySQL Community Server
```

**Mac:**
```bash
# Using Homebrew
brew install mysql

# Start MySQL service
brew services start mysql
```

**Linux (Ubuntu/Debian):**
```bash
# Update package list
sudo apt update

# Install MySQL
sudo apt install mysql-server

# Start MySQL service
sudo systemctl start mysql
sudo systemctl enable mysql
```

### Initial Configuration
```bash
# Secure installation (set root password)
sudo mysql_secure_installation

# Login to MySQL
mysql -u root -p

# Create database for IT-235
CREATE DATABASE it235_database;
USE it235_database;

# Create user for development
CREATE USER 'it235_user'@'localhost' IDENTIFIED BY 'secure_password';
GRANT ALL PRIVILEGES ON it235_database.* TO 'it235_user'@'localhost';
FLUSH PRIVILEGES;
```

### MySQL Workbench Setup
**Installation:**
- Download: https://dev.mysql.com/downloads/workbench/
- Free GUI tool for MySQL management
- Visual database design and query editor

**Connection Setup:**
1. Open MySQL Workbench
2. Click "+" to create new connection
3. Enter connection details:
   - Connection Name: IT-235 Local
   - Hostname: localhost
   - Port: 3306
   - Username: it235_user
   - Password: [your password]

### Essential MySQL Commands
```sql
-- Show databases
SHOW DATABASES;

-- Use specific database
USE it235_database;

-- Show tables
SHOW TABLES;

-- Describe table structure
DESCRIBE table_name;

-- Show table creation statement
SHOW CREATE TABLE table_name;

-- Backup database
mysqldump -u root -p it235_database > backup.sql

-- Restore database
mysql -u root -p it235_database < backup.sql
```

## 🍃 MongoDB Setup

### Installation
**Windows:**
```bash
# Using Chocolatey
choco install mongodb

# Or download from: https://www.mongodb.com/try/download/community
```

**Mac:**
```bash
# Using Homebrew
brew tap mongodb/brew
brew install mongodb-community

# Start MongoDB
brew services start mongodb/brew/mongodb-community
```

**Linux:**
```bash
# Import MongoDB public key
wget -qO - https://www.mongodb.org/static/pgp/server-6.0.asc | sudo apt-key add -

# Add MongoDB repository
echo "deb [ arch=amd64,arm64 ] https://repo.mongodb.org/apt/ubuntu focal/mongodb-org/6.0 multiverse" | sudo tee /etc/apt/sources.list.d/mongodb-org-6.0.list

# Install MongoDB
sudo apt-get update
sudo apt-get install -y mongodb-org

# Start MongoDB
sudo systemctl start mongod
sudo systemctl enable mongod
```

### MongoDB Compass Setup
**Installation:**
- Download: https://www.mongodb.com/products/compass
- GUI tool for MongoDB management
- Visual query builder and data explorer

**Connection Setup:**
1. Open MongoDB Compass
2. Default connection: mongodb://localhost:27017
3. Click "Connect" to connect to local MongoDB

### Essential MongoDB Commands
```javascript
// Connect to MongoDB shell
mongosh

// Show databases
show dbs

// Use specific database
use it235_database

// Show collections
show collections

// Insert document
db.users.insertOne({
  name: "John Doe",
  email: "john@example.com",
  age: 30
});

// Find documents
db.users.find();
db.users.findOne({name: "John Doe"});

// Update document
db.users.updateOne(
  {name: "John Doe"},
  {$set: {age: 31}}
);

// Delete document
db.users.deleteOne({name: "John Doe"});
```

## 🎨 Database Design Tools

### ERD Design Tools
**Lucidchart:**
- Website: https://www.lucidchart.com/
- Free tier available
- Collaborative ERD design
- Export to various formats

**Draw.io (now diagrams.net):**
- Website: https://app.diagrams.net/
- Completely free
- Offline capability
- Integration with Google Drive, OneDrive

**MySQL Workbench:**
- Built-in ERD designer
- Forward/Reverse engineering
- Synchronize with database

### Database Modeling Process
1. **Requirements Analysis**
   - Identify entities and relationships
   - Document business rules
   - Define data requirements

2. **Conceptual Design**
   - Create Entity-Relationship Diagram (ERD)
   - Define entities, attributes, relationships
   - Identify primary and foreign keys

3. **Logical Design**
   - Convert ERD to relational model
   - Normalize database design
   - Define constraints and indexes

4. **Physical Design**
   - Choose data types
   - Optimize for performance
   - Plan storage and indexing

## 📊 Database Design Examples

### E-Commerce Database Schema
```sql
-- Customers table
CREATE TABLE customers (
    customer_id INT PRIMARY KEY AUTO_INCREMENT,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    phone VARCHAR(20),
    address VARCHAR(255),
    city VARCHAR(50),
    state VARCHAR(50),
    zip_code VARCHAR(10),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Products table
CREATE TABLE products (
    product_id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100) NOT NULL,
    description TEXT,
    price DECIMAL(10,2) NOT NULL,
    category_id INT,
    stock_quantity INT DEFAULT 0,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (category_id) REFERENCES categories(category_id)
);

-- Categories table
CREATE TABLE categories (
    category_id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(50) NOT NULL,
    description TEXT
);

-- Orders table
CREATE TABLE orders (
    order_id INT PRIMARY KEY AUTO_INCREMENT,
    customer_id INT NOT NULL,
    order_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    total_amount DECIMAL(10,2) NOT NULL,
    status ENUM('pending', 'processing', 'shipped', 'delivered', 'cancelled') DEFAULT 'pending',
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id)
);

-- Order items table
CREATE TABLE order_items (
    order_item_id INT PRIMARY KEY AUTO_INCREMENT,
    order_id INT NOT NULL,
    product_id INT NOT NULL,
    quantity INT NOT NULL,
    unit_price DECIMAL(10,2) NOT NULL,
    FOREIGN KEY (order_id) REFERENCES orders(order_id),
    FOREIGN KEY (product_id) REFERENCES products(product_id)
);
```

### MongoDB Document Design
```javascript
// Customer document
{
  _id: ObjectId("507f1f77bcf86cd799439011"),
  customer_id: "CUST001",
  personal_info: {
    first_name: "John",
    last_name: "Doe",
    email: "john@example.com",
    phone: "+1-555-0123"
  },
  address: {
    street: "123 Main St",
    city: "Anytown",
    state: "CA",
    zip_code: "12345"
  },
  orders: [
    {
      order_id: "ORD001",
      order_date: ISODate("2023-01-15T10:30:00Z"),
      items: [
        {
          product_id: "PROD001",
          name: "Laptop",
          quantity: 1,
          unit_price: 999.99
        }
      ],
      total_amount: 999.99,
      status: "delivered"
    }
  ],
  created_at: ISODate("2023-01-01T00:00:00Z")
}
```

## 🔧 Database Development Tools

### SQL Development
**VS Code Extensions:**
- **MySQL**: MySQL syntax highlighting
- **SQL Server (mssql)**: SQL Server support
- **PostgreSQL**: PostgreSQL support
- **SQLTools**: Database management

**DBeaver:**
- Download: https://dbeaver.io/
- Universal database tool
- Free and open source
- Supports MySQL, PostgreSQL, MongoDB, etc.

### Database Testing
**Test Data Generation:**
```sql
-- Insert test customers
INSERT INTO customers (first_name, last_name, email, phone) VALUES
('John', 'Doe', 'john@example.com', '555-0101'),
('Jane', 'Smith', 'jane@example.com', '555-0102'),
('Bob', 'Johnson', 'bob@example.com', '555-0103');

-- Insert test products
INSERT INTO products (name, description, price, category_id) VALUES
('Laptop', 'High-performance laptop', 999.99, 1),
('Mouse', 'Wireless mouse', 29.99, 2),
('Keyboard', 'Mechanical keyboard', 79.99, 2);
```

**Performance Testing:**
```sql
-- Analyze query performance
EXPLAIN SELECT * FROM customers WHERE email = 'john@example.com';

-- Check index usage
SHOW INDEX FROM customers;

-- Monitor slow queries
SHOW VARIABLES LIKE 'slow_query_log';
SET GLOBAL slow_query_log = 'ON';
```

## 📚 Learning Resources

### Database Design
- **Database Design Tutorial**: https://www.studytonight.com/dbms/
- **Normalization Guide**: https://www.guru99.com/database-normalization.html
- **ERD Tutorial**: https://www.lucidchart.com/pages/er-diagrams
- **SQL Tutorial**: https://www.w3schools.com/sql/

### MySQL
- **MySQL Documentation**: https://dev.mysql.com/doc/
- **MySQL Tutorial**: https://www.mysqltutorial.org/
- **MySQL Workbench Guide**: https://dev.mysql.com/doc/workbench/en/
- **MySQL Performance Tuning**: https://dev.mysql.com/doc/refman/8.0/en/optimization.html

### MongoDB
- **MongoDB Documentation**: https://docs.mongodb.com/
- **MongoDB University**: https://university.mongodb.com/
- **MongoDB Compass Guide**: https://docs.mongodb.com/compass/
- **MongoDB Best Practices**: https://docs.mongodb.com/manual/core/best-practices/

### Database Security
- **OWASP Database Security**: https://owasp.org/www-project-database-security/
- **MySQL Security Guide**: https://dev.mysql.com/doc/refman/8.0/en/security.html
- **MongoDB Security**: https://docs.mongodb.com/manual/security/

## 🎯 IT-235 Project Checklist

### Phase 1: Requirements Analysis
- [ ] Identify business requirements
- [ ] Document data requirements
- [ ] Identify entities and relationships
- [ ] Define business rules

### Phase 2: Conceptual Design
- [ ] Create Entity-Relationship Diagram
- [ ] Define entity attributes
- [ ] Identify primary and foreign keys
- [ ] Document relationships and cardinalities

### Phase 3: Logical Design
- [ ] Convert ERD to relational model
- [ ] Apply normalization (1NF, 2NF, 3NF)
- [ ] Define constraints and indexes
- [ ] Optimize for performance

### Phase 4: Physical Implementation
- [ ] Set up MySQL/MongoDB environment
- [ ] Create database schema
- [ ] Implement tables/collections
- [ ] Add sample data
- [ ] Test queries and performance

### Phase 5: Documentation
- [ ] Document database design decisions
- [ ] Create data dictionary
- [ ] Document relationships
- [ ] Provide sample queries
- [ ] Create user guide

## 💡 Pro Tips

1. **Start Simple**: Begin with basic entities and add complexity gradually
2. **Normalize Properly**: Follow normalization rules to avoid data redundancy
3. **Use Meaningful Names**: Choose clear, descriptive table and column names
4. **Document Everything**: Keep detailed documentation of design decisions
5. **Test Early**: Create test data and validate queries early
6. **Consider Performance**: Plan for indexing and query optimization
7. **Security First**: Implement proper access controls and data validation
8. **Backup Regularly**: Set up automated backup procedures
9. **Version Control**: Track database schema changes
10. **Review and Refactor**: Regularly review and improve database design

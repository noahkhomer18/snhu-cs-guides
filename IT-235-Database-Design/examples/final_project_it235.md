# IT-235 Final Project — Cougar Pizza Pies

## 📋 Business Scenario
Cougar Pizza Pies needs a relational database to manage customers, employees, menu items, and orders efficiently.  

## 📑 Deliverables
1. **Requirements Document**: Entities, attributes, business rules.  
2. **ERD**: Crow's Foot diagram showing all relationships.  
3. **Normalized Schema**: 1NF → 2NF → 3NF tables.  
4. **SQL Implementation**: CREATE TABLE statements with PKs & FKs.  
5. **Sample Data & Queries**: Insert data, run SELECT queries.  
6. **Reflection**: Lessons learned & design trade-offs.  

## 📊 Final ERD (Summary)
- **Customer** ↔ **Order** (1:M)  
- **Order** ↔ **OrderDetail** (1:M)  
- **OrderDetail** ↔ **MenuItem** (M:1)  
- **Employee** ↔ **Order** (1:M)  

## 📝 Example SQL
```sql
CREATE TABLE Customer (
  CustomerID INT PRIMARY KEY,
  Name VARCHAR(50),
  Phone VARCHAR(20)
);

CREATE TABLE OrderTbl (
  OrderID INT PRIMARY KEY,
  CustomerID INT,
  EmployeeID INT,
  OrderDate DATE,
  FOREIGN KEY (CustomerID) REFERENCES Customer(CustomerID),
  FOREIGN KEY (EmployeeID) REFERENCES Employee(EmployeeID)
);
```

## 🎯 Reflection

This project showed the importance of normalization for avoiding redundancy. At first, customer phone numbers were repeated in every order row — normalization fixed this.
ERDs made it easier to visualize many-to-many relationships, especially between orders and menu items.
Next time, more time should be spent on indexing queries for performance.

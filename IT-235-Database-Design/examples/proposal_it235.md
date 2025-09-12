# IT-235 Database Design — Project Proposal (Milestone One)

## 📋 Purpose
The goal of this database is to support a small business (Cougar Pizza Pies) in tracking customers, orders, employees, and menu items in a structured and efficient way.

## 🎯 Goals & Objectives
- Organize customer data (name, phone, address).  
- Track orders, including multiple items per order.  
- Track employees (delivery drivers, cashiers).  
- Ensure menu can be updated without breaking order history.  

## 📐 Business Rules
1. A customer can place many orders; an order belongs to one customer.  
2. Each order can contain multiple menu items.  
3. Employees are linked to orders (who took the order, who delivered it).  
4. Menu items have prices that can change over time.  

## 📑 Scope
- Entities: Customer, Order, Employee, MenuItem, OrderDetail.  
- Attributes: customerName, customerPhone, employeeName, itemPrice, orderDate, etc.  
- Deliverables: ERD, normalized schema, SQL tables, sample queries.  

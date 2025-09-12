# IT-235 ERD Sample (Cougar Pizza Pies)

## 📊 Crow's Foot ERD

Entities:
- **Customer** (CustomerID PK, Name, Phone, Address)  
- **Order** (OrderID PK, CustomerID FK, EmployeeID FK, OrderDate, Total)  
- **Employee** (EmployeeID PK, Name, Role)  
- **MenuItem** (ItemID PK, Name, Price)  
- **OrderDetail** (OrderDetailID PK, OrderID FK, ItemID FK, Quantity, LineTotal)  

### Relationships
- One **Customer** → Many **Orders**  
- One **Order** → Many **OrderDetails**  
- One **MenuItem** → Many **OrderDetails**  
- One **Employee** → Many **Orders**  

### Notes
- Crow's Foot notation used to represent 1-to-many relationships.  
- OrderDetail resolves many-to-many between Orders and MenuItems.  

![ERD Sample](https://user-images.githubusercontent.com/example/erd-it235.png)  

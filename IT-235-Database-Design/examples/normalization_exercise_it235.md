# IT-235 Normalization Exercise

## 🚫 Initial Unnormalized Table
| OrderID | CustomerName | CustomerPhone | Item1 | Item2 | Item3 |
|---------|--------------|---------------|-------|-------|-------|
| 101 | Alice | 555-1234 | Pizza | Coke | NULL |
| 102 | Bob   | 555-5678 | Burger | Fries | Shake |

### Problems
- Repeated groups (Item1, Item2, Item3).  
- Data anomalies if phone number changes.  
- Hard to query items by order.  

---

## ✅ Step 1: First Normal Form (1NF)
Split repeating groups into rows.

| OrderID | CustomerName | CustomerPhone | Item |
|---------|--------------|---------------|------|
| 101 | Alice | 555-1234 | Pizza |
| 101 | Alice | 555-1234 | Coke |
| 102 | Bob   | 555-5678 | Burger |

---

## ✅ Step 2: Second Normal Form (2NF)
Remove partial dependency (Customer data tied to OrderID).

- Customer(CustomerID PK, Name, Phone)  
- Order(OrderID PK, CustomerID FK, Date)  
- OrderItem(OrderID FK, ItemID FK)  
- Item(ItemID PK, Name, Price)  

---

## ✅ Step 3: Third Normal Form (3NF)
Remove transitive dependencies.

- Employee table separated if employees tied to orders.  
- Prices stored in MenuItem; totals computed at runtime.  

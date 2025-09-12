# IT-315 UML Diagrams and OOAD

## 🎯 Purpose
Demonstrate UML diagram creation and object-oriented analysis and design principles.

## 📝 UML Diagram Examples

### Class Diagram
```mermaid
classDiagram
    class User {
        -String userId
        -String username
        -String email
        -String password
        -Date createdAt
        +User(String username, String email)
        +login(String password) boolean
        +logout() void
        +updateProfile(String email) void
        +changePassword(String oldPass, String newPass) boolean
    }
    
    class Order {
        -String orderId
        -Date orderDate
        -OrderStatus status
        -double totalAmount
        -User customer
        -List~OrderItem~ items
        +Order(User customer)
        +addItem(Product product, int quantity) void
        +removeItem(String productId) void
        +calculateTotal() double
        +updateStatus(OrderStatus status) void
    }
    
    class Product {
        -String productId
        -String name
        -String description
        -double price
        -int stockQuantity
        -Category category
        +Product(String name, double price)
        +updatePrice(double newPrice) void
        +updateStock(int quantity) void
        +isAvailable() boolean
    }
    
    class OrderItem {
        -String itemId
        -Product product
        -int quantity
        -double unitPrice
        +OrderItem(Product product, int quantity)
        +calculateSubtotal() double
        +updateQuantity(int newQuantity) void
    }
    
    class Category {
        -String categoryId
        -String name
        -String description
        -List~Product~ products
        +Category(String name)
        +addProduct(Product product) void
        +removeProduct(String productId) void
    }
    
    class Payment {
        -String paymentId
        -PaymentMethod method
        -double amount
        -PaymentStatus status
        -Date paymentDate
        +Payment(PaymentMethod method, double amount)
        +processPayment() boolean
        +refund() boolean
    }
    
    User ||--o{ Order : places
    Order ||--o{ OrderItem : contains
    OrderItem }o--|| Product : references
    Product }o--|| Category : belongs to
    Order ||--|| Payment : has
```

### Sequence Diagram
```mermaid
sequenceDiagram
    participant Customer
    participant WebApp
    participant OrderService
    participant PaymentService
    participant InventoryService
    participant EmailService
    
    Customer->>WebApp: Browse products
    WebApp->>InventoryService: Get product list
    InventoryService-->>WebApp: Return products
    WebApp-->>Customer: Display products
    
    Customer->>WebApp: Add to cart
    WebApp->>InventoryService: Check availability
    InventoryService-->>WebApp: Product available
    WebApp-->>Customer: Item added to cart
    
    Customer->>WebApp: Place order
    WebApp->>OrderService: Create order
    OrderService->>InventoryService: Reserve items
    InventoryService-->>OrderService: Items reserved
    OrderService-->>WebApp: Order created
    
    WebApp->>PaymentService: Process payment
    PaymentService-->>WebApp: Payment successful
    WebApp->>OrderService: Confirm order
    OrderService->>InventoryService: Update inventory
    OrderService->>EmailService: Send confirmation
    EmailService-->>Customer: Order confirmation email
    WebApp-->>Customer: Order confirmed
```

### Use Case Diagram
```mermaid
graph TB
    subgraph "E-commerce System"
        UC1[Browse Products]
        UC2[Search Products]
        UC3[Add to Cart]
        UC4[Place Order]
        UC5[Make Payment]
        UC6[Track Order]
        UC7[Manage Profile]
        UC8[View Order History]
        UC9[Manage Inventory]
        UC10[Process Orders]
        UC11[Generate Reports]
    end
    
    subgraph "Actors"
        Customer[Customer]
        Admin[Administrator]
        Guest[Guest User]
    end
    
    Customer --> UC1
    Customer --> UC2
    Customer --> UC3
    Customer --> UC4
    Customer --> UC5
    Customer --> UC6
    Customer --> UC7
    Customer --> UC8
    
    Guest --> UC1
    Guest --> UC2
    
    Admin --> UC9
    Admin --> UC10
    Admin --> UC11
    
    UC3 --> UC1
    UC4 --> UC3
    UC5 --> UC4
    UC6 --> UC4
```

### Activity Diagram
```mermaid
flowchart TD
    Start([Start]) --> Login{User Logged In?}
    Login -->|No| LoginPage[Login Page]
    LoginPage --> LoginProcess[Enter Credentials]
    LoginProcess --> Validate{Valid Credentials?}
    Validate -->|No| LoginError[Show Error Message]
    LoginError --> LoginProcess
    Validate -->|Yes| Dashboard[Dashboard]
    Login -->|Yes| Dashboard
    
    Dashboard --> Browse[Browse Products]
    Browse --> SelectProduct[Select Product]
    SelectProduct --> AddToCart[Add to Cart]
    AddToCart --> Continue{Continue Shopping?}
    Continue -->|Yes| Browse
    Continue -->|No| Checkout[Proceed to Checkout]
    
    Checkout --> ReviewOrder[Review Order]
    ReviewOrder --> Payment[Enter Payment Info]
    Payment --> ProcessPayment[Process Payment]
    ProcessPayment --> PaymentSuccess{Payment Successful?}
    PaymentSuccess -->|No| PaymentError[Payment Error]
    PaymentError --> Payment
    PaymentSuccess -->|Yes| ConfirmOrder[Confirm Order]
    ConfirmOrder --> SendEmail[Send Confirmation Email]
    SendEmail --> End([End])
```

### State Diagram
```mermaid
stateDiagram-v2
    [*] --> Pending : Order Created
    
    Pending --> Confirmed : Payment Received
    Pending --> Cancelled : Customer Cancels
    Pending --> Cancelled : Payment Failed
    
    Confirmed --> Processing : Start Processing
    Confirmed --> Cancelled : Customer Cancels
    
    Processing --> Shipped : Items Shipped
    Processing --> Cancelled : Unable to Fulfill
    
    Shipped --> Delivered : Package Delivered
    Shipped --> Returned : Customer Returns
    
    Delivered --> Completed : Order Complete
    Delivered --> Returned : Customer Returns
    
    Returned --> Refunded : Refund Processed
    Refunded --> [*]
    
    Completed --> [*]
    Cancelled --> [*]
```

### Component Diagram
```mermaid
graph TB
    subgraph "Frontend Layer"
        WebUI[Web Interface]
        MobileUI[Mobile Interface]
    end
    
    subgraph "Application Layer"
        UserController[User Controller]
        OrderController[Order Controller]
        ProductController[Product Controller]
        PaymentController[Payment Controller]
    end
    
    subgraph "Service Layer"
        UserService[User Service]
        OrderService[Order Service]
        ProductService[Product Service]
        PaymentService[Payment Service]
        EmailService[Email Service]
    end
    
    subgraph "Data Layer"
        UserRepository[User Repository]
        OrderRepository[Order Repository]
        ProductRepository[Product Repository]
        PaymentRepository[Payment Repository]
    end
    
    subgraph "External Systems"
        PaymentGateway[Payment Gateway]
        EmailProvider[Email Provider]
        InventorySystem[Inventory System]
    end
    
    WebUI --> UserController
    WebUI --> OrderController
    WebUI --> ProductController
    WebUI --> PaymentController
    
    MobileUI --> UserController
    MobileUI --> OrderController
    MobileUI --> ProductController
    MobileUI --> PaymentController
    
    UserController --> UserService
    OrderController --> OrderService
    ProductController --> ProductService
    PaymentController --> PaymentService
    
    UserService --> UserRepository
    OrderService --> OrderRepository
    ProductService --> ProductRepository
    PaymentService --> PaymentRepository
    
    OrderService --> EmailService
    PaymentService --> PaymentGateway
    EmailService --> EmailProvider
    ProductService --> InventorySystem
```

## 🔍 OOAD Principles

### SOLID Principles
1. **Single Responsibility**: Each class has one reason to change
2. **Open/Closed**: Open for extension, closed for modification
3. **Liskov Substitution**: Derived classes must be substitutable for base classes
4. **Interface Segregation**: Clients shouldn't depend on unused interfaces
5. **Dependency Inversion**: Depend on abstractions, not concretions

### Design Patterns
- **Factory Pattern**: Create objects without specifying exact classes
- **Observer Pattern**: Define one-to-many dependency between objects
- **Strategy Pattern**: Define family of algorithms and make them interchangeable
- **Singleton Pattern**: Ensure class has only one instance

## 💡 Learning Points
- UML diagrams provide visual representation of system design
- Class diagrams show static structure and relationships
- Sequence diagrams illustrate dynamic interactions
- Use case diagrams capture functional requirements
- Activity diagrams model business processes
- State diagrams show object lifecycle
- Component diagrams show system architecture

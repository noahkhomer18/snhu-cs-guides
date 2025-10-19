# IT-315 Object-Oriented Analysis & Design: Design Patterns

## 🎯 Purpose
Comprehensive guide to design patterns in object-oriented analysis and design, including practical examples and implementation strategies.

## 📝 Design Pattern Examples

### Example 1: Singleton Pattern

**Problem**: Ensure only one instance of a database connection manager exists throughout the application.

**Solution**:
```java
public class DatabaseConnectionManager {
    private static DatabaseConnectionManager instance;
    private Connection connection;
    
    // Private constructor to prevent instantiation
    private DatabaseConnectionManager() {
        try {
            this.connection = DriverManager.getConnection(
                "jdbc:mysql://localhost:3306/mydb",
                "username", "password"
            );
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
    
    // Public method to get the single instance
    public static synchronized DatabaseConnectionManager getInstance() {
        if (instance == null) {
            instance = new DatabaseConnectionManager();
        }
        return instance;
    }
    
    public Connection getConnection() {
        return connection;
    }
    
    public void closeConnection() {
        try {
            if (connection != null && !connection.isClosed()) {
                connection.close();
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
}

// Usage
public class Main {
    public static void main(String[] args) {
        DatabaseConnectionManager dbManager = DatabaseConnectionManager.getInstance();
        Connection conn = dbManager.getConnection();
        // Use connection...
    }
}
```

### Example 2: Factory Pattern

**Problem**: Create different types of vehicles without exposing the creation logic to the client.

**Solution**:
```java
// Abstract Product
public abstract class Vehicle {
    protected String brand;
    protected String model;
    protected int year;
    
    public abstract void start();
    public abstract void stop();
    public abstract void accelerate();
}

// Concrete Products
public class Car extends Vehicle {
    public Car(String brand, String model, int year) {
        this.brand = brand;
        this.model = model;
        this.year = year;
    }
    
    @Override
    public void start() {
        System.out.println("Car engine started");
    }
    
    @Override
    public void stop() {
        System.out.println("Car engine stopped");
    }
    
    @Override
    public void accelerate() {
        System.out.println("Car accelerating");
    }
}

public class Motorcycle extends Vehicle {
    public Motorcycle(String brand, String model, int year) {
        this.brand = brand;
        this.model = model;
        this.year = year;
    }
    
    @Override
    public void start() {
        System.out.println("Motorcycle engine started");
    }
    
    @Override
    public void stop() {
        System.out.println("Motorcycle engine stopped");
    }
    
    @Override
    public void accelerate() {
        System.out.println("Motorcycle accelerating");
    }
}

// Factory Interface
public interface VehicleFactory {
    Vehicle createVehicle(String type, String brand, String model, int year);
}

// Concrete Factory
public class VehicleFactoryImpl implements VehicleFactory {
    @Override
    public Vehicle createVehicle(String type, String brand, String model, int year) {
        switch (type.toLowerCase()) {
            case "car":
                return new Car(brand, model, year);
            case "motorcycle":
                return new Motorcycle(brand, model, year);
            default:
                throw new IllegalArgumentException("Unknown vehicle type: " + type);
        }
    }
}

// Usage
public class Main {
    public static void main(String[] args) {
        VehicleFactory factory = new VehicleFactoryImpl();
        
        Vehicle car = factory.createVehicle("car", "Toyota", "Camry", 2023);
        Vehicle motorcycle = factory.createVehicle("motorcycle", "Honda", "CBR", 2023);
        
        car.start();
        motorcycle.start();
    }
}
```

### Example 3: Observer Pattern

**Problem**: Implement a notification system where multiple subscribers can receive updates when a news agency publishes new articles.

**Solution**:
```java
import java.util.ArrayList;
import java.util.List;

// Subject Interface
public interface NewsAgency {
    void addObserver(NewsObserver observer);
    void removeObserver(NewsObserver observer);
    void notifyObservers();
}

// Observer Interface
public interface NewsObserver {
    void update(String news);
}

// Concrete Subject
public class NewsAgencyImpl implements NewsAgency {
    private List<NewsObserver> observers;
    private String latestNews;
    
    public NewsAgencyImpl() {
        this.observers = new ArrayList<>();
    }
    
    @Override
    public void addObserver(NewsObserver observer) {
        observers.add(observer);
    }
    
    @Override
    public void removeObserver(NewsObserver observer) {
        observers.remove(observer);
    }
    
    @Override
    public void notifyObservers() {
        for (NewsObserver observer : observers) {
            observer.update(latestNews);
        }
    }
    
    public void publishNews(String news) {
        this.latestNews = news;
        notifyObservers();
    }
}

// Concrete Observers
public class EmailSubscriber implements NewsObserver {
    private String email;
    
    public EmailSubscriber(String email) {
        this.email = email;
    }
    
    @Override
    public void update(String news) {
        System.out.println("Email to " + email + ": " + news);
    }
}

public class SMSSubscriber implements NewsObserver {
    private String phoneNumber;
    
    public SMSSubscriber(String phoneNumber) {
        this.phoneNumber = phoneNumber;
    }
    
    @Override
    public void update(String news) {
        System.out.println("SMS to " + phoneNumber + ": " + news);
    }
}

// Usage
public class Main {
    public static void main(String[] args) {
        NewsAgency newsAgency = new NewsAgencyImpl();
        
        NewsObserver emailSubscriber = new EmailSubscriber("user@example.com");
        NewsObserver smsSubscriber = new SMSSubscriber("+1234567890");
        
        newsAgency.addObserver(emailSubscriber);
        newsAgency.addObserver(smsSubscriber);
        
        newsAgency.publishNews("Breaking: New technology breakthrough!");
    }
}
```

## 🔍 Design Pattern Categories

### Creational Patterns
| Pattern | Purpose | Use When |
|---------|---------|----------|
| Singleton | Ensure single instance | Database connections, logging |
| Factory | Create objects without specifying classes | Multiple product types |
| Builder | Construct complex objects step by step | Complex object creation |
| Prototype | Clone existing objects | Expensive object creation |
| Abstract Factory | Create families of related objects | Multiple product families |

### Structural Patterns
| Pattern | Purpose | Use When |
|---------|---------|----------|
| Adapter | Make incompatible interfaces work together | Legacy system integration |
| Decorator | Add behavior to objects dynamically | Extending functionality |
| Facade | Provide simplified interface to complex subsystem | Complex system access |
| Proxy | Control access to objects | Lazy loading, access control |
| Composite | Treat individual and composite objects uniformly | Tree structures |

### Behavioral Patterns
| Pattern | Purpose | Use When |
|---------|---------|----------|
| Observer | Define one-to-many dependency | Event handling, notifications |
| Strategy | Define family of algorithms | Multiple ways to perform task |
| Command | Encapsulate requests as objects | Undo/redo functionality |
| State | Allow object to alter behavior when state changes | State-dependent behavior |
| Template Method | Define algorithm skeleton | Common algorithm with variations |

## 🛠️ Advanced Design Pattern Examples

### Example 4: Strategy Pattern

**Problem**: Implement different payment processing strategies for an e-commerce system.

**Solution**:
```java
// Strategy Interface
public interface PaymentStrategy {
    void processPayment(double amount);
}

// Concrete Strategies
public class CreditCardPayment implements PaymentStrategy {
    private String cardNumber;
    private String expiryDate;
    private String cvv;
    
    public CreditCardPayment(String cardNumber, String expiryDate, String cvv) {
        this.cardNumber = cardNumber;
        this.expiryDate = expiryDate;
        this.cvv = cvv;
    }
    
    @Override
    public void processPayment(double amount) {
        System.out.println("Processing credit card payment of $" + amount);
        // Credit card processing logic
    }
}

public class PayPalPayment implements PaymentStrategy {
    private String email;
    private String password;
    
    public PayPalPayment(String email, String password) {
        this.email = email;
        this.password = password;
    }
    
    @Override
    public void processPayment(double amount) {
        System.out.println("Processing PayPal payment of $" + amount);
        // PayPal processing logic
    }
}

public class BankTransferPayment implements PaymentStrategy {
    private String accountNumber;
    private String routingNumber;
    
    public BankTransferPayment(String accountNumber, String routingNumber) {
        this.accountNumber = accountNumber;
        this.routingNumber = routingNumber;
    }
    
    @Override
    public void processPayment(double amount) {
        System.out.println("Processing bank transfer of $" + amount);
        // Bank transfer logic
    }
}

// Context Class
public class PaymentProcessor {
    private PaymentStrategy paymentStrategy;
    
    public void setPaymentStrategy(PaymentStrategy paymentStrategy) {
        this.paymentStrategy = paymentStrategy;
    }
    
    public void processPayment(double amount) {
        if (paymentStrategy != null) {
            paymentStrategy.processPayment(amount);
        } else {
            throw new IllegalStateException("Payment strategy not set");
        }
    }
}

// Usage
public class Main {
    public static void main(String[] args) {
        PaymentProcessor processor = new PaymentProcessor();
        
        // Credit card payment
        processor.setPaymentStrategy(new CreditCardPayment("1234-5678-9012-3456", "12/25", "123"));
        processor.processPayment(100.0);
        
        // PayPal payment
        processor.setPaymentStrategy(new PayPalPayment("user@example.com", "password"));
        processor.processPayment(50.0);
    }
}
```

### Example 5: Decorator Pattern

**Problem**: Add additional features to a basic coffee order without modifying the original coffee class.

**Solution**:
```java
// Component Interface
public abstract class Coffee {
    protected String description;
    protected double cost;
    
    public abstract String getDescription();
    public abstract double getCost();
}

// Concrete Component
public class BasicCoffee extends Coffee {
    public BasicCoffee() {
        this.description = "Basic Coffee";
        this.cost = 2.0;
    }
    
    @Override
    public String getDescription() {
        return description;
    }
    
    @Override
    public double getCost() {
        return cost;
    }
}

// Decorator Abstract Class
public abstract class CoffeeDecorator extends Coffee {
    protected Coffee coffee;
    
    public CoffeeDecorator(Coffee coffee) {
        this.coffee = coffee;
    }
    
    @Override
    public abstract String getDescription();
    
    @Override
    public abstract double getCost();
}

// Concrete Decorators
public class MilkDecorator extends CoffeeDecorator {
    public MilkDecorator(Coffee coffee) {
        super(coffee);
    }
    
    @Override
    public String getDescription() {
        return coffee.getDescription() + ", Milk";
    }
    
    @Override
    public double getCost() {
        return coffee.getCost() + 0.5;
    }
}

public class SugarDecorator extends CoffeeDecorator {
    public SugarDecorator(Coffee coffee) {
        super(coffee);
    }
    
    @Override
    public String getDescription() {
        return coffee.getDescription() + ", Sugar";
    }
    
    @Override
    public double getCost() {
        return coffee.getCost() + 0.2;
    }
}

public class WhippedCreamDecorator extends CoffeeDecorator {
    public WhippedCreamDecorator(Coffee coffee) {
        super(coffee);
    }
    
    @Override
    public String getDescription() {
        return coffee.getDescription() + ", Whipped Cream";
    }
    
    @Override
    public double getCost() {
        return coffee.getCost() + 0.8;
    }
}

// Usage
public class Main {
    public static void main(String[] args) {
        Coffee coffee = new BasicCoffee();
        System.out.println(coffee.getDescription() + " - $" + coffee.getCost());
        
        coffee = new MilkDecorator(coffee);
        System.out.println(coffee.getDescription() + " - $" + coffee.getCost());
        
        coffee = new SugarDecorator(coffee);
        System.out.println(coffee.getDescription() + " - $" + coffee.getCost());
        
        coffee = new WhippedCreamDecorator(coffee);
        System.out.println(coffee.getDescription() + " - $" + coffee.getCost());
    }
}
```

## 📊 Design Pattern Selection Guide

### When to Use Each Pattern

**Creational Patterns**:
- **Singleton**: When you need exactly one instance
- **Factory**: When you have multiple product types
- **Builder**: When object creation is complex
- **Prototype**: When object creation is expensive

**Structural Patterns**:
- **Adapter**: When integrating incompatible systems
- **Decorator**: When you need to add features dynamically
- **Facade**: When you need to simplify complex systems
- **Proxy**: When you need to control object access

**Behavioral Patterns**:
- **Observer**: When you need event notifications
- **Strategy**: When you have multiple algorithms
- **Command**: When you need to encapsulate requests
- **State**: When behavior depends on state

## 📋 Design Pattern Implementation Checklist

### Before Implementation
- [ ] Identify the problem that needs solving
- [ ] Choose the appropriate pattern
- [ ] Understand the pattern's structure
- [ ] Plan the implementation approach

### During Implementation
- [ ] Follow the pattern's structure
- [ ] Implement all required components
- [ ] Test the implementation
- [ ] Document the usage

### After Implementation
- [ ] Verify the pattern solves the problem
- [ ] Check for proper encapsulation
- [ ] Ensure extensibility
- [ ] Review for maintainability

## 🎯 IT-315 Learning Outcomes

### Technical Skills
- **Pattern Recognition**: Identifying when to use design patterns
- **Implementation**: Implementing patterns correctly
- **Code Organization**: Structuring code for maintainability
- **Problem Solving**: Applying patterns to solve design problems

### Professional Skills
- **System Design**: Creating flexible, maintainable systems
- **Code Quality**: Writing clean, well-structured code
- **Documentation**: Explaining design decisions
- **Collaboration**: Working with team members on design

## 💡 Pro Tips

1. **Start Simple**: Begin with basic patterns before advanced ones
2. **Understand the Problem**: Don't force patterns where they don't fit
3. **Practice Regularly**: Implement patterns in different contexts
4. **Study Real Examples**: Look at how patterns are used in frameworks
5. **Combine Patterns**: Learn how patterns work together
6. **Document Decisions**: Explain why you chose specific patterns
7. **Test Thoroughly**: Ensure patterns work as expected
8. **Refactor When Needed**: Don't be afraid to change patterns if requirements change

---

*This design patterns guide provides comprehensive examples and implementation strategies for IT-315 Object-Oriented Analysis & Design, helping students master essential design patterns for professional software development.*

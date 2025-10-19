# CS-255 Class Diagrams

## 🎯 Purpose
Demonstrate comprehensive class diagram creation for system analysis and design projects, showing system structure and relationships.

## 📝 Class Diagram Examples

### E-Commerce System Class Diagram

```mermaid
classDiagram
    class User {
        +String userId
        +String username
        +String email
        +String password
        +Date createdAt
        +login()
        +logout()
        +updateProfile()
    }
    
    class Customer {
        +String customerId
        +String firstName
        +String lastName
        +String phoneNumber
        +Address shippingAddress
        +Address billingAddress
        +addToCart()
        +placeOrder()
        +viewOrderHistory()
    }
    
    class Product {
        +String productId
        +String name
        +String description
        +Double price
        +Integer stockQuantity
        +String category
        +updateStock()
        +calculateDiscount()
    }
    
    class Order {
        +String orderId
        +Date orderDate
        +OrderStatus status
        +Double totalAmount
        +processPayment()
        +updateStatus()
        +calculateTotal()
    }
    
    class OrderItem {
        +String itemId
        +Integer quantity
        +Double unitPrice
        +Double subtotal
        +calculateSubtotal()
    }
    
    class Payment {
        +String paymentId
        +PaymentMethod method
        +Double amount
        +PaymentStatus status
        +processPayment()
        +refund()
    }
    
    class Address {
        +String street
        +String city
        +String state
        +String zipCode
        +String country
        +validateAddress()
    }
    
    User <|-- Customer
    Customer ||--o{ Order
    Order ||--o{ OrderItem
    Product ||--o{ OrderItem
    Order ||--|| Payment
    Customer ||--o{ Address
```

### Library Management System Class Diagram

```mermaid
classDiagram
    class Person {
        +String personId
        +String firstName
        +String lastName
        +String email
        +String phone
        +Date dateOfBirth
    }
    
    class Member {
        +String memberId
        +Date joinDate
        +MemberStatus status
        +Integer maxBooks
        +checkoutBook()
        +returnBook()
        +renewBook()
    }
    
    class Librarian {
        +String employeeId
        +String department
        +Date hireDate
        +addBook()
        +removeBook()
        +processReturn()
        +generateReport()
    }
    
    class Book {
        +String isbn
        +String title
        +String author
        +String publisher
        +Date publicationDate
        +BookStatus status
        +String location
        +checkAvailability()
        +updateStatus()
    }
    
    class Loan {
        +String loanId
        +Date checkoutDate
        +Date dueDate
        +Date returnDate
        +LoanStatus status
        +calculateFine()
        +extendLoan()
    }
    
    class Fine {
        +String fineId
        +Double amount
        +Date issueDate
        +FineStatus status
        +calculateAmount()
        +processPayment()
    }
    
    class Category {
        +String categoryId
        +String name
        +String description
        +addBook()
        +removeBook()
    }
    
    Person <|-- Member
    Person <|-- Librarian
    Member ||--o{ Loan
    Book ||--o{ Loan
    Loan ||--o{ Fine
    Book }o--|| Category
```

### Student Information System Class Diagram

```mermaid
classDiagram
    class Person {
        +String personId
        +String firstName
        +String lastName
        +String email
        +String phone
        +Date dateOfBirth
        +Address address
    }
    
    class Student {
        +String studentId
        +String major
        +Double gpa
        +StudentStatus status
        +Date enrollmentDate
        +registerForCourse()
        +dropCourse()
        +viewTranscript()
    }
    
    class Professor {
        +String employeeId
        +String department
        +String title
        +Date hireDate
        +createCourse()
        +assignGrade()
        +viewClassRoster()
    }
    
    class Course {
        +String courseId
        +String courseName
        +String description
        +Integer credits
        +String department
        +addStudent()
        +removeStudent()
        +calculateCapacity()
    }
    
    class Enrollment {
        +String enrollmentId
        +Date enrollmentDate
        +Grade grade
        +EnrollmentStatus status
        +calculateGPA()
    }
    
    class Department {
        +String departmentId
        +String name
        +String description
        +String head
        +addCourse()
        +removeCourse()
    }
    
    class Grade {
        +String gradeId
        +String letterGrade
        +Double numericGrade
        +Date assignedDate
        +calculateGPA()
    }
    
    Person <|-- Student
    Person <|-- Professor
    Student ||--o{ Enrollment
    Course ||--o{ Enrollment
    Professor ||--o{ Course
    Department ||--o{ Course
    Enrollment ||--|| Grade
```

## 🔍 Class Diagram Components

### 1. Classes
- **Name**: Class identifier
- **Attributes**: Properties of the class
- **Methods**: Operations the class can perform
- **Visibility**: Public (+), Private (-), Protected (#)

### 2. Relationships
- **Association**: General relationship between classes
- **Aggregation**: "Has-a" relationship (loose coupling)
- **Composition**: "Part-of" relationship (strong coupling)
- **Inheritance**: "Is-a" relationship
- **Dependency**: One class uses another

### 3. Multiplicity
- **1**: Exactly one
- **0..1**: Zero or one
- **1..***: One or more
- **0..***: Zero or more
- **n..m**: Between n and m

## 📊 Advanced Class Diagram Examples

### Banking System with Inheritance

```mermaid
classDiagram
    class Account {
        <<abstract>>
        +String accountNumber
        +Double balance
        +Date openDate
        +AccountStatus status
        +deposit(amount)
        +withdraw(amount)
        +getBalance()
        +close()
    }
    
    class CheckingAccount {
        +Double overdraftLimit
        +Boolean hasOverdraftProtection
        +processCheck()
        +applyOverdraftFee()
    }
    
    class SavingsAccount {
        +Double interestRate
        +Double minimumBalance
        +calculateInterest()
        +applyInterest()
    }
    
    class CreditAccount {
        +Double creditLimit
        +Double interestRate
        +Double minimumPayment
        +calculateInterest()
        +processPayment()
    }
    
    class Transaction {
        +String transactionId
        +Date transactionDate
        +TransactionType type
        +Double amount
        +String description
        +process()
        +reverse()
    }
    
    class Customer {
        +String customerId
        +String firstName
        +String lastName
        +String ssn
        +Date dateOfBirth
        +openAccount()
        +closeAccount()
        +viewAccounts()
    }
    
    Account <|-- CheckingAccount
    Account <|-- SavingsAccount
    Account <|-- CreditAccount
    Customer ||--o{ Account
    Account ||--o{ Transaction
```

### Hospital Management System

```mermaid
classDiagram
    class Person {
        +String personId
        +String firstName
        +String lastName
        +String email
        +String phone
        +Date dateOfBirth
        +Address address
    }
    
    class Patient {
        +String patientId
        +String insuranceNumber
        +PatientStatus status
        +Date admissionDate
        +scheduleAppointment()
        +viewMedicalHistory()
    }
    
    class Doctor {
        +String doctorId
        +String specialization
        +String licenseNumber
        +Date hireDate
        +diagnosePatient()
        +prescribeMedication()
        +scheduleSurgery()
    }
    
    class Nurse {
        +String nurseId
        +String department
        +String licenseNumber
        +assistDoctor()
        +monitorPatient()
        +administerMedication()
    }
    
    class Appointment {
        +String appointmentId
        +Date appointmentDate
        +Time appointmentTime
        +AppointmentType type
        +AppointmentStatus status
        +schedule()
        +cancel()
    }
    
    class MedicalRecord {
        +String recordId
        +Date recordDate
        +String diagnosis
        +String treatment
        +String notes
        +addEntry()
        +updateRecord()
    }
    
    class Prescription {
        +String prescriptionId
        +String medicationName
        +String dosage
        +Integer quantity
        +Date prescribedDate
        +PrescriptionStatus status
        +fillPrescription()
    }
    
    Person <|-- Patient
    Person <|-- Doctor
    Person <|-- Nurse
    Patient ||--o{ Appointment
    Doctor ||--o{ Appointment
    Patient ||--o{ MedicalRecord
    Doctor ||--o{ MedicalRecord
    Patient ||--o{ Prescription
    Doctor ||--o{ Prescription
```

## 🛠️ Class Diagram Best Practices

### 1. Design Principles
- **Single Responsibility**: Each class should have one reason to change
- **Open/Closed**: Open for extension, closed for modification
- **Liskov Substitution**: Subclasses should be substitutable for base classes
- **Interface Segregation**: Clients shouldn't depend on unused interfaces
- **Dependency Inversion**: Depend on abstractions, not concretions

### 2. Naming Conventions
- **Classes**: Use PascalCase (e.g., Customer, OrderItem)
- **Attributes**: Use camelCase (e.g., firstName, orderDate)
- **Methods**: Use camelCase with verbs (e.g., calculateTotal, processPayment)
- **Constants**: Use UPPER_CASE (e.g., MAX_ITEMS, DEFAULT_STATUS)

### 3. Relationship Guidelines
- **Use composition** for "part-of" relationships
- **Use aggregation** for "has-a" relationships
- **Use inheritance** for "is-a" relationships
- **Use association** for general relationships
- **Avoid deep inheritance** hierarchies (max 3-4 levels)

### 4. Documentation
- **Add comments** for complex methods
- **Document assumptions** and constraints
- **Include examples** for abstract concepts
- **Specify preconditions** and postconditions
- **Note performance** considerations

## 📋 Class Diagram Template

```markdown
# Class Diagram: [System Name]

## Purpose
[Brief description of what the class diagram shows]

## Key Classes
- **Class 1**: [Description and responsibilities]
- **Class 2**: [Description and responsibilities]
- **Class 3**: [Description and responsibilities]

## Relationships
- **Association**: [Description of associations]
- **Inheritance**: [Description of inheritance hierarchy]
- **Composition**: [Description of composition relationships]
- **Aggregation**: [Description of aggregation relationships]

## Design Patterns Used
- **Pattern 1**: [Description and implementation]
- **Pattern 2**: [Description and implementation]

## Notes
- [Important design decisions]
- [Performance considerations]
- [Security requirements]
```

## 🎯 CS-255 Learning Outcomes

### Technical Skills
- **Object-Oriented Design**: Understanding class relationships
- **System Architecture**: Modeling system structure
- **Design Patterns**: Applying common design patterns
- **Code Organization**: Structuring code for maintainability

### Professional Skills
- **System Documentation**: Creating clear structural diagrams
- **Design Communication**: Explaining system architecture
- **Requirements Analysis**: Understanding system structure
- **Code Review**: Evaluating design quality

## 💡 Pro Tips

1. **Start with Core Classes**: Identify the main entities first
2. **Add Relationships**: Define how classes interact
3. **Use Design Patterns**: Apply common patterns for better design
4. **Keep It Simple**: Avoid over-engineering
5. **Validate with Users**: Get feedback from stakeholders
6. **Iterate and Refine**: Class diagrams evolve with understanding
7. **Document Decisions**: Note important design choices
8. **Consider Performance**: Think about system performance implications

## 🔗 Related UML Diagrams

- **Use Case Diagrams**: Show system functionality
- **Sequence Diagrams**: Show object interactions
- **Activity Diagrams**: Show business processes
- **State Diagrams**: Show object state changes
- **Component Diagrams**: Show system architecture

---

*This class diagram guide provides comprehensive examples and best practices for CS-255 Systems Analysis and Design, helping students create professional-quality structural documentation.*

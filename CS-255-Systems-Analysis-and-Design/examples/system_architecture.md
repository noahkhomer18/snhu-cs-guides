# CS-255 System Architecture Design

## 🎯 Purpose
Demonstrate system architecture design patterns and documentation.

## 📝 Architecture Examples

### Three-Tier Architecture

#### E-commerce Platform Architecture
```
┌─────────────────────────────────────────────────────────┐
│                    Presentation Tier                    │
│  ┌─────────────┐ ┌─────────────┐ ┌─────────────┐      │
│  │   Web UI    │ │  Mobile App │ │ Admin Panel │      │
│  │   (React)   │ │  (React    │ │   (Vue.js)  │      │
│  │             │ │   Native)  │ │             │      │
│  └─────────────┘ └─────────────┘ └─────────────┘      │
└─────────────────────────────────────────────────────────┘
                            │
                            ▼
┌─────────────────────────────────────────────────────────┐
│                   Application Tier                      │
│  ┌─────────────┐ ┌─────────────┐ ┌─────────────┐      │
│  │   API       │ │  Auth       │ │  Payment    │      │
│  │  Gateway    │ │  Service    │ │  Service    │      │
│  │  (Express)  │ │  (Node.js)  │ │  (Node.js)  │      │
│  └─────────────┘ └─────────────┘ └─────────────┘      │
│  ┌─────────────┐ ┌─────────────┐ ┌─────────────┐      │
│  │  Product    │ │   Order     │ │  Inventory  │      │
│  │  Service    │ │  Service    │ │  Service    │      │
│  │  (Node.js)  │ │  (Node.js)  │ │  (Node.js)  │      │
│  └─────────────┘ └─────────────┘ └─────────────┘      │
└─────────────────────────────────────────────────────────┘
                            │
                            ▼
┌─────────────────────────────────────────────────────────┐
│                     Data Tier                           │
│  ┌─────────────┐ ┌─────────────┐ ┌─────────────┐      │
│  │ PostgreSQL  │ │    Redis    │ │   MongoDB   │      │
│  │ (Primary    │ │  (Cache &   │ │ (Product    │      │
│  │ Database)   │ │  Sessions)  │ │  Catalog)   │      │
│  └─────────────┘ └─────────────┘ └─────────────┘      │
└─────────────────────────────────────────────────────────┘
```

### Microservices Architecture

#### Hospital Management System
```
┌─────────────────────────────────────────────────────────┐
│                    API Gateway                          │
│              (Load Balancer & Routing)                  │
└─────────────────────────────────────────────────────────┘
                            │
        ┌───────────────────┼───────────────────┐
        │                   │                   │
        ▼                   ▼                   ▼
┌─────────────┐    ┌─────────────┐    ┌─────────────┐
│   Patient   │    │   Doctor    │    │  Appointment│
│   Service   │    │   Service   │    │   Service   │
│             │    │             │    │             │
│ - Patient   │    │ - Doctor    │    │ - Schedule  │
│   Records   │    │   Profiles  │    │ - Booking   │
│ - Medical   │    │ - Schedule  │    │ - Reminders │
│   History   │    │ - Patients  │    │             │
└─────────────┘    └─────────────┘    └─────────────┘
        │                   │                   │
        ▼                   ▼                   ▼
┌─────────────┐    ┌─────────────┐    ┌─────────────┐
│   Patient   │    │   Doctor    │    │ Appointment │
│  Database   │    │  Database   │    │  Database   │
│ (PostgreSQL)│    │ (PostgreSQL)│    │ (PostgreSQL)│
└─────────────┘    └─────────────┘    └─────────────┘
```

### Component Diagram

#### Library Management System Components
```
┌─────────────────────────────────────────────────────────┐
│                Library Management System                │
└─────────────────────────────────────────────────────────┘
                            │
        ┌───────────────────┼───────────────────┐
        │                   │                   │
        ▼                   ▼                   ▼
┌─────────────┐    ┌─────────────┐    ┌─────────────┐
│   User      │    │   Catalog   │    │ Circulation │
│ Management  │    │ Management  │    │ Management  │
│             │    │             │    │             │
│ - User      │    │ - Book      │    │ - Check-out │
│   Registration│  │   Catalog   │    │ - Check-in  │
│ - Authentication│ │ - Search    │    │ - Renewals  │
│ - Authorization │ │ - Categories│    │ - Fines     │
└─────────────┘    └─────────────┘    └─────────────┘
        │                   │                   │
        ▼                   ▼                   ▼
┌─────────────┐    ┌─────────────┐    ┌─────────────┐
│   Report    │    │   Inventory │    │   Payment   │
│ Generation  │    │ Management  │    │ Processing  │
│             │    │             │    │             │
│ - User      │    │ - Stock     │    │ - Fine      │
│   Reports   │    │   Tracking  │    │   Collection│
│ - Circulation│   │ - Ordering  │    │ - Payment   │
│   Reports   │    │ - Suppliers │    │   Gateway   │
└─────────────┘    └─────────────┘    └─────────────┘
```

## 🔍 Architecture Patterns

### Layered Architecture
- **Presentation Layer**: User interface components
- **Business Logic Layer**: Application logic and rules
- **Data Access Layer**: Database operations
- **Data Layer**: Data storage and persistence

### Service-Oriented Architecture (SOA)
- **Service Provider**: Offers services to consumers
- **Service Consumer**: Uses services from providers
- **Service Registry**: Directory of available services
- **Service Broker**: Manages service interactions

### Event-Driven Architecture
- **Event Producer**: Generates events
- **Event Consumer**: Processes events
- **Event Bus**: Routes events between components
- **Event Store**: Persists events for replay

## 💡 Learning Points
- Architecture patterns provide proven solutions to common problems
- Separation of concerns improves maintainability
- Scalability should be considered from the beginning
- Technology choices should align with architecture patterns
- Documentation is crucial for architecture understanding

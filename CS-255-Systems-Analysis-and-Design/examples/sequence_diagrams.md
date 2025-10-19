# CS-255 Sequence Diagrams

## 🎯 Purpose
Demonstrate comprehensive sequence diagram creation for system analysis and design projects, showing interactions between objects over time.

## 📝 Sequence Diagram Examples

### User Login Sequence Diagram

```mermaid
sequenceDiagram
    participant U as User
    participant UI as Login UI
    participant C as Controller
    participant A as Auth Service
    participant DB as Database
    participant E as Email Service

    U->>UI: Enter credentials
    UI->>C: Submit login form
    C->>A: Validate credentials
    A->>DB: Query user data
    DB-->>A: Return user info
    A->>A: Verify password hash
    alt Valid credentials
        A-->>C: Return success + token
        C->>DB: Update last login
        C-->>UI: Redirect to dashboard
        UI-->>U: Show dashboard
        C->>E: Send login notification
    else Invalid credentials
        A-->>C: Return error
        C-->>UI: Display error message
        UI-->>U: Show error
    end
```

### E-Commerce Order Processing Sequence

```mermaid
sequenceDiagram
    participant C as Customer
    participant UI as Web Interface
    participant O as Order Service
    participant I as Inventory Service
    participant P as Payment Service
    participant S as Shipping Service
    participant N as Notification Service

    C->>UI: Add items to cart
    UI->>O: Create order
    O->>I: Check inventory
    I-->>O: Inventory status
    
    alt Items available
        O->>P: Process payment
        P-->>O: Payment confirmation
        O->>I: Reserve inventory
        I-->>O: Inventory reserved
        O->>S: Create shipping label
        S-->>O: Shipping details
        O->>N: Send order confirmation
        N-->>C: Email confirmation
        O-->>UI: Order success
        UI-->>C: Show confirmation
    else Items unavailable
        O-->>UI: Out of stock message
        UI-->>C: Show error
    end
```

### Library Book Checkout Sequence

```mermaid
sequenceDiagram
    participant M as Member
    participant L as Librarian
    participant S as System
    participant I as Inventory
    participant F as Fine System
    participant N as Notification

    M->>L: Request book checkout
    L->>S: Scan member card
    S->>S: Validate membership
    L->>S: Scan book barcode
    S->>I: Check book availability
    
    alt Book available
        S->>F: Check member fines
        F-->>S: Fine status
        
        alt No outstanding fines
            S->>I: Update book status
            I-->>S: Book checked out
            S->>N: Send checkout confirmation
            N-->>M: Email confirmation
            S-->>L: Checkout successful
            L-->>M: Hand over book
        else Outstanding fines
            S-->>L: Fines must be paid
            L-->>M: Cannot checkout
        end
    else Book unavailable
        S-->>L: Book not available
        L-->>M: Book unavailable
    end
```

## 🔍 Sequence Diagram Components

### 1. Lifelines
- **Represent objects or actors** in the system
- **Vertical lines** showing the object's existence over time
- **Activation boxes** show when objects are active

### 2. Messages
- **Synchronous calls**: Solid arrows with filled arrowheads
- **Asynchronous calls**: Solid arrows with open arrowheads
- **Return messages**: Dashed arrows
- **Self-calls**: Messages to the same object

### 3. Interaction Fragments
- **Alt**: Alternative paths (if-else conditions)
- **Opt**: Optional interactions
- **Loop**: Repeated interactions
- **Par**: Parallel interactions
- **Break**: Exception handling

## 📊 Advanced Sequence Diagram Examples

### ATM Transaction with Error Handling

```mermaid
sequenceDiagram
    participant U as User
    participant A as ATM
    participant B as Bank
    participant D as Database

    U->>A: Insert card
    A->>B: Validate card
    B-->>A: Card valid
    
    U->>A: Enter PIN
    A->>B: Verify PIN
    B->>D: Check account
    D-->>B: Account status
    
    alt Valid PIN and account
        U->>A: Request withdrawal
        A->>B: Process withdrawal
        B->>D: Check balance
        
        alt Sufficient funds
            B->>D: Update balance
            D-->>B: Balance updated
            B-->>A: Transaction approved
            A-->>U: Dispense cash
        else Insufficient funds
            B-->>A: Transaction denied
            A-->>U: Insufficient funds
        end
    else Invalid PIN
        B-->>A: PIN invalid
        A-->>U: Invalid PIN
    end
```

### Online Shopping Cart Sequence

```mermaid
sequenceDiagram
    participant C as Customer
    participant W as Website
    participant CART as Cart Service
    participant P as Product Service
    participant I as Inventory
    participant R as Recommendation Engine

    C->>W: Browse products
    W->>P: Get product list
    P-->>W: Product data
    W-->>C: Display products
    
    C->>W: Add to cart
    W->>CART: Add item
    CART->>I: Check stock
    I-->>CART: Stock available
    CART-->>W: Item added
    W-->>C: Cart updated
    
    C->>W: View cart
    W->>CART: Get cart contents
    CART-->>W: Cart items
    W->>R: Get recommendations
    R-->>W: Suggested items
    W-->>C: Display cart + recommendations
```

## 🛠️ Sequence Diagram Best Practices

### 1. Clarity and Readability
- **Use descriptive names** for actors and objects
- **Keep diagrams focused** on one main scenario
- **Avoid overcrowding** with too many objects
- **Use consistent notation** throughout

### 2. Message Design
- **Use action verbs** for message names
- **Include parameters** when necessary
- **Show return values** for important calls
- **Use consistent naming** conventions

### 3. Layout and Organization
- **Arrange actors** from left to right by importance
- **Group related interactions** together
- **Use activation boxes** to show object activity
- **Align messages** for better readability

### 4. Error Handling
- **Include alternative paths** for error conditions
- **Show exception handling** clearly
- **Use alt/opt fragments** for conditional logic
- **Document error scenarios** thoroughly

## 📋 Sequence Diagram Template

```markdown
# Sequence Diagram: [Scenario Name]

## Purpose
[Brief description of what the sequence diagram shows]

## Participants
- **Actor 1**: [Description]
- **Actor 2**: [Description]
- **System Component 1**: [Description]
- **System Component 2**: [Description]

## Main Flow
1. [Step 1]
2. [Step 2]
3. [Step 3]

## Alternative Flows
- **Alt 1**: [Alternative scenario]
- **Alt 2**: [Another alternative]

## Exception Flows
- **Exception 1**: [Error condition]
- **Exception 2**: [Another error]

## Notes
- [Important implementation details]
- [Performance considerations]
- [Security requirements]
```

## 🎯 CS-255 Learning Outcomes

### Technical Skills
- **Object Interaction Modeling**: Understanding how objects communicate
- **Message Sequencing**: Proper ordering of system interactions
- **Error Handling**: Modeling exception scenarios
- **System Behavior**: Capturing dynamic system behavior

### Professional Skills
- **System Documentation**: Creating clear interaction diagrams
- **Stakeholder Communication**: Visualizing complex interactions
- **Requirements Analysis**: Understanding system workflows
- **Design Validation**: Verifying system behavior

## 💡 Pro Tips

1. **Start with Happy Path**: Model the main success scenario first
2. **Add Error Handling**: Include alternative and exception paths
3. **Keep It Simple**: Don't try to show everything in one diagram
4. **Use Fragments**: Leverage alt, opt, loop, and par for clarity
5. **Focus on Interactions**: Show what happens, not how it's implemented
6. **Validate with Users**: Get feedback from actual system users
7. **Iterate and Refine**: Sequence diagrams evolve with understanding
8. **Document Assumptions**: Note any assumptions or constraints

## 🔗 Related UML Diagrams

- **Use Case Diagrams**: Show what the system does
- **Class Diagrams**: Show system structure
- **Activity Diagrams**: Show business processes
- **State Diagrams**: Show object state changes
- **Component Diagrams**: Show system architecture

---

*This sequence diagram guide provides comprehensive examples and best practices for CS-255 Systems Analysis and Design, helping students create professional-quality interaction documentation.*

# CS-340 REST API Basics

## 🎯 Purpose
Demonstrate REST API design, implementation, and client-server communication.

## 📝 REST API Examples

### Basic REST Controller
```java
@RestController
@RequestMapping("/api/users")
@CrossOrigin(origins = "*")
public class UserController {
    
    @Autowired
    private UserService userService;
    
    // GET /api/users - Retrieve all users
    @GetMapping
    public ResponseEntity<List<UserResponse>> getAllUsers(
            @RequestParam(defaultValue = "0") int page,
            @RequestParam(defaultValue = "10") int size) {
        
        List<UserResponse> users = userService.getAllUsers(page, size);
        return ResponseEntity.ok(users);
    }
    
    // GET /api/users/{id} - Retrieve user by ID
    @GetMapping("/{id}")
    public ResponseEntity<UserResponse> getUserById(@PathVariable Long id) {
        try {
            UserResponse user = userService.getUserById(id);
            return ResponseEntity.ok(user);
        } catch (UserNotFoundException e) {
            return ResponseEntity.notFound().build();
        }
    }
    
    // POST /api/users - Create new user
    @PostMapping
    public ResponseEntity<UserResponse> createUser(@Valid @RequestBody UserRequest request) {
        UserResponse user = userService.createUser(request);
        return ResponseEntity.status(HttpStatus.CREATED).body(user);
    }
    
    // PUT /api/users/{id} - Update user
    @PutMapping("/{id}")
    public ResponseEntity<UserResponse> updateUser(
            @PathVariable Long id, 
            @Valid @RequestBody UserRequest request) {
        try {
            UserResponse user = userService.updateUser(id, request);
            return ResponseEntity.ok(user);
        } catch (UserNotFoundException e) {
            return ResponseEntity.notFound().build();
        }
    }
    
    // DELETE /api/users/{id} - Delete user
    @DeleteMapping("/{id}")
    public ResponseEntity<Void> deleteUser(@PathVariable Long id) {
        try {
            userService.deleteUser(id);
            return ResponseEntity.noContent().build();
        } catch (UserNotFoundException e) {
            return ResponseEntity.notFound().build();
        }
    }
}
```

### HTTP Status Codes and Error Handling
```java
@ControllerAdvice
public class GlobalExceptionHandler {
    
    @ExceptionHandler(UserNotFoundException.class)
    public ResponseEntity<ErrorResponse> handleUserNotFound(UserNotFoundException e) {
        ErrorResponse error = new ErrorResponse(
            "USER_NOT_FOUND", 
            "User with ID " + e.getUserId() + " not found",
            HttpStatus.NOT_FOUND.value()
        );
        return ResponseEntity.status(HttpStatus.NOT_FOUND).body(error);
    }
    
    @ExceptionHandler(MethodArgumentNotValidException.class)
    public ResponseEntity<ErrorResponse> handleValidationErrors(MethodArgumentNotValidException e) {
        List<String> errors = e.getBindingResult()
            .getFieldErrors()
            .stream()
            .map(error -> error.getField() + ": " + error.getDefaultMessage())
            .collect(Collectors.toList());
            
        ErrorResponse error = new ErrorResponse(
            "VALIDATION_ERROR",
            "Invalid input data",
            HttpStatus.BAD_REQUEST.value(),
            errors
        );
        return ResponseEntity.badRequest().body(error);
    }
    
    @ExceptionHandler(Exception.class)
    public ResponseEntity<ErrorResponse> handleGenericException(Exception e) {
        ErrorResponse error = new ErrorResponse(
            "INTERNAL_SERVER_ERROR",
            "An unexpected error occurred",
            HttpStatus.INTERNAL_SERVER_ERROR.value()
        );
        return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(error);
    }
}
```

### Request/Response DTOs
```java
// Request DTO
public class UserRequest {
    @NotBlank(message = "Email is required")
    @Email(message = "Invalid email format")
    private String email;
    
    @NotBlank(message = "Name is required")
    @Size(min = 2, max = 50, message = "Name must be between 2 and 50 characters")
    private String name;
    
    @NotBlank(message = "Password is required")
    @Size(min = 8, message = "Password must be at least 8 characters")
    private String password;
    
    // Constructors, getters, setters
}

// Response DTO
public class UserResponse {
    private Long id;
    private String email;
    private String name;
    private LocalDateTime createdAt;
    private LocalDateTime updatedAt;
    
    // Constructors, getters, setters
}

// Error Response DTO
public class ErrorResponse {
    private String code;
    private String message;
    private int status;
    private List<String> details;
    
    // Constructors, getters, setters
}
```

## 🔍 REST API Best Practices

### HTTP Methods and Their Usage
- **GET**: Retrieve data (idempotent, safe)
- **POST**: Create new resources (not idempotent)
- **PUT**: Update entire resource (idempotent)
- **PATCH**: Partial update (not idempotent)
- **DELETE**: Remove resource (idempotent)

### URL Design Principles
```
GET    /api/users              # Get all users
GET    /api/users/123          # Get user by ID
POST   /api/users              # Create new user
PUT    /api/users/123          # Update user 123
DELETE /api/users/123          # Delete user 123

GET    /api/users/123/orders   # Get orders for user 123
POST   /api/users/123/orders   # Create order for user 123
```

## 💡 Learning Points
- REST APIs use HTTP methods to perform CRUD operations
- Proper HTTP status codes communicate operation results
- Request/Response DTOs provide clean data contracts
- Error handling improves API usability and debugging
- Consistent URL patterns make APIs predictable

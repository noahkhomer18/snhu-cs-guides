# CS-320 Integration Testing Examples

## 🎯 Purpose
Demonstrate integration testing strategies and implementation.

## 📝 Integration Testing Examples

### Database Integration Testing

#### Repository Integration Test
```java
@SpringBootTest
@TestPropertySource(locations = "classpath:application-test.properties")
@Transactional
@Rollback
public class UserRepositoryIntegrationTest {
    
    @Autowired
    private UserRepository userRepository;
    
    @Autowired
    private TestEntityManager entityManager;
    
    @Test
    @DisplayName("Should save and retrieve user from database")
    void testSaveAndFindUser() {
        // Arrange
        User user = new User("john@example.com", "John Doe", "password123");
        
        // Act
        User savedUser = userRepository.save(user);
        entityManager.flush();
        entityManager.clear();
        
        User foundUser = userRepository.findById(savedUser.getId()).orElse(null);
        
        // Assert
        assertNotNull(foundUser);
        assertEquals("john@example.com", foundUser.getEmail());
        assertEquals("John Doe", foundUser.getName());
    }
    
    @Test
    @DisplayName("Should find users by email")
    void testFindByEmail() {
        // Arrange
        User user1 = new User("alice@example.com", "Alice Smith", "password");
        User user2 = new User("bob@example.com", "Bob Johnson", "password");
        
        userRepository.save(user1);
        userRepository.save(user2);
        entityManager.flush();
        
        // Act
        Optional<User> foundUser = userRepository.findByEmail("alice@example.com");
        
        // Assert
        assertTrue(foundUser.isPresent());
        assertEquals("Alice Smith", foundUser.get().getName());
    }
}
```

### API Integration Testing

#### REST Controller Integration Test
```java
@SpringBootTest(webEnvironment = SpringBootTest.WebEnvironment.RANDOM_PORT)
@AutoConfigureTestDatabase(replace = AutoConfigureTestDatabase.Replace.ANY)
public class UserControllerIntegrationTest {
    
    @Autowired
    private TestRestTemplate restTemplate;
    
    @Autowired
    private UserRepository userRepository;
    
    @Test
    @DisplayName("Should create user via REST API")
    void testCreateUser() {
        // Arrange
        UserRequest request = new UserRequest("jane@example.com", "Jane Doe", "password123");
        
        // Act
        ResponseEntity<UserResponse> response = restTemplate.postForEntity(
            "/api/users", 
            request, 
            UserResponse.class
        );
        
        // Assert
        assertEquals(HttpStatus.CREATED, response.getStatusCode());
        assertNotNull(response.getBody());
        assertEquals("jane@example.com", response.getBody().getEmail());
        
        // Verify in database
        Optional<User> savedUser = userRepository.findByEmail("jane@example.com");
        assertTrue(savedUser.isPresent());
    }
    
    @Test
    @DisplayName("Should retrieve user by ID")
    void testGetUserById() {
        // Arrange
        User user = new User("test@example.com", "Test User", "password");
        User savedUser = userRepository.save(user);
        
        // Act
        ResponseEntity<UserResponse> response = restTemplate.getForEntity(
            "/api/users/" + savedUser.getId(), 
            UserResponse.class
        );
        
        // Assert
        assertEquals(HttpStatus.OK, response.getStatusCode());
        assertEquals("test@example.com", response.getBody().getEmail());
    }
}
```

### Service Layer Integration Test

#### Business Logic Integration Test
```java
@SpringBootTest
@Transactional
public class OrderServiceIntegrationTest {
    
    @Autowired
    private OrderService orderService;
    
    @Autowired
    private UserRepository userRepository;
    
    @Autowired
    private ProductRepository productRepository;
    
    @Test
    @DisplayName("Should process complete order workflow")
    void testCompleteOrderWorkflow() {
        // Arrange
        User user = userRepository.save(new User("customer@example.com", "Customer", "password"));
        Product product = productRepository.save(new Product("Laptop", 999.99, 10));
        
        OrderRequest orderRequest = new OrderRequest();
        orderRequest.setUserId(user.getId());
        orderRequest.addItem(product.getId(), 2);
        
        // Act
        OrderResponse orderResponse = orderService.createOrder(orderRequest);
        
        // Assert
        assertNotNull(orderResponse);
        assertEquals(OrderStatus.CONFIRMED, orderResponse.getStatus());
        assertEquals(1999.98, orderResponse.getTotalAmount(), 0.01);
        
        // Verify inventory updated
        Product updatedProduct = productRepository.findById(product.getId()).orElse(null);
        assertEquals(8, updatedProduct.getStockQuantity());
    }
}
```

### Message Queue Integration Testing

#### Event-Driven Integration Test
```java
@SpringBootTest
@DirtiesContext
public class OrderEventIntegrationTest {
    
    @Autowired
    private OrderService orderService;
    
    @Autowired
    private TestMessageChannel orderEventsChannel;
    
    @Test
    @DisplayName("Should publish order created event")
    void testOrderCreatedEvent() {
        // Arrange
        OrderRequest orderRequest = createValidOrderRequest();
        
        // Act
        OrderResponse orderResponse = orderService.createOrder(orderRequest);
        
        // Assert
        assertNotNull(orderResponse);
        
        // Verify event was published
        Message<?> message = orderEventsChannel.receive(5000);
        assertNotNull(message);
        
        OrderCreatedEvent event = (OrderCreatedEvent) message.getPayload();
        assertEquals(orderResponse.getId(), event.getOrderId());
        assertEquals(OrderStatus.CONFIRMED, event.getStatus());
    }
}
```

### Test Configuration

#### Test Application Properties
```properties
# application-test.properties
spring.datasource.url=jdbc:h2:mem:testdb
spring.datasource.driver-class-name=org.h2.Driver
spring.jpa.hibernate.ddl-auto=create-drop
spring.jpa.show-sql=true
spring.jpa.properties.hibernate.format_sql=true

# Disable security for testing
spring.security.user.name=test
spring.security.user.password=test
spring.security.user.roles=USER

# Test message broker
spring.rabbitmq.host=localhost
spring.rabbitmq.port=5672
spring.rabbitmq.username=guest
spring.rabbitmq.password=guest
```

#### Test Configuration Class
```java
@Configuration
@TestConfiguration
public class TestConfig {
    
    @Bean
    @Primary
    public Clock testClock() {
        return Clock.fixed(Instant.parse("2023-01-01T00:00:00Z"), ZoneOffset.UTC);
    }
    
    @Bean
    @Primary
    public EmailService mockEmailService() {
        return Mockito.mock(EmailService.class);
    }
}
```

## 🔍 Integration Testing Strategies

### Testing Pyramid
```
    /\
   /  \     E2E Tests (Few)
  /____\    
 /      \   Integration Tests (Some)
/________\  
/          \ Unit Tests (Many)
/____________\
```

### Integration Test Types
- **Database Integration**: Test data persistence layer
- **API Integration**: Test REST endpoints
- **Service Integration**: Test business logic with dependencies
- **Message Integration**: Test event-driven communication

## 💡 Learning Points
- Integration tests verify component interactions
- Use test databases and mock external services
- Test real data flow through multiple layers
- Focus on critical business workflows
- Balance test coverage with execution time

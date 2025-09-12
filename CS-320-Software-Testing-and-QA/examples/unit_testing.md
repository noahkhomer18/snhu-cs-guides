# CS-320 Unit Testing Examples

## 🎯 Purpose
Demonstrate unit testing principles, frameworks, and best practices.

## 📝 Testing Examples

### JUnit Testing Framework

#### Basic Test Class
```java
import org.junit.jupiter.api.*;
import static org.junit.jupiter.api.Assertions.*;

public class CalculatorTest {
    private Calculator calculator;
    
    @BeforeEach
    void setUp() {
        calculator = new Calculator();
    }
    
    @Test
    @DisplayName("Addition should return correct sum")
    void testAddition() {
        // Arrange
        int a = 5;
        int b = 3;
        int expected = 8;
        
        // Act
        int result = calculator.add(a, b);
        
        // Assert
        assertEquals(expected, result);
    }
    
    @Test
    @DisplayName("Division by zero should throw exception")
    void testDivisionByZero() {
        // Arrange
        int a = 10;
        int b = 0;
        
        // Act & Assert
        assertThrows(ArithmeticException.class, () -> {
            calculator.divide(a, b);
        });
    }
    
    @Test
    @DisplayName("Multiple assertions for complex validation")
    void testComplexCalculation() {
        // Arrange
        int[] numbers = {1, 2, 3, 4, 5};
        
        // Act
        int sum = calculator.sumArray(numbers);
        double average = calculator.averageArray(numbers);
        
        // Assert
        assertAll("Array calculations",
            () -> assertEquals(15, sum),
            () -> assertEquals(3.0, average, 0.001),
            () -> assertTrue(sum > 0),
            () -> assertNotNull(average)
        );
    }
}
```

#### Parameterized Tests
```java
@ParameterizedTest
@ValueSource(ints = {2, 4, 6, 8, 10})
@DisplayName("Even numbers should be identified correctly")
void testIsEven(int number) {
    assertTrue(calculator.isEven(number));
}

@ParameterizedTest
@CsvSource({
    "2, 3, 6",
    "4, 5, 20",
    "10, 2, 20"
})
@DisplayName("Multiplication should work for various inputs")
void testMultiplication(int a, int b, int expected) {
    assertEquals(expected, calculator.multiply(a, b));
}
```

### Test Doubles (Mocks, Stubs, Fakes)

#### Mock Object Example
```java
import org.mockito.Mock;
import org.mockito.MockitoAnnotations;
import static org.mockito.Mockito.*;

public class UserServiceTest {
    @Mock
    private UserRepository userRepository;
    
    @Mock
    private EmailService emailService;
    
    private UserService userService;
    
    @BeforeEach
    void setUp() {
        MockitoAnnotations.openMocks(this);
        userService = new UserService(userRepository, emailService);
    }
    
    @Test
    @DisplayName("Should create user and send welcome email")
    void testCreateUser() {
        // Arrange
        User user = new User("john@example.com", "John Doe");
        when(userRepository.save(any(User.class))).thenReturn(user);
        doNothing().when(emailService).sendWelcomeEmail(anyString());
        
        // Act
        User result = userService.createUser("john@example.com", "John Doe");
        
        // Assert
        assertNotNull(result);
        assertEquals("john@example.com", result.getEmail());
        verify(userRepository, times(1)).save(any(User.class));
        verify(emailService, times(1)).sendWelcomeEmail("john@example.com");
    }
}
```

### Test Coverage Analysis

#### Coverage Metrics Example
```java
public class BankAccount {
    private double balance;
    private String accountNumber;
    
    public BankAccount(String accountNumber, double initialBalance) {
        this.accountNumber = accountNumber;
        this.balance = initialBalance;
    }
    
    public void deposit(double amount) {
        if (amount > 0) {
            balance += amount;
        } else {
            throw new IllegalArgumentException("Amount must be positive");
        }
    }
    
    public void withdraw(double amount) {
        if (amount <= 0) {
            throw new IllegalArgumentException("Amount must be positive");
        }
        if (amount > balance) {
            throw new InsufficientFundsException("Insufficient funds");
        }
        balance -= amount;
    }
    
    public double getBalance() {
        return balance;
    }
    
    public boolean hasMinimumBalance(double minimum) {
        return balance >= minimum;
    }
}
```

#### Comprehensive Test Coverage
```java
public class BankAccountTest {
    private BankAccount account;
    
    @BeforeEach
    void setUp() {
        account = new BankAccount("12345", 100.0);
    }
    
    @Test
    void testDepositPositiveAmount() {
        account.deposit(50.0);
        assertEquals(150.0, account.getBalance());
    }
    
    @Test
    void testDepositNegativeAmount() {
        assertThrows(IllegalArgumentException.class, () -> {
            account.deposit(-10.0);
        });
    }
    
    @Test
    void testWithdrawValidAmount() {
        account.withdraw(30.0);
        assertEquals(70.0, account.getBalance());
    }
    
    @Test
    void testWithdrawInsufficientFunds() {
        assertThrows(InsufficientFundsException.class, () -> {
            account.withdraw(150.0);
        });
    }
    
    @Test
    void testWithdrawNegativeAmount() {
        assertThrows(IllegalArgumentException.class, () -> {
            account.withdraw(-10.0);
        });
    }
    
    @Test
    void testHasMinimumBalanceTrue() {
        assertTrue(account.hasMinimumBalance(50.0));
    }
    
    @Test
    void testHasMinimumBalanceFalse() {
        assertFalse(account.hasMinimumBalance(150.0));
    }
}
```

## 🔍 Testing Best Practices

### Test Structure (AAA Pattern)
- **Arrange**: Set up test data and conditions
- **Act**: Execute the method under test
- **Assert**: Verify the expected outcome

### Test Naming Conventions
- `testMethodName_Scenario_ExpectedResult()`
- `should_ExpectedBehavior_When_StateUnderTest()`
- Use descriptive display names with `@DisplayName`

### Coverage Goals
- **Line Coverage**: 80-90% minimum
- **Branch Coverage**: 70-80% minimum
- **Path Coverage**: Focus on critical paths

## 💡 Learning Points
- Unit tests should be fast, isolated, repeatable, and self-validating
- Mock external dependencies to isolate units under test
- Test both happy path and edge cases
- Use parameterized tests for multiple input scenarios
- Aim for high coverage but focus on meaningful tests

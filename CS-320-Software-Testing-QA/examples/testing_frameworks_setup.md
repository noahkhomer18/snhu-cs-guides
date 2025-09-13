# CS-320 Testing Frameworks Setup Guide

## 🎯 Purpose
Complete setup guide for software testing frameworks, tools, and best practices used in quality assurance.

## 🧪 Testing Framework Overview

### Types of Testing
- **Unit Testing**: Test individual components in isolation
- **Integration Testing**: Test component interactions
- **End-to-End Testing**: Test complete user workflows
- **Performance Testing**: Test system performance under load
- **Security Testing**: Test for vulnerabilities and security issues

## 🐍 Python Testing (PyTest)

### Installation
```bash
# Install pytest
pip install pytest

# Install additional testing tools
pip install pytest-cov pytest-mock pytest-xdist
pip install pytest-html pytest-json-report
pip install factory-boy faker  # For test data generation

# Verify installation
pytest --version
```

### Basic Test Structure
```python
# test_calculator.py
import pytest
from calculator import Calculator

class TestCalculator:
    def setup_method(self):
        """Set up test fixtures before each test method."""
        self.calc = Calculator()
    
    def test_add(self):
        """Test addition functionality."""
        assert self.calc.add(2, 3) == 5
        assert self.calc.add(-1, 1) == 0
        assert self.calc.add(0, 0) == 0
    
    def test_subtract(self):
        """Test subtraction functionality."""
        assert self.calc.subtract(5, 3) == 2
        assert self.calc.subtract(1, 1) == 0
        assert self.calc.subtract(0, 5) == -5
    
    def test_divide(self):
        """Test division functionality."""
        assert self.calc.divide(10, 2) == 5
        assert self.calc.divide(5, 2) == 2.5
    
    def test_divide_by_zero(self):
        """Test division by zero raises exception."""
        with pytest.raises(ValueError, match="Cannot divide by zero"):
            self.calc.divide(5, 0)
    
    @pytest.mark.parametrize("a,b,expected", [
        (2, 3, 5),
        (0, 0, 0),
        (-1, 1, 0),
        (10, -5, 5)
    ])
    def test_add_parametrized(self, a, b, expected):
        """Test addition with multiple inputs."""
        assert self.calc.add(a, b) == expected
```

### Fixtures and Mocking
```python
# conftest.py
import pytest
from unittest.mock import Mock, patch

@pytest.fixture
def sample_data():
    """Provide sample data for tests."""
    return {
        'users': [
            {'id': 1, 'name': 'John', 'email': 'john@example.com'},
            {'id': 2, 'name': 'Jane', 'email': 'jane@example.com'}
        ]
    }

@pytest.fixture
def mock_database():
    """Mock database connection."""
    with patch('app.database.connect') as mock_db:
        mock_db.return_value.execute.return_value.fetchall.return_value = [
            (1, 'John', 'john@example.com'),
            (2, 'Jane', 'jane@example.com')
        ]
        yield mock_db

# test_user_service.py
import pytest
from unittest.mock import Mock, patch
from user_service import UserService

class TestUserService:
    def test_get_user_by_id(self, mock_database, sample_data):
        """Test getting user by ID."""
        service = UserService()
        user = service.get_user_by_id(1)
        
        assert user['id'] == 1
        assert user['name'] == 'John'
        mock_database.return_value.execute.assert_called_once()
    
    @patch('user_service.send_email')
    def test_send_welcome_email(self, mock_send_email, sample_data):
        """Test sending welcome email."""
        service = UserService()
        service.send_welcome_email('newuser@example.com')
        
        mock_send_email.assert_called_once_with(
            'newuser@example.com',
            'Welcome!',
            'Welcome to our service!'
        )
```

### Running Tests
```bash
# Run all tests
pytest

# Run specific test file
pytest test_calculator.py

# Run specific test method
pytest test_calculator.py::TestCalculator::test_add

# Run with coverage
pytest --cov=src --cov-report=html

# Run in parallel
pytest -n 4

# Run with verbose output
pytest -v

# Run and stop on first failure
pytest -x

# Run only failed tests from last run
pytest --lf
```

## ☕ Java Testing (JUnit 5)

### Maven Setup
```xml
<!-- pom.xml -->
<dependencies>
    <dependency>
        <groupId>org.junit.jupiter</groupId>
        <artifactId>junit-jupiter</artifactId>
        <version>5.9.2</version>
        <scope>test</scope>
    </dependency>
    <dependency>
        <groupId>org.mockito</groupId>
        <artifactId>mockito-core</artifactId>
        <version>4.11.0</version>
        <scope>test</scope>
    </dependency>
    <dependency>
        <groupId>org.assertj</groupId>
        <artifactId>assertj-core</artifactId>
        <version>3.24.2</version>
        <scope>test</scope>
    </dependency>
</dependencies>

<build>
    <plugins>
        <plugin>
            <groupId>org.apache.maven.plugins</groupId>
            <artifactId>maven-surefire-plugin</artifactId>
            <version>3.0.0</version>
        </plugin>
        <plugin>
            <groupId>org.jacoco</groupId>
            <artifactId>jacoco-maven-plugin</artifactId>
            <version>0.8.8</version>
        </plugin>
    </plugins>
</build>
```

### JUnit 5 Test Examples
```java
// CalculatorTest.java
import org.junit.jupiter.api.*;
import org.junit.jupiter.params.ParameterizedTest;
import org.junit.jupiter.params.provider.ValueSource;
import org.junit.jupiter.params.provider.CsvSource;
import static org.junit.jupiter.api.Assertions.*;
import static org.assertj.core.api.Assertions.*;

class CalculatorTest {
    private Calculator calculator;
    
    @BeforeEach
    void setUp() {
        calculator = new Calculator();
    }
    
    @Test
    @DisplayName("Addition should return correct result")
    void testAdd() {
        // Given
        int a = 2;
        int b = 3;
        
        // When
        int result = calculator.add(a, b);
        
        // Then
        assertEquals(5, result);
        assertThat(result).isEqualTo(5);
    }
    
    @Test
    @DisplayName("Division by zero should throw exception")
    void testDivideByZero() {
        // Given
        int a = 5;
        int b = 0;
        
        // When & Then
        assertThrows(ArithmeticException.class, () -> {
            calculator.divide(a, b);
        });
    }
    
    @ParameterizedTest
    @CsvSource({
        "2, 3, 5",
        "0, 0, 0",
        "-1, 1, 0",
        "10, -5, 5"
    })
    @DisplayName("Addition with multiple inputs")
    void testAddParameterized(int a, int b, int expected) {
        int result = calculator.add(a, b);
        assertEquals(expected, result);
    }
    
    @Test
    @DisplayName("Calculator should be initialized correctly")
    void testCalculatorInitialization() {
        assertNotNull(calculator);
        assertThat(calculator.getHistory()).isEmpty();
    }
}
```

### Mockito Examples
```java
// UserServiceTest.java
import org.junit.jupiter.api.*;
import org.mockito.Mock;
import org.mockito.MockitoAnnotations;
import static org.mockito.Mockito.*;
import static org.assertj.core.api.Assertions.*;

class UserServiceTest {
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
    @DisplayName("Should create user successfully")
    void testCreateUser() {
        // Given
        User user = new User("John", "john@example.com");
        when(userRepository.save(any(User.class))).thenReturn(user);
        
        // When
        User result = userService.createUser("John", "john@example.com");
        
        // Then
        assertThat(result.getName()).isEqualTo("John");
        assertThat(result.getEmail()).isEqualTo("john@example.com");
        verify(userRepository).save(any(User.class));
        verify(emailService).sendWelcomeEmail("john@example.com");
    }
    
    @Test
    @DisplayName("Should throw exception when user already exists")
    void testCreateUserWhenUserExists() {
        // Given
        when(userRepository.findByEmail("john@example.com"))
            .thenReturn(new User("John", "john@example.com"));
        
        // When & Then
        assertThrows(UserAlreadyExistsException.class, () -> {
            userService.createUser("John", "john@example.com");
        });
        
        verify(userRepository, never()).save(any(User.class));
        verify(emailService, never()).sendWelcomeEmail(anyString());
    }
}
```

## 🌐 JavaScript Testing (Jest)

### Installation
```bash
# Install Jest
npm install --save-dev jest

# Install additional testing tools
npm install --save-dev @testing-library/jest-dom
npm install --save-dev @testing-library/react
npm install --save-dev @testing-library/user-event
npm install --save-dev jest-environment-jsdom

# Install for Angular
npm install --save-dev @angular/cli
ng add @angular/testing
```

### Jest Configuration
```javascript
// jest.config.js
module.exports = {
  testEnvironment: 'jsdom',
  setupFilesAfterEnv: ['<rootDir>/src/setupTests.js'],
  moduleNameMapping: {
    '^@/(.*)$': '<rootDir>/src/$1'
  },
  collectCoverageFrom: [
    'src/**/*.{js,jsx}',
    '!src/index.js',
    '!src/reportWebVitals.js'
  ],
  coverageThreshold: {
    global: {
      branches: 80,
      functions: 80,
      lines: 80,
      statements: 80
    }
  }
};
```

### Jest Test Examples
```javascript
// calculator.test.js
import Calculator from '../src/Calculator';

describe('Calculator', () => {
  let calculator;
  
  beforeEach(() => {
    calculator = new Calculator();
  });
  
  describe('add', () => {
    test('should add two positive numbers', () => {
      expect(calculator.add(2, 3)).toBe(5);
    });
    
    test('should add negative numbers', () => {
      expect(calculator.add(-1, -2)).toBe(-3);
    });
    
    test('should add zero', () => {
      expect(calculator.add(5, 0)).toBe(5);
    });
  });
  
  describe('divide', () => {
    test('should divide two numbers', () => {
      expect(calculator.divide(10, 2)).toBe(5);
    });
    
    test('should throw error when dividing by zero', () => {
      expect(() => calculator.divide(5, 0)).toThrow('Cannot divide by zero');
    });
  });
  
  describe('history', () => {
    test('should track calculation history', () => {
      calculator.add(2, 3);
      calculator.multiply(4, 5);
      
      expect(calculator.getHistory()).toHaveLength(2);
      expect(calculator.getHistory()[0]).toEqual({
        operation: 'add',
        operands: [2, 3],
        result: 5
      });
    });
  });
});
```

### React Testing Examples
```javascript
// UserProfile.test.jsx
import React from 'react';
import { render, screen, fireEvent, waitFor } from '@testing-library/react';
import userEvent from '@testing-library/user-event';
import UserProfile from '../UserProfile';

describe('UserProfile', () => {
  const mockUser = {
    id: 1,
    name: 'John Doe',
    email: 'john@example.com'
  };
  
  test('renders user information', () => {
    render(<UserProfile user={mockUser} />);
    
    expect(screen.getByText('John Doe')).toBeInTheDocument();
    expect(screen.getByText('john@example.com')).toBeInTheDocument();
  });
  
  test('allows editing user information', async () => {
    const user = userEvent.setup();
    const mockOnUpdate = jest.fn();
    
    render(<UserProfile user={mockUser} onUpdate={mockOnUpdate} />);
    
    const editButton = screen.getByRole('button', { name: /edit/i });
    await user.click(editButton);
    
    const nameInput = screen.getByDisplayValue('John Doe');
    await user.clear(nameInput);
    await user.type(nameInput, 'Jane Doe');
    
    const saveButton = screen.getByRole('button', { name: /save/i });
    await user.click(saveButton);
    
    await waitFor(() => {
      expect(mockOnUpdate).toHaveBeenCalledWith({
        ...mockUser,
        name: 'Jane Doe'
      });
    });
  });
});
```

## 🔧 Testing Tools & Utilities

### Test Data Generation
```python
# Python with Faker
from faker import Faker
import factory

fake = Faker()

class UserFactory(factory.Factory):
    class Meta:
        model = User
    
    name = factory.LazyFunction(lambda: fake.name())
    email = factory.LazyFunction(lambda: fake.email())
    age = factory.LazyFunction(lambda: fake.random_int(min=18, max=80))

# Usage in tests
def test_user_creation():
    user = UserFactory()
    assert user.name is not None
    assert '@' in user.email
    assert 18 <= user.age <= 80
```

```java
// Java with Faker
import net.datafaker.Faker;

public class UserTestDataFactory {
    private static final Faker faker = new Faker();
    
    public static User createUser() {
        return User.builder()
            .name(faker.name().fullName())
            .email(faker.internet().emailAddress())
            .age(faker.number().numberBetween(18, 80))
            .build();
    }
    
    public static User createUserWithName(String name) {
        return User.builder()
            .name(name)
            .email(faker.internet().emailAddress())
            .age(faker.number().numberBetween(18, 80))
            .build();
    }
}
```

### Performance Testing
```python
# Python with pytest-benchmark
import pytest
import time

def test_calculation_performance(benchmark):
    def slow_calculation():
        time.sleep(0.1)  # Simulate slow operation
        return sum(range(1000))
    
    result = benchmark(slow_calculation)
    assert result == 499500
```

```java
// Java with JMH
import org.openjdk.jmh.annotations.*;

@BenchmarkMode(Mode.AverageTime)
@OutputTimeUnit(TimeUnit.MICROSECONDS)
@State(Scope.Benchmark)
public class CalculatorBenchmark {
    private Calculator calculator;
    
    @Setup
    public void setup() {
        calculator = new Calculator();
    }
    
    @Benchmark
    public int benchmarkAdd() {
        return calculator.add(1000, 2000);
    }
}
```

## 🚀 Continuous Integration

### GitHub Actions
```yaml
# .github/workflows/test.yml
name: Tests

on:
  push:
    branches: [ main, develop ]
  pull_request:
    branches: [ main ]

jobs:
  test:
    runs-on: ubuntu-latest
    
    strategy:
      matrix:
        node-version: [16.x, 18.x, 20.x]
        python-version: [3.8, 3.9, '3.10', '3.11']
    
    steps:
    - uses: actions/checkout@v3
    
    - name: Setup Node.js
      uses: actions/setup-node@v3
      with:
        node-version: ${{ matrix.node-version }}
        cache: 'npm'
    
    - name: Setup Python
      uses: actions/setup-python@v4
      with:
        python-version: ${{ matrix.python-version }}
    
    - name: Install dependencies
      run: |
        npm ci
        pip install -r requirements.txt
    
    - name: Run tests
      run: |
        npm test
        pytest --cov=src --cov-report=xml
    
    - name: Upload coverage
      uses: codecov/codecov-action@v3
      with:
        file: ./coverage.xml
```

### Test Reporting
```bash
# Generate HTML coverage report
pytest --cov=src --cov-report=html

# Generate XML report for CI
pytest --cov=src --cov-report=xml

# Generate JSON report
pytest --cov=src --cov-report=json

# Run with JUnit XML output
pytest --junitxml=test-results.xml
```

## 📚 Learning Resources

### Testing Documentation
- **pytest Documentation**: https://docs.pytest.org/
- **JUnit 5 User Guide**: https://junit.org/junit5/docs/current/user-guide/
- **Jest Documentation**: https://jestjs.io/docs/getting-started
- **Testing Library**: https://testing-library.com/

### Best Practices
- **Test Pyramid**: https://martinfowler.com/articles/practical-test-pyramid.html
- **AAA Pattern**: Arrange, Act, Assert
- **FIRST Principles**: Fast, Independent, Repeatable, Self-validating, Timely
- **TDD (Test-Driven Development)**: Write tests before code

### Books
- **Growing Object-Oriented Software, Guided by Tests**: Freeman & Pryce
- **Test Driven Development**: Kent Beck
- **The Art of Unit Testing**: Roy Osherove

## 🎯 CS-320 Project Checklist

### Phase 1: Setup
- [ ] Install testing frameworks
- [ ] Configure test environment
- [ ] Set up test data generation
- [ ] Create test directory structure

### Phase 2: Unit Testing
- [ ] Write unit tests for all classes
- [ ] Achieve 80%+ code coverage
- [ ] Test edge cases and error conditions
- [ ] Use mocking for external dependencies

### Phase 3: Integration Testing
- [ ] Test component interactions
- [ ] Test database operations
- [ ] Test API endpoints
- [ ] Test file I/O operations

### Phase 4: End-to-End Testing
- [ ] Test complete user workflows
- [ ] Test UI interactions
- [ ] Test cross-browser compatibility
- [ ] Test mobile responsiveness

### Phase 5: Performance & Security
- [ ] Load testing
- [ ] Security vulnerability testing
- [ ] Memory leak testing
- [ ] Performance benchmarking

## 💡 Pro Tips

1. **Write Tests First**: Follow TDD principles
2. **Keep Tests Simple**: One assertion per test
3. **Use Descriptive Names**: Test names should explain what they test
4. **Mock External Dependencies**: Isolate units under test
5. **Test Edge Cases**: Include boundary conditions and error cases
6. **Maintain Test Data**: Use factories and builders for test data
7. **Run Tests Frequently**: Run tests after every change
8. **Keep Tests Fast**: Avoid slow operations in unit tests
9. **Document Test Strategy**: Explain testing approach and coverage goals
10. **Review Test Code**: Treat test code with same care as production code

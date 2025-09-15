# CS-320 Test Automation Frameworks

## 🎯 Purpose
Demonstrate test automation frameworks, continuous integration, and test management strategies for software quality assurance.

## 📝 Test Automation Examples

### TestNG Framework (Java)

#### TestNG Configuration and Test Classes
```java
// TestNG XML Configuration
// testng.xml
<?xml version="1.0" encoding="UTF-8"?>
<suite name="UserManagementTestSuite" parallel="tests" thread-count="3">
    <test name="UserRegistrationTests">
        <parameter name="browser" value="chrome"/>
        <classes>
            <class name="com.example.tests.UserRegistrationTest"/>
        </classes>
    </test>
    
    <test name="UserAuthenticationTests">
        <parameter name="browser" value="firefox"/>
        <classes>
            <class name="com.example.tests.UserAuthenticationTest"/>
        </classes>
    </test>
    
    <test name="UserManagementTests">
        <parameter name="browser" value="chrome"/>
        <classes>
            <class name="com.example.tests.UserManagementTest"/>
        </classes>
    </test>
</suite>

// BaseTestNG.java
import org.testng.annotations.*;
import org.testng.ITestResult;
import org.testng.ITestListener;
import org.openqa.selenium.WebDriver;
import org.openqa.selenium.chrome.ChromeDriver;
import org.openqa.selenium.firefox.FirefoxDriver;
import org.openqa.selenium.support.ui.WebDriverWait;
import java.time.Duration;
import java.io.File;
import java.io.IOException;
import org.apache.commons.io.FileUtils;
import org.openqa.selenium.OutputType;
import org.openqa.selenium.TakesScreenshot;

public class BaseTestNG implements ITestListener {
    protected WebDriver driver;
    protected WebDriverWait wait;
    protected String baseUrl = "http://localhost:3000";
    
    @BeforeSuite
    public void setUpSuite() {
        System.out.println("Starting test suite execution");
    }
    
    @BeforeTest
    @Parameters("browser")
    public void setUpTest(String browser) {
        if (browser.equalsIgnoreCase("chrome")) {
            System.setProperty("webdriver.chrome.driver", "path/to/chromedriver");
            driver = new ChromeDriver();
        } else if (browser.equalsIgnoreCase("firefox")) {
            System.setProperty("webdriver.gecko.driver", "path/to/geckodriver");
            driver = new FirefoxDriver();
        }
        
        wait = new WebDriverWait(driver, Duration.ofSeconds(10));
        driver.manage().window().maximize();
        driver.manage().timeouts().implicitlyWait(Duration.ofSeconds(5));
    }
    
    @BeforeMethod
    public void setUpMethod() {
        driver.get(baseUrl);
    }
    
    @AfterMethod
    public void tearDownMethod(ITestResult result) {
        if (result.getStatus() == ITestResult.FAILURE) {
            takeScreenshot(result.getName());
        }
    }
    
    @AfterTest
    public void tearDownTest() {
        if (driver != null) {
            driver.quit();
        }
    }
    
    @AfterSuite
    public void tearDownSuite() {
        System.out.println("Test suite execution completed");
    }
    
    private void takeScreenshot(String testName) {
        try {
            File screenshot = ((TakesScreenshot) driver).getScreenshotAs(OutputType.FILE);
            FileUtils.copyFile(screenshot, new File("screenshots/" + testName + "_" + System.currentTimeMillis() + ".png"));
        } catch (IOException e) {
            e.printStackTrace();
        }
    }
    
    // ITestListener methods
    @Override
    public void onTestStart(ITestResult result) {
        System.out.println("Starting test: " + result.getName());
    }
    
    @Override
    public void onTestSuccess(ITestResult result) {
        System.out.println("Test passed: " + result.getName());
    }
    
    @Override
    public void onTestFailure(ITestResult result) {
        System.out.println("Test failed: " + result.getName());
    }
    
    @Override
    public void onTestSkipped(ITestResult result) {
        System.out.println("Test skipped: " + result.getName());
    }
}

// UserRegistrationTestNG.java
import org.testng.annotations.*;
import org.testng.Assert;
import org.openqa.selenium.By;
import org.openqa.selenium.WebElement;
import org.openqa.selenium.support.ui.ExpectedConditions;

public class UserRegistrationTestNG extends BaseTestNG {
    
    @Test(priority = 1, description = "Register new user with valid data")
    public void testValidUserRegistration() {
        // Navigate to registration page
        driver.get(baseUrl + "/register");
        
        // Fill registration form
        WebElement nameField = wait.until(ExpectedConditions.visibilityOfElementLocated(By.id("name")));
        nameField.sendKeys("John Doe");
        
        WebElement emailField = driver.findElement(By.id("email"));
        emailField.sendKeys("john.doe@example.com");
        
        WebElement passwordField = driver.findElement(By.id("password"));
        passwordField.sendKeys("password123");
        
        WebElement ageField = driver.findElement(By.id("age"));
        ageField.sendKeys("25");
        
        // Submit form
        WebElement submitButton = driver.findElement(By.id("submit-button"));
        submitButton.click();
        
        // Verify success message
        WebElement successMessage = wait.until(ExpectedConditions.visibilityOfElementLocated(By.className("success-message")));
        Assert.assertTrue(successMessage.getText().contains("User registered successfully"));
    }
    
    @Test(priority = 2, description = "Validate required fields", dataProvider = "invalidRegistrationData")
    public void testInvalidUserRegistration(String name, String email, String password, String age, String expectedError) {
        driver.get(baseUrl + "/register");
        
        if (!name.isEmpty()) {
            driver.findElement(By.id("name")).sendKeys(name);
        }
        if (!email.isEmpty()) {
            driver.findElement(By.id("email")).sendKeys(email);
        }
        if (!password.isEmpty()) {
            driver.findElement(By.id("password")).sendKeys(password);
        }
        if (!age.isEmpty()) {
            driver.findElement(By.id("age")).sendKeys(age);
        }
        
        driver.findElement(By.id("submit-button")).click();
        
        // Verify validation error
        WebElement errorElement = wait.until(ExpectedConditions.visibilityOfElementLocated(By.className("error-message")));
        Assert.assertTrue(errorElement.getText().contains(expectedError));
    }
    
    @Test(priority = 3, description = "Prevent duplicate email registration")
    public void testDuplicateEmailRegistration() {
        // First registration
        testValidUserRegistration();
        
        // Try to register with same email
        driver.get(baseUrl + "/register");
        driver.findElement(By.id("name")).sendKeys("Another User");
        driver.findElement(By.id("email")).sendKeys("john.doe@example.com");
        driver.findElement(By.id("password")).sendKeys("password123");
        driver.findElement(By.id("age")).sendKeys("30");
        
        driver.findElement(By.id("submit-button")).click();
        
        // Verify error message
        WebElement errorMessage = wait.until(ExpectedConditions.visibilityOfElementLocated(By.className("error-message")));
        Assert.assertTrue(errorMessage.getText().contains("Email already exists"));
    }
    
    @DataProvider(name = "invalidRegistrationData")
    public Object[][] getInvalidRegistrationData() {
        return new Object[][] {
            {"", "test@example.com", "password123", "25", "Name is required"},
            {"Test User", "", "password123", "25", "Email is required"},
            {"Test User", "test@example.com", "", "25", "Password is required"},
            {"Test User", "test@example.com", "password123", "150", "Age must be less than 120"},
            {"Test User", "invalid-email", "password123", "25", "Invalid email format"}
        };
    }
    
    @Test(priority = 4, description = "Test registration with boundary values", dataProvider = "boundaryValueData")
    public void testBoundaryValueRegistration(String name, String email, String password, String age, boolean shouldPass) {
        driver.get(baseUrl + "/register");
        
        driver.findElement(By.id("name")).sendKeys(name);
        driver.findElement(By.id("email")).sendKeys(email);
        driver.findElement(By.id("password")).sendKeys(password);
        driver.findElement(By.id("age")).sendKeys(age);
        
        driver.findElement(By.id("submit-button")).click();
        
        if (shouldPass) {
            WebElement successMessage = wait.until(ExpectedConditions.visibilityOfElementLocated(By.className("success-message")));
            Assert.assertTrue(successMessage.getText().contains("User registered successfully"));
        } else {
            WebElement errorMessage = wait.until(ExpectedConditions.visibilityOfElementLocated(By.className("error-message")));
            Assert.assertTrue(errorMessage.isDisplayed());
        }
    }
    
    @DataProvider(name = "boundaryValueData")
    public Object[][] getBoundaryValueData() {
        return new Object[][] {
            {"A", "a@b.com", "123456", "0", true}, // Minimum valid values
            {"A".repeat(50), "test@example.com", "123456", "120", true}, // Maximum valid values
            {"", "test@example.com", "123456", "25", false}, // Empty name
            {"Test", "test@example.com", "12345", "25", false}, // Password too short
            {"Test", "test@example.com", "123456", "121", false} // Age too high
        };
    }
}
```

### Jest Testing Framework (JavaScript)

#### Jest Configuration and Test Setup
```javascript
// jest.config.js
module.exports = {
  testEnvironment: 'jsdom',
  setupFilesAfterEnv: ['<rootDir>/src/setupTests.js'],
  testMatch: [
    '<rootDir>/src/**/__tests__/**/*.{js,jsx,ts,tsx}',
    '<rootDir>/src/**/*.{test,spec}.{js,jsx,ts,tsx}'
  ],
  collectCoverageFrom: [
    'src/**/*.{js,jsx,ts,tsx}',
    '!src/**/*.d.ts',
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
  },
  moduleNameMapping: {
    '\\.(css|less|scss|sass)$': 'identity-obj-proxy',
    '\\.(jpg|jpeg|png|gif|eot|otf|webp|svg|ttf|woff|woff2|mp4|webm|wav|mp3|m4a|aac|oga)$': 'jest-transform-stub'
  },
  transform: {
    '^.+\\.(js|jsx|ts|tsx)$': 'babel-jest'
  }
};

// src/setupTests.js
import '@testing-library/jest-dom';
import { configure } from '@testing-library/react';

// Configure testing library
configure({ testIdAttribute: 'data-testid' });

// Mock window.matchMedia
Object.defineProperty(window, 'matchMedia', {
  writable: true,
  value: jest.fn().mockImplementation(query => ({
    matches: false,
    media: query,
    onchange: null,
    addListener: jest.fn(),
    removeListener: jest.fn(),
    addEventListener: jest.fn(),
    removeEventListener: jest.fn(),
    dispatchEvent: jest.fn(),
  })),
});

// Mock IntersectionObserver
global.IntersectionObserver = class IntersectionObserver {
  constructor() {}
  observe() {
    return null;
  }
  disconnect() {
    return null;
  }
  unobserve() {
    return null;
  }
};

// UserService.test.js
import { UserService } from '../services/UserService';
import { apiClient } from '../utils/apiClient';

// Mock the API client
jest.mock('../utils/apiClient');

describe('UserService', () => {
  beforeEach(() => {
    jest.clearAllMocks();
  });

  describe('getUsers', () => {
    it('should fetch users successfully', async () => {
      const mockUsers = [
        { id: 1, name: 'John Doe', email: 'john@example.com', age: 25 },
        { id: 2, name: 'Jane Smith', email: 'jane@example.com', age: 30 }
      ];

      apiClient.get.mockResolvedValue({ data: mockUsers });

      const result = await UserService.getUsers();

      expect(apiClient.get).toHaveBeenCalledWith('/users');
      expect(result).toEqual(mockUsers);
    });

    it('should handle API errors', async () => {
      const errorMessage = 'Network Error';
      apiClient.get.mockRejectedValue(new Error(errorMessage));

      await expect(UserService.getUsers()).rejects.toThrow(errorMessage);
    });

    it('should fetch users with filters', async () => {
      const filters = { search: 'john', role: 'user' };
      const mockUsers = [{ id: 1, name: 'John Doe', email: 'john@example.com' }];

      apiClient.get.mockResolvedValue({ data: mockUsers });

      await UserService.getUsers(filters);

      expect(apiClient.get).toHaveBeenCalledWith('/users', { params: filters });
    });
  });

  describe('createUser', () => {
    it('should create user successfully', async () => {
      const userData = {
        name: 'John Doe',
        email: 'john@example.com',
        password: 'password123',
        age: 25
      };

      const mockResponse = { id: 1, ...userData };
      apiClient.post.mockResolvedValue({ data: mockResponse });

      const result = await UserService.createUser(userData);

      expect(apiClient.post).toHaveBeenCalledWith('/users', userData);
      expect(result).toEqual(mockResponse);
    });

    it('should handle validation errors', async () => {
      const userData = { name: '', email: 'invalid-email' };
      const errorResponse = {
        response: {
          status: 400,
          data: { errors: ['Name is required', 'Invalid email format'] }
        }
      };

      apiClient.post.mockRejectedValue(errorResponse);

      await expect(UserService.createUser(userData)).rejects.toEqual(errorResponse);
    });
  });

  describe('updateUser', () => {
    it('should update user successfully', async () => {
      const userId = 1;
      const updateData = { name: 'Updated Name', age: 26 };
      const mockResponse = { id: userId, ...updateData };

      apiClient.put.mockResolvedValue({ data: mockResponse });

      const result = await UserService.updateUser(userId, updateData);

      expect(apiClient.put).toHaveBeenCalledWith(`/users/${userId}`, updateData);
      expect(result).toEqual(mockResponse);
    });
  });

  describe('deleteUser', () => {
    it('should delete user successfully', async () => {
      const userId = 1;
      apiClient.delete.mockResolvedValue({ data: { message: 'User deleted successfully' } });

      await UserService.deleteUser(userId);

      expect(apiClient.delete).toHaveBeenCalledWith(`/users/${userId}`);
    });
  });
});

// UserForm.test.jsx
import React from 'react';
import { render, screen, fireEvent, waitFor } from '@testing-library/react';
import userEvent from '@testing-library/user-event';
import { UserForm } from '../components/UserForm';

describe('UserForm', () => {
  const mockOnSubmit = jest.fn();
  const mockOnCancel = jest.fn();

  beforeEach(() => {
    jest.clearAllMocks();
  });

  it('should render form fields correctly', () => {
    render(<UserForm onSubmit={mockOnSubmit} onCancel={mockOnCancel} />);

    expect(screen.getByLabelText(/name/i)).toBeInTheDocument();
    expect(screen.getByLabelText(/email/i)).toBeInTheDocument();
    expect(screen.getByLabelText(/password/i)).toBeInTheDocument();
    expect(screen.getByLabelText(/age/i)).toBeInTheDocument();
    expect(screen.getByRole('button', { name: /submit/i })).toBeInTheDocument();
    expect(screen.getByRole('button', { name: /cancel/i })).toBeInTheDocument();
  });

  it('should submit form with valid data', async () => {
    const user = userEvent.setup();
    render(<UserForm onSubmit={mockOnSubmit} onCancel={mockOnCancel} />);

    await user.type(screen.getByLabelText(/name/i), 'John Doe');
    await user.type(screen.getByLabelText(/email/i), 'john@example.com');
    await user.type(screen.getByLabelText(/password/i), 'password123');
    await user.type(screen.getByLabelText(/age/i), '25');

    await user.click(screen.getByRole('button', { name: /submit/i }));

    await waitFor(() => {
      expect(mockOnSubmit).toHaveBeenCalledWith({
        name: 'John Doe',
        email: 'john@example.com',
        password: 'password123',
        age: 25
      });
    });
  });

  it('should show validation errors for invalid input', async () => {
    const user = userEvent.setup();
    render(<UserForm onSubmit={mockOnSubmit} onCancel={mockOnCancel} />);

    // Try to submit empty form
    await user.click(screen.getByRole('button', { name: /submit/i }));

    await waitFor(() => {
      expect(screen.getByText(/name is required/i)).toBeInTheDocument();
      expect(screen.getByText(/email is required/i)).toBeInTheDocument();
      expect(screen.getByText(/password is required/i)).toBeInTheDocument();
    });

    expect(mockOnSubmit).not.toHaveBeenCalled();
  });

  it('should call onCancel when cancel button is clicked', async () => {
    const user = userEvent.setup();
    render(<UserForm onSubmit={mockOnSubmit} onCancel={mockOnCancel} />);

    await user.click(screen.getByRole('button', { name: /cancel/i }));

    expect(mockOnCancel).toHaveBeenCalled();
  });

  it('should populate form with initial data when editing', () => {
    const initialData = {
      name: 'John Doe',
      email: 'john@example.com',
      age: 25
    };

    render(
      <UserForm
        onSubmit={mockOnSubmit}
        onCancel={mockOnCancel}
        initialData={initialData}
      />
    );

    expect(screen.getByDisplayValue('John Doe')).toBeInTheDocument();
    expect(screen.getByDisplayValue('john@example.com')).toBeInTheDocument();
    expect(screen.getByDisplayValue('25')).toBeInTheDocument();
  });

  it('should disable submit button while submitting', async () => {
    const user = userEvent.setup();
    const slowSubmit = jest.fn().mockImplementation(() => new Promise(resolve => setTimeout(resolve, 1000)));
    
    render(<UserForm onSubmit={slowSubmit} onCancel={mockOnCancel} />);

    await user.type(screen.getByLabelText(/name/i), 'John Doe');
    await user.type(screen.getByLabelText(/email/i), 'john@example.com');
    await user.type(screen.getByLabelText(/password/i), 'password123');
    await user.type(screen.getByLabelText(/age/i), '25');

    const submitButton = screen.getByRole('button', { name: /submit/i });
    await user.click(submitButton);

    expect(submitButton).toBeDisabled();
    expect(screen.getByText(/submitting/i)).toBeInTheDocument();
  });
});

// UserList.test.jsx
import React from 'react';
import { render, screen, waitFor } from '@testing-library/react';
import userEvent from '@testing-library/user-event';
import { UserList } from '../components/UserList';
import { UserService } from '../services/UserService';

jest.mock('../services/UserService');

describe('UserList', () => {
  const mockUsers = [
    { id: 1, name: 'John Doe', email: 'john@example.com', age: 25, role: 'user' },
    { id: 2, name: 'Jane Smith', email: 'jane@example.com', age: 30, role: 'admin' }
  ];

  beforeEach(() => {
    jest.clearAllMocks();
  });

  it('should display users list', async () => {
    UserService.getUsers.mockResolvedValue(mockUsers);

    render(<UserList />);

    await waitFor(() => {
      expect(screen.getByText('John Doe')).toBeInTheDocument();
      expect(screen.getByText('Jane Smith')).toBeInTheDocument();
    });
  });

  it('should handle loading state', () => {
    UserService.getUsers.mockImplementation(() => new Promise(() => {})); // Never resolves

    render(<UserList />);

    expect(screen.getByText(/loading/i)).toBeInTheDocument();
  });

  it('should handle error state', async () => {
    UserService.getUsers.mockRejectedValue(new Error('Failed to fetch users'));

    render(<UserList />);

    await waitFor(() => {
      expect(screen.getByText(/error loading users/i)).toBeInTheDocument();
    });
  });

  it('should search users', async () => {
    const user = userEvent.setup();
    UserService.getUsers.mockResolvedValue(mockUsers);

    render(<UserList />);

    await waitFor(() => {
      expect(screen.getByText('John Doe')).toBeInTheDocument();
    });

    const searchInput = screen.getByPlaceholderText(/search users/i);
    await user.type(searchInput, 'john');

    await waitFor(() => {
      expect(UserService.getUsers).toHaveBeenCalledWith({ search: 'john' });
    });
  });

  it('should delete user', async () => {
    const user = userEvent.setup();
    UserService.getUsers.mockResolvedValue(mockUsers);
    UserService.deleteUser.mockResolvedValue();

    render(<UserList />);

    await waitFor(() => {
      expect(screen.getByText('John Doe')).toBeInTheDocument();
    });

    const deleteButton = screen.getAllByRole('button', { name: /delete/i })[0];
    await user.click(deleteButton);

    // Confirm deletion
    const confirmButton = screen.getByRole('button', { name: /confirm/i });
    await user.click(confirmButton);

    await waitFor(() => {
      expect(UserService.deleteUser).toHaveBeenCalledWith(1);
    });
  });
});
```

### Continuous Integration with GitHub Actions

#### GitHub Actions Workflow
```yaml
# .github/workflows/test.yml
name: Test Suite

on:
  push:
    branches: [ main, develop ]
  pull_request:
    branches: [ main ]

jobs:
  unit-tests:
    runs-on: ubuntu-latest
    
    strategy:
      matrix:
        node-version: [16.x, 18.x, 20.x]
    
    steps:
    - uses: actions/checkout@v3
    
    - name: Use Node.js ${{ matrix.node-version }}
      uses: actions/setup-node@v3
      with:
        node-version: ${{ matrix.node-version }}
        cache: 'npm'
    
    - name: Install dependencies
      run: npm ci
    
    - name: Run linting
      run: npm run lint
    
    - name: Run unit tests
      run: npm run test:unit
    
    - name: Generate coverage report
      run: npm run test:coverage
    
    - name: Upload coverage to Codecov
      uses: codecov/codecov-action@v3
      with:
        file: ./coverage/lcov.info
        flags: unittests
        name: codecov-umbrella

  integration-tests:
    runs-on: ubuntu-latest
    
    services:
      postgres:
        image: postgres:13
        env:
          POSTGRES_PASSWORD: postgres
          POSTGRES_DB: testdb
        options: >-
          --health-cmd pg_isready
          --health-interval 10s
          --health-timeout 5s
          --health-retries 5
        ports:
          - 5432:5432
      
      redis:
        image: redis:6
        options: >-
          --health-cmd "redis-cli ping"
          --health-interval 10s
          --health-timeout 5s
          --health-retries 5
        ports:
          - 6379:6379
    
    steps:
    - uses: actions/checkout@v3
    
    - name: Use Node.js 18.x
      uses: actions/setup-node@v3
      with:
        node-version: 18.x
        cache: 'npm'
    
    - name: Install dependencies
      run: npm ci
    
    - name: Run database migrations
      run: npm run migrate:test
      env:
        DATABASE_URL: postgresql://postgres:postgres@localhost:5432/testdb
        REDIS_URL: redis://localhost:6379
    
    - name: Run integration tests
      run: npm run test:integration
      env:
        DATABASE_URL: postgresql://postgres:postgres@localhost:5432/testdb
        REDIS_URL: redis://localhost:6379
        JWT_SECRET: test-secret

  e2e-tests:
    runs-on: ubuntu-latest
    
    strategy:
      matrix:
        browser: [chrome, firefox]
    
    steps:
    - uses: actions/checkout@v3
    
    - name: Use Node.js 18.x
      uses: actions/setup-node@v3
      with:
        node-version: 18.x
        cache: 'npm'
    
    - name: Install dependencies
      run: npm ci
    
    - name: Build application
      run: npm run build
    
    - name: Start application
      run: |
        npm start &
        sleep 10
      env:
        NODE_ENV: test
        PORT: 3000
    
    - name: Run E2E tests
      run: npm run test:e2e -- --browser ${{ matrix.browser }}
    
    - name: Upload test results
      uses: actions/upload-artifact@v3
      if: always()
      with:
        name: e2e-test-results-${{ matrix.browser }}
        path: test-results/

  performance-tests:
    runs-on: ubuntu-latest
    
    steps:
    - uses: actions/checkout@v3
    
    - name: Use Node.js 18.x
      uses: actions/setup-node@v3
      with:
        node-version: 18.x
        cache: 'npm'
    
    - name: Install dependencies
      run: npm ci
    
    - name: Build application
      run: npm run build
    
    - name: Start application
      run: |
        npm start &
        sleep 10
    
    - name: Run performance tests
      run: npm run test:performance
    
    - name: Upload performance results
      uses: actions/upload-artifact@v3
      with:
        name: performance-test-results
        path: performance-results/

  security-tests:
    runs-on: ubuntu-latest
    
    steps:
    - uses: actions/checkout@v3
    
    - name: Use Node.js 18.x
      uses: actions/setup-node@v3
      with:
        node-version: 18.x
        cache: 'npm'
    
    - name: Install dependencies
      run: npm ci
    
    - name: Run security audit
      run: npm audit --audit-level moderate
    
    - name: Run dependency check
      run: npm run security:check
    
    - name: Run SAST scan
      uses: github/super-linter@v4
      env:
        DEFAULT_BRANCH: main
        GITHUB_TOKEN: ${{ secrets.GITHUB_TOKEN }}
        VALIDATE_JAVASCRIPT_ES: true
        VALIDATE_TYPESCRIPT_ES: true
```

## 🔍 Test Automation Concepts
- **Test Frameworks**: TestNG, Jest, and other testing frameworks
- **Continuous Integration**: Automated testing in CI/CD pipelines
- **Test Data Management**: Managing test data and test environments
- **Test Reporting**: Generating and analyzing test reports
- **Test Maintenance**: Keeping tests up-to-date and reliable

## 💡 Learning Points
- Test automation frameworks provide structure and utilities for testing
- Continuous integration ensures code quality through automated testing
- Proper test organization improves maintainability and reliability
- Test data management is crucial for consistent test results
- Performance and security testing should be integrated into the testing pipeline

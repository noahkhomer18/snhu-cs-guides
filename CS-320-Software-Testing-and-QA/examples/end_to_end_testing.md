# CS-320 End-to-End Testing

## 🎯 Purpose
Demonstrate end-to-end testing strategies, tools, and implementation for web applications using Selenium, Cypress, and Playwright.

## 📝 End-to-End Testing Examples

### Selenium WebDriver (Java)

#### Basic Selenium Test Framework
```java
// BaseTest.java
import org.openqa.selenium.WebDriver;
import org.openqa.selenium.chrome.ChromeDriver;
import org.openqa.selenium.chrome.ChromeOptions;
import org.openqa.selenium.firefox.FirefoxDriver;
import org.openqa.selenium.firefox.FirefoxOptions;
import org.openqa.selenium.support.ui.WebDriverWait;
import org.testng.annotations.AfterMethod;
import org.testng.annotations.BeforeMethod;
import org.testng.annotations.Parameters;
import java.time.Duration;

public class BaseTest {
    protected WebDriver driver;
    protected WebDriverWait wait;
    protected String baseUrl = "http://localhost:3000";
    
    @BeforeMethod
    @Parameters("browser")
    public void setUp(String browser) {
        if (browser.equalsIgnoreCase("chrome")) {
            ChromeOptions options = new ChromeOptions();
            options.addArguments("--headless");
            options.addArguments("--no-sandbox");
            options.addArguments("--disable-dev-shm-usage");
            driver = new ChromeDriver(options);
        } else if (browser.equalsIgnoreCase("firefox")) {
            FirefoxOptions options = new FirefoxOptions();
            options.addArguments("--headless");
            driver = new FirefoxDriver(options);
        }
        
        wait = new WebDriverWait(driver, Duration.ofSeconds(10));
        driver.manage().window().maximize();
        driver.manage().timeouts().implicitlyWait(Duration.ofSeconds(5));
    }
    
    @AfterMethod
    public void tearDown() {
        if (driver != null) {
            driver.quit();
        }
    }
}

// UserManagementTest.java
import org.openqa.selenium.By;
import org.openqa.selenium.WebElement;
import org.openqa.selenium.support.ui.ExpectedConditions;
import org.openqa.selenium.support.ui.Select;
import org.testng.Assert;
import org.testng.annotations.Test;
import java.util.List;

public class UserManagementTest extends BaseTest {
    
    @Test
    public void testUserRegistration() {
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
        
        // Verify redirect to user list
        wait.until(ExpectedConditions.urlContains("/users"));
        Assert.assertTrue(driver.getCurrentUrl().contains("/users"));
    }
    
    @Test
    public void testUserLogin() {
        // Navigate to login page
        driver.get(baseUrl + "/login");
        
        // Fill login form
        WebElement emailField = wait.until(ExpectedConditions.visibilityOfElementLocated(By.id("email")));
        emailField.sendKeys("admin@example.com");
        
        WebElement passwordField = driver.findElement(By.id("password"));
        passwordField.sendKeys("admin123");
        
        // Submit form
        WebElement loginButton = driver.findElement(By.id("login-button"));
        loginButton.click();
        
        // Verify successful login
        wait.until(ExpectedConditions.urlContains("/dashboard"));
        WebElement welcomeMessage = driver.findElement(By.className("welcome-message"));
        Assert.assertTrue(welcomeMessage.getText().contains("Welcome"));
    }
    
    @Test
    public void testUserListDisplay() {
        // Login first
        loginAsAdmin();
        
        // Navigate to user list
        driver.get(baseUrl + "/users");
        
        // Wait for user list to load
        WebElement userTable = wait.until(ExpectedConditions.visibilityOfElementLocated(By.id("user-table")));
        
        // Verify table headers
        List<WebElement> headers = driver.findElements(By.tagName("th"));
        Assert.assertEquals(headers.size(), 5);
        Assert.assertEquals(headers.get(0).getText(), "Name");
        Assert.assertEquals(headers.get(1).getText(), "Email");
        Assert.assertEquals(headers.get(2).getText(), "Age");
        Assert.assertEquals(headers.get(3).getText(), "Role");
        Assert.assertEquals(headers.get(4).getText(), "Actions");
        
        // Verify at least one user is displayed
        List<WebElement> userRows = driver.findElements(By.cssSelector("tbody tr"));
        Assert.assertTrue(userRows.size() > 0);
    }
    
    @Test
    public void testUserSearch() {
        // Login first
        loginAsAdmin();
        
        // Navigate to user list
        driver.get(baseUrl + "/users");
        
        // Enter search term
        WebElement searchField = wait.until(ExpectedConditions.visibilityOfElementLocated(By.id("search-input")));
        searchField.sendKeys("admin");
        
        // Click search button
        WebElement searchButton = driver.findElement(By.id("search-button"));
        searchButton.click();
        
        // Wait for results
        wait.until(ExpectedConditions.visibilityOfElementLocated(By.id("user-table")));
        
        // Verify search results
        List<WebElement> userRows = driver.findElements(By.cssSelector("tbody tr"));
        for (WebElement row : userRows) {
            String rowText = row.getText().toLowerCase();
            Assert.assertTrue(rowText.contains("admin"));
        }
    }
    
    @Test
    public void testUserEdit() {
        // Login first
        loginAsAdmin();
        
        // Navigate to user list
        driver.get(baseUrl + "/users");
        
        // Click edit button for first user
        WebElement editButton = wait.until(ExpectedConditions.elementToBeClickable(By.cssSelector("tbody tr:first-child .edit-button")));
        editButton.click();
        
        // Wait for edit form
        WebElement editForm = wait.until(ExpectedConditions.visibilityOfElementLocated(By.id("edit-form")));
        
        // Update user name
        WebElement nameField = driver.findElement(By.id("edit-name"));
        nameField.clear();
        nameField.sendKeys("Updated Name");
        
        // Submit form
        WebElement saveButton = driver.findElement(By.id("save-button"));
        saveButton.click();
        
        // Verify success message
        WebElement successMessage = wait.until(ExpectedConditions.visibilityOfElementLocated(By.className("success-message")));
        Assert.assertTrue(successMessage.getText().contains("User updated successfully"));
    }
    
    @Test
    public void testUserDelete() {
        // Login first
        loginAsAdmin();
        
        // Navigate to user list
        driver.get(baseUrl + "/users");
        
        // Get initial user count
        List<WebElement> initialRows = driver.findElements(By.cssSelector("tbody tr"));
        int initialCount = initialRows.size();
        
        // Click delete button for first user
        WebElement deleteButton = wait.until(ExpectedConditions.elementToBeClickable(By.cssSelector("tbody tr:first-child .delete-button")));
        deleteButton.click();
        
        // Confirm deletion in alert
        driver.switchTo().alert().accept();
        
        // Wait for user list to update
        wait.until(ExpectedConditions.numberOfElementsToBe(By.cssSelector("tbody tr"), initialCount - 1));
        
        // Verify user count decreased
        List<WebElement> updatedRows = driver.findElements(By.cssSelector("tbody tr"));
        Assert.assertEquals(updatedRows.size(), initialCount - 1);
    }
    
    @Test
    public void testFormValidation() {
        // Navigate to registration page
        driver.get(baseUrl + "/register");
        
        // Try to submit empty form
        WebElement submitButton = wait.until(ExpectedConditions.elementToBeClickable(By.id("submit-button")));
        submitButton.click();
        
        // Verify validation errors
        WebElement nameError = wait.until(ExpectedConditions.visibilityOfElementLocated(By.id("name-error")));
        Assert.assertTrue(nameError.getText().contains("Name is required"));
        
        WebElement emailError = driver.findElement(By.id("email-error"));
        Assert.assertTrue(emailError.getText().contains("Email is required"));
        
        WebElement passwordError = driver.findElement(By.id("password-error"));
        Assert.assertTrue(passwordError.getText().contains("Password is required"));
    }
    
    private void loginAsAdmin() {
        driver.get(baseUrl + "/login");
        
        WebElement emailField = wait.until(ExpectedConditions.visibilityOfElementLocated(By.id("email")));
        emailField.sendKeys("admin@example.com");
        
        WebElement passwordField = driver.findElement(By.id("password"));
        passwordField.sendKeys("admin123");
        
        WebElement loginButton = driver.findElement(By.id("login-button"));
        loginButton.click();
        
        wait.until(ExpectedConditions.urlContains("/dashboard"));
    }
}
```

### Cypress (JavaScript)

#### Cypress Test Suite
```javascript
// cypress/integration/user-management.spec.js
describe('User Management E2E Tests', () => {
  beforeEach(() => {
    // Visit the application
    cy.visit('/');
  });

  describe('User Registration', () => {
    it('should register a new user successfully', () => {
      // Navigate to registration page
      cy.visit('/register');
      
      // Fill registration form
      cy.get('[data-testid="name-input"]').type('Jane Smith');
      cy.get('[data-testid="email-input"]').type('jane.smith@example.com');
      cy.get('[data-testid="password-input"]').type('password123');
      cy.get('[data-testid="age-input"]').type('28');
      
      // Submit form
      cy.get('[data-testid="submit-button"]').click();
      
      // Verify success message
      cy.get('[data-testid="success-message"]')
        .should('be.visible')
        .and('contain', 'User registered successfully');
      
      // Verify redirect to user list
      cy.url().should('include', '/users');
    });

    it('should show validation errors for invalid input', () => {
      cy.visit('/register');
      
      // Try to submit empty form
      cy.get('[data-testid="submit-button"]').click();
      
      // Verify validation errors
      cy.get('[data-testid="name-error"]')
        .should('be.visible')
        .and('contain', 'Name is required');
      
      cy.get('[data-testid="email-error"]')
        .should('be.visible')
        .and('contain', 'Email is required');
      
      cy.get('[data-testid="password-error"]')
        .should('be.visible')
        .and('contain', 'Password is required');
    });

    it('should prevent duplicate email registration', () => {
      // First registration
      cy.registerUser('test@example.com', 'Test User', 'password123', 25);
      
      // Try to register with same email
      cy.visit('/register');
      cy.get('[data-testid="name-input"]').type('Another User');
      cy.get('[data-testid="email-input"]').type('test@example.com');
      cy.get('[data-testid="password-input"]').type('password123');
      cy.get('[data-testid="age-input"]').type('30');
      
      cy.get('[data-testid="submit-button"]').click();
      
      // Verify error message
      cy.get('[data-testid="error-message"]')
        .should('be.visible')
        .and('contain', 'Email already exists');
    });
  });

  describe('User Authentication', () => {
    it('should login with valid credentials', () => {
      // Create a user first
      cy.registerUser('login@example.com', 'Login User', 'password123', 25);
      
      // Login
      cy.visit('/login');
      cy.get('[data-testid="email-input"]').type('login@example.com');
      cy.get('[data-testid="password-input"]').type('password123');
      cy.get('[data-testid="login-button"]').click();
      
      // Verify successful login
      cy.url().should('include', '/dashboard');
      cy.get('[data-testid="welcome-message"]')
        .should('be.visible')
        .and('contain', 'Welcome');
    });

    it('should show error for invalid credentials', () => {
      cy.visit('/login');
      cy.get('[data-testid="email-input"]').type('invalid@example.com');
      cy.get('[data-testid="password-input"]').type('wrongpassword');
      cy.get('[data-testid="login-button"]').click();
      
      // Verify error message
      cy.get('[data-testid="error-message"]')
        .should('be.visible')
        .and('contain', 'Invalid credentials');
    });

    it('should logout successfully', () => {
      // Login first
      cy.login('admin@example.com', 'admin123');
      
      // Click logout button
      cy.get('[data-testid="logout-button"]').click();
      
      // Verify redirect to login page
      cy.url().should('include', '/login');
    });
  });

  describe('User Management', () => {
    beforeEach(() => {
      // Login as admin before each test
      cy.login('admin@example.com', 'admin123');
    });

    it('should display user list with correct data', () => {
      cy.visit('/users');
      
      // Verify table headers
      cy.get('[data-testid="user-table"]').within(() => {
        cy.get('th').should('have.length', 5);
        cy.get('th').eq(0).should('contain', 'Name');
        cy.get('th').eq(1).should('contain', 'Email');
        cy.get('th').eq(2).should('contain', 'Age');
        cy.get('th').eq(3).should('contain', 'Role');
        cy.get('th').eq(4).should('contain', 'Actions');
      });
      
      // Verify at least one user is displayed
      cy.get('[data-testid="user-table"] tbody tr').should('have.length.greaterThan', 0);
    });

    it('should search users by name and email', () => {
      cy.visit('/users');
      
      // Search for admin user
      cy.get('[data-testid="search-input"]').type('admin');
      cy.get('[data-testid="search-button"]').click();
      
      // Verify search results
      cy.get('[data-testid="user-table"] tbody tr').each(($row) => {
        cy.wrap($row).should('contain.text', 'admin');
      });
    });

    it('should filter users by role', () => {
      cy.visit('/users');
      
      // Filter by admin role
      cy.get('[data-testid="role-filter"]').select('admin');
      
      // Verify filtered results
      cy.get('[data-testid="user-table"] tbody tr').each(($row) => {
        cy.wrap($row).find('[data-testid="user-role"]').should('contain', 'admin');
      });
    });

    it('should edit user information', () => {
      cy.visit('/users');
      
      // Click edit button for first user
      cy.get('[data-testid="user-table"] tbody tr').first().within(() => {
        cy.get('[data-testid="edit-button"]').click();
      });
      
      // Update user name
      cy.get('[data-testid="edit-name-input"]').clear().type('Updated User Name');
      
      // Save changes
      cy.get('[data-testid="save-button"]').click();
      
      // Verify success message
      cy.get('[data-testid="success-message"]')
        .should('be.visible')
        .and('contain', 'User updated successfully');
      
      // Verify updated name in table
      cy.get('[data-testid="user-table"] tbody tr').first()
        .should('contain', 'Updated User Name');
    });

    it('should delete user with confirmation', () => {
      // Create a test user first
      cy.registerUser('delete@example.com', 'Delete User', 'password123', 25);
      
      cy.visit('/users');
      
      // Get initial user count
      cy.get('[data-testid="user-table"] tbody tr').then(($rows) => {
        const initialCount = $rows.length;
        
        // Click delete button for the test user
        cy.contains('Delete User').parent().within(() => {
          cy.get('[data-testid="delete-button"]').click();
        });
        
        // Confirm deletion
        cy.get('[data-testid="confirm-delete-button"]').click();
        
        // Verify user count decreased
        cy.get('[data-testid="user-table"] tbody tr')
          .should('have.length', initialCount - 1);
        
        // Verify user is no longer in the list
        cy.get('[data-testid="user-table"]').should('not.contain', 'Delete User');
      });
    });
  });

  describe('Responsive Design', () => {
    it('should work on mobile devices', () => {
      // Set mobile viewport
      cy.viewport('iphone-x');
      
      cy.visit('/users');
      
      // Verify mobile navigation
      cy.get('[data-testid="mobile-menu-button"]').should('be.visible');
      cy.get('[data-testid="mobile-menu-button"]').click();
      
      // Verify mobile menu items
      cy.get('[data-testid="mobile-menu"]').should('be.visible');
      cy.get('[data-testid="mobile-menu"]').within(() => {
        cy.get('[data-testid="users-link"]').should('be.visible');
        cy.get('[data-testid="profile-link"]').should('be.visible');
      });
    });

    it('should work on tablet devices', () => {
      // Set tablet viewport
      cy.viewport('ipad-2');
      
      cy.visit('/users');
      
      // Verify table is responsive
      cy.get('[data-testid="user-table"]').should('be.visible');
      
      // Verify search functionality works
      cy.get('[data-testid="search-input"]').should('be.visible');
      cy.get('[data-testid="search-input"]').type('admin');
      cy.get('[data-testid="search-button"]').click();
    });
  });
});

// cypress/support/commands.js
Cypress.Commands.add('registerUser', (email, name, password, age) => {
  cy.visit('/register');
  cy.get('[data-testid="name-input"]').type(name);
  cy.get('[data-testid="email-input"]').type(email);
  cy.get('[data-testid="password-input"]').type(password);
  cy.get('[data-testid="age-input"]').type(age.toString());
  cy.get('[data-testid="submit-button"]').click();
});

Cypress.Commands.add('login', (email, password) => {
  cy.visit('/login');
  cy.get('[data-testid="email-input"]').type(email);
  cy.get('[data-testid="password-input"]').type(password);
  cy.get('[data-testid="login-button"]').click();
  cy.url().should('include', '/dashboard');
});
```

### Playwright (TypeScript)

#### Playwright Test Suite
```typescript
// tests/user-management.spec.ts
import { test, expect, Page } from '@playwright/test';

test.describe('User Management E2E Tests', () => {
  let page: Page;

  test.beforeEach(async ({ browser }) => {
    page = await browser.newPage();
    await page.goto('/');
  });

  test.afterEach(async () => {
    await page.close();
  });

  test.describe('User Registration', () => {
    test('should register a new user successfully', async () => {
      await page.goto('/register');
      
      // Fill registration form
      await page.fill('[data-testid="name-input"]', 'John Doe');
      await page.fill('[data-testid="email-input"]', 'john.doe@example.com');
      await page.fill('[data-testid="password-input"]', 'password123');
      await page.fill('[data-testid="age-input"]', '25');
      
      // Submit form
      await page.click('[data-testid="submit-button"]');
      
      // Verify success message
      await expect(page.locator('[data-testid="success-message"]'))
        .toBeVisible()
        .and('contain.text', 'User registered successfully');
      
      // Verify redirect
      await expect(page).toHaveURL(/.*\/users/);
    });

    test('should show validation errors for invalid input', async () => {
      await page.goto('/register');
      
      // Try to submit empty form
      await page.click('[data-testid="submit-button"]');
      
      // Verify validation errors
      await expect(page.locator('[data-testid="name-error"]'))
        .toBeVisible()
        .and('contain.text', 'Name is required');
      
      await expect(page.locator('[data-testid="email-error"]'))
        .toBeVisible()
        .and('contain.text', 'Email is required');
    });
  });

  test.describe('User Authentication', () => {
    test('should login with valid credentials', async () => {
      // Create user first
      await registerUser('login@example.com', 'Login User', 'password123', 25);
      
      // Login
      await page.goto('/login');
      await page.fill('[data-testid="email-input"]', 'login@example.com');
      await page.fill('[data-testid="password-input"]', 'password123');
      await page.click('[data-testid="login-button"]');
      
      // Verify successful login
      await expect(page).toHaveURL(/.*\/dashboard/);
      await expect(page.locator('[data-testid="welcome-message"]'))
        .toBeVisible()
        .and('contain.text', 'Welcome');
    });

    test('should show error for invalid credentials', async () => {
      await page.goto('/login');
      await page.fill('[data-testid="email-input"]', 'invalid@example.com');
      await page.fill('[data-testid="password-input"]', 'wrongpassword');
      await page.click('[data-testid="login-button"]');
      
      // Verify error message
      await expect(page.locator('[data-testid="error-message"]'))
        .toBeVisible()
        .and('contain.text', 'Invalid credentials');
    });
  });

  test.describe('User Management', () => {
    test.beforeEach(async () => {
      // Login as admin
      await login('admin@example.com', 'admin123');
    });

    test('should display user list with pagination', async () => {
      await page.goto('/users');
      
      // Verify table is visible
      await expect(page.locator('[data-testid="user-table"]')).toBeVisible();
      
      // Verify pagination controls
      await expect(page.locator('[data-testid="pagination"]')).toBeVisible();
      
      // Test pagination
      if (await page.locator('[data-testid="next-page"]').isVisible()) {
        await page.click('[data-testid="next-page"]');
        await expect(page.locator('[data-testid="current-page"]'))
          .toHaveText('2');
      }
    });

    test('should search and filter users', async () => {
      await page.goto('/users');
      
      // Search functionality
      await page.fill('[data-testid="search-input"]', 'admin');
      await page.click('[data-testid="search-button"]');
      
      // Verify search results
      const userRows = page.locator('[data-testid="user-table"] tbody tr');
      const count = await userRows.count();
      
      for (let i = 0; i < count; i++) {
        await expect(userRows.nth(i)).toContainText('admin');
      }
      
      // Filter by role
      await page.selectOption('[data-testid="role-filter"]', 'admin');
      
      // Verify filtered results
      const roleElements = page.locator('[data-testid="user-role"]');
      const roleCount = await roleElements.count();
      
      for (let i = 0; i < roleCount; i++) {
        await expect(roleElements.nth(i)).toHaveText('admin');
      }
    });

    test('should edit user information', async () => {
      await page.goto('/users');
      
      // Click edit button for first user
      await page.locator('[data-testid="user-table"] tbody tr').first()
        .locator('[data-testid="edit-button"]').click();
      
      // Update user information
      await page.fill('[data-testid="edit-name-input"]', 'Updated Name');
      await page.fill('[data-testid="edit-age-input"]', '30');
      
      // Save changes
      await page.click('[data-testid="save-button"]');
      
      // Verify success message
      await expect(page.locator('[data-testid="success-message"]'))
        .toBeVisible()
        .and('contain.text', 'User updated successfully');
    });

    test('should delete user with confirmation', async () => {
      // Create a test user
      await registerUser('delete@example.com', 'Delete User', 'password123', 25);
      
      await page.goto('/users');
      
      // Get initial count
      const initialRows = page.locator('[data-testid="user-table"] tbody tr');
      const initialCount = await initialRows.count();
      
      // Delete user
      await page.locator('text=Delete User').locator('..')
        .locator('[data-testid="delete-button"]').click();
      
      // Confirm deletion
      await page.click('[data-testid="confirm-delete-button"]');
      
      // Verify user count decreased
      await expect(initialRows).toHaveCount(initialCount - 1);
      
      // Verify user is removed
      await expect(page.locator('[data-testid="user-table"]'))
        .not.toContainText('Delete User');
    });
  });

  test.describe('Cross-browser Testing', () => {
    test('should work in Chrome', async ({ browserName }) => {
      test.skip(browserName !== 'chromium');
      
      await page.goto('/users');
      await expect(page.locator('[data-testid="user-table"]')).toBeVisible();
    });

    test('should work in Firefox', async ({ browserName }) => {
      test.skip(browserName !== 'firefox');
      
      await page.goto('/users');
      await expect(page.locator('[data-testid="user-table"]')).toBeVisible();
    });

    test('should work in Safari', async ({ browserName }) => {
      test.skip(browserName !== 'webkit');
      
      await page.goto('/users');
      await expect(page.locator('[data-testid="user-table"]')).toBeVisible();
    });
  });

  test.describe('Performance Testing', () => {
    test('should load user list within acceptable time', async () => {
      const startTime = Date.now();
      
      await page.goto('/users');
      await page.waitForSelector('[data-testid="user-table"]');
      
      const loadTime = Date.now() - startTime;
      expect(loadTime).toBeLessThan(3000); // Should load within 3 seconds
    });

    test('should handle large datasets efficiently', async () => {
      // Create multiple users for testing
      for (let i = 0; i < 50; i++) {
        await registerUser(`user${i}@example.com`, `User ${i}`, 'password123', 25);
      }
      
      await page.goto('/users');
      
      // Verify pagination works with large dataset
      await expect(page.locator('[data-testid="pagination"]')).toBeVisible();
      
      // Test search performance
      const searchStartTime = Date.now();
      await page.fill('[data-testid="search-input"]', 'User');
      await page.click('[data-testid="search-button"]');
      await page.waitForSelector('[data-testid="user-table"] tbody tr');
      
      const searchTime = Date.now() - searchStartTime;
      expect(searchTime).toBeLessThan(2000); // Search should complete within 2 seconds
    });
  });

  // Helper functions
  async function registerUser(email: string, name: string, password: string, age: number) {
    await page.goto('/register');
    await page.fill('[data-testid="name-input"]', name);
    await page.fill('[data-testid="email-input"]', email);
    await page.fill('[data-testid="password-input"]', password);
    await page.fill('[data-testid="age-input"]', age.toString());
    await page.click('[data-testid="submit-button"]');
  }

  async function login(email: string, password: string) {
    await page.goto('/login');
    await page.fill('[data-testid="email-input"]', email);
    await page.fill('[data-testid="password-input"]', password);
    await page.click('[data-testid="login-button"]');
    await page.waitForURL(/.*\/dashboard/);
  }
});
```

## 🔍 End-to-End Testing Concepts
- **Test Automation**: Automated testing of complete user workflows
- **Cross-browser Testing**: Ensuring compatibility across different browsers
- **Responsive Testing**: Testing on different screen sizes and devices
- **Performance Testing**: Measuring application performance under load
- **User Journey Testing**: Testing complete user scenarios from start to finish

## 💡 Learning Points
- E2E tests verify the entire application workflow
- Test data management is crucial for reliable tests
- Cross-browser testing ensures compatibility
- Performance testing validates application responsiveness
- Proper test organization improves maintainability

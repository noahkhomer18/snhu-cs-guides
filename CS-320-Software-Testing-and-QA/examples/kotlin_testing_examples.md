# CS-320 Kotlin Software Testing Examples

## 🎯 Purpose
Demonstrate software testing methodologies and frameworks in Kotlin including unit testing, integration testing, mocking, and test automation.

## 📝 Kotlin Testing Examples

### Unit Testing with JUnit 5
```kotlin
import org.junit.jupiter.api.Test
import org.junit.jupiter.api.Assertions.*
import org.junit.jupiter.api.BeforeEach
import org.junit.jupiter.api.DisplayName
import org.junit.jupiter.api.Nested
import org.junit.jupiter.params.ParameterizedTest
import org.junit.jupiter.params.provider.ValueSource
import org.junit.jupiter.params.provider.CsvSource

class Calculator {
    fun add(a: Int, b: Int): Int = a + b
    fun subtract(a: Int, b: Int): Int = a - b
    fun multiply(a: Int, b: Int): Int = a * b
    fun divide(a: Int, b: Int): Double {
        if (b == 0) throw IllegalArgumentException("Division by zero")
        return a.toDouble() / b
    }
    fun isEven(number: Int): Boolean = number % 2 == 0
    fun factorial(n: Int): Int {
        if (n < 0) throw IllegalArgumentException("Factorial not defined for negative numbers")
        return if (n <= 1) 1 else n * factorial(n - 1)
    }
}

class CalculatorTest {
    private lateinit var calculator: Calculator
    
    @BeforeEach
    fun setUp() {
        calculator = Calculator()
    }
    
    @Test
    @DisplayName("Addition should return correct result")
    fun testAddition() {
        // Arrange
        val a = 5
        val b = 3
        
        // Act
        val result = calculator.add(a, b)
        
        // Assert
        assertEquals(8, result)
    }
    
    @Test
    @DisplayName("Subtraction should return correct result")
    fun testSubtraction() {
        assertEquals(2, calculator.subtract(5, 3))
        assertEquals(-2, calculator.subtract(3, 5))
    }
    
    @Test
    @DisplayName("Multiplication should return correct result")
    fun testMultiplication() {
        assertEquals(15, calculator.multiply(5, 3))
        assertEquals(0, calculator.multiply(5, 0))
    }
    
    @Test
    @DisplayName("Division should return correct result")
    fun testDivision() {
        assertEquals(2.5, calculator.divide(5, 2), 0.001)
        assertEquals(1.0, calculator.divide(5, 5), 0.001)
    }
    
    @Test
    @DisplayName("Division by zero should throw exception")
    fun testDivisionByZero() {
        val exception = assertThrows(IllegalArgumentException::class.java) {
            calculator.divide(5, 0)
        }
        assertEquals("Division by zero", exception.message)
    }
    
    @ParameterizedTest
    @ValueSource(ints = [2, 4, 6, 8, 10])
    @DisplayName("Even numbers should return true")
    fun testIsEvenWithEvenNumbers(number: Int) {
        assertTrue(calculator.isEven(number))
    }
    
    @ParameterizedTest
    @ValueSource(ints = [1, 3, 5, 7, 9])
    @DisplayName("Odd numbers should return false")
    fun testIsEvenWithOddNumbers(number: Int) {
        assertFalse(calculator.isEven(number))
    }
    
    @ParameterizedTest
    @CsvSource(
        "0, 1",
        "1, 1",
        "2, 2",
        "3, 6",
        "4, 24",
        "5, 120"
    )
    @DisplayName("Factorial should return correct result")
    fun testFactorial(n: Int, expected: Int) {
        assertEquals(expected, calculator.factorial(n))
    }
    
    @Test
    @DisplayName("Factorial of negative number should throw exception")
    fun testFactorialNegative() {
        val exception = assertThrows(IllegalArgumentException::class.java) {
            calculator.factorial(-1)
        }
        assertEquals("Factorial not defined for negative numbers", exception.message)
    }
    
    @Nested
    @DisplayName("Edge Cases")
    inner class EdgeCases {
        @Test
        @DisplayName("Zero addition should return same number")
        fun testAddWithZero() {
            assertEquals(5, calculator.add(5, 0))
            assertEquals(3, calculator.add(0, 3))
        }
        
        @Test
        @DisplayName("Negative number operations")
        fun testNegativeNumbers() {
            assertEquals(-2, calculator.add(-5, 3))
            assertEquals(-8, calculator.subtract(-5, 3))
            assertEquals(-15, calculator.multiply(-5, 3))
        }
    }
}
```

### Mocking with MockK
```kotlin
import io.mockk.*
import org.junit.jupiter.api.Test
import org.junit.jupiter.api.Assertions.*
import org.junit.jupiter.api.BeforeEach

// Service interfaces
interface UserRepository {
    fun findById(id: Int): User?
    fun save(user: User): User
    fun delete(id: Int): Boolean
}

interface EmailService {
    fun sendEmail(to: String, subject: String, body: String): Boolean
}

// Domain models
data class User(
    val id: Int,
    val name: String,
    val email: String,
    val isActive: Boolean = true
)

// Service class
class UserService(
    private val userRepository: UserRepository,
    private val emailService: EmailService
) {
    fun createUser(name: String, email: String): User {
        val user = User(0, name, email)
        val savedUser = userRepository.save(user)
        emailService.sendEmail(email, "Welcome", "Welcome to our service!")
        return savedUser
    }
    
    fun deactivateUser(id: Int): Boolean {
        val user = userRepository.findById(id) ?: return false
        val deactivatedUser = user.copy(isActive = false)
        userRepository.save(deactivatedUser)
        emailService.sendEmail(user.email, "Account Deactivated", "Your account has been deactivated.")
        return true
    }
    
    fun getUserById(id: Int): User? {
        return userRepository.findById(id)
    }
}

class UserServiceTest {
    private lateinit var userRepository: UserRepository
    private lateinit var emailService: EmailService
    private lateinit var userService: UserService
    
    @BeforeEach
    fun setUp() {
        userRepository = mockk()
        emailService = mockk()
        userService = UserService(userRepository, emailService)
    }
    
    @Test
    fun `createUser should save user and send welcome email`() {
        // Arrange
        val name = "John Doe"
        val email = "john@example.com"
        val savedUser = User(1, name, email)
        
        every { userRepository.save(any()) } returns savedUser
        every { emailService.sendEmail(any(), any(), any()) } returns true
        
        // Act
        val result = userService.createUser(name, email)
        
        // Assert
        assertEquals(savedUser, result)
        verify { userRepository.save(match { it.name == name && it.email == email }) }
        verify { emailService.sendEmail(email, "Welcome", "Welcome to our service!") }
    }
    
    @Test
    fun `deactivateUser should deactivate user and send notification`() {
        // Arrange
        val userId = 1
        val user = User(userId, "John Doe", "john@example.com", true)
        val deactivatedUser = user.copy(isActive = false)
        
        every { userRepository.findById(userId) } returns user
        every { userRepository.save(any()) } returns deactivatedUser
        every { emailService.sendEmail(any(), any(), any()) } returns true
        
        // Act
        val result = userService.deactivateUser(userId)
        
        // Assert
        assertTrue(result)
        verify { userRepository.findById(userId) }
        verify { userRepository.save(match { !it.isActive }) }
        verify { emailService.sendEmail(user.email, "Account Deactivated", "Your account has been deactivated.") }
    }
    
    @Test
    fun `deactivateUser should return false when user not found`() {
        // Arrange
        val userId = 999
        every { userRepository.findById(userId) } returns null
        
        // Act
        val result = userService.deactivateUser(userId)
        
        // Assert
        assertFalse(result)
        verify { userRepository.findById(userId) }
        verify(exactly = 0) { userRepository.save(any()) }
        verify(exactly = 0) { emailService.sendEmail(any(), any(), any()) }
    }
    
    @Test
    fun `getUserById should return user when found`() {
        // Arrange
        val userId = 1
        val user = User(userId, "John Doe", "john@example.com")
        every { userRepository.findById(userId) } returns user
        
        // Act
        val result = userService.getUserById(userId)
        
        // Assert
        assertEquals(user, result)
        verify { userRepository.findById(userId) }
    }
    
    @Test
    fun `getUserById should return null when user not found`() {
        // Arrange
        val userId = 999
        every { userRepository.findById(userId) } returns null
        
        // Act
        val result = userService.getUserById(userId)
        
        // Assert
        assertNull(result)
        verify { userRepository.findById(userId) }
    }
}
```

### Integration Testing
```kotlin
import org.junit.jupiter.api.Test
import org.junit.jupiter.api.Assertions.*
import org.junit.jupiter.api.BeforeEach
import org.springframework.boot.test.context.SpringBootTest
import org.springframework.test.context.ActiveProfiles
import org.springframework.beans.factory.annotation.Autowired
import org.springframework.test.web.servlet.MockMvc
import org.springframework.test.web.servlet.request.MockMvcRequestBuilders.*
import org.springframework.test.web.servlet.result.MockMvcResultMatchers.*
import org.springframework.http.MediaType
import com.fasterxml.jackson.databind.ObjectMapper

@SpringBootTest
@ActiveProfiles("test")
class UserControllerIntegrationTest {
    
    @Autowired
    private lateinit var mockMvc: MockMvc
    
    @Autowired
    private lateinit var objectMapper: ObjectMapper
    
    @Autowired
    private lateinit var userRepository: UserRepository
    
    @BeforeEach
    fun setUp() {
        userRepository.deleteAll()
    }
    
    @Test
    fun `POST /users should create new user`() {
        // Arrange
        val userRequest = CreateUserRequest("John Doe", "john@example.com")
        
        // Act & Assert
        mockMvc.perform(
            post("/users")
                .contentType(MediaType.APPLICATION_JSON)
                .content(objectMapper.writeValueAsString(userRequest))
        )
            .andExpect(status().isCreated)
            .andExpect(jsonPath("$.name").value("John Doe"))
            .andExpect(jsonPath("$.email").value("john@example.com"))
            .andExpect(jsonPath("$.id").exists())
    }
    
    @Test
    fun `GET /users/{id} should return user when found`() {
        // Arrange
        val user = userRepository.save(User(0, "John Doe", "john@example.com"))
        
        // Act & Assert
        mockMvc.perform(get("/users/${user.id}"))
            .andExpect(status().isOk)
            .andExpect(jsonPath("$.id").value(user.id))
            .andExpect(jsonPath("$.name").value("John Doe"))
            .andExpect(jsonPath("$.email").value("john@example.com"))
    }
    
    @Test
    fun `GET /users/{id} should return 404 when user not found`() {
        // Act & Assert
        mockMvc.perform(get("/users/999"))
            .andExpect(status().isNotFound)
    }
    
    @Test
    fun `PUT /users/{id} should update user`() {
        // Arrange
        val user = userRepository.save(User(0, "John Doe", "john@example.com"))
        val updateRequest = UpdateUserRequest("Jane Doe", "jane@example.com")
        
        // Act & Assert
        mockMvc.perform(
            put("/users/${user.id}")
                .contentType(MediaType.APPLICATION_JSON)
                .content(objectMapper.writeValueAsString(updateRequest))
        )
            .andExpect(status().isOk)
            .andExpect(jsonPath("$.name").value("Jane Doe"))
            .andExpect(jsonPath("$.email").value("jane@example.com"))
    }
    
    @Test
    fun `DELETE /users/{id} should delete user`() {
        // Arrange
        val user = userRepository.save(User(0, "John Doe", "john@example.com"))
        
        // Act & Assert
        mockMvc.perform(delete("/users/${user.id}"))
            .andExpect(status().isNoContent)
        
        // Verify user is deleted
        assertFalse(userRepository.existsById(user.id))
    }
}

data class CreateUserRequest(val name: String, val email: String)
data class UpdateUserRequest(val name: String, val email: String)
```

### Test Data Builders
```kotlin
class UserTestDataBuilder {
    private var id: Int = 1
    private var name: String = "John Doe"
    private var email: String = "john@example.com"
    private var isActive: Boolean = true
    
    fun withId(id: Int) = apply { this.id = id }
    fun withName(name: String) = apply { this.name = name }
    fun withEmail(email: String) = apply { this.email = email }
    fun withActiveStatus(isActive: Boolean) = apply { this.isActive = isActive }
    
    fun build() = User(id, name, email, isActive)
    
    companion object {
        fun aUser() = UserTestDataBuilder()
        fun anActiveUser() = UserTestDataBuilder().withActiveStatus(true)
        fun anInactiveUser() = UserTestDataBuilder().withActiveStatus(false)
    }
}

class UserTestDataBuilderTest {
    @Test
    fun `should create user with default values`() {
        val user = UserTestDataBuilder().build()
        
        assertEquals(1, user.id)
        assertEquals("John Doe", user.name)
        assertEquals("john@example.com", user.email)
        assertTrue(user.isActive)
    }
    
    @Test
    fun `should create user with custom values`() {
        val user = UserTestDataBuilder()
            .withId(5)
            .withName("Jane Smith")
            .withEmail("jane@example.com")
            .withActiveStatus(false)
            .build()
        
        assertEquals(5, user.id)
        assertEquals("Jane Smith", user.name)
        assertEquals("jane@example.com", user.email)
        assertFalse(user.isActive)
    }
    
    @Test
    fun `should create active user using convenience method`() {
        val user = UserTestDataBuilder.anActiveUser().build()
        assertTrue(user.isActive)
    }
    
    @Test
    fun `should create inactive user using convenience method`() {
        val user = UserTestDataBuilder.anInactiveUser().build()
        assertFalse(user.isActive)
    }
}
```

### Property-Based Testing
```kotlin
import io.kotest.property.Arb
import io.kotest.property.arbitrary.*
import io.kotest.property.checkAll
import io.kotest.core.spec.style.FunSpec
import io.kotest.matchers.shouldBe

class PropertyBasedTest : FunSpec({
    test("addition is commutative") {
        checkAll(Arb.int(), Arb.int()) { a, b ->
            val calculator = Calculator()
            calculator.add(a, b) shouldBe calculator.add(b, a)
        }
    }
    
    test("addition is associative") {
        checkAll(Arb.int(), Arb.int(), Arb.int()) { a, b, c ->
            val calculator = Calculator()
            calculator.add(calculator.add(a, b), c) shouldBe calculator.add(a, calculator.add(b, c))
        }
    }
    
    test("multiplication by zero is zero") {
        checkAll(Arb.int()) { a ->
            val calculator = Calculator()
            calculator.multiply(a, 0) shouldBe 0
        }
    }
    
    test("even number detection") {
        checkAll(Arb.int()) { n ->
            val calculator = Calculator()
            val isEven = calculator.isEven(n)
            val expected = n % 2 == 0
            isEven shouldBe expected
        }
    }
    
    test("factorial of positive numbers is positive") {
        checkAll(Arb.int(1..10)) { n ->
            val calculator = Calculator()
            val result = calculator.factorial(n)
            result shouldBe result.coerceAtLeast(1)
        }
    }
})
```

### Test Doubles and Stubs
```kotlin
import org.junit.jupiter.api.Test
import org.junit.jupiter.api.Assertions.*

// Stub implementation
class InMemoryUserRepository : UserRepository {
    private val users = mutableMapOf<Int, User>()
    private var nextId = 1
    
    override fun findById(id: Int): User? = users[id]
    
    override fun save(user: User): User {
        val savedUser = if (user.id == 0) {
            user.copy(id = nextId++)
        } else {
            user
        }
        users[savedUser.id] = savedUser
        return savedUser
    }
    
    override fun delete(id: Int): Boolean {
        return users.remove(id) != null
    }
    
    fun clear() {
        users.clear()
        nextId = 1
    }
    
    fun count(): Int = users.size
}

// Fake implementation
class FakeEmailService : EmailService {
    private val sentEmails = mutableListOf<Email>()
    
    override fun sendEmail(to: String, subject: String, body: String): Boolean {
        sentEmails.add(Email(to, subject, body))
        return true
    }
    
    fun getSentEmails(): List<Email> = sentEmails.toList()
    fun clear() = sentEmails.clear()
    fun wasEmailSent(to: String, subject: String): Boolean {
        return sentEmails.any { it.to == to && it.subject == subject }
    }
}

data class Email(val to: String, val subject: String, val body: String)

class UserServiceWithTestDoublesTest {
    private lateinit var userRepository: InMemoryUserRepository
    private lateinit var emailService: FakeEmailService
    private lateinit var userService: UserService
    
    @BeforeEach
    fun setUp() {
        userRepository = InMemoryUserRepository()
        emailService = FakeEmailService()
        userService = UserService(userRepository, emailService)
    }
    
    @Test
    fun `createUser should save user and send welcome email using test doubles`() {
        // Arrange
        val name = "John Doe"
        val email = "john@example.com"
        
        // Act
        val result = userService.createUser(name, email)
        
        // Assert
        assertEquals(name, result.name)
        assertEquals(email, result.email)
        assertTrue(result.id > 0)
        
        // Verify repository
        val savedUser = userRepository.findById(result.id)
        assertEquals(result, savedUser)
        
        // Verify email service
        assertTrue(emailService.wasEmailSent(email, "Welcome"))
        assertEquals(1, emailService.getSentEmails().size)
    }
    
    @Test
    fun `deactivateUser should work with test doubles`() {
        // Arrange
        val user = userRepository.save(User(0, "John Doe", "john@example.com"))
        
        // Act
        val result = userService.deactivateUser(user.id)
        
        // Assert
        assertTrue(result)
        
        // Verify user is deactivated
        val deactivatedUser = userRepository.findById(user.id)
        assertFalse(deactivatedUser?.isActive ?: true)
        
        // Verify email was sent
        assertTrue(emailService.wasEmailSent(user.email, "Account Deactivated"))
    }
}
```

### Performance Testing
```kotlin
import org.junit.jupiter.api.Test
import org.junit.jupiter.api.Assertions.*
import kotlin.system.measureTimeMillis

class PerformanceTest {
    @Test
    fun `factorial calculation should complete within reasonable time`() {
        val calculator = Calculator()
        val maxTime = 1000L // 1 second
        
        val time = measureTimeMillis {
            repeat(1000) {
                calculator.factorial(10)
            }
        }
        
        assertTrue(time < maxTime, "Factorial calculation took too long: ${time}ms")
    }
    
    @Test
    fun `large number operations should be efficient`() {
        val calculator = Calculator()
        val largeNumber = 1000000
        
        val time = measureTimeMillis {
            repeat(10000) {
                calculator.add(largeNumber, largeNumber)
                calculator.multiply(largeNumber, 2)
            }
        }
        
        assertTrue(time < 1000, "Large number operations took too long: ${time}ms")
    }
}
```

### Test Configuration and Setup
```kotlin
import org.junit.jupiter.api.extension.ExtendWith
import org.springframework.boot.test.context.SpringBootTest
import org.springframework.test.context.junit.jupiter.SpringJUnitConfig
import org.springframework.test.context.ActiveProfiles
import org.springframework.transaction.annotation.Transactional

@SpringBootTest
@ActiveProfiles("test")
@Transactional
@ExtendWith(SpringExtension::class)
class BaseIntegrationTest {
    
    @Autowired
    protected lateinit var testEntityManager: TestEntityManager
    
    @Autowired
    protected lateinit var userRepository: UserRepository
    
    protected fun clearDatabase() {
        userRepository.deleteAll()
        testEntityManager.flush()
        testEntityManager.clear()
    }
    
    protected fun <T> saveAndFlush(entity: T): T {
        val saved = testEntityManager.persistAndFlush(entity)
        testEntityManager.clear()
        return saved
    }
}

// Test configuration
@Configuration
@TestPropertySource(locations = ["classpath:application-test.properties"])
class TestConfiguration {
    
    @Bean
    @Primary
    fun testEmailService(): EmailService {
        return FakeEmailService()
    }
    
    @Bean
    @Primary
    fun testUserRepository(): UserRepository {
        return InMemoryUserRepository()
    }
}
```

### Test Utilities and Helpers
```kotlin
object TestUtils {
    fun createValidUser(): User {
        return User(1, "Test User", "test@example.com")
    }
    
    fun createUserWithId(id: Int): User {
        return User(id, "Test User $id", "test$id@example.com")
    }
    
    fun createMultipleUsers(count: Int): List<User> {
        return (1..count).map { createUserWithId(it) }
    }
    
    fun assertUserEquals(expected: User, actual: User) {
        assertEquals(expected.id, actual.id)
        assertEquals(expected.name, actual.name)
        assertEquals(expected.email, actual.email)
        assertEquals(expected.isActive, actual.isActive)
    }
    
    fun assertEmailSent(emailService: FakeEmailService, to: String, subject: String) {
        assertTrue(emailService.wasEmailSent(to, subject), 
            "Expected email to be sent to $to with subject '$subject'")
    }
}

class TestUtilsTest {
    @Test
    fun `createValidUser should return valid user`() {
        val user = TestUtils.createValidUser()
        
        assertEquals(1, user.id)
        assertEquals("Test User", user.name)
        assertEquals("test@example.com", user.email)
        assertTrue(user.isActive)
    }
    
    @Test
    fun `createMultipleUsers should return correct number of users`() {
        val users = TestUtils.createMultipleUsers(5)
        
        assertEquals(5, users.size)
        users.forEachIndexed { index, user ->
            assertEquals(index + 1, user.id)
            assertEquals("Test User ${index + 1}", user.name)
        }
    }
}
```

## 🔍 Testing Best Practices

### Test Structure (AAA Pattern)
- **Arrange**: Set up test data and conditions
- **Act**: Execute the code under test
- **Assert**: Verify the expected outcomes

### Test Naming
- Use descriptive test names that explain the scenario
- Follow the pattern: `should_expectedBehavior_when_stateUnderTest`
- Use `@DisplayName` for more readable test output

### Test Organization
- Group related tests using `@Nested` classes
- Use `@BeforeEach` for common setup
- Keep tests independent and isolated

### Mocking Guidelines
- Mock external dependencies, not the code under test
- Use mocks for expensive operations (database, network)
- Verify interactions with mocks
- Use stubs for simple data returns

## 💡 Learning Points
- **Unit tests** verify individual components in isolation
- **Integration tests** verify component interactions
- **Mocking** isolates code under test from dependencies
- **Test data builders** make test setup more maintainable
- **Property-based testing** verifies general properties
- **Test doubles** (stubs, fakes, mocks) replace dependencies
- **Performance tests** ensure acceptable execution times
- **Test configuration** provides test-specific setup
- **Test utilities** reduce code duplication
- **Good test practices** improve code quality and maintainability

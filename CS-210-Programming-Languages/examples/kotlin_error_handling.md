# CS-210 Kotlin Error Handling Examples

## 🎯 Purpose
Demonstrate error handling mechanisms in Kotlin including exceptions, try-catch blocks, and Result types.

## 📝 Kotlin Error Handling Examples

### Basic Exception Handling
```kotlin
fun main() {
    // Basic try-catch
    try {
        val result = 10 / 0
        println("Result: $result")
    } catch (e: ArithmeticException) {
        println("Error: Division by zero - ${e.message}")
    }
    
    // Try-catch-finally
    try {
        val number = "abc".toInt()
        println("Number: $number")
    } catch (e: NumberFormatException) {
        println("Error: Invalid number format - ${e.message}")
    } finally {
        println("This block always executes")
    }
    
    // Try as expression
    val result = try {
        "123".toInt()
    } catch (e: NumberFormatException) {
        -1
    }
    println("Parsed result: $result")
}
```

### Multiple Catch Blocks
```kotlin
fun parseUserInput(input: String): Int? {
    return try {
        input.toInt()
    } catch (e: NumberFormatException) {
        println("Invalid number format: $input")
        null
    } catch (e: Exception) {
        println("Unexpected error: ${e.message}")
        null
    }
}

fun divideNumbers(a: String, b: String): Double? {
    return try {
        val numA = a.toInt()
        val numB = b.toInt()
        numA.toDouble() / numB
    } catch (e: NumberFormatException) {
        println("Error: Invalid number format")
        null
    } catch (e: ArithmeticException) {
        println("Error: Division by zero")
        null
    } catch (e: Exception) {
        println("Unexpected error: ${e.message}")
        null
    }
}

fun main() {
    println("Parse result: ${parseUserInput("123")}")
    println("Parse result: ${parseUserInput("abc")}")
    
    println("Division result: ${divideNumbers("10", "2")}")
    println("Division result: ${divideNumbers("10", "0")}")
    println("Division result: ${divideNumbers("abc", "2")}")
}
```

### Custom Exceptions
```kotlin
// Custom exception classes
class ValidationException(message: String) : Exception(message)
class InsufficientFundsException(amount: Double) : Exception("Insufficient funds. Required: $amount")

class BankAccount(private var balance: Double) {
    
    fun deposit(amount: Double) {
        if (amount <= 0) {
            throw ValidationException("Deposit amount must be positive")
        }
        balance += amount
        println("Deposited $amount. New balance: $balance")
    }
    
    fun withdraw(amount: Double) {
        if (amount <= 0) {
            throw ValidationException("Withdrawal amount must be positive")
        }
        if (amount > balance) {
            throw InsufficientFundsException(amount)
        }
        balance -= amount
        println("Withdrew $amount. New balance: $balance")
    }
    
    fun getBalance(): Double = balance
}

fun main() {
    val account = BankAccount(100.0)
    
    try {
        account.deposit(50.0)
        account.withdraw(30.0)
        account.withdraw(200.0) // This will throw InsufficientFundsException
    } catch (e: ValidationException) {
        println("Validation error: ${e.message}")
    } catch (e: InsufficientFundsException) {
        println("Banking error: ${e.message}")
    } catch (e: Exception) {
        println("Unexpected error: ${e.message}")
    }
    
    println("Final balance: ${account.getBalance()}")
}
```

### Result Type for Error Handling
```kotlin
// Using Result type for functional error handling
fun divide(a: Int, b: Int): Result<Double> {
    return if (b == 0) {
        Result.failure(ArithmeticException("Division by zero"))
    } else {
        Result.success(a.toDouble() / b)
    }
}

fun parseNumber(input: String): Result<Int> {
    return try {
        Result.success(input.toInt())
    } catch (e: NumberFormatException) {
        Result.failure(e)
    }
}

fun safeDivide(a: String, b: String): Result<Double> {
    val numA = parseNumber(a)
    val numB = parseNumber(b)
    
    return numA.fold(
        onSuccess = { aValue ->
            numB.fold(
                onSuccess = { bValue -> divide(aValue, bValue) },
                onFailure = { Result.failure(it) }
            )
        },
        onFailure = { Result.failure(it) }
    )
}

fun main() {
    // Using Result type
    val result1 = divide(10, 2)
    val result2 = divide(10, 0)
    
    result1.fold(
        onSuccess = { println("Success: $it") },
        onFailure = { println("Error: ${it.message}") }
    )
    
    result2.fold(
        onSuccess = { println("Success: $it") },
        onFailure = { println("Error: ${it.message}") }
    )
    
    // Chaining Results
    val result3 = safeDivide("10", "2")
    val result4 = safeDivide("abc", "2")
    val result5 = safeDivide("10", "0")
    
    println("Safe divide result: $result3")
    println("Safe divide result: $result4")
    println("Safe divide result: $result5")
}
```

### Null Safety and Safe Calls
```kotlin
class User(val name: String, val email: String?)
class Address(val street: String, val city: String)
class Company(val name: String, val address: Address?)

fun getUser(): User? = User("Alice", "alice@example.com")
fun getCompany(): Company? = Company("Tech Corp", Address("123 Main St", "New York"))

fun main() {
    val user = getUser()
    
    // Safe call operator
    val emailLength = user?.email?.length
    println("Email length: $emailLength")
    
    // Elvis operator for default values
    val displayName = user?.name ?: "Unknown User"
    val email = user?.email ?: "No email provided"
    
    println("Display name: $displayName")
    println("Email: $email")
    
    // Safe call chaining
    val company = getCompany()
    val city = company?.address?.city
    println("Company city: $city")
    
    // Let function for null checks
    user?.let {
        println("User found: ${it.name}")
        it.email?.let { email ->
            println("Email: $email")
        }
    }
    
    // Not-null assertion (use with caution)
    val userName = user!!.name // Will throw NPE if user is null
    println("User name: $userName")
}
```

### Exception Propagation
```kotlin
// Functions that can throw exceptions
@Throws(IllegalArgumentException::class)
fun calculateSquareRoot(number: Double): Double {
    if (number < 0) {
        throw IllegalArgumentException("Cannot calculate square root of negative number")
    }
    return kotlin.math.sqrt(number)
}

fun processNumber(input: String): Double {
    val number = input.toDoubleOrNull()
        ?: throw NumberFormatException("Invalid number format: $input")
    
    return calculateSquareRoot(number)
}

fun main() {
    try {
        val result1 = processNumber("16")
        println("Square root of 16: $result1")
        
        val result2 = processNumber("-4")
        println("Square root of -4: $result2")
    } catch (e: NumberFormatException) {
        println("Number format error: ${e.message}")
    } catch (e: IllegalArgumentException) {
        println("Calculation error: ${e.message}")
    }
    
    try {
        val result3 = processNumber("abc")
        println("Square root of abc: $result3")
    } catch (e: Exception) {
        println("General error: ${e.message}")
    }
}
```

### Resource Management with Use
```kotlin
import java.io.File
import java.io.FileWriter

// Simulating a resource that needs cleanup
class DatabaseConnection {
    fun connect() {
        println("Connected to database")
    }
    
    fun query(sql: String): String {
        println("Executing query: $sql")
        return "Query result"
    }
    
    fun close() {
        println("Database connection closed")
    }
}

// Extension function to make DatabaseConnection use-able
fun DatabaseConnection.use(block: (DatabaseConnection) -> Unit) {
    try {
        connect()
        block(this)
    } finally {
        close()
    }
}

fun main() {
    // Using the use pattern
    DatabaseConnection().use { db ->
        val result = db.query("SELECT * FROM users")
        println("Result: $result")
    }
    
    // File operations with use
    val file = File("test.txt")
    file.writeText("Hello, World!")
    
    file.useLines { lines ->
        lines.forEach { line ->
            println("Line: $line")
        }
    }
}
```

### Functional Error Handling
```kotlin
// Either type for functional error handling
sealed class Either<out L, out R> {
    data class Left<out L>(val value: L) : Either<L, Nothing>()
    data class Right<out R>(val value: R) : Either<Nothing, R>()
}

fun <L, R, T> Either<L, R>.map(transform: (R) -> T): Either<L, T> {
    return when (this) {
        is Either.Left -> Either.Left(this.value)
        is Either.Right -> Either.Right(transform(this.value))
    }
}

fun <L, R> Either<L, R>.fold(
    onLeft: (L) -> Unit,
    onRight: (R) -> Unit
) {
    when (this) {
        is Either.Left -> onLeft(this.value)
        is Either.Right -> onRight(this.value)
    }
}

// Using Either for error handling
fun divideEither(a: Int, b: Int): Either<String, Double> {
    return if (b == 0) {
        Either.Left("Division by zero")
    } else {
        Either.Right(a.toDouble() / b)
    }
}

fun parseIntEither(input: String): Either<String, Int> {
    return try {
        Either.Right(input.toInt())
    } catch (e: NumberFormatException) {
        Either.Left("Invalid number: $input")
    }
}

fun main() {
    val result1 = divideEither(10, 2)
    val result2 = divideEither(10, 0)
    
    result1.fold(
        onLeft = { error -> println("Error: $error") },
        onRight = { value -> println("Result: $value") }
    )
    
    result2.fold(
        onLeft = { error -> println("Error: $error") },
        onRight = { value -> println("Result: $value") }
    )
    
    // Chaining Either operations
    val result3 = parseIntEither("10")
        .map { it * 2 }
        .map { it.toDouble() }
    
    result3.fold(
        onLeft = { error -> println("Error: $error") },
        onRight = { value -> println("Final result: $value") }
    )
}
```

## 🔍 Kotlin Error Handling Features
- **Try-catch-finally**: Traditional exception handling
- **Try as expression**: Return values from try-catch blocks
- **Multiple catch blocks**: Handle different exception types
- **Custom exceptions**: Create domain-specific exceptions
- **Result type**: Functional approach to error handling
- **Null safety**: Built-in null safety prevents NPEs
- **Safe call operator**: Safe navigation through nullable chains
- **Elvis operator**: Provide default values for nulls
- **Use function**: Automatic resource management
- **Either type**: Functional error handling pattern

## 💡 Learning Points
- **Kotlin exceptions** work similarly to Java but with expression support
- **Result type** provides functional error handling without exceptions
- **Null safety** prevents many common runtime errors
- **Safe calls** allow chaining operations on nullable values
- **Use function** ensures proper resource cleanup
- **Either type** enables functional error handling patterns
- **Custom exceptions** provide domain-specific error information
- **Exception propagation** allows errors to bubble up the call stack
- **Functional error handling** can be more predictable than exceptions

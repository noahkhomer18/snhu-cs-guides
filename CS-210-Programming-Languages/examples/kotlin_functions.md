# CS-210 Kotlin Functions Examples

## 🎯 Purpose
Demonstrate function definitions, parameters, return types, and advanced function features in Kotlin.

## 📝 Kotlin Function Examples

### Basic Function Definitions
```kotlin
// Simple function
fun greet(name: String) {
    println("Hello, $name!")
}

// Function with return type
fun add(a: Int, b: Int): Int {
    return a + b
}

// Single expression function
fun multiply(a: Int, b: Int): Int = a * b

// Function with default parameters
fun greetWithTitle(name: String, title: String = "Mr./Ms.") {
    println("Hello, $title $name!")
}

// Function with named parameters
fun createUser(name: String, age: Int, email: String, isActive: Boolean = true) {
    println("User: $name, Age: $age, Email: $email, Active: $isActive")
}

fun main() {
    greet("Alice")
    println("Sum: ${add(5, 3)}")
    println("Product: ${multiply(4, 6)}")
    
    greetWithTitle("Bob")
    greetWithTitle("Alice", "Dr.")
    
    createUser("John", 25, "john@example.com")
    createUser(name = "Jane", email = "jane@example.com", age = 30)
}
```

### Function Overloading
```kotlin
// Function overloading with different parameter types
fun calculateArea(length: Int, width: Int): Int {
    return length * width
}

fun calculateArea(radius: Double): Double {
    return Math.PI * radius * radius
}

fun calculateArea(base: Double, height: Double, isTriangle: Boolean): Double {
    return if (isTriangle) 0.5 * base * height else base * height
}

fun main() {
    println("Rectangle area: ${calculateArea(5, 3)}")
    println("Circle area: ${calculateArea(2.5)}")
    println("Triangle area: ${calculateArea(4.0, 6.0, true)}")
    println("Parallelogram area: ${calculateArea(4.0, 6.0, false)}")
}
```

### Higher-Order Functions
```kotlin
// Function that takes another function as parameter
fun processNumbers(numbers: List<Int>, operation: (Int) -> Int): List<Int> {
    return numbers.map(operation)
}

// Function that returns a function
fun getOperation(operationType: String): (Int, Int) -> Int {
    return when (operationType) {
        "add" -> { a, b -> a + b }
        "multiply" -> { a, b -> a * b }
        "subtract" -> { a, b -> a - b }
        else -> { a, b -> a / b }
    }
}

fun main() {
    val numbers = listOf(1, 2, 3, 4, 5)
    
    // Using lambda expressions
    val doubled = processNumbers(numbers) { it * 2 }
    val squared = processNumbers(numbers) { it * it }
    
    println("Original: $numbers")
    println("Doubled: $doubled")
    println("Squared: $squared")
    
    // Using function references
    val addOperation = getOperation("add")
    val multiplyOperation = getOperation("multiply")
    
    println("5 + 3 = ${addOperation(5, 3)}")
    println("4 * 6 = ${multiplyOperation(4, 6)}")
}
```

### Lambda Expressions and Anonymous Functions
```kotlin
fun main() {
    val numbers = listOf(1, 2, 3, 4, 5, 6, 7, 8, 9, 10)
    
    // Lambda expressions
    val evenNumbers = numbers.filter { it % 2 == 0 }
    val doubled = numbers.map { it * 2 }
    val sum = numbers.reduce { acc, num -> acc + num }
    
    println("Even numbers: $evenNumbers")
    println("Doubled: $doubled")
    println("Sum: $sum")
    
    // Anonymous function
    val oddNumbers = numbers.filter(fun(num: Int): Boolean {
        return num % 2 != 0
    })
    
    println("Odd numbers: $oddNumbers")
    
    // Lambda with multiple parameters
    val pairs = listOf(Pair(1, "one"), Pair(2, "two"), Pair(3, "three"))
    val descriptions = pairs.map { (num, word) -> "$num is $word" }
    
    println("Descriptions: $descriptions")
}
```

### Extension Functions
```kotlin
// Extension function for String
fun String.isEmail(): Boolean {
    return this.contains("@") && this.contains(".")
}

// Extension function for List<Int>
fun List<Int>.average(): Double {
    return if (isEmpty()) 0.0 else sum().toDouble() / size
}

// Extension function for Int
fun Int.isEven(): Boolean = this % 2 == 0

// Extension function with generic type
fun <T> List<T>.second(): T? {
    return if (size >= 2) this[1] else null
}

fun main() {
    val email = "user@example.com"
    val numbers = listOf(1, 2, 3, 4, 5)
    val words = listOf("apple", "banana", "cherry")
    
    println("Is email valid: ${email.isEmail()}")
    println("Average: ${numbers.average()}")
    println("Is 4 even: ${4.isEven()}")
    println("Second word: ${words.second()}")
}
```

### Inline Functions
```kotlin
// Inline function for performance optimization
inline fun measureTime(block: () -> Unit): Long {
    val start = System.currentTimeMillis()
    block()
    return System.currentTimeMillis() - start
}

// Inline function with reified type parameter
inline fun <reified T> createList(vararg items: T): List<T> {
    return items.toList()
}

fun main() {
    // Measure execution time
    val time = measureTime {
        repeat(1000) {
            println("Hello")
        }
    }
    println("Execution time: ${time}ms")
    
    // Create typed lists
    val stringList = createList("apple", "banana", "cherry")
    val intList = createList(1, 2, 3, 4, 5)
    
    println("String list: $stringList")
    println("Int list: $intList")
}
```

### Tail Recursive Functions
```kotlin
// Regular recursive function (not tail recursive)
fun factorial(n: Int): Long {
    return if (n <= 1) 1 else n * factorial(n - 1)
}

// Tail recursive function
tailrec fun factorialTailRec(n: Int, acc: Long = 1): Long {
    return if (n <= 1) acc else factorialTailRec(n - 1, n * acc)
}

// Tail recursive function for Fibonacci
tailrec fun fibonacci(n: Int, a: Long = 0, b: Long = 1): Long {
    return if (n == 0) a else fibonacci(n - 1, b, a + b)
}

fun main() {
    println("Factorial of 5: ${factorial(5)}")
    println("Factorial of 5 (tail rec): ${factorialTailRec(5)}")
    println("Fibonacci(10): ${fibonacci(10)}")
}
```

### Function Scope and Visibility
```kotlin
// Top-level function (public by default)
fun publicFunction() {
    println("This is a public function")
}

// Private top-level function
private fun privateFunction() {
    println("This is a private function")
}

// Internal function (visible within module)
internal fun internalFunction() {
    println("This is an internal function")
}

class MyClass {
    // Public method
    fun publicMethod() {
        println("Public method")
    }
    
    // Private method
    private fun privateMethod() {
        println("Private method")
    }
    
    // Protected method
    protected fun protectedMethod() {
        println("Protected method")
    }
    
    // Internal method
    internal fun internalMethod() {
        println("Internal method")
    }
}

fun main() {
    publicFunction()
    privateFunction()
    internalFunction()
    
    val obj = MyClass()
    obj.publicMethod()
    obj.internalMethod()
    // obj.privateMethod() // Error: cannot access private member
}
```

### Function Types and Type Aliases
```kotlin
// Type alias for function types
typealias StringProcessor = (String) -> String
typealias BinaryOperation = (Int, Int) -> Int

// Function that takes function type as parameter
fun processString(input: String, processor: StringProcessor): String {
    return processor(input)
}

// Function that returns function type
fun getStringProcessor(type: String): StringProcessor {
    return when (type) {
        "upper" -> { s -> s.uppercase() }
        "lower" -> { s -> s.lowercase() }
        "reverse" -> { s -> s.reversed() }
        else -> { s -> s }
    }
}

fun main() {
    val text = "Hello World"
    
    // Using type alias
    val upperProcessor: StringProcessor = { it.uppercase() }
    val lowerProcessor: StringProcessor = { it.lowercase() }
    
    println(processString(text, upperProcessor))
    println(processString(text, lowerProcessor))
    
    // Using function that returns function type
    val reverseProcessor = getStringProcessor("reverse")
    println(processString(text, reverseProcessor))
}
```

## 🔍 Kotlin Function Features
- **Single expression functions**: Concise syntax with `=`
- **Default parameters**: Reduce function overloads
- **Named parameters**: Improve readability
- **Function overloading**: Multiple functions with same name
- **Higher-order functions**: Functions as parameters/return values
- **Lambda expressions**: Concise anonymous functions
- **Extension functions**: Add methods to existing classes
- **Inline functions**: Performance optimization
- **Tail recursion**: Optimized recursive functions
- **Type aliases**: Custom names for function types

## 💡 Learning Points
- **Kotlin functions** are more concise than Java methods
- **Default parameters** eliminate the need for many overloads
- **Named parameters** make function calls more readable
- **Higher-order functions** enable functional programming
- **Lambda expressions** provide concise syntax for simple functions
- **Extension functions** allow adding functionality to existing classes
- **Inline functions** can improve performance for higher-order functions
- **Tail recursion** prevents stack overflow for recursive algorithms
- **Type aliases** make complex function types more readable

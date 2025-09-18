# CS-210 Kotlin Object-Oriented Programming Examples

## 🎯 Purpose
Demonstrate object-oriented programming concepts in Kotlin, including classes, inheritance, interfaces, and data classes.

## 📝 Kotlin OOP Examples

### Basic Class Definition
```kotlin
// Person.kt
class Person(
    val name: String,
    val age: Int
) {
    fun introduce() {
        println("Hi, I'm $name and I'm $age years old.")
    }
    
    fun isAdult(): Boolean = age >= 18
}

// Usage
fun main() {
    val person = Person("Alice", 25)
    person.introduce()
    println("Is adult: ${person.isAdult()}")
}
```

### Data Class (Automatic equals, hashCode, toString)
```kotlin
// User.kt
data class User(
    val id: Int,
    val name: String,
    val email: String
) {
    val displayName: String
        get() = name.ifEmpty { "Anonymous" }
}

// Usage
fun main() {
    val user1 = User(1, "John", "john@example.com")
    val user2 = User(1, "John", "john@example.com")
    
    println(user1 == user2) // true (data class equality)
    println(user1) // User(id=1, name=John, email=john@example.com)
    println(user1.displayName) // John
}
```

### Inheritance and Abstract Classes
```kotlin
// Animal.kt
abstract class Animal(
    protected val name: String,
    protected val species: String
) {
    abstract fun makeSound()
    
    fun introduce() {
        println("I'm $name, a $species")
    }
}

class Dog(name: String) : Animal(name, "Dog") {
    override fun makeSound() {
        println("$name says: Woof!")
    }
}

class Cat(name: String) : Animal(name, "Cat") {
    override fun makeSound() {
        println("$name says: Meow!")
    }
}

// Usage
fun main() {
    val dog = Dog("Buddy")
    val cat = Cat("Whiskers")
    
    dog.introduce()
    dog.makeSound()
    
    cat.introduce()
    cat.makeSound()
}
```

### Interface Implementation
```kotlin
// Drawable.kt
interface Drawable {
    fun draw()
    fun getArea(): Double
}

interface Movable {
    fun move(x: Double, y: Double)
}

// Rectangle.kt
class Rectangle(
    private var x: Double,
    private var y: Double,
    private val width: Double,
    private val height: Double
) : Drawable, Movable {
    
    override fun draw() {
        println("Drawing rectangle at ($x, $y) with size ${width}x$height")
    }
    
    override fun getArea(): Double = width * height
    
    override fun move(newX: Double, newY: Double) {
        x = newX
        y = newY
    }
}

// Usage
fun main() {
    val rectangle = Rectangle(0.0, 0.0, 10.0, 5.0)
    rectangle.draw()
    println("Area: ${rectangle.getArea()}")
    rectangle.move(5.0, 3.0)
    rectangle.draw()
}
```

### Sealed Classes (Pattern Matching)
```kotlin
// Result.kt
sealed class Result<out T> {
    data class Success<T>(val data: T) : Result<T>()
    data class Error(val exception: Throwable) : Result<Nothing>()
    object Loading : Result<Nothing>()
}

// Usage
fun handleResult(result: Result<String>) {
    when (result) {
        is Result.Success -> println("Success: ${result.data}")
        is Result.Error -> println("Error: ${result.exception.message}")
        is Result.Loading -> println("Loading...")
    }
}

fun main() {
    val success = Result.Success("Hello World")
    val error = Result.Error(Exception("Something went wrong"))
    val loading = Result.Loading
    
    handleResult(success)
    handleResult(error)
    handleResult(loading)
}
```

### Companion Objects (Static-like behavior)
```kotlin
// MathUtils.kt
class MathUtils {
    companion object {
        const val PI = 3.14159
        
        fun add(a: Int, b: Int): Int = a + b
        
        fun multiply(a: Int, b: Int): Int = a * b
        
        fun create(): MathUtils = MathUtils()
    }
    
    fun subtract(a: Int, b: Int): Int = a - b
}

// Usage
fun main() {
    // Access companion object members
    println("PI = ${MathUtils.PI}")
    println("5 + 3 = ${MathUtils.add(5, 3)}")
    println("4 * 6 = ${MathUtils.multiply(4, 6)}")
    
    // Create instance for non-static methods
    val mathUtils = MathUtils()
    println("10 - 3 = ${mathUtils.subtract(10, 3)}")
}
```

### Extension Functions
```kotlin
// StringExtensions.kt
fun String.isEmail(): Boolean {
    return this.contains("@") && this.contains(".")
}

fun String.capitalizeWords(): String {
    return this.split(" ")
        .joinToString(" ") { word ->
            word.replaceFirstChar { 
                if (it.isLowerCase()) it.titlecase() else it.toString() 
            }
        }
}

fun List<Int>.average(): Double {
    return if (isEmpty()) 0.0 else sum().toDouble() / size
}

// Usage
fun main() {
    val email = "user@example.com"
    val name = "john doe"
    val numbers = listOf(1, 2, 3, 4, 5)
    
    println("Is email valid: ${email.isEmail()}")
    println("Capitalized name: ${name.capitalizeWords()}")
    println("Average: ${numbers.average()}")
}
```

### Property Delegates
```kotlin
// ObservableProperty.kt
import kotlin.properties.Delegates

class User {
    var name: String by Delegates.observable("") { _, old, new ->
        println("Name changed from '$old' to '$new'")
    }
    
    var age: Int by Delegates.vetoable(0) { _, old, new ->
        println("Age change from $old to $new")
        new >= 0 // Only allow non-negative ages
    }
}

// Usage
fun main() {
    val user = User()
    
    user.name = "Alice"
    user.name = "Bob"
    
    user.age = 25
    user.age = -5 // This will be vetoed
    println("Final age: ${user.age}")
}
```

### Generic Classes
```kotlin
// Box.kt
class Box<T>(private var item: T) {
    fun getItem(): T = item
    
    fun setItem(newItem: T) {
        item = newItem
    }
    
    fun isEmpty(): Boolean = item == null
}

// Generic function
fun <T> printList(list: List<T>) {
    list.forEach { println(it) }
}

// Usage
fun main() {
    val stringBox = Box("Hello")
    val intBox = Box(42)
    
    println("String box: ${stringBox.getItem()}")
    println("Int box: ${intBox.getItem()}")
    
    val names = listOf("Alice", "Bob", "Charlie")
    val numbers = listOf(1, 2, 3, 4, 5)
    
    printList(names)
    printList(numbers)
}
```

## 🔍 Kotlin OOP Concepts
- **Classes**: Primary constructors with concise syntax
- **Data Classes**: Automatic equals, hashCode, toString, copy
- **Inheritance**: Single inheritance with `:` syntax
- **Interfaces**: Multiple interface implementation
- **Abstract Classes**: Cannot be instantiated, must be extended
- **Sealed Classes**: Restricted class hierarchies for pattern matching
- **Companion Objects**: Static-like behavior without static keyword
- **Extension Functions**: Add functionality to existing classes
- **Property Delegates**: Custom property behavior
- **Generics**: Type-safe generic programming

## 💡 Learning Points
- **Kotlin** reduces boilerplate code compared to Java
- **Data classes** automatically generate common methods
- **Null safety** prevents NullPointerExceptions
- **Extension functions** allow adding methods to existing classes
- **Sealed classes** provide exhaustive when expressions
- **Companion objects** replace static members
- **Property delegates** enable powerful property behavior
- **Generics** provide type safety without runtime overhead

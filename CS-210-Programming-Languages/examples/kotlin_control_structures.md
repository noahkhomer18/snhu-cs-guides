# CS-210 Kotlin Control Structures Examples

## 🎯 Purpose
Demonstrate control flow structures in Kotlin including conditionals, loops, and when expressions.

## 📝 Kotlin Control Structure Examples

### If-Else Statements
```kotlin
fun main() {
    val age = 20
    val name = "Alice"
    
    // Basic if-else
    if (age >= 18) {
        println("$name is an adult")
    } else {
        println("$name is a minor")
    }
    
    // If as expression
    val status = if (age >= 18) "Adult" else "Minor"
    println("Status: $status")
    
    // Multiple conditions
    val grade = 85
    val letterGrade = if (grade >= 90) {
        "A"
    } else if (grade >= 80) {
        "B"
    } else if (grade >= 70) {
        "C"
    } else if (grade >= 60) {
        "D"
    } else {
        "F"
    }
    println("Grade: $letterGrade")
}
```

### When Expression (Switch-like)
```kotlin
fun main() {
    val day = 3
    
    // Basic when
    when (day) {
        1 -> println("Monday")
        2 -> println("Tuesday")
        3 -> println("Wednesday")
        4 -> println("Thursday")
        5 -> println("Friday")
        6, 7 -> println("Weekend")
        else -> println("Invalid day")
    }
    
    // When as expression
    val dayName = when (day) {
        1 -> "Monday"
        2 -> "Tuesday"
        3 -> "Wednesday"
        4 -> "Thursday"
        5 -> "Friday"
        6, 7 -> "Weekend"
        else -> "Invalid day"
    }
    println("Day name: $dayName")
    
    // When with ranges
    val score = 85
    val grade = when (score) {
        in 90..100 -> "A"
        in 80..89 -> "B"
        in 70..79 -> "C"
        in 60..69 -> "D"
        else -> "F"
    }
    println("Grade: $grade")
    
    // When without argument (like if-else chain)
    val temperature = 25
    val weather = when {
        temperature > 30 -> "Hot"
        temperature > 20 -> "Warm"
        temperature > 10 -> "Cool"
        else -> "Cold"
    }
    println("Weather: $weather")
}
```

### For Loops
```kotlin
fun main() {
    // Range iteration
    println("Numbers 1 to 5:")
    for (i in 1..5) {
        println(i)
    }
    
    // Range with step
    println("Even numbers 2 to 10:")
    for (i in 2..10 step 2) {
        println(i)
    }
    
    // DownTo range
    println("Countdown from 5:")
    for (i in 5 downTo 1) {
        println(i)
    }
    
    // List iteration
    val fruits = listOf("Apple", "Banana", "Orange")
    println("Fruits:")
    for (fruit in fruits) {
        println(fruit)
    }
    
    // List iteration with index
    println("Fruits with index:")
    for ((index, fruit) in fruits.withIndex()) {
        println("$index: $fruit")
    }
    
    // String iteration
    val word = "Hello"
    println("Characters in '$word':")
    for (char in word) {
        println(char)
    }
    
    // Map iteration
    val ages = mapOf("Alice" to 25, "Bob" to 30, "Charlie" to 35)
    println("Ages:")
    for ((name, age) in ages) {
        println("$name is $age years old")
    }
}
```

### While and Do-While Loops
```kotlin
fun main() {
    // While loop
    var count = 1
    println("While loop - counting to 5:")
    while (count <= 5) {
        println(count)
        count++
    }
    
    // Do-while loop
    var number = 1
    println("Do-while loop - counting to 3:")
    do {
        println(number)
        number++
    } while (number <= 3)
    
    // While with condition
    var sum = 0
    var n = 1
    println("Sum of first 5 numbers:")
    while (n <= 5) {
        sum += n
        n++
    }
    println("Sum: $sum")
    
    // Input validation example
    var userInput: String
    do {
        print("Enter 'yes' to continue: ")
        userInput = readLine() ?: ""
    } while (userInput.lowercase() != "yes")
    println("Thank you!")
}
```

### Break and Continue
```kotlin
fun main() {
    // Break example
    println("Numbers 1 to 10 (break at 5):")
    for (i in 1..10) {
        if (i == 5) {
            break
        }
        println(i)
    }
    
    // Continue example
    println("Even numbers 1 to 10:")
    for (i in 1..10) {
        if (i % 2 != 0) {
            continue
        }
        println(i)
    }
    
    // Nested loops with labeled break
    println("Nested loops with labeled break:")
    outer@ for (i in 1..3) {
        for (j in 1..3) {
            if (i == 2 && j == 2) {
                break@outer
            }
            println("i=$i, j=$j")
        }
    }
    
    // Nested loops with labeled continue
    println("Nested loops with labeled continue:")
    outer@ for (i in 1..3) {
        for (j in 1..3) {
            if (i == 2 && j == 2) {
                continue@outer
            }
            println("i=$i, j=$j")
        }
    }
}
```

### Exception Handling
```kotlin
fun main() {
    // Basic try-catch
    try {
        val result = 10 / 0
        println("Result: $result")
    } catch (e: ArithmeticException) {
        println("Error: Division by zero")
    }
    
    // Try-catch-finally
    try {
        val number = "abc".toInt()
        println("Number: $number")
    } catch (e: NumberFormatException) {
        println("Error: Invalid number format")
    } finally {
        println("This always executes")
    }
    
    // Try as expression
    val result = try {
        "123".toInt()
    } catch (e: NumberFormatException) {
        -1
    }
    println("Result: $result")
    
    // Multiple catch blocks
    try {
        val list = listOf(1, 2, 3)
        println(list[5]) // IndexOutOfBoundsException
    } catch (e: IndexOutOfBoundsException) {
        println("Error: Index out of bounds")
    } catch (e: Exception) {
        println("General error: ${e.message}")
    }
}
```

### Advanced Control Flow Examples
```kotlin
fun main() {
    // Function with when expression
    fun getDayType(day: Int): String = when (day) {
        in 1..5 -> "Weekday"
        6, 7 -> "Weekend"
        else -> "Invalid"
    }
    
    println("Day 3 is a: ${getDayType(3)}")
    println("Day 6 is a: ${getDayType(6)}")
    
    // Lambda with control flow
    val numbers = listOf(1, 2, 3, 4, 5, 6, 7, 8, 9, 10)
    
    val evenSquares = numbers
        .filter { it % 2 == 0 }
        .map { it * it }
    
    println("Even squares: $evenSquares")
    
    // Early return pattern
    fun processNumber(num: Int): String {
        if (num < 0) return "Negative number"
        if (num == 0) return "Zero"
        if (num > 100) return "Too large"
        
        return "Valid number: $num"
    }
    
    println(processNumber(-5))
    println(processNumber(0))
    println(processNumber(50))
    println(processNumber(150))
}
```

## 🔍 Kotlin Control Structure Features
- **If-else**: Can be used as expressions, not just statements
- **When**: More powerful than switch statements, supports ranges and conditions
- **For loops**: Support ranges, collections, and destructuring
- **While/Do-while**: Traditional loop structures
- **Break/Continue**: Support labels for nested loops
- **Exception handling**: Try-catch-finally with expression support
- **Early returns**: Clean exit patterns from functions

## 💡 Learning Points
- **When expressions** are more powerful than switch statements
- **If-else** can return values (expressions)
- **For loops** work with any iterable, not just arrays
- **Ranges** provide concise iteration syntax
- **Labels** help control nested loop flow
- **Try-catch** can be used as expressions
- **Early returns** make code more readable
- **Functional style** with filter/map chains

# CS-210 Error Handling Comparison

## 🎯 Purpose
Compare error handling mechanisms across C++, Java, and Python.

## 📝 Code Examples

### Exception Handling

#### C++ Exception Handling
```cpp
#include <iostream>
#include <stdexcept>
using namespace std;

int divide(int a, int b) {
    if (b == 0) {
        throw runtime_error("Division by zero!");
    }
    return a / b;
}

int main() {
    try {
        int result = divide(10, 0);
        cout << "Result: " << result << endl;
    } catch (const runtime_error& e) {
        cout << "Error: " << e.what() << endl;
    } catch (...) {
        cout << "Unknown error occurred" << endl;
    }
    
    return 0;
}
```

#### Java Exception Handling
```java
public class ErrorHandling {
    public static int divide(int a, int b) throws ArithmeticException {
        if (b == 0) {
            throw new ArithmeticException("Division by zero!");
        }
        return a / b;
    }
    
    public static void main(String[] args) {
        try {
            int result = divide(10, 0);
            System.out.println("Result: " + result);
        } catch (ArithmeticException e) {
            System.out.println("Error: " + e.getMessage());
        } catch (Exception e) {
            System.out.println("Unknown error: " + e.getMessage());
        } finally {
            System.out.println("Finally block executed");
        }
    }
}
```

#### Python Exception Handling
```python
def divide(a, b):
    if b == 0:
        raise ValueError("Division by zero!")
    return a / b

try:
    result = divide(10, 0)
    print(f"Result: {result}")
except ValueError as e:
    print(f"Error: {e}")
except Exception as e:
    print(f"Unknown error: {e}")
finally:
    print("Finally block executed")
```

### Input Validation

#### C++ Input Validation
```cpp
#include <iostream>
#include <limits>
using namespace std;

int getValidInteger() {
    int value;
    while (true) {
        cout << "Enter an integer: ";
        if (cin >> value) {
            return value;
        } else {
            cout << "Invalid input. Please enter a number." << endl;
            cin.clear();
            cin.ignore(numeric_limits<streamsize>::max(), '\n');
        }
    }
}

int main() {
    int number = getValidInteger();
    cout << "You entered: " << number << endl;
    return 0;
}
```

#### Java Input Validation
```java
import java.util.Scanner;
import java.util.InputMismatchException;

public class InputValidation {
    public static int getValidInteger(Scanner scanner) {
        while (true) {
            try {
                System.out.print("Enter an integer: ");
                return scanner.nextInt();
            } catch (InputMismatchException e) {
                System.out.println("Invalid input. Please enter a number.");
                scanner.nextLine(); // Clear the buffer
            }
        }
    }
    
    public static void main(String[] args) {
        Scanner scanner = new Scanner(System.in);
        int number = getValidInteger(scanner);
        System.out.println("You entered: " + number);
        scanner.close();
    }
}
```

#### Python Input Validation
```python
def get_valid_integer():
    while True:
        try:
            value = int(input("Enter an integer: "))
            return value
        except ValueError:
            print("Invalid input. Please enter a number.")

number = get_valid_integer()
print(f"You entered: {number}")
```

## 🔍 Key Differences
- **C++**: Manual stream state management, specific exception types
- **Java**: Checked vs unchecked exceptions, finally blocks
- **Python**: Simple try-except, no checked exceptions

## 💡 Learning Points
- Exception hierarchy concepts
- Resource cleanup patterns
- Input validation strategies

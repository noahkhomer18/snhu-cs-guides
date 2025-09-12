# CS-210 Variable Types Comparison

## 🎯 Purpose
Compare variable declarations and data types across C++, Java, and Python.

## 📝 Code Examples

### C++ Variables
```cpp
#include <iostream>
#include <string>
using namespace std;

int main() {
    // Primitive types
    int age = 25;
    double salary = 75000.50;
    char grade = 'A';
    bool isEmployed = true;
    
    // String type
    string name = "John Doe";
    
    // Arrays
    int numbers[5] = {1, 2, 3, 4, 5};
    
    cout << "Name: " << name << ", Age: " << age << endl;
    return 0;
}
```

### Java Variables
```java
public class Variables {
    public static void main(String[] args) {
        // Primitive types
        int age = 25;
        double salary = 75000.50;
        char grade = 'A';
        boolean isEmployed = true;
        
        // String type (object)
        String name = "John Doe";
        
        // Arrays
        int[] numbers = {1, 2, 3, 4, 5};
        
        System.out.println("Name: " + name + ", Age: " + age);
    }
}
```

### Python Variables
```python
# Dynamic typing - no explicit type declaration
age = 25
salary = 75000.50
grade = 'A'
is_employed = True
name = "John Doe"

# Lists (dynamic arrays)
numbers = [1, 2, 3, 4, 5]

print(f"Name: {name}, Age: {age}")
```

## 🔍 Key Differences
- **C++**: Explicit type declaration, manual memory management
- **Java**: Explicit types, automatic garbage collection
- **Python**: Dynamic typing, no type declarations needed

## 💡 Learning Points
- Static vs dynamic typing
- Memory management approaches
- Type safety considerations

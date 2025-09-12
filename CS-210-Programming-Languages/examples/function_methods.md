# CS-210 Functions and Methods Comparison

## 🎯 Purpose
Compare function/method definitions and calls across C++, Java, and Python.

## 📝 Code Examples

### Function Definitions

#### C++ Functions
```cpp
#include <iostream>
#include <string>
using namespace std;

// Function declaration
int add(int a, int b);
void greet(string name);
double calculateArea(double radius);

int main() {
    int sum = add(5, 3);
    cout << "Sum: " << sum << endl;
    
    greet("Alice");
    
    double area = calculateArea(5.0);
    cout << "Area: " << area << endl;
    
    return 0;
}

// Function definitions
int add(int a, int b) {
    return a + b;
}

void greet(string name) {
    cout << "Hello, " << name << "!" << endl;
}

double calculateArea(double radius) {
    const double PI = 3.14159;
    return PI * radius * radius;
}
```

#### Java Methods
```java
public class Functions {
    public static void main(String[] args) {
        int sum = add(5, 3);
        System.out.println("Sum: " + sum);
        
        greet("Alice");
        
        double area = calculateArea(5.0);
        System.out.println("Area: " + area);
    }
    
    // Static methods
    public static int add(int a, int b) {
        return a + b;
    }
    
    public static void greet(String name) {
        System.out.println("Hello, " + name + "!");
    }
    
    public static double calculateArea(double radius) {
        final double PI = 3.14159;
        return PI * radius * radius;
    }
}
```

#### Python Functions
```python
def add(a, b):
    return a + b

def greet(name):
    print(f"Hello, {name}!")

def calculate_area(radius):
    PI = 3.14159
    return PI * radius * radius

# Main execution
if __name__ == "__main__":
    sum_result = add(5, 3)
    print(f"Sum: {sum_result}")
    
    greet("Alice")
    
    area = calculate_area(5.0)
    print(f"Area: {area}")
```

## 🔍 Key Differences
- **C++**: Separate declaration and definition, explicit return types
- **Java**: All methods in classes, static keyword for standalone functions
- **Python**: No explicit return types, def keyword, __main__ guard

## 💡 Learning Points
- Function vs method concepts
- Static vs instance methods
- Parameter passing mechanisms

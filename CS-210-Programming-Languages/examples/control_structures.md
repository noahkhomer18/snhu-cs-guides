# CS-210 Control Structures Comparison

## 🎯 Purpose
Compare if-else statements, loops, and switch statements across languages.

## 📝 Code Examples

### If-Else Statements

#### C++
```cpp
#include <iostream>
using namespace std;

int main() {
    int score = 85;
    
    if (score >= 90) {
        cout << "Grade: A" << endl;
    } else if (score >= 80) {
        cout << "Grade: B" << endl;
    } else if (score >= 70) {
        cout << "Grade: C" << endl;
    } else {
        cout << "Grade: F" << endl;
    }
    
    return 0;
}
```

#### Java
```java
public class ControlStructures {
    public static void main(String[] args) {
        int score = 85;
        
        if (score >= 90) {
            System.out.println("Grade: A");
        } else if (score >= 80) {
            System.out.println("Grade: B");
        } else if (score >= 70) {
            System.out.println("Grade: C");
        } else {
            System.out.println("Grade: F");
        }
    }
}
```

#### Python
```python
score = 85

if score >= 90:
    print("Grade: A")
elif score >= 80:
    print("Grade: B")
elif score >= 70:
    print("Grade: C")
else:
    print("Grade: F")
```

### For Loops

#### C++
```cpp
// Traditional for loop
for (int i = 0; i < 5; i++) {
    cout << "Count: " << i << endl;
}

// Range-based for loop (C++11+)
int numbers[] = {1, 2, 3, 4, 5};
for (int num : numbers) {
    cout << "Number: " << num << endl;
}
```

#### Java
```java
// Traditional for loop
for (int i = 0; i < 5; i++) {
    System.out.println("Count: " + i);
}

// Enhanced for loop
int[] numbers = {1, 2, 3, 4, 5};
for (int num : numbers) {
    System.out.println("Number: " + num);
}
```

#### Python
```python
# Range-based for loop
for i in range(5):
    print(f"Count: {i}")

# For-each loop
numbers = [1, 2, 3, 4, 5]
for num in numbers:
    print(f"Number: {num}")
```

## 🔍 Key Differences
- **Syntax**: C++/Java use braces, Python uses indentation
- **Switch**: C++/Java have switch statements, Python uses if-elif chains
- **Range**: Python's range() is more flexible than traditional for loops

## 💡 Learning Points
- Indentation vs braces for code blocks
- Language-specific loop constructs
- Switch statement alternatives

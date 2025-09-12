# CS-210 Array Operations Comparison

## 🎯 Purpose
Compare array creation, manipulation, and iteration across C++, Java, and Python.

## 📝 Code Examples

### Array Creation and Initialization

#### C++ Arrays
```cpp
#include <iostream>
#include <vector>
using namespace std;

int main() {
    // Static array
    int numbers[5] = {1, 2, 3, 4, 5};
    
    // Dynamic array (vector)
    vector<int> dynamicNumbers = {10, 20, 30, 40, 50};
    
    // Array of strings
    string names[] = {"Alice", "Bob", "Charlie"};
    
    // Accessing elements
    cout << "First number: " << numbers[0] << endl;
    cout << "Last number: " << numbers[4] << endl;
    
    // Modifying elements
    numbers[0] = 100;
    cout << "Modified first number: " << numbers[0] << endl;
    
    return 0;
}
```

#### Java Arrays
```java
public class ArrayOperations {
    public static void main(String[] args) {
        // Array initialization
        int[] numbers = {1, 2, 3, 4, 5};
        
        // Array of strings
        String[] names = {"Alice", "Bob", "Charlie"};
        
        // Accessing elements
        System.out.println("First number: " + numbers[0]);
        System.out.println("Last number: " + numbers[numbers.length - 1]);
        
        // Modifying elements
        numbers[0] = 100;
        System.out.println("Modified first number: " + numbers[0]);
        
        // Array length
        System.out.println("Array length: " + numbers.length);
    }
}
```

#### Python Lists
```python
# List creation and initialization
numbers = [1, 2, 3, 4, 5]
names = ["Alice", "Bob", "Charlie"]

# Accessing elements
print(f"First number: {numbers[0]}")
print(f"Last number: {numbers[-1]}")  # Negative indexing

# Modifying elements
numbers[0] = 100
print(f"Modified first number: {numbers[0]}")

# List length
print(f"List length: {len(numbers)}")
```

### Array Iteration

#### C++ Array Iteration
```cpp
#include <iostream>
#include <vector>
using namespace std;

int main() {
    vector<int> numbers = {1, 2, 3, 4, 5};
    
    // Traditional for loop
    cout << "Traditional for loop:" << endl;
    for (int i = 0; i < numbers.size(); i++) {
        cout << "Index " << i << ": " << numbers[i] << endl;
    }
    
    // Range-based for loop
    cout << "\nRange-based for loop:" << endl;
    for (int num : numbers) {
        cout << "Value: " << num << endl;
    }
    
    return 0;
}
```

#### Java Array Iteration
```java
public class ArrayIteration {
    public static void main(String[] args) {
        int[] numbers = {1, 2, 3, 4, 5};
        
        // Traditional for loop
        System.out.println("Traditional for loop:");
        for (int i = 0; i < numbers.length; i++) {
            System.out.println("Index " + i + ": " + numbers[i]);
        }
        
        // Enhanced for loop
        System.out.println("\nEnhanced for loop:");
        for (int num : numbers) {
            System.out.println("Value: " + num);
        }
    }
}
```

#### Python List Iteration
```python
numbers = [1, 2, 3, 4, 5]

# Traditional for loop with index
print("Traditional for loop:")
for i in range(len(numbers)):
    print(f"Index {i}: {numbers[i]}")

# For-each loop
print("\nFor-each loop:")
for num in numbers:
    print(f"Value: {num}")

# Enumerate for index and value
print("\nEnumerate:")
for i, num in enumerate(numbers):
    print(f"Index {i}: {num}")
```

## 🔍 Key Differences
- **C++**: Static arrays vs vectors, manual memory management
- **Java**: Fixed-size arrays, length property
- **Python**: Dynamic lists, negative indexing, enumerate function

## 💡 Learning Points
- Array vs list concepts
- Memory management differences
- Indexing and iteration patterns

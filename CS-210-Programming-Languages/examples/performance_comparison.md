# CS-210 Performance Comparison

## 🎯 Purpose
Compare performance characteristics and optimization techniques across C++, Java, and Python.

## 📝 Code Examples

### Algorithm Performance Test

#### C++ Performance Test
```cpp
#include <iostream>
#include <chrono>
#include <vector>
using namespace std;
using namespace std::chrono;

// Bubble sort implementation
void bubbleSort(vector<int>& arr) {
    int n = arr.size();
    for (int i = 0; i < n-1; i++) {
        for (int j = 0; j < n-i-1; j++) {
            if (arr[j] > arr[j+1]) {
                swap(arr[j], arr[j+1]);
            }
        }
    }
}

int main() {
    const int SIZE = 10000;
    vector<int> numbers(SIZE);
    
    // Initialize with random numbers
    for (int i = 0; i < SIZE; i++) {
        numbers[i] = rand() % 1000;
    }
    
    // Measure execution time
    auto start = high_resolution_clock::now();
    bubbleSort(numbers);
    auto stop = high_resolution_clock::now();
    
    auto duration = duration_cast<microseconds>(stop - start);
    cout << "C++ Bubble Sort Time: " << duration.count() << " microseconds" << endl;
    
    return 0;
}
```

#### Java Performance Test
```java
import java.util.Random;

public class PerformanceTest {
    // Bubble sort implementation
    public static void bubbleSort(int[] arr) {
        int n = arr.length;
        for (int i = 0; i < n-1; i++) {
            for (int j = 0; j < n-i-1; j++) {
                if (arr[j] > arr[j+1]) {
                    int temp = arr[j];
                    arr[j] = arr[j+1];
                    arr[j+1] = temp;
                }
            }
        }
    }
    
    public static void main(String[] args) {
        final int SIZE = 10000;
        int[] numbers = new int[SIZE];
        Random rand = new Random();
        
        // Initialize with random numbers
        for (int i = 0; i < SIZE; i++) {
            numbers[i] = rand.nextInt(1000);
        }
        
        // Measure execution time
        long startTime = System.nanoTime();
        bubbleSort(numbers);
        long endTime = System.nanoTime();
        
        long duration = (endTime - startTime) / 1000; // Convert to microseconds
        System.out.println("Java Bubble Sort Time: " + duration + " microseconds");
    }
}
```

#### Python Performance Test
```python
import random
import time

def bubble_sort(arr):
    n = len(arr)
    for i in range(n-1):
        for j in range(n-i-1):
            if arr[j] > arr[j+1]:
                arr[j], arr[j+1] = arr[j+1], arr[j]

# Test data
SIZE = 10000
numbers = [random.randint(0, 999) for _ in range(SIZE)]

# Measure execution time
start_time = time.perf_counter()
bubble_sort(numbers)
end_time = time.perf_counter()

duration = (end_time - start_time) * 1_000_000  # Convert to microseconds
print(f"Python Bubble Sort Time: {duration:.2f} microseconds")
```

### Memory Usage Comparison

#### C++ Memory Usage
```cpp
#include <iostream>
#include <vector>
using namespace std;

int main() {
    // Measure memory usage
    vector<int> numbers(1000000);
    
    cout << "C++ Vector size: " << numbers.size() << " elements" << endl;
    cout << "Memory per element: " << sizeof(int) << " bytes" << endl;
    cout << "Total memory: " << numbers.size() * sizeof(int) << " bytes" << endl;
    
    return 0;
}
```

#### Java Memory Usage
```java
public class MemoryUsage {
    public static void main(String[] args) {
        int[] numbers = new int[1000000];
        
        System.out.println("Java Array size: " + numbers.length + " elements");
        System.out.println("Memory per element: " + Integer.BYTES + " bytes");
        System.out.println("Total memory: " + (numbers.length * Integer.BYTES) + " bytes");
        
        // Get JVM memory info
        Runtime runtime = Runtime.getRuntime();
        long totalMemory = runtime.totalMemory();
        long freeMemory = runtime.freeMemory();
        long usedMemory = totalMemory - freeMemory;
        
        System.out.println("JVM Total Memory: " + totalMemory + " bytes");
        System.out.println("JVM Used Memory: " + usedMemory + " bytes");
    }
}
```

#### Python Memory Usage
```python
import sys

# Create list
numbers = [0] * 1000000

print(f"Python List size: {len(numbers)} elements")
print(f"Memory per element: {sys.getsizeof(0)} bytes")
print(f"Total memory: {sys.getsizeof(numbers)} bytes")

# Memory usage of individual elements
total_element_memory = sum(sys.getsizeof(x) for x in numbers)
print(f"Total element memory: {total_element_memory} bytes")
```

## 🔍 Performance Characteristics

### Execution Speed (Typical Order)
1. **C++** - Fastest (compiled, direct machine code)
2. **Java** - Medium (compiled to bytecode, JIT optimized)
3. **Python** - Slowest (interpreted, dynamic typing)

### Memory Usage
- **C++**: Most efficient (direct memory management)
- **Java**: Higher overhead (JVM, garbage collection)
- **Python**: Highest overhead (object overhead, reference counting)

### Development Speed
- **Python**: Fastest development (simple syntax, dynamic typing)
- **Java**: Medium (good tooling, static typing)
- **C++**: Slowest (complex syntax, manual memory management)

## 💡 Learning Points
- Compiled vs interpreted languages
- Memory management trade-offs
- Performance vs development speed
- Optimization techniques

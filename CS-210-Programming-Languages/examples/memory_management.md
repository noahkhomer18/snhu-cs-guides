# CS-210 Memory Management Comparison

## 🎯 Purpose
Compare memory management approaches across C++, Java, and Python.

## 📝 Code Examples

### Memory Allocation

#### C++ Memory Management
```cpp
#include <iostream>
#include <memory>
using namespace std;

class Student {
private:
    string name;
    int age;
    
public:
    Student(string n, int a) : name(n), age(a) {
        cout << "Student created: " << name << endl;
    }
    
    ~Student() {
        cout << "Student destroyed: " << name << endl;
    }
    
    void display() {
        cout << "Name: " << name << ", Age: " << age << endl;
    }
};

int main() {
    // Stack allocation
    Student student1("Alice", 20);
    student1.display();
    
    // Heap allocation (manual)
    Student* student2 = new Student("Bob", 22);
    student2->display();
    delete student2; // Manual cleanup required
    
    // Smart pointer (automatic cleanup)
    unique_ptr<Student> student3 = make_unique<Student>("Charlie", 21);
    student3->display();
    // Automatically cleaned up when out of scope
    
    return 0;
}
```

#### Java Memory Management
```java
class Student {
    private String name;
    private int age;
    
    public Student(String name, int age) {
        this.name = name;
        this.age = age;
        System.out.println("Student created: " + name);
    }
    
    @Override
    protected void finalize() throws Throwable {
        System.out.println("Student destroyed: " + name);
        super.finalize();
    }
    
    public void display() {
        System.out.println("Name: " + name + ", Age: " + age);
    }
}

public class MemoryManagement {
    public static void main(String[] args) {
        // Object creation (heap allocation)
        Student student1 = new Student("Alice", 20);
        student1.display();
        
        // Reference reassignment
        Student student2 = new Student("Bob", 22);
        student2.display();
        student2 = null; // Eligible for garbage collection
        
        // Automatic garbage collection
        System.gc(); // Suggestion to run garbage collector
        
        // Object goes out of scope automatically
    }
}
```

#### Python Memory Management
```python
class Student:
    def __init__(self, name, age):
        self.name = name
        self.age = age
        print(f"Student created: {name}")
    
    def __del__(self):
        print(f"Student destroyed: {self.name}")
    
    def display(self):
        print(f"Name: {self.name}, Age: {self.age}")

# Object creation
student1 = Student("Alice", 20)
student1.display()

# Reference reassignment
student2 = Student("Bob", 22)
student2.display()
student2 = None  # Reference removed

# Automatic garbage collection
import gc
gc.collect()  # Force garbage collection

# Object goes out of scope automatically
```

### Memory Leaks and Best Practices

#### C++ Memory Leak Prevention
```cpp
#include <iostream>
#include <memory>
#include <vector>
using namespace std;

class Resource {
private:
    int* data;
    
public:
    Resource(int size) {
        data = new int[size];
        cout << "Resource allocated" << endl;
    }
    
    // Destructor for cleanup
    ~Resource() {
        delete[] data;
        cout << "Resource deallocated" << endl;
    }
    
    // Copy constructor (deep copy)
    Resource(const Resource& other) {
        data = new int[10]; // Assuming size 10
        for (int i = 0; i < 10; i++) {
            data[i] = other.data[i];
        }
    }
    
    // Assignment operator
    Resource& operator=(const Resource& other) {
        if (this != &other) {
            delete[] data;
            data = new int[10];
            for (int i = 0; i < 10; i++) {
                data[i] = other.data[i];
            }
        }
        return *this;
    }
};

int main() {
    // RAII (Resource Acquisition Is Initialization)
    Resource resource(10);
    
    // Smart pointer usage
    auto smartResource = make_unique<Resource>(10);
    
    return 0; // Automatic cleanup
}
```

## 🔍 Key Differences
- **C++**: Manual memory management, RAII, smart pointers
- **Java**: Automatic garbage collection, finalize method
- **Python**: Reference counting, automatic garbage collection

## 💡 Learning Points
- Stack vs heap allocation
- RAII principle
- Garbage collection concepts
- Memory leak prevention

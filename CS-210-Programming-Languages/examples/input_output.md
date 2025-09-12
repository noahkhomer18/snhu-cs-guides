# CS-210 Input/Output Operations

## 🎯 Purpose
Compare input/output operations and file handling across C++, Java, and Python.

## 📝 Code Examples

### Console Input/Output

#### C++ I/O
```cpp
#include <iostream>
#include <string>
using namespace std;

int main() {
    // Output
    cout << "Enter your name: ";
    
    // Input
    string name;
    getline(cin, name);
    
    cout << "Enter your age: ";
    int age;
    cin >> age;
    
    // Formatted output
    cout << "Hello, " << name << "! You are " << age << " years old." << endl;
    
    return 0;
}
```

#### Java I/O
```java
import java.util.Scanner;

public class InputOutput {
    public static void main(String[] args) {
        Scanner scanner = new Scanner(System.in);
        
        // Output
        System.out.print("Enter your name: ");
        
        // Input
        String name = scanner.nextLine();
        
        System.out.print("Enter your age: ");
        int age = scanner.nextInt();
        
        // Formatted output
        System.out.println("Hello, " + name + "! You are " + age + " years old.");
        
        scanner.close();
    }
}
```

#### Python I/O
```python
# Output
print("Enter your name: ", end="")

# Input
name = input()

print("Enter your age: ", end="")
age = int(input())

# Formatted output
print(f"Hello, {name}! You are {age} years old.")
```

### File Operations

#### C++ File I/O
```cpp
#include <iostream>
#include <fstream>
#include <string>
using namespace std;

int main() {
    // Writing to file
    ofstream outFile("data.txt");
    if (outFile.is_open()) {
        outFile << "Hello, World!" << endl;
        outFile << "This is a test file." << endl;
        outFile.close();
    }
    
    // Reading from file
    ifstream inFile("data.txt");
    string line;
    if (inFile.is_open()) {
        while (getline(inFile, line)) {
            cout << line << endl;
        }
        inFile.close();
    }
    
    return 0;
}
```

#### Java File I/O
```java
import java.io.*;
import java.util.Scanner;

public class FileOperations {
    public static void main(String[] args) {
        try {
            // Writing to file
            PrintWriter writer = new PrintWriter("data.txt");
            writer.println("Hello, World!");
            writer.println("This is a test file.");
            writer.close();
            
            // Reading from file
            Scanner fileScanner = new Scanner(new File("data.txt"));
            while (fileScanner.hasNextLine()) {
                System.out.println(fileScanner.nextLine());
            }
            fileScanner.close();
            
        } catch (FileNotFoundException e) {
            System.out.println("File not found: " + e.getMessage());
        }
    }
}
```

#### Python File I/O
```python
# Writing to file
with open("data.txt", "w") as file:
    file.write("Hello, World!\n")
    file.write("This is a test file.\n")

# Reading from file
try:
    with open("data.txt", "r") as file:
        for line in file:
            print(line.strip())
except FileNotFoundError:
    print("File not found")
```

## 🔍 Key Differences
- **C++**: Stream-based I/O, manual file handling
- **Java**: Scanner class, exception handling required
- **Python**: Simple file operations, context managers (with statement)

## 💡 Learning Points
- Stream vs file concepts
- Exception handling approaches
- Resource management patterns

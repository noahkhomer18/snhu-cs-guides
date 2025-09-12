# CS-210 Object-Oriented Programming Basics

## 🎯 Purpose
Compare basic OOP concepts (classes, objects, inheritance) across languages.

## 📝 Code Examples

### Class Definitions

#### C++ Classes
```cpp
#include <iostream>
#include <string>
using namespace std;

class Person {
private:
    string name;
    int age;
    
public:
    // Constructor
    Person(string n, int a) : name(n), age(a) {}
    
    // Getter methods
    string getName() { return name; }
    int getAge() { return age; }
    
    // Setter methods
    void setName(string n) { name = n; }
    void setAge(int a) { age = a; }
    
    // Method
    void introduce() {
        cout << "Hi, I'm " << name << " and I'm " << age << " years old." << endl;
    }
};

class Student : public Person {
private:
    string major;
    
public:
    Student(string n, int a, string m) : Person(n, a), major(m) {}
    
    string getMajor() { return major; }
    void setMajor(string m) { major = m; }
    
    void study() {
        cout << getName() << " is studying " << major << endl;
    }
};

int main() {
    Person person("John", 25);
    person.introduce();
    
    Student student("Alice", 20, "Computer Science");
    student.introduce();
    student.study();
    
    return 0;
}
```

#### Java Classes
```java
// Person.java
public class Person {
    private String name;
    private int age;
    
    // Constructor
    public Person(String name, int age) {
        this.name = name;
        this.age = age;
    }
    
    // Getter methods
    public String getName() { return name; }
    public int getAge() { return age; }
    
    // Setter methods
    public void setName(String name) { this.name = name; }
    public void setAge(int age) { this.age = age; }
    
    // Method
    public void introduce() {
        System.out.println("Hi, I'm " + name + " and I'm " + age + " years old.");
    }
}

// Student.java
public class Student extends Person {
    private String major;
    
    public Student(String name, int age, String major) {
        super(name, age);
        this.major = major;
    }
    
    public String getMajor() { return major; }
    public void setMajor(String major) { this.major = major; }
    
    public void study() {
        System.out.println(getName() + " is studying " + major);
    }
}

// Main.java
public class Main {
    public static void main(String[] args) {
        Person person = new Person("John", 25);
        person.introduce();
        
        Student student = new Student("Alice", 20, "Computer Science");
        student.introduce();
        student.study();
    }
}
```

#### Python Classes
```python
class Person:
    def __init__(self, name, age):
        self.name = name
        self.age = age
    
    def get_name(self):
        return self.name
    
    def get_age(self):
        return self.age
    
    def set_name(self, name):
        self.name = name
    
    def set_age(self, age):
        self.age = age
    
    def introduce(self):
        print(f"Hi, I'm {self.name} and I'm {self.age} years old.")

class Student(Person):
    def __init__(self, name, age, major):
        super().__init__(name, age)
        self.major = major
    
    def get_major(self):
        return self.major
    
    def set_major(self, major):
        self.major = major
    
    def study(self):
        print(f"{self.get_name()} is studying {self.major}")

# Main execution
if __name__ == "__main__":
    person = Person("John", 25)
    person.introduce()
    
    student = Student("Alice", 20, "Computer Science")
    student.introduce()
    student.study()
```

## 🔍 Key Differences
- **C++**: Explicit access modifiers, constructor initialization lists
- **Java**: this keyword, super() calls, separate files per class
- **Python**: __init__ method, self parameter, super() function

## 💡 Learning Points
- Encapsulation with private/public
- Inheritance syntax differences
- Constructor patterns
- Method overriding

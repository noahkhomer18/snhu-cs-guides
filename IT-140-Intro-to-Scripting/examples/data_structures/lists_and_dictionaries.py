# Lists and Dictionaries in Python
# This script demonstrates working with lists and dictionaries

# Lists - ordered, mutable collections
def list_examples():
    """Demonstrate list operations"""
    print("=== LIST EXAMPLES ===\n")
    
    # Creating lists
    numbers = [1, 2, 3, 4, 5]
    fruits = ["apple", "banana", "orange"]
    mixed = [1, "hello", 3.14, True]
    
    print("Original lists:")
    print(f"Numbers: {numbers}")
    print(f"Fruits: {fruits}")
    print(f"Mixed: {mixed}")
    
    # Accessing elements
    print(f"\nFirst fruit: {fruits[0]}")
    print(f"Last fruit: {fruits[-1]}")
    print(f"Fruits from index 1 to 2: {fruits[1:3]}")
    
    # Modifying lists
    fruits.append("grape")
    print(f"After appending 'grape': {fruits}")
    
    fruits.insert(1, "mango")
    print(f"After inserting 'mango' at index 1: {fruits}")
    
    fruits.remove("banana")
    print(f"After removing 'banana': {fruits}")
    
    popped = fruits.pop()
    print(f"Popped element: {popped}")
    print(f"After popping: {fruits}")
    
    # List methods
    numbers_copy = numbers.copy()
    numbers_copy.extend([6, 7, 8])
    print(f"Extended numbers: {numbers_copy}")
    
    print(f"Index of 'orange': {fruits.index('orange')}")
    print(f"Count of 'apple': {fruits.count('apple')}")
    
    # Sorting
    unsorted_numbers = [3, 1, 4, 1, 5, 9, 2, 6]
    sorted_numbers = sorted(unsorted_numbers)
    print(f"Unsorted: {unsorted_numbers}")
    print(f"Sorted: {sorted_numbers}")
    
    # List comprehensions
    squares = [x**2 for x in range(1, 6)]
    even_squares = [x**2 for x in range(1, 11) if x % 2 == 0]
    print(f"Squares: {squares}")
    print(f"Even squares: {even_squares}")

# Dictionaries - key-value pairs
def dictionary_examples():
    """Demonstrate dictionary operations"""
    print("\n=== DICTIONARY EXAMPLES ===\n")
    
    # Creating dictionaries
    person = {
        "name": "Alice",
        "age": 25,
        "city": "New York",
        "is_student": True
    }
    
    # Alternative ways to create dictionaries
    person2 = dict(name="Bob", age=30, city="Boston")
    person3 = dict([("name", "Charlie"), ("age", 35), ("city", "Chicago")])
    
    print("Original dictionaries:")
    print(f"Person 1: {person}")
    print(f"Person 2: {person2}")
    print(f"Person 3: {person3}")
    
    # Accessing values
    print(f"\nPerson's name: {person['name']}")
    print(f"Person's age: {person.get('age')}")
    print(f"Person's salary: {person.get('salary', 'Not specified')}")
    
    # Modifying dictionaries
    person["age"] = 26
    person["salary"] = 50000
    print(f"After modifications: {person}")
    
    # Adding new key-value pairs
    person["hobbies"] = ["reading", "swimming", "coding"]
    print(f"After adding hobbies: {person}")
    
    # Removing items
    removed_age = person.pop("age")
    print(f"Removed age: {removed_age}")
    print(f"After removing age: {person}")
    
    # Dictionary methods
    print(f"Keys: {list(person.keys())}")
    print(f"Values: {list(person.values())}")
    print(f"Items: {list(person.items())}")
    
    # Checking for keys
    print(f"Has 'name' key: {'name' in person}")
    print(f"Has 'age' key: {'age' in person}")
    
    # Dictionary comprehensions
    squares_dict = {x: x**2 for x in range(1, 6)}
    print(f"Squares dictionary: {squares_dict}")
    
    # Nested dictionaries
    students = {
        "student1": {"name": "Alice", "grade": "A", "subjects": ["Math", "Science"]},
        "student2": {"name": "Bob", "grade": "B", "subjects": ["English", "History"]},
        "student3": {"name": "Charlie", "grade": "A", "subjects": ["Math", "Art"]}
    }
    
    print(f"\nNested dictionary:")
    for student_id, info in students.items():
        print(f"{student_id}: {info['name']} - Grade: {info['grade']}")

# Working with both lists and dictionaries
def combined_examples():
    """Demonstrate combining lists and dictionaries"""
    print("\n=== COMBINED EXAMPLES ===\n")
    
    # List of dictionaries
    employees = [
        {"name": "Alice", "department": "IT", "salary": 60000},
        {"name": "Bob", "department": "HR", "salary": 55000},
        {"name": "Charlie", "department": "IT", "salary": 65000},
        {"name": "Diana", "department": "Finance", "salary": 58000}
    ]
    
    print("List of employee dictionaries:")
    for emp in employees:
        print(f"  {emp['name']} - {emp['department']} - ${emp['salary']}")
    
    # Filtering
    it_employees = [emp for emp in employees if emp["department"] == "IT"]
    print(f"\nIT employees: {[emp['name'] for emp in it_employees]}")
    
    # Sorting
    employees_by_salary = sorted(employees, key=lambda x: x["salary"], reverse=True)
    print(f"\nEmployees by salary (highest first):")
    for emp in employees_by_salary:
        print(f"  {emp['name']}: ${emp['salary']}")
    
    # Dictionary with list values
    department_employees = {}
    for emp in employees:
        dept = emp["department"]
        if dept not in department_employees:
            department_employees[dept] = []
        department_employees[dept].append(emp["name"])
    
    print(f"\nEmployees by department:")
    for dept, names in department_employees.items():
        print(f"  {dept}: {names}")
    
    # Calculating statistics
    salaries = [emp["salary"] for emp in employees]
    avg_salary = sum(salaries) / len(salaries)
    max_salary = max(salaries)
    min_salary = min(salaries)
    
    print(f"\nSalary statistics:")
    print(f"  Average: ${avg_salary:.2f}")
    print(f"  Maximum: ${max_salary}")
    print(f"  Minimum: ${min_salary}")

# Main execution
if __name__ == "__main__":
    list_examples()
    dictionary_examples()
    combined_examples()

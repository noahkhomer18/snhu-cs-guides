# Variables and Data Types in Python
# This script demonstrates basic Python data types and variable usage

# String variables
name = "Alice"
age = 25
city = 'New York'

print("String variables:")
print(f"Name: {name}")
print(f"Age: {age}")
print(f"City: {city}")

# Numeric variables
integer_num = 42
float_num = 3.14159
complex_num = 3 + 4j

print("\nNumeric variables:")
print(f"Integer: {integer_num}")
print(f"Float: {float_num}")
print(f"Complex: {complex_num}")

# Boolean variables
is_student = True
is_working = False

print("\nBoolean variables:")
print(f"Is student: {is_student}")
print(f"Is working: {is_working}")

# List (mutable sequence)
fruits = ["apple", "banana", "orange"]
numbers = [1, 2, 3, 4, 5]

print("\nList variables:")
print(f"Fruits: {fruits}")
print(f"Numbers: {numbers}")

# Tuple (immutable sequence)
coordinates = (10, 20)
colors = ("red", "green", "blue")

print("\nTuple variables:")
print(f"Coordinates: {coordinates}")
print(f"Colors: {colors}")

# Dictionary (key-value pairs)
person = {
    "name": "Bob",
    "age": 30,
    "city": "Boston"
}

print("\nDictionary variable:")
print(f"Person: {person}")

# Set (unique elements)
unique_numbers = {1, 2, 3, 4, 5}
unique_letters = {"a", "b", "c", "d"}

print("\nSet variables:")
print(f"Unique numbers: {unique_numbers}")
print(f"Unique letters: {unique_letters}")

# Type checking
print("\nData type checking:")
print(f"Type of name: {type(name)}")
print(f"Type of age: {type(age)}")
print(f"Type of float_num: {type(float_num)}")
print(f"Type of fruits: {type(fruits)}")
print(f"Type of person: {type(person)}")

# Type conversion
print("\nType conversion examples:")
str_to_int = int("123")
int_to_str = str(456)
float_to_int = int(3.7)

print(f"String '123' to int: {str_to_int}")
print(f"Int 456 to string: {int_to_str}")
print(f"Float 3.7 to int: {float_to_int}")

# Variable naming conventions
# Good variable names
user_name = "John"
total_score = 95
is_valid = True

# Constants (convention: UPPER_CASE)
MAX_ATTEMPTS = 3
PI = 3.14159
COMPANY_NAME = "TechCorp"

print("\nConstants:")
print(f"MAX_ATTEMPTS: {MAX_ATTEMPTS}")
print(f"PI: {PI}")
print(f"COMPANY_NAME: {COMPANY_NAME}")

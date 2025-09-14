# Functions in Python
# This script demonstrates function definition, parameters, and usage

# Basic function
def greet():
    """Simple greeting function"""
    print("Hello, World!")

# Function with parameters
def greet_person(name):
    """Greet a specific person"""
    print(f"Hello, {name}!")

# Function with multiple parameters
def greet_with_age(name, age):
    """Greet person with their age"""
    print(f"Hello, {name}! You are {age} years old.")

# Function with default parameters
def greet_with_city(name, city="Unknown"):
    """Greet person with optional city"""
    print(f"Hello, {name}! You are from {city}.")

# Function with return value
def add_numbers(a, b):
    """Add two numbers and return the result"""
    return a + b

# Function with multiple return values
def get_name_and_age():
    """Return multiple values as a tuple"""
    name = "Alice"
    age = 25
    return name, age

# Function with variable number of arguments (*args)
def sum_all(*numbers):
    """Sum all provided numbers"""
    total = 0
    for num in numbers:
        total += num
    return total

# Function with keyword arguments (**kwargs)
def create_profile(**info):
    """Create a profile with keyword arguments"""
    profile = {}
    for key, value in info.items():
        profile[key] = value
    return profile

# Lambda functions (anonymous functions)
square = lambda x: x ** 2
add = lambda x, y: x + y

# Higher-order function (function that takes another function as parameter)
def apply_operation(numbers, operation):
    """Apply an operation to a list of numbers"""
    results = []
    for num in numbers:
        results.append(operation(num))
    return results

# Recursive function
def factorial(n):
    """Calculate factorial recursively"""
    if n <= 1:
        return 1
    else:
        return n * factorial(n - 1)

# Function with type hints (Python 3.5+)
def calculate_area(length: float, width: float) -> float:
    """Calculate area of rectangle with type hints"""
    return length * width

# Main execution
if __name__ == "__main__":
    print("=== Function Examples ===\n")
    
    # Call basic functions
    greet()
    greet_person("Bob")
    greet_with_age("Charlie", 30)
    greet_with_city("David")
    greet_with_city("Eve", "New York")
    
    # Use return values
    result = add_numbers(5, 3)
    print(f"\n5 + 3 = {result}")
    
    # Multiple return values
    name, age = get_name_and_age()
    print(f"Name: {name}, Age: {age}")
    
    # Variable arguments
    total1 = sum_all(1, 2, 3, 4, 5)
    total2 = sum_all(10, 20)
    print(f"Sum of 1,2,3,4,5: {total1}")
    print(f"Sum of 10,20: {total2}")
    
    # Keyword arguments
    profile = create_profile(name="Alice", age=25, city="Boston", job="Engineer")
    print(f"Profile: {profile}")
    
    # Lambda functions
    print(f"Square of 5: {square(5)}")
    print(f"Add 3 and 7: {add(3, 7)}")
    
    # Higher-order function
    numbers = [1, 2, 3, 4, 5]
    squared_numbers = apply_operation(numbers, square)
    print(f"Original numbers: {numbers}")
    print(f"Squared numbers: {squared_numbers}")
    
    # Recursive function
    fact_5 = factorial(5)
    print(f"5! = {fact_5}")
    
    # Type hints function
    area = calculate_area(5.5, 3.2)
    print(f"Area of rectangle (5.5 x 3.2): {area}")

# Function documentation example
def complex_function(param1, param2=None, *args, **kwargs):
    """
    A complex function demonstrating various parameter types.
    
    Args:
        param1 (str): Required parameter
        param2 (int, optional): Optional parameter with default None
        *args: Variable number of positional arguments
        **kwargs: Variable number of keyword arguments
    
    Returns:
        dict: A dictionary containing all parameters
    
    Example:
        >>> result = complex_function("hello", 42, 1, 2, 3, key1="value1")
        >>> print(result)
    """
    result = {
        "param1": param1,
        "param2": param2,
        "args": args,
        "kwargs": kwargs
    }
    return result

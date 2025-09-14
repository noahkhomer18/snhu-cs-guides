# Control Structures in Python
# This script demonstrates if/else statements, loops, and other control flow

# If/Else statements
def check_grade(score):
    """Check grade based on score"""
    if score >= 90:
        return "A"
    elif score >= 80:
        return "B"
    elif score >= 70:
        return "C"
    elif score >= 60:
        return "D"
    else:
        return "F"

# Test the function
scores = [95, 85, 75, 65, 55]
print("Grade checking:")
for score in scores:
    grade = check_grade(score)
    print(f"Score {score}: Grade {grade}")

# For loops
print("\nFor loop examples:")

# Loop through a list
fruits = ["apple", "banana", "orange", "grape"]
print("Fruits:")
for fruit in fruits:
    print(f"  - {fruit}")

# Loop with range
print("\nNumbers 1 to 5:")
for i in range(1, 6):
    print(f"  {i}")

# Loop with enumerate (get index and value)
print("\nFruits with index:")
for index, fruit in enumerate(fruits):
    print(f"  {index}: {fruit}")

# While loops
print("\nWhile loop example:")
count = 0
while count < 5:
    print(f"Count: {count}")
    count += 1

# Nested loops
print("\nNested loop example (multiplication table):")
for i in range(1, 4):
    for j in range(1, 4):
        result = i * j
        print(f"{i} x {j} = {result}")

# Break and continue
print("\nBreak and continue examples:")

# Break example - stop when we find "orange"
print("Searching for 'orange':")
for fruit in fruits:
    print(f"Checking: {fruit}")
    if fruit == "orange":
        print("Found orange! Stopping search.")
        break

# Continue example - skip even numbers
print("\nOdd numbers from 1 to 10:")
for num in range(1, 11):
    if num % 2 == 0:
        continue  # Skip even numbers
    print(f"  {num}")

# List comprehensions (Pythonic way to create lists)
print("\nList comprehensions:")

# Create list of squares
squares = [x**2 for x in range(1, 6)]
print(f"Squares: {squares}")

# Create list of even numbers
evens = [x for x in range(1, 11) if x % 2 == 0]
print(f"Even numbers: {evens}")

# Create list from another list
fruits_upper = [fruit.upper() for fruit in fruits]
print(f"Fruits in uppercase: {fruits_upper}")

# Try/except for error handling
print("\nError handling example:")
def safe_divide(a, b):
    """Safely divide two numbers"""
    try:
        result = a / b
        return result
    except ZeroDivisionError:
        return "Cannot divide by zero!"
    except TypeError:
        return "Invalid input types!"

# Test the function
print(f"10 / 2 = {safe_divide(10, 2)}")
print(f"10 / 0 = {safe_divide(10, 0)}")
print(f"10 / 'a' = {safe_divide(10, 'a')}")

# Match statement (Python 3.10+)
def get_day_type(day):
    """Get type of day using match statement"""
    match day.lower():
        case "monday" | "tuesday" | "wednesday" | "thursday" | "friday":
            return "Weekday"
        case "saturday" | "sunday":
            return "Weekend"
        case _:
            return "Invalid day"

# Test the function
days = ["Monday", "Saturday", "InvalidDay"]
print("\nDay type checking:")
for day in days:
    day_type = get_day_type(day)
    print(f"{day}: {day_type}")

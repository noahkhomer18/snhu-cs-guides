# File Operations in Python
# This script demonstrates reading from and writing to files

import os
import json
import csv

# Writing to a text file
def write_text_file():
    """Write content to a text file"""
    filename = "sample.txt"
    content = """This is a sample text file.
It contains multiple lines of text.
We can write various types of content here.
"""
    
    with open(filename, 'w') as file:
        file.write(content)
    print(f"Content written to {filename}")

# Reading from a text file
def read_text_file():
    """Read content from a text file"""
    filename = "sample.txt"
    
    try:
        with open(filename, 'r') as file:
            content = file.read()
        print(f"Content from {filename}:")
        print(content)
    except FileNotFoundError:
        print(f"File {filename} not found!")

# Reading file line by line
def read_file_lines():
    """Read file line by line"""
    filename = "sample.txt"
    
    try:
        with open(filename, 'r') as file:
            lines = file.readlines()
        print(f"Lines from {filename}:")
        for i, line in enumerate(lines, 1):
            print(f"Line {i}: {line.strip()}")
    except FileNotFoundError:
        print(f"File {filename} not found!")

# Appending to a file
def append_to_file():
    """Append content to an existing file"""
    filename = "sample.txt"
    additional_content = "\nThis line was appended later."
    
    with open(filename, 'a') as file:
        file.write(additional_content)
    print(f"Content appended to {filename}")

# Working with JSON files
def write_json_file():
    """Write data to a JSON file"""
    data = {
        "name": "Alice",
        "age": 25,
        "city": "New York",
        "hobbies": ["reading", "swimming", "coding"],
        "is_student": True
    }
    
    filename = "data.json"
    with open(filename, 'w') as file:
        json.dump(data, file, indent=4)
    print(f"JSON data written to {filename}")

def read_json_file():
    """Read data from a JSON file"""
    filename = "data.json"
    
    try:
        with open(filename, 'r') as file:
            data = json.load(file)
        print(f"JSON data from {filename}:")
        print(json.dumps(data, indent=2))
    except FileNotFoundError:
        print(f"File {filename} not found!")

# Working with CSV files
def write_csv_file():
    """Write data to a CSV file"""
    filename = "students.csv"
    students = [
        ["Name", "Age", "Grade", "City"],
        ["Alice", 20, "A", "Boston"],
        ["Bob", 21, "B", "New York"],
        ["Charlie", 19, "A", "Chicago"],
        ["Diana", 22, "C", "Los Angeles"]
    ]
    
    with open(filename, 'w', newline='') as file:
        writer = csv.writer(file)
        writer.writerows(students)
    print(f"CSV data written to {filename}")

def read_csv_file():
    """Read data from a CSV file"""
    filename = "students.csv"
    
    try:
        with open(filename, 'r') as file:
            reader = csv.reader(file)
            print(f"CSV data from {filename}:")
            for row in reader:
                print(row)
    except FileNotFoundError:
        print(f"File {filename} not found!")

# File and directory operations
def file_operations():
    """Demonstrate various file operations"""
    filename = "sample.txt"
    
    # Check if file exists
    if os.path.exists(filename):
        print(f"{filename} exists")
        
        # Get file size
        size = os.path.getsize(filename)
        print(f"File size: {size} bytes")
        
        # Get file modification time
        import time
        mod_time = os.path.getmtime(filename)
        mod_time_str = time.ctime(mod_time)
        print(f"Last modified: {mod_time_str}")
        
        # Check if it's a file or directory
        if os.path.isfile(filename):
            print(f"{filename} is a file")
        if os.path.isdir(filename):
            print(f"{filename} is a directory")
    else:
        print(f"{filename} does not exist")

# List directory contents
def list_directory():
    """List contents of current directory"""
    print("Current directory contents:")
    for item in os.listdir('.'):
        if os.path.isfile(item):
            print(f"  File: {item}")
        elif os.path.isdir(item):
            print(f"  Directory: {item}")

# Create and remove directories
def directory_operations():
    """Demonstrate directory operations"""
    dir_name = "test_directory"
    
    # Create directory
    if not os.path.exists(dir_name):
        os.makedirs(dir_name)
        print(f"Created directory: {dir_name}")
    
    # Create a file in the directory
    file_path = os.path.join(dir_name, "test_file.txt")
    with open(file_path, 'w') as file:
        file.write("This is a test file in a test directory.")
    print(f"Created file: {file_path}")
    
    # List directory contents
    print(f"Contents of {dir_name}:")
    for item in os.listdir(dir_name):
        print(f"  {item}")
    
    # Remove the file
    os.remove(file_path)
    print(f"Removed file: {file_path}")
    
    # Remove the directory
    os.rmdir(dir_name)
    print(f"Removed directory: {dir_name}")

# Main execution
if __name__ == "__main__":
    print("=== File Operations Examples ===\n")
    
    # Text file operations
    print("1. Text File Operations:")
    write_text_file()
    read_text_file()
    print()
    
    print("2. Reading file line by line:")
    read_file_lines()
    print()
    
    print("3. Appending to file:")
    append_to_file()
    read_text_file()
    print()
    
    # JSON file operations
    print("4. JSON File Operations:")
    write_json_file()
    read_json_file()
    print()
    
    # CSV file operations
    print("5. CSV File Operations:")
    write_csv_file()
    read_csv_file()
    print()
    
    # File system operations
    print("6. File System Operations:")
    file_operations()
    print()
    
    print("7. Directory Listing:")
    list_directory()
    print()
    
    print("8. Directory Operations:")
    directory_operations()
    print()
    
    # Clean up created files
    print("9. Cleanup:")
    files_to_remove = ["sample.txt", "data.json", "students.csv"]
    for filename in files_to_remove:
        if os.path.exists(filename):
            os.remove(filename)
            print(f"Removed {filename}")

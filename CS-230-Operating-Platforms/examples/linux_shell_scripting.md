# CS-230 Linux Shell Scripting

## 🎯 Purpose
Demonstrate essential shell scripting concepts and practical examples.

## 📝 Script Examples

### Basic Shell Script
```bash
#!/bin/bash
# Basic shell script example

echo "Hello, World!"
echo "Current date: $(date)"
echo "Current user: $USER"
echo "Current directory: $(pwd)"
```

### Variables and Input
```bash
#!/bin/bash
# Variables and user input

# System variables
echo "Home directory: $HOME"
echo "Path: $PATH"
echo "Shell: $SHELL"

# User-defined variables
NAME="John Doe"
AGE=25
echo "Name: $NAME, Age: $AGE"

# User input
echo -n "Enter your name: "
read USER_NAME
echo "Hello, $USER_NAME!"
```

### Conditional Statements
```bash
#!/bin/bash
# Conditional statements

# Simple if statement
if [ $USER = "root" ]; then
    echo "You are running as root"
else
    echo "You are running as $USER"
fi

# If-else with file check
if [ -f "/etc/passwd" ]; then
    echo "File /etc/passwd exists"
else
    echo "File /etc/passwd does not exist"
fi

# Multiple conditions
if [ $# -eq 0 ]; then
    echo "No arguments provided"
elif [ $# -eq 1 ]; then
    echo "One argument provided: $1"
else
    echo "Multiple arguments provided: $@"
fi
```

### Loops
```bash
#!/bin/bash
# Loop examples

# For loop with range
echo "Counting from 1 to 5:"
for i in {1..5}; do
    echo "Number: $i"
done

# For loop with array
FRUITS=("apple" "banana" "orange" "grape")
echo "Fruits:"
for fruit in "${FRUITS[@]}"; do
    echo "  - $fruit"
done

# While loop
echo "Countdown:"
count=5
while [ $count -gt 0 ]; do
    echo "$count"
    count=$((count - 1))
done
echo "Blast off!"
```

### Functions
```bash
#!/bin/bash
# Function examples

# Simple function
greet() {
    echo "Hello, $1!"
}

greet "World"
greet "Linux"

# Function with return value
add() {
    local result=$(( $1 + $2 ))
    echo $result
}

sum=$(add 5 3)
echo "5 + 3 = $sum"

# Function with multiple parameters
info() {
    echo "Name: $1"
    echo "Age: $2"
    echo "City: $3"
}

info "Alice" 25 "New York"
```

### File Operations Script
```bash
#!/bin/bash
# File operations script

# Create backup directory
BACKUP_DIR="/tmp/backup_$(date +%Y%m%d_%H%M%S)"
mkdir -p "$BACKUP_DIR"

# Copy files to backup
if [ -d "$1" ]; then
    echo "Backing up directory: $1"
    cp -r "$1" "$BACKUP_DIR/"
    echo "Backup completed: $BACKUP_DIR"
else
    echo "Directory $1 does not exist"
    exit 1
fi

# List backup contents
echo "Backup contents:"
ls -la "$BACKUP_DIR"
```

### System Monitoring Script
```bash
#!/bin/bash
# System monitoring script

echo "=== System Information ==="
echo "Hostname: $(hostname)"
echo "Uptime: $(uptime)"
echo "Date: $(date)"

echo -e "\n=== Memory Usage ==="
free -h

echo -e "\n=== Disk Usage ==="
df -h

echo -e "\n=== Top 5 Processes ==="
ps aux --sort=-%cpu | head -6

echo -e "\n=== Network Interfaces ==="
ip addr show | grep -E "inet |UP|DOWN"
```

### Error Handling
```bash
#!/bin/bash
# Error handling example

# Exit on error
set -e

# Function to handle errors
error_handler() {
    echo "Error occurred on line $1"
    echo "Command: $2"
    exit 1
}

# Set error trap
trap 'error_handler $LINENO "$BASH_COMMAND"' ERR

# Test commands
echo "Creating directory..."
mkdir -p /tmp/test_dir

echo "Creating file..."
touch /tmp/test_dir/test_file.txt

echo "Listing contents..."
ls -la /tmp/test_dir/

echo "Script completed successfully"
```

## 🔍 Key Concepts
- **Shebang**: #!/bin/bash for script interpreter
- **Variables**: Local and environment variables
- **Conditionals**: if, elif, else statements
- **Loops**: for, while, until loops
- **Functions**: Reusable code blocks
- **Error Handling**: set -e, trap, exit codes

## 💡 Learning Points
- Shell scripting syntax and structure
- Variable manipulation and scope
- Control flow and logic
- File and system operations
- Error handling and debugging

# CS-230 Linux File Operations

## 🎯 Purpose
Demonstrate essential Linux file and directory operations using command line.

## 📝 Command Examples

### File and Directory Management
```bash
# Create directories
mkdir -p /home/user/projects/cs230
mkdir -p /home/user/projects/cs230/{lab1,lab2,lab3}

# Navigate directories
cd /home/user/projects/cs230
pwd  # Print working directory

# List files with details
ls -la
ls -lh  # Human readable file sizes
ls -lt  # Sort by modification time

# Create files
touch lab1/assignment.txt
echo "Hello, Linux!" > lab1/greeting.txt
cat > lab1/notes.txt << EOF
This is a multi-line file
created using heredoc syntax
EOF
```

### File Permissions
```bash
# View permissions
ls -l lab1/assignment.txt
# Output: -rw-r--r-- 1 user user 0 Sep 11 10:30 assignment.txt

# Change permissions
chmod 755 lab1/assignment.txt    # rwxr-xr-x
chmod u+x lab1/assignment.txt    # Add execute for owner
chmod g-w lab1/assignment.txt    # Remove write for group
chmod o+r lab1/assignment.txt    # Add read for others

# Change ownership
sudo chown root:root lab1/assignment.txt
sudo chown user:users lab1/assignment.txt
```

### File Operations
```bash
# Copy files
cp lab1/assignment.txt lab2/
cp -r lab1/ lab2/  # Copy directory recursively

# Move/rename files
mv lab1/assignment.txt lab1/homework.txt
mv lab1/ lab2/  # Move directory

# Remove files
rm lab1/greeting.txt
rm -rf lab1/  # Remove directory and contents

# Find files
find /home/user -name "*.txt" -type f
find /home/user -name "lab*" -type d
find /home/user -size +1M  # Files larger than 1MB
```

### Text Processing
```bash
# View file contents
cat lab1/notes.txt
less lab1/notes.txt  # Page through file
head -10 lab1/notes.txt  # First 10 lines
tail -10 lab1/notes.txt  # Last 10 lines

# Search in files
grep "Linux" lab1/notes.txt
grep -r "assignment" lab1/  # Search recursively
grep -i "hello" lab1/*.txt  # Case insensitive

# Text manipulation
sort lab1/notes.txt
uniq lab1/notes.txt
wc -l lab1/notes.txt  # Count lines
cut -d' ' -f1 lab1/notes.txt  # Extract first field
```

## 🔍 Key Concepts
- **File permissions**: rwx (read, write, execute) for owner, group, others
- **Path navigation**: Absolute vs relative paths
- **Wildcards**: *, ?, [abc] for pattern matching
- **Redirection**: >, >>, <, | for input/output

## 💡 Learning Points
- Linux file system hierarchy
- Permission system (octal notation)
- Command line efficiency
- Text processing tools

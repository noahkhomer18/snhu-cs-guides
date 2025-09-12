# CS-230 Linux User Management

## 🎯 Purpose
Demonstrate Linux user and group management, permissions, and security.

## 📝 Command Examples

### User Management
```bash
# Create new user
sudo useradd -m -s /bin/bash newuser
sudo useradd -m -s /bin/bash -c "John Doe" -d /home/johndoe johndoe

# Set user password
sudo passwd newuser
sudo passwd -e newuser  # Force password change on next login

# Modify user account
sudo usermod -l newusername oldusername  # Change username
sudo usermod -d /home/newhome -m newuser  # Change home directory
sudo usermod -s /bin/zsh newuser  # Change shell
sudo usermod -L newuser  # Lock account
sudo usermod -U newuser  # Unlock account

# Delete user
sudo userdel newuser  # Remove user only
sudo userdel -r newuser  # Remove user and home directory
```

### Group Management
```bash
# Create group
sudo groupadd developers
sudo groupadd -g 1001 developers  # With specific GID

# Add user to group
sudo usermod -a -G developers newuser
sudo gpasswd -a newuser developers

# Remove user from group
sudo gpasswd -d newuser developers

# Delete group
sudo groupdel developers

# List groups
groups newuser  # Groups for specific user
getent group  # All groups
```

### User Information
```bash
# View user information
id newuser
finger newuser  # If installed
getent passwd newuser

# List all users
cut -d: -f1 /etc/passwd
getent passwd | cut -d: -f1

# View user login history
last newuser
lastlog -u newuser

# Current user information
whoami
id
groups
```

### File Permissions
```bash
# View permissions
ls -l file.txt
stat file.txt

# Change permissions (symbolic)
chmod u+x file.txt  # Add execute for owner
chmod g-w file.txt  # Remove write for group
chmod o+r file.txt  # Add read for others
chmod a+x file.txt  # Add execute for all

# Change permissions (octal)
chmod 755 file.txt  # rwxr-xr-x
chmod 644 file.txt  # rw-r--r--
chmod 600 file.txt  # rw-------

# Change ownership
sudo chown newuser file.txt
sudo chown newuser:developers file.txt
sudo chgrp developers file.txt
```

### Sudo Configuration
```bash
# Edit sudoers file
sudo visudo

# Add user to sudo group
sudo usermod -a -G sudo newuser

# Test sudo access
sudo -l  # List sudo privileges
sudo whoami  # Test sudo

# Sudo without password (in sudoers)
newuser ALL=(ALL) NOPASSWD: ALL
```

### User Environment
```bash
# View user environment
env
printenv
echo $HOME
echo $PATH
echo $SHELL

# Set environment variables
export MY_VAR="value"
echo 'export MY_VAR="value"' >> ~/.bashrc

# User profile files
ls -la ~/.bashrc ~/.profile ~/.bash_profile
```

### Account Security
```bash
# Password policies
sudo chage -l newuser  # View password aging
sudo chage -M 90 newuser  # Set max password age
sudo chage -m 7 newuser  # Set min password age
sudo chage -W 7 newuser  # Set warning days

# Account expiration
sudo chage -E 2024-12-31 newuser  # Set account expiration
sudo chage -E -1 newuser  # Remove expiration

# Login restrictions
sudo usermod -s /bin/false newuser  # Disable shell access
sudo usermod -s /usr/sbin/nologin newuser  # System account
```

### System Monitoring
```bash
# Monitor user activity
w  # Who is logged in and what they're doing
who  # List logged in users
last  # Login history
lastlog  # Last login for all users

# Monitor file access
sudo lsof -u newuser  # Files opened by user
sudo lsof /home/newuser  # Files in user's home directory

# Process monitoring
ps aux | grep newuser
top -u newuser
```

## 🔍 Key Concepts
- **User Accounts**: Local user management and configuration
- **Groups**: User grouping and permission management
- **Permissions**: File and directory access control
- **Sudo**: Privilege escalation and security
- **Environment**: User-specific settings and variables

## 💡 Learning Points
- Linux user and group architecture
- Permission system and security
- Account lifecycle management
- System monitoring and auditing
- Security best practices

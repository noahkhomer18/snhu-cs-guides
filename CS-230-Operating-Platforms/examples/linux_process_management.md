# CS-230 Linux Process Management

## 🎯 Purpose
Demonstrate process management, monitoring, and control in Linux.

## 📝 Command Examples

### Process Monitoring
```bash
# List running processes
ps aux  # All processes with details
ps -ef  # Alternative format
ps -u $USER  # Current user's processes

# Real-time process monitoring
top
htop  # Enhanced version (if installed)
ps aux --sort=-%cpu  # Sort by CPU usage

# Process tree
pstree
pstree -p  # Show process IDs
pstree -u  # Show usernames
```

### Process Control
```bash
# Run process in background
sleep 60 &
jobs  # List background jobs
fg %1  # Bring job 1 to foreground
bg %1  # Send job 1 to background

# Process signals
kill 1234  # Send TERM signal (default)
kill -9 1234  # Send KILL signal (force kill)
kill -HUP 1234  # Send HUP signal (reload config)
killall firefox  # Kill all firefox processes

# Process priorities
nice -n 10 command  # Run with lower priority
renice 10 1234  # Change priority of running process
```

### System Information
```bash
# System resources
free -h  # Memory usage
df -h  # Disk usage
du -sh *  # Directory sizes
iostat  # I/O statistics
vmstat  # Virtual memory statistics

# System information
uname -a  # System information
uptime  # System uptime and load
who  # Logged in users
w  # Detailed user information
```

### Service Management
```bash
# Systemd services (modern Linux)
systemctl status sshd  # Check service status
systemctl start sshd  # Start service
systemctl stop sshd  # Stop service
systemctl restart sshd  # Restart service
systemctl enable sshd  # Enable at boot
systemctl disable sshd  # Disable at boot

# List services
systemctl list-units --type=service
systemctl list-unit-files --type=service
```

### Process Analysis
```bash
# Find process by name
pgrep firefox
pgrep -l firefox  # Show process names
pkill firefox  # Kill processes by name

# Process details
lsof -p 1234  # Files opened by process
lsof -i :80  # Processes using port 80
fuser -v /home/user/file.txt  # Processes using file

# Process memory usage
pmap 1234  # Memory map of process
cat /proc/1234/status  # Process status
cat /proc/1234/cmdline  # Command line
```

## 🔍 Key Concepts
- **Process states**: Running, sleeping, stopped, zombie
- **Signals**: TERM, KILL, HUP, INT for process control
- **Job control**: Background, foreground, job numbers
- **Systemd**: Modern service management system

## 💡 Learning Points
- Process lifecycle management
- Resource monitoring and optimization
- Service administration
- System troubleshooting

# CS-230 Operating System Setup Guide

## 🎯 Purpose
Complete setup guide for Linux and Windows development environments, system administration, and platform-specific tools.

## 🐧 Linux Setup & Administration

### Linux Distribution Options
**For Beginners:**
- **Ubuntu Desktop**: User-friendly, great for learning
- **Linux Mint**: Windows-like interface
- **Pop!_OS**: Gaming and development focused

**For Advanced Users:**
- **Arch Linux**: Minimal, highly customizable
- **Fedora**: Cutting-edge features
- **Debian**: Stable, server-focused

### Ubuntu Installation
```bash
# Download Ubuntu from https://ubuntu.com/download
# Create bootable USB using Rufus (Windows) or Etcher (Cross-platform)

# After installation, update system
sudo apt update && sudo apt upgrade -y

# Install essential development tools
sudo apt install -y build-essential git curl wget vim nano
sudo apt install -y python3 python3-pip nodejs npm
sudo apt install -y openjdk-11-jdk openjdk-17-jdk
sudo apt install -y gcc g++ make cmake
```

### Essential Linux Commands
```bash
# File system navigation
pwd                    # Print working directory
ls -la                 # List files with details
cd /path/to/directory  # Change directory
mkdir newdir           # Create directory
rm -rf olddir          # Remove directory recursively
cp file1 file2         # Copy file
mv file1 file2         # Move/rename file

# File permissions
chmod 755 script.sh    # Set permissions
chown user:group file  # Change ownership
sudo chown -R $USER:$USER /path  # Recursive ownership

# Process management
ps aux                 # List all processes
top                    # Real-time process monitor
htop                   # Enhanced process monitor
kill -9 PID            # Force kill process
killall process_name   # Kill all processes by name

# System information
uname -a               # System information
df -h                  # Disk usage
free -h                # Memory usage
lscpu                  # CPU information
lsblk                  # Block devices
```

### Package Management
```bash
# Ubuntu/Debian (APT)
sudo apt update                    # Update package list
sudo apt upgrade                   # Upgrade packages
sudo apt install package_name      # Install package
sudo apt remove package_name       # Remove package
sudo apt search search_term        # Search packages
apt list --installed              # List installed packages

# CentOS/RHEL (YUM/DNF)
sudo yum update                   # Update packages
sudo yum install package_name     # Install package
sudo yum remove package_name      # Remove package
yum search search_term            # Search packages

# Arch Linux (Pacman)
sudo pacman -Syu                  # Update system
sudo pacman -S package_name       # Install package
sudo pacman -R package_name       # Remove package
pacman -Ss search_term            # Search packages
```

### Shell Configuration
```bash
# Bash configuration
nano ~/.bashrc

# Add to .bashrc
export PATH=$PATH:/usr/local/bin
export EDITOR=nano
alias ll='ls -la'
alias la='ls -A'
alias l='ls -CF'
alias ..='cd ..'
alias ...='cd ../..'
alias grep='grep --color=auto'
alias fgrep='fgrep --color=auto'
alias egrep='egrep --color=auto'

# Reload configuration
source ~/.bashrc
```

### SSH Setup
```bash
# Install SSH server
sudo apt install openssh-server

# Start SSH service
sudo systemctl start ssh
sudo systemctl enable ssh

# Generate SSH key pair
ssh-keygen -t ed25519 -C "your_email@example.com"

# Copy public key to remote server
ssh-copy-id user@remote-server

# Test SSH connection
ssh user@remote-server
```

### System Services Management
```bash
# Systemctl commands
sudo systemctl start service_name     # Start service
sudo systemctl stop service_name      # Stop service
sudo systemctl restart service_name   # Restart service
sudo systemctl enable service_name    # Enable auto-start
sudo systemctl disable service_name   # Disable auto-start
sudo systemctl status service_name    # Check service status

# Common services
sudo systemctl start apache2          # Start Apache
sudo systemctl start mysql            # Start MySQL
sudo systemctl start nginx            # Start Nginx
sudo systemctl start docker           # Start Docker
```

## 🪟 Windows Setup & Administration

### Windows Development Environment
```powershell
# Install Chocolatey (Package Manager)
Set-ExecutionPolicy Bypass -Scope Process -Force
[System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072
iex ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))

# Install development tools
choco install git nodejs python openjdk
choco install vscode docker-desktop
choco install postman dbeaver
```

### PowerShell Configuration
```powershell
# Set execution policy
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser

# Install PowerShell modules
Install-Module -Name PSReadLine -Force
Install-Module -Name posh-git -Force

# PowerShell profile
notepad $PROFILE

# Add to profile
Import-Module PSReadLine
Import-Module posh-git
Set-PSReadLineOption -PredictionSource History
Set-PSReadLineOption -EditMode Emacs
```

### Windows Subsystem for Linux (WSL)
```powershell
# Enable WSL
dism.exe /online /enable-feature /featurename:Microsoft-Windows-Subsystem-Linux /all /norestart
dism.exe /online /enable-feature /featurename:VirtualMachinePlatform /all /norestart

# Install WSL 2
wsl --install

# Install Ubuntu
wsl --install -d Ubuntu

# List installed distributions
wsl --list --verbose

# Set default distribution
wsl --set-default Ubuntu
```

### Windows Services Management
```powershell
# Get services
Get-Service

# Start service
Start-Service -Name "ServiceName"

# Stop service
Stop-Service -Name "ServiceName"

# Restart service
Restart-Service -Name "ServiceName"

# Set service startup type
Set-Service -Name "ServiceName" -StartupType Automatic
```

## 🐳 Containerization & Virtualization

### Docker Setup
```bash
# Install Docker
# Ubuntu
curl -fsSL https://get.docker.com -o get-docker.sh
sudo sh get-docker.sh
sudo usermod -aG docker $USER

# Windows: Download Docker Desktop from https://www.docker.com/products/docker-desktop

# Verify installation
docker --version
docker-compose --version

# Basic Docker commands
docker run hello-world
docker images
docker ps
docker ps -a
```

### VirtualBox Setup
```bash
# Install VirtualBox
# Ubuntu
sudo apt install virtualbox virtualbox-ext-pack

# Create virtual machine
# 1. Open VirtualBox
# 2. Click "New"
# 3. Configure memory, storage, network
# 4. Install guest OS

# VirtualBox commands
VBoxManage list vms                    # List VMs
VBoxManage startvm "VM Name"           # Start VM
VBoxManage controlvm "VM Name" poweroff # Stop VM
```

### VMware Setup
```bash
# Download VMware Workstation from https://www.vmware.com/products/workstation-pro.html
# Install and create virtual machines

# VMware commands (if using CLI)
vmrun start "path/to/vm.vmx"           # Start VM
vmrun stop "path/to/vm.vmx"            # Stop VM
vmrun suspend "path/to/vm.vmx"         # Suspend VM
```

## 🔧 Development Tools Setup

### Visual Studio Code
```bash
# Install VS Code
# Ubuntu
wget -qO- https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > packages.microsoft.gpg
sudo install -o root -g root -m 644 packages.microsoft.gpg /etc/apt/trusted.gpg.d/
sudo sh -c 'echo "deb [arch=amd64,arm64,armhf signed-by=/etc/apt/trusted.gpg.d/packages.microsoft.gpg] https://packages.microsoft.com/repos/code stable main" > /etc/apt/sources.list.d/vscode.list'
sudo apt update
sudo apt install code

# Essential extensions
code --install-extension ms-python.python
code --install-extension ms-vscode.cpptools
code --install-extension ms-vscode.java
code --install-extension bradlc.vscode-tailwindcss
code --install-extension esbenp.prettier-vscode
```

### Terminal Emulators
```bash
# Ubuntu - Install additional terminals
sudo apt install terminator tmux screen

# Terminator configuration
mkdir -p ~/.config/terminator
cat > ~/.config/terminator/config << EOF
[global_config]
[keybindings]
[profiles]
  [[default]]
    use_system_font = False
    font = Monospace 12
    background_color = "#2d2d2d"
    foreground_color = "#ffffff"
[layouts]
  [[default]]
    [[[window0]]]
      type = Window
      parent = ""
    [[[child1]]]
      type = Terminal
      parent = window0
[plugins]
EOF
```

### System Monitoring Tools
```bash
# Install monitoring tools
sudo apt install htop iotop nethogs ncdu tree

# htop - Process monitor
htop

# iotop - I/O monitor
sudo iotop

# nethogs - Network monitor
sudo nethogs

# ncdu - Disk usage analyzer
ncdu /

# tree - Directory structure
tree -L 3
```

## 🌐 Network Configuration

### Network Tools
```bash
# Install network tools
sudo apt install net-tools iputils-ping traceroute nmap wireshark

# Basic network commands
ip addr show                    # Show network interfaces
ip route show                   # Show routing table
ping google.com                 # Test connectivity
traceroute google.com           # Trace network path
nmap -sn 192.168.1.0/24        # Scan network
netstat -tulpn                  # Show network connections
ss -tulpn                       # Modern netstat alternative
```

### Firewall Configuration
```bash
# Ubuntu UFW (Uncomplicated Firewall)
sudo ufw enable                 # Enable firewall
sudo ufw status                 # Check status
sudo ufw allow 22               # Allow SSH
sudo ufw allow 80               # Allow HTTP
sudo ufw allow 443              # Allow HTTPS
sudo ufw deny 23                # Deny Telnet
sudo ufw delete allow 23        # Remove rule

# iptables (Advanced)
sudo iptables -L                # List rules
sudo iptables -A INPUT -p tcp --dport 22 -j ACCEPT
sudo iptables -A INPUT -p tcp --dport 80 -j ACCEPT
sudo iptables -A INPUT -j DROP
```

### DNS Configuration
```bash
# Edit DNS configuration
sudo nano /etc/resolv.conf

# Add DNS servers
nameserver 8.8.8.8
nameserver 8.8.4.4
nameserver 1.1.1.1

# Test DNS resolution
nslookup google.com
dig google.com
```

## 📁 File System Management

### Disk Management
```bash
# Check disk usage
df -h                           # Human readable format
du -sh /path/to/directory       # Directory size
du -h --max-depth=1             # Directory sizes at level 1

# Mount/unmount drives
sudo mount /dev/sdb1 /mnt       # Mount drive
sudo umount /mnt                # Unmount drive
sudo fdisk -l                   # List partitions

# Format drives
sudo mkfs.ext4 /dev/sdb1        # Format as ext4
sudo mkfs.ntfs /dev/sdb1        # Format as NTFS
```

### Backup Strategies
```bash
# Create backup script
cat > backup.sh << 'EOF'
#!/bin/bash
BACKUP_DIR="/backup"
SOURCE_DIR="/home/user"
DATE=$(date +%Y%m%d_%H%M%S)

# Create backup directory
mkdir -p $BACKUP_DIR

# Create tar backup
tar -czf $BACKUP_DIR/backup_$DATE.tar.gz $SOURCE_DIR

# Keep only last 7 days of backups
find $BACKUP_DIR -name "backup_*.tar.gz" -mtime +7 -delete

echo "Backup completed: backup_$DATE.tar.gz"
EOF

chmod +x backup.sh

# Schedule with cron
crontab -e
# Add: 0 2 * * * /path/to/backup.sh
```

## 🔐 Security Configuration

### User Management
```bash
# Create user
sudo adduser newuser
sudo usermod -aG sudo newuser    # Add to sudo group

# Change password
sudo passwd username

# Lock/unlock account
sudo usermod -L username         # Lock
sudo usermod -U username         # Unlock

# Delete user
sudo deluser username
sudo deluser --remove-home username
```

### SSH Security
```bash
# Edit SSH configuration
sudo nano /etc/ssh/sshd_config

# Security settings
Port 2222                        # Change default port
PermitRootLogin no               # Disable root login
PasswordAuthentication no        # Disable password auth
PubkeyAuthentication yes         # Enable key auth
MaxAuthTries 3                   # Limit auth attempts

# Restart SSH service
sudo systemctl restart ssh
```

### System Hardening
```bash
# Update system
sudo apt update && sudo apt upgrade

# Install security tools
sudo apt install fail2ban ufw rkhunter chkrootkit

# Configure fail2ban
sudo nano /etc/fail2ban/jail.local
# Add SSH protection
[sshd]
enabled = true
port = ssh
filter = sshd
logpath = /var/log/auth.log
maxretry = 3
bantime = 3600

# Start fail2ban
sudo systemctl start fail2ban
sudo systemctl enable fail2ban
```

## 📚 Learning Resources

### Linux Documentation
- **Linux Documentation Project**: https://tldp.org/
- **Ubuntu Documentation**: https://help.ubuntu.com/
- **Arch Wiki**: https://wiki.archlinux.org/
- **Red Hat Documentation**: https://access.redhat.com/documentation

### Windows Documentation
- **Microsoft Docs**: https://docs.microsoft.com/
- **PowerShell Documentation**: https://docs.microsoft.com/en-us/powershell/
- **Windows Server Documentation**: https://docs.microsoft.com/en-us/windows-server/

### System Administration
- **Linux System Administration**: https://www.linux.org/
- **Windows Server Administration**: https://docs.microsoft.com/en-us/windows-server/
- **Docker Documentation**: https://docs.docker.com/

## 🎯 CS-230 Project Checklist

### Phase 1: System Setup
- [ ] Install Linux distribution
- [ ] Configure Windows development environment
- [ ] Set up WSL2
- [ ] Install essential development tools

### Phase 2: System Administration
- [ ] Configure user accounts and permissions
- [ ] Set up SSH and remote access
- [ ] Configure firewall and security
- [ ] Set up system monitoring

### Phase 3: Development Environment
- [ ] Install and configure IDEs
- [ ] Set up version control
- [ ] Configure development tools
- [ ] Set up containerization

### Phase 4: Network Configuration
- [ ] Configure network settings
- [ ] Set up DNS and routing
- [ ] Configure firewall rules
- [ ] Test network connectivity

### Phase 5: Security & Maintenance
- [ ] Implement security best practices
- [ ] Set up backup strategies
- [ ] Configure system updates
- [ ] Monitor system performance

## 💡 Pro Tips

1. **Start with Ubuntu**: Easiest Linux distribution for beginners
2. **Use WSL2**: Great for Windows users who need Linux tools
3. **Learn Command Line**: Essential for system administration
4. **Use Version Control**: Track system configuration changes
5. **Regular Backups**: Always have a backup strategy
6. **Security First**: Implement security measures from the start
7. **Document Everything**: Keep notes on system configuration
8. **Practice Regularly**: Hands-on experience is crucial
9. **Join Communities**: Linux and Windows admin communities
10. **Stay Updated**: Keep systems and knowledge current

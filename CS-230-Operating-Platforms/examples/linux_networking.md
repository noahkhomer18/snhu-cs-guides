# CS-230 Linux Networking

## 🎯 Purpose
Demonstrate Linux networking configuration, monitoring, and troubleshooting.

## 📝 Command Examples

### Network Interface Management
```bash
# List network interfaces
ip addr show
ifconfig  # Traditional command
ip link show

# Interface status
ip addr show eth0
ip link show eth0
ethtool eth0  # Interface capabilities

# Bring interfaces up/down
sudo ip link set eth0 up
sudo ip link set eth0 down
sudo ifconfig eth0 up
sudo ifconfig eth0 down
```

### IP Configuration
```bash
# Configure IP address
sudo ip addr add 192.168.1.100/24 dev eth0
sudo ip addr del 192.168.1.100/24 dev eth0
sudo ifconfig eth0 192.168.1.100 netmask 255.255.255.0

# Set default gateway
sudo ip route add default via 192.168.1.1
sudo route add default gw 192.168.1.1

# View routing table
ip route show
route -n
```

### Network Monitoring
```bash
# Network statistics
netstat -i  # Interface statistics
netstat -s  # Protocol statistics
ss -tuln  # Socket statistics
ip -s link show eth0  # Interface statistics

# Active connections
netstat -tuln  # TCP/UDP listening ports
netstat -tulnp  # With process information
ss -tuln  # Modern alternative
lsof -i :80  # Processes using port 80
```

### Network Testing
```bash
# Connectivity testing
ping google.com
ping -c 4 8.8.8.8  # Ping 4 times
traceroute google.com
mtr google.com  # Continuous traceroute

# Port testing
telnet google.com 80
nc -zv google.com 80  # Netcat port test
nmap -p 80,443 google.com  # Port scan

# DNS testing
nslookup google.com
dig google.com
host google.com
```

### Firewall Management (iptables)
```bash
# View firewall rules
sudo iptables -L
sudo iptables -L -n -v  # Numeric addresses, verbose
sudo iptables -L INPUT  # Specific chain

# Basic firewall rules
sudo iptables -A INPUT -p tcp --dport 22 -j ACCEPT  # Allow SSH
sudo iptables -A INPUT -p tcp --dport 80 -j ACCEPT  # Allow HTTP
sudo iptables -A INPUT -j DROP  # Drop all other traffic

# Save and restore rules
sudo iptables-save > /etc/iptables/rules.v4
sudo iptables-restore < /etc/iptables/rules.v4
```

### Network Configuration Files
```bash
# Network configuration (Ubuntu/Debian)
cat /etc/netplan/01-netcfg.yaml
sudo nano /etc/netplan/01-netcfg.yaml

# Example netplan configuration
network:
  version: 2
  ethernets:
    eth0:
      dhcp4: true
      addresses:
        - 192.168.1.100/24
      gateway4: 192.168.1.1
      nameservers:
        addresses: [8.8.8.8, 8.8.4.4]

# Apply configuration
sudo netplan apply
```

### Network Troubleshooting
```bash
# Check network connectivity
ping -c 1 8.8.8.8  # Test internet connectivity
ping -c 1 192.168.1.1  # Test gateway connectivity
ping -c 1 localhost  # Test local loopback

# Check DNS resolution
nslookup google.com
dig @8.8.8.8 google.com  # Use specific DNS server

# Check routing
ip route get 8.8.8.8  # Route to specific destination
traceroute 8.8.8.8  # Trace route to destination

# Network interface issues
sudo ethtool eth0  # Check interface status
sudo mii-tool eth0  # Check link status
dmesg | grep eth0  # Check kernel messages
```

### Network Security
```bash
# Monitor network traffic
sudo tcpdump -i eth0
sudo tcpdump -i eth0 port 80
sudo tcpdump -i eth0 host 192.168.1.100

# Network scanning
nmap -sn 192.168.1.0/24  # Ping sweep
nmap -sS 192.168.1.100  # SYN scan
nmap -O 192.168.1.100  # OS detection

# Port security
sudo netstat -tulnp | grep LISTEN  # List listening ports
sudo lsof -i -P -n | grep LISTEN  # Alternative method
```

## 🔍 Key Concepts
- **Network interfaces**: Physical and virtual network adapters
- **IP addressing**: Static vs DHCP configuration
- **Routing**: How packets are forwarded between networks
- **Firewall**: Packet filtering and network security
- **DNS**: Domain name resolution

## 💡 Learning Points
- Linux networking stack
- Network configuration management
- Troubleshooting network issues
- Security considerations
- Performance monitoring

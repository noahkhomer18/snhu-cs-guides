# IT-212 Networking Tools Setup Guide

## 🎯 Purpose
Complete setup guide for networking tools, protocols, and network analysis used in computer networking courses.

## 🌐 Network Analysis Tools

### Wireshark Installation
```bash
# Ubuntu/Debian
sudo apt update
sudo apt install wireshark
sudo usermod -aG wireshark $USER

# Windows
# Download from https://www.wireshark.org/download.html

# macOS
brew install wireshark
```

### Wireshark Configuration
```bash
# Start Wireshark
sudo wireshark

# Command line capture
sudo tshark -i eth0 -c 100 -w capture.pcap

# Filter specific traffic
sudo tshark -i eth0 -f "host 8.8.8.8" -w dns_capture.pcap

# Analyze existing capture
tshark -r capture.pcap -T fields -e ip.src -e ip.dst
```

### Essential Wireshark Filters
```bash
# Protocol filters
tcp                    # TCP traffic only
udp                    # UDP traffic only
http                   # HTTP traffic
dns                    # DNS queries
icmp                   # ICMP packets

# IP address filters
ip.addr == 192.168.1.1
ip.src == 192.168.1.1
ip.dst == 8.8.8.8

# Port filters
tcp.port == 80
tcp.port == 443
udp.port == 53

# Combined filters
tcp.port == 80 and ip.addr == 192.168.1.100
http and ip.addr == 10.0.0.1
dns and udp.port == 53
```

## 🔍 Network Discovery Tools

### Nmap Installation
```bash
# Ubuntu/Debian
sudo apt install nmap

# Windows
# Download from https://nmap.org/download.html

# macOS
brew install nmap
```

### Nmap Commands
```bash
# Basic scan
nmap 192.168.1.1

# Scan range
nmap 192.168.1.1-254

# Scan specific ports
nmap -p 80,443,22,21 192.168.1.1

# Scan all ports
nmap -p- 192.168.1.1

# OS detection
nmap -O 192.168.1.1

# Service version detection
nmap -sV 192.168.1.1

# Aggressive scan
nmap -A 192.168.1.1

# Stealth scan
nmap -sS 192.168.1.1

# UDP scan
nmap -sU 192.168.1.1

# Script scan
nmap --script vuln 192.168.1.1
```

### Network Discovery Script
```bash
#!/bin/bash
# network_discovery.sh

echo "Network Discovery Tool"
echo "====================="

# Get local network
LOCAL_IP=$(hostname -I | awk '{print $1}')
NETWORK=$(echo $LOCAL_IP | cut -d. -f1-3)

echo "Local IP: $LOCAL_IP"
echo "Scanning network: $NETWORK.0/24"
echo ""

# Ping sweep
echo "Ping sweep results:"
for i in {1..254}; do
    ping -c 1 -W 1 $NETWORK.$i > /dev/null 2>&1
    if [ $? -eq 0 ]; then
        echo "$NETWORK.$i - Host is up"
    fi
done

echo ""
echo "Port scan on active hosts:"
nmap -sn $NETWORK.0/24 | grep "Nmap scan report" | awk '{print $5}' | while read host; do
    if [ ! -z "$host" ]; then
        echo "Scanning $host..."
        nmap -sS -O $host
        echo "---"
    fi
done
```

## 🌍 DNS Tools

### DNS Configuration
```bash
# Check DNS configuration
cat /etc/resolv.conf

# Test DNS resolution
nslookup google.com
dig google.com
host google.com

# Reverse DNS lookup
nslookup 8.8.8.8
dig -x 8.8.8.8

# Query specific DNS server
nslookup google.com 8.8.8.8
dig @8.8.8.8 google.com
```

### DNS Server Setup
```bash
# Install BIND9 DNS server
sudo apt install bind9 bind9utils bind9-doc

# Configure BIND9
sudo nano /etc/bind/named.conf.local

# Add zone configuration
zone "example.local" {
    type master;
    file "/etc/bind/db.example.local";
};

# Create zone file
sudo nano /etc/bind/db.example.local

# Zone file content
$TTL    604800
@       IN      SOA     ns1.example.local. admin.example.local. (
                              2         ; Serial
                         604800         ; Refresh
                          86400         ; Retry
                        2419200         ; Expire
                         604800 )       ; Negative Cache TTL
;
@       IN      NS      ns1.example.local.
@       IN      A       192.168.1.10
ns1     IN      A       192.168.1.10
www     IN      A       192.168.1.10
mail    IN      A       192.168.1.11
```

### DNS Testing Script
```bash
#!/bin/bash
# dns_test.sh

echo "DNS Testing Tool"
echo "================"

# Test DNS servers
DNS_SERVERS=("8.8.8.8" "1.1.1.1" "208.67.222.222")

for dns in "${DNS_SERVERS[@]}"; do
    echo "Testing DNS server: $dns"
    dig @$dns google.com +short
    echo "Response time:"
    dig @$dns google.com | grep "Query time"
    echo "---"
done

# Test local DNS resolution
echo "Local DNS resolution test:"
nslookup google.com
```

## 🔧 Network Configuration Tools

### IP Configuration
```bash
# Show network interfaces
ip addr show
ifconfig

# Configure static IP
sudo nano /etc/netplan/01-netcfg.yaml

# Static IP configuration
network:
  version: 2
  renderer: networkd
  ethernets:
    eth0:
      addresses:
        - 192.168.1.100/24
      gateway4: 192.168.1.1
      nameservers:
        addresses: [8.8.8.8, 8.8.4.4]

# Apply configuration
sudo netplan apply
```

### Routing Configuration
```bash
# Show routing table
ip route show
route -n

# Add static route
sudo ip route add 10.0.0.0/8 via 192.168.1.1
sudo route add -net 10.0.0.0/8 gw 192.168.1.1

# Delete route
sudo ip route del 10.0.0.0/8
sudo route del -net 10.0.0.0/8

# Test connectivity
ping 8.8.8.8
traceroute 8.8.8.8
mtr 8.8.8.8
```

### Network Interface Scripts
```bash
#!/bin/bash
# network_monitor.sh

echo "Network Interface Monitor"
echo "========================"

# Monitor network interfaces
while true; do
    clear
    echo "Network Interfaces:"
    ip addr show | grep -E "(inet |UP|DOWN)"
    echo ""
    echo "Routing Table:"
    ip route show
    echo ""
    echo "Active Connections:"
    ss -tuln
    echo ""
    echo "Press Ctrl+C to exit"
    sleep 5
done
```

## 🛡️ Security Tools

### Firewall Configuration
```bash
# UFW (Ubuntu Firewall)
sudo ufw enable
sudo ufw status
sudo ufw allow 22/tcp
sudo ufw allow 80/tcp
sudo ufw allow 443/tcp
sudo ufw deny 23/tcp

# iptables
sudo iptables -L
sudo iptables -A INPUT -p tcp --dport 22 -j ACCEPT
sudo iptables -A INPUT -p tcp --dport 80 -j ACCEPT
sudo iptables -A INPUT -j DROP

# Save iptables rules
sudo iptables-save > /etc/iptables/rules.v4
```

### Intrusion Detection
```bash
# Install fail2ban
sudo apt install fail2ban

# Configure fail2ban
sudo nano /etc/fail2ban/jail.local

# SSH protection
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

### Network Security Script
```bash
#!/bin/bash
# network_security.sh

echo "Network Security Check"
echo "====================="

# Check open ports
echo "Open ports on localhost:"
nmap -sT -O localhost

# Check for suspicious connections
echo "Active network connections:"
netstat -tulpn | grep LISTEN

# Check firewall status
echo "Firewall status:"
sudo ufw status verbose

# Check for failed login attempts
echo "Failed login attempts:"
sudo grep "Failed password" /var/log/auth.log | tail -10
```

## 📊 Network Monitoring

### Bandwidth Monitoring
```bash
# Install monitoring tools
sudo apt install iftop nethogs vnstat

# Monitor bandwidth usage
sudo iftop -i eth0

# Monitor per-process bandwidth
sudo nethogs

# Monitor daily bandwidth
vnstat -d

# Monitor monthly bandwidth
vnstat -m
```

### Network Performance Testing
```bash
# Install testing tools
sudo apt install iperf3 speedtest-cli

# Test local network speed
# Server side
iperf3 -s

# Client side
iperf3 -c server_ip

# Test internet speed
speedtest-cli

# Test latency
ping -c 10 google.com
```

### Monitoring Script
```bash
#!/bin/bash
# network_monitor.sh

echo "Network Performance Monitor"
echo "=========================="

# Monitor bandwidth
echo "Bandwidth usage:"
ifconfig eth0 | grep "RX bytes\|TX bytes"

# Monitor latency
echo "Latency test:"
ping -c 5 8.8.8.8 | grep "avg"

# Monitor packet loss
echo "Packet loss test:"
ping -c 100 8.8.8.8 | grep "packet loss"

# Monitor DNS resolution time
echo "DNS resolution time:"
time nslookup google.com > /dev/null
```

## 🌐 Web Server Setup

### Apache Installation
```bash
# Install Apache
sudo apt install apache2

# Start Apache
sudo systemctl start apache2
sudo systemctl enable apache2

# Check status
sudo systemctl status apache2

# Configure virtual hosts
sudo nano /etc/apache2/sites-available/example.com.conf

# Virtual host configuration
<VirtualHost *:80>
    ServerName example.com
    ServerAlias www.example.com
    DocumentRoot /var/www/example.com
    ErrorLog ${APACHE_LOG_DIR}/example.com_error.log
    CustomLog ${APACHE_LOG_DIR}/example.com_access.log combined
</VirtualHost>

# Enable site
sudo a2ensite example.com.conf
sudo systemctl reload apache2
```

### Nginx Installation
```bash
# Install Nginx
sudo apt install nginx

# Start Nginx
sudo systemctl start nginx
sudo systemctl enable nginx

# Configure Nginx
sudo nano /etc/nginx/sites-available/example.com

# Server configuration
server {
    listen 80;
    server_name example.com www.example.com;
    root /var/www/example.com;
    index index.html index.htm;

    location / {
        try_files $uri $uri/ =404;
    }
}

# Enable site
sudo ln -s /etc/nginx/sites-available/example.com /etc/nginx/sites-enabled/
sudo nginx -t
sudo systemctl reload nginx
```

## 📚 Learning Resources

### Networking Documentation
- **Cisco Documentation**: https://www.cisco.com/c/en/us/support/
- **RFC Documents**: https://www.rfc-editor.org/
- **Wireshark Documentation**: https://www.wireshark.org/docs/
- **Nmap Documentation**: https://nmap.org/book/

### Online Tools
- **Subnet Calculator**: https://www.subnet-calculator.com/
- **Port Checker**: https://www.yougetsignal.com/tools/open-ports/
- **DNS Lookup**: https://www.dnswatch.info/
- **Network Tools**: https://network-tools.com/

### Books
- **Computer Networks**: Andrew Tanenbaum
- **TCP/IP Illustrated**: W. Richard Stevens
- **Network Security Essentials**: William Stallings

## 🎯 IT-212 Project Checklist

### Phase 1: Tool Setup
- [ ] Install Wireshark and network analysis tools
- [ ] Set up network monitoring tools
- [ ] Configure DNS and routing tools
- [ ] Install security and firewall tools

### Phase 2: Network Analysis
- [ ] Capture and analyze network traffic
- [ ] Perform network discovery scans
- [ ] Test DNS resolution and configuration
- [ ] Analyze network protocols

### Phase 3: Security Testing
- [ ] Configure firewall rules
- [ ] Test network security measures
- [ ] Perform vulnerability assessments
- [ ] Monitor for suspicious activity

### Phase 4: Performance Testing
- [ ] Test network bandwidth and latency
- [ ] Monitor network performance
- [ ] Optimize network configuration
- [ ] Document network topology

### Phase 5: Documentation
- [ ] Document network configuration
- [ ] Create network diagrams
- [ ] Document security policies
- [ ] Create troubleshooting guides

## 💡 Pro Tips

1. **Start with Wireshark**: Learn packet analysis fundamentals
2. **Practice with Labs**: Use virtual labs for hands-on experience
3. **Understand Protocols**: Learn OSI model and TCP/IP stack
4. **Security First**: Always consider security implications
5. **Document Everything**: Keep detailed network documentation
6. **Use Virtual Environments**: Practice with VMs and containers
7. **Stay Updated**: Keep tools and knowledge current
8. **Join Communities**: Network with other networking professionals
9. **Certification Paths**: Consider CCNA, Network+, or similar
10. **Hands-on Practice**: Theory without practice is incomplete

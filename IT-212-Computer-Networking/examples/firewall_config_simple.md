# IT-212 Firewall Configuration Example

## 🛡️ Basic Firewall Rules for Small Office

### Scenario
Configure firewall for office with:
- Web server in DMZ
- Internal file server
- Workstations
- Guest wireless network

## 📋 Firewall Rule Set

### Inbound Rules (Internet → Internal)
```
Rule 1: Allow HTTP to Web Server
Source: Any
Destination: 192.168.1.10:80
Action: ALLOW

Rule 2: Allow HTTPS to Web Server  
Source: Any
Destination: 192.168.1.10:443
Action: ALLOW

Rule 3: Deny all other inbound
Source: Any
Destination: Any
Action: DENY
```

### Outbound Rules (Internal → Internet)
```
Rule 1: Allow HTTP/HTTPS from workstations
Source: 192.168.1.0/24
Destination: Any:80,443
Action: ALLOW

Rule 2: Allow DNS queries
Source: Any
Destination: Any:53
Action: ALLOW

Rule 3: Allow all other outbound
Source: 192.168.1.0/24
Destination: Any
Action: ALLOW
```

### Internal Rules (LAN → LAN)
```
Rule 1: Allow workstation to file server
Source: 192.168.1.50-69
Destination: 192.168.1.11:445,139
Action: ALLOW

Rule 2: Allow workstation to print server
Source: 192.168.1.50-69
Destination: 192.168.1.12:9100,515
Action: ALLOW

Rule 3: Deny guest network to internal
Source: 192.168.2.0/24
Destination: 192.168.1.0/24
Action: DENY
```

## 🔧 Implementation Notes

### Security Best Practices
- **Default Deny**: Block all traffic by default
- **Least Privilege**: Only allow necessary ports/protocols
- **Network Segmentation**: Isolate guest network
- **Regular Updates**: Keep firewall firmware current

### Monitoring
- Log all denied connections
- Monitor for unusual traffic patterns
- Set up alerts for failed login attempts
- Regular security audits

## ✅ Testing Checklist
- [ ] Web server accessible from internet
- [ ] File server accessible from workstations only
- [ ] Guest network isolated from internal
- [ ] DNS resolution working
- [ ] Email access (if applicable)

# IT-212 Network Diagram Sample

## 🏢 Small Business Network Topology

### Network Components
- **Internet Gateway**: Router with firewall
- **Core Switch**: 24-port managed switch
- **Access Points**: 2 wireless access points
- **Servers**: Web server, file server, print server
- **Workstations**: 20 desktop computers
- **Network Printer**: Shared laser printer

## 📊 Network Diagram

```
Internet
    |
[Firewall/Router] 192.168.1.1/24
    |
[Core Switch] 192.168.1.2/24
    |
    ├── [Web Server] 192.168.1.10/24
    ├── [File Server] 192.168.1.11/24
    ├── [Print Server] 192.168.1.12/24
    ├── [WAP-1] 192.168.1.20/24
    ├── [WAP-2] 192.168.1.21/24
    └── [Workstations] 192.168.1.50-69/24
```

## 🔒 Security Zones

### DMZ (Demilitarized Zone)
- Web server (192.168.1.10)
- Exposed to internet with restricted access

### Internal Network
- File server (192.168.1.11)
- Print server (192.168.1.12)
- Workstations (192.168.1.50-69)
- Protected by firewall rules

### Wireless Network
- Guest network: 192.168.2.0/24
- Employee network: 192.168.1.0/24
- Isolated from each other

## 📋 Design Justification
- **Scalability**: Room for 254 devices in /24 network
- **Security**: Firewall separates internal/external traffic
- **Redundancy**: Multiple access points for wireless coverage
- **Management**: Centralized switch for easy administration

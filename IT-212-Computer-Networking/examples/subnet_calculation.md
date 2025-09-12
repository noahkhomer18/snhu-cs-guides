# IT-212 Subnetting Exercise

## 🎯 Scenario: Small Office Network Design
Design a network for a small office with:
- 25 workstations
- 3 servers (web, database, file server)
- 1 network printer
- 1 wireless access point

## 📊 IP Address Planning

### Given: 192.168.1.0/24 network

**Step 1: Calculate subnet requirements**
- Workstations: 25 hosts → need /27 (32 addresses, 30 usable)
- Servers: 3 hosts → need /29 (8 addresses, 6 usable)  
- Network devices: 2 hosts → need /30 (4 addresses, 2 usable)

**Step 2: Subnet allocation**
```
192.168.1.0/27   - Workstations (192.168.1.1 - 192.168.1.30)
192.168.1.32/29  - Servers (192.168.1.33 - 192.168.1.38)
192.168.1.40/30  - Network devices (192.168.1.41 - 192.168.1.42)
```

## 🔧 Configuration Examples

### Router Configuration
```
interface GigabitEthernet0/0
 ip address 192.168.1.1 255.255.255.224
 description Workstation VLAN
```

### DHCP Scope
```
ip dhcp pool WORKSTATIONS
 network 192.168.1.0 255.255.255.224
 default-router 192.168.1.1
 dns-server 192.168.1.33
```

## ✅ Verification
- Ping test from workstation to server: `ping 192.168.1.33`
- Check routing table: `show ip route`
- Verify DHCP assignment: `ipconfig /all`

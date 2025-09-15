# CS-370 Blockchain Development

## 🎯 Purpose
Demonstrate blockchain development concepts, smart contracts, and decentralized applications (DApps) using Ethereum and other blockchain platforms.

## 📝 Blockchain Development Examples

### Ethereum Smart Contracts

#### Basic Smart Contract
```solidity
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract UserRegistry {
    struct User {
        string name;
        string email;
        uint256 age;
        bool isActive;
        uint256 createdAt;
    }
    
    mapping(address => User) public users;
    mapping(address => bool) public registeredUsers;
    address[] public userAddresses;
    
    address public owner;
    uint256 public userCount;
    
    event UserRegistered(address indexed userAddress, string name, string email);
    event UserUpdated(address indexed userAddress, string name, string email);
    event UserDeactivated(address indexed userAddress);
    
    modifier onlyOwner() {
        require(msg.sender == owner, "Only owner can call this function");
        _;
    }
    
    modifier onlyRegisteredUser() {
        require(registeredUsers[msg.sender], "User not registered");
        _;
    }
    
    constructor() {
        owner = msg.sender;
    }
    
    function registerUser(
        string memory _name,
        string memory _email,
        uint256 _age
    ) public {
        require(!registeredUsers[msg.sender], "User already registered");
        require(bytes(_name).length > 0, "Name cannot be empty");
        require(bytes(_email).length > 0, "Email cannot be empty");
        require(_age > 0, "Age must be greater than 0");
        
        users[msg.sender] = User({
            name: _name,
            email: _email,
            age: _age,
            isActive: true,
            createdAt: block.timestamp
        });
        
        registeredUsers[msg.sender] = true;
        userAddresses.push(msg.sender);
        userCount++;
        
        emit UserRegistered(msg.sender, _name, _email);
    }
    
    function updateUser(
        string memory _name,
        string memory _email,
        uint256 _age
    ) public onlyRegisteredUser {
        require(bytes(_name).length > 0, "Name cannot be empty");
        require(bytes(_email).length > 0, "Email cannot be empty");
        require(_age > 0, "Age must be greater than 0");
        
        users[msg.sender].name = _name;
        users[msg.sender].email = _email;
        users[msg.sender].age = _age;
        
        emit UserUpdated(msg.sender, _name, _email);
    }
    
    function deactivateUser() public onlyRegisteredUser {
        users[msg.sender].isActive = false;
        emit UserDeactivated(msg.sender);
    }
    
    function getUser(address _userAddress) public view returns (
        string memory name,
        string memory email,
        uint256 age,
        bool isActive,
        uint256 createdAt
    ) {
        require(registeredUsers[_userAddress], "User not registered");
        User memory user = users[_userAddress];
        return (user.name, user.email, user.age, user.isActive, user.createdAt);
    }
    
    function getAllUsers() public view returns (address[] memory) {
        return userAddresses;
    }
    
    function getActiveUserCount() public view returns (uint256) {
        uint256 activeCount = 0;
        for (uint256 i = 0; i < userAddresses.length; i++) {
            if (users[userAddresses[i]].isActive) {
                activeCount++;
            }
        }
        return activeCount;
    }
}
```

#### Token Contract (ERC-20)
```solidity
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract MyToken {
    string public name;
    string public symbol;
    uint8 public decimals;
    uint256 public totalSupply;
    
    mapping(address => uint256) public balanceOf;
    mapping(address => mapping(address => uint256)) public allowance;
    
    event Transfer(address indexed from, address indexed to, uint256 value);
    event Approval(address indexed owner, address indexed spender, uint256 value);
    
    constructor(
        string memory _name,
        string memory _symbol,
        uint8 _decimals,
        uint256 _totalSupply
    ) {
        name = _name;
        symbol = _symbol;
        decimals = _decimals;
        totalSupply = _totalSupply * 10**_decimals;
        balanceOf[msg.sender] = totalSupply;
        emit Transfer(address(0), msg.sender, totalSupply);
    }
    
    function transfer(address _to, uint256 _value) public returns (bool success) {
        require(balanceOf[msg.sender] >= _value, "Insufficient balance");
        require(_to != address(0), "Invalid recipient address");
        
        balanceOf[msg.sender] -= _value;
        balanceOf[_to] += _value;
        
        emit Transfer(msg.sender, _to, _value);
        return true;
    }
    
    function approve(address _spender, uint256 _value) public returns (bool success) {
        allowance[msg.sender][_spender] = _value;
        emit Approval(msg.sender, _spender, _value);
        return true;
    }
    
    function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
        require(_value <= balanceOf[_from], "Insufficient balance");
        require(_value <= allowance[_from][msg.sender], "Insufficient allowance");
        require(_to != address(0), "Invalid recipient address");
        
        balanceOf[_from] -= _value;
        balanceOf[_to] += _value;
        allowance[_from][msg.sender] -= _value;
        
        emit Transfer(_from, _to, _value);
        return true;
    }
    
    function burn(uint256 _value) public returns (bool success) {
        require(balanceOf[msg.sender] >= _value, "Insufficient balance");
        
        balanceOf[msg.sender] -= _value;
        totalSupply -= _value;
        
        emit Transfer(msg.sender, address(0), _value);
        return true;
    }
}
```

### Web3.js Integration

#### Frontend DApp with Web3.js
```javascript
// web3-config.js
import Web3 from 'web3';

class Web3Service {
    constructor() {
        this.web3 = null;
        this.contract = null;
        this.account = null;
    }

    async connectWallet() {
        if (window.ethereum) {
            try {
                // Request account access
                await window.ethereum.request({ method: 'eth_requestAccounts' });
                
                // Create Web3 instance
                this.web3 = new Web3(window.ethereum);
                
                // Get accounts
                const accounts = await this.web3.eth.getAccounts();
                this.account = accounts[0];
                
                // Load contract
                await this.loadContract();
                
                return true;
            } catch (error) {
                console.error('Error connecting wallet:', error);
                return false;
            }
        } else {
            alert('Please install MetaMask!');
            return false;
        }
    }

    async loadContract() {
        const contractABI = [
            {
                "inputs": [
                    {"internalType": "string", "name": "_name", "type": "string"},
                    {"internalType": "string", "name": "_email", "type": "string"},
                    {"internalType": "uint256", "name": "_age", "type": "uint256"}
                ],
                "name": "registerUser",
                "outputs": [],
                "stateMutability": "nonpayable",
                "type": "function"
            },
            {
                "inputs": [{"internalType": "address", "name": "_userAddress", "type": "address"}],
                "name": "getUser",
                "outputs": [
                    {"internalType": "string", "name": "name", "type": "string"},
                    {"internalType": "string", "name": "email", "type": "string"},
                    {"internalType": "uint256", "name": "age", "type": "uint256"},
                    {"internalType": "bool", "name": "isActive", "type": "bool"},
                    {"internalType": "uint256", "name": "createdAt", "type": "uint256"}
                ],
                "stateMutability": "view",
                "type": "function"
            },
            {
                "inputs": [],
                "name": "getAllUsers",
                "outputs": [{"internalType": "address[]", "name": "", "type": "address[]"}],
                "stateMutability": "view",
                "type": "function"
            }
        ];

        const contractAddress = '0x...'; // Contract address after deployment
        
        this.contract = new this.web3.eth.Contract(contractABI, contractAddress);
    }

    async registerUser(name, email, age) {
        try {
            const gasEstimate = await this.contract.methods
                .registerUser(name, email, age)
                .estimateGas({ from: this.account });
            
            const result = await this.contract.methods
                .registerUser(name, email, age)
                .send({ 
                    from: this.account,
                    gas: gasEstimate
                });
            
            return result;
        } catch (error) {
            console.error('Error registering user:', error);
            throw error;
        }
    }

    async getUser(userAddress) {
        try {
            const result = await this.contract.methods.getUser(userAddress).call();
            return {
                name: result.name,
                email: result.email,
                age: result.age,
                isActive: result.isActive,
                createdAt: result.createdAt
            };
        } catch (error) {
            console.error('Error getting user:', error);
            throw error;
        }
    }

    async getAllUsers() {
        try {
            const addresses = await this.contract.methods.getAllUsers().call();
            const users = [];
            
            for (const address of addresses) {
                const user = await this.getUser(address);
                users.push({ address, ...user });
            }
            
            return users;
        } catch (error) {
            console.error('Error getting all users:', error);
            throw error;
        }
    }

    async getBalance() {
        try {
            const balance = await this.web3.eth.getBalance(this.account);
            return this.web3.utils.fromWei(balance, 'ether');
        } catch (error) {
            console.error('Error getting balance:', error);
            throw error;
        }
    }
}

export default new Web3Service();
```

#### React DApp Component
```jsx
// DApp.jsx
import React, { useState, useEffect } from 'react';
import Web3Service from './web3-config';

const DApp = () => {
    const [connected, setConnected] = useState(false);
    const [users, setUsers] = useState([]);
    const [loading, setLoading] = useState(false);
    const [formData, setFormData] = useState({
        name: '',
        email: '',
        age: ''
    });

    useEffect(() => {
        checkConnection();
    }, []);

    const checkConnection = async () => {
        if (window.ethereum) {
            const accounts = await window.ethereum.request({ method: 'eth_accounts' });
            if (accounts.length > 0) {
                setConnected(true);
                loadUsers();
            }
        }
    };

    const connectWallet = async () => {
        setLoading(true);
        try {
            const success = await Web3Service.connectWallet();
            if (success) {
                setConnected(true);
                loadUsers();
            }
        } catch (error) {
            console.error('Connection failed:', error);
        } finally {
            setLoading(false);
        }
    };

    const loadUsers = async () => {
        try {
            const userList = await Web3Service.getAllUsers();
            setUsers(userList);
        } catch (error) {
            console.error('Failed to load users:', error);
        }
    };

    const handleSubmit = async (e) => {
        e.preventDefault();
        setLoading(true);
        
        try {
            await Web3Service.registerUser(
                formData.name,
                formData.email,
                parseInt(formData.age)
            );
            
            setFormData({ name: '', email: '', age: '' });
            loadUsers(); // Refresh the list
        } catch (error) {
            console.error('Registration failed:', error);
        } finally {
            setLoading(false);
        }
    };

    const handleInputChange = (e) => {
        setFormData({
            ...formData,
            [e.target.name]: e.target.value
        });
    };

    if (!connected) {
        return (
            <div className="dapp-container">
                <h1>Blockchain User Registry</h1>
                <p>Connect your wallet to interact with the smart contract</p>
                <button 
                    onClick={connectWallet}
                    disabled={loading}
                    className="connect-button"
                >
                    {loading ? 'Connecting...' : 'Connect Wallet'}
                </button>
            </div>
        );
    }

    return (
        <div className="dapp-container">
            <h1>Blockchain User Registry</h1>
            <p>Connected to Ethereum network</p>
            
            <div className="form-section">
                <h2>Register New User</h2>
                <form onSubmit={handleSubmit} className="user-form">
                    <input
                        type="text"
                        name="name"
                        placeholder="Name"
                        value={formData.name}
                        onChange={handleInputChange}
                        required
                    />
                    <input
                        type="email"
                        name="email"
                        placeholder="Email"
                        value={formData.email}
                        onChange={handleInputChange}
                        required
                    />
                    <input
                        type="number"
                        name="age"
                        placeholder="Age"
                        value={formData.age}
                        onChange={handleInputChange}
                        required
                    />
                    <button type="submit" disabled={loading}>
                        {loading ? 'Registering...' : 'Register User'}
                    </button>
                </form>
            </div>

            <div className="users-section">
                <h2>Registered Users ({users.length})</h2>
                <div className="users-list">
                    {users.map((user, index) => (
                        <div key={index} className="user-card">
                            <h3>{user.name}</h3>
                            <p>Email: {user.email}</p>
                            <p>Age: {user.age}</p>
                            <p>Address: {user.address}</p>
                            <p>Status: {user.isActive ? 'Active' : 'Inactive'}</p>
                            <p>Created: {new Date(user.createdAt * 1000).toLocaleDateString()}</p>
                        </div>
                    ))}
                </div>
            </div>
        </div>
    );
};

export default DApp;
```

### IPFS Integration

#### File Storage with IPFS
```javascript
// ipfs-service.js
import { create } from 'ipfs-http-client';

class IPFSService {
    constructor() {
        this.ipfs = create({
            host: 'ipfs.infura.io',
            port: 5001,
            protocol: 'https'
        });
    }

    async uploadFile(file) {
        try {
            const result = await this.ipfs.add(file);
            return result.path;
        } catch (error) {
            console.error('Error uploading to IPFS:', error);
            throw error;
        }
    }

    async uploadJSON(data) {
        try {
            const jsonString = JSON.stringify(data);
            const result = await this.ipfs.add(jsonString);
            return result.path;
        } catch (error) {
            console.error('Error uploading JSON to IPFS:', error);
            throw error;
        }
    }

    async getFile(hash) {
        try {
            const chunks = [];
            for await (const chunk of this.ipfs.cat(hash)) {
                chunks.push(chunk);
            }
            return Buffer.concat(chunks);
        } catch (error) {
            console.error('Error getting file from IPFS:', error);
            throw error;
        }
    }

    async getJSON(hash) {
        try {
            const file = await this.getFile(hash);
            return JSON.parse(file.toString());
        } catch (error) {
            console.error('Error getting JSON from IPFS:', error);
            throw error;
        }
    }
}

export default new IPFSService();
```

### DeFi (Decentralized Finance) Example

#### Simple DEX Contract
```solidity
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract SimpleDEX {
    mapping(address => mapping(address => uint256)) public liquidity;
    mapping(address => uint256) public totalLiquidity;
    
    event LiquidityAdded(address indexed token, address indexed provider, uint256 amount);
    event LiquidityRemoved(address indexed token, address indexed provider, uint256 amount);
    event SwapExecuted(address indexed tokenIn, address indexed tokenOut, uint256 amountIn, uint256 amountOut);
    
    function addLiquidity(address token, uint256 amount) external {
        require(amount > 0, "Amount must be greater than 0");
        
        // Transfer tokens from user to contract
        IERC20(token).transferFrom(msg.sender, address(this), amount);
        
        liquidity[token][msg.sender] += amount;
        totalLiquidity[token] += amount;
        
        emit LiquidityAdded(token, msg.sender, amount);
    }
    
    function removeLiquidity(address token, uint256 amount) external {
        require(amount > 0, "Amount must be greater than 0");
        require(liquidity[token][msg.sender] >= amount, "Insufficient liquidity");
        
        liquidity[token][msg.sender] -= amount;
        totalLiquidity[token] -= amount;
        
        IERC20(token).transfer(msg.sender, amount);
        
        emit LiquidityRemoved(token, msg.sender, amount);
    }
    
    function swap(address tokenIn, address tokenOut, uint256 amountIn) external {
        require(amountIn > 0, "Amount must be greater than 0");
        require(totalLiquidity[tokenIn] > 0, "No liquidity for input token");
        require(totalLiquidity[tokenOut] > 0, "No liquidity for output token");
        
        // Calculate output amount using constant product formula (x * y = k)
        uint256 amountOut = (amountIn * totalLiquidity[tokenOut]) / totalLiquidity[tokenIn];
        
        require(amountOut > 0, "Insufficient output amount");
        require(totalLiquidity[tokenOut] >= amountOut, "Insufficient liquidity for output");
        
        // Transfer input tokens from user
        IERC20(tokenIn).transferFrom(msg.sender, address(this), amountIn);
        
        // Update liquidity
        totalLiquidity[tokenIn] += amountIn;
        totalLiquidity[tokenOut] -= amountOut;
        
        // Transfer output tokens to user
        IERC20(tokenOut).transfer(msg.sender, amountOut);
        
        emit SwapExecuted(tokenIn, tokenOut, amountIn, amountOut);
    }
    
    function getPrice(address tokenIn, address tokenOut, uint256 amountIn) external view returns (uint256) {
        if (totalLiquidity[tokenIn] == 0 || totalLiquidity[tokenOut] == 0) {
            return 0;
        }
        return (amountIn * totalLiquidity[tokenOut]) / totalLiquidity[tokenIn];
    }
}

interface IERC20 {
    function transfer(address to, uint256 amount) external returns (bool);
    function transferFrom(address from, address to, uint256 amount) external returns (bool);
    function balanceOf(address account) external view returns (uint256);
}
```

## 🔍 Blockchain Development Concepts
- **Smart Contracts**: Self-executing contracts with terms directly written into code
- **Decentralized Applications (DApps)**: Applications that run on blockchain networks
- **Web3.js**: JavaScript library for interacting with Ethereum blockchain
- **IPFS**: InterPlanetary File System for decentralized file storage
- **DeFi**: Decentralized finance applications and protocols

## 💡 Learning Points
- Smart contracts are immutable once deployed to the blockchain
- Gas fees are required for all blockchain transactions
- Web3.js enables frontend integration with blockchain networks
- IPFS provides decentralized file storage solutions
- DeFi protocols enable financial services without intermediaries

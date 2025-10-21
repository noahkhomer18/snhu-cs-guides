# CS-305 Software Security: SHA-256 and Encryption Comprehensive Guide

## 🎯 Purpose
Comprehensive guide to SHA-256 hashing, encryption techniques, and secure cryptographic implementations for software security applications.

## 📝 SHA-256 Hashing Examples

### Example 1: Basic SHA-256 Hashing

**Java Implementation**:
```java
import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;
import java.security.SecureRandom;
import java.nio.charset.StandardCharsets;

public class SHA256HashExample {
    
    /**
     * Generate SHA-256 hash of input string
     * @param input The string to hash
     * @return SHA-256 hash as hexadecimal string
     */
    public static String hashSHA256(String input) throws NoSuchAlgorithmException {
        MessageDigest digest = MessageDigest.getInstance("SHA-256");
        byte[] hashBytes = digest.digest(input.getBytes(StandardCharsets.UTF_8));
        
        // Convert byte array to hexadecimal string
        StringBuilder hexString = new StringBuilder();
        for (byte b : hashBytes) {
            String hex = Integer.toHexString(0xff & b);
            if (hex.length() == 1) {
                hexString.append('0');
            }
            hexString.append(hex);
        }
        return hexString.toString();
    }
    
    /**
     * Generate SHA-256 hash with salt for password security
     * @param password The password to hash
     * @param salt The salt to add
     * @return SHA-256 hash with salt
     */
    public static String hashPasswordWithSalt(String password, String salt) throws NoSuchAlgorithmException {
        String saltedPassword = password + salt;
        return hashSHA256(saltedPassword);
    }
    
    /**
     * Generate random salt for password hashing
     * @return Random salt as hexadecimal string
     */
    public static String generateSalt() {
        SecureRandom random = new SecureRandom();
        byte[] salt = new byte[16];
        random.nextBytes(salt);
        
        StringBuilder hexString = new StringBuilder();
        for (byte b : salt) {
            String hex = Integer.toHexString(0xff & b);
            if (hex.length() == 1) {
                hexString.append('0');
            }
            hexString.append(hex);
        }
        return hexString.toString();
    }
    
    public static void main(String[] args) {
        try {
            // Basic hashing
            String input = "Hello, World!";
            String hash = hashSHA256(input);
            System.out.println("Input: " + input);
            System.out.println("SHA-256 Hash: " + hash);
            
            // Password hashing with salt
            String password = "mySecurePassword123";
            String salt = generateSalt();
            String hashedPassword = hashPasswordWithSalt(password, salt);
            
            System.out.println("\nPassword: " + password);
            System.out.println("Salt: " + salt);
            System.out.println("Hashed Password: " + hashedPassword);
            
        } catch (NoSuchAlgorithmException e) {
            System.err.println("SHA-256 algorithm not available: " + e.getMessage());
        }
    }
}
```

### Example 2: Python SHA-256 Implementation

**Python Implementation**:
```python
import hashlib
import secrets
import hmac

class SHA256HashExample:
    
    @staticmethod
    def hash_sha256(input_string):
        """
        Generate SHA-256 hash of input string
        """
        return hashlib.sha256(input_string.encode('utf-8')).hexdigest()
    
    @staticmethod
    def hash_password_with_salt(password, salt):
        """
        Generate SHA-256 hash with salt for password security
        """
        salted_password = password + salt
        return hashlib.sha256(salted_password.encode('utf-8')).hexdigest()
    
    @staticmethod
    def generate_salt(length=16):
        """
        Generate random salt for password hashing
        """
        return secrets.token_hex(length)
    
    @staticmethod
    def verify_password(password, salt, stored_hash):
        """
        Verify password against stored hash
        """
        computed_hash = SHA256HashExample.hash_password_with_salt(password, salt)
        return hmac.compare_digest(computed_hash, stored_hash)
    
    @staticmethod
    def hash_file(file_path):
        """
        Generate SHA-256 hash of a file
        """
        sha256_hash = hashlib.sha256()
        with open(file_path, "rb") as f:
            for byte_block in iter(lambda: f.read(4096), b""):
                sha256_hash.update(byte_block)
        return sha256_hash.hexdigest()

# Usage example
if __name__ == "__main__":
    # Basic hashing
    input_text = "Hello, World!"
    hash_result = SHA256HashExample.hash_sha256(input_text)
    print(f"Input: {input_text}")
    print(f"SHA-256 Hash: {hash_result}")
    
    # Password hashing with salt
    password = "mySecurePassword123"
    salt = SHA256HashExample.generate_salt()
    hashed_password = SHA256HashExample.hash_password_with_salt(password, salt)
    
    print(f"\nPassword: {password}")
    print(f"Salt: {salt}")
    print(f"Hashed Password: {hashed_password}")
    
    # Verify password
    is_valid = SHA256HashExample.verify_password(password, salt, hashed_password)
    print(f"Password verification: {is_valid}")
```

### Example 3: JavaScript/Node.js SHA-256 Implementation

**Node.js Implementation**:
```javascript
const crypto = require('crypto');

class SHA256HashExample {
    
    /**
     * Generate SHA-256 hash of input string
     * @param {string} input - The string to hash
     * @returns {string} SHA-256 hash as hexadecimal string
     */
    static hashSHA256(input) {
        return crypto.createHash('sha256').update(input, 'utf8').digest('hex');
    }
    
    /**
     * Generate SHA-256 hash with salt for password security
     * @param {string} password - The password to hash
     * @param {string} salt - The salt to add
     * @returns {string} SHA-256 hash with salt
     */
    static hashPasswordWithSalt(password, salt) {
        const saltedPassword = password + salt;
        return crypto.createHash('sha256').update(saltedPassword, 'utf8').digest('hex');
    }
    
    /**
     * Generate random salt for password hashing
     * @param {number} length - Length of salt in bytes
     * @returns {string} Random salt as hexadecimal string
     */
    static generateSalt(length = 16) {
        return crypto.randomBytes(length).toString('hex');
    }
    
    /**
     * Verify password against stored hash
     * @param {string} password - The password to verify
     * @param {string} salt - The salt used
     * @param {string} storedHash - The stored hash to compare against
     * @returns {boolean} True if password matches
     */
    static verifyPassword(password, salt, storedHash) {
        const computedHash = this.hashPasswordWithSalt(password, salt);
        return crypto.timingSafeEqual(
            Buffer.from(computedHash, 'hex'),
            Buffer.from(storedHash, 'hex')
        );
    }
    
    /**
     * Generate SHA-256 hash of a file
     * @param {string} filePath - Path to the file
     * @returns {Promise<string>} SHA-256 hash of the file
     */
    static async hashFile(filePath) {
        const fs = require('fs');
        const hash = crypto.createHash('sha256');
        const stream = fs.createReadStream(filePath);
        
        return new Promise((resolve, reject) => {
            stream.on('data', (data) => hash.update(data));
            stream.on('end', () => resolve(hash.digest('hex')));
            stream.on('error', reject);
        });
    }
}

// Usage example
async function main() {
    try {
        // Basic hashing
        const input = "Hello, World!";
        const hash = SHA256HashExample.hashSHA256(input);
        console.log(`Input: ${input}`);
        console.log(`SHA-256 Hash: ${hash}`);
        
        // Password hashing with salt
        const password = "mySecurePassword123";
        const salt = SHA256HashExample.generateSalt();
        const hashedPassword = SHA256HashExample.hashPasswordWithSalt(password, salt);
        
        console.log(`\nPassword: ${password}`);
        console.log(`Salt: ${salt}`);
        console.log(`Hashed Password: ${hashedPassword}`);
        
        // Verify password
        const isValid = SHA256HashExample.verifyPassword(password, salt, hashedPassword);
        console.log(`Password verification: ${isValid}`);
        
    } catch (error) {
        console.error('Error:', error.message);
    }
}

main();
```

## 🔐 Advanced Encryption Examples

### Example 4: AES-256 Encryption

**Java AES-256 Implementation**:
```java
import javax.crypto.Cipher;
import javax.crypto.KeyGenerator;
import javax.crypto.SecretKey;
import javax.crypto.spec.GCMParameterSpec;
import javax.crypto.spec.SecretKeySpec;
import java.security.SecureRandom;
import java.util.Base64;

public class AES256EncryptionExample {
    
    private static final String ALGORITHM = "AES";
    private static final String TRANSFORMATION = "AES/GCM/NoPadding";
    private static final int GCM_IV_LENGTH = 12;
    private static final int GCM_TAG_LENGTH = 16;
    
    /**
     * Generate AES-256 secret key
     * @return SecretKey for AES-256 encryption
     */
    public static SecretKey generateKey() throws Exception {
        KeyGenerator keyGenerator = KeyGenerator.getInstance(ALGORITHM);
        keyGenerator.init(256);
        return keyGenerator.generateKey();
    }
    
    /**
     * Encrypt plaintext using AES-256-GCM
     * @param plaintext The text to encrypt
     * @param key The secret key
     * @return Encrypted data as Base64 string
     */
    public static String encrypt(String plaintext, SecretKey key) throws Exception {
        Cipher cipher = Cipher.getInstance(TRANSFORMATION);
        
        // Generate random IV
        byte[] iv = new byte[GCM_IV_LENGTH];
        new SecureRandom().nextBytes(iv);
        
        GCMParameterSpec parameterSpec = new GCMParameterSpec(GCM_TAG_LENGTH * 8, iv);
        cipher.init(Cipher.ENCRYPT_MODE, key, parameterSpec);
        
        byte[] cipherText = cipher.doFinal(plaintext.getBytes());
        
        // Combine IV and ciphertext
        byte[] encryptedData = new byte[GCM_IV_LENGTH + cipherText.length];
        System.arraycopy(iv, 0, encryptedData, 0, GCM_IV_LENGTH);
        System.arraycopy(cipherText, 0, encryptedData, GCM_IV_LENGTH, cipherText.length);
        
        return Base64.getEncoder().encodeToString(encryptedData);
    }
    
    /**
     * Decrypt ciphertext using AES-256-GCM
     * @param encryptedData The encrypted data as Base64 string
     * @param key The secret key
     * @return Decrypted plaintext
     */
    public static String decrypt(String encryptedData, SecretKey key) throws Exception {
        byte[] encryptedBytes = Base64.getDecoder().decode(encryptedData);
        
        // Extract IV and ciphertext
        byte[] iv = new byte[GCM_IV_LENGTH];
        byte[] cipherText = new byte[encryptedBytes.length - GCM_IV_LENGTH];
        System.arraycopy(encryptedBytes, 0, iv, 0, GCM_IV_LENGTH);
        System.arraycopy(encryptedBytes, GCM_IV_LENGTH, cipherText, 0, cipherText.length);
        
        Cipher cipher = Cipher.getInstance(TRANSFORMATION);
        GCMParameterSpec parameterSpec = new GCMParameterSpec(GCM_TAG_LENGTH * 8, iv);
        cipher.init(Cipher.DECRYPT_MODE, key, parameterSpec);
        
        byte[] plaintext = cipher.doFinal(cipherText);
        return new String(plaintext);
    }
    
    public static void main(String[] args) {
        try {
            // Generate key
            SecretKey key = generateKey();
            
            // Encrypt data
            String plaintext = "This is a secret message!";
            String encrypted = encrypt(plaintext, key);
            String decrypted = decrypt(encrypted, key);
            
            System.out.println("Original: " + plaintext);
            System.out.println("Encrypted: " + encrypted);
            System.out.println("Decrypted: " + decrypted);
            System.out.println("Match: " + plaintext.equals(decrypted));
            
        } catch (Exception e) {
            System.err.println("Encryption error: " + e.getMessage());
        }
    }
}
```

### Example 5: RSA Encryption

**Java RSA Implementation**:
```java
import javax.crypto.Cipher;
import java.security.*;
import java.security.spec.PKCS8EncodedKeySpec;
import java.security.spec.X509EncodedKeySpec;
import java.util.Base64;

public class RSAEncryptionExample {
    
    private static final String ALGORITHM = "RSA";
    private static final String TRANSFORMATION = "RSA/ECB/PKCS1Padding";
    private static final int KEY_SIZE = 2048;
    
    /**
     * Generate RSA key pair
     * @return KeyPair containing public and private keys
     */
    public static KeyPair generateKeyPair() throws Exception {
        KeyPairGenerator keyPairGenerator = KeyPairGenerator.getInstance(ALGORITHM);
        keyPairGenerator.initialize(KEY_SIZE);
        return keyPairGenerator.generateKeyPair();
    }
    
    /**
     * Encrypt data using RSA public key
     * @param plaintext The text to encrypt
     * @param publicKey The public key
     * @return Encrypted data as Base64 string
     */
    public static String encrypt(String plaintext, PublicKey publicKey) throws Exception {
        Cipher cipher = Cipher.getInstance(TRANSFORMATION);
        cipher.init(Cipher.ENCRYPT_MODE, publicKey);
        byte[] encryptedBytes = cipher.doFinal(plaintext.getBytes());
        return Base64.getEncoder().encodeToString(encryptedBytes);
    }
    
    /**
     * Decrypt data using RSA private key
     * @param encryptedData The encrypted data as Base64 string
     * @param privateKey The private key
     * @return Decrypted plaintext
     */
    public static String decrypt(String encryptedData, PrivateKey privateKey) throws Exception {
        Cipher cipher = Cipher.getInstance(TRANSFORMATION);
        cipher.init(Cipher.DECRYPT_MODE, privateKey);
        byte[] encryptedBytes = Base64.getDecoder().decode(encryptedData);
        byte[] decryptedBytes = cipher.doFinal(encryptedBytes);
        return new String(decryptedBytes);
    }
    
    /**
     * Convert PublicKey to Base64 string
     * @param publicKey The public key
     * @return Base64 encoded public key
     */
    public static String publicKeyToString(PublicKey publicKey) {
        return Base64.getEncoder().encodeToString(publicKey.getEncoded());
    }
    
    /**
     * Convert PrivateKey to Base64 string
     * @param privateKey The private key
     * @return Base64 encoded private key
     */
    public static String privateKeyToString(PrivateKey privateKey) {
        return Base64.getEncoder().encodeToString(privateKey.getEncoded());
    }
    
    /**
     * Convert Base64 string to PublicKey
     * @param publicKeyString Base64 encoded public key
     * @return PublicKey object
     */
    public static PublicKey stringToPublicKey(String publicKeyString) throws Exception {
        byte[] keyBytes = Base64.getDecoder().decode(publicKeyString);
        X509EncodedKeySpec spec = new X509EncodedKeySpec(keyBytes);
        KeyFactory keyFactory = KeyFactory.getInstance(ALGORITHM);
        return keyFactory.generatePublic(spec);
    }
    
    /**
     * Convert Base64 string to PrivateKey
     * @param privateKeyString Base64 encoded private key
     * @return PrivateKey object
     */
    public static PrivateKey stringToPrivateKey(String privateKeyString) throws Exception {
        byte[] keyBytes = Base64.getDecoder().decode(privateKeyString);
        PKCS8EncodedKeySpec spec = new PKCS8EncodedKeySpec(keyBytes);
        KeyFactory keyFactory = KeyFactory.getInstance(ALGORITHM);
        return keyFactory.generatePrivate(spec);
    }
    
    public static void main(String[] args) {
        try {
            // Generate key pair
            KeyPair keyPair = generateKeyPair();
            PublicKey publicKey = keyPair.getPublic();
            PrivateKey privateKey = keyPair.getPrivate();
            
            // Convert keys to strings for storage/transmission
            String publicKeyString = publicKeyToString(publicKey);
            String privateKeyString = privateKeyToString(privateKey);
            
            System.out.println("Public Key: " + publicKeyString);
            System.out.println("Private Key: " + privateKeyString);
            
            // Encrypt and decrypt
            String plaintext = "This is a secret message for RSA encryption!";
            String encrypted = encrypt(plaintext, publicKey);
            String decrypted = decrypt(encrypted, privateKey);
            
            System.out.println("\nOriginal: " + plaintext);
            System.out.println("Encrypted: " + encrypted);
            System.out.println("Decrypted: " + decrypted);
            System.out.println("Match: " + plaintext.equals(decrypted));
            
        } catch (Exception e) {
            System.err.println("RSA encryption error: " + e.getMessage());
        }
    }
}
```

## 🔍 Security Best Practices

### 1. Password Hashing
- **Always use salt**: Prevent rainbow table attacks
- **Use strong salts**: Random, unique salts for each password
- **Consider bcrypt/Argon2**: For production password hashing
- **Never store plaintext passwords**: Always hash before storage

### 2. Encryption Guidelines
- **Use strong algorithms**: AES-256, RSA-2048 minimum
- **Generate random IVs**: Never reuse initialization vectors
- **Secure key management**: Store keys securely, rotate regularly
- **Use authenticated encryption**: GCM mode for AES

### 3. Hash Function Security
- **SHA-256 is secure**: For most applications
- **Avoid MD5/SHA-1**: Vulnerable to collision attacks
- **Use HMAC for authentication**: When verifying message integrity
- **Consider SHA-3**: For future-proofing

## 📊 Cryptographic Algorithm Comparison

| Algorithm | Type | Key Size | Security Level | Use Case |
|-----------|------|----------|----------------|----------|
| MD5 | Hash | 128-bit | Deprecated | Legacy systems only |
| SHA-1 | Hash | 160-bit | Deprecated | Legacy systems only |
| SHA-256 | Hash | 256-bit | Secure | General purpose hashing |
| SHA-3 | Hash | 256-bit+ | Secure | Future-proof hashing |
| AES-128 | Symmetric | 128-bit | Secure | Fast encryption |
| AES-256 | Symmetric | 256-bit | Very Secure | High-security encryption |
| RSA-2048 | Asymmetric | 2048-bit | Secure | Digital signatures, key exchange |
| RSA-4096 | Asymmetric | 4096-bit | Very Secure | High-security applications |

## 🛠️ Implementation Checklist

### Before Implementation
- [ ] Choose appropriate algorithm for use case
- [ ] Understand security requirements
- [ ] Plan key management strategy
- [ ] Consider performance implications

### During Implementation
- [ ] Use secure random number generation
- [ ] Implement proper error handling
- [ ] Add input validation
- [ ] Test with various inputs

### After Implementation
- [ ] Security testing and auditing
- [ ] Performance monitoring
- [ ] Regular key rotation
- [ ] Update documentation

## 🎯 CS-305 Learning Outcomes

### Technical Skills
- **Cryptographic Implementation**: Understanding hash functions and encryption
- **Security Programming**: Writing secure cryptographic code
- **Key Management**: Proper handling of cryptographic keys
- **Algorithm Selection**: Choosing appropriate cryptographic algorithms

### Professional Skills
- **Security Awareness**: Understanding security implications
- **Best Practices**: Following industry security standards
- **Risk Assessment**: Evaluating cryptographic risks
- **Documentation**: Explaining security implementations

## 💡 Pro Tips

1. **Never implement your own crypto**: Use well-tested libraries
2. **Always use salt for passwords**: Prevent rainbow table attacks
3. **Generate random IVs**: Never reuse initialization vectors
4. **Use authenticated encryption**: GCM mode for AES
5. **Store keys securely**: Use hardware security modules when possible
6. **Regular key rotation**: Change keys periodically
7. **Test thoroughly**: Verify encryption/decryption works correctly
8. **Stay updated**: Keep up with cryptographic best practices

---

*This comprehensive SHA-256 and encryption guide provides detailed examples and best practices for CS-305 Software Security, helping students master cryptographic implementations and security programming techniques.*

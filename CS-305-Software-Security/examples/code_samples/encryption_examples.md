# CS-305 Encryption & Cryptography

## 🎯 Purpose
Demonstrate encryption, decryption, and cryptographic best practices.

## 📝 Encryption Examples

### AES Encryption
```java
import javax.crypto.Cipher;
import javax.crypto.KeyGenerator;
import javax.crypto.SecretKey;
import javax.crypto.spec.GCMParameterSpec;
import javax.crypto.spec.SecretKeySpec;
import java.security.SecureRandom;
import java.util.Base64;

public class AESEncryption {
    private static final String ALGORITHM = "AES";
    private static final String TRANSFORMATION = "AES/GCM/NoPadding";
    private static final int GCM_IV_LENGTH = 12;
    private static final int GCM_TAG_LENGTH = 16;
    
    public static SecretKey generateKey() throws Exception {
        KeyGenerator keyGenerator = KeyGenerator.getInstance(ALGORITHM);
        keyGenerator.init(256);
        return keyGenerator.generateKey();
    }
    
    public static String encrypt(String plaintext, SecretKey key) throws Exception {
        Cipher cipher = Cipher.getInstance(TRANSFORMATION);
        
        // Generate random IV
        byte[] iv = new byte[GCM_IV_LENGTH];
        new SecureRandom().nextBytes(iv);
        
        GCMParameterSpec parameterSpec = new GCMParameterSpec(GCM_TAG_LENGTH * 8, iv);
        cipher.init(Cipher.ENCRYPT_MODE, key, parameterSpec);
        
        byte[] ciphertext = cipher.doFinal(plaintext.getBytes("UTF-8"));
        
        // Combine IV and ciphertext
        byte[] encryptedWithIv = new byte[GCM_IV_LENGTH + ciphertext.length];
        System.arraycopy(iv, 0, encryptedWithIv, 0, GCM_IV_LENGTH);
        System.arraycopy(ciphertext, 0, encryptedWithIv, GCM_IV_LENGTH, ciphertext.length);
        
        return Base64.getEncoder().encodeToString(encryptedWithIv);
    }
    
    public static String decrypt(String encryptedData, SecretKey key) throws Exception {
        byte[] encryptedWithIv = Base64.getDecoder().decode(encryptedData);
        
        // Extract IV
        byte[] iv = new byte[GCM_IV_LENGTH];
        System.arraycopy(encryptedWithIv, 0, iv, 0, GCM_IV_LENGTH);
        
        // Extract ciphertext
        byte[] ciphertext = new byte[encryptedWithIv.length - GCM_IV_LENGTH];
        System.arraycopy(encryptedWithIv, GCM_IV_LENGTH, ciphertext, 0, ciphertext.length);
        
        Cipher cipher = Cipher.getInstance(TRANSFORMATION);
        GCMParameterSpec parameterSpec = new GCMParameterSpec(GCM_TAG_LENGTH * 8, iv);
        cipher.init(Cipher.DECRYPT_MODE, key, parameterSpec);
        
        byte[] plaintext = cipher.doFinal(ciphertext);
        return new String(plaintext, "UTF-8");
    }
}
```

### RSA Encryption
```java
import java.security.*;
import java.security.spec.PKCS8EncodedKeySpec;
import java.security.spec.X509EncodedKeySpec;
import javax.crypto.Cipher;
import java.util.Base64;

public class RSAEncryption {
    private static final String ALGORITHM = "RSA";
    private static final String TRANSFORMATION = "RSA/ECB/OAEPWithSHA-256AndMGF1Padding";
    
    public static KeyPair generateKeyPair() throws Exception {
        KeyPairGenerator keyPairGenerator = KeyPairGenerator.getInstance(ALGORITHM);
        keyPairGenerator.initialize(2048);
        return keyPairGenerator.generateKeyPair();
    }
    
    public static String encrypt(String plaintext, PublicKey publicKey) throws Exception {
        Cipher cipher = Cipher.getInstance(TRANSFORMATION);
        cipher.init(Cipher.ENCRYPT_MODE, publicKey);
        
        byte[] ciphertext = cipher.doFinal(plaintext.getBytes("UTF-8"));
        return Base64.getEncoder().encodeToString(ciphertext);
    }
    
    public static String decrypt(String encryptedData, PrivateKey privateKey) throws Exception {
        byte[] encryptedBytes = Base64.getDecoder().decode(encryptedData);
        
        Cipher cipher = Cipher.getInstance(TRANSFORMATION);
        cipher.init(Cipher.DECRYPT_MODE, privateKey);
        
        byte[] plaintext = cipher.doFinal(encryptedBytes);
        return new String(plaintext, "UTF-8");
    }
    
    public static String publicKeyToString(PublicKey publicKey) {
        return Base64.getEncoder().encodeToString(publicKey.getEncoded());
    }
    
    public static PublicKey stringToPublicKey(String publicKeyString) throws Exception {
        byte[] keyBytes = Base64.getDecoder().decode(publicKeyString);
        X509EncodedKeySpec spec = new X509EncodedKeySpec(keyBytes);
        KeyFactory keyFactory = KeyFactory.getInstance(ALGORITHM);
        return keyFactory.generatePublic(spec);
    }
}
```

### Digital Signatures
```java
import java.security.*;
import java.security.spec.PKCS8EncodedKeySpec;
import java.security.spec.X509EncodedKeySpec;
import java.util.Base64;

public class DigitalSignature {
    private static final String ALGORITHM = "SHA256withRSA";
    
    public static String sign(String data, PrivateKey privateKey) throws Exception {
        Signature signature = Signature.getInstance(ALGORITHM);
        signature.initSign(privateKey);
        signature.update(data.getBytes("UTF-8"));
        
        byte[] signatureBytes = signature.sign();
        return Base64.getEncoder().encodeToString(signatureBytes);
    }
    
    public static boolean verify(String data, String signature, PublicKey publicKey) throws Exception {
        Signature sig = Signature.getInstance(ALGORITHM);
        sig.initVerify(publicKey);
        sig.update(data.getBytes("UTF-8"));
        
        byte[] signatureBytes = Base64.getDecoder().decode(signature);
        return sig.verify(signatureBytes);
    }
    
    public static String createHash(String data) throws Exception {
        MessageDigest digest = MessageDigest.getInstance("SHA-256");
        byte[] hash = digest.digest(data.getBytes("UTF-8"));
        return Base64.getEncoder().encodeToString(hash);
    }
}
```

### Secure Random Number Generation
```java
import java.security.SecureRandom;
import java.util.UUID;

public class SecureRandomGeneration {
    private static final SecureRandom secureRandom = new SecureRandom();
    
    public static String generateSecureToken(int length) {
        byte[] bytes = new byte[length];
        secureRandom.nextBytes(bytes);
        return Base64.getUrlEncoder().withoutPadding().encodeToString(bytes);
    }
    
    public static String generateSecurePassword(int length) {
        String chars = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789!@#$%^&*";
        StringBuilder password = new StringBuilder();
        
        for (int i = 0; i < length; i++) {
            password.append(chars.charAt(secureRandom.nextInt(chars.length())));
        }
        
        return password.toString();
    }
    
    public static String generateUUID() {
        return UUID.randomUUID().toString();
    }
    
    public static int generateSecureInt(int min, int max) {
        return secureRandom.nextInt(max - min + 1) + min;
    }
}
```

## 🔍 Cryptographic Best Practices

### Key Management
- **Key Generation**: Use cryptographically secure random number generators
- **Key Storage**: Store keys securely (HSM, key vaults)
- **Key Rotation**: Regularly rotate encryption keys
- **Key Destruction**: Securely delete keys when no longer needed

### Encryption Standards
- **Symmetric**: AES-256 for data encryption
- **Asymmetric**: RSA-2048 or ECC for key exchange
- **Hashing**: SHA-256 or SHA-3 for integrity
- **Digital Signatures**: RSA or ECDSA for authentication

## 💡 Learning Points
- Always use strong, industry-standard encryption algorithms
- Generate cryptographically secure random numbers for keys and IVs
- Implement proper key management and rotation policies
- Use authenticated encryption modes (GCM) when possible
- Never reuse IVs or nonces in encryption operations

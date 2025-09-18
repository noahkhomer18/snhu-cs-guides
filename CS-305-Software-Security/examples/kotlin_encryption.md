# CS-305 Kotlin Encryption Examples

## 🎯 Purpose
Demonstrate various encryption and cryptographic techniques in Kotlin including symmetric encryption, asymmetric encryption, and digital signatures.

## 📝 Kotlin Encryption Examples

### Symmetric Encryption (AES)
```kotlin
import javax.crypto.Cipher
import javax.crypto.KeyGenerator
import javax.crypto.SecretKey
import javax.crypto.spec.SecretKeySpec
import javax.crypto.spec.IvParameterSpec
import javax.crypto.spec.GCMParameterSpec
import java.security.SecureRandom
import java.util.Base64

class AESEncryption {
    private val algorithm = "AES"
    private val transformation = "AES/CBC/PKCS5Padding"
    private val gcmTransformation = "AES/GCM/NoPadding"
    private val keySize = 256
    
    // Generate AES key
    fun generateKey(): SecretKey {
        val keyGenerator = KeyGenerator.getInstance(algorithm)
        keyGenerator.init(keySize)
        return keyGenerator.generateKey()
    }
    
    // Generate key from password
    fun generateKeyFromPassword(password: String, salt: ByteArray): SecretKey {
        val spec = javax.crypto.spec.PBEKeySpec(
            password.toCharArray(),
            salt,
            65536, // Iterations
            keySize
        )
        val factory = javax.crypto.SecretKeyFactory.getInstance("PBKDF2WithHmacSHA256")
        val keyBytes = factory.generateSecret(spec).encoded
        return SecretKeySpec(keyBytes, algorithm)
    }
    
    // Encrypt with CBC mode
    fun encryptCBC(data: String, key: SecretKey): EncryptedData {
        val cipher = Cipher.getInstance(transformation)
        val iv = ByteArray(16)
        SecureRandom().nextBytes(iv)
        
        cipher.init(Cipher.ENCRYPT_MODE, key, IvParameterSpec(iv))
        val encryptedBytes = cipher.doFinal(data.toByteArray())
        
        return EncryptedData(
            encryptedData = Base64.getEncoder().encodeToString(encryptedBytes),
            iv = Base64.getEncoder().encodeToString(iv),
            mode = "CBC"
        )
    }
    
    // Decrypt with CBC mode
    fun decryptCBC(encryptedData: EncryptedData, key: SecretKey): String {
        val cipher = Cipher.getInstance(transformation)
        val iv = Base64.getDecoder().decode(encryptedData.iv)
        
        cipher.init(Cipher.DECRYPT_MODE, key, IvParameterSpec(iv))
        val decryptedBytes = cipher.doFinal(Base64.getDecoder().decode(encryptedData.encryptedData))
        
        return String(decryptedBytes)
    }
    
    // Encrypt with GCM mode (authenticated encryption)
    fun encryptGCM(data: String, key: SecretKey): EncryptedData {
        val cipher = Cipher.getInstance(gcmTransformation)
        val iv = ByteArray(12) // GCM recommended IV size
        SecureRandom().nextBytes(iv)
        
        val gcmSpec = GCMParameterSpec(128, iv) // 128-bit authentication tag
        cipher.init(Cipher.ENCRYPT_MODE, key, gcmSpec)
        
        val encryptedBytes = cipher.doFinal(data.toByteArray())
        
        return EncryptedData(
            encryptedData = Base64.getEncoder().encodeToString(encryptedBytes),
            iv = Base64.getEncoder().encodeToString(iv),
            mode = "GCM"
        )
    }
    
    // Decrypt with GCM mode
    fun decryptGCM(encryptedData: EncryptedData, key: SecretKey): String {
        val cipher = Cipher.getInstance(gcmTransformation)
        val iv = Base64.getDecoder().decode(encryptedData.iv)
        
        val gcmSpec = GCMParameterSpec(128, iv)
        cipher.init(Cipher.DECRYPT_MODE, key, gcmSpec)
        
        val decryptedBytes = cipher.doFinal(Base64.getDecoder().decode(encryptedData.encryptedData))
        
        return String(decryptedBytes)
    }
}

data class EncryptedData(
    val encryptedData: String,
    val iv: String,
    val mode: String
)
```

### Asymmetric Encryption (RSA)
```kotlin
import java.security.KeyPair
import java.security.KeyPairGenerator
import java.security.PrivateKey
import java.security.PublicKey
import java.security.spec.PKCS8EncodedKeySpec
import java.security.spec.X509EncodedKeySpec
import java.util.Base64
import javax.crypto.Cipher

class RSAEncryption {
    private val algorithm = "RSA"
    private val transformation = "RSA/ECB/PKCS1Padding"
    private val keySize = 2048
    
    // Generate RSA key pair
    fun generateKeyPair(): KeyPair {
        val keyPairGenerator = KeyPairGenerator.getInstance(algorithm)
        keyPairGenerator.initialize(keySize)
        return keyPairGenerator.generateKeyPair()
    }
    
    // Encrypt with public key
    fun encrypt(data: String, publicKey: PublicKey): String {
        val cipher = Cipher.getInstance(transformation)
        cipher.init(Cipher.ENCRYPT_MODE, publicKey)
        
        val encryptedBytes = cipher.doFinal(data.toByteArray())
        return Base64.getEncoder().encodeToString(encryptedBytes)
    }
    
    // Decrypt with private key
    fun decrypt(encryptedData: String, privateKey: PrivateKey): String {
        val cipher = Cipher.getInstance(transformation)
        cipher.init(Cipher.DECRYPT_MODE, privateKey)
        
        val decryptedBytes = cipher.doFinal(Base64.getDecoder().decode(encryptedData))
        return String(decryptedBytes)
    }
    
    // Encrypt large data by splitting
    fun encryptLargeData(data: String, publicKey: PublicKey): List<String> {
        val maxBlockSize = keySize / 8 - 11 // PKCS1 padding overhead
        val chunks = data.chunked(maxBlockSize)
        
        return chunks.map { chunk ->
            encrypt(chunk, publicKey)
        }
    }
    
    // Decrypt large data
    fun decryptLargeData(encryptedChunks: List<String>, privateKey: PrivateKey): String {
        val decryptedChunks = encryptedChunks.map { chunk ->
            decrypt(chunk, privateKey)
        }
        
        return decryptedChunks.joinToString("")
    }
    
    // Convert key to string
    fun publicKeyToString(publicKey: PublicKey): String {
        return Base64.getEncoder().encodeToString(publicKey.encoded)
    }
    
    fun privateKeyToString(privateKey: PrivateKey): String {
        return Base64.getEncoder().encodeToString(privateKey.encoded)
    }
    
    // Convert string to key
    fun stringToPublicKey(keyString: String): PublicKey {
        val keyBytes = Base64.getDecoder().decode(keyString)
        val keySpec = X509EncodedKeySpec(keyBytes)
        val keyFactory = java.security.KeyFactory.getInstance(algorithm)
        return keyFactory.generatePublic(keySpec)
    }
    
    fun stringToPrivateKey(keyString: String): PrivateKey {
        val keyBytes = Base64.getDecoder().decode(keyString)
        val keySpec = PKCS8EncodedKeySpec(keyBytes)
        val keyFactory = java.security.KeyFactory.getInstance(algorithm)
        return keyFactory.generatePrivate(keySpec)
    }
}
```

### Digital Signatures
```kotlin
import java.security.KeyPair
import java.security.PrivateKey
import java.security.PublicKey
import java.security.Signature
import java.util.Base64

class DigitalSignature {
    private val algorithm = "SHA256withRSA"
    
    // Sign data with private key
    fun sign(data: String, privateKey: PrivateKey): String {
        val signature = Signature.getInstance(algorithm)
        signature.initSign(privateKey)
        signature.update(data.toByteArray())
        
        val signatureBytes = signature.sign()
        return Base64.getEncoder().encodeToString(signatureBytes)
    }
    
    // Verify signature with public key
    fun verify(data: String, signature: String, publicKey: PublicKey): Boolean {
        return try {
            val sig = Signature.getInstance(algorithm)
            sig.initVerify(publicKey)
            sig.update(data.toByteArray())
            
            val signatureBytes = Base64.getDecoder().decode(signature)
            sig.verify(signatureBytes)
        } catch (e: Exception) {
            false
        }
    }
    
    // Sign file content
    fun signFile(fileContent: ByteArray, privateKey: PrivateKey): String {
        val signature = Signature.getInstance(algorithm)
        signature.initSign(privateKey)
        signature.update(fileContent)
        
        val signatureBytes = signature.sign()
        return Base64.getEncoder().encodeToString(signatureBytes)
    }
    
    // Verify file signature
    fun verifyFile(fileContent: ByteArray, signature: String, publicKey: PublicKey): Boolean {
        return try {
            val sig = Signature.getInstance(algorithm)
            sig.initVerify(publicKey)
            sig.update(fileContent)
            
            val signatureBytes = Base64.getDecoder().decode(signature)
            sig.verify(signatureBytes)
        } catch (e: Exception) {
            false
        }
    }
}
```

### Hash Functions
```kotlin
import java.security.MessageDigest
import java.security.SecureRandom
import javax.crypto.Mac
import javax.crypto.spec.SecretKeySpec

class HashFunctions {
    // MD5 (not recommended for security purposes)
    fun md5(input: String): String {
        val digest = MessageDigest.getInstance("MD5")
        val hashBytes = digest.digest(input.toByteArray())
        return hashBytes.joinToString("") { "%02x".format(it) }
    }
    
    // SHA-1 (not recommended for security purposes)
    fun sha1(input: String): String {
        val digest = MessageDigest.getInstance("SHA-1")
        val hashBytes = digest.digest(input.toByteArray())
        return hashBytes.joinToString("") { "%02x".format(it) }
    }
    
    // SHA-256
    fun sha256(input: String): String {
        val digest = MessageDigest.getInstance("SHA-256")
        val hashBytes = digest.digest(input.toByteArray())
        return hashBytes.joinToString("") { "%02x".format(it) }
    }
    
    // SHA-512
    fun sha512(input: String): String {
        val digest = MessageDigest.getInstance("SHA-512")
        val hashBytes = digest.digest(input.toByteArray())
        return hashBytes.joinToString("") { "%02x".format(it) }
    }
    
    // HMAC-SHA256
    fun hmacSha256(data: String, key: String): String {
        val secretKey = SecretKeySpec(key.toByteArray(), "HmacSHA256")
        val mac = Mac.getInstance("HmacSHA256")
        mac.init(secretKey)
        
        val hashBytes = mac.doFinal(data.toByteArray())
        return hashBytes.joinToString("") { "%02x".format(it) }
    }
    
    // HMAC-SHA512
    fun hmacSha512(data: String, key: String): String {
        val secretKey = SecretKeySpec(key.toByteArray(), "HmacSHA512")
        val mac = Mac.getInstance("HmacSHA512")
        mac.init(secretKey)
        
        val hashBytes = mac.doFinal(data.toByteArray())
        return hashBytes.joinToString("") { "%02x".format(it) }
    }
    
    // Generate random salt
    fun generateSalt(length: Int = 16): ByteArray {
        val salt = ByteArray(length)
        SecureRandom().nextBytes(salt)
        return salt
    }
    
    // Hash with salt
    fun hashWithSalt(input: String, salt: ByteArray): String {
        val digest = MessageDigest.getInstance("SHA-256")
        digest.update(salt)
        val hashBytes = digest.digest(input.toByteArray())
        return hashBytes.joinToString("") { "%02x".format(it) }
    }
}
```

### Hybrid Encryption (RSA + AES)
```kotlin
class HybridEncryption {
    private val aesEncryption = AESEncryption()
    private val rsaEncryption = RSAEncryption()
    
    // Encrypt data using hybrid approach
    fun encrypt(data: String, publicKey: PublicKey): HybridEncryptedData {
        // Generate random AES key
        val aesKey = aesEncryption.generateKey()
        
        // Encrypt data with AES
        val encryptedData = aesEncryption.encryptGCM(data, aesKey)
        
        // Encrypt AES key with RSA
        val encryptedKey = rsaEncryption.encrypt(
            rsaEncryption.publicKeyToString(aesKey as java.security.PublicKey),
            publicKey
        )
        
        return HybridEncryptedData(
            encryptedData = encryptedData.encryptedData,
            iv = encryptedData.iv,
            encryptedKey = encryptedKey
        )
    }
    
    // Decrypt data using hybrid approach
    fun decrypt(encryptedData: HybridEncryptedData, privateKey: PrivateKey): String {
        // Decrypt AES key with RSA
        val aesKeyString = rsaEncryption.decrypt(encryptedData.encryptedKey, privateKey)
        val aesKey = rsaEncryption.stringToPublicKey(aesKeyString) as javax.crypto.SecretKey
        
        // Decrypt data with AES
        val aesEncryptedData = EncryptedData(
            encryptedData = encryptedData.encryptedData,
            iv = encryptedData.iv,
            mode = "GCM"
        )
        
        return aesEncryption.decryptGCM(aesEncryptedData, aesKey)
    }
}

data class HybridEncryptedData(
    val encryptedData: String,
    val iv: String,
    val encryptedKey: String
)
```

### Certificate and Key Management
```kotlin
import java.security.KeyStore
import java.security.cert.Certificate
import java.security.cert.CertificateFactory
import java.io.ByteArrayInputStream
import java.util.Base64

class CertificateManager {
    // Load certificate from string
    fun loadCertificateFromString(certString: String): Certificate {
        val certBytes = Base64.getDecoder().decode(certString)
        val certFactory = CertificateFactory.getInstance("X.509")
        return certFactory.generateCertificate(ByteArrayInputStream(certBytes))
    }
    
    // Load certificate from file
    fun loadCertificateFromFile(filePath: String): Certificate {
        val certFactory = CertificateFactory.getInstance("X.509")
        return certFactory.generateCertificate(java.io.FileInputStream(filePath))
    }
    
    // Create keystore
    fun createKeystore(keyPair: KeyPair, certificate: Certificate, password: String): KeyStore {
        val keystore = KeyStore.getInstance("PKCS12")
        keystore.load(null, null)
        
        val certChain = arrayOf(certificate)
        keystore.setKeyEntry("mykey", keyPair.private, password.toCharArray(), certChain)
        
        return keystore
    }
    
    // Save keystore to file
    fun saveKeystore(keystore: KeyStore, filePath: String, password: String) {
        val outputStream = java.io.FileOutputStream(filePath)
        keystore.store(outputStream, password.toCharArray())
        outputStream.close()
    }
    
    // Load keystore from file
    fun loadKeystore(filePath: String, password: String): KeyStore {
        val keystore = KeyStore.getInstance("PKCS12")
        val inputStream = java.io.FileInputStream(filePath)
        keystore.load(inputStream, password.toCharArray())
        inputStream.close()
        return keystore
    }
}
```

### Performance Testing
```kotlin
fun main() {
    // Test AES encryption
    val aesEncryption = AESEncryption()
    val aesKey = aesEncryption.generateKey()
    val data = "This is sensitive data that needs to be encrypted"
    
    println("AES Encryption Test:")
    val encryptedCBC = aesEncryption.encryptCBC(data, aesKey)
    val decryptedCBC = aesEncryption.decryptCBC(encryptedCBC, aesKey)
    println("Original: $data")
    println("Encrypted (CBC): ${encryptedCBC.encryptedData}")
    println("Decrypted (CBC): $decryptedCBC")
    
    val encryptedGCM = aesEncryption.encryptGCM(data, aesKey)
    val decryptedGCM = aesEncryption.decryptGCM(encryptedGCM, aesKey)
    println("Encrypted (GCM): ${encryptedGCM.encryptedData}")
    println("Decrypted (GCM): $decryptedGCM")
    
    // Test RSA encryption
    val rsaEncryption = RSAEncryption()
    val keyPair = rsaEncryption.generateKeyPair()
    
    println("\nRSA Encryption Test:")
    val rsaEncrypted = rsaEncryption.encrypt(data, keyPair.public)
    val rsaDecrypted = rsaEncryption.decrypt(rsaEncrypted, keyPair.private)
    println("Original: $data")
    println("Encrypted: $rsaEncrypted")
    println("Decrypted: $rsaDecrypted")
    
    // Test digital signatures
    val digitalSignature = DigitalSignature()
    val signature = digitalSignature.sign(data, keyPair.private)
    val isValid = digitalSignature.verify(data, signature, keyPair.public)
    
    println("\nDigital Signature Test:")
    println("Data: $data")
    println("Signature: $signature")
    println("Valid: $isValid")
    
    // Test hash functions
    val hashFunctions = HashFunctions()
    println("\nHash Functions Test:")
    println("MD5: ${hashFunctions.md5(data)}")
    println("SHA-1: ${hashFunctions.sha1(data)}")
    println("SHA-256: ${hashFunctions.sha256(data)}")
    println("SHA-512: ${hashFunctions.sha512(data)}")
    println("HMAC-SHA256: ${hashFunctions.hmacSha256(data, "secret-key")}")
    
    // Test hybrid encryption
    val hybridEncryption = HybridEncryption()
    val hybridEncrypted = hybridEncryption.encrypt(data, keyPair.public)
    val hybridDecrypted = hybridEncryption.decrypt(hybridEncrypted, keyPair.private)
    
    println("\nHybrid Encryption Test:")
    println("Original: $data")
    println("Encrypted: ${hybridEncrypted.encryptedData}")
    println("Decrypted: $hybridDecrypted")
    
    // Performance comparison
    val iterations = 1000
    val testData = "Performance test data for encryption algorithms"
    
    println("\nPerformance Test ($iterations iterations):")
    
    // AES performance
    val aesStart = System.nanoTime()
    repeat(iterations) {
        val encrypted = aesEncryption.encryptGCM(testData, aesKey)
        aesEncryption.decryptGCM(encrypted, aesKey)
    }
    val aesTime = (System.nanoTime() - aesStart) / 1_000_000
    println("AES GCM: ${aesTime}ms")
    
    // RSA performance
    val rsaStart = System.nanoTime()
    repeat(iterations) {
        val encrypted = rsaEncryption.encrypt(testData, keyPair.public)
        rsaEncryption.decrypt(encrypted, keyPair.private)
    }
    val rsaTime = (System.nanoTime() - rsaStart) / 1_000_000
    println("RSA: ${rsaTime}ms")
    
    // Hash performance
    val hashStart = System.nanoTime()
    repeat(iterations) {
        hashFunctions.sha256(testData)
    }
    val hashTime = (System.nanoTime() - hashStart) / 1_000_000
    println("SHA-256: ${hashTime}ms")
}
```

## 🔍 Encryption Algorithm Comparison

| Algorithm | Type | Key Size | Speed | Security | Use Case |
|-----------|------|----------|-------|----------|----------|
| AES-256 | Symmetric | 256 bits | Fast | High | Data encryption |
| RSA-2048 | Asymmetric | 2048 bits | Slow | High | Key exchange, signatures |
| SHA-256 | Hash | N/A | Fast | High | Data integrity |
| HMAC-SHA256 | MAC | Variable | Fast | High | Message authentication |
| PBKDF2 | Key Derivation | Variable | Slow | High | Password hashing |

## 💡 Learning Points
- **Symmetric encryption** is fast but requires secure key exchange
- **Asymmetric encryption** is slow but enables secure key exchange
- **Hybrid encryption** combines benefits of both approaches
- **Digital signatures** provide authentication and non-repudiation
- **Hash functions** ensure data integrity
- **HMAC** provides message authentication
- **GCM mode** provides authenticated encryption
- **Key management** is crucial for security
- **Performance** varies significantly between algorithms
- **Security** depends on proper implementation and key management

# CS-305 Kotlin Software Security Examples

## 🎯 Purpose
Demonstrate secure coding practices in Kotlin including input validation, encryption, authentication, and common security vulnerabilities prevention.

## 📝 Kotlin Security Examples

### Input Validation and Sanitization
```kotlin
class InputValidator {
    // Email validation
    fun isValidEmail(email: String): Boolean {
        val emailRegex = "^[A-Za-z0-9+_.-]+@([A-Za-z0-9.-]+\\.[A-Za-z]{2,})$".toRegex()
        return emailRegex.matches(email)
    }
    
    // Phone number validation
    fun isValidPhoneNumber(phone: String): Boolean {
        val phoneRegex = "^\\+?[1-9]\\d{1,14}$".toRegex()
        return phoneRegex.matches(phone.replace("\\s".toRegex(), ""))
    }
    
    // SQL injection prevention
    fun sanitizeForSQL(input: String): String {
        return input
            .replace("'", "''")
            .replace(";", "")
            .replace("--", "")
            .replace("/*", "")
            .replace("*/", "")
            .replace("xp_", "")
            .replace("sp_", "")
    }
    
    // XSS prevention
    fun sanitizeForXSS(input: String): String {
        return input
            .replace("<", "&lt;")
            .replace(">", "&gt;")
            .replace("\"", "&quot;")
            .replace("'", "&#x27;")
            .replace("&", "&amp;")
    }
    
    // Path traversal prevention
    fun sanitizeFilePath(input: String): String {
        return input
            .replace("..", "")
            .replace("/", "")
            .replace("\\", "")
            .replace(":", "")
    }
    
    // Validate file upload
    fun isValidFileUpload(fileName: String, allowedExtensions: Set<String>): Boolean {
        val extension = fileName.substringAfterLast('.', "").lowercase()
        return extension in allowedExtensions && !fileName.contains("..")
    }
    
    // Validate password strength
    fun validatePassword(password: String): PasswordValidationResult {
        val issues = mutableListOf<String>()
        
        if (password.length < 8) {
            issues.add("Password must be at least 8 characters long")
        }
        
        if (!password.any { it.isUpperCase() }) {
            issues.add("Password must contain at least one uppercase letter")
        }
        
        if (!password.any { it.isLowerCase() }) {
            issues.add("Password must contain at least one lowercase letter")
        }
        
        if (!password.any { it.isDigit() }) {
            issues.add("Password must contain at least one digit")
        }
        
        if (!password.any { "!@#$%^&*()_+-=[]{}|;:,.<>?".contains(it) }) {
            issues.add("Password must contain at least one special character")
        }
        
        return PasswordValidationResult(issues.isEmpty(), issues)
    }
}

data class PasswordValidationResult(
    val isValid: Boolean,
    val issues: List<String>
)
```

### Secure Password Hashing
```kotlin
import java.security.MessageDigest
import java.security.SecureRandom
import javax.crypto.spec.PBEKeySpec
import javax.crypto.SecretKeyFactory
import java.util.Base64

class PasswordSecurity {
    private val random = SecureRandom()
    
    // Generate secure salt
    fun generateSalt(): ByteArray {
        val salt = ByteArray(16)
        random.nextBytes(salt)
        return salt
    }
    
    // Hash password with PBKDF2
    fun hashPassword(password: String, salt: ByteArray): String {
        val spec = PBEKeySpec(
            password.toCharArray(),
            salt,
            100000, // Iterations
            256 // Key length
        )
        
        val factory = SecretKeyFactory.getInstance("PBKDF2WithHmacSHA256")
        val hash = factory.generateSecret(spec).encoded
        
        return Base64.getEncoder().encodeToString(salt + hash)
    }
    
    // Verify password
    fun verifyPassword(password: String, hashedPassword: String): Boolean {
        val decoded = Base64.getDecoder().decode(hashedPassword)
        val salt = decoded.sliceArray(0..15)
        val hash = decoded.sliceArray(16 until decoded.size)
        
        val spec = PBEKeySpec(
            password.toCharArray(),
            salt,
            100000,
            256
        )
        
        val factory = SecretKeyFactory.getInstance("PBKDF2WithHmacSHA256")
        val testHash = factory.generateSecret(spec).encoded
        
        return hash.contentEquals(testHash)
    }
    
    // Generate secure random password
    fun generateSecurePassword(length: Int = 16): String {
        val chars = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789!@#$%^&*"
        val password = StringBuilder(length)
        
        repeat(length) {
            password.append(chars[random.nextInt(chars.length)])
        }
        
        return password.toString()
    }
}
```

### Encryption and Decryption
```kotlin
import javax.crypto.Cipher
import javax.crypto.KeyGenerator
import javax.crypto.SecretKey
import javax.crypto.spec.SecretKeySpec
import javax.crypto.spec.IvParameterSpec
import java.security.SecureRandom
import java.util.Base64

class EncryptionService {
    private val algorithm = "AES"
    private val transformation = "AES/CBC/PKCS5Padding"
    private val keySize = 256
    
    // Generate AES key
    fun generateKey(): SecretKey {
        val keyGenerator = KeyGenerator.getInstance(algorithm)
        keyGenerator.init(keySize)
        return keyGenerator.generateKey()
    }
    
    // Encrypt data
    fun encrypt(data: String, key: SecretKey): EncryptedData {
        val cipher = Cipher.getInstance(transformation)
        val iv = ByteArray(16)
        SecureRandom().nextBytes(iv)
        
        cipher.init(Cipher.ENCRYPT_MODE, key, IvParameterSpec(iv))
        val encryptedBytes = cipher.doFinal(data.toByteArray())
        
        return EncryptedData(
            encryptedData = Base64.getEncoder().encodeToString(encryptedBytes),
            iv = Base64.getEncoder().encodeToString(iv)
        )
    }
    
    // Decrypt data
    fun decrypt(encryptedData: EncryptedData, key: SecretKey): String {
        val cipher = Cipher.getInstance(transformation)
        val iv = Base64.getDecoder().decode(encryptedData.iv)
        
        cipher.init(Cipher.DECRYPT_MODE, key, IvParameterSpec(iv))
        val decryptedBytes = cipher.doFinal(Base64.getDecoder().decode(encryptedData.encryptedData))
        
        return String(decryptedBytes)
    }
    
    // Encrypt with password
    fun encryptWithPassword(data: String, password: String): EncryptedData {
        val key = deriveKeyFromPassword(password)
        return encrypt(data, key)
    }
    
    // Decrypt with password
    fun decryptWithPassword(encryptedData: EncryptedData, password: String): String {
        val key = deriveKeyFromPassword(password)
        return decrypt(encryptedData, key)
    }
    
    private fun deriveKeyFromPassword(password: String): SecretKey {
        val salt = "SecureSalt123".toByteArray() // In production, use random salt
        val spec = PBEKeySpec(password.toCharArray(), salt, 10000, 256)
        val factory = SecretKeyFactory.getInstance("PBKDF2WithHmacSHA256")
        val keyBytes = factory.generateSecret(spec).encoded
        return SecretKeySpec(keyBytes, algorithm)
    }
}

data class EncryptedData(
    val encryptedData: String,
    val iv: String
)
```

### JWT Token Security
```kotlin
import io.jsonwebtoken.Jwts
import io.jsonwebtoken.SignatureAlgorithm
import io.jsonwebtoken.security.Keys
import java.util.Date
import java.util.concurrent.TimeUnit
import javax.crypto.SecretKey

class JWTService {
    private val secretKey: SecretKey = Keys.secretKeyFor(SignatureAlgorithm.HS256)
    private val expirationTime = TimeUnit.HOURS.toMillis(24) // 24 hours
    
    // Generate JWT token
    fun generateToken(username: String, roles: List<String>): String {
        val now = Date()
        val expiration = Date(now.time + expirationTime)
        
        return Jwts.builder()
            .setSubject(username)
            .claim("roles", roles)
            .setIssuedAt(now)
            .setExpiration(expiration)
            .signWith(secretKey)
            .compact()
    }
    
    // Validate JWT token
    fun validateToken(token: String): Boolean {
        return try {
            Jwts.parserBuilder()
                .setSigningKey(secretKey)
                .build()
                .parseClaimsJws(token)
            true
        } catch (e: Exception) {
            false
        }
    }
    
    // Extract username from token
    fun getUsernameFromToken(token: String): String? {
        return try {
            val claims = Jwts.parserBuilder()
                .setSigningKey(secretKey)
                .build()
                .parseClaimsJws(token)
                .body
            
            claims.subject
        } catch (e: Exception) {
            null
        }
    }
    
    // Extract roles from token
    fun getRolesFromToken(token: String): List<String>? {
        return try {
            val claims = Jwts.parserBuilder()
                .setSigningKey(secretKey)
                .build()
                .parseClaimsJws(token)
                .body
            
            @Suppress("UNCHECKED_CAST")
            claims["roles"] as? List<String>
        } catch (e: Exception) {
            null
        }
    }
    
    // Check if token is expired
    fun isTokenExpired(token: String): Boolean {
        return try {
            val claims = Jwts.parserBuilder()
                .setSigningKey(secretKey)
                .build()
                .parseClaimsJws(token)
                .body
            
            claims.expiration.before(Date())
        } catch (e: Exception) {
            true
        }
    }
}
```

### Rate Limiting
```kotlin
import java.util.concurrent.ConcurrentHashMap
import java.util.concurrent.atomic.AtomicInteger
import kotlin.math.max

class RateLimiter {
    private val requests = ConcurrentHashMap<String, RequestInfo>()
    private val maxRequests: Int
    private val windowSizeMs: Long
    
    constructor(maxRequests: Int, windowSizeSeconds: Int) {
        this.maxRequests = maxRequests
        this.windowSizeMs = windowSizeSeconds * 1000L
    }
    
    // Check if request is allowed
    fun isAllowed(clientId: String): Boolean {
        val now = System.currentTimeMillis()
        val requestInfo = requests.computeIfAbsent(clientId) { RequestInfo() }
        
        // Clean old requests
        requestInfo.cleanOldRequests(now, windowSizeMs)
        
        // Check if under limit
        if (requestInfo.requestCount.get() < maxRequests) {
            requestInfo.addRequest(now)
            return true
        }
        
        return false
    }
    
    // Get remaining requests for client
    fun getRemainingRequests(clientId: String): Int {
        val now = System.currentTimeMillis()
        val requestInfo = requests[clientId] ?: return maxRequests
        
        requestInfo.cleanOldRequests(now, windowSizeMs)
        return max(0, maxRequests - requestInfo.requestCount.get())
    }
    
    // Reset rate limit for client
    fun reset(clientId: String) {
        requests.remove(clientId)
    }
    
    private class RequestInfo {
        val requestTimes = mutableListOf<Long>()
        val requestCount = AtomicInteger(0)
        
        fun addRequest(timestamp: Long) {
            requestTimes.add(timestamp)
            requestCount.incrementAndGet()
        }
        
        fun cleanOldRequests(now: Long, windowSizeMs: Long) {
            val cutoff = now - windowSizeMs
            requestTimes.removeAll { it < cutoff }
            requestCount.set(requestTimes.size)
        }
    }
}
```

### SQL Injection Prevention
```kotlin
import java.sql.Connection
import java.sql.PreparedStatement
import java.sql.ResultSet

class SecureDatabaseService {
    private lateinit var connection: Connection
    
    // Secure user authentication
    fun authenticateUser(username: String, password: String): User? {
        val query = "SELECT id, username, email, password_hash FROM users WHERE username = ? AND is_active = true"
        
        return try {
            val statement = connection.prepareStatement(query)
            statement.setString(1, username)
            
            val resultSet = statement.executeQuery()
            
            if (resultSet.next()) {
                val storedHash = resultSet.getString("password_hash")
                val passwordSecurity = PasswordSecurity()
                
                if (passwordSecurity.verifyPassword(password, storedHash)) {
                    User(
                        id = resultSet.getInt("id"),
                        username = resultSet.getString("username"),
                        email = resultSet.getString("email")
                    )
                } else {
                    null
                }
            } else {
                null
            }
        } catch (e: Exception) {
            // Log error securely
            null
        }
    }
    
    // Secure user search
    fun searchUsers(searchTerm: String, limit: Int = 10): List<User> {
        val query = "SELECT id, username, email FROM users WHERE username LIKE ? AND is_active = true LIMIT ?"
        val users = mutableListOf<User>()
        
        return try {
            val statement = connection.prepareStatement(query)
            statement.setString(1, "%$searchTerm%")
            statement.setInt(2, limit)
            
            val resultSet = statement.executeQuery()
            
            while (resultSet.next()) {
                users.add(
                    User(
                        id = resultSet.getInt("id"),
                        username = resultSet.getString("username"),
                        email = resultSet.getString("email")
                    )
                )
            }
            
            users
        } catch (e: Exception) {
            // Log error securely
            emptyList()
        }
    }
    
    // Secure user creation
    fun createUser(username: String, email: String, password: String): Boolean {
        val query = "INSERT INTO users (username, email, password_hash, created_at, is_active) VALUES (?, ?, ?, NOW(), true)"
        
        return try {
            val passwordSecurity = PasswordSecurity()
            val salt = passwordSecurity.generateSalt()
            val passwordHash = passwordSecurity.hashPassword(password, salt)
            
            val statement = connection.prepareStatement(query)
            statement.setString(1, username)
            statement.setString(2, email)
            statement.setString(3, passwordHash)
            
            statement.executeUpdate() > 0
        } catch (e: Exception) {
            // Log error securely
            false
        }
    }
}

data class User(
    val id: Int,
    val username: String,
    val email: String
)
```

### CSRF Protection
```kotlin
import java.security.SecureRandom
import java.util.concurrent.ConcurrentHashMap

class CSRFProtection {
    private val tokens = ConcurrentHashMap<String, CSRFToken>()
    private val random = SecureRandom()
    private val tokenExpirationMs = 30 * 60 * 1000L // 30 minutes
    
    // Generate CSRF token
    fun generateToken(sessionId: String): String {
        val tokenBytes = ByteArray(32)
        random.nextBytes(tokenBytes)
        val token = tokenBytes.joinToString("") { "%02x".format(it) }
        
        tokens[sessionId] = CSRFToken(
            token = token,
            createdAt = System.currentTimeMillis()
        )
        
        return token
    }
    
    // Validate CSRF token
    fun validateToken(sessionId: String, token: String): Boolean {
        val storedToken = tokens[sessionId] ?: return false
        
        // Check if token is expired
        if (System.currentTimeMillis() - storedToken.createdAt > tokenExpirationMs) {
            tokens.remove(sessionId)
            return false
        }
        
        return storedToken.token == token
    }
    
    // Remove token
    fun removeToken(sessionId: String) {
        tokens.remove(sessionId)
    }
    
    // Clean expired tokens
    fun cleanExpiredTokens() {
        val now = System.currentTimeMillis()
        tokens.entries.removeIf { (_, token) ->
            now - token.createdAt > tokenExpirationMs
        }
    }
    
    private data class CSRFToken(
        val token: String,
        val createdAt: Long
    )
}
```

### Secure File Handling
```kotlin
import java.io.File
import java.nio.file.Files
import java.nio.file.Path
import java.nio.file.Paths
import java.security.MessageDigest

class SecureFileHandler {
    private val allowedExtensions = setOf("jpg", "jpeg", "png", "gif", "pdf", "txt", "doc", "docx")
    private val maxFileSize = 10 * 1024 * 1024L // 10MB
    private val uploadDirectory = Paths.get("uploads")
    
    init {
        // Create upload directory if it doesn't exist
        Files.createDirectories(uploadDirectory)
    }
    
    // Secure file upload
    fun uploadFile(fileName: String, fileContent: ByteArray, userId: Int): UploadResult {
        // Validate file size
        if (fileContent.size > maxFileSize) {
            return UploadResult(false, "File size exceeds maximum allowed size")
        }
        
        // Validate file extension
        val extension = fileName.substringAfterLast('.', "").lowercase()
        if (extension !in allowedExtensions) {
            return UploadResult(false, "File type not allowed")
        }
        
        // Sanitize filename
        val sanitizedFileName = sanitizeFileName(fileName)
        
        // Generate unique filename
        val uniqueFileName = generateUniqueFileName(sanitizedFileName, userId)
        val filePath = uploadDirectory.resolve(uniqueFileName)
        
        return try {
            // Write file
            Files.write(filePath, fileContent)
            
            // Verify file integrity
            val hash = calculateFileHash(fileContent)
            
            UploadResult(true, "File uploaded successfully", uniqueFileName, hash)
        } catch (e: Exception) {
            UploadResult(false, "Failed to upload file: ${e.message}")
        }
    }
    
    // Secure file download
    fun downloadFile(fileName: String, userId: Int): DownloadResult? {
        // Validate filename
        if (!isValidFileName(fileName)) {
            return null
        }
        
        val filePath = uploadDirectory.resolve(fileName)
        
        return try {
            if (Files.exists(filePath) && Files.isRegularFile(filePath)) {
                val content = Files.readAllBytes(filePath)
                val mimeType = Files.probeContentType(filePath) ?: "application/octet-stream"
                
                DownloadResult(content, mimeType, fileName)
            } else {
                null
            }
        } catch (e: Exception) {
            null
        }
    }
    
    private fun sanitizeFileName(fileName: String): String {
        return fileName
            .replace("[^a-zA-Z0-9._-]".toRegex(), "_")
            .replace("..", "_")
    }
    
    private fun generateUniqueFileName(originalName: String, userId: Int): String {
        val timestamp = System.currentTimeMillis()
        val extension = originalName.substringAfterLast('.', "")
        return "${userId}_${timestamp}.${extension}"
    }
    
    private fun isValidFileName(fileName: String): Boolean {
        return fileName.matches("^[a-zA-Z0-9._-]+\$".toRegex()) && !fileName.contains("..")
    }
    
    private fun calculateFileHash(content: ByteArray): String {
        val digest = MessageDigest.getInstance("SHA-256")
        val hashBytes = digest.digest(content)
        return hashBytes.joinToString("") { "%02x".format(it) }
    }
}

data class UploadResult(
    val success: Boolean,
    val message: String,
    val fileName: String? = null,
    val fileHash: String? = null
)

data class DownloadResult(
    val content: ByteArray,
    val mimeType: String,
    val fileName: String
) {
    override fun equals(other: Any?): Boolean {
        if (this === other) return true
        if (javaClass != other?.javaClass) return false
        
        other as DownloadResult
        
        if (!content.contentEquals(other.content)) return false
        if (mimeType != other.mimeType) return false
        if (fileName != other.fileName) return false
        
        return true
    }
    
    override fun hashCode(): Int {
        var result = content.contentHashCode()
        result = 31 * result + mimeType.hashCode()
        result = 31 * result + fileName.hashCode()
        return result
    }
}
```

### Performance Testing
```kotlin
fun main() {
    // Test input validation
    val validator = InputValidator()
    println("Email validation:")
    println("test@example.com: ${validator.isValidEmail("test@example.com")}")
    println("invalid-email: ${validator.isValidEmail("invalid-email")}")
    
    val passwordResult = validator.validatePassword("MySecure123!")
    println("Password validation: ${passwordResult.isValid}")
    if (!passwordResult.isValid) {
        println("Issues: ${passwordResult.issues}")
    }
    
    // Test password security
    val passwordSecurity = PasswordSecurity()
    val password = "MySecurePassword123!"
    val salt = passwordSecurity.generateSalt()
    val hashedPassword = passwordSecurity.hashPassword(password, salt)
    
    println("\nPassword hashing:")
    println("Original: $password")
    println("Hashed: $hashedPassword")
    println("Verification: ${passwordSecurity.verifyPassword(password, hashedPassword)}")
    
    // Test encryption
    val encryptionService = EncryptionService()
    val key = encryptionService.generateKey()
    val data = "Sensitive data to encrypt"
    val encrypted = encryptionService.encrypt(data, key)
    val decrypted = encryptionService.decrypt(encrypted, key)
    
    println("\nEncryption:")
    println("Original: $data")
    println("Encrypted: ${encrypted.encryptedData}")
    println("Decrypted: $decrypted")
    
    // Test JWT
    val jwtService = JWTService()
    val token = jwtService.generateToken("john_doe", listOf("USER", "ADMIN"))
    println("\nJWT Token:")
    println("Token: $token")
    println("Valid: ${jwtService.validateToken(token)}")
    println("Username: ${jwtService.getUsernameFromToken(token)}")
    println("Roles: ${jwtService.getRolesFromToken(token)}")
    
    // Test rate limiting
    val rateLimiter = RateLimiter(5, 60) // 5 requests per minute
    println("\nRate Limiting:")
    repeat(7) { i ->
        val allowed = rateLimiter.isAllowed("client1")
        println("Request ${i + 1}: $allowed")
    }
    
    // Test CSRF protection
    val csrfProtection = CSRFProtection()
    val sessionId = "session123"
    val csrfToken = csrfProtection.generateToken(sessionId)
    println("\nCSRF Protection:")
    println("Generated token: $csrfToken")
    println("Valid token: ${csrfProtection.validateToken(sessionId, csrfToken)}")
    println("Invalid token: ${csrfProtection.validateToken(sessionId, "invalid")}")
}
```

## 🔍 Security Best Practices

### Input Validation
- **Validate all inputs** at the boundary
- **Use whitelist validation** when possible
- **Sanitize data** before processing
- **Implement length limits** to prevent buffer overflows

### Authentication & Authorization
- **Use strong password policies**
- **Implement proper session management**
- **Use secure password hashing** (PBKDF2, bcrypt, Argon2)
- **Implement multi-factor authentication**

### Data Protection
- **Encrypt sensitive data** at rest and in transit
- **Use secure random number generators**
- **Implement proper key management**
- **Use HTTPS for all communications**

### Error Handling
- **Don't expose sensitive information** in error messages
- **Log security events** for monitoring
- **Implement proper exception handling**
- **Use generic error messages** for users

## 💡 Learning Points
- **Input validation** is the first line of defense
- **Password hashing** should use strong algorithms with salts
- **Encryption** protects data confidentiality
- **JWT tokens** provide stateless authentication
- **Rate limiting** prevents abuse and DoS attacks
- **CSRF protection** prevents cross-site request forgery
- **Secure file handling** prevents path traversal attacks
- **Defense in depth** requires multiple security layers
- **Security by design** should be built into applications from the start

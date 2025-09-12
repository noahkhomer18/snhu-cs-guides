# CS-305 Authentication & Security Implementation

## 🎯 Purpose
Demonstrate secure authentication, password hashing, and session management.

## 📝 Security Examples

### Secure Password Hashing
```java
import java.security.SecureRandom;
import java.security.spec.KeySpec;
import javax.crypto.spec.PBEKeySpec;
import javax.crypto.SecretKeyFactory;
import java.util.Base64;

public class PasswordSecurity {
    private static final String ALGORITHM = "PBKDF2WithHmacSHA256";
    private static final int ITERATIONS = 100000;
    private static final int KEY_LENGTH = 256;
    private static final int SALT_LENGTH = 32;
    
    public static String hashPassword(String password) {
        try {
            SecureRandom random = new SecureRandom();
            byte[] salt = new byte[SALT_LENGTH];
            random.nextBytes(salt);
            
            KeySpec spec = new PBEKeySpec(password.toCharArray(), salt, ITERATIONS, KEY_LENGTH);
            SecretKeyFactory factory = SecretKeyFactory.getInstance(ALGORITHM);
            byte[] hash = factory.generateSecret(spec).getEncoded();
            
            // Combine salt and hash
            byte[] combined = new byte[salt.length + hash.length];
            System.arraycopy(salt, 0, combined, 0, salt.length);
            System.arraycopy(hash, 0, combined, salt.length, hash.length);
            
            return Base64.getEncoder().encodeToString(combined);
        } catch (Exception e) {
            throw new RuntimeException("Password hashing failed", e);
        }
    }
    
    public static boolean verifyPassword(String password, String hashedPassword) {
        try {
            byte[] combined = Base64.getDecoder().decode(hashedPassword);
            byte[] salt = new byte[SALT_LENGTH];
            System.arraycopy(combined, 0, salt, 0, SALT_LENGTH);
            
            KeySpec spec = new PBEKeySpec(password.toCharArray(), salt, ITERATIONS, KEY_LENGTH);
            SecretKeyFactory factory = SecretKeyFactory.getInstance(ALGORITHM);
            byte[] hash = factory.generateSecret(spec).getEncoded();
            
            // Compare hashes
            for (int i = 0; i < hash.length; i++) {
                if (hash[i] != combined[SALT_LENGTH + i]) {
                    return false;
                }
            }
            return true;
        } catch (Exception e) {
            return false;
        }
    }
}
```

### JWT Token Security
```java
import io.jsonwebtoken.*;
import io.jsonwebtoken.security.Keys;
import java.security.Key;
import java.util.Date;

public class JwtSecurity {
    private static final Key SECRET_KEY = Keys.secretKeyFor(SignatureAlgorithm.HS256);
    private static final long EXPIRATION_TIME = 24 * 60 * 60 * 1000; // 24 hours
    
    public static String generateToken(String username, String role) {
        Date now = new Date();
        Date expiryDate = new Date(now.getTime() + EXPIRATION_TIME);
        
        return Jwts.builder()
            .setSubject(username)
            .claim("role", role)
            .setIssuedAt(now)
            .setExpiration(expiryDate)
            .signWith(SECRET_KEY)
            .compact();
    }
    
    public static boolean validateToken(String token) {
        try {
            Jwts.parserBuilder()
                .setSigningKey(SECRET_KEY)
                .build()
                .parseClaimsJws(token);
            return true;
        } catch (JwtException | IllegalArgumentException e) {
            return false;
        }
    }
    
    public static String getUsernameFromToken(String token) {
        Claims claims = Jwts.parserBuilder()
            .setSigningKey(SECRET_KEY)
            .build()
            .parseClaimsJws(token)
            .getBody();
        return claims.getSubject();
    }
}
```

### Input Validation & Sanitization
```java
import java.util.regex.Pattern;
import org.apache.commons.text.StringEscapeUtils;

public class InputValidation {
    private static final Pattern EMAIL_PATTERN = 
        Pattern.compile("^[A-Za-z0-9+_.-]+@([A-Za-z0-9.-]+\\.[A-Za-z]{2,})$");
    private static final Pattern SQL_INJECTION_PATTERN = 
        Pattern.compile(".*('|(\\-\\-)|(;)|(\\|)|(\\*)|(%)|(\\+)|(\\=)|(\\<)|(\\>)|(\\[)|(\\])).*");
    
    public static boolean isValidEmail(String email) {
        if (email == null || email.trim().isEmpty()) {
            return false;
        }
        return EMAIL_PATTERN.matcher(email).matches();
    }
    
    public static String sanitizeInput(String input) {
        if (input == null) {
            return null;
        }
        // Remove potential SQL injection patterns
        if (SQL_INJECTION_PATTERN.matcher(input).matches()) {
            throw new IllegalArgumentException("Invalid input detected");
        }
        // HTML escape to prevent XSS
        return StringEscapeUtils.escapeHtml4(input.trim());
    }
    
    public static boolean isValidPassword(String password) {
        if (password == null || password.length() < 8) {
            return false;
        }
        // Check for at least one uppercase, lowercase, digit, and special character
        return password.matches("^(?=.*[a-z])(?=.*[A-Z])(?=.*\\d)(?=.*[@$!%*?&])[A-Za-z\\d@$!%*?&]{8,}$");
    }
}
```

## 🔍 Security Best Practices

### Common Vulnerabilities
- **SQL Injection**: Use parameterized queries
- **XSS**: Sanitize user input and escape output
- **CSRF**: Use CSRF tokens
- **Session Hijacking**: Use secure cookies and HTTPS

### Authentication Security
- **Strong Passwords**: Enforce complexity requirements
- **Password Hashing**: Use PBKDF2, bcrypt, or Argon2
- **Rate Limiting**: Prevent brute force attacks
- **Account Lockout**: Lock accounts after failed attempts

## 💡 Learning Points
- Always hash passwords with salt and high iteration counts
- Validate and sanitize all user inputs
- Use secure session management
- Implement proper error handling without information leakage
- Regular security audits and penetration testing

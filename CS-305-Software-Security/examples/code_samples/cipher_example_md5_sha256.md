# Cipher Examples: MD5 vs SHA-256

## MD5 Example (Deprecated - Use for Learning Only)
```java
import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;

public class MD5Example {
    public static String hashMD5(String input) throws NoSuchAlgorithmException {
        MessageDigest md = MessageDigest.getInstance("MD5");
        byte[] hashBytes = md.digest(input.getBytes());
        StringBuilder sb = new StringBuilder();
        for (byte b : hashBytes) {
            sb.append(String.format("%02x", b));
        }
        return sb.toString();
    }
}
```

## SHA-256 Example (Recommended)
```java
import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;

public class SHA256Example {
    public static String hashSHA256(String input) throws NoSuchAlgorithmException {
        MessageDigest md = MessageDigest.getInstance("SHA-256");
        byte[] hashBytes = md.digest(input.getBytes());
        StringBuilder sb = new StringBuilder();
        for (byte b : hashBytes) {
            sb.append(String.format("%02x", b));
        }
        return sb.toString();
    }
}
```

## Security Notes
- **MD5**: Vulnerable to collision attacks, not recommended for security
- **SHA-256**: Cryptographically secure, recommended for passwords and data integrity
- Always use salt for password hashing
- Consider bcrypt or Argon2 for password storage

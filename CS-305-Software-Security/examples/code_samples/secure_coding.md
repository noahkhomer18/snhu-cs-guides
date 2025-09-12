# CS-305 Secure Coding Practices

## 🎯 Purpose
Demonstrate secure coding practices and vulnerability prevention.

## 📝 Secure Coding Examples

### SQL Injection Prevention
```java
import java.sql.*;
import java.util.List;

public class SecureDatabaseAccess {
    private Connection connection;
    
    // VULNERABLE: SQL Injection
    public User getUserByNameVulnerable(String name) throws SQLException {
        String query = "SELECT * FROM users WHERE name = '" + name + "'";
        Statement stmt = connection.createStatement();
        ResultSet rs = stmt.executeQuery(query);
        // This is vulnerable to SQL injection!
        return mapResultSetToUser(rs);
    }
    
    // SECURE: Parameterized Query
    public User getUserByNameSecure(String name) throws SQLException {
        String query = "SELECT * FROM users WHERE name = ?";
        PreparedStatement stmt = connection.prepareStatement(query);
        stmt.setString(1, name);
        ResultSet rs = stmt.executeQuery();
        return mapResultSetToUser(rs);
    }
    
    // SECURE: Batch Operations
    public void updateUsersSecure(List<User> users) throws SQLException {
        String query = "UPDATE users SET email = ?, status = ? WHERE id = ?";
        PreparedStatement stmt = connection.prepareStatement(query);
        
        for (User user : users) {
            stmt.setString(1, user.getEmail());
            stmt.setString(2, user.getStatus());
            stmt.setLong(3, user.getId());
            stmt.addBatch();
        }
        
        stmt.executeBatch();
    }
}
```

### XSS Prevention
```java
import org.apache.commons.text.StringEscapeUtils;
import org.owasp.encoder.Encode;

public class XSSPrevention {
    
    // VULNERABLE: Direct output without escaping
    public String displayUserInputVulnerable(String userInput) {
        return "<div>" + userInput + "</div>"; // XSS vulnerability!
    }
    
    // SECURE: HTML escaping
    public String displayUserInputSecure(String userInput) {
        String escaped = StringEscapeUtils.escapeHtml4(userInput);
        return "<div>" + escaped + "</div>";
    }
    
    // SECURE: Using OWASP Encoder
    public String displayUserInputOWASP(String userInput) {
        String encoded = Encode.forHtml(userInput);
        return "<div>" + encoded + "</div>";
    }
    
    // SECURE: Context-specific encoding
    public String displayInJavaScript(String userInput) {
        String encoded = Encode.forJavaScript(userInput);
        return "var userData = '" + encoded + "';";
    }
    
    // SECURE: URL encoding
    public String createSecureURL(String baseURL, String parameter) {
        String encodedParam = Encode.forUriComponent(parameter);
        return baseURL + "?param=" + encodedParam;
    }
}
```

### CSRF Protection
```java
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;
import java.security.SecureRandom;
import java.util.Base64;

public class CSRFProtection {
    private static final String CSRF_TOKEN_NAME = "csrfToken";
    private static final SecureRandom secureRandom = new SecureRandom();
    
    public static String generateCSRFToken() {
        byte[] tokenBytes = new byte[32];
        secureRandom.nextBytes(tokenBytes);
        return Base64.getUrlEncoder().withoutPadding().encodeToString(tokenBytes);
    }
    
    public static void storeCSRFToken(HttpSession session) {
        String token = generateCSRFToken();
        session.setAttribute(CSRF_TOKEN_NAME, token);
    }
    
    public static boolean validateCSRFToken(HttpServletRequest request) {
        HttpSession session = request.getSession(false);
        if (session == null) {
            return false;
        }
        
        String sessionToken = (String) session.getAttribute(CSRF_TOKEN_NAME);
        String requestToken = request.getParameter(CSRF_TOKEN_NAME);
        
        if (sessionToken == null || requestToken == null) {
            return false;
        }
        
        return sessionToken.equals(requestToken);
    }
    
    public static String getCSRFToken(HttpSession session) {
        return (String) session.getAttribute(CSRF_TOKEN_NAME);
    }
}
```

### File Upload Security
```java
import java.io.*;
import java.nio.file.*;
import java.util.*;

public class SecureFileUpload {
    private static final Set<String> ALLOWED_EXTENSIONS = Set.of(
        "jpg", "jpeg", "png", "gif", "pdf", "txt", "doc", "docx"
    );
    private static final long MAX_FILE_SIZE = 10 * 1024 * 1024; // 10MB
    private static final String UPLOAD_DIR = "/secure/uploads/";
    
    public boolean isFileAllowed(String filename) {
        if (filename == null || filename.trim().isEmpty()) {
            return false;
        }
        
        String extension = getFileExtension(filename).toLowerCase();
        return ALLOWED_EXTENSIONS.contains(extension);
    }
    
    public boolean isFileSizeValid(long fileSize) {
        return fileSize > 0 && fileSize <= MAX_FILE_SIZE;
    }
    
    public String generateSecureFilename(String originalFilename) {
        String extension = getFileExtension(originalFilename);
        String secureName = UUID.randomUUID().toString();
        return secureName + "." + extension;
    }
    
    public void saveFileSecurely(InputStream fileStream, String filename) throws IOException {
        // Validate filename
        if (!isFileAllowed(filename)) {
            throw new SecurityException("File type not allowed");
        }
        
        // Generate secure filename
        String secureFilename = generateSecureFilename(filename);
        Path uploadPath = Paths.get(UPLOAD_DIR, secureFilename);
        
        // Ensure upload directory exists
        Files.createDirectories(uploadPath.getParent());
        
        // Save file with restricted permissions
        Files.copy(fileStream, uploadPath, StandardCopyOption.REPLACE_EXISTING);
        
        // Set file permissions (read-only for owner)
        Files.setPosixFilePermissions(uploadPath, 
            Set.of(PosixFilePermission.OWNER_READ, PosixFilePermission.OWNER_WRITE));
    }
    
    private String getFileExtension(String filename) {
        int lastDotIndex = filename.lastIndexOf('.');
        if (lastDotIndex == -1 || lastDotIndex == filename.length() - 1) {
            return "";
        }
        return filename.substring(lastDotIndex + 1);
    }
}
```

### Input Validation Framework
```java
import java.util.regex.Pattern;
import java.util.function.Predicate;

public class InputValidator {
    
    public static class ValidationResult {
        private final boolean valid;
        private final String errorMessage;
        
        public ValidationResult(boolean valid, String errorMessage) {
            this.valid = valid;
            this.errorMessage = errorMessage;
        }
        
        public boolean isValid() { return valid; }
        public String getErrorMessage() { return errorMessage; }
    }
    
    public static ValidationResult validateEmail(String email) {
        if (email == null || email.trim().isEmpty()) {
            return new ValidationResult(false, "Email is required");
        }
        
        Pattern emailPattern = Pattern.compile(
            "^[A-Za-z0-9+_.-]+@([A-Za-z0-9.-]+\\.[A-Za-z]{2,})$"
        );
        
        if (!emailPattern.matcher(email).matches()) {
            return new ValidationResult(false, "Invalid email format");
        }
        
        if (email.length() > 254) {
            return new ValidationResult(false, "Email too long");
        }
        
        return new ValidationResult(true, null);
    }
    
    public static ValidationResult validatePassword(String password) {
        if (password == null || password.length() < 8) {
            return new ValidationResult(false, "Password must be at least 8 characters");
        }
        
        if (password.length() > 128) {
            return new ValidationResult(false, "Password too long");
        }
        
        if (!password.matches(".*[A-Z].*")) {
            return new ValidationResult(false, "Password must contain uppercase letter");
        }
        
        if (!password.matches(".*[a-z].*")) {
            return new ValidationResult(false, "Password must contain lowercase letter");
        }
        
        if (!password.matches(".*\\d.*")) {
            return new ValidationResult(false, "Password must contain number");
        }
        
        return new ValidationResult(true, null);
    }
    
    public static ValidationResult validateLength(String input, int minLength, int maxLength) {
        if (input == null) {
            return new ValidationResult(false, "Input is required");
        }
        
        if (input.length() < minLength) {
            return new ValidationResult(false, "Input too short (minimum " + minLength + " characters)");
        }
        
        if (input.length() > maxLength) {
            return new ValidationResult(false, "Input too long (maximum " + maxLength + " characters)");
        }
        
        return new ValidationResult(true, null);
    }
}
```

## 🔍 Security Best Practices

### Common Vulnerabilities to Prevent
- **SQL Injection**: Use parameterized queries
- **XSS**: Escape all user input
- **CSRF**: Implement CSRF tokens
- **File Upload**: Validate file types and sizes
- **Path Traversal**: Sanitize file paths

### Secure Coding Principles
- **Input Validation**: Validate all inputs
- **Output Encoding**: Encode all outputs
- **Least Privilege**: Use minimal required permissions
- **Defense in Depth**: Multiple security layers
- **Fail Secure**: Default to secure state

## 💡 Learning Points
- Always validate and sanitize user input
- Use parameterized queries to prevent SQL injection
- Implement proper error handling without information leakage
- Follow the principle of least privilege
- Regular security code reviews and testing

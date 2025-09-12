# CS-340 Authentication & Security

## 🎯 Purpose
Demonstrate authentication, authorization, and security implementation in client-server applications.

## 📝 Security Examples

### JWT Authentication
```java
@Service
public class JwtService {
    
    @Value("${jwt.secret}")
    private String secret;
    
    @Value("${jwt.expiration}")
    private int expiration;
    
    public String generateToken(UserDetails userDetails) {
        Map<String, Object> claims = new HashMap<>();
        claims.put("authorities", userDetails.getAuthorities());
        return createToken(claims, userDetails.getUsername());
    }
    
    private String createToken(Map<String, Object> claims, String subject) {
        return Jwts.builder()
            .setClaims(claims)
            .setSubject(subject)
            .setIssuedAt(new Date(System.currentTimeMillis()))
            .setExpiration(new Date(System.currentTimeMillis() + expiration * 1000))
            .signWith(SignatureAlgorithm.HS512, secret)
            .compact();
    }
    
    public Boolean validateToken(String token, UserDetails userDetails) {
        final String username = extractUsername(token);
        return (username.equals(userDetails.getUsername()) && !isTokenExpired(token));
    }
    
    public String extractUsername(String token) {
        return extractClaim(token, Claims::getSubject);
    }
    
    public Date extractExpiration(String token) {
        return extractClaim(token, Claims::getExpiration);
    }
    
    private <T> T extractClaim(String token, Function<Claims, T> claimsResolver) {
        final Claims claims = extractAllClaims(token);
        return claimsResolver.apply(claims);
    }
    
    private Claims extractAllClaims(String token) {
        return Jwts.parser().setSigningKey(secret).parseClaimsJws(token).getBody();
    }
    
    private Boolean isTokenExpired(String token) {
        return extractExpiration(token).before(new Date());
    }
}
```

### Spring Security Configuration
```java
@Configuration
@EnableWebSecurity
@EnableGlobalMethodSecurity(prePostEnabled = true)
public class SecurityConfig {
    
    @Autowired
    private JwtAuthenticationEntryPoint jwtAuthenticationEntryPoint;
    
    @Autowired
    private JwtRequestFilter jwtRequestFilter;
    
    @Bean
    public PasswordEncoder passwordEncoder() {
        return new BCryptPasswordEncoder();
    }
    
    @Bean
    public AuthenticationManager authenticationManager(
            AuthenticationConfiguration authConfig) throws Exception {
        return authConfig.getAuthenticationManager();
    }
    
    @Bean
    public SecurityFilterChain filterChain(HttpSecurity http) throws Exception {
        http.csrf().disable()
            .authorizeHttpRequests(authz -> authz
                .requestMatchers("/api/auth/**").permitAll()
                .requestMatchers("/api/public/**").permitAll()
                .requestMatchers(HttpMethod.GET, "/api/users").hasRole("ADMIN")
                .requestMatchers(HttpMethod.POST, "/api/users").hasRole("ADMIN")
                .requestMatchers("/api/users/{id}").access("@userSecurityService.canAccessUser(authentication, #id)")
                .anyRequest().authenticated()
            )
            .exceptionHandling().authenticationEntryPoint(jwtAuthenticationEntryPoint)
            .and()
            .sessionManagement().sessionCreationPolicy(SessionCreationPolicy.STATELESS);
        
        http.addFilterBefore(jwtRequestFilter, UsernamePasswordAuthenticationFilter.class);
        
        return http.build();
    }
}
```

### Authentication Controller
```java
@RestController
@RequestMapping("/api/auth")
@CrossOrigin(origins = "*")
public class AuthenticationController {
    
    @Autowired
    private AuthenticationManager authenticationManager;
    
    @Autowired
    private JwtService jwtService;
    
    @Autowired
    private UserService userService;
    
    @PostMapping("/login")
    public ResponseEntity<JwtResponse> login(@RequestBody LoginRequest loginRequest) {
        try {
            Authentication authentication = authenticationManager.authenticate(
                new UsernamePasswordAuthenticationToken(
                    loginRequest.getUsername(),
                    loginRequest.getPassword()
                )
            );
            
            UserDetails userDetails = (UserDetails) authentication.getPrincipal();
            String token = jwtService.generateToken(userDetails);
            
            JwtResponse response = new JwtResponse(token, userDetails.getUsername(), 
                userDetails.getAuthorities().stream()
                    .map(GrantedAuthority::getAuthority)
                    .collect(Collectors.toList()));
            
            return ResponseEntity.ok(response);
            
        } catch (BadCredentialsException e) {
            return ResponseEntity.status(HttpStatus.UNAUTHORIZED)
                .body(new JwtResponse("Invalid credentials"));
        }
    }
    
    @PostMapping("/register")
    public ResponseEntity<UserResponse> register(@Valid @RequestBody RegisterRequest request) {
        try {
            UserResponse user = userService.createUser(request);
            return ResponseEntity.status(HttpStatus.CREATED).body(user);
        } catch (EmailAlreadyExistsException e) {
            return ResponseEntity.status(HttpStatus.CONFLICT)
                .body(new UserResponse("Email already exists"));
        }
    }
    
    @PostMapping("/refresh")
    public ResponseEntity<JwtResponse> refreshToken(@RequestBody RefreshTokenRequest request) {
        try {
            String username = jwtService.extractUsername(request.getToken());
            UserDetails userDetails = userService.loadUserByUsername(username);
            
            if (jwtService.validateToken(request.getToken(), userDetails)) {
                String newToken = jwtService.generateToken(userDetails);
                return ResponseEntity.ok(new JwtResponse(newToken, username, 
                    userDetails.getAuthorities().stream()
                        .map(GrantedAuthority::getAuthority)
                        .collect(Collectors.toList())));
            }
            
            return ResponseEntity.status(HttpStatus.UNAUTHORIZED)
                .body(new JwtResponse("Invalid token"));
            
        } catch (Exception e) {
            return ResponseEntity.status(HttpStatus.UNAUTHORIZED)
                .body(new JwtResponse("Token refresh failed"));
        }
    }
}
```

### JWT Request Filter
```java
@Component
public class JwtRequestFilter extends OncePerRequestFilter {
    
    @Autowired
    private UserService userService;
    
    @Autowired
    private JwtService jwtService;
    
    @Override
    protected void doFilterInternal(HttpServletRequest request, 
                                  HttpServletResponse response, 
                                  FilterChain chain) throws ServletException, IOException {
        
        final String requestTokenHeader = request.getHeader("Authorization");
        
        String username = null;
        String jwtToken = null;
        
        if (requestTokenHeader != null && requestTokenHeader.startsWith("Bearer ")) {
            jwtToken = requestTokenHeader.substring(7);
            try {
                username = jwtService.extractUsername(jwtToken);
            } catch (IllegalArgumentException e) {
                logger.error("Unable to get JWT Token");
            } catch (ExpiredJwtException e) {
                logger.error("JWT Token has expired");
            }
        } else {
            logger.warn("JWT Token does not begin with Bearer String");
        }
        
        if (username != null && SecurityContextHolder.getContext().getAuthentication() == null) {
            UserDetails userDetails = this.userService.loadUserByUsername(username);
            
            if (jwtService.validateToken(jwtToken, userDetails)) {
                UsernamePasswordAuthenticationToken authToken = 
                    new UsernamePasswordAuthenticationToken(
                        userDetails, null, userDetails.getAuthorities());
                authToken.setDetails(new WebAuthenticationDetailsSource().buildDetails(request));
                SecurityContextHolder.getContext().setAuthentication(authToken);
            }
        }
        chain.doFilter(request, response);
    }
}
```

### Role-Based Access Control
```java
@Service
public class UserSecurityService {
    
    @Autowired
    private UserRepository userRepository;
    
    public boolean canAccessUser(Authentication authentication, Long userId) {
        String currentUsername = authentication.getName();
        User currentUser = userRepository.findByEmail(currentUsername)
            .orElseThrow(() -> new UserNotFoundException("User not found"));
        
        // Admin can access any user
        if (currentUser.getRole() == UserRole.ADMIN) {
            return true;
        }
        
        // Users can only access their own data
        return currentUser.getId().equals(userId);
    }
    
    public boolean canModifyUser(Authentication authentication, Long userId) {
        String currentUsername = authentication.getName();
        User currentUser = userRepository.findByEmail(currentUsername)
            .orElseThrow(() -> new UserNotFoundException("User not found"));
        
        // Admin can modify any user
        if (currentUser.getRole() == UserRole.ADMIN) {
            return true;
        }
        
        // Users can only modify their own data
        return currentUser.getId().equals(userId);
    }
}
```

### Password Security
```java
@Service
public class PasswordService {
    
    @Autowired
    private PasswordEncoder passwordEncoder;
    
    public String encodePassword(String rawPassword) {
        return passwordEncoder.encode(rawPassword);
    }
    
    public boolean matches(String rawPassword, String encodedPassword) {
        return passwordEncoder.matches(rawPassword, encodedPassword);
    }
    
    public void validatePasswordStrength(String password) {
        if (password == null || password.length() < 8) {
            throw new WeakPasswordException("Password must be at least 8 characters long");
        }
        
        if (!password.matches(".*[A-Z].*")) {
            throw new WeakPasswordException("Password must contain at least one uppercase letter");
        }
        
        if (!password.matches(".*[a-z].*")) {
            throw new WeakPasswordException("Password must contain at least one lowercase letter");
        }
        
        if (!password.matches(".*[0-9].*")) {
            throw new WeakPasswordException("Password must contain at least one number");
        }
        
        if (!password.matches(".*[!@#$%^&*(),.?\":{}|<>].*")) {
            throw new WeakPasswordException("Password must contain at least one special character");
        }
    }
}
```

## 🔍 Security Best Practices

### Authentication vs Authorization
- **Authentication**: Verifying who the user is (login)
- **Authorization**: Determining what the user can do (permissions)

### Security Headers
```java
@Configuration
public class SecurityHeadersConfig {
    
    @Bean
    public FilterRegistrationBean<HeaderFilter> headerFilter() {
        FilterRegistrationBean<HeaderFilter> registrationBean = new FilterRegistrationBean<>();
        registrationBean.setFilter(new HeaderFilter());
        registrationBean.addUrlPatterns("/*");
        return registrationBean;
    }
    
    public static class HeaderFilter implements Filter {
        @Override
        public void doFilter(ServletRequest request, ServletResponse response, 
                           FilterChain chain) throws IOException, ServletException {
            HttpServletResponse httpResponse = (HttpServletResponse) response;
            
            httpResponse.setHeader("X-Content-Type-Options", "nosniff");
            httpResponse.setHeader("X-Frame-Options", "DENY");
            httpResponse.setHeader("X-XSS-Protection", "1; mode=block");
            httpResponse.setHeader("Strict-Transport-Security", "max-age=31536000; includeSubDomains");
            httpResponse.setHeader("Content-Security-Policy", "default-src 'self'");
            
            chain.doFilter(request, response);
        }
    }
}
```

## 💡 Learning Points
- JWT provides stateless authentication
- Spring Security handles authentication and authorization
- Role-based access control limits user permissions
- Strong password policies improve security
- Security headers protect against common attacks
- HTTPS should be used in production environments

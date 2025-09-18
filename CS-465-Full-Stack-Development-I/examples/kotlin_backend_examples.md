# CS-465 Kotlin Full Stack Backend Examples

## 🎯 Purpose
Demonstrate full stack backend development with Kotlin including Spring Boot, REST APIs, database integration, and modern web development patterns.

## 📝 Kotlin Full Stack Backend Examples

### Spring Boot Application Setup
```kotlin
// Application.kt
@SpringBootApplication
@EnableJpaRepositories
@EnableWebMvc
class FullStackApplication

fun main(args: Array<String>) {
    runApplication<FullStackApplication>(*args)
}

// Application Properties (application.yml)
/*
spring:
  application:
    name: fullstack-kotlin-app
  datasource:
    url: jdbc:postgresql://localhost:5432/fullstack_db
    username: ${DB_USERNAME:postgres}
    password: ${DB_PASSWORD:password}
    driver-class-name: org.postgresql.Driver
  jpa:
    hibernate:
      ddl-auto: update
    show-sql: true
    properties:
      hibernate:
        dialect: org.hibernate.dialect.PostgreSQLDialect
  security:
    oauth2:
      client:
        registration:
          google:
            client-id: ${GOOGLE_CLIENT_ID}
            client-secret: ${GOOGLE_CLIENT_SECRET}
            scope: openid,profile,email

server:
  port: 8080

logging:
  level:
    org.springframework.web: DEBUG
    com.example: DEBUG
*/
```

### Domain Models
```kotlin
import javax.persistence.*
import java.time.LocalDateTime

@Entity
@Table(name = "users")
data class User(
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    val id: Long = 0,
    
    @Column(unique = true, nullable = false)
    val email: String,
    
    @Column(nullable = false)
    val name: String,
    
    @Column(name = "created_at")
    val createdAt: LocalDateTime = LocalDateTime.now(),
    
    @Column(name = "updated_at")
    val updatedAt: LocalDateTime = LocalDateTime.now(),
    
    @OneToMany(mappedBy = "user", cascade = [CascadeType.ALL], fetch = FetchType.LAZY)
    val posts: List<Post> = emptyList()
)

@Entity
@Table(name = "posts")
data class Post(
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    val id: Long = 0,
    
    @Column(nullable = false)
    val title: String,
    
    @Column(columnDefinition = "TEXT")
    val content: String,
    
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "user_id")
    val user: User,
    
    @Column(name = "created_at")
    val createdAt: LocalDateTime = LocalDateTime.now(),
    
    @Column(name = "updated_at")
    val updatedAt: LocalDateTime = LocalDateTime.now(),
    
    @OneToMany(mappedBy = "post", cascade = [CascadeType.ALL], fetch = FetchType.LAZY)
    val comments: List<Comment> = emptyList()
)

@Entity
@Table(name = "comments")
data class Comment(
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    val id: Long = 0,
    
    @Column(columnDefinition = "TEXT")
    val content: String,
    
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "post_id")
    val post: Post,
    
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "user_id")
    val user: User,
    
    @Column(name = "created_at")
    val createdAt: LocalDateTime = LocalDateTime.now()
)
```

### DTOs (Data Transfer Objects)
```kotlin
data class CreateUserRequest(
    val email: String,
    val name: String
)

data class UpdateUserRequest(
    val name: String? = null,
    val email: String? = null
)

data class UserResponse(
    val id: Long,
    val email: String,
    val name: String,
    val createdAt: LocalDateTime,
    val updatedAt: LocalDateTime
) {
    companion object {
        fun fromEntity(user: User): UserResponse {
            return UserResponse(
                id = user.id,
                email = user.email,
                name = user.name,
                createdAt = user.createdAt,
                updatedAt = user.updatedAt
            )
        }
    }
}

data class CreatePostRequest(
    val title: String,
    val content: String
)

data class UpdatePostRequest(
    val title: String? = null,
    val content: String? = null
)

data class PostResponse(
    val id: Long,
    val title: String,
    val content: String,
    val author: UserResponse,
    val createdAt: LocalDateTime,
    val updatedAt: LocalDateTime,
    val commentCount: Int
) {
    companion object {
        fun fromEntity(post: Post): PostResponse {
            return PostResponse(
                id = post.id,
                title = post.title,
                content = post.content,
                author = UserResponse.fromEntity(post.user),
                createdAt = post.createdAt,
                updatedAt = post.updatedAt,
                commentCount = post.comments.size
            )
        }
    }
}

data class CreateCommentRequest(
    val content: String
)

data class CommentResponse(
    val id: Long,
    val content: String,
    val author: UserResponse,
    val createdAt: LocalDateTime
) {
    companion object {
        fun fromEntity(comment: Comment): CommentResponse {
            return CommentResponse(
                id = comment.id,
                content = comment.content,
                author = UserResponse.fromEntity(comment.user),
                createdAt = comment.createdAt
            )
        }
    }
}
```

### Repository Layer
```kotlin
import org.springframework.data.jpa.repository.JpaRepository
import org.springframework.data.jpa.repository.Query
import org.springframework.data.repository.query.Param
import org.springframework.stereotype.Repository

@Repository
interface UserRepository : JpaRepository<User, Long> {
    fun findByEmail(email: String): User?
    fun existsByEmail(email: String): Boolean
    
    @Query("SELECT u FROM User u WHERE u.name LIKE %:name%")
    fun findByNameContaining(@Param("name") name: String): List<User>
}

@Repository
interface PostRepository : JpaRepository<Post, Long> {
    fun findByUserIdOrderByCreatedAtDesc(userId: Long): List<Post>
    
    @Query("SELECT p FROM Post p WHERE p.title LIKE %:title% OR p.content LIKE %:content%")
    fun findByTitleOrContentContaining(@Param("title") title: String, @Param("content") content: String): List<Post>
    
    @Query("SELECT p FROM Post p ORDER BY p.createdAt DESC")
    fun findAllOrderByCreatedAtDesc(): List<Post>
}

@Repository
interface CommentRepository : JpaRepository<Comment, Long> {
    fun findByPostIdOrderByCreatedAtDesc(postId: Long): List<Comment>
    fun countByPostId(postId: Long): Long
}
```

### Service Layer
```kotlin
import org.springframework.stereotype.Service
import org.springframework.transaction.annotation.Transactional
import org.springframework.data.domain.Page
import org.springframework.data.domain.Pageable

@Service
@Transactional
class UserService(
    private val userRepository: UserRepository
) {
    
    fun createUser(request: CreateUserRequest): UserResponse {
        if (userRepository.existsByEmail(request.email)) {
            throw IllegalArgumentException("User with email ${request.email} already exists")
        }
        
        val user = User(
            email = request.email,
            name = request.name
        )
        
        val savedUser = userRepository.save(user)
        return UserResponse.fromEntity(savedUser)
    }
    
    @Transactional(readOnly = true)
    fun getUserById(id: Long): UserResponse {
        val user = userRepository.findById(id)
            .orElseThrow { IllegalArgumentException("User with id $id not found") }
        return UserResponse.fromEntity(user)
    }
    
    @Transactional(readOnly = true)
    fun getAllUsers(pageable: Pageable): Page<UserResponse> {
        return userRepository.findAll(pageable)
            .map { UserResponse.fromEntity(it) }
    }
    
    fun updateUser(id: Long, request: UpdateUserRequest): UserResponse {
        val user = userRepository.findById(id)
            .orElseThrow { IllegalArgumentException("User with id $id not found") }
        
        val updatedUser = user.copy(
            name = request.name ?: user.name,
            email = request.email ?: user.email,
            updatedAt = LocalDateTime.now()
        )
        
        val savedUser = userRepository.save(updatedUser)
        return UserResponse.fromEntity(savedUser)
    }
    
    fun deleteUser(id: Long) {
        if (!userRepository.existsById(id)) {
            throw IllegalArgumentException("User with id $id not found")
        }
        userRepository.deleteById(id)
    }
    
    @Transactional(readOnly = true)
    fun searchUsers(name: String): List<UserResponse> {
        return userRepository.findByNameContaining(name)
            .map { UserResponse.fromEntity(it) }
    }
}

@Service
@Transactional
class PostService(
    private val postRepository: PostRepository,
    private val userRepository: UserRepository
) {
    
    fun createPost(userId: Long, request: CreatePostRequest): PostResponse {
        val user = userRepository.findById(userId)
            .orElseThrow { IllegalArgumentException("User with id $userId not found") }
        
        val post = Post(
            title = request.title,
            content = request.content,
            user = user
        )
        
        val savedPost = postRepository.save(post)
        return PostResponse.fromEntity(savedPost)
    }
    
    @Transactional(readOnly = true)
    fun getPostById(id: Long): PostResponse {
        val post = postRepository.findById(id)
            .orElseThrow { IllegalArgumentException("Post with id $id not found") }
        return PostResponse.fromEntity(post)
    }
    
    @Transactional(readOnly = true)
    fun getAllPosts(pageable: Pageable): Page<PostResponse> {
        return postRepository.findAll(pageable)
            .map { PostResponse.fromEntity(it) }
    }
    
    @Transactional(readOnly = true)
    fun getPostsByUser(userId: Long): List<PostResponse> {
        return postRepository.findByUserIdOrderByCreatedAtDesc(userId)
            .map { PostResponse.fromEntity(it) }
    }
    
    fun updatePost(id: Long, request: UpdatePostRequest): PostResponse {
        val post = postRepository.findById(id)
            .orElseThrow { IllegalArgumentException("Post with id $id not found") }
        
        val updatedPost = post.copy(
            title = request.title ?: post.title,
            content = request.content ?: post.content,
            updatedAt = LocalDateTime.now()
        )
        
        val savedPost = postRepository.save(updatedPost)
        return PostResponse.fromEntity(savedPost)
    }
    
    fun deletePost(id: Long) {
        if (!postRepository.existsById(id)) {
            throw IllegalArgumentException("Post with id $id not found")
        }
        postRepository.deleteById(id)
    }
    
    @Transactional(readOnly = true)
    fun searchPosts(query: String): List<PostResponse> {
        return postRepository.findByTitleOrContentContaining(query, query)
            .map { PostResponse.fromEntity(it) }
    }
}

@Service
@Transactional
class CommentService(
    private val commentRepository: CommentRepository,
    private val postRepository: PostRepository,
    private val userRepository: UserRepository
) {
    
    fun createComment(postId: Long, userId: Long, request: CreateCommentRequest): CommentResponse {
        val post = postRepository.findById(postId)
            .orElseThrow { IllegalArgumentException("Post with id $postId not found") }
        
        val user = userRepository.findById(userId)
            .orElseThrow { IllegalArgumentException("User with id $userId not found") }
        
        val comment = Comment(
            content = request.content,
            post = post,
            user = user
        )
        
        val savedComment = commentRepository.save(comment)
        return CommentResponse.fromEntity(savedComment)
    }
    
    @Transactional(readOnly = true)
    fun getCommentsByPost(postId: Long): List<CommentResponse> {
        return commentRepository.findByPostIdOrderByCreatedAtDesc(postId)
            .map { CommentResponse.fromEntity(it) }
    }
    
    fun deleteComment(id: Long) {
        if (!commentRepository.existsById(id)) {
            throw IllegalArgumentException("Comment with id $id not found")
        }
        commentRepository.deleteById(id)
    }
}
```

### Controller Layer
```kotlin
import org.springframework.http.HttpStatus
import org.springframework.http.ResponseEntity
import org.springframework.web.bind.annotation.*
import org.springframework.data.domain.Page
import org.springframework.data.domain.Pageable
import org.springframework.data.web.PageableDefault
import javax.validation.Valid

@RestController
@RequestMapping("/api/users")
@CrossOrigin(origins = ["http://localhost:3000"])
class UserController(
    private val userService: UserService
) {
    
    @PostMapping
    fun createUser(@Valid @RequestBody request: CreateUserRequest): ResponseEntity<UserResponse> {
        val user = userService.createUser(request)
        return ResponseEntity.status(HttpStatus.CREATED).body(user)
    }
    
    @GetMapping("/{id}")
    fun getUserById(@PathVariable id: Long): ResponseEntity<UserResponse> {
        val user = userService.getUserById(id)
        return ResponseEntity.ok(user)
    }
    
    @GetMapping
    fun getAllUsers(
        @PageableDefault(size = 20) pageable: Pageable
    ): ResponseEntity<Page<UserResponse>> {
        val users = userService.getAllUsers(pageable)
        return ResponseEntity.ok(users)
    }
    
    @PutMapping("/{id}")
    fun updateUser(
        @PathVariable id: Long,
        @Valid @RequestBody request: UpdateUserRequest
    ): ResponseEntity<UserResponse> {
        val user = userService.updateUser(id, request)
        return ResponseEntity.ok(user)
    }
    
    @DeleteMapping("/{id}")
    fun deleteUser(@PathVariable id: Long): ResponseEntity<Void> {
        userService.deleteUser(id)
        return ResponseEntity.noContent().build()
    }
    
    @GetMapping("/search")
    fun searchUsers(@RequestParam name: String): ResponseEntity<List<UserResponse>> {
        val users = userService.searchUsers(name)
        return ResponseEntity.ok(users)
    }
}

@RestController
@RequestMapping("/api/posts")
@CrossOrigin(origins = ["http://localhost:3000"])
class PostController(
    private val postService: PostService
) {
    
    @PostMapping
    fun createPost(
        @RequestHeader("X-User-Id") userId: Long,
        @Valid @RequestBody request: CreatePostRequest
    ): ResponseEntity<PostResponse> {
        val post = postService.createPost(userId, request)
        return ResponseEntity.status(HttpStatus.CREATED).body(post)
    }
    
    @GetMapping("/{id}")
    fun getPostById(@PathVariable id: Long): ResponseEntity<PostResponse> {
        val post = postService.getPostById(id)
        return ResponseEntity.ok(post)
    }
    
    @GetMapping
    fun getAllPosts(
        @PageableDefault(size = 10) pageable: Pageable
    ): ResponseEntity<Page<PostResponse>> {
        val posts = postService.getAllPosts(pageable)
        return ResponseEntity.ok(posts)
    }
    
    @GetMapping("/user/{userId}")
    fun getPostsByUser(@PathVariable userId: Long): ResponseEntity<List<PostResponse>> {
        val posts = postService.getPostsByUser(userId)
        return ResponseEntity.ok(posts)
    }
    
    @PutMapping("/{id}")
    fun updatePost(
        @PathVariable id: Long,
        @Valid @RequestBody request: UpdatePostRequest
    ): ResponseEntity<PostResponse> {
        val post = postService.updatePost(id, request)
        return ResponseEntity.ok(post)
    }
    
    @DeleteMapping("/{id}")
    fun deletePost(@PathVariable id: Long): ResponseEntity<Void> {
        postService.deletePost(id)
        return ResponseEntity.noContent().build()
    }
    
    @GetMapping("/search")
    fun searchPosts(@RequestParam q: String): ResponseEntity<List<PostResponse>> {
        val posts = postService.searchPosts(q)
        return ResponseEntity.ok(posts)
    }
}

@RestController
@RequestMapping("/api/comments")
@CrossOrigin(origins = ["http://localhost:3000"])
class CommentController(
    private val commentService: CommentService
) {
    
    @PostMapping
    fun createComment(
        @RequestHeader("X-User-Id") userId: Long,
        @RequestParam postId: Long,
        @Valid @RequestBody request: CreateCommentRequest
    ): ResponseEntity<CommentResponse> {
        val comment = commentService.createComment(postId, userId, request)
        return ResponseEntity.status(HttpStatus.CREATED).body(comment)
    }
    
    @GetMapping("/post/{postId}")
    fun getCommentsByPost(@PathVariable postId: Long): ResponseEntity<List<CommentResponse>> {
        val comments = commentService.getCommentsByPost(postId)
        return ResponseEntity.ok(comments)
    }
    
    @DeleteMapping("/{id}")
    fun deleteComment(@PathVariable id: Long): ResponseEntity<Void> {
        commentService.deleteComment(id)
        return ResponseEntity.noContent().build()
    }
}
```

### Exception Handling
```kotlin
import org.springframework.http.HttpStatus
import org.springframework.http.ResponseEntity
import org.springframework.web.bind.annotation.ExceptionHandler
import org.springframework.web.bind.annotation.RestControllerAdvice
import org.springframework.web.context.request.WebRequest
import java.time.LocalDateTime

@RestControllerAdvice
class GlobalExceptionHandler {
    
    @ExceptionHandler(IllegalArgumentException::class)
    fun handleIllegalArgumentException(
        ex: IllegalArgumentException,
        request: WebRequest
    ): ResponseEntity<ErrorResponse> {
        val errorResponse = ErrorResponse(
            timestamp = LocalDateTime.now(),
            status = HttpStatus.BAD_REQUEST.value(),
            error = "Bad Request",
            message = ex.message ?: "Invalid request",
            path = request.getDescription(false).replace("uri=", "")
        )
        return ResponseEntity.badRequest().body(errorResponse)
    }
    
    @ExceptionHandler(EntityNotFoundException::class)
    fun handleEntityNotFoundException(
        ex: EntityNotFoundException,
        request: WebRequest
    ): ResponseEntity<ErrorResponse> {
        val errorResponse = ErrorResponse(
            timestamp = LocalDateTime.now(),
            status = HttpStatus.NOT_FOUND.value(),
            error = "Not Found",
            message = ex.message ?: "Resource not found",
            path = request.getDescription(false).replace("uri=", "")
        )
        return ResponseEntity.status(HttpStatus.NOT_FOUND).body(errorResponse)
    }
    
    @ExceptionHandler(Exception::class)
    fun handleGenericException(
        ex: Exception,
        request: WebRequest
    ): ResponseEntity<ErrorResponse> {
        val errorResponse = ErrorResponse(
            timestamp = LocalDateTime.now(),
            status = HttpStatus.INTERNAL_SERVER_ERROR.value(),
            error = "Internal Server Error",
            message = "An unexpected error occurred",
            path = request.getDescription(false).replace("uri=", "")
        )
        return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(errorResponse)
    }
}

data class ErrorResponse(
    val timestamp: LocalDateTime,
    val status: Int,
    val error: String,
    val message: String,
    val path: String
)

class EntityNotFoundException(message: String) : RuntimeException(message)
```

### Security Configuration
```kotlin
import org.springframework.context.annotation.Bean
import org.springframework.context.annotation.Configuration
import org.springframework.security.config.annotation.web.builders.HttpSecurity
import org.springframework.security.config.annotation.web.configuration.EnableWebSecurity
import org.springframework.security.config.annotation.web.configuration.WebSecurityConfigurerAdapter
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder
import org.springframework.security.crypto.password.PasswordEncoder
import org.springframework.web.cors.CorsConfiguration
import org.springframework.web.cors.CorsConfigurationSource
import org.springframework.web.cors.UrlBasedCorsConfigurationSource

@Configuration
@EnableWebSecurity
class SecurityConfig : WebSecurityConfigurerAdapter() {
    
    override fun configure(http: HttpSecurity) {
        http
            .cors().and()
            .csrf().disable()
            .authorizeRequests()
                .antMatchers("/api/auth/**").permitAll()
                .antMatchers("/api/public/**").permitAll()
                .antMatchers(HttpMethod.GET, "/api/posts/**").permitAll()
                .antMatchers(HttpMethod.GET, "/api/comments/**").permitAll()
                .anyRequest().authenticated()
            .and()
            .oauth2Login()
            .and()
            .oauth2ResourceServer()
            .jwt()
    }
    
    @Bean
    fun passwordEncoder(): PasswordEncoder {
        return BCryptPasswordEncoder()
    }
    
    @Bean
    fun corsConfigurationSource(): CorsConfigurationSource {
        val configuration = CorsConfiguration()
        configuration.allowedOriginPatterns = listOf("*")
        configuration.allowedMethods = listOf("GET", "POST", "PUT", "DELETE", "OPTIONS")
        configuration.allowedHeaders = listOf("*")
        configuration.allowCredentials = true
        
        val source = UrlBasedCorsConfigurationSource()
        source.registerCorsConfiguration("/**", configuration)
        return source
    }
}
```

### Configuration Classes
```kotlin
import org.springframework.context.annotation.Bean
import org.springframework.context.annotation.Configuration
import org.springframework.web.servlet.config.annotation.CorsRegistry
import org.springframework.web.servlet.config.annotation.WebMvcConfigurer
import com.fasterxml.jackson.databind.ObjectMapper
import com.fasterxml.jackson.datatype.jsr310.JavaTimeModule
import com.fasterxml.jackson.module.kotlin.KotlinModule

@Configuration
class WebConfig : WebMvcConfigurer {
    
    override fun addCorsMappings(registry: CorsRegistry) {
        registry.addMapping("/api/**")
            .allowedOrigins("http://localhost:3000", "http://localhost:3001")
            .allowedMethods("GET", "POST", "PUT", "DELETE", "OPTIONS")
            .allowedHeaders("*")
            .allowCredentials(true)
    }
}

@Configuration
class JacksonConfig {
    
    @Bean
    fun objectMapper(): ObjectMapper {
        return ObjectMapper()
            .registerModule(KotlinModule.Builder().build())
            .registerModule(JavaTimeModule())
    }
}
```

### Application Properties
```kotlin
// application.yml
/*
spring:
  application:
    name: fullstack-kotlin-app
  
  datasource:
    url: jdbc:postgresql://localhost:5432/fullstack_db
    username: ${DB_USERNAME:postgres}
    password: ${DB_PASSWORD:password}
    driver-class-name: org.postgresql.Driver
  
  jpa:
    hibernate:
      ddl-auto: update
    show-sql: true
    properties:
      hibernate:
        dialect: org.hibernate.dialect.PostgreSQLDialect
        format_sql: true
  
  security:
    oauth2:
      client:
        registration:
          google:
            client-id: ${GOOGLE_CLIENT_ID}
            client-secret: ${GOOGLE_CLIENT_SECRET}
            scope: openid,profile,email

server:
  port: 8080

logging:
  level:
    org.springframework.web: DEBUG
    com.example: DEBUG
    org.hibernate.SQL: DEBUG
    org.hibernate.type.descriptor.sql.BasicBinder: TRACE

management:
  endpoints:
    web:
      exposure:
        include: health,info,metrics
*/
```

## 🔍 Full Stack Architecture

### Backend Components
- **Controllers**: Handle HTTP requests and responses
- **Services**: Business logic and transaction management
- **Repositories**: Data access layer
- **Entities**: JPA domain models
- **DTOs**: Data transfer objects for API communication
- **Configuration**: Security, CORS, and application settings

### API Design Principles
- **RESTful**: Use HTTP methods appropriately
- **Stateless**: Each request contains all necessary information
- **Resource-based**: URLs represent resources
- **JSON**: Use JSON for data exchange
- **Error handling**: Consistent error responses
- **Pagination**: Support for large datasets
- **CORS**: Enable cross-origin requests

### Database Design
- **JPA/Hibernate**: Object-relational mapping
- **Relationships**: Proper entity relationships
- **Indexing**: Optimize query performance
- **Transactions**: Ensure data consistency
- **Migrations**: Version control for schema changes

## 💡 Learning Points
- **Spring Boot** provides rapid application development
- **JPA/Hibernate** simplifies database operations
- **REST APIs** enable frontend-backend communication
- **DTOs** separate internal models from API contracts
- **Exception handling** provides consistent error responses
- **Security** protects endpoints and data
- **CORS** enables cross-origin requests
- **Configuration** externalizes application settings
- **Testing** ensures code quality and reliability
- **Documentation** helps with API understanding and maintenance

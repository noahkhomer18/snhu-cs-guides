# CS-320 Performance Testing Examples

## 🎯 Purpose
Demonstrate performance testing methodologies and tools.

## 📝 Performance Testing Examples

### Load Testing with JMeter

#### Basic Load Test Plan
```xml
<?xml version="1.0" encoding="UTF-8"?>
<jmeterTestPlan version="1.2">
  <hashTree>
    <TestPlan testname="User API Load Test">
      <elementProp name="TestPlan.arguments" elementType="Arguments" guiclass="ArgumentsPanel">
        <collectionProp name="Arguments.arguments"/>
      </elementProp>
      <stringProp name="TestPlan.user_define_classpath"></stringProp>
      <boolProp name="TestPlan.functional_mode">false</boolProp>
      <boolProp name="TestPlan.serialize_threadgroups">false</boolProp>
    </TestPlan>
    
    <ThreadGroup testname="User Load Test">
      <stringProp name="ThreadGroup.num_threads">100</stringProp>
      <stringProp name="ThreadGroup.ramp_time">60</stringProp>
      <stringProp name="ThreadGroup.duration">300</stringProp>
      <stringProp name="ThreadGroup.delay"></stringProp>
      <boolProp name="ThreadGroup.scheduler">true</boolProp>
    </ThreadGroup>
  </hashTree>
</jmeterTestPlan>
```

### Stress Testing Example

#### API Stress Test
```java
@SpringBootTest(webEnvironment = SpringBootTest.WebEnvironment.RANDOM_PORT)
public class UserApiStressTest {
    
    @Autowired
    private TestRestTemplate restTemplate;
    
    @Test
    @DisplayName("Should handle concurrent user creation")
    void testConcurrentUserCreation() throws InterruptedException {
        int numberOfThreads = 50;
        int requestsPerThread = 10;
        CountDownLatch latch = new CountDownLatch(numberOfThreads);
        List<CompletableFuture<Void>> futures = new ArrayList<>();
        
        for (int i = 0; i < numberOfThreads; i++) {
            final int threadId = i;
            CompletableFuture<Void> future = CompletableFuture.runAsync(() -> {
                try {
                    for (int j = 0; j < requestsPerThread; j++) {
                        UserRequest request = new UserRequest(
                            "user" + threadId + "_" + j + "@example.com",
                            "User " + threadId + "_" + j,
                            "password123"
                        );
                        
                        ResponseEntity<UserResponse> response = restTemplate.postForEntity(
                            "/api/users", request, UserResponse.class
                        );
                        
                        assertEquals(HttpStatus.CREATED, response.getStatusCode());
                    }
                } finally {
                    latch.countDown();
                }
            });
            futures.add(future);
        }
        
        // Wait for all threads to complete
        assertTrue(latch.await(60, TimeUnit.SECONDS));
        
        // Verify all futures completed successfully
        CompletableFuture.allOf(futures.toArray(new CompletableFuture[0])).join();
    }
}
```

### Memory Leak Testing

#### Memory Usage Monitoring
```java
public class MemoryLeakTest {
    
    @Test
    @DisplayName("Should not have memory leaks in user processing")
    void testMemoryLeakInUserProcessing() throws InterruptedException {
        // Get initial memory usage
        Runtime runtime = Runtime.getRuntime();
        long initialMemory = runtime.totalMemory() - runtime.freeMemory();
        
        UserService userService = new UserService();
        
        // Process many users
        for (int i = 0; i < 10000; i++) {
            User user = new User("user" + i + "@example.com", "User " + i, "password");
            userService.processUser(user);
        }
        
        // Force garbage collection
        System.gc();
        Thread.sleep(1000);
        
        // Check memory usage
        long finalMemory = runtime.totalMemory() - runtime.freeMemory();
        long memoryIncrease = finalMemory - initialMemory;
        
        // Memory increase should be reasonable (less than 50MB)
        assertTrue(memoryIncrease < 50 * 1024 * 1024, 
            "Memory leak detected. Increase: " + memoryIncrease + " bytes");
    }
}
```

### Database Performance Testing

#### Query Performance Test
```java
@SpringBootTest
@Transactional
public class DatabasePerformanceTest {
    
    @Autowired
    private UserRepository userRepository;
    
    @Test
    @DisplayName("Should handle large dataset queries efficiently")
    void testLargeDatasetQueryPerformance() {
        // Create large dataset
        List<User> users = new ArrayList<>();
        for (int i = 0; i < 10000; i++) {
            users.add(new User("user" + i + "@example.com", "User " + i, "password"));
        }
        userRepository.saveAll(users);
        
        // Test query performance
        long startTime = System.currentTimeMillis();
        
        List<User> activeUsers = userRepository.findActiveUsers();
        
        long endTime = System.currentTimeMillis();
        long queryTime = endTime - startTime;
        
        // Query should complete within 1 second
        assertTrue(queryTime < 1000, "Query took too long: " + queryTime + "ms");
        assertFalse(activeUsers.isEmpty());
    }
    
    @Test
    @DisplayName("Should handle concurrent database operations")
    void testConcurrentDatabaseOperations() throws InterruptedException {
        int numberOfThreads = 20;
        CountDownLatch latch = new CountDownLatch(numberOfThreads);
        AtomicInteger successCount = new AtomicInteger(0);
        
        for (int i = 0; i < numberOfThreads; i++) {
            final int threadId = i;
            new Thread(() -> {
                try {
                    for (int j = 0; j < 100; j++) {
                        User user = new User(
                            "concurrent" + threadId + "_" + j + "@example.com",
                            "Concurrent User " + threadId + "_" + j,
                            "password"
                        );
                        userRepository.save(user);
                        successCount.incrementAndGet();
                    }
                } finally {
                    latch.countDown();
                }
            }).start();
        }
        
        assertTrue(latch.await(30, TimeUnit.SECONDS));
        assertEquals(numberOfThreads * 100, successCount.get());
    }
}
```

### Response Time Testing

#### API Response Time Test
```java
@SpringBootTest(webEnvironment = SpringBootTest.WebEnvironment.RANDOM_PORT)
public class ApiResponseTimeTest {
    
    @Autowired
    private TestRestTemplate restTemplate;
    
    @Test
    @DisplayName("API endpoints should respond within acceptable time")
    void testApiResponseTimes() {
        // Test user creation response time
        UserRequest request = new UserRequest("test@example.com", "Test User", "password");
        
        long startTime = System.currentTimeMillis();
        ResponseEntity<UserResponse> response = restTemplate.postForEntity(
            "/api/users", request, UserResponse.class
        );
        long endTime = System.currentTimeMillis();
        
        long responseTime = endTime - startTime;
        assertTrue(responseTime < 500, "User creation took too long: " + responseTime + "ms");
        assertEquals(HttpStatus.CREATED, response.getStatusCode());
        
        // Test user retrieval response time
        String userId = response.getBody().getId();
        
        startTime = System.currentTimeMillis();
        ResponseEntity<UserResponse> getResponse = restTemplate.getForEntity(
            "/api/users/" + userId, UserResponse.class
        );
        endTime = System.currentTimeMillis();
        
        responseTime = endTime - startTime;
        assertTrue(responseTime < 200, "User retrieval took too long: " + responseTime + "ms");
        assertEquals(HttpStatus.OK, getResponse.getStatusCode());
    }
}
```

## 🔍 Performance Testing Metrics

### Key Performance Indicators
- **Response Time**: Time to complete a request
- **Throughput**: Requests processed per second
- **Resource Utilization**: CPU, memory, disk usage
- **Error Rate**: Percentage of failed requests
- **Concurrent Users**: Number of simultaneous users

### Performance Benchmarks
```java
public class PerformanceBenchmarks {
    
    public static final int MAX_RESPONSE_TIME_MS = 500;
    public static final int MIN_THROUGHPUT_RPS = 100;
    public static final double MAX_ERROR_RATE = 0.01; // 1%
    public static final int MAX_MEMORY_USAGE_MB = 512;
    
    @Test
    void testPerformanceBenchmarks() {
        PerformanceMetrics metrics = runPerformanceTest();
        
        assertTrue(metrics.getAverageResponseTime() < MAX_RESPONSE_TIME_MS,
            "Response time exceeds benchmark");
        assertTrue(metrics.getThroughput() > MIN_THROUGHPUT_RPS,
            "Throughput below benchmark");
        assertTrue(metrics.getErrorRate() < MAX_ERROR_RATE,
            "Error rate exceeds benchmark");
        assertTrue(metrics.getMemoryUsage() < MAX_MEMORY_USAGE_MB,
            "Memory usage exceeds benchmark");
    }
}
```

## 💡 Learning Points
- Performance testing validates system behavior under load
- Monitor multiple metrics: response time, throughput, resource usage
- Test both normal and peak load conditions
- Use realistic test data and scenarios
- Set clear performance benchmarks and SLAs

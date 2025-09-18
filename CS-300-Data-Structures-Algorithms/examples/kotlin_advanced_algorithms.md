# CS-300 Kotlin Advanced Algorithms Examples

## 🎯 Purpose
Demonstrate advanced algorithms and data structures in Kotlin including dynamic programming, greedy algorithms, and advanced tree algorithms.

## 📝 Kotlin Advanced Algorithm Examples

### Dynamic Programming - Fibonacci
```kotlin
// Naive recursive Fibonacci (exponential time)
fun fibonacciNaive(n: Int): Long {
    return when (n) {
        0, 1 -> n.toLong()
        else -> fibonacciNaive(n - 1) + fibonacciNaive(n - 2)
    }
}

// Memoized Fibonacci (linear time)
fun fibonacciMemo(n: Int): Long {
    val memo = mutableMapOf<Int, Long>()
    
    fun fib(n: Int): Long {
        if (n in memo) return memo[n]!!
        if (n <= 1) return n.toLong()
        
        memo[n] = fib(n - 1) + fib(n - 2)
        return memo[n]!!
    }
    
    return fib(n)
}

// Bottom-up Fibonacci (linear time, O(1) space)
fun fibonacciDP(n: Int): Long {
    if (n <= 1) return n.toLong()
    
    var prev2 = 0L
    var prev1 = 1L
    
    for (i in 2..n) {
        val current = prev1 + prev2
        prev2 = prev1
        prev1 = current
    }
    
    return prev1
}

// Matrix exponentiation Fibonacci (O(log n) time)
fun fibonacciMatrix(n: Int): Long {
    if (n <= 1) return n.toLong()
    
    fun matrixMultiply(a: Array<LongArray>, b: Array<LongArray>): Array<LongArray> {
        val result = Array(2) { LongArray(2) }
        for (i in 0..1) {
            for (j in 0..1) {
                for (k in 0..1) {
                    result[i][j] += a[i][k] * b[k][j]
                }
            }
        }
        return result
    }
    
    fun matrixPower(matrix: Array<LongArray>, power: Int): Array<LongArray> {
        if (power == 1) return matrix
        
        val half = matrixPower(matrix, power / 2)
        val result = matrixMultiply(half, half)
        
        return if (power % 2 == 0) result else matrixMultiply(result, matrix)
    }
    
    val baseMatrix = arrayOf(
        longArrayOf(1, 1),
        longArrayOf(1, 0)
    )
    
    val resultMatrix = matrixPower(baseMatrix, n - 1)
    return resultMatrix[0][0]
}
```

### Dynamic Programming - Longest Common Subsequence
```kotlin
fun longestCommonSubsequence(text1: String, text2: String): Int {
    val m = text1.length
    val n = text2.length
    val dp = Array(m + 1) { IntArray(n + 1) }
    
    for (i in 1..m) {
        for (j in 1..n) {
            if (text1[i - 1] == text2[j - 1]) {
                dp[i][j] = dp[i - 1][j - 1] + 1
            } else {
                dp[i][j] = maxOf(dp[i - 1][j], dp[i][j - 1])
            }
        }
    }
    
    return dp[m][n]
}

// Get the actual LCS string
fun getLCSString(text1: String, text2: String): String {
    val m = text1.length
    val n = text2.length
    val dp = Array(m + 1) { IntArray(n + 1) }
    
    // Build DP table
    for (i in 1..m) {
        for (j in 1..n) {
            if (text1[i - 1] == text2[j - 1]) {
                dp[i][j] = dp[i - 1][j - 1] + 1
            } else {
                dp[i][j] = maxOf(dp[i - 1][j], dp[i][j - 1])
            }
        }
    }
    
    // Reconstruct LCS
    val lcs = StringBuilder()
    var i = m
    var j = n
    
    while (i > 0 && j > 0) {
        if (text1[i - 1] == text2[j - 1]) {
            lcs.append(text1[i - 1])
            i--
            j--
        } else if (dp[i - 1][j] > dp[i][j - 1]) {
            i--
        } else {
            j--
        }
    }
    
    return lcs.reverse().toString()
}
```

### Dynamic Programming - Knapsack Problem
```kotlin
data class Item(val weight: Int, val value: Int)

// 0/1 Knapsack Problem
fun knapsack01(items: List<Item>, capacity: Int): Int {
    val n = items.size
    val dp = Array(n + 1) { IntArray(capacity + 1) }
    
    for (i in 1..n) {
        for (w in 1..capacity) {
            val item = items[i - 1]
            
            if (item.weight <= w) {
                dp[i][w] = maxOf(
                    dp[i - 1][w], // Don't take item
                    dp[i - 1][w - item.weight] + item.value // Take item
                )
            } else {
                dp[i][w] = dp[i - 1][w]
            }
        }
    }
    
    return dp[n][capacity]
}

// Get items selected in optimal solution
fun getKnapsackItems(items: List<Item>, capacity: Int): List<Item> {
    val n = items.size
    val dp = Array(n + 1) { IntArray(capacity + 1) }
    
    // Build DP table
    for (i in 1..n) {
        for (w in 1..capacity) {
            val item = items[i - 1]
            
            if (item.weight <= w) {
                dp[i][w] = maxOf(
                    dp[i - 1][w],
                    dp[i - 1][w - item.weight] + item.value
                )
            } else {
                dp[i][w] = dp[i - 1][w]
            }
        }
    }
    
    // Reconstruct solution
    val selectedItems = mutableListOf<Item>()
    var i = n
    var w = capacity
    
    while (i > 0 && w > 0) {
        if (dp[i][w] != dp[i - 1][w]) {
            selectedItems.add(items[i - 1])
            w -= items[i - 1].weight
        }
        i--
    }
    
    return selectedItems
}

// Unbounded Knapsack Problem
fun knapsackUnbounded(items: List<Item>, capacity: Int): Int {
    val dp = IntArray(capacity + 1)
    
    for (w in 1..capacity) {
        for (item in items) {
            if (item.weight <= w) {
                dp[w] = maxOf(dp[w], dp[w - item.weight] + item.value)
            }
        }
    }
    
    return dp[capacity]
}
```

### Greedy Algorithms - Activity Selection
```kotlin
data class Activity(val start: Int, val end: Int, val name: String)

// Activity Selection Problem
fun selectActivities(activities: List<Activity>): List<Activity> {
    // Sort activities by end time
    val sortedActivities = activities.sortedBy { it.end }
    val selected = mutableListOf<Activity>()
    
    if (sortedActivities.isNotEmpty()) {
        selected.add(sortedActivities[0])
        var lastEndTime = sortedActivities[0].end
        
        for (i in 1 until sortedActivities.size) {
            val activity = sortedActivities[i]
            if (activity.start >= lastEndTime) {
                selected.add(activity)
                lastEndTime = activity.end
            }
        }
    }
    
    return selected
}

// Fractional Knapsack Problem
fun fractionalKnapsack(items: List<Item>, capacity: Int): Double {
    // Sort items by value per weight ratio (descending)
    val sortedItems = items.sortedByDescending { it.value.toDouble() / it.weight }
    
    var totalValue = 0.0
    var remainingCapacity = capacity
    
    for (item in sortedItems) {
        if (remainingCapacity >= item.weight) {
            // Take the whole item
            totalValue += item.value
            remainingCapacity -= item.weight
        } else {
            // Take fraction of the item
            val fraction = remainingCapacity.toDouble() / item.weight
            totalValue += item.value * fraction
            break
        }
    }
    
    return totalValue
}
```

### Greedy Algorithms - Huffman Coding
```kotlin
data class HuffmanNode(
    val char: Char? = null,
    val frequency: Int,
    val left: HuffmanNode? = null,
    val right: HuffmanNode? = null
) : Comparable<HuffmanNode> {
    override fun compareTo(other: HuffmanNode): Int {
        return frequency.compareTo(other.frequency)
    }
}

class HuffmanCoding {
    fun buildHuffmanTree(text: String): HuffmanNode {
        // Count character frequencies
        val frequencies = text.groupingBy { it }.eachCount()
        
        // Create priority queue (min heap)
        val pq = java.util.PriorityQueue<HuffmanNode>()
        
        for ((char, freq) in frequencies) {
            pq.offer(HuffmanNode(char, freq))
        }
        
        // Build Huffman tree
        while (pq.size > 1) {
            val left = pq.poll()
            val right = pq.poll()
            
            val merged = HuffmanNode(
                frequency = left.frequency + right.frequency,
                left = left,
                right = right
            )
            
            pq.offer(merged)
        }
        
        return pq.poll()
    }
    
    fun buildHuffmanCodes(root: HuffmanNode): Map<Char, String> {
        val codes = mutableMapOf<Char, String>()
        
        fun buildCodes(node: HuffmanNode, code: String) {
            if (node.char != null) {
                codes[node.char] = code
            } else {
                node.left?.let { buildCodes(it, code + "0") }
                node.right?.let { buildCodes(it, code + "1") }
            }
        }
        
        buildCodes(root, "")
        return codes
    }
    
    fun encode(text: String, codes: Map<Char, String>): String {
        return text.map { codes[it] ?: "" }.joinToString("")
    }
    
    fun decode(encodedText: String, root: HuffmanNode): String {
        val result = StringBuilder()
        var current = root
        
        for (bit in encodedText) {
            current = if (bit == '0') current.left!! else current.right!!
            
            if (current.char != null) {
                result.append(current.char)
                current = root
            }
        }
        
        return result.toString()
    }
}
```

### Advanced Tree Algorithms - Trie
```kotlin
class TrieNode {
    val children = mutableMapOf<Char, TrieNode>()
    var isEndOfWord = false
}

class Trie {
    private val root = TrieNode()
    
    fun insert(word: String) {
        var current = root
        
        for (char in word) {
            current = current.children.getOrPut(char) { TrieNode() }
        }
        
        current.isEndOfWord = true
    }
    
    fun search(word: String): Boolean {
        var current = root
        
        for (char in word) {
            current = current.children[char] ?: return false
        }
        
        return current.isEndOfWord
    }
    
    fun startsWith(prefix: String): Boolean {
        var current = root
        
        for (char in prefix) {
            current = current.children[char] ?: return false
        }
        
        return true
    }
    
    fun getAllWordsWithPrefix(prefix: String): List<String> {
        var current = root
        
        // Navigate to prefix node
        for (char in prefix) {
            current = current.children[char] ?: return emptyList()
        }
        
        val words = mutableListOf<String>()
        collectWords(current, prefix, words)
        return words
    }
    
    private fun collectWords(node: TrieNode, currentWord: String, words: MutableList<String>) {
        if (node.isEndOfWord) {
            words.add(currentWord)
        }
        
        for ((char, child) in node.children) {
            collectWords(child, currentWord + char, words)
        }
    }
    
    fun delete(word: String): Boolean {
        return deleteRecursive(root, word, 0)
    }
    
    private fun deleteRecursive(node: TrieNode, word: String, index: Int): Boolean {
        if (index == word.length) {
            if (!node.isEndOfWord) return false
            node.isEndOfWord = false
            return node.children.isEmpty()
        }
        
        val char = word[index]
        val child = node.children[char] ?: return false
        
        val shouldDeleteChild = deleteRecursive(child, word, index + 1)
        
        if (shouldDeleteChild) {
            node.children.remove(char)
            return node.children.isEmpty() && !node.isEndOfWord
        }
        
        return false
    }
}
```

### Advanced Tree Algorithms - Segment Tree
```kotlin
class SegmentTree(private val arr: IntArray) {
    private val tree = IntArray(4 * arr.size)
    
    init {
        build(0, 0, arr.size - 1)
    }
    
    private fun build(node: Int, start: Int, end: Int) {
        if (start == end) {
            tree[node] = arr[start]
        } else {
            val mid = (start + end) / 2
            build(2 * node + 1, start, mid)
            build(2 * node + 2, mid + 1, end)
            tree[node] = tree[2 * node + 1] + tree[2 * node + 2]
        }
    }
    
    fun update(index: Int, value: Int) {
        updateRecursive(0, 0, arr.size - 1, index, value)
    }
    
    private fun updateRecursive(node: Int, start: Int, end: Int, index: Int, value: Int) {
        if (start == end) {
            arr[index] = value
            tree[node] = value
        } else {
            val mid = (start + end) / 2
            if (index <= mid) {
                updateRecursive(2 * node + 1, start, mid, index, value)
            } else {
                updateRecursive(2 * node + 2, mid + 1, end, index, value)
            }
            tree[node] = tree[2 * node + 1] + tree[2 * node + 2]
        }
    }
    
    fun query(left: Int, right: Int): Int {
        return queryRecursive(0, 0, arr.size - 1, left, right)
    }
    
    private fun queryRecursive(node: Int, start: Int, end: Int, left: Int, right: Int): Int {
        if (right < start || left > end) {
            return 0
        }
        
        if (left <= start && end <= right) {
            return tree[node]
        }
        
        val mid = (start + end) / 2
        val leftSum = queryRecursive(2 * node + 1, start, mid, left, right)
        val rightSum = queryRecursive(2 * node + 2, mid + 1, end, left, right)
        
        return leftSum + rightSum
    }
}
```

### Performance Testing
```kotlin
fun main() {
    // Test Fibonacci algorithms
    val n = 40
    println("Testing Fibonacci algorithms with n = $n")
    
    val start1 = System.nanoTime()
    val result1 = fibonacciDP(n)
    val time1 = (System.nanoTime() - start1) / 1_000_000
    println("DP Fibonacci: $result1 (${time1}ms)")
    
    val start2 = System.nanoTime()
    val result2 = fibonacciMatrix(n)
    val time2 = (System.nanoTime() - start2) / 1_000_000
    println("Matrix Fibonacci: $result2 (${time2}ms)")
    
    // Test LCS
    val text1 = "ABCDGH"
    val text2 = "AEDFHR"
    val lcsLength = longestCommonSubsequence(text1, text2)
    val lcsString = getLCSString(text1, text2)
    println("\nLCS of '$text1' and '$text2': $lcsString (length: $lcsLength)")
    
    // Test Knapsack
    val items = listOf(
        Item(10, 60),
        Item(20, 100),
        Item(30, 120)
    )
    val capacity = 50
    val maxValue = knapsack01(items, capacity)
    val selectedItems = getKnapsackItems(items, capacity)
    println("\nKnapsack (capacity: $capacity):")
    println("Max value: $maxValue")
    println("Selected items: $selectedItems")
    
    // Test Activity Selection
    val activities = listOf(
        Activity(1, 3, "A"),
        Activity(2, 5, "B"),
        Activity(0, 6, "C"),
        Activity(5, 7, "D"),
        Activity(8, 9, "E"),
        Activity(5, 9, "F")
    )
    val selectedActivities = selectActivities(activities)
    println("\nSelected activities: ${selectedActivities.map { it.name }}")
    
    // Test Trie
    val trie = Trie()
    val words = listOf("apple", "app", "application", "apply", "banana", "band")
    words.forEach { trie.insert(it) }
    
    println("\nTrie operations:")
    println("Search 'app': ${trie.search("app")}")
    println("Search 'apps': ${trie.search("apps")}")
    println("StartsWith 'app': ${trie.startsWith("app")}")
    println("Words with prefix 'app': ${trie.getAllWordsWithPrefix("app")}")
    
    // Test Segment Tree
    val arr = intArrayOf(1, 3, 5, 7, 9, 11)
    val segmentTree = SegmentTree(arr)
    
    println("\nSegment Tree operations:")
    println("Sum [1, 3]: ${segmentTree.query(1, 3)}")
    println("Sum [0, 5]: ${segmentTree.query(0, 5)}")
    
    segmentTree.update(1, 10)
    println("After updating index 1 to 10:")
    println("Sum [1, 3]: ${segmentTree.query(1, 3)}")
}
```

## 🔍 Algorithm Complexity Analysis

| Algorithm | Time Complexity | Space Complexity | Notes |
|-----------|----------------|------------------|-------|
| Fibonacci (Naive) | O(2^n) | O(n) | Exponential, not practical |
| Fibonacci (DP) | O(n) | O(1) | Linear time, constant space |
| Fibonacci (Matrix) | O(log n) | O(1) | Fastest for large n |
| LCS | O(m×n) | O(m×n) | Dynamic programming |
| 0/1 Knapsack | O(n×W) | O(n×W) | W = capacity |
| Activity Selection | O(n log n) | O(1) | Greedy algorithm |
| Huffman Coding | O(n log n) | O(n) | Priority queue based |
| Trie Operations | O(m) | O(ALPHABET_SIZE×N×M) | m = word length |
| Segment Tree | O(log n) | O(n) | Range queries/updates |

## 💡 Learning Points
- **Dynamic Programming** solves problems by breaking them into overlapping subproblems
- **Memoization** stores results of expensive function calls
- **Greedy algorithms** make locally optimal choices at each step
- **Trie** provides efficient string operations and prefix matching
- **Segment Tree** enables efficient range queries and updates
- **Time-space tradeoffs** are common in algorithm design
- **Problem decomposition** is key to solving complex algorithms
- **Data structure choice** significantly affects algorithm performance

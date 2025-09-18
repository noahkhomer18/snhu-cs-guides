# CS-300 Kotlin String Algorithms Examples

## 🎯 Purpose
Demonstrate string processing algorithms in Kotlin including pattern matching, string manipulation, and text processing algorithms.

## 📝 Kotlin String Algorithm Examples

### Pattern Matching - Naive String Search
```kotlin
class StringSearch {
    // Naive string search algorithm
    fun naiveSearch(text: String, pattern: String): List<Int> {
        val occurrences = mutableListOf<Int>()
        val textLength = text.length
        val patternLength = pattern.length
        
        for (i in 0..textLength - patternLength) {
            var j = 0
            while (j < patternLength && text[i + j] == pattern[j]) {
                j++
            }
            if (j == patternLength) {
                occurrences.add(i)
            }
        }
        
        return occurrences
    }
    
    // Naive search with early termination
    fun naiveSearchOptimized(text: String, pattern: String): List<Int> {
        val occurrences = mutableListOf<Int>()
        val textLength = text.length
        val patternLength = pattern.length
        
        for (i in 0..textLength - patternLength) {
            var match = true
            for (j in 0 until patternLength) {
                if (text[i + j] != pattern[j]) {
                    match = false
                    break
                }
            }
            if (match) {
                occurrences.add(i)
            }
        }
        
        return occurrences
    }
}
```

### Knuth-Morris-Pratt (KMP) Algorithm
```kotlin
class KMPAlgorithm {
    // Build failure function (LPS array)
    private fun buildFailureFunction(pattern: String): IntArray {
        val lps = IntArray(pattern.length)
        var len = 0
        var i = 1
        
        while (i < pattern.length) {
            if (pattern[i] == pattern[len]) {
                len++
                lps[i] = len
                i++
            } else {
                if (len != 0) {
                    len = lps[len - 1]
                } else {
                    lps[i] = 0
                    i++
                }
            }
        }
        
        return lps
    }
    
    // KMP pattern matching
    fun kmpSearch(text: String, pattern: String): List<Int> {
        val occurrences = mutableListOf<Int>()
        val lps = buildFailureFunction(pattern)
        val textLength = text.length
        val patternLength = pattern.length
        
        var i = 0 // Index for text
        var j = 0 // Index for pattern
        
        while (i < textLength) {
            if (pattern[j] == text[i]) {
                i++
                j++
            }
            
            if (j == patternLength) {
                occurrences.add(i - j)
                j = lps[j - 1]
            } else if (i < textLength && pattern[j] != text[i]) {
                if (j != 0) {
                    j = lps[j - 1]
                } else {
                    i++
                }
            }
        }
        
        return occurrences
    }
    
    // Count occurrences using KMP
    fun countOccurrences(text: String, pattern: String): Int {
        return kmpSearch(text, pattern).size
    }
}
```

### Rabin-Karp Algorithm
```kotlin
class RabinKarpAlgorithm {
    private val base = 256
    private val prime = 101
    
    // Calculate hash value for a string
    private fun calculateHash(str: String, length: Int): Long {
        var hash = 0L
        for (i in 0 until length) {
            hash = (hash * base + str[i].code) % prime
        }
        return hash
    }
    
    // Recalculate hash for rolling window
    private fun recalculateHash(
        oldHash: Long,
        oldChar: Char,
        newChar: Char,
        patternLength: Int
    ): Long {
        var hash = oldHash
        hash = (hash + prime - (oldChar.code * power(base, patternLength - 1, prime)) % prime) % prime
        hash = (hash * base + newChar.code) % prime
        return hash
    }
    
    // Modular exponentiation
    private fun power(base: Int, exponent: Int, mod: Int): Long {
        var result = 1L
        var b = base.toLong()
        var exp = exponent
        
        while (exp > 0) {
            if (exp % 2 == 1) {
                result = (result * b) % mod
            }
            b = (b * b) % mod
            exp /= 2
        }
        
        return result
    }
    
    // Rabin-Karp pattern matching
    fun rabinKarpSearch(text: String, pattern: String): List<Int> {
        val occurrences = mutableListOf<Int>()
        val textLength = text.length
        val patternLength = pattern.length
        
        if (patternLength > textLength) return occurrences
        
        val patternHash = calculateHash(pattern, patternLength)
        var textHash = calculateHash(text, patternLength)
        
        // Check first window
        if (patternHash == textHash && text.substring(0, patternLength) == pattern) {
            occurrences.add(0)
        }
        
        // Check remaining windows
        for (i in 1..textLength - patternLength) {
            textHash = recalculateHash(
                textHash,
                text[i - 1],
                text[i + patternLength - 1],
                patternLength
            )
            
            if (patternHash == textHash && text.substring(i, i + patternLength) == pattern) {
                occurrences.add(i)
            }
        }
        
        return occurrences
    }
}
```

### Boyer-Moore Algorithm
```kotlin
class BoyerMooreAlgorithm {
    // Build bad character table
    private fun buildBadCharTable(pattern: String): Map<Char, Int> {
        val badChar = mutableMapOf<Char, Int>()
        val patternLength = pattern.length
        
        for (i in 0 until patternLength - 1) {
            badChar[pattern[i]] = patternLength - 1 - i
        }
        
        return badChar
    }
    
    // Build good suffix table
    private fun buildGoodSuffixTable(pattern: String): IntArray {
        val patternLength = pattern.length
        val goodSuffix = IntArray(patternLength)
        val suffix = IntArray(patternLength)
        
        // Build suffix array
        suffix[patternLength - 1] = patternLength
        var j = patternLength - 1
        
        for (i in patternLength - 2 downTo 0) {
            if (j < patternLength - 1 && suffix[patternLength - 1 - j + i] < i - j) {
                suffix[i] = suffix[patternLength - 1 - j + i]
            } else {
                j = i
                while (j >= 0 && pattern[j] == pattern[patternLength - 1 - i + j]) {
                    j--
                }
                suffix[i] = i - j
            }
        }
        
        // Build good suffix array
        for (i in 0 until patternLength) {
            goodSuffix[i] = patternLength
        }
        
        var j = 0
        for (i in patternLength - 1 downTo 0) {
            if (suffix[i] == i + 1) {
                while (j < patternLength - 1 - i) {
                    if (goodSuffix[j] == patternLength) {
                        goodSuffix[j] = patternLength - 1 - i
                    }
                    j++
                }
            }
        }
        
        for (i in 0 until patternLength - 1) {
            goodSuffix[patternLength - 1 - suffix[i]] = patternLength - 1 - i
        }
        
        return goodSuffix
    }
    
    // Boyer-Moore pattern matching
    fun boyerMooreSearch(text: String, pattern: String): List<Int> {
        val occurrences = mutableListOf<Int>()
        val textLength = text.length
        val patternLength = pattern.length
        
        if (patternLength > textLength) return occurrences
        
        val badChar = buildBadCharTable(pattern)
        val goodSuffix = buildGoodSuffixTable(pattern)
        
        var i = 0
        while (i <= textLength - patternLength) {
            var j = patternLength - 1
            
            // Match from right to left
            while (j >= 0 && pattern[j] == text[i + j]) {
                j--
            }
            
            if (j < 0) {
                // Pattern found
                occurrences.add(i)
                i += goodSuffix[0]
            } else {
                // Shift based on bad character and good suffix rules
                val badCharShift = badChar[text[i + j]] ?: patternLength
                val goodSuffixShift = goodSuffix[j]
                i += maxOf(badCharShift, goodSuffixShift)
            }
        }
        
        return occurrences
    }
}
```

### String Manipulation Algorithms
```kotlin
class StringManipulation {
    // Reverse string
    fun reverseString(str: String): String {
        return str.reversed()
    }
    
    // Reverse string in-place (for mutable strings)
    fun reverseStringInPlace(str: StringBuilder): StringBuilder {
        var left = 0
        var right = str.length - 1
        
        while (left < right) {
            val temp = str[left]
            str[left] = str[right]
            str[right] = temp
            left++
            right--
        }
        
        return str
    }
    
    // Check if string is palindrome
    fun isPalindrome(str: String): Boolean {
        val cleaned = str.lowercase().filter { it.isLetterOrDigit() }
        var left = 0
        var right = cleaned.length - 1
        
        while (left < right) {
            if (cleaned[left] != cleaned[right]) {
                return false
            }
            left++
            right--
        }
        
        return true
    }
    
    // Find longest common prefix
    fun longestCommonPrefix(strings: List<String>): String {
        if (strings.isEmpty()) return ""
        if (strings.size == 1) return strings[0]
        
        var prefix = strings[0]
        
        for (i in 1 until strings.size) {
            while (!strings[i].startsWith(prefix)) {
                prefix = prefix.dropLast(1)
                if (prefix.isEmpty()) return ""
            }
        }
        
        return prefix
    }
    
    // Find longest common subsequence (already covered in advanced algorithms)
    fun longestCommonSubsequence(str1: String, str2: String): String {
        val m = str1.length
        val n = str2.length
        val dp = Array(m + 1) { IntArray(n + 1) }
        
        // Build DP table
        for (i in 1..m) {
            for (j in 1..n) {
                if (str1[i - 1] == str2[j - 1]) {
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
            if (str1[i - 1] == str2[j - 1]) {
                lcs.append(str1[i - 1])
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
}
```

### String Compression Algorithms
```kotlin
class StringCompression {
    // Run-length encoding
    fun runLengthEncoding(str: String): String {
        if (str.isEmpty()) return ""
        
        val result = StringBuilder()
        var count = 1
        var current = str[0]
        
        for (i in 1 until str.length) {
            if (str[i] == current) {
                count++
            } else {
                result.append(current).append(count)
                current = str[i]
                count = 1
            }
        }
        
        result.append(current).append(count)
        return result.toString()
    }
    
    // Decode run-length encoding
    fun runLengthDecoding(encoded: String): String {
        val result = StringBuilder()
        var i = 0
        
        while (i < encoded.length) {
            val char = encoded[i]
            i++
            
            var count = 0
            while (i < encoded.length && encoded[i].isDigit()) {
                count = count * 10 + (encoded[i] - '0')
                i++
            }
            
            repeat(count) {
                result.append(char)
            }
        }
        
        return result.toString()
    }
    
    // Compress string by removing consecutive duplicates
    fun compressString(str: String): String {
        if (str.isEmpty()) return ""
        
        val result = StringBuilder()
        var count = 1
        var current = str[0]
        
        for (i in 1 until str.length) {
            if (str[i] == current) {
                count++
            } else {
                result.append(current)
                if (count > 1) {
                    result.append(count)
                }
                current = str[i]
                count = 1
            }
        }
        
        result.append(current)
        if (count > 1) {
            result.append(count)
        }
        
        return result.toString()
    }
}
```

### Anagram Detection
```kotlin
class AnagramDetection {
    // Check if two strings are anagrams (sorting approach)
    fun areAnagrams(str1: String, str2: String): Boolean {
        if (str1.length != str2.length) return false
        
        val sorted1 = str1.lowercase().toCharArray().sorted()
        val sorted2 = str2.lowercase().toCharArray().sorted()
        
        return sorted1 == sorted2
    }
    
    // Check if two strings are anagrams (character counting approach)
    fun areAnagramsCounting(str1: String, str2: String): Boolean {
        if (str1.length != str2.length) return false
        
        val charCount = IntArray(26) // Assuming lowercase English letters
        
        for (char in str1.lowercase()) {
            if (char.isLetter()) {
                charCount[char - 'a']++
            }
        }
        
        for (char in str2.lowercase()) {
            if (char.isLetter()) {
                charCount[char - 'a']--
            }
        }
        
        return charCount.all { it == 0 }
    }
    
    // Find all anagrams of a string
    fun findAllAnagrams(str: String, wordList: List<String>): List<String> {
        return wordList.filter { areAnagrams(str, it) }
    }
    
    // Group anagrams together
    fun groupAnagrams(words: List<String>): List<List<String>> {
        val groups = mutableMapOf<String, MutableList<String>>()
        
        for (word in words) {
            val key = word.lowercase().toCharArray().sorted().joinToString("")
            groups.getOrPut(key) { mutableListOf() }.add(word)
        }
        
        return groups.values.toList()
    }
}
```

### Performance Testing
```kotlin
fun main() {
    val text = "ABABDABACDABABCABAB"
    val pattern = "ABABCABAB"
    
    println("Text: $text")
    println("Pattern: $pattern")
    println()
    
    // Test different string search algorithms
    val naive = StringSearch()
    val kmp = KMPAlgorithm()
    val rabinKarp = RabinKarpAlgorithm()
    val boyerMoore = BoyerMooreAlgorithm()
    
    println("Naive Search: ${naive.naiveSearch(text, pattern)}")
    println("KMP Search: ${kmp.kmpSearch(text, pattern)}")
    println("Rabin-Karp Search: ${rabinKarp.rabinKarpSearch(text, pattern)}")
    println("Boyer-Moore Search: ${boyerMoore.boyerMooreSearch(text, pattern)}")
    println()
    
    // Test string manipulation
    val manipulation = StringManipulation()
    val testString = "Hello World"
    
    println("Original: $testString")
    println("Reversed: ${manipulation.reverseString(testString)}")
    println("Is palindrome 'racecar': ${manipulation.isPalindrome("racecar")}")
    println("Is palindrome 'hello': ${manipulation.isPalindrome("hello")}")
    
    val strings = listOf("flower", "flow", "flight")
    println("Longest common prefix: ${manipulation.longestCommonPrefix(strings)}")
    println()
    
    // Test string compression
    val compression = StringCompression()
    val originalText = "AAAABBBCCDAA"
    val encoded = compression.runLengthEncoding(originalText)
    val decoded = compression.runLengthDecoding(encoded)
    
    println("Original: $originalText")
    println("Encoded: $encoded")
    println("Decoded: $decoded")
    println()
    
    // Test anagram detection
    val anagram = AnagramDetection()
    val word1 = "listen"
    val word2 = "silent"
    val word3 = "hello"
    
    println("'$word1' and '$word2' are anagrams: ${anagram.areAnagrams(word1, word2)}")
    println("'$word1' and '$word3' are anagrams: ${anagram.areAnagrams(word1, word3)}")
    
    val words = listOf("eat", "tea", "tan", "ate", "nat", "bat")
    val grouped = anagram.groupAnagrams(words)
    println("Grouped anagrams: $grouped")
}
```

## 🔍 String Algorithm Complexity

| Algorithm | Time Complexity | Space Complexity | Notes |
|-----------|----------------|------------------|-------|
| Naive Search | O(mn) | O(1) | m = text length, n = pattern length |
| KMP | O(m + n) | O(n) | Linear time, preprocesses pattern |
| Rabin-Karp | O(m + n) | O(1) | Average case, uses rolling hash |
| Boyer-Moore | O(m + n) | O(n) | Best case O(m/n), worst case O(mn) |
| String Reversal | O(n) | O(1) | In-place reversal |
| Palindrome Check | O(n) | O(1) | Two-pointer approach |
| LCS | O(mn) | O(mn) | Dynamic programming |
| Run-length Encoding | O(n) | O(n) | Linear scan |

## 💡 Learning Points
- **Pattern matching** algorithms have different trade-offs
- **KMP algorithm** uses failure function to avoid redundant comparisons
- **Rabin-Karp** uses rolling hash for efficient substring matching
- **Boyer-Moore** skips characters using bad character and good suffix rules
- **String manipulation** often involves two-pointer techniques
- **Compression algorithms** exploit patterns in data
- **Anagram detection** can use sorting or character counting
- **Space-time tradeoffs** are common in string algorithms
- **Preprocessing** can improve pattern matching performance

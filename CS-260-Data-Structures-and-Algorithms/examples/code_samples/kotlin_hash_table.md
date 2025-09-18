# CS-260 Kotlin Hash Table Implementation

## 🎯 Purpose
Demonstrate hash table data structure implementation in Kotlin with various collision resolution strategies.

## 📝 Kotlin Hash Table Examples

### Basic Hash Table with Chaining
```kotlin
// Node for chaining
class HashNode<K, V>(val key: K, var value: V) {
    var next: HashNode<K, V>? = null
}

// Hash Table with separate chaining
class HashTable<K, V>(private val initialCapacity: Int = 16) {
    private var table: Array<HashNode<K, V>?> = arrayOfNulls(initialCapacity)
    private var size = 0
    private val loadFactor = 0.75
    
    // Hash function
    private fun hash(key: K): Int {
        return key.hashCode() and 0x7FFFFFFF % table.size
    }
    
    // Insert key-value pair
    fun put(key: K, value: V) {
        val index = hash(key)
        var current = table[index]
        
        // Check if key already exists
        while (current != null) {
            if (current.key == key) {
                current.value = value
                return
            }
            current = current.next
        }
        
        // Add new node at beginning of chain
        val newNode = HashNode(key, value)
        newNode.next = table[index]
        table[index] = newNode
        size++
        
        // Resize if load factor exceeded
        if (size > table.size * loadFactor) {
            resize()
        }
    }
    
    // Get value by key
    fun get(key: K): V? {
        val index = hash(key)
        var current = table[index]
        
        while (current != null) {
            if (current.key == key) {
                return current.value
            }
            current = current.next
        }
        
        return null
    }
    
    // Remove key-value pair
    fun remove(key: K): V? {
        val index = hash(key)
        var current = table[index]
        var prev: HashNode<K, V>? = null
        
        while (current != null) {
            if (current.key == key) {
                if (prev == null) {
                    table[index] = current.next
                } else {
                    prev.next = current.next
                }
                size--
                return current.value
            }
            prev = current
            current = current.next
        }
        
        return null
    }
    
    // Check if key exists
    fun containsKey(key: K): Boolean {
        return get(key) != null
    }
    
    // Get all keys
    fun keys(): List<K> {
        val keyList = mutableListOf<K>()
        for (bucket in table) {
            var current = bucket
            while (current != null) {
                keyList.add(current.key)
                current = current.next
            }
        }
        return keyList
    }
    
    // Get all values
    fun values(): List<V> {
        val valueList = mutableListOf<V>()
        for (bucket in table) {
            var current = bucket
            while (current != null) {
                valueList.add(current.value)
                current = current.next
            }
        }
        return valueList
    }
    
    // Get size
    fun size(): Int = size
    
    // Check if empty
    fun isEmpty(): Boolean = size == 0
    
    // Resize table
    private fun resize() {
        val oldTable = table
        table = arrayOfNulls(table.size * 2)
        size = 0
        
        for (bucket in oldTable) {
            var current = bucket
            while (current != null) {
                put(current.key, current.value)
                current = current.next
            }
        }
    }
    
    // Print table structure
    fun printTable() {
        for (i in table.indices) {
            print("Bucket $i: ")
            var current = table[i]
            while (current != null) {
                print("(${current.key}, ${current.value}) ")
                current = current.next
            }
            println()
        }
    }
}
```

### Hash Table with Linear Probing
```kotlin
// Entry class for open addressing
class HashEntry<K, V>(val key: K, var value: V) {
    var isDeleted = false
}

// Hash Table with linear probing
class LinearProbingHashTable<K, V>(private val initialCapacity: Int = 16) {
    private var table: Array<HashEntry<K, V>?> = arrayOfNulls(initialCapacity)
    private var size = 0
    private val loadFactor = 0.5
    
    // Hash function
    private fun hash(key: K): Int {
        return key.hashCode() and 0x7FFFFFFF % table.size
    }
    
    // Find slot for key
    private fun findSlot(key: K): Int {
        var index = hash(key)
        var originalIndex = index
        
        while (table[index] != null && !table[index]!!.isDeleted) {
            if (table[index]!!.key == key) {
                return index
            }
            index = (index + 1) % table.size
            if (index == originalIndex) {
                throw IllegalStateException("Hash table is full")
            }
        }
        
        return index
    }
    
    // Insert key-value pair
    fun put(key: K, value: V) {
        val index = findSlot(key)
        
        if (table[index] == null || table[index]!!.isDeleted) {
            table[index] = HashEntry(key, value)
            size++
        } else {
            table[index]!!.value = value
        }
        
        // Resize if load factor exceeded
        if (size > table.size * loadFactor) {
            resize()
        }
    }
    
    // Get value by key
    fun get(key: K): V? {
        var index = hash(key)
        var originalIndex = index
        
        while (table[index] != null) {
            if (!table[index]!!.isDeleted && table[index]!!.key == key) {
                return table[index]!!.value
            }
            index = (index + 1) % table.size
            if (index == originalIndex) {
                break
            }
        }
        
        return null
    }
    
    // Remove key-value pair
    fun remove(key: K): V? {
        var index = hash(key)
        var originalIndex = index
        
        while (table[index] != null) {
            if (!table[index]!!.isDeleted && table[index]!!.key == key) {
                val value = table[index]!!.value
                table[index]!!.isDeleted = true
                size--
                return value
            }
            index = (index + 1) % table.size
            if (index == originalIndex) {
                break
            }
        }
        
        return null
    }
    
    // Check if key exists
    fun containsKey(key: K): Boolean {
        return get(key) != null
    }
    
    // Get all keys
    fun keys(): List<K> {
        val keyList = mutableListOf<K>()
        for (entry in table) {
            if (entry != null && !entry.isDeleted) {
                keyList.add(entry.key)
            }
        }
        return keyList
    }
    
    // Get all values
    fun values(): List<V> {
        val valueList = mutableListOf<V>()
        for (entry in table) {
            if (entry != null && !entry.isDeleted) {
                valueList.add(entry.value)
            }
        }
        return valueList
    }
    
    // Get size
    fun size(): Int = size
    
    // Check if empty
    fun isEmpty(): Boolean = size == 0
    
    // Resize table
    private fun resize() {
        val oldTable = table
        table = arrayOfNulls(table.size * 2)
        size = 0
        
        for (entry in oldTable) {
            if (entry != null && !entry.isDeleted) {
                put(entry.key, entry.value)
            }
        }
    }
    
    // Print table structure
    fun printTable() {
        for (i in table.indices) {
            val entry = table[i]
            if (entry != null && !entry.isDeleted) {
                println("Index $i: (${entry.key}, ${entry.value})")
            } else {
                println("Index $i: null")
            }
        }
    }
}
```

### Hash Table with Quadratic Probing
```kotlin
// Hash Table with quadratic probing
class QuadraticProbingHashTable<K, V>(private val initialCapacity: Int = 16) {
    private var table: Array<HashEntry<K, V>?> = arrayOfNulls(initialCapacity)
    private var size = 0
    private val loadFactor = 0.5
    
    // Hash function
    private fun hash(key: K): Int {
        return key.hashCode() and 0x7FFFFFFF % table.size
    }
    
    // Find slot for key using quadratic probing
    private fun findSlot(key: K): Int {
        var index = hash(key)
        var originalIndex = index
        var i = 0
        
        while (table[index] != null && !table[index]!!.isDeleted) {
            if (table[index]!!.key == key) {
                return index
            }
            i++
            index = (originalIndex + i * i) % table.size
            if (i >= table.size) {
                throw IllegalStateException("Hash table is full")
            }
        }
        
        return index
    }
    
    // Insert key-value pair
    fun put(key: K, value: V) {
        val index = findSlot(key)
        
        if (table[index] == null || table[index]!!.isDeleted) {
            table[index] = HashEntry(key, value)
            size++
        } else {
            table[index]!!.value = value
        }
        
        // Resize if load factor exceeded
        if (size > table.size * loadFactor) {
            resize()
        }
    }
    
    // Get value by key
    fun get(key: K): V? {
        var index = hash(key)
        var originalIndex = index
        var i = 0
        
        while (table[index] != null) {
            if (!table[index]!!.isDeleted && table[index]!!.key == key) {
                return table[index]!!.value
            }
            i++
            index = (originalIndex + i * i) % table.size
            if (i >= table.size) {
                break
            }
        }
        
        return null
    }
    
    // Remove key-value pair
    fun remove(key: K): V? {
        var index = hash(key)
        var originalIndex = index
        var i = 0
        
        while (table[index] != null) {
            if (!table[index]!!.isDeleted && table[index]!!.key == key) {
                val value = table[index]!!.value
                table[index]!!.isDeleted = true
                size--
                return value
            }
            i++
            index = (originalIndex + i * i) % table.size
            if (i >= table.size) {
                break
            }
        }
        
        return null
    }
    
    // Check if key exists
    fun containsKey(key: K): Boolean {
        return get(key) != null
    }
    
    // Get size
    fun size(): Int = size
    
    // Check if empty
    fun isEmpty(): Boolean = size == 0
    
    // Resize table
    private fun resize() {
        val oldTable = table
        table = arrayOfNulls(table.size * 2)
        size = 0
        
        for (entry in oldTable) {
            if (entry != null && !entry.isDeleted) {
                put(entry.key, entry.value)
            }
        }
    }
}
```

### Hash Table with Double Hashing
```kotlin
// Hash Table with double hashing
class DoubleHashingHashTable<K, V>(private val initialCapacity: Int = 16) {
    private var table: Array<HashEntry<K, V>?> = arrayOfNulls(initialCapacity)
    private var size = 0
    private val loadFactor = 0.5
    
    // Primary hash function
    private fun hash1(key: K): Int {
        return key.hashCode() and 0x7FFFFFFF % table.size
    }
    
    // Secondary hash function
    private fun hash2(key: K): Int {
        val hash = key.hashCode() and 0x7FFFFFFF
        return if (hash % 2 == 0) hash + 1 else hash
    }
    
    // Find slot for key using double hashing
    private fun findSlot(key: K): Int {
        val h1 = hash1(key)
        val h2 = hash2(key) % table.size
        var index = h1
        var i = 0
        
        while (table[index] != null && !table[index]!!.isDeleted) {
            if (table[index]!!.key == key) {
                return index
            }
            i++
            index = (h1 + i * h2) % table.size
            if (i >= table.size) {
                throw IllegalStateException("Hash table is full")
            }
        }
        
        return index
    }
    
    // Insert key-value pair
    fun put(key: K, value: V) {
        val index = findSlot(key)
        
        if (table[index] == null || table[index]!!.isDeleted) {
            table[index] = HashEntry(key, value)
            size++
        } else {
            table[index]!!.value = value
        }
        
        // Resize if load factor exceeded
        if (size > table.size * loadFactor) {
            resize()
        }
    }
    
    // Get value by key
    fun get(key: K): V? {
        val h1 = hash1(key)
        val h2 = hash2(key) % table.size
        var index = h1
        var i = 0
        
        while (table[index] != null) {
            if (!table[index]!!.isDeleted && table[index]!!.key == key) {
                return table[index]!!.value
            }
            i++
            index = (h1 + i * h2) % table.size
            if (i >= table.size) {
                break
            }
        }
        
        return null
    }
    
    // Remove key-value pair
    fun remove(key: K): V? {
        val h1 = hash1(key)
        val h2 = hash2(key) % table.size
        var index = h1
        var i = 0
        
        while (table[index] != null) {
            if (!table[index]!!.isDeleted && table[index]!!.key == key) {
                val value = table[index]!!.value
                table[index]!!.isDeleted = true
                size--
                return value
            }
            i++
            index = (h1 + i * h2) % table.size
            if (i >= table.size) {
                break
            }
        }
        
        return null
    }
    
    // Check if key exists
    fun containsKey(key: K): Boolean {
        return get(key) != null
    }
    
    // Get size
    fun size(): Int = size
    
    // Check if empty
    fun isEmpty(): Boolean = size == 0
    
    // Resize table
    private fun resize() {
        val oldTable = table
        table = arrayOfNulls(table.size * 2)
        size = 0
        
        for (entry in oldTable) {
            if (entry != null && !entry.isDeleted) {
                put(entry.key, entry.value)
            }
        }
    }
}
```

### Performance Testing
```kotlin
fun main() {
    val testData = listOf(
        "apple" to 1,
        "banana" to 2,
        "cherry" to 3,
        "date" to 4,
        "elderberry" to 5,
        "fig" to 6,
        "grape" to 7,
        "honeydew" to 8
    )
    
    // Test chaining hash table
    println("Testing Chaining Hash Table:")
    val chainingTable = HashTable<String, Int>()
    for ((key, value) in testData) {
        chainingTable.put(key, value)
    }
    chainingTable.printTable()
    println("Size: ${chainingTable.size()}")
    println("Get 'banana': ${chainingTable.get("banana")}")
    println("Contains 'cherry': ${chainingTable.containsKey("cherry")}")
    println("Remove 'date': ${chainingTable.remove("date")}")
    println("Keys: ${chainingTable.keys()}")
    println()
    
    // Test linear probing hash table
    println("Testing Linear Probing Hash Table:")
    val linearTable = LinearProbingHashTable<String, Int>()
    for ((key, value) in testData) {
        linearTable.put(key, value)
    }
    linearTable.printTable()
    println("Size: ${linearTable.size()}")
    println("Get 'grape': ${linearTable.get("grape")}")
    println("Contains 'fig': ${linearTable.containsKey("fig")}")
    println("Remove 'apple': ${linearTable.remove("apple")}")
    println("Keys: ${linearTable.keys()}")
    println()
    
    // Test quadratic probing hash table
    println("Testing Quadratic Probing Hash Table:")
    val quadraticTable = QuadraticProbingHashTable<String, Int>()
    for ((key, value) in testData) {
        quadraticTable.put(key, value)
    }
    println("Size: ${quadraticTable.size()}")
    println("Get 'honeydew': ${quadraticTable.get("honeydew")}")
    println("Contains 'elderberry': ${quadraticTable.containsKey("elderberry")}")
    println("Remove 'banana': ${quadraticTable.remove("banana")}")
    println()
    
    // Test double hashing hash table
    println("Testing Double Hashing Hash Table:")
    val doubleTable = DoubleHashingHashTable<String, Int>()
    for ((key, value) in testData) {
        doubleTable.put(key, value)
    }
    println("Size: ${doubleTable.size()}")
    println("Get 'cherry': ${doubleTable.get("cherry")}")
    println("Contains 'date': ${doubleTable.containsKey("date")}")
    println("Remove 'fig': ${doubleTable.remove("fig")}")
}
```

## 🔍 Hash Table Operations Complexity
- **Average Case**: O(1) for all operations
- **Worst Case**: O(n) when all keys hash to same bucket
- **Space**: O(n) - stores n key-value pairs
- **Load Factor**: Affects performance (typically 0.5-0.75)

## 🔍 Collision Resolution Strategies
- **Separate Chaining**: Store collisions in linked lists
- **Linear Probing**: Check next slot sequentially
- **Quadratic Probing**: Check slots with quadratic increments
- **Double Hashing**: Use second hash function for probing

## 💡 Learning Points
- **Hash functions** should distribute keys uniformly
- **Load factor** affects performance and memory usage
- **Collision resolution** strategies have different trade-offs
- **Resizing** maintains performance as table grows
- **Open addressing** uses less memory than chaining
- **Clustering** can occur with linear probing
- **Double hashing** reduces clustering compared to linear probing
- **Hash tables** provide O(1) average-case performance

# CS-260 Kotlin Linked List Implementation

## 🎯 Purpose
Demonstrate linked list data structure implementation in Kotlin with various operations.

## 📝 Kotlin Linked List Examples

### Singly Linked List
```kotlin
// Node class for singly linked list
class ListNode<T>(val data: T) {
    var next: ListNode<T>? = null
}

// Singly Linked List implementation
class SinglyLinkedList<T> {
    private var head: ListNode<T>? = null
    private var size = 0
    
    // Add element to the end
    fun append(data: T) {
        val newNode = ListNode(data)
        if (head == null) {
            head = newNode
        } else {
            var current = head
            while (current?.next != null) {
                current = current.next
            }
            current?.next = newNode
        }
        size++
    }
    
    // Add element to the beginning
    fun prepend(data: T) {
        val newNode = ListNode(data)
        newNode.next = head
        head = newNode
        size++
    }
    
    // Insert element at specific position
    fun insertAt(index: Int, data: T) {
        if (index < 0 || index > size) {
            throw IndexOutOfBoundsException("Index $index out of bounds")
        }
        
        if (index == 0) {
            prepend(data)
            return
        }
        
        val newNode = ListNode(data)
        var current = head
        repeat(index - 1) {
            current = current?.next
        }
        
        newNode.next = current?.next
        current?.next = newNode
        size++
    }
    
    // Remove element by value
    fun remove(data: T): Boolean {
        if (head == null) return false
        
        if (head?.data == data) {
            head = head?.next
            size--
            return true
        }
        
        var current = head
        while (current?.next != null) {
            if (current.next?.data == data) {
                current.next = current.next?.next
                size--
                return true
            }
            current = current.next
        }
        return false
    }
    
    // Remove element at index
    fun removeAt(index: Int): T? {
        if (index < 0 || index >= size) {
            throw IndexOutOfBoundsException("Index $index out of bounds")
        }
        
        if (index == 0) {
            val data = head?.data
            head = head?.next
            size--
            return data
        }
        
        var current = head
        repeat(index - 1) {
            current = current?.next
        }
        
        val data = current?.next?.data
        current?.next = current?.next?.next
        size--
        return data
    }
    
    // Search for element
    fun contains(data: T): Boolean {
        var current = head
        while (current != null) {
            if (current.data == data) return true
            current = current.next
        }
        return false
    }
    
    // Get element at index
    fun get(index: Int): T? {
        if (index < 0 || index >= size) return null
        
        var current = head
        repeat(index) {
            current = current?.next
        }
        return current?.data
    }
    
    // Get size
    fun size(): Int = size
    
    // Check if empty
    fun isEmpty(): Boolean = size == 0
    
    // Convert to list
    fun toList(): List<T> {
        val result = mutableListOf<T>()
        var current = head
        while (current != null) {
            result.add(current.data)
            current = current.next
        }
        return result
    }
    
    // Print the list
    override fun toString(): String {
        return toList().joinToString(" -> ", "[", "]")
    }
}

fun main() {
    val list = SinglyLinkedList<Int>()
    
    // Test operations
    list.append(1)
    list.append(2)
    list.append(3)
    println("After append: $list")
    
    list.prepend(0)
    println("After prepend: $list")
    
    list.insertAt(2, 10)
    println("After insert at index 2: $list")
    
    println("Contains 2: ${list.contains(2)}")
    println("Contains 5: ${list.contains(5)}")
    
    println("Element at index 1: ${list.get(1)}")
    
    list.remove(2)
    println("After removing 2: $list")
    
    list.removeAt(0)
    println("After removing at index 0: $list")
    
    println("Size: ${list.size()}")
    println("Is empty: ${list.isEmpty()}")
}
```

### Doubly Linked List
```kotlin
// Node class for doubly linked list
class DoublyListNode<T>(val data: T) {
    var next: DoublyListNode<T>? = null
    var prev: DoublyListNode<T>? = null
}

// Doubly Linked List implementation
class DoublyLinkedList<T> {
    private var head: DoublyListNode<T>? = null
    private var tail: DoublyListNode<T>? = null
    private var size = 0
    
    // Add element to the end
    fun append(data: T) {
        val newNode = DoublyListNode(data)
        
        if (head == null) {
            head = newNode
            tail = newNode
        } else {
            tail?.next = newNode
            newNode.prev = tail
            tail = newNode
        }
        size++
    }
    
    // Add element to the beginning
    fun prepend(data: T) {
        val newNode = DoublyListNode(data)
        
        if (head == null) {
            head = newNode
            tail = newNode
        } else {
            newNode.next = head
            head?.prev = newNode
            head = newNode
        }
        size++
    }
    
    // Insert element at specific position
    fun insertAt(index: Int, data: T) {
        if (index < 0 || index > size) {
            throw IndexOutOfBoundsException("Index $index out of bounds")
        }
        
        if (index == 0) {
            prepend(data)
            return
        }
        
        if (index == size) {
            append(data)
            return
        }
        
        val newNode = DoublyListNode(data)
        var current = head
        repeat(index) {
            current = current?.next
        }
        
        newNode.prev = current?.prev
        newNode.next = current
        current?.prev?.next = newNode
        current?.prev = newNode
        size++
    }
    
    // Remove element by value
    fun remove(data: T): Boolean {
        var current = head
        while (current != null) {
            if (current.data == data) {
                if (current == head) {
                    head = current.next
                    head?.prev = null
                } else if (current == tail) {
                    tail = current.prev
                    tail?.next = null
                } else {
                    current.prev?.next = current.next
                    current.next?.prev = current.prev
                }
                size--
                return true
            }
            current = current.next
        }
        return false
    }
    
    // Remove element at index
    fun removeAt(index: Int): T? {
        if (index < 0 || index >= size) {
            throw IndexOutOfBoundsException("Index $index out of bounds")
        }
        
        var current = head
        repeat(index) {
            current = current?.next
        }
        
        if (current == head) {
            head = current.next
            head?.prev = null
        } else if (current == tail) {
            tail = current.prev
            tail?.next = null
        } else {
            current?.prev?.next = current?.next
            current?.next?.prev = current?.prev
        }
        
        size--
        return current?.data
    }
    
    // Search for element
    fun contains(data: T): Boolean {
        var current = head
        while (current != null) {
            if (current.data == data) return true
            current = current.next
        }
        return false
    }
    
    // Get element at index
    fun get(index: Int): T? {
        if (index < 0 || index >= size) return null
        
        var current = head
        repeat(index) {
            current = current?.next
        }
        return current?.data
    }
    
    // Get size
    fun size(): Int = size
    
    // Check if empty
    fun isEmpty(): Boolean = size == 0
    
    // Convert to list (forward)
    fun toList(): List<T> {
        val result = mutableListOf<T>()
        var current = head
        while (current != null) {
            result.add(current.data)
            current = current.next
        }
        return result
    }
    
    // Convert to list (backward)
    fun toListReversed(): List<T> {
        val result = mutableListOf<T>()
        var current = tail
        while (current != null) {
            result.add(current.data)
            current = current.prev
        }
        return result
    }
    
    // Print the list
    override fun toString(): String {
        return toList().joinToString(" <-> ", "[", "]")
    }
}

fun main() {
    val list = DoublyLinkedList<String>()
    
    // Test operations
    list.append("A")
    list.append("B")
    list.append("C")
    println("After append: $list")
    
    list.prepend("Z")
    println("After prepend: $list")
    
    list.insertAt(2, "X")
    println("After insert at index 2: $list")
    
    println("Contains B: ${list.contains("B")}")
    println("Contains D: ${list.contains("D")}")
    
    println("Element at index 1: ${list.get(1)}")
    
    list.remove("B")
    println("After removing B: $list")
    
    list.removeAt(0)
    println("After removing at index 0: $list")
    
    println("Forward: ${list.toList()}")
    println("Backward: ${list.toListReversed()}")
    
    println("Size: ${list.size()}")
    println("Is empty: ${list.isEmpty()}")
}
```

### Circular Linked List
```kotlin
// Circular Linked List implementation
class CircularLinkedList<T> {
    private var head: ListNode<T>? = null
    private var size = 0
    
    // Add element to the end
    fun append(data: T) {
        val newNode = ListNode(data)
        
        if (head == null) {
            head = newNode
            newNode.next = head // Point to itself
        } else {
            var current = head
            while (current?.next != head) {
                current = current?.next
            }
            current?.next = newNode
            newNode.next = head
        }
        size++
    }
    
    // Add element to the beginning
    fun prepend(data: T) {
        val newNode = ListNode(data)
        
        if (head == null) {
            head = newNode
            newNode.next = head
        } else {
            var current = head
            while (current?.next != head) {
                current = current?.next
            }
            current?.next = newNode
            newNode.next = head
            head = newNode
        }
        size++
    }
    
    // Remove element by value
    fun remove(data: T): Boolean {
        if (head == null) return false
        
        var current = head
        var prev: ListNode<T>? = null
        
        do {
            if (current?.data == data) {
                if (current == head) {
                    if (size == 1) {
                        head = null
                    } else {
                        var last = head
                        while (last?.next != head) {
                            last = last?.next
                        }
                        last?.next = head?.next
                        head = head?.next
                    }
                } else {
                    prev?.next = current.next
                }
                size--
                return true
            }
            prev = current
            current = current?.next
        } while (current != head)
        
        return false
    }
    
    // Search for element
    fun contains(data: T): Boolean {
        if (head == null) return false
        
        var current = head
        do {
            if (current?.data == data) return true
            current = current?.next
        } while (current != head)
        
        return false
    }
    
    // Get size
    fun size(): Int = size
    
    // Check if empty
    fun isEmpty(): Boolean = size == 0
    
    // Convert to list
    fun toList(): List<T> {
        if (head == null) return emptyList()
        
        val result = mutableListOf<T>()
        var current = head
        do {
            result.add(current?.data!!)
            current = current.next
        } while (current != head)
        
        return result
    }
    
    // Print the list
    override fun toString(): String {
        return toList().joinToString(" -> ", "[", " -> ...]")
    }
}

fun main() {
    val list = CircularLinkedList<Int>()
    
    // Test operations
    list.append(1)
    list.append(2)
    list.append(3)
    println("After append: $list")
    
    list.prepend(0)
    println("After prepend: $list")
    
    println("Contains 2: ${list.contains(2)}")
    println("Contains 5: ${list.contains(5)}")
    
    list.remove(2)
    println("After removing 2: $list")
    
    println("Size: ${list.size()}")
    println("Is empty: ${list.isEmpty()}")
}
```

## 🔍 Linked List Operations Complexity
- **Access**: O(n) - Need to traverse to find element
- **Search**: O(n) - Need to traverse to find element
- **Insertion**: O(1) at head, O(n) at arbitrary position
- **Deletion**: O(1) at head, O(n) at arbitrary position
- **Space**: O(n) - Each node stores data and pointer(s)

## 💡 Learning Points
- **Singly linked lists** use one pointer per node (next)
- **Doubly linked lists** use two pointers per node (next, prev)
- **Circular linked lists** connect the last node to the first
- **Insertion/Deletion** at head is O(1) for all types
- **Traversal** is required for most operations (O(n))
- **Memory overhead** is higher than arrays due to pointers
- **No random access** - must traverse from head
- **Dynamic size** - can grow and shrink as needed

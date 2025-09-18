# CS-260 Kotlin Binary Search Tree Implementation

## 🎯 Purpose
Demonstrate binary search tree data structure implementation in Kotlin with various operations.

## 📝 Kotlin Binary Search Tree Examples

### Basic Binary Search Tree
```kotlin
// Node class for binary search tree
class TreeNode<T : Comparable<T>>(val data: T) {
    var left: TreeNode<T>? = null
    var right: TreeNode<T>? = null
}

// Binary Search Tree implementation
class BinarySearchTree<T : Comparable<T>> {
    private var root: TreeNode<T>? = null
    private var size = 0
    
    // Insert element
    fun insert(data: T) {
        root = insertRecursive(root, data)
        size++
    }
    
    private fun insertRecursive(node: TreeNode<T>?, data: T): TreeNode<T> {
        if (node == null) {
            return TreeNode(data)
        }
        
        when {
            data < node.data -> node.left = insertRecursive(node.left, data)
            data > node.data -> node.right = insertRecursive(node.right, data)
            // data == node.data: duplicate, do nothing
        }
        
        return node
    }
    
    // Search for element
    fun contains(data: T): Boolean {
        return searchRecursive(root, data) != null
    }
    
    private fun searchRecursive(node: TreeNode<T>?, data: T): TreeNode<T>? {
        if (node == null || node.data == data) {
            return node
        }
        
        return if (data < node.data) {
            searchRecursive(node.left, data)
        } else {
            searchRecursive(node.right, data)
        }
    }
    
    // Delete element
    fun delete(data: T): Boolean {
        val initialSize = size
        root = deleteRecursive(root, data)
        return size < initialSize
    }
    
    private fun deleteRecursive(node: TreeNode<T>?, data: T): TreeNode<T>? {
        if (node == null) return null
        
        when {
            data < node.data -> {
                node.left = deleteRecursive(node.left, data)
            }
            data > node.data -> {
                node.right = deleteRecursive(node.right, data)
            }
            else -> {
                // Node to delete found
                size--
                
                // Case 1: Node with no children
                if (node.left == null && node.right == null) {
                    return null
                }
                
                // Case 2: Node with one child
                if (node.left == null) return node.right
                if (node.right == null) return node.left
                
                // Case 3: Node with two children
                val minNode = findMin(node.right!!)
                node.data = minNode.data
                node.right = deleteRecursive(node.right, minNode.data)
            }
        }
        
        return node
    }
    
    private fun findMin(node: TreeNode<T>): TreeNode<T> {
        var current = node
        while (current.left != null) {
            current = current.left!!
        }
        return current
    }
    
    // Get size
    fun size(): Int = size
    
    // Check if empty
    fun isEmpty(): Boolean = size == 0
    
    // Tree traversals
    fun inorderTraversal(): List<T> {
        val result = mutableListOf<T>()
        inorderRecursive(root, result)
        return result
    }
    
    private fun inorderRecursive(node: TreeNode<T>?, result: MutableList<T>) {
        if (node != null) {
            inorderRecursive(node.left, result)
            result.add(node.data)
            inorderRecursive(node.right, result)
        }
    }
    
    fun preorderTraversal(): List<T> {
        val result = mutableListOf<T>()
        preorderRecursive(root, result)
        return result
    }
    
    private fun preorderRecursive(node: TreeNode<T>?, result: MutableList<T>) {
        if (node != null) {
            result.add(node.data)
            preorderRecursive(node.left, result)
            preorderRecursive(node.right, result)
        }
    }
    
    fun postorderTraversal(): List<T> {
        val result = mutableListOf<T>()
        postorderRecursive(root, result)
        return result
    }
    
    private fun postorderRecursive(node: TreeNode<T>?, result: MutableList<T>) {
        if (node != null) {
            postorderRecursive(node.left, result)
            postorderRecursive(node.right, result)
            result.add(node.data)
        }
    }
    
    // Get height of tree
    fun height(): Int {
        return heightRecursive(root)
    }
    
    private fun heightRecursive(node: TreeNode<T>?): Int {
        if (node == null) return -1
        
        val leftHeight = heightRecursive(node.left)
        val rightHeight = heightRecursive(node.right)
        
        return 1 + maxOf(leftHeight, rightHeight)
    }
    
    // Check if tree is balanced
    fun isBalanced(): Boolean {
        return isBalancedRecursive(root) != -1
    }
    
    private fun isBalancedRecursive(node: TreeNode<T>?): Int {
        if (node == null) return 0
        
        val leftHeight = isBalancedRecursive(node.left)
        if (leftHeight == -1) return -1
        
        val rightHeight = isBalancedRecursive(node.right)
        if (rightHeight == -1) return -1
        
        if (kotlin.math.abs(leftHeight - rightHeight) > 1) return -1
        
        return 1 + maxOf(leftHeight, rightHeight)
    }
    
    // Find minimum value
    fun findMin(): T? {
        return findMinRecursive(root)?.data
    }
    
    private fun findMinRecursive(node: TreeNode<T>?): TreeNode<T>? {
        if (node == null) return null
        return if (node.left == null) node else findMinRecursive(node.left)
    }
    
    // Find maximum value
    fun findMax(): T? {
        return findMaxRecursive(root)?.data
    }
    
    private fun findMaxRecursive(node: TreeNode<T>?): TreeNode<T>? {
        if (node == null) return null
        return if (node.right == null) node else findMaxRecursive(node.right)
    }
    
    // Convert to sorted list
    fun toSortedList(): List<T> {
        return inorderTraversal()
    }
    
    // Print tree structure (for debugging)
    fun printTree() {
        printTreeRecursive(root, 0)
    }
    
    private fun printTreeRecursive(node: TreeNode<T>?, level: Int) {
        if (node != null) {
            printTreeRecursive(node.right, level + 1)
            repeat(level * 4) { print(" ") }
            println(node.data)
            printTreeRecursive(node.left, level + 1)
        }
    }
}

fun main() {
    val bst = BinarySearchTree<Int>()
    
    // Test operations
    bst.insert(50)
    bst.insert(30)
    bst.insert(70)
    bst.insert(20)
    bst.insert(40)
    bst.insert(60)
    bst.insert(80)
    
    println("BST after insertions:")
    bst.printTree()
    
    println("\nSize: ${bst.size()}")
    println("Height: ${bst.height()}")
    println("Is balanced: ${bst.isBalanced()}")
    
    println("\nInorder traversal: ${bst.inorderTraversal()}")
    println("Preorder traversal: ${bst.preorderTraversal()}")
    println("Postorder traversal: ${bst.postorderTraversal()}")
    
    println("\nMin value: ${bst.findMin()}")
    println("Max value: ${bst.findMax()}")
    
    println("\nContains 40: ${bst.contains(40)}")
    println("Contains 90: ${bst.contains(90)}")
    
    bst.delete(30)
    println("\nAfter deleting 30:")
    bst.printTree()
    
    println("\nSorted list: ${bst.toSortedList()}")
}
```

### AVL Tree (Self-Balancing BST)
```kotlin
// AVL Node with height
class AVLNode<T : Comparable<T>>(val data: T) {
    var left: AVLNode<T>? = null
    var right: AVLNode<T>? = null
    var height = 1
}

// AVL Tree implementation
class AVLTree<T : Comparable<T>> {
    private var root: AVLNode<T>? = null
    private var size = 0
    
    // Get height of node
    private fun height(node: AVLNode<T>?): Int {
        return node?.height ?: 0
    }
    
    // Get balance factor
    private fun getBalance(node: AVLNode<T>?): Int {
        return if (node == null) 0 else height(node.left) - height(node.right)
    }
    
    // Update height
    private fun updateHeight(node: AVLNode<T>) {
        node.height = 1 + maxOf(height(node.left), height(node.right))
    }
    
    // Right rotation
    private fun rightRotate(y: AVLNode<T>): AVLNode<T> {
        val x = y.left!!
        val T2 = x.right
        
        x.right = y
        y.left = T2
        
        updateHeight(y)
        updateHeight(x)
        
        return x
    }
    
    // Left rotation
    private fun leftRotate(x: AVLNode<T>): AVLNode<T> {
        val y = x.right!!
        val T2 = y.left
        
        y.left = x
        x.right = T2
        
        updateHeight(x)
        updateHeight(y)
        
        return y
    }
    
    // Insert element
    fun insert(data: T) {
        root = insertRecursive(root, data)
        size++
    }
    
    private fun insertRecursive(node: AVLNode<T>?, data: T): AVLNode<T> {
        if (node == null) {
            return AVLNode(data)
        }
        
        when {
            data < node.data -> node.left = insertRecursive(node.left, data)
            data > node.data -> node.right = insertRecursive(node.right, data)
            else -> return node // Duplicate values not allowed
        }
        
        updateHeight(node)
        
        val balance = getBalance(node)
        
        // Left Left Case
        if (balance > 1 && data < node.left!!.data) {
            return rightRotate(node)
        }
        
        // Right Right Case
        if (balance < -1 && data > node.right!!.data) {
            return leftRotate(node)
        }
        
        // Left Right Case
        if (balance > 1 && data > node.left!!.data) {
            node.left = leftRotate(node.left!!)
            return rightRotate(node)
        }
        
        // Right Left Case
        if (balance < -1 && data < node.right!!.data) {
            node.right = rightRotate(node.right!!)
            return leftRotate(node)
        }
        
        return node
    }
    
    // Delete element
    fun delete(data: T): Boolean {
        val initialSize = size
        root = deleteRecursive(root, data)
        return size < initialSize
    }
    
    private fun deleteRecursive(node: AVLNode<T>?, data: T): AVLNode<T>? {
        if (node == null) return null
        
        when {
            data < node.data -> node.left = deleteRecursive(node.left, data)
            data > node.data -> node.right = deleteRecursive(node.right, data)
            else -> {
                size--
                
                // Node with no children or one child
                if (node.left == null || node.right == null) {
                    val temp = node.left ?: node.right
                    return temp
                }
                
                // Node with two children
                val temp = findMin(node.right!!)
                node.data = temp.data
                node.right = deleteRecursive(node.right, temp.data)
            }
        }
        
        updateHeight(node)
        
        val balance = getBalance(node)
        
        // Left Left Case
        if (balance > 1 && getBalance(node.left) >= 0) {
            return rightRotate(node)
        }
        
        // Left Right Case
        if (balance > 1 && getBalance(node.left) < 0) {
            node.left = leftRotate(node.left!!)
            return rightRotate(node)
        }
        
        // Right Right Case
        if (balance < -1 && getBalance(node.right) <= 0) {
            return leftRotate(node)
        }
        
        // Right Left Case
        if (balance < -1 && getBalance(node.right) > 0) {
            node.right = rightRotate(node.right!!)
            return leftRotate(node)
        }
        
        return node
    }
    
    private fun findMin(node: AVLNode<T>): AVLNode<T> {
        var current = node
        while (current.left != null) {
            current = current.left!!
        }
        return current
    }
    
    // Search for element
    fun contains(data: T): Boolean {
        return searchRecursive(root, data) != null
    }
    
    private fun searchRecursive(node: AVLNode<T>?, data: T): AVLNode<T>? {
        if (node == null || node.data == data) {
            return node
        }
        
        return if (data < node.data) {
            searchRecursive(node.left, data)
        } else {
            searchRecursive(node.right, data)
        }
    }
    
    // Get size
    fun size(): Int = size
    
    // Check if empty
    fun isEmpty(): Boolean = size == 0
    
    // Get height
    fun height(): Int {
        return height(root)
    }
    
    // Inorder traversal
    fun inorderTraversal(): List<T> {
        val result = mutableListOf<T>()
        inorderRecursive(root, result)
        return result
    }
    
    private fun inorderRecursive(node: AVLNode<T>?, result: MutableList<T>) {
        if (node != null) {
            inorderRecursive(node.left, result)
            result.add(node.data)
            inorderRecursive(node.right, result)
        }
    }
    
    // Print tree structure
    fun printTree() {
        printTreeRecursive(root, 0)
    }
    
    private fun printTreeRecursive(node: AVLNode<T>?, level: Int) {
        if (node != null) {
            printTreeRecursive(node.right, level + 1)
            repeat(level * 4) { print(" ") }
            println("${node.data} (h:${node.height})")
            printTreeRecursive(node.left, level + 1)
        }
    }
}

fun main() {
    val avl = AVLTree<Int>()
    
    // Test operations
    avl.insert(10)
    avl.insert(20)
    avl.insert(30)
    avl.insert(40)
    avl.insert(50)
    avl.insert(25)
    
    println("AVL Tree after insertions:")
    avl.printTree()
    
    println("\nSize: ${avl.size()}")
    println("Height: ${avl.height()}")
    println("Inorder traversal: ${avl.inorderTraversal()}")
    
    avl.delete(30)
    println("\nAfter deleting 30:")
    avl.printTree()
    
    println("\nContains 25: ${avl.contains(25)}")
    println("Contains 30: ${avl.contains(30)}")
}
```

## 🔍 Binary Search Tree Operations Complexity
- **Search**: O(log n) average, O(n) worst case
- **Insertion**: O(log n) average, O(n) worst case
- **Deletion**: O(log n) average, O(n) worst case
- **Traversal**: O(n) - must visit every node
- **Space**: O(n) - each node stores data and pointers

## 🔍 AVL Tree Operations Complexity
- **Search**: O(log n) - always balanced
- **Insertion**: O(log n) - with rotations
- **Deletion**: O(log n) - with rotations
- **Traversal**: O(n) - must visit every node
- **Space**: O(n) - each node stores data, pointers, and height

## 💡 Learning Points
- **BST property**: Left child < parent < right child
- **Inorder traversal** gives sorted order
- **Height** affects performance significantly
- **AVL trees** maintain balance automatically
- **Rotations** restore balance in AVL trees
- **Self-balancing** trees provide consistent O(log n) performance
- **Tree traversals** visit nodes in different orders
- **Recursive algorithms** are natural for tree operations

# CS-260 Stack and Queue Implementation

## 🎯 Purpose
Demonstrate stack and queue data structures with practical examples.

## 📝 Code Examples

### Stack Implementation
```java
public class Stack<T> {
    private T[] stack;
    private int top;
    private int capacity;
    
    @SuppressWarnings("unchecked")
    public Stack(int capacity) {
        this.capacity = capacity;
        this.stack = (T[]) new Object[capacity];
        this.top = -1;
    }
    
    // Push element onto stack
    public void push(T element) {
        if (isFull()) {
            throw new StackOverflowError("Stack is full");
        }
        stack[++top] = element;
    }
    
    // Pop element from stack
    public T pop() {
        if (isEmpty()) {
            throw new EmptyStackException();
        }
        return stack[top--];
    }
    
    // Peek at top element
    public T peek() {
        if (isEmpty()) {
            throw new EmptyStackException();
        }
        return stack[top];
    }
    
    // Check if stack is empty
    public boolean isEmpty() {
        return top == -1;
    }
    
    // Check if stack is full
    public boolean isFull() {
        return top == capacity - 1;
    }
    
    // Get stack size
    public int size() {
        return top + 1;
    }
}
```

### Queue Implementation
```java
public class Queue<T> {
    private T[] queue;
    private int front;
    private int rear;
    private int size;
    private int capacity;
    
    @SuppressWarnings("unchecked")
    public Queue(int capacity) {
        this.capacity = capacity;
        this.queue = (T[]) new Object[capacity];
        this.front = 0;
        this.rear = -1;
        this.size = 0;
    }
    
    // Enqueue element
    public void enqueue(T element) {
        if (isFull()) {
            throw new IllegalStateException("Queue is full");
        }
        rear = (rear + 1) % capacity;
        queue[rear] = element;
        size++;
    }
    
    // Dequeue element
    public T dequeue() {
        if (isEmpty()) {
            throw new IllegalStateException("Queue is empty");
        }
        T element = queue[front];
        front = (front + 1) % capacity;
        size--;
        return element;
    }
    
    // Peek at front element
    public T peek() {
        if (isEmpty()) {
            throw new IllegalStateException("Queue is empty");
        }
        return queue[front];
    }
    
    // Check if queue is empty
    public boolean isEmpty() {
        return size == 0;
    }
    
    // Check if queue is full
    public boolean isFull() {
        return size == capacity;
    }
    
    // Get queue size
    public int size() {
        return size;
    }
}
```

### Practical Applications

#### Balanced Parentheses Checker
```java
public class ParenthesesChecker {
    public static boolean isBalanced(String expression) {
        Stack<Character> stack = new Stack<>(expression.length());
        
        for (char c : expression.toCharArray()) {
            if (c == '(' || c == '[' || c == '{') {
                stack.push(c);
            } else if (c == ')' || c == ']' || c == '}') {
                if (stack.isEmpty()) {
                    return false;
                }
                
                char top = stack.pop();
                if (!isMatching(top, c)) {
                    return false;
                }
            }
        }
        
        return stack.isEmpty();
    }
    
    private static boolean isMatching(char open, char close) {
        return (open == '(' && close == ')') ||
               (open == '[' && close == ']') ||
               (open == '{' && close == '}');
    }
}
```

#### Breadth-First Search (BFS)
```java
public class BFS {
    public static void bfsTraversal(int[][] graph, int start) {
        boolean[] visited = new boolean[graph.length];
        Queue<Integer> queue = new Queue<>(graph.length);
        
        visited[start] = true;
        queue.enqueue(start);
        
        while (!queue.isEmpty()) {
            int vertex = queue.dequeue();
            System.out.print(vertex + " ");
            
            for (int i = 0; i < graph[vertex].length; i++) {
                if (graph[vertex][i] == 1 && !visited[i]) {
                    visited[i] = true;
                    queue.enqueue(i);
                }
            }
        }
    }
}
```

## 🔍 Key Concepts
- **Stack**: LIFO (Last In, First Out) principle
- **Queue**: FIFO (First In, First Out) principle
- **Circular Queue**: Efficient space utilization
- **Applications**: Expression evaluation, BFS/DFS, function calls

## 💡 Learning Points
- Stacks are used for recursion and expression evaluation
- Queues are used for BFS and task scheduling
- Circular arrays prevent memory waste in queues
- Both structures have O(1) insertion and deletion

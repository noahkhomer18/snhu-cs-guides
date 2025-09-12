# CS-260 Array Operations

## 🎯 Purpose
Demonstrate fundamental array operations and algorithms.

## 📝 Code Examples

### Array Traversal
```java
public class ArrayTraversal {
    // Linear search
    public static int linearSearch(int[] arr, int target) {
        for (int i = 0; i < arr.length; i++) {
            if (arr[i] == target) {
                return i;
            }
        }
        return -1; // Not found
    }
    
    // Binary search (requires sorted array)
    public static int binarySearch(int[] arr, int target) {
        int left = 0;
        int right = arr.length - 1;
        
        while (left <= right) {
            int mid = left + (right - left) / 2;
            
            if (arr[mid] == target) {
                return mid;
            } else if (arr[mid] < target) {
                left = mid + 1;
            } else {
                right = mid - 1;
            }
        }
        return -1; // Not found
    }
}
```

### Array Manipulation
```java
public class ArrayManipulation {
    // Insert element at specific position
    public static int[] insertElement(int[] arr, int element, int position) {
        int[] newArr = new int[arr.length + 1];
        
        // Copy elements before position
        for (int i = 0; i < position; i++) {
            newArr[i] = arr[i];
        }
        
        // Insert new element
        newArr[position] = element;
        
        // Copy elements after position
        for (int i = position; i < arr.length; i++) {
            newArr[i + 1] = arr[i];
        }
        
        return newArr;
    }
    
    // Remove element at specific position
    public static int[] removeElement(int[] arr, int position) {
        int[] newArr = new int[arr.length - 1];
        
        // Copy elements before position
        for (int i = 0; i < position; i++) {
            newArr[i] = arr[i];
        }
        
        // Copy elements after position
        for (int i = position + 1; i < arr.length; i++) {
            newArr[i - 1] = arr[i];
        }
        
        return newArr;
    }
}
```

## 🔍 Key Concepts
- **Time Complexity**: Linear search O(n), Binary search O(log n)
- **Space Complexity**: O(1) for in-place operations
- **Array Properties**: Fixed size, random access, contiguous memory

## 💡 Learning Points
- Arrays provide constant-time access by index
- Insertion/deletion requires shifting elements
- Binary search requires sorted array
- Dynamic arrays (ArrayList) handle resizing automatically

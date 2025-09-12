# CS-300 Advanced Sorting Algorithms

## 🎯 Purpose
Demonstrate advanced sorting algorithms with detailed analysis and optimization techniques.

## 📝 Advanced Sorting Examples

### Quick Sort with Optimizations
```java
public class QuickSortAdvanced {
    
    // Basic Quick Sort
    public static void quickSort(int[] arr, int low, int high) {
        if (low < high) {
            int pivotIndex = partition(arr, low, high);
            quickSort(arr, low, pivotIndex - 1);
            quickSort(arr, pivotIndex + 1, high);
        }
    }
    
    // Optimized Quick Sort with 3-way partitioning
    public static void quickSort3Way(int[] arr, int low, int high) {
        if (low >= high) return;
        
        int[] pivotIndices = partition3Way(arr, low, high);
        quickSort3Way(arr, low, pivotIndices[0] - 1);
        quickSort3Way(arr, pivotIndices[1] + 1, high);
    }
    
    // 3-way partitioning for duplicate elements
    private static int[] partition3Way(int[] arr, int low, int high) {
        int pivot = arr[low];
        int lt = low;      // arr[low..lt-1] < pivot
        int i = low + 1;   // arr[lt..i-1] == pivot
        int gt = high;     // arr[gt+1..high] > pivot
        
        while (i <= gt) {
            if (arr[i] < pivot) {
                swap(arr, lt++, i++);
            } else if (arr[i] > pivot) {
                swap(arr, i, gt--);
            } else {
                i++;
            }
        }
        
        return new int[]{lt, gt};
    }
    
    // Hybrid Quick Sort (switches to Insertion Sort for small arrays)
    public static void hybridQuickSort(int[] arr, int low, int high) {
        if (low < high) {
            if (high - low < 10) {
                insertionSort(arr, low, high);
            } else {
                int pivotIndex = partition(arr, low, high);
                hybridQuickSort(arr, low, pivotIndex - 1);
                hybridQuickSort(arr, pivotIndex + 1, high);
            }
        }
    }
    
    private static int partition(int[] arr, int low, int high) {
        // Median-of-three pivot selection
        int mid = low + (high - low) / 2;
        if (arr[mid] < arr[low]) swap(arr, low, mid);
        if (arr[high] < arr[low]) swap(arr, low, high);
        if (arr[high] < arr[mid]) swap(arr, mid, high);
        
        int pivot = arr[mid];
        swap(arr, mid, high);
        
        int i = low - 1;
        for (int j = low; j < high; j++) {
            if (arr[j] <= pivot) {
                i++;
                swap(arr, i, j);
            }
        }
        swap(arr, i + 1, high);
        return i + 1;
    }
    
    private static void insertionSort(int[] arr, int low, int high) {
        for (int i = low + 1; i <= high; i++) {
            int key = arr[i];
            int j = i - 1;
            while (j >= low && arr[j] > key) {
                arr[j + 1] = arr[j];
                j--;
            }
            arr[j + 1] = key;
        }
    }
    
    private static void swap(int[] arr, int i, int j) {
        int temp = arr[i];
        arr[i] = arr[j];
        arr[j] = temp;
    }
}
```

### Merge Sort with Optimizations
```java
public class MergeSortAdvanced {
    
    // Basic Merge Sort
    public static void mergeSort(int[] arr, int left, int right) {
        if (left < right) {
            int mid = left + (right - left) / 2;
            mergeSort(arr, left, mid);
            mergeSort(arr, mid + 1, right);
            merge(arr, left, mid, right);
        }
    }
    
    // Bottom-up Merge Sort (iterative)
    public static void bottomUpMergeSort(int[] arr) {
        int n = arr.length;
        int[] temp = new int[n];
        
        for (int size = 1; size < n; size *= 2) {
            for (int left = 0; left < n - size; left += 2 * size) {
                int mid = left + size - 1;
                int right = Math.min(left + 2 * size - 1, n - 1);
                merge(arr, left, mid, right);
            }
        }
    }
    
    // Optimized Merge Sort with insertion sort for small arrays
    public static void hybridMergeSort(int[] arr, int left, int right) {
        if (left < right) {
            if (right - left < 10) {
                insertionSort(arr, left, right);
            } else {
                int mid = left + (right - left) / 2;
                hybridMergeSort(arr, left, mid);
                hybridMergeSort(arr, mid + 1, right);
                merge(arr, left, mid, right);
            }
        }
    }
    
    private static void merge(int[] arr, int left, int mid, int right) {
        int[] leftArray = new int[mid - left + 1];
        int[] rightArray = new int[right - mid];
        
        // Copy data to temp arrays
        for (int i = 0; i < leftArray.length; i++) {
            leftArray[i] = arr[left + i];
        }
        for (int i = 0; i < rightArray.length; i++) {
            rightArray[i] = arr[mid + 1 + i];
        }
        
        // Merge the temp arrays back
        int i = 0, j = 0, k = left;
        
        while (i < leftArray.length && j < rightArray.length) {
            if (leftArray[i] <= rightArray[j]) {
                arr[k] = leftArray[i];
                i++;
            } else {
                arr[k] = rightArray[j];
                j++;
            }
            k++;
        }
        
        // Copy remaining elements
        while (i < leftArray.length) {
            arr[k] = leftArray[i];
            i++;
            k++;
        }
        while (j < rightArray.length) {
            arr[k] = rightArray[j];
            j++;
            k++;
        }
    }
    
    private static void insertionSort(int[] arr, int left, int right) {
        for (int i = left + 1; i <= right; i++) {
            int key = arr[i];
            int j = i - 1;
            while (j >= left && arr[j] > key) {
                arr[j + 1] = arr[j];
                j--;
            }
            arr[j + 1] = key;
        }
    }
}
```

### Heap Sort
```java
public class HeapSort {
    
    public static void heapSort(int[] arr) {
        int n = arr.length;
        
        // Build max heap
        for (int i = n / 2 - 1; i >= 0; i--) {
            heapify(arr, n, i);
        }
        
        // Extract elements from heap one by one
        for (int i = n - 1; i > 0; i--) {
            // Move current root to end
            swap(arr, 0, i);
            
            // Call heapify on the reduced heap
            heapify(arr, i, 0);
        }
    }
    
    private static void heapify(int[] arr, int n, int i) {
        int largest = i;        // Initialize largest as root
        int left = 2 * i + 1;   // Left child
        int right = 2 * i + 2;  // Right child
        
        // If left child is larger than root
        if (left < n && arr[left] > arr[largest]) {
            largest = left;
        }
        
        // If right child is larger than largest so far
        if (right < n && arr[right] > arr[largest]) {
            largest = right;
        }
        
        // If largest is not root
        if (largest != i) {
            swap(arr, i, largest);
            
            // Recursively heapify the affected sub-tree
            heapify(arr, n, largest);
        }
    }
    
    private static void swap(int[] arr, int i, int j) {
        int temp = arr[i];
        arr[i] = arr[j];
        arr[j] = temp;
    }
}
```

### Counting Sort (Non-comparison based)
```java
public class CountingSort {
    
    public static void countingSort(int[] arr) {
        int max = Arrays.stream(arr).max().orElse(0);
        int min = Arrays.stream(arr).min().orElse(0);
        int range = max - min + 1;
        
        int[] count = new int[range];
        int[] output = new int[arr.length];
        
        // Count occurrences
        for (int value : arr) {
            count[value - min]++;
        }
        
        // Modify count array to store actual position
        for (int i = 1; i < range; i++) {
            count[i] += count[i - 1];
        }
        
        // Build output array
        for (int i = arr.length - 1; i >= 0; i--) {
            output[count[arr[i] - min] - 1] = arr[i];
            count[arr[i] - min]--;
        }
        
        // Copy output back to original array
        System.arraycopy(output, 0, arr, 0, arr.length);
    }
}
```

### Radix Sort
```java
public class RadixSort {
    
    public static void radixSort(int[] arr) {
        int max = Arrays.stream(arr).max().orElse(0);
        
        // Do counting sort for every digit
        for (int exp = 1; max / exp > 0; exp *= 10) {
            countingSortByDigit(arr, exp);
        }
    }
    
    private static void countingSortByDigit(int[] arr, int exp) {
        int n = arr.length;
        int[] output = new int[n];
        int[] count = new int[10];
        
        // Store count of occurrences
        for (int value : arr) {
            count[(value / exp) % 10]++;
        }
        
        // Change count[i] so that count[i] contains actual position
        for (int i = 1; i < 10; i++) {
            count[i] += count[i - 1];
        }
        
        // Build output array
        for (int i = n - 1; i >= 0; i--) {
            output[count[(arr[i] / exp) % 10] - 1] = arr[i];
            count[(arr[i] / exp) % 10]--;
        }
        
        // Copy output back to original array
        System.arraycopy(output, 0, arr, 0, n);
    }
}
```

### Tim Sort (Python's default sort)
```java
public class TimSort {
    private static final int MIN_MERGE = 32;
    
    public static void timSort(int[] arr) {
        int n = arr.length;
        
        // Sort individual subarrays of size MIN_MERGE
        for (int i = 0; i < n; i += MIN_MERGE) {
            insertionSort(arr, i, Math.min(i + MIN_MERGE - 1, n - 1));
        }
        
        // Start merging from size MIN_MERGE
        for (int size = MIN_MERGE; size < n; size *= 2) {
            for (int left = 0; left < n; left += 2 * size) {
                int mid = left + size - 1;
                int right = Math.min(left + 2 * size - 1, n - 1);
                
                if (mid < right) {
                    merge(arr, left, mid, right);
                }
            }
        }
    }
    
    private static void insertionSort(int[] arr, int left, int right) {
        for (int i = left + 1; i <= right; i++) {
            int key = arr[i];
            int j = i - 1;
            while (j >= left && arr[j] > key) {
                arr[j + 1] = arr[j];
                j--;
            }
            arr[j + 1] = key;
        }
    }
    
    private static void merge(int[] arr, int left, int mid, int right) {
        int[] leftArray = new int[mid - left + 1];
        int[] rightArray = new int[right - mid];
        
        System.arraycopy(arr, left, leftArray, 0, leftArray.length);
        System.arraycopy(arr, mid + 1, rightArray, 0, rightArray.length);
        
        int i = 0, j = 0, k = left;
        
        while (i < leftArray.length && j < rightArray.length) {
            if (leftArray[i] <= rightArray[j]) {
                arr[k] = leftArray[i];
                i++;
            } else {
                arr[k] = rightArray[j];
                j++;
            }
            k++;
        }
        
        while (i < leftArray.length) {
            arr[k] = leftArray[i];
            i++;
            k++;
        }
        
        while (j < rightArray.length) {
            arr[k] = rightArray[j];
            j++;
            k++;
        }
    }
}
```

## 🔍 Algorithm Analysis

| Algorithm | Best Case | Average Case | Worst Case | Space | Stable |
|-----------|-----------|--------------|------------|-------|--------|
| Quick Sort | O(n log n) | O(n log n) | O(n²) | O(log n) | No |
| Merge Sort | O(n log n) | O(n log n) | O(n log n) | O(n) | Yes |
| Heap Sort | O(n log n) | O(n log n) | O(n log n) | O(1) | No |
| Counting Sort | O(n + k) | O(n + k) | O(n + k) | O(k) | Yes |
| Radix Sort | O(d(n + k)) | O(d(n + k)) | O(d(n + k)) | O(n + k) | Yes |
| Tim Sort | O(n) | O(n log n) | O(n log n) | O(n) | Yes |

## 💡 Learning Points
- **Quick Sort**: Fast average case, but worst case O(n²)
- **Merge Sort**: Consistent O(n log n), stable, but uses O(n) space
- **Heap Sort**: In-place, consistent performance, but not stable
- **Counting Sort**: Linear time for small range integers
- **Radix Sort**: Linear time for integers with fixed number of digits
- **Tim Sort**: Hybrid approach used in real-world systems
- **Hybrid approaches** often perform better than pure algorithms

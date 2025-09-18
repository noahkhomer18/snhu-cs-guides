# CS-260 Kotlin Sorting Algorithms Implementation

## 🎯 Purpose
Demonstrate various sorting algorithms implemented in Kotlin with performance analysis.

## 📝 Kotlin Sorting Algorithm Examples

### Bubble Sort
```kotlin
fun bubbleSort(arr: IntArray): IntArray {
    val result = arr.copyOf()
    val n = result.size
    
    for (i in 0 until n - 1) {
        var swapped = false
        for (j in 0 until n - i - 1) {
            if (result[j] > result[j + 1]) {
                // Swap elements
                val temp = result[j]
                result[j] = result[j + 1]
                result[j + 1] = temp
                swapped = true
            }
        }
        // If no swapping occurred, array is sorted
        if (!swapped) break
    }
    
    return result
}

// Optimized bubble sort with early termination
fun bubbleSortOptimized(arr: IntArray): IntArray {
    val result = arr.copyOf()
    var n = result.size
    
    while (n > 1) {
        var newN = 0
        for (i in 1 until n) {
            if (result[i - 1] > result[i]) {
                // Swap elements
                val temp = result[i - 1]
                result[i - 1] = result[i]
                result[i] = temp
                newN = i
            }
        }
        n = newN
    }
    
    return result
}
```

### Selection Sort
```kotlin
fun selectionSort(arr: IntArray): IntArray {
    val result = arr.copyOf()
    val n = result.size
    
    for (i in 0 until n - 1) {
        var minIndex = i
        
        // Find minimum element in remaining array
        for (j in i + 1 until n) {
            if (result[j] < result[minIndex]) {
                minIndex = j
            }
        }
        
        // Swap if minimum is not at current position
        if (minIndex != i) {
            val temp = result[i]
            result[i] = result[minIndex]
            result[minIndex] = temp
        }
    }
    
    return result
}

// Selection sort with generic type
fun <T : Comparable<T>> selectionSortGeneric(arr: Array<T>): Array<T> {
    val result = arr.copyOf()
    val n = result.size
    
    for (i in 0 until n - 1) {
        var minIndex = i
        
        for (j in i + 1 until n) {
            if (result[j] < result[minIndex]) {
                minIndex = j
            }
        }
        
        if (minIndex != i) {
            val temp = result[i]
            result[i] = result[minIndex]
            result[minIndex] = temp
        }
    }
    
    return result
}
```

### Insertion Sort
```kotlin
fun insertionSort(arr: IntArray): IntArray {
    val result = arr.copyOf()
    
    for (i in 1 until result.size) {
        val key = result[i]
        var j = i - 1
        
        // Move elements greater than key one position ahead
        while (j >= 0 && result[j] > key) {
            result[j + 1] = result[j]
            j--
        }
        result[j + 1] = key
    }
    
    return result
}

// Insertion sort with binary search optimization
fun insertionSortBinary(arr: IntArray): IntArray {
    val result = arr.copyOf()
    
    for (i in 1 until result.size) {
        val key = result[i]
        val pos = binarySearchPosition(result, 0, i - 1, key)
        
        // Shift elements to make room
        for (j in i downTo pos + 1) {
            result[j] = result[j - 1]
        }
        result[pos] = key
    }
    
    return result
}

private fun binarySearchPosition(arr: IntArray, left: Int, right: Int, key: Int): Int {
    var low = left
    var high = right
    
    while (low <= high) {
        val mid = (low + high) / 2
        when {
            arr[mid] == key -> return mid
            arr[mid] < key -> low = mid + 1
            else -> high = mid - 1
        }
    }
    
    return low
}
```

### Merge Sort
```kotlin
fun mergeSort(arr: IntArray): IntArray {
    if (arr.size <= 1) return arr
    
    val mid = arr.size / 2
    val left = mergeSort(arr.sliceArray(0 until mid))
    val right = mergeSort(arr.sliceArray(mid until arr.size))
    
    return merge(left, right)
}

private fun merge(left: IntArray, right: IntArray): IntArray {
    val result = IntArray(left.size + right.size)
    var i = 0
    var j = 0
    var k = 0
    
    // Merge elements in sorted order
    while (i < left.size && j < right.size) {
        if (left[i] <= right[j]) {
            result[k++] = left[i++]
        } else {
            result[k++] = right[j++]
        }
    }
    
    // Copy remaining elements
    while (i < left.size) {
        result[k++] = left[i++]
    }
    while (j < right.size) {
        result[k++] = right[j++]
    }
    
    return result
}

// In-place merge sort
fun mergeSortInPlace(arr: IntArray, left: Int = 0, right: Int = arr.size - 1) {
    if (left < right) {
        val mid = (left + right) / 2
        mergeSortInPlace(arr, left, mid)
        mergeSortInPlace(arr, mid + 1, right)
        mergeInPlace(arr, left, mid, right)
    }
}

private fun mergeInPlace(arr: IntArray, left: Int, mid: Int, right: Int) {
    val leftArray = arr.sliceArray(left..mid)
    val rightArray = arr.sliceArray(mid + 1..right)
    
    var i = 0
    var j = 0
    var k = left
    
    while (i < leftArray.size && j < rightArray.size) {
        if (leftArray[i] <= rightArray[j]) {
            arr[k++] = leftArray[i++]
        } else {
            arr[k++] = rightArray[j++]
        }
    }
    
    while (i < leftArray.size) {
        arr[k++] = leftArray[i++]
    }
    while (j < rightArray.size) {
        arr[k++] = rightArray[j++]
    }
}
```

### Quick Sort
```kotlin
fun quickSort(arr: IntArray, low: Int = 0, high: Int = arr.size - 1) {
    if (low < high) {
        val pivotIndex = partition(arr, low, high)
        quickSort(arr, low, pivotIndex - 1)
        quickSort(arr, pivotIndex + 1, high)
    }
}

private fun partition(arr: IntArray, low: Int, high: Int): Int {
    val pivot = arr[high]
    var i = low - 1
    
    for (j in low until high) {
        if (arr[j] <= pivot) {
            i++
            swap(arr, i, j)
        }
    }
    
    swap(arr, i + 1, high)
    return i + 1
}

private fun swap(arr: IntArray, i: Int, j: Int) {
    val temp = arr[i]
    arr[i] = arr[j]
    arr[j] = temp
}

// Quick sort with different pivot selection strategies
fun quickSortRandomPivot(arr: IntArray, low: Int = 0, high: Int = arr.size - 1) {
    if (low < high) {
        val randomIndex = (low..high).random()
        swap(arr, randomIndex, high)
        val pivotIndex = partition(arr, low, high)
        quickSortRandomPivot(arr, low, pivotIndex - 1)
        quickSortRandomPivot(arr, pivotIndex + 1, high)
    }
}

fun quickSortMedianPivot(arr: IntArray, low: Int = 0, high: Int = arr.size - 1) {
    if (low < high) {
        val medianIndex = findMedianIndex(arr, low, high)
        swap(arr, medianIndex, high)
        val pivotIndex = partition(arr, low, high)
        quickSortMedianPivot(arr, low, pivotIndex - 1)
        quickSortMedianPivot(arr, pivotIndex + 1, high)
    }
}

private fun findMedianIndex(arr: IntArray, low: Int, high: Int): Int {
    val mid = (low + high) / 2
    val a = arr[low]
    val b = arr[mid]
    val c = arr[high]
    
    return when {
        (a <= b && b <= c) || (c <= b && b <= a) -> mid
        (b <= a && a <= c) || (c <= a && a <= b) -> low
        else -> high
    }
}
```

### Heap Sort
```kotlin
fun heapSort(arr: IntArray) {
    val n = arr.size
    
    // Build max heap
    for (i in n / 2 - 1 downTo 0) {
        heapify(arr, n, i)
    }
    
    // Extract elements from heap one by one
    for (i in n - 1 downTo 1) {
        swap(arr, 0, i)
        heapify(arr, i, 0)
    }
}

private fun heapify(arr: IntArray, n: Int, i: Int) {
    var largest = i
    val left = 2 * i + 1
    val right = 2 * i + 2
    
    // If left child is larger than root
    if (left < n && arr[left] > arr[largest]) {
        largest = left
    }
    
    // If right child is larger than largest so far
    if (right < n && arr[right] > arr[largest]) {
        largest = right
    }
    
    // If largest is not root
    if (largest != i) {
        swap(arr, i, largest)
        heapify(arr, n, largest)
    }
}

private fun swap(arr: IntArray, i: Int, j: Int) {
    val temp = arr[i]
    arr[i] = arr[j]
    arr[j] = temp
}
```

### Counting Sort
```kotlin
fun countingSort(arr: IntArray): IntArray {
    if (arr.isEmpty()) return arr
    
    val max = arr.maxOrNull()!!
    val min = arr.minOrNull()!!
    val range = max - min + 1
    
    val count = IntArray(range)
    val output = IntArray(arr.size)
    
    // Count occurrences
    for (num in arr) {
        count[num - min]++
    }
    
    // Modify count array to store positions
    for (i in 1 until range) {
        count[i] += count[i - 1]
    }
    
    // Build output array
    for (i in arr.size - 1 downTo 0) {
        output[count[arr[i] - min] - 1] = arr[i]
        count[arr[i] - min]--
    }
    
    return output
}
```

### Radix Sort
```kotlin
fun radixSort(arr: IntArray): IntArray {
    if (arr.isEmpty()) return arr
    
    val max = arr.maxOrNull()!!
    var result = arr.copyOf()
    
    // Sort by each digit
    var exp = 1
    while (max / exp > 0) {
        result = countingSortByDigit(result, exp)
        exp *= 10
    }
    
    return result
}

private fun countingSortByDigit(arr: IntArray, exp: Int): IntArray {
    val output = IntArray(arr.size)
    val count = IntArray(10)
    
    // Count occurrences of each digit
    for (num in arr) {
        count[(num / exp) % 10]++
    }
    
    // Modify count array to store positions
    for (i in 1 until 10) {
        count[i] += count[i - 1]
    }
    
    // Build output array
    for (i in arr.size - 1 downTo 0) {
        output[count[(arr[i] / exp) % 10] - 1] = arr[i]
        count[(arr[i] / exp) % 10]--
    }
    
    return output
}
```

### Performance Testing
```kotlin
fun measureSortingTime(sortFunction: (IntArray) -> IntArray, arr: IntArray): Long {
    val startTime = System.nanoTime()
    sortFunction(arr)
    val endTime = System.nanoTime()
    return (endTime - startTime) / 1_000_000 // Convert to milliseconds
}

fun measureInPlaceSortingTime(sortFunction: (IntArray) -> Unit, arr: IntArray): Long {
    val startTime = System.nanoTime()
    sortFunction(arr)
    val endTime = System.nanoTime()
    return (endTime - startTime) / 1_000_000
}

fun main() {
    val sizes = listOf(100, 1000, 10000)
    
    for (size in sizes) {
        println("Testing with array size: $size")
        val arr = IntArray(size) { (0..1000).random() }
        
        // Test different sorting algorithms
        val bubbleTime = measureSortingTime(::bubbleSort, arr)
        val selectionTime = measureSortingTime(::selectionSort, arr)
        val insertionTime = measureSortingTime(::insertionSort, arr)
        val mergeTime = measureSortingTime(::mergeSort, arr)
        
        val quickArr = arr.copyOf()
        val quickTime = measureInPlaceSortingTime(::quickSort, quickArr)
        
        val heapArr = arr.copyOf()
        val heapTime = measureInPlaceSortingTime(::heapSort, heapArr)
        
        val countingTime = measureSortingTime(::countingSort, arr)
        val radixTime = measureSortingTime(::radixSort, arr)
        
        println("Bubble Sort: ${bubbleTime}ms")
        println("Selection Sort: ${selectionTime}ms")
        println("Insertion Sort: ${insertionTime}ms")
        println("Merge Sort: ${mergeTime}ms")
        println("Quick Sort: ${quickTime}ms")
        println("Heap Sort: ${heapTime}ms")
        println("Counting Sort: ${countingTime}ms")
        println("Radix Sort: ${radixTime}ms")
        println()
    }
}
```

## 🔍 Sorting Algorithm Complexity

| Algorithm | Best Case | Average Case | Worst Case | Space | Stable |
|-----------|-----------|--------------|------------|-------|--------|
| Bubble Sort | O(n) | O(n²) | O(n²) | O(1) | Yes |
| Selection Sort | O(n²) | O(n²) | O(n²) | O(1) | No |
| Insertion Sort | O(n) | O(n²) | O(n²) | O(1) | Yes |
| Merge Sort | O(n log n) | O(n log n) | O(n log n) | O(n) | Yes |
| Quick Sort | O(n log n) | O(n log n) | O(n²) | O(log n) | No |
| Heap Sort | O(n log n) | O(n log n) | O(n log n) | O(1) | No |
| Counting Sort | O(n + k) | O(n + k) | O(n + k) | O(k) | Yes |
| Radix Sort | O(d(n + k)) | O(d(n + k)) | O(d(n + k)) | O(n + k) | Yes |

## 💡 Learning Points
- **Comparison-based sorts** have O(n log n) lower bound
- **Non-comparison sorts** can achieve O(n) time complexity
- **Stable sorts** maintain relative order of equal elements
- **In-place sorts** use O(1) extra space
- **Adaptive sorts** perform better on partially sorted data
- **Pivot selection** affects Quick Sort performance
- **Hybrid algorithms** combine multiple sorting strategies
- **Memory access patterns** affect cache performance

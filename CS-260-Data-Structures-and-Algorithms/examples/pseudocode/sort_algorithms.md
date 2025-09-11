# Sorting Algorithms – Pseudocode

## Selection Sort
```
for i = 0 to n-1
    minIndex = i
    for j = i+1 to n
        if A[j] < A[minIndex]
            minIndex = j
    swap A[i] and A[minIndex]
```

## Quick Sort
```
function quickSort(A, low, high)
    if low < high
        pi = partition(A, low, high)
        quickSort(A, low, pi-1)
        quickSort(A, pi+1, high)
```

## Merge Sort
```
function mergeSort(A)
    if n <= 1 return
    split A into left and right
    mergeSort(left)
    mergeSort(right)
    merge(left, right, A)
```

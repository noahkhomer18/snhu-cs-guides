# CS-300 Advanced Algorithms

## 🎯 Purpose
Demonstrate advanced algorithmic concepts and optimization techniques.

## 📝 Advanced Algorithm Examples

### Dynamic Programming
```java
public class DynamicProgramming {
    
    // Fibonacci with memoization
    public static long fibonacci(int n) {
        long[] memo = new long[n + 1];
        return fibonacciMemo(n, memo);
    }
    
    private static long fibonacciMemo(int n, long[] memo) {
        if (n <= 1) return n;
        if (memo[n] != 0) return memo[n];
        
        memo[n] = fibonacciMemo(n - 1, memo) + fibonacciMemo(n - 2, memo);
        return memo[n];
    }
    
    // Longest Common Subsequence
    public static int lcs(String s1, String s2) {
        int m = s1.length();
        int n = s2.length();
        int[][] dp = new int[m + 1][n + 1];
        
        for (int i = 1; i <= m; i++) {
            for (int j = 1; j <= n; j++) {
                if (s1.charAt(i - 1) == s2.charAt(j - 1)) {
                    dp[i][j] = dp[i - 1][j - 1] + 1;
                } else {
                    dp[i][j] = Math.max(dp[i - 1][j], dp[i][j - 1]);
                }
            }
        }
        return dp[m][n];
    }
    
    // Knapsack Problem
    public static int knapsack(int[] weights, int[] values, int capacity) {
        int n = weights.length;
        int[][] dp = new int[n + 1][capacity + 1];
        
        for (int i = 1; i <= n; i++) {
            for (int w = 1; w <= capacity; w++) {
                if (weights[i - 1] <= w) {
                    dp[i][w] = Math.max(
                        values[i - 1] + dp[i - 1][w - weights[i - 1]],
                        dp[i - 1][w]
                    );
                } else {
                    dp[i][w] = dp[i - 1][w];
                }
            }
        }
        return dp[n][capacity];
    }
}
```

### Greedy Algorithms
```java
public class GreedyAlgorithms {
    
    // Activity Selection Problem
    public static List<Activity> selectActivities(List<Activity> activities) {
        activities.sort((a, b) -> Integer.compare(a.end, b.end));
        
        List<Activity> selected = new ArrayList<>();
        selected.add(activities.get(0));
        
        int lastEnd = activities.get(0).end;
        for (int i = 1; i < activities.size(); i++) {
            if (activities.get(i).start >= lastEnd) {
                selected.add(activities.get(i));
                lastEnd = activities.get(i).end;
            }
        }
        return selected;
    }
    
    // Huffman Coding
    public static HuffmanNode buildHuffmanTree(char[] chars, int[] freq) {
        PriorityQueue<HuffmanNode> pq = new PriorityQueue<>();
        
        for (int i = 0; i < chars.length; i++) {
            pq.add(new HuffmanNode(chars[i], freq[i]));
        }
        
        while (pq.size() > 1) {
            HuffmanNode left = pq.poll();
            HuffmanNode right = pq.poll();
            
            HuffmanNode merged = new HuffmanNode('\0', left.freq + right.freq);
            merged.left = left;
            merged.right = right;
            
            pq.add(merged);
        }
        return pq.poll();
    }
}
```

## 🔍 Algorithm Analysis
- **Time Complexity**: O(n²) for LCS, O(nW) for Knapsack
- **Space Complexity**: O(n²) for LCS, O(nW) for Knapsack
- **Greedy Choice**: Always make locally optimal choice

## 💡 Learning Points
- Dynamic programming solves overlapping subproblems
- Greedy algorithms make locally optimal choices
- Memoization improves recursive algorithm performance
- Problem decomposition is key to algorithm design

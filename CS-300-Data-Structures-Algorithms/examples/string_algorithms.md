# CS-300 String Algorithms

## 🎯 Purpose
Demonstrate advanced string processing algorithms and pattern matching techniques.

## 📝 String Algorithm Examples

### KMP (Knuth-Morris-Pratt) Pattern Matching
```java
public class KMPAlgorithm {
    
    public static int kmpSearch(String text, String pattern) {
        int[] lps = computeLPSArray(pattern);
        int i = 0; // index for text
        int j = 0; // index for pattern
        
        while (i < text.length()) {
            if (pattern.charAt(j) == text.charAt(i)) {
                i++;
                j++;
            }
            
            if (j == pattern.length()) {
                return i - j; // Pattern found at index i-j
            } else if (i < text.length() && pattern.charAt(j) != text.charAt(i)) {
                if (j != 0) {
                    j = lps[j - 1];
                } else {
                    i++;
                }
            }
        }
        
        return -1; // Pattern not found
    }
    
    // Compute Longest Proper Prefix which is also Suffix
    private static int[] computeLPSArray(String pattern) {
        int[] lps = new int[pattern.length()];
        int len = 0; // length of the previous longest prefix suffix
        int i = 1;
        
        while (i < pattern.length()) {
            if (pattern.charAt(i) == pattern.charAt(len)) {
                len++;
                lps[i] = len;
                i++;
            } else {
                if (len != 0) {
                    len = lps[len - 1];
                } else {
                    lps[i] = 0;
                    i++;
                }
            }
        }
        
        return lps;
    }
    
    // Find all occurrences of pattern in text
    public static List<Integer> findAllOccurrences(String text, String pattern) {
        List<Integer> occurrences = new ArrayList<>();
        int[] lps = computeLPSArray(pattern);
        int i = 0, j = 0;
        
        while (i < text.length()) {
            if (pattern.charAt(j) == text.charAt(i)) {
                i++;
                j++;
            }
            
            if (j == pattern.length()) {
                occurrences.add(i - j);
                j = lps[j - 1];
            } else if (i < text.length() && pattern.charAt(j) != text.charAt(i)) {
                if (j != 0) {
                    j = lps[j - 1];
                } else {
                    i++;
                }
            }
        }
        
        return occurrences;
    }
}
```

### Rabin-Karp Algorithm
```java
public class RabinKarpAlgorithm {
    private static final int PRIME = 101;
    
    public static int rabinKarpSearch(String text, String pattern) {
        int textLength = text.length();
        int patternLength = pattern.length();
        
        if (patternLength > textLength) return -1;
        
        long patternHash = calculateHash(pattern, patternLength);
        long textHash = calculateHash(text, patternLength);
        
        for (int i = 0; i <= textLength - patternLength; i++) {
            if (patternHash == textHash && text.substring(i, i + patternLength).equals(pattern)) {
                return i;
            }
            
            if (i < textLength - patternLength) {
                textHash = recalculateHash(text, i, i + patternLength, textHash, patternLength);
            }
        }
        
        return -1;
    }
    
    private static long calculateHash(String str, int length) {
        long hash = 0;
        for (int i = 0; i < length; i++) {
            hash += str.charAt(i) * Math.pow(PRIME, i);
        }
        return hash;
    }
    
    private static long recalculateHash(String str, int oldIndex, int newIndex, long oldHash, int patternLength) {
        long newHash = oldHash - str.charAt(oldIndex);
        newHash = newHash / PRIME;
        newHash += str.charAt(newIndex) * Math.pow(PRIME, patternLength - 1);
        return newHash;
    }
}
```

### Z-Algorithm
```java
public class ZAlgorithm {
    
    public static int[] computeZArray(String str) {
        int n = str.length();
        int[] z = new int[n];
        int left = 0, right = 0;
        
        for (int i = 1; i < n; i++) {
            if (i > right) {
                left = right = i;
                while (right < n && str.charAt(right - left) == str.charAt(right)) {
                    right++;
                }
                z[i] = right - left;
                right--;
            } else {
                int k = i - left;
                if (z[k] < right - i + 1) {
                    z[i] = z[k];
                } else {
                    left = i;
                    while (right < n && str.charAt(right - left) == str.charAt(right)) {
                        right++;
                    }
                    z[i] = right - left;
                    right--;
                }
            }
        }
        
        return z;
    }
    
    public static List<Integer> findPattern(String text, String pattern) {
        String combined = pattern + "$" + text;
        int[] z = computeZArray(combined);
        List<Integer> occurrences = new ArrayList<>();
        
        for (int i = pattern.length() + 1; i < z.length; i++) {
            if (z[i] == pattern.length()) {
                occurrences.add(i - pattern.length() - 1);
            }
        }
        
        return occurrences;
    }
}
```

### Suffix Array Construction
```java
public class SuffixArray {
    
    public static int[] buildSuffixArray(String text) {
        int n = text.length();
        Suffix[] suffixes = new Suffix[n];
        
        for (int i = 0; i < n; i++) {
            suffixes[i] = new Suffix(i, text.charAt(i), i + 1 < n ? text.charAt(i + 1) : -1);
        }
        
        // Sort by first 2 characters
        Arrays.sort(suffixes, (a, b) -> {
            if (a.rank[0] == b.rank[0]) {
                return Integer.compare(a.rank[1], b.rank[1]);
            }
            return Integer.compare(a.rank[0], b.rank[0]);
        });
        
        int[] ind = new int[n];
        for (int k = 4; k < 2 * n; k *= 2) {
            int rank = 0;
            int prevRank = suffixes[0].rank[0];
            suffixes[0].rank[0] = rank;
            ind[suffixes[0].index] = 0;
            
            for (int i = 1; i < n; i++) {
                if (suffixes[i].rank[0] == prevRank && suffixes[i].rank[1] == suffixes[i - 1].rank[1]) {
                    prevRank = suffixes[i].rank[0];
                    suffixes[i].rank[0] = rank;
                } else {
                    prevRank = suffixes[i].rank[0];
                    suffixes[i].rank[0] = ++rank;
                }
                ind[suffixes[i].index] = i;
            }
            
            for (int i = 0; i < n; i++) {
                int nextIndex = suffixes[i].index + k / 2;
                suffixes[i].rank[1] = (nextIndex < n) ? suffixes[ind[nextIndex]].rank[0] : -1;
            }
            
            Arrays.sort(suffixes, (a, b) -> {
                if (a.rank[0] == b.rank[0]) {
                    return Integer.compare(a.rank[1], b.rank[1]);
                }
                return Integer.compare(a.rank[0], b.rank[0]);
            });
        }
        
        int[] suffixArray = new int[n];
        for (int i = 0; i < n; i++) {
            suffixArray[i] = suffixes[i].index;
        }
        
        return suffixArray;
    }
    
    static class Suffix {
        int index;
        int[] rank = new int[2];
        
        Suffix(int index, int rank0, int rank1) {
            this.index = index;
            this.rank[0] = rank0;
            this.rank[1] = rank1;
        }
    }
}
```

### Longest Common Subsequence (LCS)
```java
public class LongestCommonSubsequence {
    
    public static int lcsLength(String s1, String s2) {
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
    
    public static String lcsString(String s1, String s2) {
        int m = s1.length();
        int n = s2.length();
        int[][] dp = new int[m + 1][n + 1];
        
        // Fill DP table
        for (int i = 1; i <= m; i++) {
            for (int j = 1; j <= n; j++) {
                if (s1.charAt(i - 1) == s2.charAt(j - 1)) {
                    dp[i][j] = dp[i - 1][j - 1] + 1;
                } else {
                    dp[i][j] = Math.max(dp[i - 1][j], dp[i][j - 1]);
                }
            }
        }
        
        // Reconstruct LCS
        StringBuilder lcs = new StringBuilder();
        int i = m, j = n;
        
        while (i > 0 && j > 0) {
            if (s1.charAt(i - 1) == s2.charAt(j - 1)) {
                lcs.insert(0, s1.charAt(i - 1));
                i--;
                j--;
            } else if (dp[i - 1][j] > dp[i][j - 1]) {
                i--;
            } else {
                j--;
            }
        }
        
        return lcs.toString();
    }
}
```

### Edit Distance (Levenshtein Distance)
```java
public class EditDistance {
    
    public static int editDistance(String s1, String s2) {
        int m = s1.length();
        int n = s2.length();
        int[][] dp = new int[m + 1][n + 1];
        
        // Initialize base cases
        for (int i = 0; i <= m; i++) {
            dp[i][0] = i;
        }
        for (int j = 0; j <= n; j++) {
            dp[0][j] = j;
        }
        
        // Fill DP table
        for (int i = 1; i <= m; i++) {
            for (int j = 1; j <= n; j++) {
                if (s1.charAt(i - 1) == s2.charAt(j - 1)) {
                    dp[i][j] = dp[i - 1][j - 1];
                } else {
                    dp[i][j] = 1 + Math.min(
                        Math.min(dp[i - 1][j],     // deletion
                                dp[i][j - 1]),     // insertion
                        dp[i - 1][j - 1]          // substitution
                    );
                }
            }
        }
        
        return dp[m][n];
    }
    
    // Space-optimized version
    public static int editDistanceOptimized(String s1, String s2) {
        int m = s1.length();
        int n = s2.length();
        
        if (m < n) {
            return editDistanceOptimized(s2, s1);
        }
        
        int[] prev = new int[n + 1];
        int[] curr = new int[n + 1];
        
        for (int j = 0; j <= n; j++) {
            prev[j] = j;
        }
        
        for (int i = 1; i <= m; i++) {
            curr[0] = i;
            for (int j = 1; j <= n; j++) {
                if (s1.charAt(i - 1) == s2.charAt(j - 1)) {
                    curr[j] = prev[j - 1];
                } else {
                    curr[j] = 1 + Math.min(
                        Math.min(prev[j], curr[j - 1]), prev[j - 1]
                    );
                }
            }
            System.arraycopy(curr, 0, prev, 0, n + 1);
        }
        
        return prev[n];
    }
}
```

### Palindrome Detection
```java
public class PalindromeAlgorithms {
    
    // Check if string is palindrome
    public static boolean isPalindrome(String s) {
        int left = 0, right = s.length() - 1;
        
        while (left < right) {
            if (s.charAt(left) != s.charAt(right)) {
                return false;
            }
            left++;
            right--;
        }
        
        return true;
    }
    
    // Find longest palindromic substring using expand around centers
    public static String longestPalindrome(String s) {
        if (s == null || s.length() < 1) return "";
        
        int start = 0, end = 0;
        
        for (int i = 0; i < s.length(); i++) {
            int len1 = expandAroundCenter(s, i, i);     // odd length
            int len2 = expandAroundCenter(s, i, i + 1); // even length
            int len = Math.max(len1, len2);
            
            if (len > end - start) {
                start = i - (len - 1) / 2;
                end = i + len / 2;
            }
        }
        
        return s.substring(start, end + 1);
    }
    
    private static int expandAroundCenter(String s, int left, int right) {
        while (left >= 0 && right < s.length() && s.charAt(left) == s.charAt(right)) {
            left--;
            right++;
        }
        return right - left - 1;
    }
    
    // Count palindromic substrings
    public static int countPalindromes(String s) {
        int count = 0;
        
        for (int i = 0; i < s.length(); i++) {
            count += expandAroundCenter(s, i, i);     // odd length
            count += expandAroundCenter(s, i, i + 1); // even length
        }
        
        return count;
    }
}
```

## 🔍 Algorithm Analysis
- **KMP Time Complexity**: O(m + n) where m = pattern length, n = text length
- **Rabin-Karp Time Complexity**: O(m + n) average case, O(mn) worst case
- **Z-Algorithm Time Complexity**: O(m + n)
- **Suffix Array Time Complexity**: O(n log n)
- **LCS Time Complexity**: O(mn) where m, n are string lengths
- **Edit Distance Time Complexity**: O(mn)
- **Palindrome Detection Time Complexity**: O(n²) for longest palindrome

## 💡 Learning Points
- **Pattern matching** is fundamental to text processing
- **KMP algorithm** avoids redundant comparisons using failure function
- **Rabin-Karp** uses hashing for efficient pattern matching
- **Suffix arrays** enable efficient substring operations
- **Dynamic programming** solves many string problems optimally
- **Space optimization** can significantly improve performance

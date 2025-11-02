# Assignment Structure Guide

## Part 1: Rank-1 Approximation
**What to include:**
- MATLAB code using `svd()` function
- `A1` clearly stated (rounded to 4 decimals)
- RMSE calculation between `A` and `A1`
- Brief explanation of what rank-1 approximation means

## Part 2: Rank-2 Approximation
**What to include:**
- MATLAB code using `svd()` function
- `A2` clearly stated (rounded to 4 decimals)
- RMSE calculation between `A` and `A2`
- Comparison: Which approximation is better and why

## Part 3: Vector Operations on U Matrix
**What to include:**
- MATLAB code for `dot(u1, u2)` → `d1`
- MATLAB code for `cross(u1, u2)` → `c`
- MATLAB code for `dot(c, u3)` → `d2`
- Explanation: Do these values make sense? (Think about properties of U matrix columns)

## Part 4: Span Check
**What to include:**
- Method used to determine if columns of U span R³
- MATLAB code to support your method (rank, determinant, or other)
- Clear conclusion: Yes/No with reasoning

## Part 5: Image Compression - Load and Setup
**What to include:**
- MATLAB code to load image using `imshow()` or `load()` then display
- Derivation of `k` value for CR ≈ 2
- Construction of rank-k approximation

## Part 6: Analysis and Recommendations
**What to include:**
- Display of rank-k approximate image
- RMSE calculation for each CR tested (2, 10, 25, 75)
- All approximate images included in report
- Trend analysis as CR increases
- Recommendation for "best CR" with justification


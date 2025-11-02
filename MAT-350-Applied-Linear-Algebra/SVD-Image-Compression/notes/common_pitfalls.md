# Common Pitfalls and Mistakes

## SVD and Approximations

❌ **Wrong:** Using `S` matrix incorrectly
- Don't forget SVD gives `A = U * S * V'` (note the transpose on V)
- For rank-k: extract first k columns of U and V, k×k block of S

❌ **Wrong:** Not rounding to 4 decimal places
- Assignment specifically requires 4 decimals for `A1` and `A2`

❌ **Wrong:** Confusing rank-1 vs rank-2 construction
- Rank-1: single column/row vectors with scalar multiplication
- Rank-2: 2×2 block matrix multiplication

## Vector Operations

❌ **Wrong:** Mixing up column vs row vectors
- `U(:, 1)` extracts column vector (correct)
- `U(1, :)` extracts row vector (wrong for this context)

❌ **Wrong:** Not understanding what dot/cross products should yield
- For orthonormal U: `dot(u1, u2)` ≈ 0 (orthogonal)
- `dot(cross(u1, u2), u3)` relates to orientation/volume

## Span Check

❌ **Wrong:** Only stating conclusion without showing work
- Must show MATLAB code (rank, det, rref, etc.)
- Explain the method used

❌ **Wrong:** Incorrect method for span check
- For 3×3: rank should be 3, or det should be non-zero
- RREF should show identity matrix if spanning

## Image Compression

❌ **Wrong:** Incorrect k calculation for target CR
- Formula: `k = round((m × n) / (CR × (m + n + 1)))`
- Don't forget to round to nearest integer

❌ **Wrong:** Not converting data types properly
- Original image may be uint8
- SVD requires double/float
- Display requires uint8 conversion: `imshow(uint8(A_k))`

❌ **Wrong:** Missing images in report
- Must include all approximate images for CRs: 2, 10, 25, 75

## RMSE Calculation

❌ **Wrong:** Incorrect RMSE formula
- Should use element-wise operations: `(A - A_k).^2`
- Then mean, then square root
- Use helper function provided or show correct formula

## General

❌ **Wrong:** No MATLAB code/terminal output included
- Assignment requires showing work, not just final answers

❌ **Wrong:** Unclear or missing explanations
- Must explain "why" for comparisons and recommendations
- Trend analysis requires clear description

❌ **Wrong:** Poor code organization
- Use section headers (`%%`)
- Comment your steps
- Label outputs clearly


# Compression Ratio (CR) Formula

## Definition

Compression Ratio measures how much data reduction is achieved:

```
CR = (original storage) / (compressed storage)
```

## For SVD Rank-k Approximation

When using rank-k approximation, the storage needed is:

**Compressed storage = k(m + n + 1)**

Where:
- `k` = rank of approximation
- `m` = number of rows
- `n` = number of columns

**Original storage = m × n**

Therefore:

```
CR = (m × n) / (k(m + n + 1))
```

## Solving for k

To find `k` for a target compression ratio `CR_target`:

```
k = (m × n) / (CR_target × (m + n + 1))
```

Round `k` to the nearest integer.

## Example (Different Data)

For a 100×100 image wanting CR ≈ 2:
- Original storage = 100 × 100 = 10,000
- k = 10,000 / (2 × (100 + 100 + 1)) = 10,000 / 402 ≈ 24.88
- Round to k = 25

This is an example only - use your assignment image dimensions!


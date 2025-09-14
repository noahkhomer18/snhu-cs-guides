# Proof Techniques

## Direct Proof
**Method**: Assume P is true, then show Q must be true.

**Example**: Prove "If n is even, then n² is even"
- **Given**: n is even
- **To Prove**: n² is even
- **Proof**: 
  - Since n is even, n = 2k for some integer k
  - Then n² = (2k)² = 4k² = 2(2k²)
  - Since 2k² is an integer, n² is even

## Proof by Contradiction
**Method**: Assume the statement is false, then derive a contradiction.

**Example**: Prove "√2 is irrational"
- **Assume**: √2 is rational
- **Then**: √2 = p/q where p, q are integers with no common factors
- **Square both sides**: 2 = p²/q²
- **Rearrange**: 2q² = p²
- **This means**: p² is even, so p is even
- **Let p = 2k**: 2q² = (2k)² = 4k²
- **Simplify**: q² = 2k²
- **This means**: q² is even, so q is even
- **Contradiction**: Both p and q are even, but we assumed no common factors

## Proof by Contrapositive
**Method**: Prove ¬Q → ¬P instead of P → Q

**Example**: Prove "If n² is odd, then n is odd"
- **Contrapositive**: "If n is even, then n² is even"
- **Proof**: If n is even, then n = 2k
- **Then**: n² = (2k)² = 4k² = 2(2k²)
- **Therefore**: n² is even

## Mathematical Induction
**Method**: 
1. Base case: Show P(1) is true
2. Inductive step: Show P(k) → P(k+1)

**Example**: Prove 1 + 2 + 3 + ... + n = n(n+1)/2
- **Base case (n=1)**: 1 = 1(1+1)/2 = 1 ✓
- **Inductive hypothesis**: Assume true for n = k
- **Inductive step**: Show true for n = k+1
  - 1 + 2 + ... + k + (k+1) = k(k+1)/2 + (k+1)
  - = (k(k+1) + 2(k+1))/2
  - = (k+1)(k+2)/2 ✓

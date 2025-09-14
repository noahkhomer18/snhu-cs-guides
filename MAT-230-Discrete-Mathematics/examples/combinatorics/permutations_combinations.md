# Permutations and Combinations

## Permutations
**Definition**: Arrangements of objects where order matters
**Formula**: P(n,r) = n!/(n-r)!

### Examples

#### Example 1: Simple Permutation
**Problem**: How many ways can 3 people (A, B, C) be arranged in a line?
**Solution**: P(3,3) = 3! = 6 ways
- ABC, ACB, BAC, BCA, CAB, CBA

#### Example 2: Partial Permutation
**Problem**: How many ways can 4 students be chosen from 10 to fill positions of President, Vice-President, Secretary, and Treasurer?
**Solution**: P(10,4) = 10!/(10-4)! = 10!/6! = 10×9×8×7 = 5,040 ways

#### Example 3: Permutation with Repetition
**Problem**: How many 4-digit numbers can be formed using digits 1, 2, 3, 4, 5 if repetition is allowed?
**Solution**: 5⁴ = 625 ways

## Combinations
**Definition**: Selections of objects where order doesn't matter
**Formula**: C(n,r) = n!/(r!(n-r)!)

### Examples

#### Example 1: Simple Combination
**Problem**: How many ways can 2 people be chosen from 4 people (A, B, C, D)?
**Solution**: C(4,2) = 4!/(2!×2!) = 6 ways
- AB, AC, AD, BC, BD, CD

#### Example 2: Committee Selection
**Problem**: A committee of 3 people needs to be formed from 8 candidates. How many different committees are possible?
**Solution**: C(8,3) = 8!/(3!×5!) = 56 ways

#### Example 3: Mixed Selection
**Problem**: From a group of 5 men and 4 women, how many committees of 3 people can be formed with exactly 2 men?
**Solution**: 
- Choose 2 men: C(5,2) = 10 ways
- Choose 1 woman: C(4,1) = 4 ways
- Total: 10 × 4 = 40 ways

## Special Cases and Identities

### Pascal's Triangle
```
n=0:    1
n=1:   1 1
n=2:  1 2 1
n=3: 1 3 3 1
n=4:1 4 6 4 1
```

### Useful Identities
- C(n,r) = C(n,n-r) (Symmetry)
- C(n,0) = C(n,n) = 1
- C(n,1) = C(n,n-1) = n
- C(n,r) = C(n-1,r-1) + C(n-1,r) (Pascal's Identity)

## Practice Problems

1. **How many ways can 5 books be arranged on a shelf?**

2. **A pizza place offers 8 toppings. How many different 3-topping pizzas can be ordered?**

3. **From a deck of 52 cards, how many ways can you select 5 cards for a poker hand?**

4. **A password must be 6 characters long using letters A-Z and numbers 0-9. How many passwords are possible if:**
   - No repetition allowed?
   - Repetition allowed?

5. **A committee of 4 people must be formed from 6 men and 5 women. How many ways can this be done if:**
   - No restrictions?
   - Must have exactly 2 men and 2 women?
   - Must have at least 1 woman?

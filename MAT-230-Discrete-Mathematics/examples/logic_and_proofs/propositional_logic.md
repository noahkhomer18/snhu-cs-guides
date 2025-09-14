# Propositional Logic Examples

## Basic Logical Operators

### AND (∧) - Conjunction
- **Example**: "It is raining AND I have an umbrella"
- **Truth Table**:
  | P | Q | P ∧ Q |
  |---|---|-------|
  | T | T |   T   |
  | T | F |   F   |
  | F | T |   F   |
  | F | F |   F   |

### OR (∨) - Disjunction
- **Example**: "I will take the bus OR I will walk"
- **Truth Table**:
  | P | Q | P ∨ Q |
  |---|---|-------|
  | T | T |   T   |
  | T | F |   T   |
  | F | T |   T   |
  | F | F |   F   |

### NOT (¬) - Negation
- **Example**: "It is NOT raining"
- **Truth Table**:
  | P | ¬P |
  |---|----|
  | T | F  |
  | F | T  |

### IMPLIES (→) - Conditional
- **Example**: "If it rains, then the ground will be wet"
- **Truth Table**:
  | P | Q | P → Q |
  |---|---|-------|
  | T | T |   T   |
  | T | F |   F   |
  | F | T |   T   |
  | F | F |   T   |

## Practice Problems

1. **Construct truth tables for**:
   - (P ∧ Q) ∨ (¬P ∧ ¬Q)
   - (P → Q) ∧ (Q → P)
   - ¬(P ∨ Q) ∧ (P ∧ Q)

2. **Determine if the following are tautologies**:
   - P ∨ ¬P (Law of Excluded Middle)
   - (P → Q) ↔ (¬Q → ¬P) (Contrapositive)

3. **Logical Equivalences**:
   - De Morgan's Laws: ¬(P ∧ Q) ≡ ¬P ∨ ¬Q
   - Distributive Laws: P ∧ (Q ∨ R) ≡ (P ∧ Q) ∨ (P ∧ R)

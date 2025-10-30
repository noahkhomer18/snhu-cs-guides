# Inequality Constraints Template (Placeholders Only)

For each internal link variable xi:

Nonnegativity
```
xi ≥ 0  for i = 1..5
```

Capacity (from provided table)
```
xi ≤ capacity_i  for i = 1..5
```

Put them together (example pattern; do not fill numbers here):
```
0 ≤ x1 ≤ capacity_1
0 ≤ x2 ≤ capacity_2
0 ≤ x3 ≤ capacity_3
0 ≤ x4 ≤ capacity_4
0 ≤ x5 ≤ capacity_5
```

Notes
- A capacity is binding if, at the feasible solution, xi equals its capacity.
- Do not convert capacities to equalities unless justified (e.g., proven bottleneck).
- Keep directions consistent with your variable definitions in the main model.

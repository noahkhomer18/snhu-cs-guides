# Ax = b Template (Placeholders Only)

Declare variable order explicitly:

x = [x1, x2, x3, x4, x5]^T

Matrix A (5×5): each row corresponds to a router equation (A, B, C, D, E). Replace `_` with integer coefficients derived from your node balances.

A =
```
[ _  _  _  _  _ ]
[ _  _  _  _  _ ]
[ _  _  _  _  _ ]
[ _  _  _  _  _ ]
[ _  _  _  _  _ ]
```

Vector x:
```
[ x1 ]
[ x2 ]
[ x3 ]
[ x4 ]
[ x5 ]
```

Vector b (constants from external inflows/outflows):
```
[ _ ]
[ _ ]
[ _ ]
[ _ ]
[ _ ]
```

Notes
- Keep equation order consistent between A’s rows and b’s entries.
- If your system is underdetermined, document the free variable(s) elsewhere and do not add numbers here.

# MAT-243 Statistical Analysis Examples

## 🎯 Purpose
Demonstrate statistical analysis techniques and data interpretation.

## 📝 Statistical Analysis Examples

### Descriptive Statistics
```python
import numpy as np
import pandas as pd
import matplotlib.pyplot as plt
from scipy import stats

# Sample dataset
data = [85, 92, 78, 96, 88, 91, 83, 89, 94, 87, 90, 85, 93, 88, 91]

# Calculate descriptive statistics
mean_score = np.mean(data)
median_score = np.median(data)
mode_score = stats.mode(data)[0][0]
std_dev = np.std(data, ddof=1)
variance = np.var(data, ddof=1)
min_score = np.min(data)
max_score = np.max(data)
range_score = max_score - min_score

print("Descriptive Statistics:")
print(f"Mean: {mean_score:.2f}")
print(f"Median: {median_score:.2f}")
print(f"Mode: {mode_score}")
print(f"Standard Deviation: {std_dev:.2f}")
print(f"Variance: {variance:.2f}")
print(f"Range: {range_score}")
print(f"Min: {min_score}")
print(f"Max: {max_score}")

# Quartiles
q1 = np.percentile(data, 25)
q2 = np.percentile(data, 50)  # Same as median
q3 = np.percentile(data, 75)
iqr = q3 - q1

print(f"\nQuartiles:")
print(f"Q1: {q1:.2f}")
print(f"Q2 (Median): {q2:.2f}")
print(f"Q3: {q3:.2f}")
print(f"IQR: {iqr:.2f}")
```

### Hypothesis Testing
```python
# One-sample t-test
sample_data = [98, 102, 95, 99, 101, 97, 100, 96, 98, 99]
population_mean = 100
alpha = 0.05

# Perform t-test
t_stat, p_value = stats.ttest_1samp(sample_data, population_mean)

print("One-Sample T-Test:")
print(f"Sample mean: {np.mean(sample_data):.2f}")
print(f"Population mean: {population_mean}")
print(f"T-statistic: {t_stat:.4f}")
print(f"P-value: {p_value:.4f}")

if p_value < alpha:
    print("Reject null hypothesis - significant difference")
else:
    print("Fail to reject null hypothesis - no significant difference")

# Two-sample t-test
group1 = [85, 88, 92, 87, 90, 89, 91, 86, 88, 90]
group2 = [78, 82, 85, 80, 83, 81, 84, 79, 82, 83]

t_stat, p_value = stats.ttest_ind(group1, group2)

print(f"\nTwo-Sample T-Test:")
print(f"Group 1 mean: {np.mean(group1):.2f}")
print(f"Group 2 mean: {np.mean(group2):.2f}")
print(f"T-statistic: {t_stat:.4f}")
print(f"P-value: {p_value:.4f}")

if p_value < alpha:
    print("Reject null hypothesis - groups are significantly different")
else:
    print("Fail to reject null hypothesis - no significant difference")
```

### Correlation and Regression
```python
# Sample data: hours studied vs exam score
hours_studied = [2, 3, 4, 5, 6, 7, 8, 9, 10, 12]
exam_scores = [65, 70, 75, 80, 85, 88, 92, 95, 98, 100]

# Calculate correlation
correlation, p_value = stats.pearsonr(hours_studied, exam_scores)

print("Correlation Analysis:")
print(f"Correlation coefficient: {correlation:.4f}")
print(f"P-value: {p_value:.4f}")

if abs(correlation) > 0.7:
    strength = "strong"
elif abs(correlation) > 0.3:
    strength = "moderate"
else:
    strength = "weak"

if correlation > 0:
    direction = "positive"
else:
    direction = "negative"

print(f"Relationship: {strength} {direction} correlation")

# Linear regression
slope, intercept, r_value, p_value, std_err = stats.linregress(hours_studied, exam_scores)

print(f"\nLinear Regression:")
print(f"Equation: Score = {slope:.2f} * Hours + {intercept:.2f}")
print(f"R-squared: {r_value**2:.4f}")
print(f"P-value: {p_value:.4f}")

# Predict score for 11 hours of study
predicted_score = slope * 11 + intercept
print(f"Predicted score for 11 hours: {predicted_score:.2f}")
```

### Chi-Square Test
```python
# Contingency table: Gender vs Preferred Programming Language
observed = np.array([
    [15, 25, 10],  # Male: Python, Java, C++
    [20, 15, 5]    # Female: Python, Java, C++
])

# Perform chi-square test
chi2, p_value, dof, expected = stats.chi2_contingency(observed)

print("Chi-Square Test of Independence:")
print("Observed frequencies:")
print(observed)
print("\nExpected frequencies:")
print(expected)
print(f"\nChi-square statistic: {chi2:.4f}")
print(f"Degrees of freedom: {dof}")
print(f"P-value: {p_value:.4f}")

if p_value < 0.05:
    print("Reject null hypothesis - variables are dependent")
else:
    print("Fail to reject null hypothesis - variables are independent")
```

### ANOVA (Analysis of Variance)
```python
# Three groups of test scores
group_a = [85, 88, 92, 87, 90]
group_b = [78, 82, 85, 80, 83]
group_c = [95, 98, 100, 97, 99]

# Perform one-way ANOVA
f_stat, p_value = stats.f_oneway(group_a, group_b, group_c)

print("One-Way ANOVA:")
print(f"Group A mean: {np.mean(group_a):.2f}")
print(f"Group B mean: {np.mean(group_b):.2f}")
print(f"Group C mean: {np.mean(group_c):.2f}")
print(f"F-statistic: {f_stat:.4f}")
print(f"P-value: {p_value:.4f}")

if p_value < 0.05:
    print("Reject null hypothesis - at least one group is significantly different")
else:
    print("Fail to reject null hypothesis - no significant differences between groups")
```

## 🔍 Statistical Concepts
- **Descriptive Statistics**: Summarizing data characteristics
- **Inferential Statistics**: Making conclusions about populations
- **Hypothesis Testing**: Testing claims about data
- **Correlation**: Measuring relationships between variables
- **Regression**: Predicting one variable from another

## 💡 Learning Points
- Statistical analysis helps make data-driven decisions
- Proper hypothesis testing requires understanding of p-values
- Correlation doesn't imply causation
- Sample size affects statistical power
- Multiple testing requires correction for Type I errors

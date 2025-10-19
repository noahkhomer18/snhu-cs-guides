# MAT-243 Applied Statistics: Hypothesis Testing

## 🎯 Purpose
Comprehensive guide to hypothesis testing in applied statistics, including practical examples and step-by-step procedures.

## 📝 Hypothesis Testing Examples

### Example 1: One-Sample t-Test

**Scenario**: A manufacturing company claims their light bulbs last 1000 hours on average. A quality control manager tests 25 bulbs and finds they last an average of 980 hours with a standard deviation of 50 hours. Test at α = 0.05.

**Solution**:
```python
import numpy as np
from scipy import stats

# Given data
n = 25
sample_mean = 980
population_mean = 1000
sample_std = 50
alpha = 0.05

# Calculate t-statistic
t_stat = (sample_mean - population_mean) / (sample_std / np.sqrt(n))
print(f"t-statistic: {t_stat:.4f}")

# Calculate critical value
df = n - 1  # degrees of freedom
t_critical = stats.t.ppf(alpha, df)
print(f"Critical value: {t_critical:.4f}")

# Calculate p-value
p_value = stats.t.cdf(t_stat, df)
print(f"p-value: {p_value:.4f}")

# Decision
if t_stat < t_critical:
    print("Reject H0: Evidence suggests bulbs last less than 1000 hours")
else:
    print("Fail to reject H0: No evidence bulbs last less than 1000 hours")
```

### Example 2: Two-Sample t-Test

**Scenario**: A researcher wants to compare the effectiveness of two teaching methods. Method A (n=30, mean=85, std=12) and Method B (n=25, mean=78, std=15). Test if Method A is significantly better at α = 0.05.

**Solution**:
```python
import numpy as np
from scipy import stats

# Method A data
n1 = 30
mean1 = 85
std1 = 12

# Method B data
n2 = 25
mean2 = 78
std2 = 15

alpha = 0.05

# Calculate pooled standard deviation
sp = np.sqrt(((n1-1)*std1**2 + (n2-1)*std2**2) / (n1+n2-2))
print(f"Pooled standard deviation: {sp:.4f}")

# Calculate t-statistic
t_stat = (mean1 - mean2) / (sp * np.sqrt(1/n1 + 1/n2))
print(f"t-statistic: {t_stat:.4f}")

# Calculate degrees of freedom
df = n1 + n2 - 2
print(f"Degrees of freedom: {df}")

# Calculate critical value (one-tailed)
t_critical = stats.t.ppf(1-alpha, df)
print(f"Critical value: {t_critical:.4f}")

# Calculate p-value
p_value = 1 - stats.t.cdf(t_stat, df)
print(f"p-value: {p_value:.4f}")

# Decision
if t_stat > t_critical:
    print("Reject H0: Method A is significantly better")
else:
    print("Fail to reject H0: No significant difference")
```

### Example 3: Chi-Square Test of Independence

**Scenario**: A survey of 200 people asks about their preference for coffee (Regular, Decaf, None) and their age group (18-30, 31-50, 51+). Test if coffee preference is independent of age at α = 0.05.

**Observed Data**:
```
                Regular  Decaf  None  Total
18-30           25       15     10    50
31-50           30       20     20    70
51+             20       25     35    80
Total           75       60     65    200
```

**Solution**:
```python
import numpy as np
from scipy.stats import chi2_contingency

# Observed frequencies
observed = np.array([
    [25, 15, 10],
    [30, 20, 20],
    [20, 25, 35]
])

# Perform chi-square test
chi2_stat, p_value, dof, expected = chi2_contingency(observed)

print(f"Chi-square statistic: {chi2_stat:.4f}")
print(f"p-value: {p_value:.4f}")
print(f"Degrees of freedom: {dof}")
print(f"Expected frequencies:")
print(expected)

# Critical value
alpha = 0.05
chi2_critical = stats.chi2.ppf(1-alpha, dof)
print(f"Critical value: {chi2_critical:.4f}")

# Decision
if chi2_stat > chi2_critical:
    print("Reject H0: Coffee preference is not independent of age")
else:
    print("Fail to reject H0: Coffee preference is independent of age")
```

## 🔍 Hypothesis Testing Procedures

### 1. State the Hypotheses
- **Null Hypothesis (H₀)**: Statement of no effect or no difference
- **Alternative Hypothesis (H₁)**: Statement of effect or difference
- **One-tailed vs. Two-tailed**: Direction of the test

### 2. Choose Significance Level
- **α = 0.05**: Most common choice (5% chance of Type I error)
- **α = 0.01**: More conservative (1% chance of Type I error)
- **α = 0.10**: Less conservative (10% chance of Type I error)

### 3. Select Test Statistic
- **t-test**: For means (one-sample, two-sample, paired)
- **z-test**: For proportions or when σ is known
- **Chi-square**: For categorical data
- **F-test**: For variances

### 4. Calculate Test Statistic
- **Formula**: Depends on the test type
- **Critical Value**: From statistical tables
- **p-value**: Probability of observing the result

### 5. Make Decision
- **Reject H₀**: If test statistic > critical value or p-value < α
- **Fail to reject H₀**: If test statistic ≤ critical value or p-value ≥ α

## 📊 Common Test Types

### Parametric Tests
| Test Type | Use Case | Assumptions |
|-----------|----------|-------------|
| One-sample t-test | Test if mean = specific value | Normal distribution |
| Two-sample t-test | Compare two means | Normal distribution, equal variances |
| Paired t-test | Compare before/after | Normal distribution of differences |
| ANOVA | Compare multiple means | Normal distribution, equal variances |
| F-test | Compare variances | Normal distribution |

### Non-parametric Tests
| Test Type | Use Case | Assumptions |
|-----------|----------|-------------|
| Mann-Whitney U | Compare two medians | Independent samples |
| Wilcoxon signed-rank | Paired data | Symmetric distribution |
| Kruskal-Wallis | Multiple medians | Independent samples |
| Chi-square | Categorical data | Expected frequency ≥ 5 |

## 🛠️ Python Implementation

### Complete Hypothesis Testing Function
```python
def hypothesis_test(data, test_type, alpha=0.05, **kwargs):
    """
    Perform hypothesis testing with comprehensive output
    
    Parameters:
    data: array-like, input data
    test_type: str, type of test to perform
    alpha: float, significance level
    **kwargs: additional parameters for specific tests
    """
    import numpy as np
    from scipy import stats
    
    if test_type == 'one_sample_t':
        # One-sample t-test
        n = len(data)
        sample_mean = np.mean(data)
        sample_std = np.std(data, ddof=1)
        pop_mean = kwargs.get('pop_mean', 0)
        
        t_stat = (sample_mean - pop_mean) / (sample_std / np.sqrt(n))
        df = n - 1
        p_value = 2 * (1 - stats.t.cdf(abs(t_stat), df))
        critical_value = stats.t.ppf(1 - alpha/2, df)
        
        return {
            'test_statistic': t_stat,
            'p_value': p_value,
            'critical_value': critical_value,
            'degrees_of_freedom': df,
            'decision': 'Reject H0' if abs(t_stat) > critical_value else 'Fail to reject H0'
        }
    
    elif test_type == 'two_sample_t':
        # Two-sample t-test
        data1, data2 = data
        n1, n2 = len(data1), len(data2)
        mean1, mean2 = np.mean(data1), np.mean(data2)
        std1, std2 = np.std(data1, ddof=1), np.std(data2, ddof=1)
        
        # Pooled standard deviation
        sp = np.sqrt(((n1-1)*std1**2 + (n2-1)*std2**2) / (n1+n2-2))
        t_stat = (mean1 - mean2) / (sp * np.sqrt(1/n1 + 1/n2))
        df = n1 + n2 - 2
        p_value = 2 * (1 - stats.t.cdf(abs(t_stat), df))
        critical_value = stats.t.ppf(1 - alpha/2, df)
        
        return {
            'test_statistic': t_stat,
            'p_value': p_value,
            'critical_value': critical_value,
            'degrees_of_freedom': df,
            'decision': 'Reject H0' if abs(t_stat) > critical_value else 'Fail to reject H0'
        }
    
    elif test_type == 'chi_square':
        # Chi-square test of independence
        chi2_stat, p_value, dof, expected = chi2_contingency(data)
        critical_value = stats.chi2.ppf(1 - alpha, dof)
        
        return {
            'test_statistic': chi2_stat,
            'p_value': p_value,
            'critical_value': critical_value,
            'degrees_of_freedom': dof,
            'expected_frequencies': expected,
            'decision': 'Reject H0' if chi2_stat > critical_value else 'Fail to reject H0'
        }
```

## 📋 Hypothesis Testing Checklist

### Before Testing
- [ ] Clearly state the research question
- [ ] Identify the appropriate test
- [ ] Check assumptions
- [ ] Set significance level
- [ ] Determine sample size

### During Testing
- [ ] Calculate test statistic correctly
- [ ] Find critical value or p-value
- [ ] Make decision based on results
- [ ] Interpret results in context

### After Testing
- [ ] Report results clearly
- [ ] Discuss practical significance
- [ ] Note any limitations
- [ ] Suggest further research

## 🎯 MAT-243 Learning Outcomes

### Statistical Concepts
- **Hypothesis Formulation**: Creating appropriate null and alternative hypotheses
- **Test Selection**: Choosing the right statistical test
- **Assumption Checking**: Verifying test assumptions
- **Result Interpretation**: Understanding and explaining results

### Technical Skills
- **Calculation Skills**: Computing test statistics and p-values
- **Software Usage**: Using statistical software effectively
- **Critical Thinking**: Evaluating statistical evidence
- **Communication**: Presenting statistical results clearly

## 💡 Pro Tips

1. **Always check assumptions** before performing tests
2. **Use appropriate software** for complex calculations
3. **Interpret results in context** of the research question
4. **Consider practical significance** in addition to statistical significance
5. **Report confidence intervals** along with p-values
6. **Document your process** for reproducibility
7. **Understand the limitations** of your tests
8. **Consider multiple testing** when appropriate

---

*This hypothesis testing guide provides comprehensive examples and procedures for MAT-243 Applied Statistics, helping students master statistical inference and decision-making.*

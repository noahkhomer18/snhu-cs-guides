# Science Elective Lab Experiments

## 🎯 Purpose
Demonstrate common laboratory experiments and scientific methodology across different science disciplines.

## 📝 Lab Experiment Examples

### Biology: Enzyme Activity
```python
import matplotlib.pyplot as plt
import numpy as np

class EnzymeActivityLab:
    def __init__(self):
        self.temperature_data = []
        self.activity_data = []
    
    def measure_enzyme_activity(self, temperature, substrate_concentration=1.0):
        """
        Simulate enzyme activity measurement
        temperature: temperature in Celsius
        substrate_concentration: substrate concentration (mM)
        """
        # Simulate enzyme activity curve (optimal around 37°C)
        optimal_temp = 37
        max_activity = 100
        
        # Activity decreases as temperature deviates from optimal
        activity = max_activity * np.exp(-((temperature - optimal_temp) / 20)**2)
        
        # Add some experimental noise
        noise = np.random.normal(0, 5)
        activity += noise
        
        # Ensure activity is positive
        activity = max(0, activity)
        
        return activity
    
    def run_temperature_experiment(self):
        """Run experiment at different temperatures"""
        temperatures = range(0, 61, 5)  # 0°C to 60°C in 5°C steps
        
        for temp in temperatures:
            activity = self.measure_enzyme_activity(temp)
            self.temperature_data.append(temp)
            self.activity_data.append(activity)
        
        return self.temperature_data, self.activity_data
    
    def plot_results(self):
        """Plot enzyme activity vs temperature"""
        plt.figure(figsize=(10, 6))
        plt.plot(self.temperature_data, self.activity_data, 'bo-', linewidth=2, markersize=8)
        plt.xlabel('Temperature (°C)')
        plt.ylabel('Enzyme Activity (%)')
        plt.title('Effect of Temperature on Enzyme Activity')
        plt.grid(True, alpha=0.3)
        plt.axvline(x=37, color='r', linestyle='--', alpha=0.7, label='Optimal Temperature')
        plt.legend()
        plt.show()
    
    def calculate_optimal_temperature(self):
        """Find temperature with maximum activity"""
        max_activity = max(self.activity_data)
        max_index = self.activity_data.index(max_activity)
        optimal_temp = self.temperature_data[max_index]
        return optimal_temp, max_activity

# Example usage
lab = EnzymeActivityLab()
temps, activities = lab.run_temperature_experiment()
optimal_temp, max_activity = lab.calculate_optimal_temperature()

print(f"Optimal temperature: {optimal_temp}°C")
print(f"Maximum activity: {max_activity:.1f}%")
lab.plot_results()
```

### Chemistry: pH Titration
```python
class pHTitrationLab:
    def __init__(self):
        self.volume_data = []
        self.ph_data = []
    
    def calculate_ph(self, volume_naoh, concentration_naoh=0.1, concentration_hcl=0.1, initial_volume=25):
        """
        Calculate pH during titration
        volume_naoh: volume of NaOH added (mL)
        concentration_naoh: concentration of NaOH (M)
        concentration_hcl: concentration of HCl (M)
        initial_volume: initial volume of HCl (mL)
        """
        # Moles of acid and base
        moles_hcl = concentration_hcl * initial_volume / 1000
        moles_naoh = concentration_naoh * volume_naoh / 1000
        
        # Total volume
        total_volume = (initial_volume + volume_naoh) / 1000
        
        if moles_naoh < moles_hcl:
            # Before equivalence point - excess acid
            excess_hcl = moles_hcl - moles_naoh
            h_plus_concentration = excess_hcl / total_volume
            ph = -np.log10(h_plus_concentration)
        elif moles_naoh > moles_hcl:
            # After equivalence point - excess base
            excess_naoh = moles_naoh - moles_hcl
            oh_minus_concentration = excess_naoh / total_volume
            poh = -np.log10(oh_minus_concentration)
            ph = 14 - poh
        else:
            # At equivalence point
            ph = 7.0
        
        return ph
    
    def run_titration(self):
        """Run complete titration"""
        volumes = np.arange(0, 50.1, 0.5)  # 0 to 50 mL in 0.5 mL steps
        
        for volume in volumes:
            ph = self.calculate_ph(volume)
            self.volume_data.append(volume)
            self.ph_data.append(ph)
        
        return self.volume_data, self.ph_data
    
    def plot_titration_curve(self):
        """Plot titration curve"""
        plt.figure(figsize=(10, 6))
        plt.plot(self.volume_data, self.ph_data, 'b-', linewidth=2)
        plt.xlabel('Volume of NaOH (mL)')
        plt.ylabel('pH')
        plt.title('pH Titration Curve: HCl vs NaOH')
        plt.grid(True, alpha=0.3)
        plt.axhline(y=7, color='r', linestyle='--', alpha=0.7, label='Neutral pH')
        plt.legend()
        plt.show()
    
    def find_equivalence_point(self):
        """Find equivalence point (steepest part of curve)"""
        # Calculate derivative (slope)
        slopes = np.diff(self.ph_data) / np.diff(self.volume_data)
        max_slope_index = np.argmax(slopes)
        equivalence_volume = self.volume_data[max_slope_index + 1]
        equivalence_ph = self.ph_data[max_slope_index + 1]
        return equivalence_volume, equivalence_ph

# Example usage
titration = pHTitrationLab()
volumes, phs = titration.run_titration()
equiv_vol, equiv_ph = titration.find_equivalence_point()

print(f"Equivalence point: {equiv_vol:.1f} mL at pH {equiv_ph:.2f}")
titration.plot_titration_curve()
```

### Physics: Simple Pendulum
```python
class PendulumLab:
    def __init__(self):
        self.length_data = []
        self.period_data = []
    
    def calculate_period(self, length, g=9.81):
        """
        Calculate period of simple pendulum
        length: pendulum length (m)
        g: gravitational acceleration (m/s²)
        """
        period = 2 * np.pi * np.sqrt(length / g)
        return period
    
    def measure_period(self, length, num_oscillations=10):
        """
        Simulate period measurement
        length: pendulum length (m)
        num_oscillations: number of oscillations to time
        """
        theoretical_period = self.calculate_period(length)
        
        # Add experimental uncertainty (±5%)
        uncertainty = np.random.normal(0, 0.05 * theoretical_period)
        measured_period = theoretical_period + uncertainty
        
        return measured_period
    
    def run_length_experiment(self):
        """Run experiment with different pendulum lengths"""
        lengths = np.arange(0.1, 1.1, 0.1)  # 0.1 to 1.0 m in 0.1 m steps
        
        for length in lengths:
            period = self.measure_period(length)
            self.length_data.append(length)
            self.period_data.append(period)
        
        return self.length_data, self.period_data
    
    def plot_period_vs_length(self):
        """Plot period vs length"""
        plt.figure(figsize=(10, 6))
        plt.plot(self.length_data, self.period_data, 'ro-', linewidth=2, markersize=8)
        plt.xlabel('Pendulum Length (m)')
        plt.ylabel('Period (s)')
        plt.title('Period vs Length for Simple Pendulum')
        plt.grid(True, alpha=0.3)
        plt.show()
    
    def calculate_g_from_data(self):
        """Calculate gravitational acceleration from experimental data"""
        # T = 2π√(L/g), so g = 4π²L/T²
        g_values = []
        for i in range(len(self.length_data)):
            g = 4 * np.pi**2 * self.length_data[i] / (self.period_data[i]**2)
            g_values.append(g)
        
        average_g = np.mean(g_values)
        std_g = np.std(g_values)
        
        return average_g, std_g

# Example usage
pendulum = PendulumLab()
lengths, periods = pendulum.run_length_experiment()
g_exp, g_std = pendulum.calculate_g_from_data()

print(f"Experimental g: {g_exp:.2f} ± {g_std:.2f} m/s²")
print(f"Theoretical g: 9.81 m/s²")
print(f"Percent error: {abs(g_exp - 9.81) / 9.81 * 100:.1f}%")
pendulum.plot_period_vs_length()
```

### Environmental Science: Water Quality
```python
class WaterQualityLab:
    def __init__(self):
        self.samples = []
    
    def measure_water_parameters(self, sample_id, temperature, ph, dissolved_oxygen, turbidity):
        """
        Record water quality parameters
        temperature: water temperature (°C)
        ph: pH level
        dissolved_oxygen: dissolved oxygen (mg/L)
        turbidity: turbidity (NTU)
        """
        sample = {
            'sample_id': sample_id,
            'temperature': temperature,
            'ph': ph,
            'dissolved_oxygen': dissolved_oxygen,
            'turbidity': turbidity
        }
        self.samples.append(sample)
        return sample
    
    def assess_water_quality(self, sample):
        """Assess water quality based on parameters"""
        quality_score = 0
        issues = []
        
        # Temperature assessment (optimal: 15-25°C)
        if 15 <= sample['temperature'] <= 25:
            quality_score += 25
        else:
            issues.append(f"Temperature {sample['temperature']}°C outside optimal range")
        
        # pH assessment (optimal: 6.5-8.5)
        if 6.5 <= sample['ph'] <= 8.5:
            quality_score += 25
        else:
            issues.append(f"pH {sample['ph']} outside optimal range")
        
        # Dissolved oxygen assessment (good: >5 mg/L)
        if sample['dissolved_oxygen'] >= 5:
            quality_score += 25
        else:
            issues.append(f"Low dissolved oxygen: {sample['dissolved_oxygen']} mg/L")
        
        # Turbidity assessment (good: <1 NTU)
        if sample['turbidity'] <= 1:
            quality_score += 25
        else:
            issues.append(f"High turbidity: {sample['turbidity']} NTU")
        
        # Overall assessment
        if quality_score >= 90:
            quality_rating = "Excellent"
        elif quality_score >= 75:
            quality_rating = "Good"
        elif quality_score >= 50:
            quality_rating = "Fair"
        else:
            quality_rating = "Poor"
        
        return {
            'quality_score': quality_score,
            'quality_rating': quality_rating,
            'issues': issues
        }
    
    def generate_report(self):
        """Generate water quality report"""
        print("Water Quality Assessment Report")
        print("=" * 40)
        
        for sample in self.samples:
            assessment = self.assess_water_quality(sample)
            print(f"\nSample {sample['sample_id']}:")
            print(f"  Temperature: {sample['temperature']}°C")
            print(f"  pH: {sample['ph']}")
            print(f"  Dissolved Oxygen: {sample['dissolved_oxygen']} mg/L")
            print(f"  Turbidity: {sample['turbidity']} NTU")
            print(f"  Quality Score: {assessment['quality_score']}/100")
            print(f"  Quality Rating: {assessment['quality_rating']}")
            
            if assessment['issues']:
                print("  Issues:")
                for issue in assessment['issues']:
                    print(f"    - {issue}")

# Example usage
water_lab = WaterQualityLab()

# Sample different water sources
water_lab.measure_water_parameters("River A", 22, 7.2, 8.5, 0.8)
water_lab.measure_water_parameters("Lake B", 18, 6.8, 6.2, 1.5)
water_lab.measure_water_parameters("Stream C", 25, 8.1, 4.8, 2.1)

water_lab.generate_report()
```

## 🔍 Scientific Method Concepts
- **Hypothesis Formation**: Making testable predictions
- **Experimental Design**: Controlling variables and collecting data
- **Data Analysis**: Statistical analysis and interpretation
- **Error Analysis**: Understanding measurement uncertainties
- **Conclusion Drawing**: Making evidence-based conclusions

## 💡 Learning Points
- Scientific experiments require careful planning and execution
- Data collection must be systematic and repeatable
- Statistical analysis helps interpret experimental results
- Error analysis is crucial for understanding data reliability
- Lab safety and proper procedures are essential

# PHY-150 Physics Calculations

## 🎯 Purpose
Demonstrate fundamental physics calculations and problem-solving techniques.

## 📝 Physics Calculation Examples

### Kinematics Problems
```python
import math

# Problem 1: Projectile Motion
def projectile_motion(v0, angle, g=9.81):
    """
    Calculate projectile motion parameters
    v0: initial velocity (m/s)
    angle: launch angle (degrees)
    g: gravitational acceleration (m/s²)
    """
    angle_rad = math.radians(angle)
    v0x = v0 * math.cos(angle_rad)  # Horizontal component
    v0y = v0 * math.sin(angle_rad)  # Vertical component
    
    # Time of flight
    t_flight = 2 * v0y / g
    
    # Maximum height
    h_max = (v0y**2) / (2 * g)
    
    # Range
    range_distance = v0x * t_flight
    
    return {
        'initial_velocity_x': v0x,
        'initial_velocity_y': v0y,
        'time_of_flight': t_flight,
        'maximum_height': h_max,
        'range': range_distance
    }

# Example: Ball thrown at 20 m/s at 30° angle
result = projectile_motion(20, 30)
print("Projectile Motion Results:")
for key, value in result.items():
    print(f"{key}: {value:.2f}")

# Problem 2: Free Fall
def free_fall_calculations(h, g=9.81):
    """
    Calculate free fall parameters
    h: height (m)
    g: gravitational acceleration (m/s²)
    """
    # Time to fall
    t = math.sqrt(2 * h / g)
    
    # Final velocity
    v_final = g * t
    
    # Velocity at half height
    v_half = math.sqrt(2 * g * (h/2))
    
    return {
        'time_to_fall': t,
        'final_velocity': v_final,
        'velocity_at_half_height': v_half
    }

# Example: Object dropped from 100m
fall_result = free_fall_calculations(100)
print(f"\nFree Fall from 100m:")
for key, value in fall_result.items():
    print(f"{key}: {value:.2f}")
```

### Newton's Laws Applications
```python
# Problem 3: Newton's Second Law
def newton_second_law(mass, acceleration):
    """
    Calculate force using F = ma
    mass: object mass (kg)
    acceleration: acceleration (m/s²)
    """
    force = mass * acceleration
    return force

# Problem 4: Friction
def friction_force(normal_force, coefficient_friction):
    """
    Calculate friction force
    normal_force: normal force (N)
    coefficient_friction: friction coefficient
    """
    friction = coefficient_friction * normal_force
    return friction

# Problem 5: Inclined Plane
def inclined_plane_analysis(mass, angle, coefficient_friction=0.2, g=9.81):
    """
    Analyze forces on inclined plane
    mass: object mass (kg)
    angle: incline angle (degrees)
    coefficient_friction: friction coefficient
    g: gravitational acceleration (m/s²)
    """
    angle_rad = math.radians(angle)
    
    # Weight components
    weight = mass * g
    weight_parallel = weight * math.sin(angle_rad)
    weight_perpendicular = weight * math.cos(angle_rad)
    
    # Normal force
    normal_force = weight_perpendicular
    
    # Friction force
    friction_force = coefficient_friction * normal_force
    
    # Net force
    net_force = weight_parallel - friction_force
    
    # Acceleration
    acceleration = net_force / mass
    
    return {
        'weight': weight,
        'weight_parallel': weight_parallel,
        'weight_perpendicular': weight_perpendicular,
        'normal_force': normal_force,
        'friction_force': friction_force,
        'net_force': net_force,
        'acceleration': acceleration
    }

# Example: 10kg block on 30° incline
incline_result = inclined_plane_analysis(10, 30)
print(f"\nInclined Plane Analysis (10kg, 30°):")
for key, value in incline_result.items():
    print(f"{key}: {value:.2f}")
```

### Energy Calculations
```python
# Problem 6: Kinetic and Potential Energy
def energy_calculations(mass, velocity, height, g=9.81):
    """
    Calculate kinetic and potential energy
    mass: object mass (kg)
    velocity: velocity (m/s)
    height: height above reference (m)
    g: gravitational acceleration (m/s²)
    """
    kinetic_energy = 0.5 * mass * velocity**2
    potential_energy = mass * g * height
    total_energy = kinetic_energy + potential_energy
    
    return {
        'kinetic_energy': kinetic_energy,
        'potential_energy': potential_energy,
        'total_energy': total_energy
    }

# Problem 7: Conservation of Energy
def conservation_of_energy(mass, initial_height, final_height, g=9.81):
    """
    Calculate final velocity using energy conservation
    mass: object mass (kg)
    initial_height: starting height (m)
    final_height: final height (m)
    g: gravitational acceleration (m/s²)
    """
    # Change in potential energy
    delta_pe = mass * g * (initial_height - final_height)
    
    # This equals change in kinetic energy
    # Assuming initial velocity is 0
    final_velocity = math.sqrt(2 * delta_pe / mass)
    
    return {
        'change_potential_energy': delta_pe,
        'final_velocity': final_velocity
    }

# Example: Ball dropped from 50m
energy_result = energy_calculations(2, 0, 50)
print(f"\nEnergy Calculations (2kg ball at 50m height):")
for key, value in energy_result.items():
    print(f"{key}: {value:.2f}")

conservation_result = conservation_of_energy(2, 50, 0)
print(f"\nConservation of Energy (ball dropped from 50m):")
for key, value in conservation_result.items():
    print(f"{key}: {value:.2f}")
```

### Momentum and Collisions
```python
# Problem 8: Momentum
def momentum_calculations(mass1, velocity1, mass2, velocity2):
    """
    Calculate momentum before and after collision
    mass1, mass2: masses (kg)
    velocity1, velocity2: velocities (m/s)
    """
    momentum1 = mass1 * velocity1
    momentum2 = mass2 * velocity2
    total_momentum_before = momentum1 + momentum2
    
    return {
        'momentum1': momentum1,
        'momentum2': momentum2,
        'total_momentum_before': total_momentum_before
    }

# Problem 9: Elastic Collision
def elastic_collision(mass1, velocity1, mass2, velocity2):
    """
    Calculate velocities after elastic collision
    """
    # Conservation of momentum: m1*v1 + m2*v2 = m1*v1' + m2*v2'
    # Conservation of kinetic energy: 0.5*m1*v1² + 0.5*m2*v2² = 0.5*m1*v1'² + 0.5*m2*v2'²
    
    # Final velocities
    v1_final = ((mass1 - mass2) * velocity1 + 2 * mass2 * velocity2) / (mass1 + mass2)
    v2_final = ((mass2 - mass1) * velocity2 + 2 * mass1 * velocity1) / (mass1 + mass2)
    
    return {
        'velocity1_final': v1_final,
        'velocity2_final': v2_final
    }

# Example: 5kg ball at 10 m/s hits 3kg ball at rest
collision_result = elastic_collision(5, 10, 3, 0)
print(f"\nElastic Collision (5kg@10m/s hits 3kg@0m/s):")
for key, value in collision_result.items():
    print(f"{key}: {value:.2f}")
```

### Wave Properties
```python
# Problem 10: Wave Calculations
def wave_properties(frequency, wavelength, amplitude=1):
    """
    Calculate wave properties
    frequency: frequency (Hz)
    wavelength: wavelength (m)
    amplitude: amplitude (m)
    """
    # Wave speed
    wave_speed = frequency * wavelength
    
    # Period
    period = 1 / frequency
    
    # Angular frequency
    angular_frequency = 2 * math.pi * frequency
    
    # Wave number
    wave_number = 2 * math.pi / wavelength
    
    return {
        'wave_speed': wave_speed,
        'period': period,
        'angular_frequency': angular_frequency,
        'wave_number': wave_number
    }

# Example: Sound wave with frequency 440 Hz and wavelength 0.78 m
wave_result = wave_properties(440, 0.78)
print(f"\nWave Properties (440 Hz, 0.78 m wavelength):")
for key, value in wave_result.items():
    print(f"{key}: {value:.2f}")
```

## 🔍 Physics Concepts
- **Kinematics**: Motion without considering forces
- **Dynamics**: Motion considering forces (Newton's laws)
- **Energy**: Kinetic, potential, and conservation
- **Momentum**: Conservation in collisions
- **Waves**: Properties and behavior

## 💡 Learning Points
- Physics problems require systematic problem-solving approaches
- Units are crucial for correct calculations
- Conservation laws simplify complex problems
- Vector components are essential for 2D/3D problems
- Practice with different problem types builds understanding

# PHY-150 Introductory Physics: Mechanics Problems

## 🎯 Purpose
Comprehensive guide to solving mechanics problems in introductory physics, including kinematics, dynamics, and energy conservation.

## 📝 Mechanics Problem Examples

### Example 1: Kinematics - Projectile Motion

**Problem**: A ball is thrown horizontally from a height of 20m with an initial velocity of 15 m/s. Find:
a) How long it takes to hit the ground
b) How far horizontally it travels
c) Its velocity when it hits the ground

**Solution**:
```python
import math

# Given data
h = 20  # height in meters
v0x = 15  # initial horizontal velocity in m/s
v0y = 0   # initial vertical velocity in m/s
g = 9.8  # acceleration due to gravity in m/s²

# Part a: Time to hit the ground
# Using y = y0 + v0y*t - (1/2)*g*t²
# When ball hits ground: y = 0, y0 = h
# 0 = h + v0y*t - (1/2)*g*t²
# 0 = 20 + 0*t - (1/2)*9.8*t²
# 0 = 20 - 4.9*t²
# t² = 20/4.9
# t = sqrt(20/4.9)

t = math.sqrt(h / (0.5 * g))
print(f"Time to hit ground: {t:.2f} seconds")

# Part b: Horizontal distance
# x = x0 + v0x*t
x = v0x * t
print(f"Horizontal distance: {x:.2f} meters")

# Part c: Velocity when hitting ground
# vx = v0x (constant)
# vy = v0y - g*t
vx = v0x
vy = v0y - g * t
v_magnitude = math.sqrt(vx**2 + vy**2)
angle = math.degrees(math.atan(vy/vx))

print(f"Final velocity: {v_magnitude:.2f} m/s at {angle:.1f}° below horizontal")
```

### Example 2: Dynamics - Newton's Laws

**Problem**: A 5kg block is pulled by a 30N force at 30° above horizontal on a frictionless surface. Find:
a) The acceleration of the block
b) The normal force
c) If the coefficient of friction is 0.2, find the new acceleration

**Solution**:
```python
import math

# Given data
m = 5  # mass in kg
F = 30  # applied force in N
theta = 30  # angle in degrees
mu = 0.2  # coefficient of friction

# Convert angle to radians
theta_rad = math.radians(theta)

# Part a: Acceleration on frictionless surface
# Fx = F*cos(theta) = ma
Fx = F * math.cos(theta_rad)
a_frictionless = Fx / m
print(f"Acceleration (frictionless): {a_frictionless:.2f} m/s²")

# Part b: Normal force
# Fy = F*sin(theta) + N - mg = 0
# N = mg - F*sin(theta)
N = m * 9.8 - F * math.sin(theta_rad)
print(f"Normal force: {N:.2f} N")

# Part c: Acceleration with friction
# Fx - f = ma
# f = mu * N
f = mu * N
Fx_net = Fx - f
a_with_friction = Fx_net / m
print(f"Acceleration (with friction): {a_with_friction:.2f} m/s²")
```

### Example 3: Energy Conservation

**Problem**: A 2kg block slides down a frictionless ramp from height 3m, then encounters a rough surface with μ = 0.3. How far does it slide on the rough surface?

**Solution**:
```python
# Given data
m = 2  # mass in kg
h = 3  # initial height in m
mu = 0.3  # coefficient of friction
g = 9.8  # acceleration due to gravity

# At the top of the ramp
# Potential energy: PE = mgh
# Kinetic energy: KE = 0
PE_initial = m * g * h
KE_initial = 0
print(f"Initial potential energy: {PE_initial:.2f} J")

# At the bottom of the ramp (just before rough surface)
# All PE converted to KE
# PE_final = 0, KE_final = (1/2)mv²
# Conservation of energy: PE_initial = KE_final
# mgh = (1/2)mv²
# v² = 2gh
v_bottom = math.sqrt(2 * g * h)
print(f"Velocity at bottom of ramp: {v_bottom:.2f} m/s")

# On rough surface
# Work done by friction = -μmgd
# Final KE = 0
# Work-energy theorem: W = ΔKE
# -μmgd = 0 - (1/2)mv²
# μmgd = (1/2)mv²
# d = v²/(2μg)

d = v_bottom**2 / (2 * mu * g)
print(f"Distance on rough surface: {d:.2f} m")
```

## 🔍 Physics Problem-Solving Strategy

### 1. Understand the Problem
- **Read carefully**: Identify what's given and what's asked
- **Draw a diagram**: Visualize the situation
- **Identify the system**: What objects are involved
- **Choose coordinates**: Set up a coordinate system

### 2. Apply Physical Principles
- **Kinematics**: Use equations of motion
- **Dynamics**: Apply Newton's laws
- **Energy**: Use conservation of energy
- **Momentum**: Apply conservation of momentum

### 3. Solve Mathematically
- **Substitute values**: Plug in known quantities
- **Solve for unknowns**: Use algebraic manipulation
- **Check units**: Ensure dimensional consistency
- **Verify reasonableness**: Does the answer make sense?

### 4. Interpret Results
- **Physical meaning**: What does the result tell us?
- **Limitations**: What assumptions were made?
- **Applications**: How does this relate to real situations?

## 📊 Common Physics Formulas

### Kinematics
| Quantity | Formula | Description |
|----------|---------|-------------|
| Position | x = x₀ + v₀t + ½at² | Displacement with constant acceleration |
| Velocity | v = v₀ + at | Velocity with constant acceleration |
| Velocity² | v² = v₀² + 2a(x-x₀) | Velocity without time |
| Average velocity | v̄ = (v₀ + v)/2 | Average velocity with constant acceleration |

### Dynamics
| Quantity | Formula | Description |
|----------|---------|-------------|
| Newton's 2nd Law | F = ma | Force equals mass times acceleration |
| Weight | W = mg | Force due to gravity |
| Friction | f = μN | Kinetic friction force |
| Centripetal force | Fc = mv²/r | Force for circular motion |

### Energy
| Quantity | Formula | Description |
|----------|---------|-------------|
| Kinetic energy | KE = ½mv² | Energy of motion |
| Potential energy | PE = mgh | Gravitational potential energy |
| Work | W = Fd cos(θ) | Work done by force |
| Power | P = W/t | Rate of doing work |

## 🛠️ Python Physics Calculator

### Complete Physics Problem Solver
```python
class PhysicsCalculator:
    def __init__(self):
        self.g = 9.8  # acceleration due to gravity
    
    def projectile_motion(self, v0, angle, height=0):
        """Calculate projectile motion parameters"""
        import math
        
        angle_rad = math.radians(angle)
        v0x = v0 * math.cos(angle_rad)
        v0y = v0 * math.sin(angle_rad)
        
        # Time to reach maximum height
        t_up = v0y / self.g
        
        # Maximum height
        h_max = height + v0y**2 / (2 * self.g)
        
        # Time to hit ground
        t_total = t_up + math.sqrt(2 * h_max / self.g)
        
        # Range
        range_x = v0x * t_total
        
        return {
            'time_to_peak': t_up,
            'max_height': h_max,
            'total_time': t_total,
            'range': range_x,
            'final_velocity': math.sqrt(v0x**2 + (v0y - self.g * t_total)**2)
        }
    
    def newton_second_law(self, mass, forces):
        """Calculate acceleration using Newton's second law"""
        total_force = sum(forces)
        acceleration = total_force / mass
        return acceleration
    
    def energy_conservation(self, mass, height, velocity=0):
        """Calculate energy conservation problems"""
        potential_energy = mass * self.g * height
        kinetic_energy = 0.5 * mass * velocity**2
        total_energy = potential_energy + kinetic_energy
        
        return {
            'potential_energy': potential_energy,
            'kinetic_energy': kinetic_energy,
            'total_energy': total_energy
        }
    
    def friction_force(self, normal_force, coefficient):
        """Calculate friction force"""
        return coefficient * normal_force
    
    def centripetal_force(self, mass, velocity, radius):
        """Calculate centripetal force"""
        return mass * velocity**2 / radius
```

## 📋 Problem-Solving Checklist

### Before Starting
- [ ] Read the problem carefully
- [ ] Identify given information
- [ ] Identify what needs to be found
- [ ] Draw a diagram
- [ ] Choose coordinate system

### During Solution
- [ ] Apply appropriate physics principles
- [ ] Write down relevant equations
- [ ] Substitute known values
- [ ] Solve for unknowns
- [ ] Check units

### After Solution
- [ ] Verify answer is reasonable
- [ ] Check significant figures
- [ ] Consider alternative methods
- [ ] Think about physical meaning

## 🎯 PHY-150 Learning Outcomes

### Conceptual Understanding
- **Physical Principles**: Understanding fundamental physics concepts
- **Problem-Solving**: Applying physics to real-world situations
- **Mathematical Skills**: Using algebra and trigonometry in physics
- **Critical Thinking**: Analyzing and evaluating physics problems

### Technical Skills
- **Calculation Skills**: Performing physics calculations accurately
- **Unit Conversion**: Converting between different unit systems
- **Graphical Analysis**: Interpreting graphs and diagrams
- **Experimental Design**: Understanding measurement and uncertainty

## 💡 Pro Tips

1. **Always draw a diagram** to visualize the problem
2. **Use consistent units** throughout your calculations
3. **Check your answer** for reasonableness
4. **Practice regularly** to build problem-solving skills
5. **Understand the concepts** before memorizing formulas
6. **Work with others** to discuss different approaches
7. **Use technology** when appropriate for complex calculations
8. **Connect to real-world** applications to maintain interest

---

*This mechanics problems guide provides comprehensive examples and problem-solving strategies for PHY-150 Introductory Physics, helping students master fundamental physics concepts and problem-solving techniques.*

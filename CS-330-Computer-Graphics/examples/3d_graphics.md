# CS-330 3D Computer Graphics

## 🎯 Purpose
Demonstrate 3D graphics programming concepts, transformations, and rendering techniques.

## 📝 3D Graphics Examples

### Basic 3D Transformations
```java
import java.awt.*;
import java.awt.geom.*;
import java.util.*;

public class Graphics3D {
    private double[][] projectionMatrix;
    private double[][] viewMatrix;
    private double[][] modelMatrix;
    
    public Graphics3D() {
        // Initialize identity matrices
        projectionMatrix = createIdentityMatrix(4);
        viewMatrix = createIdentityMatrix(4);
        modelMatrix = createIdentityMatrix(4);
    }
    
    // 3D Point class
    public static class Point3D {
        public double x, y, z;
        
        public Point3D(double x, double y, double z) {
            this.x = x;
            this.y = y;
            this.z = z;
        }
        
        public Point3D transform(double[][] matrix) {
            double[] result = multiplyMatrixVector(matrix, new double[]{x, y, z, 1});
            return new Point3D(result[0], result[1], result[2]);
        }
    }
    
    // Create perspective projection matrix
    public void setPerspectiveProjection(double fov, double aspect, double near, double far) {
        double f = 1.0 / Math.tan(Math.toRadians(fov) / 2.0);
        projectionMatrix = new double[][]{
            {f/aspect, 0, 0, 0},
            {0, f, 0, 0},
            {0, 0, (far+near)/(near-far), (2*far*near)/(near-far)},
            {0, 0, -1, 0}
        };
    }
    
    // Create orthographic projection matrix
    public void setOrthographicProjection(double left, double right, double bottom, 
                                        double top, double near, double far) {
        projectionMatrix = new double[][]{
            {2/(right-left), 0, 0, -(right+left)/(right-left)},
            {0, 2/(top-bottom), 0, -(top+bottom)/(top-bottom)},
            {0, 0, -2/(far-near), -(far+near)/(far-near)},
            {0, 0, 0, 1}
        };
    }
    
    // Translation matrix
    public void translate(double x, double y, double z) {
        double[][] translation = {
            {1, 0, 0, x},
            {0, 1, 0, y},
            {0, 0, 1, z},
            {0, 0, 0, 1}
        };
        modelMatrix = multiplyMatrices(modelMatrix, translation);
    }
    
    // Rotation around X axis
    public void rotateX(double angle) {
        double cos = Math.cos(angle);
        double sin = Math.sin(angle);
        double[][] rotation = {
            {1, 0, 0, 0},
            {0, cos, -sin, 0},
            {0, sin, cos, 0},
            {0, 0, 0, 1}
        };
        modelMatrix = multiplyMatrices(modelMatrix, rotation);
    }
    
    // Rotation around Y axis
    public void rotateY(double angle) {
        double cos = Math.cos(angle);
        double sin = Math.sin(angle);
        double[][] rotation = {
            {cos, 0, sin, 0},
            {0, 1, 0, 0},
            {-sin, 0, cos, 0},
            {0, 0, 0, 1}
        };
        modelMatrix = multiplyMatrices(modelMatrix, rotation);
    }
    
    // Rotation around Z axis
    public void rotateZ(double angle) {
        double cos = Math.cos(angle);
        double sin = Math.sin(angle);
        double[][] rotation = {
            {cos, -sin, 0, 0},
            {sin, cos, 0, 0},
            {0, 0, 1, 0},
            {0, 0, 0, 1}
        };
        modelMatrix = multiplyMatrices(modelMatrix, rotation);
    }
    
    // Scaling matrix
    public void scale(double x, double y, double z) {
        double[][] scaling = {
            {x, 0, 0, 0},
            {0, y, 0, 0},
            {0, 0, z, 0},
            {0, 0, 0, 1}
        };
        modelMatrix = multiplyMatrices(modelMatrix, scaling);
    }
    
    // Project 3D point to 2D screen coordinates
    public Point projectPoint(Point3D point3D, int screenWidth, int screenHeight) {
        // Apply model transformation
        Point3D transformed = point3D.transform(modelMatrix);
        
        // Apply view transformation
        transformed = transformed.transform(viewMatrix);
        
        // Apply projection transformation
        Point3D projected = transformed.transform(projectionMatrix);
        
        // Perspective divide
        if (projected.z != 0) {
            projected.x /= projected.z;
            projected.y /= projected.z;
        }
        
        // Convert to screen coordinates
        int screenX = (int)((projected.x + 1) * screenWidth / 2);
        int screenY = (int)((1 - projected.y) * screenHeight / 2);
        
        return new Point(screenX, screenY);
    }
    
    // Draw 3D cube
    public void drawCube(Graphics2D g2d, int screenWidth, int screenHeight) {
        // Define cube vertices
        Point3D[] vertices = {
            new Point3D(-1, -1, -1), new Point3D(1, -1, -1),
            new Point3D(1, 1, -1), new Point3D(-1, 1, -1),
            new Point3D(-1, -1, 1), new Point3D(1, -1, 1),
            new Point3D(1, 1, 1), new Point3D(-1, 1, 1)
        };
        
        // Define cube edges
        int[][] edges = {
            {0, 1}, {1, 2}, {2, 3}, {3, 0}, // Front face
            {4, 5}, {5, 6}, {6, 7}, {7, 4}, // Back face
            {0, 4}, {1, 5}, {2, 6}, {3, 7}  // Connecting edges
        };
        
        g2d.setColor(Color.BLUE);
        g2d.setStroke(new BasicStroke(2));
        
        // Draw edges
        for (int[] edge : edges) {
            Point3D p1 = vertices[edge[0]];
            Point3D p2 = vertices[edge[1]];
            
            Point screen1 = projectPoint(p1, screenWidth, screenHeight);
            Point screen2 = projectPoint(p2, screenWidth, screenHeight);
            
            g2d.drawLine(screen1.x, screen1.y, screen2.x, screen2.y);
        }
    }
    
    // Draw 3D sphere using parametric equations
    public void drawSphere(Graphics2D g2d, int screenWidth, int screenHeight, 
                          double radius, int segments) {
        g2d.setColor(Color.RED);
        g2d.setStroke(new BasicStroke(1));
        
        // Generate sphere vertices
        List<Point3D> vertices = new ArrayList<>();
        for (int i = 0; i <= segments; i++) {
            double lat = Math.PI * i / segments;
            for (int j = 0; j <= segments; j++) {
                double lon = 2 * Math.PI * j / segments;
                
                double x = radius * Math.sin(lat) * Math.cos(lon);
                double y = radius * Math.cos(lat);
                double z = radius * Math.sin(lat) * Math.sin(lon);
                
                vertices.add(new Point3D(x, y, z));
            }
        }
        
        // Draw sphere as wireframe
        for (int i = 0; i < segments; i++) {
            for (int j = 0; j < segments; j++) {
                int index1 = i * (segments + 1) + j;
                int index2 = index1 + 1;
                int index3 = (i + 1) * (segments + 1) + j;
                int index4 = index3 + 1;
                
                // Draw horizontal lines
                if (j < segments) {
                    Point p1 = projectPoint(vertices.get(index1), screenWidth, screenHeight);
                    Point p2 = projectPoint(vertices.get(index2), screenWidth, screenHeight);
                    g2d.drawLine(p1.x, p1.y, p2.x, p2.y);
                }
                
                // Draw vertical lines
                if (i < segments) {
                    Point p1 = projectPoint(vertices.get(index1), screenWidth, screenHeight);
                    Point p3 = projectPoint(vertices.get(index3), screenWidth, screenHeight);
                    g2d.drawLine(p1.x, p1.y, p3.x, p3.y);
                }
            }
        }
    }
    
    // Helper methods
    private double[][] createIdentityMatrix(int size) {
        double[][] matrix = new double[size][size];
        for (int i = 0; i < size; i++) {
            matrix[i][i] = 1;
        }
        return matrix;
    }
    
    private double[][] multiplyMatrices(double[][] a, double[][] b) {
        int rows = a.length;
        int cols = b[0].length;
        int common = a[0].length;
        
        double[][] result = new double[rows][cols];
        for (int i = 0; i < rows; i++) {
            for (int j = 0; j < cols; j++) {
                for (int k = 0; k < common; k++) {
                    result[i][j] += a[i][k] * b[k][j];
                }
            }
        }
        return result;
    }
    
    private double[] multiplyMatrixVector(double[][] matrix, double[] vector) {
        double[] result = new double[vector.length];
        for (int i = 0; i < matrix.length; i++) {
            for (int j = 0; j < vector.length; j++) {
                result[i] += matrix[i][j] * vector[j];
            }
        }
        return result;
    }
}
```

### 3D Animation and Camera Control
```java
public class Camera3D {
    private Point3D position;
    private Point3D target;
    private Point3D up;
    private double fov;
    private double aspect;
    private double near;
    private double far;
    
    public Camera3D(Point3D position, Point3D target, Point3D up) {
        this.position = position;
        this.target = target;
        this.up = up;
        this.fov = 60.0;
        this.aspect = 1.0;
        this.near = 0.1;
        this.far = 100.0;
    }
    
    // Create view matrix
    public double[][] getViewMatrix() {
        Point3D forward = new Point3D(
            target.x - position.x,
            target.y - position.y,
            target.z - position.z
        );
        
        // Normalize forward vector
        double length = Math.sqrt(forward.x * forward.x + forward.y * forward.y + forward.z * forward.z);
        forward.x /= length;
        forward.y /= length;
        forward.z /= length;
        
        // Calculate right vector
        Point3D right = new Point3D(
            forward.y * up.z - forward.z * up.y,
            forward.z * up.x - forward.x * up.z,
            forward.x * up.y - forward.y * up.x
        );
        
        // Normalize right vector
        length = Math.sqrt(right.x * right.x + right.y * right.y + right.z * right.z);
        right.x /= length;
        right.y /= length;
        right.z /= length;
        
        // Calculate up vector
        Point3D upVector = new Point3D(
            right.y * forward.z - right.z * forward.y,
            right.z * forward.x - right.x * forward.z,
            right.x * forward.y - right.y * forward.x
        );
        
        // Create view matrix
        return new double[][]{
            {right.x, right.y, right.z, -dotProduct(right, position)},
            {upVector.x, upVector.y, upVector.z, -dotProduct(upVector, position)},
            {-forward.x, -forward.y, -forward.z, dotProduct(forward, position)},
            {0, 0, 0, 1}
        };
    }
    
    // Move camera forward/backward
    public void moveForward(double distance) {
        Point3D direction = new Point3D(
            target.x - position.x,
            target.y - position.y,
            target.z - position.z
        );
        
        double length = Math.sqrt(direction.x * direction.x + direction.y * direction.y + direction.z * direction.z);
        direction.x /= length;
        direction.y /= length;
        direction.z /= length;
        
        position.x += direction.x * distance;
        position.y += direction.y * distance;
        position.z += direction.z * distance;
        
        target.x += direction.x * distance;
        target.y += direction.y * distance;
        target.z += direction.z * distance;
    }
    
    // Rotate camera around target
    public void orbit(double horizontalAngle, double verticalAngle) {
        // Convert angles to radians
        double hRad = Math.toRadians(horizontalAngle);
        double vRad = Math.toRadians(verticalAngle);
        
        // Calculate distance from target
        double distance = Math.sqrt(
            Math.pow(position.x - target.x, 2) +
            Math.pow(position.y - target.y, 2) +
            Math.pow(position.z - target.z, 2)
        );
        
        // Update position based on spherical coordinates
        position.x = target.x + distance * Math.cos(vRad) * Math.cos(hRad);
        position.y = target.y + distance * Math.sin(vRad);
        position.z = target.z + distance * Math.cos(vRad) * Math.sin(hRad);
    }
    
    private double dotProduct(Point3D a, Point3D b) {
        return a.x * b.x + a.y * b.y + a.z * b.z;
    }
}
```

### 3D Lighting and Shading
```java
public class Lighting3D {
    public enum LightType {
        DIRECTIONAL, POINT, SPOT
    }
    
    public static class Light {
        public LightType type;
        public Point3D position;
        public Point3D direction;
        public Color color;
        public double intensity;
        public double attenuation;
        
        public Light(LightType type, Point3D position, Color color, double intensity) {
            this.type = type;
            this.position = position;
            this.color = color;
            this.intensity = intensity;
            this.attenuation = 1.0;
        }
    }
    
    // Calculate lighting for a point
    public static Color calculateLighting(Point3D point, Point3D normal, 
                                        Point3D viewDirection, Light light) {
        Color ambient = new Color(50, 50, 50); // Ambient light
        Color diffuse = new Color(0, 0, 0);
        Color specular = new Color(0, 0, 0);
        
        Point3D lightDirection;
        double distance = 0;
        
        // Calculate light direction based on type
        switch (light.type) {
            case DIRECTIONAL:
                lightDirection = new Point3D(-light.direction.x, -light.direction.y, -light.direction.z);
                break;
            case POINT:
                lightDirection = new Point3D(
                    light.position.x - point.x,
                    light.position.y - point.y,
                    light.position.z - point.z
                );
                distance = Math.sqrt(lightDirection.x * lightDirection.x + 
                                   lightDirection.y * lightDirection.y + 
                                   lightDirection.z * lightDirection.z);
                lightDirection.x /= distance;
                lightDirection.y /= distance;
                lightDirection.z /= distance;
                break;
            default:
                lightDirection = new Point3D(0, 0, 0);
        }
        
        // Calculate diffuse lighting
        double dotProduct = Math.max(0, 
            normal.x * lightDirection.x + 
            normal.y * lightDirection.y + 
            normal.z * lightDirection.z
        );
        
        diffuse = new Color(
            (int)(light.color.getRed() * dotProduct * light.intensity),
            (int)(light.color.getGreen() * dotProduct * light.intensity),
            (int)(light.color.getBlue() * dotProduct * light.intensity)
        );
        
        // Calculate specular lighting
        Point3D reflectDirection = new Point3D(
            2 * dotProduct * normal.x - lightDirection.x,
            2 * dotProduct * normal.y - lightDirection.y,
            2 * dotProduct * normal.z - lightDirection.z
        );
        
        double specularDot = Math.max(0, 
            reflectDirection.x * viewDirection.x + 
            reflectDirection.y * viewDirection.y + 
            reflectDirection.z * viewDirection.z
        );
        
        double specularIntensity = Math.pow(specularDot, 32); // Shininess factor
        specular = new Color(
            (int)(light.color.getRed() * specularIntensity * light.intensity),
            (int)(light.color.getGreen() * specularIntensity * light.intensity),
            (int)(light.color.getBlue() * specularIntensity * light.intensity)
        );
        
        // Apply attenuation for point lights
        if (light.type == LightType.POINT) {
            double attenuationFactor = 1.0 / (1.0 + light.attenuation * distance * distance);
            diffuse = new Color(
                (int)(diffuse.getRed() * attenuationFactor),
                (int)(diffuse.getGreen() * attenuationFactor),
                (int)(diffuse.getBlue() * attenuationFactor)
            );
        }
        
        // Combine all lighting components
        int finalRed = Math.min(255, ambient.getRed() + diffuse.getRed() + specular.getRed());
        int finalGreen = Math.min(255, ambient.getGreen() + diffuse.getGreen() + specular.getGreen());
        int finalBlue = Math.min(255, ambient.getBlue() + diffuse.getBlue() + specular.getBlue());
        
        return new Color(finalRed, finalGreen, finalBlue);
    }
}
```

## 🔍 3D Graphics Concepts
- **3D Transformations**: Translation, rotation, scaling in 3D space
- **Projection Matrices**: Perspective and orthographic projections
- **Camera Systems**: View matrices and camera control
- **Lighting Models**: Ambient, diffuse, and specular lighting
- **3D Primitives**: Cubes, spheres, and complex 3D shapes

## 💡 Learning Points
- 3D graphics require understanding of matrix mathematics
- Camera systems control the viewpoint and projection
- Lighting models create realistic 3D appearance
- 3D transformations can be combined using matrix multiplication
- Perspective projection creates depth perception

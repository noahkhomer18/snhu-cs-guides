# CS-330 2D Computer Graphics

## 🎯 Purpose
Demonstrate 2D graphics programming concepts and transformations.

## 📝 2D Graphics Examples

### Basic Drawing Operations
```java
import java.awt.*;
import java.awt.geom.*;

public class Graphics2DExamples {
    
    public void drawBasicShapes(Graphics2D g2d) {
        // Set rendering hints for better quality
        g2d.setRenderingHint(RenderingHints.KEY_ANTIALIASING, 
                           RenderingHints.VALUE_ANTIALIAS_ON);
        
        // Draw line
        g2d.setColor(Color.BLUE);
        g2d.setStroke(new BasicStroke(3));
        g2d.drawLine(50, 50, 200, 100);
        
        // Draw rectangle
        g2d.setColor(Color.RED);
        g2d.fillRect(100, 150, 100, 80);
        
        // Draw circle
        g2d.setColor(Color.GREEN);
        g2d.fillOval(250, 150, 100, 100);
        
        // Draw polygon
        int[] xPoints = {400, 450, 500, 475, 425};
        int[] yPoints = {150, 120, 150, 200, 200};
        g2d.setColor(Color.ORANGE);
        g2d.fillPolygon(xPoints, yPoints, 5);
    }
    
    public void drawText(Graphics2D g2d) {
        // Set font and color
        Font font = new Font("Arial", Font.BOLD, 24);
        g2d.setFont(font);
        g2d.setColor(Color.BLACK);
        
        // Draw text with shadow effect
        g2d.setColor(Color.GRAY);
        g2d.drawString("Computer Graphics", 52, 302);
        g2d.setColor(Color.BLACK);
        g2d.drawString("Computer Graphics", 50, 300);
    }
}
```

### 2D Transformations
```java
public class Transformations2D {
    
    public void applyTransformations(Graphics2D g2d) {
        // Save original transform
        AffineTransform originalTransform = g2d.getTransform();
        
        // Translation
        g2d.translate(100, 100);
        g2d.setColor(Color.BLUE);
        g2d.fillRect(0, 0, 50, 50);
        
        // Rotation
        g2d.rotate(Math.PI / 4); // 45 degrees
        g2d.setColor(Color.RED);
        g2d.fillRect(0, 0, 50, 50);
        
        // Scaling
        g2d.scale(2.0, 1.5);
        g2d.setColor(Color.GREEN);
        g2d.fillRect(0, 0, 50, 50);
        
        // Shear
        g2d.shear(0.5, 0);
        g2d.setColor(Color.ORANGE);
        g2d.fillRect(0, 0, 50, 50);
        
        // Restore original transform
        g2d.setTransform(originalTransform);
    }
    
    public void matrixTransformations(Graphics2D g2d) {
        // Create transformation matrix
        AffineTransform transform = new AffineTransform();
        transform.translate(200, 200);
        transform.rotate(Math.PI / 6); // 30 degrees
        transform.scale(1.5, 1.5);
        
        // Apply transformation
        g2d.setTransform(transform);
        g2d.setColor(Color.PURPLE);
        g2d.fillRect(-25, -25, 50, 50);
    }
}
```

### Animation and Interpolation
```java
public class Animation2D {
    private float time = 0;
    
    public void animate(Graphics2D g2d) {
        time += 0.016f; // 60 FPS
        
        // Bouncing ball
        float ballX = 100 + (float)(Math.sin(time * 2) * 50);
        float ballY = 100 + (float)(Math.abs(Math.cos(time * 2)) * 50);
        
        g2d.setColor(Color.RED);
        g2d.fillOval((int)ballX, (int)ballY, 20, 20);
        
        // Rotating square
        AffineTransform original = g2d.getTransform();
        g2d.translate(300, 200);
        g2d.rotate(time);
        g2d.setColor(Color.BLUE);
        g2d.fillRect(-25, -25, 50, 50);
        g2d.setTransform(original);
        
        // Color interpolation
        Color startColor = Color.RED;
        Color endColor = Color.BLUE;
        float t = (float)(Math.sin(time) + 1) / 2; // 0 to 1
        
        int r = (int)(startColor.getRed() + t * (endColor.getRed() - startColor.getRed()));
        int g = (int)(startColor.getGreen() + t * (endColor.getGreen() - startColor.getGreen()));
        int b = (int)(startColor.getBlue() + t * (endColor.getBlue() - startColor.getBlue()));
        
        g2d.setColor(new Color(r, g, b));
        g2d.fillOval(400, 100, 60, 60);
    }
}
```

## 🔍 Graphics Concepts
- **Coordinate Systems**: Screen coordinates vs. world coordinates
- **Transformations**: Translation, rotation, scaling, shearing
- **Rendering Pipeline**: Geometry → Transform → Rasterize → Display
- **Anti-aliasing**: Smoothing jagged edges

## 💡 Learning Points
- Graphics programming requires understanding of coordinate systems
- Transformations can be combined using matrix multiplication
- Animation involves updating properties over time
- Quality rendering requires proper rendering hints

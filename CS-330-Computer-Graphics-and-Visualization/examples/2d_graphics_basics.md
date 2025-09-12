# CS-330 2D Graphics Basics

## 🎯 Purpose
Demonstrate fundamental 2D graphics concepts including drawing primitives, transformations, and rendering techniques.

## 📝 2D Graphics Examples

### Basic Drawing Primitives (HTML5 Canvas)
```html
<!DOCTYPE html>
<html>
<head>
    <title>2D Graphics Basics</title>
</head>
<body>
    <canvas id="canvas" width="800" height="600"></canvas>
    <script>
        const canvas = document.getElementById('canvas');
        const ctx = canvas.getContext('2d');
        
        // Set up canvas
        ctx.fillStyle = '#f0f0f0';
        ctx.fillRect(0, 0, canvas.width, canvas.height);
        
        // Drawing basic shapes
        function drawBasicShapes() {
            // Rectangle
            ctx.fillStyle = '#ff6b6b';
            ctx.fillRect(50, 50, 100, 80);
            
            // Circle
            ctx.beginPath();
            ctx.arc(200, 90, 40, 0, 2 * Math.PI);
            ctx.fillStyle = '#4ecdc4';
            ctx.fill();
            
            // Line
            ctx.beginPath();
            ctx.moveTo(300, 50);
            ctx.lineTo(400, 130);
            ctx.strokeStyle = '#45b7d1';
            ctx.lineWidth = 3;
            ctx.stroke();
            
            // Triangle
            ctx.beginPath();
            ctx.moveTo(500, 50);
            ctx.lineTo(450, 130);
            ctx.lineTo(550, 130);
            ctx.closePath();
            ctx.fillStyle = '#96ceb4';
            ctx.fill();
        }
        
        // Drawing with different styles
        function drawStyledShapes() {
            // Gradient rectangle
            const gradient = ctx.createLinearGradient(50, 200, 150, 280);
            gradient.addColorStop(0, '#ff9a9e');
            gradient.addColorStop(1, '#fecfef');
            ctx.fillStyle = gradient;
            ctx.fillRect(50, 200, 100, 80);
            
            // Pattern circle
            ctx.beginPath();
            ctx.arc(200, 240, 40, 0, 2 * Math.PI);
            ctx.strokeStyle = '#a8e6cf';
            ctx.lineWidth = 5;
            ctx.stroke();
            ctx.fillStyle = '#ffd3a5';
            ctx.fill();
            
            // Dashed line
            ctx.setLineDash([10, 5]);
            ctx.beginPath();
            ctx.moveTo(300, 200);
            ctx.lineTo(400, 280);
            ctx.strokeStyle = '#ff8b94';
            ctx.lineWidth = 2;
            ctx.stroke();
            ctx.setLineDash([]); // Reset dash pattern
        }
        
        // Text rendering
        function drawText() {
            ctx.font = '24px Arial';
            ctx.fillStyle = '#333';
            ctx.fillText('Hello Graphics!', 50, 350);
            
            ctx.font = 'bold 18px Arial';
            ctx.strokeStyle = '#666';
            ctx.strokeText('Stroked Text', 50, 380);
            
            // Text with shadow
            ctx.shadowColor = 'rgba(0,0,0,0.3)';
            ctx.shadowBlur = 4;
            ctx.shadowOffsetX = 2;
            ctx.shadowOffsetY = 2;
            ctx.fillStyle = '#ff6b6b';
            ctx.font = '20px Arial';
            ctx.fillText('Shadow Text', 50, 410);
            ctx.shadowColor = 'transparent'; // Reset shadow
        }
        
        // Call drawing functions
        drawBasicShapes();
        drawStyledShapes();
        drawText();
    </script>
</body>
</html>
```

### 2D Transformations (JavaScript)
```javascript
class Transform2D {
    constructor() {
        this.matrix = this.identity();
    }
    
    identity() {
        return [
            [1, 0, 0],
            [0, 1, 0],
            [0, 0, 1]
        ];
    }
    
    translate(tx, ty) {
        const translateMatrix = [
            [1, 0, tx],
            [0, 1, ty],
            [0, 0, 1]
        ];
        this.matrix = this.multiply(translateMatrix, this.matrix);
        return this;
    }
    
    rotate(angle) {
        const cos = Math.cos(angle);
        const sin = Math.sin(angle);
        const rotateMatrix = [
            [cos, -sin, 0],
            [sin, cos, 0],
            [0, 0, 1]
        ];
        this.matrix = this.multiply(rotateMatrix, this.matrix);
        return this;
    }
    
    scale(sx, sy) {
        const scaleMatrix = [
            [sx, 0, 0],
            [0, sy, 0],
            [0, 0, 1]
        ];
        this.matrix = this.multiply(scaleMatrix, this.matrix);
        return this;
    }
    
    multiply(a, b) {
        const result = [
            [0, 0, 0],
            [0, 0, 0],
            [0, 0, 0]
        ];
        
        for (let i = 0; i < 3; i++) {
            for (let j = 0; j < 3; j++) {
                for (let k = 0; k < 3; k++) {
                    result[i][j] += a[i][k] * b[k][j];
                }
            }
        }
        
        return result;
    }
    
    transformPoint(x, y) {
        const point = [x, y, 1];
        const result = [0, 0, 0];
        
        for (let i = 0; i < 3; i++) {
            for (let j = 0; j < 3; j++) {
                result[i] += this.matrix[i][j] * point[j];
            }
        }
        
        return { x: result[0], y: result[1] };
    }
    
    reset() {
        this.matrix = this.identity();
        return this;
    }
}

// Usage example
function demonstrateTransformations() {
    const canvas = document.getElementById('canvas');
    const ctx = canvas.getContext('2d');
    
    // Clear canvas
    ctx.clearRect(0, 0, canvas.width, canvas.height);
    
    // Draw original shape
    ctx.fillStyle = '#ff6b6b';
    ctx.fillRect(100, 100, 50, 50);
    
    // Apply transformations
    const transform = new Transform2D();
    
    // Translate, rotate, and scale
    transform.translate(200, 0)
             .rotate(Math.PI / 4)
             .scale(1.5, 1.5);
    
    // Transform and draw
    const points = [
        { x: 100, y: 100 },
        { x: 150, y: 100 },
        { x: 150, y: 150 },
        { x: 100, y: 150 }
    ];
    
    ctx.fillStyle = '#4ecdc4';
    ctx.beginPath();
    
    for (let i = 0; i < points.length; i++) {
        const transformed = transform.transformPoint(points[i].x, points[i].y);
        if (i === 0) {
            ctx.moveTo(transformed.x, transformed.y);
        } else {
            ctx.lineTo(transformed.x, transformed.y);
        }
    }
    
    ctx.closePath();
    ctx.fill();
}
```

### Line Drawing Algorithms
```javascript
class LineDrawing {
    
    // Bresenham's Line Algorithm
    static bresenhamLine(x0, y0, x1, y1, setPixel) {
        const dx = Math.abs(x1 - x0);
        const dy = Math.abs(y1 - y0);
        const sx = x0 < x1 ? 1 : -1;
        const sy = y0 < y1 ? 1 : -1;
        let err = dx - dy;
        
        let x = x0;
        let y = y0;
        
        while (true) {
            setPixel(x, y);
            
            if (x === x1 && y === y1) break;
            
            const e2 = 2 * err;
            
            if (e2 > -dy) {
                err -= dy;
                x += sx;
            }
            
            if (e2 < dx) {
                err += dx;
                y += sy;
            }
        }
    }
    
    // Digital Differential Analyzer (DDA)
    static ddaLine(x0, y0, x1, y1, setPixel) {
        const dx = x1 - x0;
        const dy = y1 - y0;
        const steps = Math.max(Math.abs(dx), Math.abs(dy));
        
        const xIncrement = dx / steps;
        const yIncrement = dy / steps;
        
        let x = x0;
        let y = y0;
        
        for (let i = 0; i <= steps; i++) {
            setPixel(Math.round(x), Math.round(y));
            x += xIncrement;
            y += yIncrement;
        }
    }
    
    // Midpoint Line Algorithm
    static midpointLine(x0, y0, x1, y1, setPixel) {
        const dx = x1 - x0;
        const dy = y1 - y0;
        const d = 2 * dy - dx;
        const incrE = 2 * dy;
        const incrNE = 2 * (dy - dx);
        
        let x = x0;
        let y = y0;
        
        setPixel(x, y);
        
        while (x < x1) {
            if (d <= 0) {
                d += incrE;
                x++;
            } else {
                d += incrNE;
                x++;
                y++;
            }
            setPixel(x, y);
        }
    }
}

// Usage example
function drawLinesWithAlgorithms() {
    const canvas = document.getElementById('canvas');
    const ctx = canvas.getContext('2d');
    
    // Clear canvas
    ctx.clearRect(0, 0, canvas.width, canvas.height);
    
    // Set up pixel drawing function
    const setPixel = (x, y) => {
        ctx.fillRect(x, y, 1, 1);
    };
    
    ctx.fillStyle = '#ff6b6b';
    
    // Draw lines using different algorithms
    LineDrawing.bresenhamLine(50, 50, 200, 100, setPixel);
    
    ctx.fillStyle = '#4ecdc4';
    LineDrawing.ddaLine(50, 120, 200, 170, setPixel);
    
    ctx.fillStyle = '#45b7d1';
    LineDrawing.midpointLine(50, 190, 200, 240, setPixel);
}
```

### Circle Drawing Algorithm
```javascript
class CircleDrawing {
    
    // Bresenham's Circle Algorithm
    static bresenhamCircle(centerX, centerY, radius, setPixel) {
        let x = 0;
        let y = radius;
        let d = 3 - 2 * radius;
        
        this.drawCirclePoints(centerX, centerY, x, y, setPixel);
        
        while (y >= x) {
            x++;
            
            if (d > 0) {
                y--;
                d = d + 4 * (x - y) + 10;
            } else {
                d = d + 4 * x + 6;
            }
            
            this.drawCirclePoints(centerX, centerY, x, y, setPixel);
        }
    }
    
    // Draw 8 symmetric points of circle
    static drawCirclePoints(centerX, centerY, x, y, setPixel) {
        setPixel(centerX + x, centerY + y);
        setPixel(centerX - x, centerY + y);
        setPixel(centerX + x, centerY - y);
        setPixel(centerX - x, centerY - y);
        setPixel(centerX + y, centerY + x);
        setPixel(centerX - y, centerY + x);
        setPixel(centerX + y, centerY - x);
        setPixel(centerX - y, centerY - x);
    }
    
    // Midpoint Circle Algorithm
    static midpointCircle(centerX, centerY, radius, setPixel) {
        let x = 0;
        let y = radius;
        let p = 1 - radius;
        
        this.drawCirclePoints(centerX, centerY, x, y, setPixel);
        
        while (x < y) {
            x++;
            
            if (p < 0) {
                p += 2 * x + 1;
            } else {
                y--;
                p += 2 * (x - y) + 1;
            }
            
            this.drawCirclePoints(centerX, centerY, x, y, setPixel);
        }
    }
}

// Usage example
function drawCircles() {
    const canvas = document.getElementById('canvas');
    const ctx = canvas.getContext('2d');
    
    ctx.clearRect(0, 0, canvas.width, canvas.height);
    
    const setPixel = (x, y) => {
        ctx.fillRect(x, y, 1, 1);
    };
    
    ctx.fillStyle = '#ff6b6b';
    CircleDrawing.bresenhamCircle(150, 150, 50, setPixel);
    
    ctx.fillStyle = '#4ecdc4';
    CircleDrawing.midpointCircle(300, 150, 50, setPixel);
}
```

### Polygon Filling (Scanline Algorithm)
```javascript
class PolygonFilling {
    
    // Scanline fill algorithm
    static scanlineFill(vertices, setPixel) {
        const n = vertices.length;
        const edges = [];
        
        // Create edge table
        for (let i = 0; i < n; i++) {
            const v1 = vertices[i];
            const v2 = vertices[(i + 1) % n];
            
            if (v1.y !== v2.y) {
                const edge = {
                    yMin: Math.min(v1.y, v2.y),
                    yMax: Math.max(v1.y, v2.y),
                    x: v1.y < v2.y ? v1.x : v2.x,
                    slope: (v2.x - v1.x) / (v2.y - v1.y)
                };
                edges.push(edge);
            }
        }
        
        // Sort edges by yMin
        edges.sort((a, b) => a.yMin - b.yMin);
        
        // Active edge list
        let activeEdges = [];
        let y = edges[0].yMin;
        
        while (y <= edges[edges.length - 1].yMax) {
            // Add edges starting at current y
            for (const edge of edges) {
                if (edge.yMin === y) {
                    activeEdges.push(edge);
                }
            }
            
            // Remove edges ending at current y
            activeEdges = activeEdges.filter(edge => edge.yMax > y);
            
            // Sort active edges by x
            activeEdges.sort((a, b) => a.x - b.x);
            
            // Fill scanline
            for (let i = 0; i < activeEdges.length; i += 2) {
                const x1 = Math.round(activeEdges[i].x);
                const x2 = Math.round(activeEdges[i + 1].x);
                
                for (let x = x1; x <= x2; x++) {
                    setPixel(x, y);
                }
            }
            
            // Update x coordinates for next scanline
            for (const edge of activeEdges) {
                edge.x += edge.slope;
            }
            
            y++;
        }
    }
}

// Usage example
function fillPolygon() {
    const canvas = document.getElementById('canvas');
    const ctx = canvas.getContext('2d');
    
    ctx.clearRect(0, 0, canvas.width, canvas.height);
    
    const setPixel = (x, y) => {
        ctx.fillRect(x, y, 1, 1);
    };
    
    // Define polygon vertices
    const vertices = [
        { x: 100, y: 100 },
        { x: 200, y: 50 },
        { x: 300, y: 100 },
        { x: 250, y: 200 },
        { x: 150, y: 200 }
    ];
    
    ctx.fillStyle = '#ff6b6b';
    PolygonFilling.scanlineFill(vertices, setPixel);
}
```

## 🔍 Graphics Concepts
- **Canvas API**: HTML5 2D graphics context
- **Transformations**: Translation, rotation, scaling using matrices
- **Line Drawing**: Bresenham's, DDA, and Midpoint algorithms
- **Circle Drawing**: Bresenham's and Midpoint circle algorithms
- **Polygon Filling**: Scanline algorithm for area filling
- **Rendering Pipeline**: From geometric primitives to pixels

## 💡 Learning Points
- **Rasterization** converts geometric shapes to pixels
- **Algorithms** optimize drawing operations for efficiency
- **Transformations** enable positioning and orientation of objects
- **Scanline filling** efficiently fills complex polygons
- **Mathematical precision** is crucial for smooth graphics

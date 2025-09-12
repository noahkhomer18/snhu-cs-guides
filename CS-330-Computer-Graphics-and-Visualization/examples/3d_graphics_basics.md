# CS-330 3D Graphics Basics

## 🎯 Purpose
Demonstrate fundamental 3D graphics concepts including 3D transformations, projections, and basic rendering techniques.

## 📝 3D Graphics Examples

### 3D Vector and Matrix Operations (JavaScript)
```javascript
class Vector3 {
    constructor(x = 0, y = 0, z = 0) {
        this.x = x;
        this.y = y;
        this.z = z;
    }
    
    add(v) {
        return new Vector3(this.x + v.x, this.y + v.y, this.z + v.z);
    }
    
    subtract(v) {
        return new Vector3(this.x - v.x, this.y - v.y, this.z - v.z);
    }
    
    multiply(scalar) {
        return new Vector3(this.x * scalar, this.y * scalar, this.z * scalar);
    }
    
    dot(v) {
        return this.x * v.x + this.y * v.y + this.z * v.z;
    }
    
    cross(v) {
        return new Vector3(
            this.y * v.z - this.z * v.y,
            this.z * v.x - this.x * v.z,
            this.x * v.y - this.y * v.x
        );
    }
    
    length() {
        return Math.sqrt(this.x * this.x + this.y * this.y + this.z * this.z);
    }
    
    normalize() {
        const len = this.length();
        if (len === 0) return new Vector3(0, 0, 0);
        return new Vector3(this.x / len, this.y / len, this.z / len);
    }
}

class Matrix4 {
    constructor() {
        this.elements = [
            1, 0, 0, 0,
            0, 1, 0, 0,
            0, 0, 1, 0,
            0, 0, 0, 1
        ];
    }
    
    static identity() {
        return new Matrix4();
    }
    
    static translation(x, y, z) {
        const m = new Matrix4();
        m.elements[12] = x;
        m.elements[13] = y;
        m.elements[14] = z;
        return m;
    }
    
    static rotationX(angle) {
        const m = new Matrix4();
        const c = Math.cos(angle);
        const s = Math.sin(angle);
        m.elements[5] = c;
        m.elements[6] = s;
        m.elements[9] = -s;
        m.elements[10] = c;
        return m;
    }
    
    static rotationY(angle) {
        const m = new Matrix4();
        const c = Math.cos(angle);
        const s = Math.sin(angle);
        m.elements[0] = c;
        m.elements[2] = -s;
        m.elements[8] = s;
        m.elements[10] = c;
        return m;
    }
    
    static rotationZ(angle) {
        const m = new Matrix4();
        const c = Math.cos(angle);
        const s = Math.sin(angle);
        m.elements[0] = c;
        m.elements[1] = s;
        m.elements[4] = -s;
        m.elements[5] = c;
        return m;
    }
    
    static scale(x, y, z) {
        const m = new Matrix4();
        m.elements[0] = x;
        m.elements[5] = y;
        m.elements[10] = z;
        return m;
    }
    
    static perspective(fov, aspect, near, far) {
        const m = new Matrix4();
        const f = 1.0 / Math.tan(fov / 2);
        const rangeInv = 1 / (near - far);
        
        m.elements[0] = f / aspect;
        m.elements[5] = f;
        m.elements[10] = (near + far) * rangeInv;
        m.elements[11] = -1;
        m.elements[14] = near * far * rangeInv * 2;
        m.elements[15] = 0;
        
        return m;
    }
    
    multiply(other) {
        const result = new Matrix4();
        const a = this.elements;
        const b = other.elements;
        const r = result.elements;
        
        for (let i = 0; i < 4; i++) {
            for (let j = 0; j < 4; j++) {
                r[i * 4 + j] = 
                    a[i * 4 + 0] * b[0 * 4 + j] +
                    a[i * 4 + 1] * b[1 * 4 + j] +
                    a[i * 4 + 2] * b[2 * 4 + j] +
                    a[i * 4 + 3] * b[3 * 4 + j];
            }
        }
        
        return result;
    }
    
    transformVector(v) {
        const x = v.x * this.elements[0] + v.y * this.elements[4] + v.z * this.elements[8] + this.elements[12];
        const y = v.x * this.elements[1] + v.y * this.elements[5] + v.z * this.elements[9] + this.elements[13];
        const z = v.x * this.elements[2] + v.y * this.elements[6] + v.z * this.elements[10] + this.elements[14];
        const w = v.x * this.elements[3] + v.y * this.elements[7] + v.z * this.elements[11] + this.elements[15];
        
        return new Vector3(x / w, y / w, z / w);
    }
}
```

### 3D Object Representation
```javascript
class Mesh3D {
    constructor() {
        this.vertices = [];
        this.faces = [];
        this.normals = [];
    }
    
    addVertex(x, y, z) {
        this.vertices.push(new Vector3(x, y, z));
    }
    
    addFace(v1, v2, v3) {
        this.faces.push([v1, v2, v3]);
        this.calculateFaceNormal(v1, v2, v3);
    }
    
    calculateFaceNormal(v1, v2, v3) {
        const edge1 = this.vertices[v2].subtract(this.vertices[v1]);
        const edge2 = this.vertices[v3].subtract(this.vertices[v1]);
        const normal = edge1.cross(edge2).normalize();
        this.normals.push(normal);
    }
    
    // Create a cube mesh
    static createCube(size = 1) {
        const mesh = new Mesh3D();
        const s = size / 2;
        
        // Define 8 vertices of a cube
        const vertices = [
            [-s, -s, -s], [s, -s, -s], [s, s, -s], [-s, s, -s],  // bottom
            [-s, -s, s], [s, -s, s], [s, s, s], [-s, s, s]       // top
        ];
        
        vertices.forEach(v => mesh.addVertex(v[0], v[1], v[2]));
        
        // Define 12 triangular faces (2 per cube face)
        const faces = [
            [0, 1, 2], [0, 2, 3],  // bottom
            [4, 7, 6], [4, 6, 5],  // top
            [0, 4, 5], [0, 5, 1],  // front
            [2, 6, 7], [2, 7, 3],  // back
            [0, 3, 7], [0, 7, 4],  // left
            [1, 5, 6], [1, 6, 2]   // right
        ];
        
        faces.forEach(f => mesh.addFace(f[0], f[1], f[2]));
        
        return mesh;
    }
    
    // Create a sphere mesh
    static createSphere(radius = 1, segments = 20) {
        const mesh = new Mesh3D();
        
        // Generate vertices
        for (let i = 0; i <= segments; i++) {
            const lat = Math.PI * i / segments;
            for (let j = 0; j <= segments; j++) {
                const lon = 2 * Math.PI * j / segments;
                const x = radius * Math.sin(lat) * Math.cos(lon);
                const y = radius * Math.cos(lat);
                const z = radius * Math.sin(lat) * Math.sin(lon);
                mesh.addVertex(x, y, z);
            }
        }
        
        // Generate faces
        for (let i = 0; i < segments; i++) {
            for (let j = 0; j < segments; j++) {
                const a = i * (segments + 1) + j;
                const b = a + segments + 1;
                const c = a + 1;
                const d = b + 1;
                
                mesh.addFace(a, b, c);
                mesh.addFace(b, d, c);
            }
        }
        
        return mesh;
    }
}
```

### 3D Rendering Pipeline
```javascript
class Renderer3D {
    constructor(canvas) {
        this.canvas = canvas;
        this.ctx = canvas.getContext('2d');
        this.width = canvas.width;
        this.height = canvas.height;
        
        // Camera properties
        this.camera = {
            position: new Vector3(0, 0, 5),
            target: new Vector3(0, 0, 0),
            up: new Vector3(0, 1, 0),
            fov: Math.PI / 4,
            near: 0.1,
            far: 100
        };
        
        // Projection matrix
        this.projectionMatrix = Matrix4.perspective(
            this.camera.fov,
            this.width / this.height,
            this.camera.near,
            this.camera.far
        );
    }
    
    // Convert 3D point to 2D screen coordinates
    projectPoint(point) {
        // Apply view matrix (simplified - just translation)
        const viewMatrix = Matrix4.translation(
            -this.camera.position.x,
            -this.camera.position.y,
            -this.camera.position.z
        );
        
        // Transform point
        const viewPoint = viewMatrix.transformVector(point);
        const projPoint = this.projectionMatrix.transformVector(viewPoint);
        
        // Convert to screen coordinates
        const screenX = (projPoint.x + 1) * this.width / 2;
        const screenY = (1 - projPoint.y) * this.height / 2;
        
        return { x: screenX, y: screenY, z: projPoint.z };
    }
    
    // Render a 3D mesh
    renderMesh(mesh, transform = Matrix4.identity()) {
        this.ctx.clearRect(0, 0, this.width, this.height);
        this.ctx.strokeStyle = '#333';
        this.ctx.lineWidth = 1;
        
        // Transform and project all vertices
        const projectedVertices = mesh.vertices.map(vertex => {
            const transformed = transform.transformVector(vertex);
            return this.projectPoint(transformed);
        });
        
        // Draw faces (wireframe)
        for (let i = 0; i < mesh.faces.length; i++) {
            const face = mesh.faces[i];
            const v1 = projectedVertices[face[0]];
            const v2 = projectedVertices[face[1]];
            const v3 = projectedVertices[face[2]];
            
            // Simple back-face culling
            const normal = this.calculateFaceNormal(v1, v2, v3);
            if (normal.z > 0) continue; // Skip back faces
            
            this.ctx.beginPath();
            this.ctx.moveTo(v1.x, v1.y);
            this.ctx.lineTo(v2.x, v2.y);
            this.ctx.lineTo(v3.x, v3.y);
            this.ctx.closePath();
            this.ctx.stroke();
        }
    }
    
    calculateFaceNormal(v1, v2, v3) {
        const edge1 = { x: v2.x - v1.x, y: v2.y - v1.y, z: v2.z - v1.z };
        const edge2 = { x: v3.x - v1.x, y: v3.y - v1.y, z: v3.z - v1.z };
        
        const normal = {
            x: edge1.y * edge2.z - edge1.z * edge2.y,
            y: edge1.z * edge2.x - edge1.x * edge2.z,
            z: edge1.x * edge2.y - edge1.y * edge2.x
        };
        
        const length = Math.sqrt(normal.x * normal.x + normal.y * normal.y + normal.z * normal.z);
        return {
            x: normal.x / length,
            y: normal.y / length,
            z: normal.z / length
        };
    }
}
```

### Animation and Rotation
```javascript
class Animation3D {
    constructor(renderer) {
        this.renderer = renderer;
        this.angle = 0;
        this.mesh = Mesh3D.createCube(2);
        this.animationId = null;
    }
    
    start() {
        const animate = () => {
            this.angle += 0.02;
            
            // Create rotation matrix
            const rotationX = Matrix4.rotationX(this.angle * 0.5);
            const rotationY = Matrix4.rotationY(this.angle);
            const rotationZ = Matrix4.rotationZ(this.angle * 0.3);
            
            // Combine rotations
            const transform = rotationX.multiply(rotationY).multiply(rotationZ);
            
            // Render the mesh
            this.renderer.renderMesh(this.mesh, transform);
            
            this.animationId = requestAnimationFrame(animate);
        };
        
        animate();
    }
    
    stop() {
        if (this.animationId) {
            cancelAnimationFrame(this.animationId);
            this.animationId = null;
        }
    }
}

// Usage example
function demonstrate3DGraphics() {
    const canvas = document.getElementById('canvas3d');
    const renderer = new Renderer3D(canvas);
    const animation = new Animation3D(renderer);
    
    // Start the animation
    animation.start();
    
    // Stop after 10 seconds
    setTimeout(() => {
        animation.stop();
    }, 10000);
}
```

### Lighting and Shading
```javascript
class Lighting3D {
    constructor() {
        this.lights = [];
        this.ambientLight = { r: 0.1, g: 0.1, b: 0.1 };
    }
    
    addDirectionalLight(direction, color) {
        this.lights.push({
            type: 'directional',
            direction: direction.normalize(),
            color: color
        });
    }
    
    addPointLight(position, color, intensity = 1) {
        this.lights.push({
            type: 'point',
            position: position,
            color: color,
            intensity: intensity
        });
    }
    
    calculateLighting(point, normal, material) {
        let totalLight = { ...this.ambientLight };
        
        for (const light of this.lights) {
            let lightDirection;
            let lightIntensity = 1;
            
            if (light.type === 'directional') {
                lightDirection = light.direction.multiply(-1);
            } else if (light.type === 'point') {
                lightDirection = point.subtract(light.position).normalize();
                const distance = point.subtract(light.position).length();
                lightIntensity = light.intensity / (distance * distance);
            }
            
            // Calculate diffuse lighting
            const dotProduct = Math.max(0, normal.dot(lightDirection));
            const diffuse = {
                r: light.color.r * dotProduct * lightIntensity,
                g: light.color.g * dotProduct * lightIntensity,
                b: light.color.b * dotProduct * lightIntensity
            };
            
            totalLight.r += diffuse.r;
            totalLight.g += diffuse.g;
            totalLight.b += diffuse.b;
        }
        
        // Apply material color
        return {
            r: Math.min(1, totalLight.r * material.r),
            g: Math.min(1, totalLight.g * material.g),
            b: Math.min(1, totalLight.b * material.b)
        };
    }
}
```

## 🔍 3D Graphics Concepts
- **3D Coordinates**: X, Y, Z axis system
- **Matrices**: 4x4 transformation matrices for 3D operations
- **Projection**: Converting 3D coordinates to 2D screen space
- **Meshes**: Vertices, faces, and normals for 3D objects
- **Rendering Pipeline**: Transform → Project → Rasterize
- **Lighting**: Ambient, directional, and point lighting models
- **Animation**: Frame-based 3D object animation

## 💡 Learning Points
- **3D transformations** use 4x4 matrices for efficiency
- **Projection matrices** convert 3D to 2D screen coordinates
- **Back-face culling** improves rendering performance
- **Lighting calculations** create realistic 3D appearance
- **Animation** requires continuous matrix updates
- **Vector math** is fundamental to 3D graphics

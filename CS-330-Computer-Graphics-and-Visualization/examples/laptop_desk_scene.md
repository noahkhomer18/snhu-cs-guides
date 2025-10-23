# CS-330 Laptop on Desk Scene

## 🎯 Purpose
Demonstrate how to build complex 3D scenes by combining multiple objects, focusing on creating a realistic laptop on a desk with proper materials, lighting, and composition.

## 📝 Laptop on Desk Scene Examples

### 1. Scene Structure and Object Hierarchy

#### Main Scene Class
```javascript
// File: src/scenes/laptopDeskScene.js
class LaptopDeskScene {
    constructor(gl, textureLoader, materialManager) {
        this.gl = gl;
        this.textureLoader = textureLoader;
        this.materialManager = materialManager;
        
        this.objects = [];
        this.lights = [];
        this.camera = null;
        
        this.initializeScene();
    }
    
    async initializeScene() {
        // Create desk
        await this.createDesk();
        
        // Create laptop
        await this.createLaptop();
        
        // Create accessories
        await this.createAccessories();
        
        // Setup lighting
        this.setupLighting();
        
        // Setup camera
        this.setupCamera();
    }
    
    async createDesk() {
        // Desk surface (main tabletop)
        const deskSurface = new DeskSurface({
            position: [0, -1, 0],
            dimensions: [4, 0.1, 2],
            material: await this.materialManager.getMaterial('oak_wood')
        });
        this.objects.push(deskSurface);
        
        // Desk legs
        const legPositions = [
            [-1.8, -1.5, -0.8],  // Front left
            [1.8, -1.5, -0.8],   // Front right
            [-1.8, -1.5, 0.8],   // Back left
            [1.8, -1.5, 0.8]     // Back right
        ];
        
        legPositions.forEach(pos => {
            const leg = new DeskLeg({
                position: pos,
                dimensions: [0.1, 1.4, 0.1],
                material: await this.materialManager.getMaterial('steel_brushed')
            });
            this.objects.push(leg);
        });
        
        // Desk drawers
        const leftDrawer = new DeskDrawer({
            position: [-1.2, -0.7, 0],
            dimensions: [0.8, 0.6, 0.4],
            material: await this.materialManager.getMaterial('oak_wood')
        });
        this.objects.push(leftDrawer);
        
        const rightDrawer = new DeskDrawer({
            position: [1.2, -0.7, 0],
            dimensions: [0.8, 0.6, 0.4],
            material: await this.materialManager.getMaterial('oak_wood')
        });
        this.objects.push(rightDrawer);
    }
    
    async createLaptop() {
        // Laptop base
        const laptopBase = new LaptopBase({
            position: [0, 0, 0],
            dimensions: [0.35, 0.02, 0.25],
            material: await this.materialManager.getMaterial('aluminum_brushed')
        });
        this.objects.push(laptopBase);
        
        // Laptop screen
        const laptopScreen = new LaptopScreen({
            position: [0, 0.15, 0.1],
            dimensions: [0.35, 0.02, 0.25],
            rotation: [0, 0, 0],
            material: await this.materialManager.getMaterial('aluminum_brushed')
        });
        this.objects.push(laptopScreen);
        
        // Laptop screen display
        const screenDisplay = new ScreenDisplay({
            position: [0, 0.16, 0.1],
            dimensions: [0.32, 0.02, 0.22],
            material: await this.materialManager.getMaterial('lcd_screen')
        });
        this.objects.push(screenDisplay);
        
        // Laptop keyboard
        const keyboard = new LaptopKeyboard({
            position: [0, 0.01, 0],
            dimensions: [0.3, 0.01, 0.2],
            material: await this.materialManager.getMaterial('black_plastic')
        });
        this.objects.push(keyboard);
        
        // Laptop trackpad
        const trackpad = new LaptopTrackpad({
            position: [0, 0.01, -0.05],
            dimensions: [0.08, 0.01, 0.05],
            material: await this.materialManager.getMaterial('black_plastic')
        });
        this.objects.push(trackpad);
    }
    
    async createAccessories() {
        // Mouse
        const mouse = new ComputerMouse({
            position: [0.3, 0, 0],
            dimensions: [0.12, 0.04, 0.08],
            material: await this.materialManager.getMaterial('black_plastic')
        });
        this.objects.push(mouse);
        
        // Mouse pad
        const mousePad = new MousePad({
            position: [0.3, -0.01, 0],
            dimensions: [0.2, 0.01, 0.15],
            material: await this.materialManager.getMaterial('rubber')
        });
        this.objects.push(mousePad);
        
        // Coffee mug
        const coffeeMug = new CoffeeMug({
            position: [-0.4, 0, 0.3],
            dimensions: [0.08, 0.1, 0.08],
            material: await this.materialManager.getMaterial('ceramic')
        });
        this.objects.push(coffeeMug);
        
        // Desk lamp
        const deskLamp = new DeskLamp({
            position: [0.5, 0.3, 0.5],
            dimensions: [0.05, 0.3, 0.05],
            material: await this.materialManager.getMaterial('metal_silver')
        });
        this.objects.push(deskLamp);
        
        // Books
        const book1 = new Book({
            position: [-0.6, 0, -0.3],
            dimensions: [0.15, 0.02, 0.2],
            material: await this.materialManager.getMaterial('paper')
        });
        this.objects.push(book1);
        
        const book2 = new Book({
            position: [-0.45, 0.02, -0.3],
            dimensions: [0.15, 0.02, 0.2],
            material: await this.materialManager.getMaterial('paper')
        });
        this.objects.push(book2);
    }
    
    setupLighting() {
        // Main directional light (sunlight through window)
        const mainLight = new DirectionalLight({
            direction: [0.5, -1, 0.3],
            color: [1, 0.95, 0.8],
            intensity: 1.0
        });
        this.lights.push(mainLight);
        
        // Desk lamp light
        const lampLight = new PointLight({
            position: [0.5, 0.2, 0.5],
            color: [1, 0.9, 0.7],
            intensity: 0.8,
            range: 2.0
        });
        this.lights.push(lampLight);
        
        // Ambient light
        const ambientLight = new AmbientLight({
            color: [0.3, 0.3, 0.4],
            intensity: 0.2
        });
        this.lights.push(ambientLight);
    }
    
    setupCamera() {
        this.camera = new Camera({
            position: [2, 1, 2],
            target: [0, 0, 0],
            up: [0, 1, 0],
            fov: 60,
            near: 0.1,
            far: 100
        });
    }
    
    render() {
        // Clear screen
        this.gl.clearColor(0.1, 0.1, 0.15, 1.0);
        this.gl.clear(this.gl.COLOR_BUFFER_BIT | this.gl.DEPTH_BUFFER_BIT);
        
        // Render all objects
        this.objects.forEach(obj => {
            obj.render(this.gl, this.camera, this.lights);
        });
    }
}
```

### 2. Individual Object Classes

#### Laptop Base
```javascript
// File: src/objects/laptopBase.js
class LaptopBase {
    constructor(options) {
        this.position = options.position;
        this.dimensions = options.dimensions;
        this.material = options.material;
        this.geometry = null;
        this.mesh = null;
        
        this.createGeometry();
    }
    
    createGeometry() {
        // Create laptop base geometry
        const [width, height, depth] = this.dimensions;
        
        // Main body
        const bodyGeometry = new BoxGeometry(width, height, depth);
        
        // Rounded corners (simplified)
        const cornerRadius = 0.02;
        const cornerGeometry = new CylinderGeometry(cornerRadius, cornerRadius, height, 8);
        
        // Combine geometries
        this.geometry = this.combineGeometries([bodyGeometry]);
        
        // Create mesh
        this.mesh = new Mesh(this.geometry, this.material);
        this.mesh.position.set(...this.position);
    }
    
    combineGeometries(geometries) {
        // Combine multiple geometries into one
        const combinedGeometry = new BufferGeometry();
        const vertices = [];
        const normals = [];
        const uvs = [];
        const indices = [];
        
        let vertexOffset = 0;
        
        geometries.forEach(geometry => {
            const geometryVertices = geometry.attributes.position.array;
            const geometryNormals = geometry.attributes.normal.array;
            const geometryUvs = geometry.attributes.uv.array;
            const geometryIndices = geometry.index.array;
            
            vertices.push(...geometryVertices);
            normals.push(...geometryNormals);
            uvs.push(...geometryUvs);
            
            geometryIndices.forEach(index => {
                indices.push(index + vertexOffset);
            });
            
            vertexOffset += geometryVertices.length / 3;
        });
        
        combinedGeometry.setAttribute('position', new Float32BufferAttribute(vertices, 3));
        combinedGeometry.setAttribute('normal', new Float32BufferAttribute(normals, 3));
        combinedGeometry.setAttribute('uv', new Float32BufferAttribute(uvs, 2));
        combinedGeometry.setIndex(indices);
        
        return combinedGeometry;
    }
    
    render(gl, camera, lights) {
        // Apply transformations
        const modelMatrix = this.createModelMatrix();
        
        // Set uniforms
        this.material.applyToShader(gl, camera, lights, modelMatrix);
        
        // Render geometry
        this.renderGeometry(gl);
    }
    
    createModelMatrix() {
        const matrix = new Matrix4();
        matrix.makeTranslation(...this.position);
        return matrix;
    }
    
    renderGeometry(gl) {
        // Bind vertex array object
        gl.bindVertexArray(this.geometry.vao);
        
        // Draw elements
        gl.drawElements(gl.TRIANGLES, this.geometry.indexCount, gl.UNSIGNED_SHORT, 0);
    }
}
```

#### Laptop Screen
```javascript
// File: src/objects/laptopScreen.js
class LaptopScreen {
    constructor(options) {
        this.position = options.position;
        this.dimensions = options.dimensions;
        this.rotation = options.rotation;
        this.material = options.material;
        this.geometry = null;
        this.mesh = null;
        
        this.createGeometry();
    }
    
    createGeometry() {
        const [width, height, depth] = this.dimensions;
        
        // Screen frame
        const frameGeometry = new BoxGeometry(width, height, depth);
        
        // Screen bezel (border)
        const bezelGeometry = new BoxGeometry(width * 0.95, height * 0.95, depth * 0.1);
        
        // Screen surface
        const screenGeometry = new BoxGeometry(width * 0.9, height * 0.9, depth * 0.05);
        
        // Combine all parts
        this.geometry = this.combineGeometries([frameGeometry, bezelGeometry, screenGeometry]);
        
        this.mesh = new Mesh(this.geometry, this.material);
        this.mesh.position.set(...this.position);
        this.mesh.rotation.set(...this.rotation);
    }
    
    combineGeometries(geometries) {
        // Similar to LaptopBase implementation
        // ... (implementation details)
    }
    
    render(gl, camera, lights) {
        const modelMatrix = this.createModelMatrix();
        this.material.applyToShader(gl, camera, lights, modelMatrix);
        this.renderGeometry(gl);
    }
    
    createModelMatrix() {
        const matrix = new Matrix4();
        matrix.makeTranslation(...this.position);
        matrix.rotateX(this.rotation[0]);
        matrix.rotateY(this.rotation[1]);
        matrix.rotateZ(this.rotation[2]);
        return matrix;
    }
    
    renderGeometry(gl) {
        gl.bindVertexArray(this.geometry.vao);
        gl.drawElements(gl.TRIANGLES, this.geometry.indexCount, gl.UNSIGNED_SHORT, 0);
    }
}
```

#### Desk Surface
```javascript
// File: src/objects/deskSurface.js
class DeskSurface {
    constructor(options) {
        this.position = options.position;
        this.dimensions = options.dimensions;
        this.material = options.material;
        this.geometry = null;
        
        this.createGeometry();
    }
    
    createGeometry() {
        const [width, height, depth] = this.dimensions;
        
        // Main surface
        const surfaceGeometry = new BoxGeometry(width, height, depth);
        
        // Add wood grain detail
        const grainGeometry = this.createWoodGrainGeometry(width, depth);
        
        this.geometry = this.combineGeometries([surfaceGeometry, grainGeometry]);
    }
    
    createWoodGrainGeometry(width, depth) {
        const segments = 32;
        const geometry = new PlaneGeometry(width, depth, segments, segments);
        
        // Modify vertices to create wood grain effect
        const positions = geometry.attributes.position.array;
        for (let i = 0; i < positions.length; i += 3) {
            const x = positions[i];
            const z = positions[i + 2];
            
            // Create wave pattern for wood grain
            const grain = Math.sin(x * 10) * 0.01 + Math.sin(z * 15) * 0.005;
            positions[i + 1] += grain;
        }
        
        geometry.attributes.position.needsUpdate = true;
        geometry.computeVertexNormals();
        
        return geometry;
    }
    
    combineGeometries(geometries) {
        // Implementation similar to other objects
        // ... (implementation details)
    }
    
    render(gl, camera, lights) {
        const modelMatrix = this.createModelMatrix();
        this.material.applyToShader(gl, camera, lights, modelMatrix);
        this.renderGeometry(gl);
    }
    
    createModelMatrix() {
        const matrix = new Matrix4();
        matrix.makeTranslation(...this.position);
        return matrix;
    }
    
    renderGeometry(gl) {
        gl.bindVertexArray(this.geometry.vao);
        gl.drawElements(gl.TRIANGLES, this.geometry.indexCount, gl.UNSIGNED_SHORT, 0);
    }
}
```

### 3. Material System for Realistic Objects

#### Material Manager
```javascript
// File: src/materials/materialManager.js
class MaterialManager {
    constructor(textureLoader) {
        this.textureLoader = textureLoader;
        this.materials = new Map();
        this.initializeMaterials();
    }
    
    async initializeMaterials() {
        // Aluminum brushed material
        this.materials.set('aluminum_brushed', new Material({
            diffuseTexture: await this.textureLoader.loadTexture('aluminum_brushed.jpg', 'metal'),
            normalTexture: await this.textureLoader.loadTexture('aluminum_brushed_normal.jpg', 'metal'),
            specularTexture: await this.textureLoader.loadTexture('aluminum_brushed_specular.jpg', 'metal'),
            diffuseColor: [0.8, 0.8, 0.85],
            specularColor: [0.9, 0.9, 0.9],
            shininess: 128,
            roughness: 0.3
        }));
        
        // Oak wood material
        this.materials.set('oak_wood', new Material({
            diffuseTexture: await this.textureLoader.loadTexture('oak_wood.jpg', 'wood'),
            normalTexture: await this.textureLoader.loadTexture('oak_wood_normal.jpg', 'wood'),
            specularTexture: await this.textureLoader.loadTexture('oak_wood_specular.jpg', 'wood'),
            diffuseColor: [0.8, 0.6, 0.4],
            specularColor: [0.2, 0.1, 0.1],
            shininess: 32,
            roughness: 0.8
        }));
        
        // Steel brushed material
        this.materials.set('steel_brushed', new Material({
            diffuseTexture: await this.textureLoader.loadTexture('steel_brushed.jpg', 'metal'),
            normalTexture: await this.textureLoader.loadTexture('steel_brushed_normal.jpg', 'metal'),
            specularTexture: await this.textureLoader.loadTexture('steel_brushed_specular.jpg', 'metal'),
            diffuseColor: [0.7, 0.7, 0.75],
            specularColor: [0.8, 0.8, 0.8],
            shininess: 64,
            roughness: 0.6
        }));
        
        // LCD screen material
        this.materials.set('lcd_screen', new Material({
            diffuseTexture: await this.textureLoader.loadTexture('lcd_screen.jpg', 'screens'),
            emissiveTexture: await this.textureLoader.loadTexture('lcd_screen_emissive.jpg', 'screens'),
            diffuseColor: [0.1, 0.1, 0.1],
            emissiveColor: [0.2, 0.2, 0.2],
            shininess: 256,
            roughness: 0.1
        }));
        
        // Black plastic material
        this.materials.set('black_plastic', new Material({
            diffuseTexture: await this.textureLoader.loadTexture('black_plastic.jpg', 'plastic'),
            normalTexture: await this.textureLoader.loadTexture('black_plastic_normal.jpg', 'plastic'),
            diffuseColor: [0.1, 0.1, 0.1],
            specularColor: [0.3, 0.3, 0.3],
            shininess: 64,
            roughness: 0.4
        }));
        
        // Ceramic material
        this.materials.set('ceramic', new Material({
            diffuseTexture: await this.textureLoader.loadTexture('ceramic.jpg', 'materials'),
            normalTexture: await this.textureLoader.loadTexture('ceramic_normal.jpg', 'materials'),
            diffuseColor: [0.9, 0.9, 0.9],
            specularColor: [0.1, 0.1, 0.1],
            shininess: 16,
            roughness: 0.9
        }));
    }
    
    async getMaterial(name) {
        if (this.materials.has(name)) {
            return this.materials.get(name);
        }
        
        // Create material on demand
        const material = await this.createMaterial(name);
        this.materials.set(name, material);
        return material;
    }
    
    async createMaterial(name) {
        // Material creation logic based on name
        // ... (implementation details)
    }
}
```

### 4. Lighting System

#### Lighting Classes
```javascript
// File: src/lighting/lighting.js
class DirectionalLight {
    constructor(options) {
        this.direction = options.direction;
        this.color = options.color;
        this.intensity = options.intensity;
        this.type = 'directional';
    }
    
    applyToShader(gl, program) {
        const directionLocation = gl.getUniformLocation(program, 'u_directionalLight.direction');
        const colorLocation = gl.getUniformLocation(program, 'u_directionalLight.color');
        const intensityLocation = gl.getUniformLocation(program, 'u_directionalLight.intensity');
        
        gl.uniform3f(directionLocation, this.direction[0], this.direction[1], this.direction[2]);
        gl.uniform3f(colorLocation, this.color[0], this.color[1], this.color[2]);
        gl.uniform1f(intensityLocation, this.intensity);
    }
}

class PointLight {
    constructor(options) {
        this.position = options.position;
        this.color = options.color;
        this.intensity = options.intensity;
        this.range = options.range;
        this.type = 'point';
    }
    
    applyToShader(gl, program) {
        const positionLocation = gl.getUniformLocation(program, 'u_pointLight.position');
        const colorLocation = gl.getUniformLocation(program, 'u_pointLight.color');
        const intensityLocation = gl.getUniformLocation(program, 'u_pointLight.intensity');
        const rangeLocation = gl.getUniformLocation(program, 'u_pointLight.range');
        
        gl.uniform3f(positionLocation, this.position[0], this.position[1], this.position[2]);
        gl.uniform3f(colorLocation, this.color[0], this.color[1], this.color[2]);
        gl.uniform1f(intensityLocation, this.intensity);
        gl.uniform1f(rangeLocation, this.range);
    }
}

class AmbientLight {
    constructor(options) {
        this.color = options.color;
        this.intensity = options.intensity;
        this.type = 'ambient';
    }
    
    applyToShader(gl, program) {
        const colorLocation = gl.getUniformLocation(program, 'u_ambientLight.color');
        const intensityLocation = gl.getUniformLocation(program, 'u_ambientLight.intensity');
        
        gl.uniform3f(colorLocation, this.color[0], this.color[1], this.color[2]);
        gl.uniform1f(intensityLocation, this.intensity);
    }
}
```

### 5. Camera System

#### Camera Class
```javascript
// File: src/camera/camera.js
class Camera {
    constructor(options) {
        this.position = options.position;
        this.target = options.target;
        this.up = options.up;
        this.fov = options.fov;
        this.near = options.near;
        this.far = options.far;
        
        this.viewMatrix = new Matrix4();
        this.projectionMatrix = new Matrix4();
        this.updateMatrices();
    }
    
    updateMatrices() {
        // Update view matrix
        this.viewMatrix.lookAt(
            this.position[0], this.position[1], this.position[2],
            this.target[0], this.target[1], this.target[2],
            this.up[0], this.up[1], this.up[2]
        );
        
        // Update projection matrix
        const aspect = window.innerWidth / window.innerHeight;
        this.projectionMatrix.perspective(this.fov, aspect, this.near, this.far);
    }
    
    applyToShader(gl, program) {
        const viewLocation = gl.getUniformLocation(program, 'u_viewMatrix');
        const projectionLocation = gl.getUniformLocation(program, 'u_projectionMatrix');
        
        gl.uniformMatrix4fv(viewLocation, false, this.viewMatrix.elements);
        gl.uniformMatrix4fv(projectionLocation, false, this.projectionMatrix.elements);
    }
}
```

### 6. Main Application

#### Application Class
```javascript
// File: src/app.js
class LaptopDeskApp {
    constructor() {
        this.canvas = document.getElementById('webgl-canvas');
        this.gl = this.canvas.getContext('webgl') || this.canvas.getContext('experimental-webgl');
        
        if (!this.gl) {
            alert('WebGL not supported');
            return;
        }
        
        this.textureLoader = new TextureLoader(this.gl);
        this.materialManager = new MaterialManager(this.textureLoader);
        this.scene = null;
        
        this.initialize();
    }
    
    async initialize() {
        // Set canvas size
        this.canvas.width = window.innerWidth;
        this.canvas.height = window.innerHeight;
        this.gl.viewport(0, 0, this.canvas.width, this.canvas.height);
        
        // Enable depth testing
        this.gl.enable(this.gl.DEPTH_TEST);
        this.gl.depthFunc(this.gl.LEQUAL);
        
        // Enable face culling
        this.gl.enable(this.gl.CULL_FACE);
        this.gl.cullFace(this.gl.BACK);
        
        // Create scene
        this.scene = new LaptopDeskScene(this.gl, this.textureLoader, this.materialManager);
        
        // Start render loop
        this.render();
    }
    
    render() {
        // Clear screen
        this.gl.clearColor(0.1, 0.1, 0.15, 1.0);
        this.gl.clear(this.gl.COLOR_BUFFER_BIT | this.gl.DEPTH_BUFFER_BIT);
        
        // Render scene
        this.scene.render();
        
        // Continue render loop
        requestAnimationFrame(() => this.render());
    }
}

// Initialize application
document.addEventListener('DOMContentLoaded', () => {
    new LaptopDeskApp();
});
```

## 🔍 Complex Scene Concepts
- **Object Hierarchy**: Organizing complex scenes with parent-child relationships
- **Material Variety**: Different materials for different object types
- **Lighting Setup**: Multiple light sources for realistic illumination
- **Camera Positioning**: Optimal viewing angles for scene composition
- **Geometry Combination**: Building complex objects from simple shapes
- **Performance Optimization**: Efficient rendering of multiple objects

## 💡 Learning Points
- **Scene composition** requires careful planning and organization
- **Material variety** creates visual interest and realism
- **Lighting setup** dramatically affects scene appearance
- **Object relationships** help maintain scene structure
- **Performance considerations** are crucial for complex scenes
- **Realistic details** make scenes more believable

## 🛠️ Implementation Tips
1. **Start with basic shapes** and build complexity gradually
2. **Use consistent materials** for related objects
3. **Position lights strategically** for best visual impact
4. **Optimize geometry** for better performance
5. **Test on different devices** to ensure compatibility
6. **Consider scene scale** for realistic proportions

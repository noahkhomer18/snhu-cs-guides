# CS-330 Visual Studio Code Image Import Guide

## 🎯 Purpose
Demonstrate how to import and organize image folders in Visual Studio Code for 3D graphics projects, including texture management and asset organization.

## 📝 Visual Studio Code Image Import Examples

### 1. Project Structure Setup

#### Folder Organization
```
your-3d-project/
├── assets/
│   ├── textures/
│   │   ├── wood/
│   │   │   ├── oak_wood.jpg
│   │   │   ├── mahogany_wood.jpg
│   │   │   └── pine_wood.jpg
│   │   ├── metal/
│   │   │   ├── steel_brushed.jpg
│   │   │   ├── aluminum.jpg
│   │   │   └── copper.jpg
│   │   ├── fabric/
│   │   │   ├── leather.jpg
│   │   │   ├── canvas.jpg
│   │   │   └── silk.jpg
│   │   ├── glass/
│   │   │   ├── clear_glass.jpg
│   │   │   ├── frosted_glass.jpg
│   │   │   └── stained_glass.jpg
│   │   └── glow/
│   │       ├── neon_blue.jpg
│   │       ├── neon_green.jpg
│   │       └── neon_pink.jpg
│   ├── models/
│   │   ├── laptop.obj
│   │   ├── desk.obj
│   │   └── chair.obj
│   └── shaders/
│       ├── vertex.glsl
│       └── fragment.glsl
├── src/
│   ├── main.js
│   ├── textureLoader.js
│   └── scene.js
└── index.html
```

### 2. HTML Setup for Image Loading
```html
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>3D Graphics with Texture Import</title>
    <style>
        body {
            margin: 0;
            padding: 0;
            background: #1a1a1a;
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
        }
        canvas {
            display: block;
            cursor: grab;
        }
        .controls {
            position: absolute;
            top: 10px;
            left: 10px;
            background: rgba(0, 0, 0, 0.8);
            color: white;
            padding: 15px;
            border-radius: 8px;
            font-size: 14px;
        }
        .texture-selector {
            margin: 10px 0;
        }
        .texture-selector select {
            background: #333;
            color: white;
            border: 1px solid #555;
            padding: 5px;
            border-radius: 4px;
        }
        .loading {
            color: #ffa500;
        }
        .loaded {
            color: #00ff00;
        }
    </style>
</head>
<body>
    <canvas id="webgl-canvas"></canvas>
    
    <div class="controls">
        <h3>Texture Controls</h3>
        <div class="texture-selector">
            <label>Wood Texture:</label>
            <select id="wood-texture">
                <option value="oak_wood.jpg">Oak Wood</option>
                <option value="mahogany_wood.jpg">Mahogany Wood</option>
                <option value="pine_wood.jpg">Pine Wood</option>
            </select>
        </div>
        
        <div class="texture-selector">
            <label>Metal Texture:</label>
            <select id="metal-texture">
                <option value="steel_brushed.jpg">Steel Brushed</option>
                <option value="aluminum.jpg">Aluminum</option>
                <option value="copper.jpg">Copper</option>
            </select>
        </div>
        
        <div class="texture-selector">
            <label>Glow Effect:</label>
            <select id="glow-texture">
                <option value="none">None</option>
                <option value="neon_blue.jpg">Neon Blue</option>
                <option value="neon_green.jpg">Neon Green</option>
                <option value="neon_pink.jpg">Neon Pink</option>
            </select>
        </div>
        
        <div id="loading-status" class="loading">Loading textures...</div>
    </div>

    <script src="src/textureLoader.js"></script>
    <script src="src/scene.js"></script>
    <script src="src/main.js"></script>
</body>
</html>
```

### 3. Texture Loader Class
```javascript
// File: src/textureLoader.js
class TextureLoader {
    constructor(gl) {
        this.gl = gl;
        this.textures = new Map();
        this.loadingPromises = new Map();
        this.basePath = './assets/textures/';
    }
    
    // Load a single texture
    async loadTexture(textureName, category = '') {
        const fullPath = category ? `${this.basePath}${category}/${textureName}` : `${this.basePath}${textureName}`;
        
        // Check if already loading
        if (this.loadingPromises.has(fullPath)) {
            return this.loadingPromises.get(fullPath);
        }
        
        // Check if already loaded
        if (this.textures.has(fullPath)) {
            return this.textures.get(fullPath);
        }
        
        const promise = this.createTextureFromImage(fullPath);
        this.loadingPromises.set(fullPath, promise);
        
        try {
            const texture = await promise;
            this.textures.set(fullPath, texture);
            this.loadingPromises.delete(fullPath);
            return texture;
        } catch (error) {
            console.error(`Failed to load texture: ${fullPath}`, error);
            this.loadingPromises.delete(fullPath);
            throw error;
        }
    }
    
    // Create texture from image
    createTextureFromImage(imagePath) {
        return new Promise((resolve, reject) => {
            const image = new Image();
            image.crossOrigin = 'anonymous';
            
            image.onload = () => {
                const texture = this.gl.createTexture();
                this.gl.bindTexture(this.gl.TEXTURE_2D, texture);
                
                // Upload image data to texture
                this.gl.texImage2D(this.gl.TEXTURE_2D, 0, this.gl.RGBA, this.gl.RGBA, this.gl.UNSIGNED_BYTE, image);
                
                // Set texture parameters
                this.gl.texParameteri(this.gl.TEXTURE_2D, this.gl.TEXTURE_WRAP_S, this.gl.REPEAT);
                this.gl.texParameteri(this.gl.TEXTURE_2D, this.gl.TEXTURE_WRAP_T, this.gl.REPEAT);
                this.gl.texParameteri(this.gl.TEXTURE_2D, this.gl.TEXTURE_MIN_FILTER, this.gl.LINEAR);
                this.gl.texParameteri(this.gl.TEXTURE_2D, this.gl.TEXTURE_MAG_FILTER, this.gl.LINEAR);
                
                // Generate mipmaps
                this.gl.generateMipmap(this.gl.TEXTURE_2D);
                
                resolve(texture);
            };
            
            image.onerror = () => {
                reject(new Error(`Failed to load image: ${imagePath}`));
            };
            
            image.src = imagePath;
        });
    }
    
    // Load multiple textures from a category
    async loadTextureCategory(category) {
        const textureFiles = {
            'wood': ['oak_wood.jpg', 'mahogany_wood.jpg', 'pine_wood.jpg'],
            'metal': ['steel_brushed.jpg', 'aluminum.jpg', 'copper.jpg'],
            'fabric': ['leather.jpg', 'canvas.jpg', 'silk.jpg'],
            'glass': ['clear_glass.jpg', 'frosted_glass.jpg', 'stained_glass.jpg'],
            'glow': ['neon_blue.jpg', 'neon_green.jpg', 'neon_pink.jpg']
        };
        
        const files = textureFiles[category] || [];
        const promises = files.map(file => this.loadTexture(file, category));
        
        try {
            const textures = await Promise.all(promises);
            const result = {};
            files.forEach((file, index) => {
                result[file] = textures[index];
            });
            return result;
        } catch (error) {
            console.error(`Failed to load texture category: ${category}`, error);
            throw error;
        }
    }
    
    // Load all textures
    async loadAllTextures() {
        const categories = ['wood', 'metal', 'fabric', 'glass', 'glow'];
        const promises = categories.map(category => this.loadTextureCategory(category));
        
        try {
            const results = await Promise.all(promises);
            const allTextures = {};
            results.forEach((categoryTextures, index) => {
                allTextures[categories[index]] = categoryTextures;
            });
            return allTextures;
        } catch (error) {
            console.error('Failed to load all textures', error);
            throw error;
        }
    }
    
    // Get texture by name and category
    getTexture(textureName, category = '') {
        const fullPath = category ? `${this.basePath}${category}/${textureName}` : `${this.basePath}${textureName}`;
        return this.textures.get(fullPath);
    }
    
    // Create texture atlas from multiple images
    async createTextureAtlas(imagePaths, atlasSize = 1024) {
        const canvas = document.createElement('canvas');
        canvas.width = atlasSize;
        canvas.height = atlasSize;
        const ctx = canvas.getContext('2d');
        
        const images = await Promise.all(
            imagePaths.map(path => this.loadImage(path))
        );
        
        const tileSize = Math.floor(atlasSize / Math.ceil(Math.sqrt(images.length)));
        const tilesPerRow = Math.floor(atlasSize / tileSize);
        
        const atlasData = {};
        
        images.forEach((image, index) => {
            const x = (index % tilesPerRow) * tileSize;
            const y = Math.floor(index / tilesPerRow) * tileSize;
            
            ctx.drawImage(image, x, y, tileSize, tileSize);
            
            atlasData[imagePaths[index]] = {
                x: x / atlasSize,
                y: y / atlasSize,
                width: tileSize / atlasSize,
                height: tileSize / atlasSize
            };
        });
        
        const texture = this.gl.createTexture();
        this.gl.bindTexture(this.gl.TEXTURE_2D, texture);
        this.gl.texImage2D(this.gl.TEXTURE_2D, 0, this.gl.RGBA, this.gl.RGBA, this.gl.UNSIGNED_BYTE, canvas);
        
        this.gl.texParameteri(this.gl.TEXTURE_2D, this.gl.TEXTURE_WRAP_S, this.gl.CLAMP_TO_EDGE);
        this.gl.texParameteri(this.gl.TEXTURE_2D, this.gl.TEXTURE_WRAP_T, this.gl.CLAMP_TO_EDGE);
        this.gl.texParameteri(this.gl.TEXTURE_2D, this.gl.TEXTURE_MIN_FILTER, this.gl.LINEAR);
        this.gl.texParameteri(this.gl.TEXTURE_2D, this.gl.TEXTURE_MAG_FILTER, this.gl.LINEAR);
        
        return { texture, atlasData };
    }
    
    // Helper method to load image
    loadImage(imagePath) {
        return new Promise((resolve, reject) => {
            const image = new Image();
            image.crossOrigin = 'anonymous';
            image.onload = () => resolve(image);
            image.onerror = () => reject(new Error(`Failed to load image: ${imagePath}`));
            image.src = imagePath;
        });
    }
}
```

### 4. Scene Management with Textures
```javascript
// File: src/scene.js
class Scene {
    constructor(gl, textureLoader) {
        this.gl = gl;
        this.textureLoader = textureLoader;
        this.objects = [];
        this.currentTextures = {
            wood: null,
            metal: null,
            glow: null
        };
    }
    
    async initialize() {
        try {
            // Load all textures
            const allTextures = await this.textureLoader.loadAllTextures();
            
            // Set default textures
            this.currentTextures.wood = allTextures.wood.oak_wood.jpg;
            this.currentTextures.metal = allTextures.metal.steel_brushed.jpg;
            this.currentTextures.glow = null;
            
            // Create scene objects
            this.createLaptop();
            this.createDesk();
            this.createChair();
            
            // Update loading status
            this.updateLoadingStatus('loaded');
            
        } catch (error) {
            console.error('Failed to initialize scene:', error);
            this.updateLoadingStatus('error');
        }
    }
    
    createLaptop() {
        const laptop = {
            type: 'laptop',
            position: [0, 0, 0],
            rotation: [0, 0, 0],
            scale: [1, 1, 1],
            textures: {
                body: this.currentTextures.metal,
                screen: this.currentTextures.glow
            }
        };
        this.objects.push(laptop);
    }
    
    createDesk() {
        const desk = {
            type: 'desk',
            position: [0, -2, 0],
            rotation: [0, 0, 0],
            scale: [2, 0.1, 1],
            textures: {
                surface: this.currentTextures.wood,
                legs: this.currentTextures.metal
            }
        };
        this.objects.push(desk);
    }
    
    createChair() {
        const chair = {
            type: 'chair',
            position: [2, -1, 0],
            rotation: [0, 0, 0],
            scale: [0.5, 1, 0.5],
            textures: {
                seat: this.currentTextures.wood,
                back: this.currentTextures.wood,
                legs: this.currentTextures.metal
            }
        };
        this.objects.push(chair);
    }
    
    updateTexture(category, textureName) {
        const texture = this.textureLoader.getTexture(textureName, category);
        if (texture) {
            this.currentTextures[category] = texture;
            this.updateObjectTextures();
        }
    }
    
    updateObjectTextures() {
        this.objects.forEach(obj => {
            switch (obj.type) {
                case 'laptop':
                    obj.textures.body = this.currentTextures.metal;
                    obj.textures.screen = this.currentTextures.glow;
                    break;
                case 'desk':
                    obj.textures.surface = this.currentTextures.wood;
                    obj.textures.legs = this.currentTextures.metal;
                    break;
                case 'chair':
                    obj.textures.seat = this.currentTextures.wood;
                    obj.textures.back = this.currentTextures.wood;
                    obj.textures.legs = this.currentTextures.metal;
                    break;
            }
        });
    }
    
    updateLoadingStatus(status) {
        const statusElement = document.getElementById('loading-status');
        if (statusElement) {
            statusElement.className = status;
            statusElement.textContent = 
                status === 'loaded' ? 'Textures loaded successfully!' :
                status === 'error' ? 'Failed to load textures' :
                'Loading textures...';
        }
    }
    
    getObjects() {
        return this.objects;
    }
}
```

### 5. Main Application
```javascript
// File: src/main.js
class GraphicsApp {
    constructor() {
        this.canvas = document.getElementById('webgl-canvas');
        this.gl = this.canvas.getContext('webgl') || this.canvas.getContext('experimental-webgl');
        
        if (!this.gl) {
            alert('WebGL not supported');
            return;
        }
        
        this.textureLoader = new TextureLoader(this.gl);
        this.scene = new Scene(this.gl, this.textureLoader);
        this.setupEventListeners();
        this.initialize();
    }
    
    async initialize() {
        // Set canvas size
        this.canvas.width = window.innerWidth;
        this.canvas.height = window.innerHeight;
        
        // Initialize scene
        await this.scene.initialize();
        
        // Start render loop
        this.render();
    }
    
    setupEventListeners() {
        // Wood texture selector
        const woodSelect = document.getElementById('wood-texture');
        if (woodSelect) {
            woodSelect.addEventListener('change', (e) => {
                this.scene.updateTexture('wood', e.target.value);
            });
        }
        
        // Metal texture selector
        const metalSelect = document.getElementById('metal-texture');
        if (metalSelect) {
            metalSelect.addEventListener('change', (e) => {
                this.scene.updateTexture('metal', e.target.value);
            });
        }
        
        // Glow texture selector
        const glowSelect = document.getElementById('glow-texture');
        if (glowSelect) {
            glowSelect.addEventListener('change', (e) => {
                if (e.target.value === 'none') {
                    this.scene.currentTextures.glow = null;
                } else {
                    this.scene.updateTexture('glow', e.target.value);
                }
            });
        }
        
        // Window resize
        window.addEventListener('resize', () => {
            this.canvas.width = window.innerWidth;
            this.canvas.height = window.innerHeight;
            this.gl.viewport(0, 0, this.canvas.width, this.canvas.height);
        });
    }
    
    render() {
        // Clear canvas
        this.gl.clearColor(0.1, 0.1, 0.1, 1.0);
        this.gl.clear(this.gl.COLOR_BUFFER_BIT | this.gl.DEPTH_BUFFER_BIT);
        
        // Render scene objects
        const objects = this.scene.getObjects();
        objects.forEach(obj => {
            this.renderObject(obj);
        });
        
        // Continue render loop
        requestAnimationFrame(() => this.render());
    }
    
    renderObject(obj) {
        // This would contain the actual WebGL rendering code
        // For now, just log the object data
        console.log('Rendering object:', obj);
    }
}

// Initialize the application
document.addEventListener('DOMContentLoaded', () => {
    new GraphicsApp();
});
```

### 6. VS Code Workspace Configuration
```json
// File: .vscode/settings.json
{
    "files.associations": {
        "*.glsl": "glsl",
        "*.vert": "glsl",
        "*.frag": "glsl"
    },
    "emmet.includeLanguages": {
        "glsl": "html"
    },
    "glsl-canvas.presets": {
        "default": {
            "width": 800,
            "height": 600,
            "pixelRatio": 1
        }
    }
}
```

### 7. Package.json for Dependencies
```json
{
    "name": "3d-graphics-texture-project",
    "version": "1.0.0",
    "description": "3D Graphics project with texture management",
    "scripts": {
        "start": "npx http-server . -p 8080 -c-1",
        "dev": "npx live-server --port=8080"
    },
    "devDependencies": {
        "http-server": "^14.1.1",
        "live-server": "^1.2.2"
    }
}
```

## 🔍 Visual Studio Code Concepts
- **Asset Organization**: Structured folder hierarchy for textures
- **Texture Loading**: Asynchronous image loading with error handling
- **Texture Atlas**: Combining multiple textures into single image
- **Category Management**: Organizing textures by material type
- **Dynamic Loading**: Loading textures on demand
- **Error Handling**: Graceful fallbacks for missing textures

## 💡 Learning Points
- **VS Code** provides excellent file management for 3D projects
- **Asset organization** is crucial for maintainable projects
- **Asynchronous loading** prevents blocking the main thread
- **Texture atlases** can improve rendering performance
- **Error handling** ensures robust texture loading
- **Dynamic switching** allows real-time texture changes

## 🛠️ Setup Instructions
1. Create project folder structure
2. Add texture images to appropriate folders
3. Set up VS Code workspace configuration
4. Install development dependencies
5. Start local server for testing
6. Open in VS Code and begin development

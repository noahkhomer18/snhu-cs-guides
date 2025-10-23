# CS-330 Texture Application Guide

## 🎯 Purpose
Demonstrate how to apply textures from imported images onto 3D shapes, including UV mapping, texture coordinates, and material properties.

## 📝 Texture Application Examples

### 1. Basic Texture Application with WebGL

#### Vertex Shader with Texture Coordinates
```glsl
// File: shaders/vertex.glsl
attribute vec3 a_position;
attribute vec3 a_normal;
attribute vec2 a_texCoord;

uniform mat4 u_modelViewMatrix;
uniform mat4 u_projectionMatrix;
uniform mat4 u_normalMatrix;

varying vec2 v_texCoord;
varying vec3 v_normal;
varying vec3 v_position;

void main() {
    gl_Position = u_projectionMatrix * u_modelViewMatrix * vec4(a_position, 1.0);
    v_texCoord = a_texCoord;
    v_normal = mat3(u_normalMatrix) * a_normal;
    v_position = vec3(u_modelViewMatrix * vec4(a_position, 1.0));
}
```

#### Fragment Shader with Texture Sampling
```glsl
// File: shaders/fragment.glsl
precision mediump float;

uniform sampler2D u_texture;
uniform sampler2D u_normalMap;
uniform sampler2D u_specularMap;
uniform vec3 u_lightPosition;
uniform vec3 u_lightColor;
uniform vec3 u_ambientColor;
uniform float u_shininess;
uniform bool u_useNormalMap;
uniform bool u_useSpecularMap;

varying vec2 v_texCoord;
varying vec3 v_normal;
varying vec3 v_position;

void main() {
    // Sample base texture
    vec4 baseColor = texture2D(u_texture, v_texCoord);
    
    // Calculate lighting
    vec3 normal = normalize(v_normal);
    vec3 lightDirection = normalize(u_lightPosition - v_position);
    vec3 viewDirection = normalize(-v_position);
    
    // Apply normal mapping if available
    if (u_useNormalMap) {
        vec3 normalMap = texture2D(u_normalMap, v_texCoord).rgb * 2.0 - 1.0;
        normal = normalize(normal + normalMap);
    }
    
    // Ambient lighting
    vec3 ambient = u_ambientColor;
    
    // Diffuse lighting
    float diff = max(dot(normal, lightDirection), 0.0);
    vec3 diffuse = diff * u_lightColor;
    
    // Specular lighting
    vec3 reflectDirection = reflect(-lightDirection, normal);
    float spec = pow(max(dot(viewDirection, reflectDirection), 0.0), u_shininess);
    vec3 specular = spec * u_lightColor;
    
    // Apply specular map if available
    if (u_useSpecularMap) {
        float specularStrength = texture2D(u_specularMap, v_texCoord).r;
        specular *= specularStrength;
    }
    
    vec3 result = (ambient + diffuse + specular) * baseColor.rgb;
    gl_FragColor = vec4(result, baseColor.a);
}
```

### 2. Texture Coordinate Generation

#### Cube with UV Mapping
```javascript
// File: src/geometry/cube.js
class CubeGeometry {
    constructor(size = 1.0) {
        this.size = size;
        this.vertices = [];
        this.normals = [];
        this.texCoords = [];
        this.indices = [];
        
        this.generateGeometry();
    }
    
    generateGeometry() {
        const s = this.size / 2.0;
        
        // Define 8 vertices
        const vertices = [
            [-s, -s, -s], [s, -s, -s], [s, s, -s], [-s, s, -s],  // back
            [-s, -s, s], [s, -s, s], [s, s, s], [-s, s, s]       // front
        ];
        
        // Define faces with proper UV coordinates
        const faces = [
            // Back face
            { vertices: [0, 1, 2, 3], normal: [0, 0, -1], uv: [[0, 0], [1, 0], [1, 1], [0, 1]] },
            // Front face
            { vertices: [4, 7, 6, 5], normal: [0, 0, 1], uv: [[0, 0], [1, 0], [1, 1], [0, 1]] },
            // Left face
            { vertices: [0, 4, 7, 3], normal: [-1, 0, 0], uv: [[0, 0], [1, 0], [1, 1], [0, 1]] },
            // Right face
            { vertices: [1, 5, 6, 2], normal: [1, 0, 0], uv: [[0, 0], [1, 0], [1, 1], [0, 1]] },
            // Top face
            { vertices: [3, 2, 6, 7], normal: [0, 1, 0], uv: [[0, 0], [1, 0], [1, 1], [0, 1]] },
            // Bottom face
            { vertices: [0, 4, 5, 1], normal: [0, -1, 0], uv: [[0, 0], [1, 0], [1, 1], [0, 1]] }
        ];
        
        faces.forEach(face => {
            // Add vertices for this face
            face.vertices.forEach(vertexIndex => {
                const vertex = vertices[vertexIndex];
                this.vertices.push(...vertex);
                this.normals.push(...face.normal);
            });
            
            // Add texture coordinates
            this.texCoords.push(...face.uv.flat());
            
            // Add indices for two triangles
            const baseIndex = this.vertices.length / 3 - 4;
            this.indices.push(
                baseIndex, baseIndex + 1, baseIndex + 2,
                baseIndex, baseIndex + 2, baseIndex + 3
            );
        });
    }
    
    getVertices() { return this.vertices; }
    getNormals() { return this.normals; }
    getTexCoords() { return this.texCoords; }
    getIndices() { return this.indices; }
}
```

#### Sphere with UV Mapping
```javascript
// File: src/geometry/sphere.js
class SphereGeometry {
    constructor(radius = 1.0, segments = 32) {
        this.radius = radius;
        this.segments = segments;
        this.vertices = [];
        this.normals = [];
        this.texCoords = [];
        this.indices = [];
        
        this.generateGeometry();
    }
    
    generateGeometry() {
        const segments = this.segments;
        const radius = this.radius;
        
        // Generate vertices
        for (let i = 0; i <= segments; i++) {
            const lat = Math.PI * i / segments;
            for (let j = 0; j <= segments; j++) {
                const lon = 2 * Math.PI * j / segments;
                
                const x = radius * Math.sin(lat) * Math.cos(lon);
                const y = radius * Math.cos(lat);
                const z = radius * Math.sin(lat) * Math.sin(lon);
                
                this.vertices.push(x, y, z);
                this.normals.push(x / radius, y / radius, z / radius);
                
                // UV coordinates
                const u = j / segments;
                const v = i / segments;
                this.texCoords.push(u, v);
            }
        }
        
        // Generate indices
        for (let i = 0; i < segments; i++) {
            for (let j = 0; j < segments; j++) {
                const a = i * (segments + 1) + j;
                const b = a + segments + 1;
                
                this.indices.push(a, b, a + 1);
                this.indices.push(a + 1, b, b + 1);
            }
        }
    }
    
    getVertices() { return this.vertices; }
    getNormals() { return this.normals; }
    getTexCoords() { return this.texCoords; }
    getIndices() { return this.indices; }
}
```

### 3. Material System with Textures

#### Material Class
```javascript
// File: src/materials/material.js
class Material {
    constructor(options = {}) {
        this.diffuseTexture = options.diffuseTexture || null;
        this.normalTexture = options.normalTexture || null;
        this.specularTexture = options.specularTexture || null;
        this.emissiveTexture = options.emissiveTexture || null;
        
        this.diffuseColor = options.diffuseColor || [1, 1, 1];
        this.specularColor = options.specularColor || [1, 1, 1];
        this.emissiveColor = options.emissiveColor || [0, 0, 0];
        this.shininess = options.shininess || 32;
        this.opacity = options.opacity || 1.0;
        
        this.textureScale = options.textureScale || [1, 1];
        this.textureOffset = options.textureOffset || [0, 0];
    }
    
    // Apply material to shader
    applyToShader(gl, program) {
        // Set texture uniforms
        if (this.diffuseTexture) {
            gl.activeTexture(gl.TEXTURE0);
            gl.bindTexture(gl.TEXTURE_2D, this.diffuseTexture);
            gl.uniform1i(gl.getUniformLocation(program, 'u_texture'), 0);
        }
        
        if (this.normalTexture) {
            gl.activeTexture(gl.TEXTURE1);
            gl.bindTexture(gl.TEXTURE_2D, this.normalTexture);
            gl.uniform1i(gl.getUniformLocation(program, 'u_normalMap'), 1);
            gl.uniform1i(gl.getUniformLocation(program, 'u_useNormalMap'), true);
        } else {
            gl.uniform1i(gl.getUniformLocation(program, 'u_useNormalMap'), false);
        }
        
        if (this.specularTexture) {
            gl.activeTexture(gl.TEXTURE2);
            gl.bindTexture(gl.TEXTURE_2D, this.specularTexture);
            gl.uniform1i(gl.getUniformLocation(program, 'u_specularMap'), 2);
            gl.uniform1i(gl.getUniformLocation(program, 'u_useSpecularMap'), true);
        } else {
            gl.uniform1i(gl.getUniformLocation(program, 'u_useSpecularMap'), false);
        }
        
        // Set material properties
        gl.uniform3f(gl.getUniformLocation(program, 'u_diffuseColor'), 
                    this.diffuseColor[0], this.diffuseColor[1], this.diffuseColor[2]);
        gl.uniform3f(gl.getUniformLocation(program, 'u_specularColor'), 
                    this.specularColor[0], this.specularColor[1], this.specularColor[2]);
        gl.uniform1f(gl.getUniformLocation(program, 'u_shininess'), this.shininess);
        gl.uniform1f(gl.getUniformLocation(program, 'u_opacity'), this.opacity);
        
        // Set texture transformation
        gl.uniform2f(gl.getUniformLocation(program, 'u_textureScale'), 
                    this.textureScale[0], this.textureScale[1]);
        gl.uniform2f(gl.getUniformLocation(program, 'u_textureOffset'), 
                    this.textureOffset[0], this.textureOffset[1]);
    }
}
```

#### Predefined Materials
```javascript
// File: src/materials/predefined.js
class PredefinedMaterials {
    static createWoodMaterial(textureLoader) {
        return new Material({
            diffuseTexture: textureLoader.getTexture('oak_wood.jpg', 'wood'),
            normalTexture: textureLoader.getTexture('oak_wood_normal.jpg', 'wood'),
            specularTexture: textureLoader.getTexture('oak_wood_specular.jpg', 'wood'),
            diffuseColor: [0.8, 0.6, 0.4],
            specularColor: [0.2, 0.1, 0.1],
            shininess: 16,
            textureScale: [2, 2]
        });
    }
    
    static createMetalMaterial(textureLoader) {
        return new Material({
            diffuseTexture: textureLoader.getTexture('steel_brushed.jpg', 'metal'),
            normalTexture: textureLoader.getTexture('steel_brushed_normal.jpg', 'metal'),
            specularTexture: textureLoader.getTexture('steel_brushed_specular.jpg', 'metal'),
            diffuseColor: [0.7, 0.7, 0.8],
            specularColor: [0.9, 0.9, 0.9],
            shininess: 128,
            textureScale: [1, 1]
        });
    }
    
    static createGlassMaterial(textureLoader) {
        return new Material({
            diffuseTexture: textureLoader.getTexture('clear_glass.jpg', 'glass'),
            normalTexture: textureLoader.getTexture('clear_glass_normal.jpg', 'glass'),
            diffuseColor: [0.9, 0.9, 1.0],
            specularColor: [1.0, 1.0, 1.0],
            shininess: 256,
            opacity: 0.7,
            textureScale: [1, 1]
        });
    }
    
    static createGlowMaterial(textureLoader) {
        return new Material({
            diffuseTexture: textureLoader.getTexture('neon_blue.jpg', 'glow'),
            emissiveTexture: textureLoader.getTexture('neon_blue.jpg', 'glow'),
            diffuseColor: [0.2, 0.4, 1.0],
            emissiveColor: [0.1, 0.2, 0.5],
            shininess: 64,
            textureScale: [1, 1]
        });
    }
}
```

### 4. Advanced Texture Techniques

#### Texture Blending
```javascript
// File: src/effects/textureBlending.js
class TextureBlending {
    constructor(gl, program) {
        this.gl = gl;
        this.program = program;
    }
    
    // Blend two textures based on a mask
    blendTextures(baseTexture, overlayTexture, maskTexture, blendMode = 'multiply') {
        const fragmentShader = `
            precision mediump float;
            
            uniform sampler2D u_baseTexture;
            uniform sampler2D u_overlayTexture;
            uniform sampler2D u_maskTexture;
            uniform float u_blendAmount;
            
            varying vec2 v_texCoord;
            
            void main() {
                vec4 base = texture2D(u_baseTexture, v_texCoord);
                vec4 overlay = texture2D(u_overlayTexture, v_texCoord);
                float mask = texture2D(u_maskTexture, v_texCoord).r;
                
                vec4 result;
                if (u_blendMode == 0) { // Multiply
                    result = base * overlay;
                } else if (u_blendMode == 1) { // Screen
                    result = 1.0 - (1.0 - base) * (1.0 - overlay);
                } else if (u_blendMode == 2) { // Overlay
                    result = base * (1.0 - overlay) + overlay * base;
                }
                
                gl_FragColor = mix(base, result, mask * u_blendAmount);
            }
        `;
        
        // Compile and use the blending shader
        // Implementation details...
    }
    
    // Create procedural texture
    createProceduralTexture(width, height, type) {
        const canvas = document.createElement('canvas');
        canvas.width = width;
        canvas.height = height;
        const ctx = canvas.getContext('2d');
        
        switch (type) {
            case 'noise':
                this.createNoiseTexture(ctx, width, height);
                break;
            case 'gradient':
                this.createGradientTexture(ctx, width, height);
                break;
            case 'checker':
                this.createCheckerTexture(ctx, width, height);
                break;
        }
        
        return this.canvasToTexture(canvas);
    }
    
    createNoiseTexture(ctx, width, height) {
        const imageData = ctx.createImageData(width, height);
        const data = imageData.data;
        
        for (let i = 0; i < data.length; i += 4) {
            const noise = Math.random();
            data[i] = noise * 255;     // R
            data[i + 1] = noise * 255;  // G
            data[i + 2] = noise * 255; // B
            data[i + 3] = 255;         // A
        }
        
        ctx.putImageData(imageData, 0, 0);
    }
    
    createGradientTexture(ctx, width, height) {
        const gradient = ctx.createLinearGradient(0, 0, width, height);
        gradient.addColorStop(0, '#ff0000');
        gradient.addColorStop(0.5, '#00ff00');
        gradient.addColorStop(1, '#0000ff');
        
        ctx.fillStyle = gradient;
        ctx.fillRect(0, 0, width, height);
    }
    
    createCheckerTexture(ctx, width, height) {
        const tileSize = 32;
        const tilesX = Math.ceil(width / tileSize);
        const tilesY = Math.ceil(height / tileSize);
        
        for (let x = 0; x < tilesX; x++) {
            for (let y = 0; y < tilesY; y++) {
                ctx.fillStyle = (x + y) % 2 === 0 ? '#ffffff' : '#000000';
                ctx.fillRect(x * tileSize, y * tileSize, tileSize, tileSize);
            }
        }
    }
    
    canvasToTexture(canvas) {
        const texture = this.gl.createTexture();
        this.gl.bindTexture(this.gl.TEXTURE_2D, texture);
        this.gl.texImage2D(this.gl.TEXTURE_2D, 0, this.gl.RGBA, this.gl.RGBA, this.gl.UNSIGNED_BYTE, canvas);
        
        this.gl.texParameteri(this.gl.TEXTURE_2D, this.gl.TEXTURE_WRAP_S, this.gl.REPEAT);
        this.gl.texParameteri(this.gl.TEXTURE_2D, this.gl.TEXTURE_WRAP_T, this.gl.REPEAT);
        this.gl.texParameteri(this.gl.TEXTURE_2D, this.gl.TEXTURE_MIN_FILTER, this.gl.LINEAR);
        this.gl.texParameteri(this.gl.TEXTURE_2D, this.gl.TEXTURE_MAG_FILTER, this.gl.LINEAR);
        
        return texture;
    }
}
```

### 5. Texture Animation and Effects

#### Animated Texture Coordinates
```javascript
// File: src/effects/textureAnimation.js
class TextureAnimation {
    constructor(gl, program) {
        this.gl = gl;
        this.program = program;
        this.time = 0;
    }
    
    update(deltaTime) {
        this.time += deltaTime;
    }
    
    // Animate UV coordinates
    animateUV(geometry, speed = 1.0, direction = [1, 0]) {
        const texCoords = geometry.getTexCoords();
        const animatedCoords = [];
        
        for (let i = 0; i < texCoords.length; i += 2) {
            const u = texCoords[i] + this.time * speed * direction[0];
            const v = texCoords[i + 1] + this.time * speed * direction[1];
            animatedCoords.push(u, v);
        }
        
        return animatedCoords;
    }
    
    // Create scrolling texture effect
    createScrollingTexture(texture, speed, direction) {
        const fragmentShader = `
            precision mediump float;
            
            uniform sampler2D u_texture;
            uniform float u_time;
            uniform vec2 u_scrollSpeed;
            
            varying vec2 v_texCoord;
            
            void main() {
                vec2 scrolledCoord = v_texCoord + u_time * u_scrollSpeed;
                gl_FragColor = texture2D(u_texture, scrolledCoord);
            }
        `;
        
        // Set uniforms
        this.gl.uniform1f(this.gl.getUniformLocation(this.program, 'u_time'), this.time);
        this.gl.uniform2f(this.gl.getUniformLocation(this.program, 'u_scrollSpeed'), 
                          speed * direction[0], speed * direction[1]);
    }
}
```

### 6. Performance Optimization

#### Texture Compression and Mipmaps
```javascript
// File: src/optimization/textureOptimization.js
class TextureOptimization {
    constructor(gl) {
        this.gl = gl;
    }
    
    // Generate mipmaps for better performance
    generateMipmaps(texture) {
        this.gl.bindTexture(this.gl.TEXTURE_2D, texture);
        this.gl.generateMipmap(this.gl.TEXTURE_2D);
        
        // Set mipmap filtering
        this.gl.texParameteri(this.gl.TEXTURE_2D, this.gl.TEXTURE_MIN_FILTER, this.gl.LINEAR_MIPMAP_LINEAR);
        this.gl.texParameteri(this.gl.TEXTURE_2D, this.gl.TEXTURE_MAG_FILTER, this.gl.LINEAR);
    }
    
    // Compress texture for memory efficiency
    compressTexture(image, quality = 0.8) {
        const canvas = document.createElement('canvas');
        canvas.width = image.width;
        canvas.height = image.height;
        const ctx = canvas.getContext('2d');
        
        ctx.drawImage(image, 0, 0);
        
        // Convert to compressed format
        return canvas.toDataURL('image/jpeg', quality);
    }
    
    // Create texture atlas for batching
    createTextureAtlas(textures, atlasSize = 1024) {
        const canvas = document.createElement('canvas');
        canvas.width = atlasSize;
        canvas.height = atlasSize;
        const ctx = canvas.getContext('2d');
        
        const atlasData = {};
        const tileSize = Math.floor(atlasSize / Math.ceil(Math.sqrt(textures.length)));
        
        textures.forEach((texture, index) => {
            const x = (index % Math.ceil(Math.sqrt(textures.length))) * tileSize;
            const y = Math.floor(index / Math.ceil(Math.sqrt(textures.length))) * tileSize;
            
            ctx.drawImage(texture, x, y, tileSize, tileSize);
            
            atlasData[texture.src] = {
                x: x / atlasSize,
                y: y / atlasSize,
                width: tileSize / atlasSize,
                height: tileSize / atlasSize
            };
        });
        
        return { canvas, atlasData };
    }
}
```

## 🔍 Texture Application Concepts
- **UV Mapping**: 2D texture coordinates on 3D surfaces
- **Material Properties**: Diffuse, specular, normal, and emissive textures
- **Texture Blending**: Combining multiple textures
- **Animation**: Moving texture coordinates over time
- **Optimization**: Mipmaps, compression, and texture atlases
- **Procedural Generation**: Creating textures programmatically

## 💡 Learning Points
- **UV coordinates** map 2D textures to 3D geometry
- **Multiple textures** can create complex materials
- **Animation** adds life to static textures
- **Optimization** is crucial for performance
- **Procedural textures** offer infinite variety
- **Blending modes** create unique visual effects

## 🛠️ Implementation Tips
1. **Start simple** with basic diffuse textures
2. **Add normal maps** for surface detail
3. **Use specular maps** for realistic reflections
4. **Optimize texture sizes** for your target resolution
5. **Test on different devices** for performance
6. **Consider texture compression** for web deployment

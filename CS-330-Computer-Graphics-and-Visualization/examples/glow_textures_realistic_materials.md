# CS-330 Glow Textures and Realistic Materials

## 🎯 Purpose
Demonstrate advanced texture techniques including glow effects, emissive materials, and realistic material properties for creating visually stunning 3D graphics.

## 📝 Glow Textures and Realistic Materials Examples

### 1. Glow Effect Implementation

#### Glow Shader System
```glsl
// File: shaders/glow_vertex.glsl
attribute vec3 a_position;
attribute vec3 a_normal;
attribute vec2 a_texCoord;

uniform mat4 u_modelViewMatrix;
uniform mat4 u_projectionMatrix;
uniform mat4 u_normalMatrix;

varying vec3 v_normal;
varying vec3 v_position;
varying vec2 v_texCoord;

void main() {
    gl_Position = u_projectionMatrix * u_modelViewMatrix * vec4(a_position, 1.0);
    v_normal = mat3(u_normalMatrix) * a_normal;
    v_position = vec3(u_modelViewMatrix * vec4(a_position, 1.0));
    v_texCoord = a_texCoord;
}
```

```glsl
// File: shaders/glow_fragment.glsl
precision mediump float;

uniform sampler2D u_diffuseTexture;
uniform sampler2D u_emissiveTexture;
uniform sampler2D u_glowMask;
uniform vec3 u_glowColor;
uniform float u_glowIntensity;
uniform float u_glowRadius;
uniform vec3 u_cameraPosition;

varying vec3 v_normal;
varying vec3 v_position;
varying vec2 v_texCoord;

void main() {
    // Sample base texture
    vec4 diffuseColor = texture2D(u_diffuseTexture, v_texCoord);
    
    // Sample emissive texture
    vec4 emissiveColor = texture2D(u_emissiveTexture, v_texCoord);
    
    // Sample glow mask
    float glowMask = texture2D(u_glowMask, v_texCoord).r;
    
    // Calculate glow effect
    vec3 glow = u_glowColor * u_glowIntensity * glowMask;
    
    // Add emissive contribution
    vec3 finalEmissive = emissiveColor.rgb + glow;
    
    // Calculate distance-based glow falloff
    float distance = length(v_position - u_cameraPosition);
    float glowFalloff = 1.0 / (1.0 + distance * distance / (u_glowRadius * u_glowRadius));
    
    // Apply glow falloff
    finalEmissive *= glowFalloff;
    
    // Combine with diffuse color
    vec3 finalColor = diffuseColor.rgb + finalEmissive;
    
    gl_FragColor = vec4(finalColor, diffuseColor.a);
}
```

#### Glow Material Class
```javascript
// File: src/materials/glowMaterial.js
class GlowMaterial extends Material {
    constructor(options = {}) {
        super(options);
        
        this.glowColor = options.glowColor || [1, 1, 1];
        this.glowIntensity = options.glowIntensity || 1.0;
        this.glowRadius = options.glowRadius || 10.0;
        this.emissiveTexture = options.emissiveTexture || null;
        this.glowMask = options.glowMask || null;
        
        this.isGlowMaterial = true;
    }
    
    applyToShader(gl, program, camera) {
        // Call parent material application
        super.applyToShader(gl, program, camera);
        
        // Set glow-specific uniforms
        const glowColorLocation = gl.getUniformLocation(program, 'u_glowColor');
        const glowIntensityLocation = gl.getUniformLocation(program, 'u_glowIntensity');
        const glowRadiusLocation = gl.getUniformLocation(program, 'u_glowRadius');
        const cameraPositionLocation = gl.getUniformLocation(program, 'u_cameraPosition');
        
        gl.uniform3f(glowColorLocation, this.glowColor[0], this.glowColor[1], this.glowColor[2]);
        gl.uniform1f(glowIntensityLocation, this.glowIntensity);
        gl.uniform1f(glowRadiusLocation, this.glowRadius);
        gl.uniform3f(cameraPositionLocation, camera.position[0], camera.position[1], camera.position[2]);
        
        // Set emissive texture
        if (this.emissiveTexture) {
            gl.activeTexture(gl.TEXTURE3);
            gl.bindTexture(gl.TEXTURE_2D, this.emissiveTexture);
            gl.uniform1i(gl.getUniformLocation(program, 'u_emissiveTexture'), 3);
        }
        
        // Set glow mask texture
        if (this.glowMask) {
            gl.activeTexture(gl.TEXTURE4);
            gl.bindTexture(gl.TEXTURE_2D, this.glowMask);
            gl.uniform1i(gl.getUniformLocation(program, 'u_glowMask'), 4);
        }
    }
}
```

### 2. Realistic Material Properties

#### PBR (Physically Based Rendering) Material
```glsl
// File: shaders/pbr_fragment.glsl
precision mediump float;

uniform sampler2D u_albedoTexture;
uniform sampler2D u_normalTexture;
uniform sampler2D u_metallicTexture;
uniform sampler2D u_roughnessTexture;
uniform sampler2D u_aoTexture;
uniform sampler2D u_emissiveTexture;

uniform vec3 u_albedoColor;
uniform float u_metallic;
uniform float u_roughness;
uniform float u_ao;
uniform vec3 u_emissiveColor;

uniform vec3 u_lightPosition;
uniform vec3 u_lightColor;
uniform vec3 u_cameraPosition;

varying vec3 v_normal;
varying vec3 v_position;
varying vec2 v_texCoord;

// PBR functions
vec3 fresnelSchlick(float cosTheta, vec3 F0) {
    return F0 + (1.0 - F0) * pow(1.0 - cosTheta, 5.0);
}

float DistributionGGX(vec3 N, vec3 H, float roughness) {
    float a = roughness * roughness;
    float a2 = a * a;
    float NdotH = max(dot(N, H), 0.0);
    float NdotH2 = NdotH * NdotH;
    
    float num = a2;
    float denom = (NdotH2 * (a2 - 1.0) + 1.0);
    denom = 3.14159265359 * denom * denom;
    
    return num / denom;
}

float GeometrySchlickGGX(float NdotV, float roughness) {
    float r = (roughness + 1.0);
    float k = (r * r) / 8.0;
    
    float num = NdotV;
    float denom = NdotV * (1.0 - k) + k;
    
    return num / denom;
}

float GeometrySmith(vec3 N, vec3 V, vec3 L, float roughness) {
    float NdotV = max(dot(N, V), 0.0);
    float NdotL = max(dot(N, L), 0.0);
    float ggx2 = GeometrySchlickGGX(NdotV, roughness);
    float ggx1 = GeometrySchlickGGX(NdotL, roughness);
    
    return ggx1 * ggx2;
}

void main() {
    // Sample textures
    vec3 albedo = texture2D(u_albedoTexture, v_texCoord).rgb * u_albedoColor;
    vec3 normal = texture2D(u_normalTexture, v_texCoord).rgb * 2.0 - 1.0;
    float metallic = texture2D(u_metallicTexture, v_texCoord).r * u_metallic;
    float roughness = texture2D(u_roughnessTexture, v_texCoord).r * u_roughness;
    float ao = texture2D(u_aoTexture, v_texCoord).r * u_ao;
    vec3 emissive = texture2D(u_emissiveTexture, v_texCoord).rgb * u_emissiveColor;
    
    // Normalize vectors
    vec3 N = normalize(v_normal + normal);
    vec3 V = normalize(u_cameraPosition - v_position);
    vec3 L = normalize(u_lightPosition - v_position);
    vec3 H = normalize(V + L);
    
    // Calculate lighting
    float NdotL = max(dot(N, L), 0.0);
    float NdotV = max(dot(N, V), 0.0);
    
    // Fresnel
    vec3 F0 = mix(vec3(0.04), albedo, metallic);
    vec3 F = fresnelSchlick(max(dot(H, V), 0.0), F0);
    
    // Normal distribution
    float D = DistributionGGX(N, H, roughness);
    
    // Geometry function
    float G = GeometrySmith(N, V, L, roughness);
    
    // Cook-Torrance BRDF
    vec3 numerator = D * G * F;
    float denominator = 4.0 * NdotV * NdotL + 0.0001;
    vec3 specular = numerator / denominator;
    
    // Energy conservation
    vec3 kS = F;
    vec3 kD = vec3(1.0) - kS;
    kD *= 1.0 - metallic;
    
    // Final color
    vec3 Lo = (kD * albedo / 3.14159265359 + specular) * u_lightColor * NdotL;
    vec3 ambient = vec3(0.03) * albedo * ao;
    
    vec3 color = ambient + Lo + emissive;
    
    gl_FragColor = vec4(color, 1.0);
}
```

#### PBR Material Class
```javascript
// File: src/materials/pbrMaterial.js
class PBRMaterial extends Material {
    constructor(options = {}) {
        super(options);
        
        this.albedoTexture = options.albedoTexture || null;
        this.normalTexture = options.normalTexture || null;
        this.metallicTexture = options.metallicTexture || null;
        this.roughnessTexture = options.roughnessTexture || null;
        this.aoTexture = options.aoTexture || null;
        this.emissiveTexture = options.emissiveTexture || null;
        
        this.albedoColor = options.albedoColor || [1, 1, 1];
        this.metallic = options.metallic || 0.0;
        this.roughness = options.roughness || 0.5;
        this.ao = options.ao || 1.0;
        this.emissiveColor = options.emissiveColor || [0, 0, 0];
        
        this.isPBRMaterial = true;
    }
    
    applyToShader(gl, program, camera, lights) {
        // Set texture uniforms
        if (this.albedoTexture) {
            gl.activeTexture(gl.TEXTURE0);
            gl.bindTexture(gl.TEXTURE_2D, this.albedoTexture);
            gl.uniform1i(gl.getUniformLocation(program, 'u_albedoTexture'), 0);
        }
        
        if (this.normalTexture) {
            gl.activeTexture(gl.TEXTURE1);
            gl.bindTexture(gl.TEXTURE_2D, this.normalTexture);
            gl.uniform1i(gl.getUniformLocation(program, 'u_normalTexture'), 1);
        }
        
        if (this.metallicTexture) {
            gl.activeTexture(gl.TEXTURE2);
            gl.bindTexture(gl.TEXTURE_2D, this.metallicTexture);
            gl.uniform1i(gl.getUniformLocation(program, 'u_metallicTexture'), 2);
        }
        
        if (this.roughnessTexture) {
            gl.activeTexture(gl.TEXTURE3);
            gl.bindTexture(gl.TEXTURE_2D, this.roughnessTexture);
            gl.uniform1i(gl.getUniformLocation(program, 'u_roughnessTexture'), 3);
        }
        
        if (this.aoTexture) {
            gl.activeTexture(gl.TEXTURE4);
            gl.bindTexture(gl.TEXTURE_2D, this.aoTexture);
            gl.uniform1i(gl.getUniformLocation(program, 'u_aoTexture'), 4);
        }
        
        if (this.emissiveTexture) {
            gl.activeTexture(gl.TEXTURE5);
            gl.bindTexture(gl.TEXTURE_2D, this.emissiveTexture);
            gl.uniform1i(gl.getUniformLocation(program, 'u_emissiveTexture'), 5);
        }
        
        // Set material properties
        gl.uniform3f(gl.getUniformLocation(program, 'u_albedoColor'), 
                    this.albedoColor[0], this.albedoColor[1], this.albedoColor[2]);
        gl.uniform1f(gl.getUniformLocation(program, 'u_metallic'), this.metallic);
        gl.uniform1f(gl.getUniformLocation(program, 'u_roughness'), this.roughness);
        gl.uniform1f(gl.getUniformLocation(program, 'u_ao'), this.ao);
        gl.uniform3f(gl.getUniformLocation(program, 'u_emissiveColor'), 
                    this.emissiveColor[0], this.emissiveColor[1], this.emissiveColor[2]);
        
        // Set camera position
        gl.uniform3f(gl.getUniformLocation(program, 'u_cameraPosition'), 
                    camera.position[0], camera.position[1], camera.position[2]);
        
        // Set light properties
        if (lights && lights.length > 0) {
            const light = lights[0];
            gl.uniform3f(gl.getUniformLocation(program, 'u_lightPosition'), 
                        light.position[0], light.position[1], light.position[2]);
            gl.uniform3f(gl.getUniformLocation(program, 'u_lightColor'), 
                        light.color[0], light.color[1], light.color[2]);
        }
    }
}
```

### 3. Glow Effect Examples

#### Neon Sign Material
```javascript
// File: src/materials/neonSignMaterial.js
class NeonSignMaterial extends GlowMaterial {
    constructor(options = {}) {
        super({
            glowColor: options.glowColor || [0, 1, 1], // Cyan
            glowIntensity: options.glowIntensity || 2.0,
            glowRadius: options.glowRadius || 15.0,
            emissiveTexture: options.emissiveTexture,
            glowMask: options.glowMask
        });
        
        this.neonColor = options.neonColor || [0, 1, 1];
        this.flickerIntensity = options.flickerIntensity || 0.1;
        this.flickerSpeed = options.flickerSpeed || 1.0;
    }
    
    applyToShader(gl, program, camera) {
        super.applyToShader(gl, program, camera);
        
        // Set neon-specific uniforms
        const neonColorLocation = gl.getUniformLocation(program, 'u_neonColor');
        const flickerIntensityLocation = gl.getUniformLocation(program, 'u_flickerIntensity');
        const flickerSpeedLocation = gl.getUniformLocation(program, 'u_flickerSpeed');
        const timeLocation = gl.getUniformLocation(program, 'u_time');
        
        gl.uniform3f(neonColorLocation, this.neonColor[0], this.neonColor[1], this.neonColor[2]);
        gl.uniform1f(flickerIntensityLocation, this.flickerIntensity);
        gl.uniform1f(flickerSpeedLocation, this.flickerSpeed);
        gl.uniform1f(timeLocation, Date.now() * 0.001);
    }
}
```

#### Holographic Material
```javascript
// File: src/materials/holographicMaterial.js
class HolographicMaterial extends GlowMaterial {
    constructor(options = {}) {
        super({
            glowColor: options.glowColor || [0, 1, 1],
            glowIntensity: options.glowIntensity || 1.5,
            glowRadius: options.glowRadius || 20.0
        });
        
        this.hologramColor = options.hologramColor || [0, 1, 1];
        this.scanlineSpeed = options.scanlineSpeed || 2.0;
        this.scanlineIntensity = options.scanlineIntensity || 0.5;
        this.flickerAmount = options.flickerAmount || 0.1;
    }
    
    applyToShader(gl, program, camera) {
        super.applyToShader(gl, program, camera);
        
        // Set holographic-specific uniforms
        const hologramColorLocation = gl.getUniformLocation(program, 'u_hologramColor');
        const scanlineSpeedLocation = gl.getUniformLocation(program, 'u_scanlineSpeed');
        const scanlineIntensityLocation = gl.getUniformLocation(program, 'u_scanlineIntensity');
        const flickerAmountLocation = gl.getUniformLocation(program, 'u_flickerAmount');
        const timeLocation = gl.getUniformLocation(program, 'u_time');
        
        gl.uniform3f(hologramColorLocation, this.hologramColor[0], this.hologramColor[1], this.hologramColor[2]);
        gl.uniform1f(scanlineSpeedLocation, this.scanlineSpeed);
        gl.uniform1f(scanlineIntensityLocation, this.scanlineIntensity);
        gl.uniform1f(flickerAmountLocation, this.flickerAmount);
        gl.uniform1f(timeLocation, Date.now() * 0.001);
    }
}
```

### 4. Realistic Material Examples

#### Metal Material
```javascript
// File: src/materials/metalMaterial.js
class MetalMaterial extends PBRMaterial {
    constructor(options = {}) {
        super({
            albedoColor: options.albedoColor || [0.7, 0.7, 0.8],
            metallic: options.metallic || 1.0,
            roughness: options.roughness || 0.1,
            ao: options.ao || 1.0
        });
        
        this.metalType = options.metalType || 'steel';
        this.oxidation = options.oxidation || 0.0;
        this.scratches = options.scratches || 0.0;
    }
    
    applyToShader(gl, program, camera, lights) {
        super.applyToShader(gl, program, camera, lights);
        
        // Set metal-specific uniforms
        const oxidationLocation = gl.getUniformLocation(program, 'u_oxidation');
        const scratchesLocation = gl.getUniformLocation(program, 'u_scratches');
        
        gl.uniform1f(oxidationLocation, this.oxidation);
        gl.uniform1f(scratchesLocation, this.scratches);
    }
}
```

#### Glass Material
```javascript
// File: src/materials/glassMaterial.js
class GlassMaterial extends PBRMaterial {
    constructor(options = {}) {
        super({
            albedoColor: options.albedoColor || [0.9, 0.9, 1.0],
            metallic: options.metallic || 0.0,
            roughness: options.roughness || 0.0,
            ao: options.ao || 1.0
        });
        
        this.refraction = options.refraction || 1.5;
        this.transparency = options.transparency || 0.8;
        this.fresnel = options.fresnel || 0.04;
    }
    
    applyToShader(gl, program, camera, lights) {
        super.applyToShader(gl, program, camera, lights);
        
        // Set glass-specific uniforms
        const refractionLocation = gl.getUniformLocation(program, 'u_refraction');
        const transparencyLocation = gl.getUniformLocation(program, 'u_transparency');
        const fresnelLocation = gl.getUniformLocation(program, 'u_fresnel');
        
        gl.uniform1f(refractionLocation, this.refraction);
        gl.uniform1f(transparencyLocation, this.transparency);
        gl.uniform1f(fresnelLocation, this.fresnel);
    }
}
```

#### Wood Material
```javascript
// File: src/materials/woodMaterial.js
class WoodMaterial extends PBRMaterial {
    constructor(options = {}) {
        super({
            albedoColor: options.albedoColor || [0.8, 0.6, 0.4],
            metallic: options.metallic || 0.0,
            roughness: options.roughness || 0.8,
            ao: options.ao || 1.0
        });
        
        this.woodType = options.woodType || 'oak';
        this.grainIntensity = options.grainIntensity || 1.0;
        this.age = options.age || 0.0;
    }
    
    applyToShader(gl, program, camera, lights) {
        super.applyToShader(gl, program, camera, lights);
        
        // Set wood-specific uniforms
        const grainIntensityLocation = gl.getUniformLocation(program, 'u_grainIntensity');
        const ageLocation = gl.getUniformLocation(program, 'u_age');
        
        gl.uniform1f(grainIntensityLocation, this.grainIntensity);
        gl.uniform1f(ageLocation, this.age);
    }
}
```

### 5. Glow Effect Shaders

#### Neon Glow Fragment Shader
```glsl
// File: shaders/neon_glow_fragment.glsl
precision mediump float;

uniform sampler2D u_diffuseTexture;
uniform sampler2D u_emissiveTexture;
uniform sampler2D u_glowMask;
uniform vec3 u_glowColor;
uniform vec3 u_neonColor;
uniform float u_glowIntensity;
uniform float u_flickerIntensity;
uniform float u_flickerSpeed;
uniform float u_time;

varying vec3 v_normal;
varying vec3 v_position;
varying vec2 v_texCoord;

void main() {
    // Sample textures
    vec4 diffuseColor = texture2D(u_diffuseTexture, v_texCoord);
    vec4 emissiveColor = texture2D(u_emissiveTexture, v_texCoord);
    float glowMask = texture2D(u_glowMask, v_texCoord).r;
    
    // Calculate flicker effect
    float flicker = 1.0 + sin(u_time * u_flickerSpeed) * u_flickerIntensity;
    
    // Calculate glow effect
    vec3 glow = u_glowColor * u_glowIntensity * glowMask * flicker;
    
    // Add neon color
    vec3 neon = u_neonColor * glowMask * flicker;
    
    // Combine colors
    vec3 finalColor = diffuseColor.rgb + glow + neon;
    
    gl_FragColor = vec4(finalColor, diffuseColor.a);
}
```

#### Holographic Glow Fragment Shader
```glsl
// File: shaders/holographic_glow_fragment.glsl
precision mediump float;

uniform sampler2D u_diffuseTexture;
uniform sampler2D u_emissiveTexture;
uniform vec3 u_glowColor;
uniform vec3 u_hologramColor;
uniform float u_glowIntensity;
uniform float u_scanlineSpeed;
uniform float u_scanlineIntensity;
uniform float u_flickerAmount;
uniform float u_time;

varying vec3 v_normal;
varying vec3 v_position;
varying vec2 v_texCoord;

void main() {
    // Sample textures
    vec4 diffuseColor = texture2D(u_diffuseTexture, v_texCoord);
    vec4 emissiveColor = texture2D(u_emissiveTexture, v_texCoord);
    
    // Calculate scanline effect
    float scanline = sin(v_texCoord.y * 100.0 + u_time * u_scanlineSpeed) * u_scanlineIntensity;
    
    // Calculate flicker effect
    float flicker = 1.0 + sin(u_time * 10.0) * u_flickerAmount;
    
    // Calculate glow effect
    vec3 glow = u_glowColor * u_glowIntensity * flicker;
    
    // Add holographic color
    vec3 hologram = u_hologramColor * scanline * flicker;
    
    // Combine colors
    vec3 finalColor = diffuseColor.rgb + glow + hologram;
    
    gl_FragColor = vec4(finalColor, diffuseColor.a);
}
```

### 6. Material Factory

#### Material Factory Class
```javascript
// File: src/materials/materialFactory.js
class MaterialFactory {
    constructor(textureLoader) {
        this.textureLoader = textureLoader;
    }
    
    async createMaterial(type, options = {}) {
        switch (type.toLowerCase()) {
            case 'neon':
                return await this.createNeonMaterial(options);
            case 'holographic':
                return await this.createHolographicMaterial(options);
            case 'metal':
                return await this.createMetalMaterial(options);
            case 'glass':
                return await this.createGlassMaterial(options);
            case 'wood':
                return await this.createWoodMaterial(options);
            case 'plastic':
                return await this.createPlasticMaterial(options);
            case 'ceramic':
                return await this.createCeramicMaterial(options);
            default:
                return await this.createDefaultMaterial(options);
        }
    }
    
    async createNeonMaterial(options) {
        const emissiveTexture = await this.textureLoader.loadTexture('neon_emissive.jpg', 'glow');
        const glowMask = await this.textureLoader.loadTexture('neon_mask.jpg', 'glow');
        
        return new NeonSignMaterial({
            glowColor: options.glowColor || [0, 1, 1],
            glowIntensity: options.glowIntensity || 2.0,
            glowRadius: options.glowRadius || 15.0,
            emissiveTexture: emissiveTexture,
            glowMask: glowMask,
            neonColor: options.neonColor || [0, 1, 1],
            flickerIntensity: options.flickerIntensity || 0.1,
            flickerSpeed: options.flickerSpeed || 1.0
        });
    }
    
    async createHolographicMaterial(options) {
        const emissiveTexture = await this.textureLoader.loadTexture('hologram_emissive.jpg', 'glow');
        
        return new HolographicMaterial({
            glowColor: options.glowColor || [0, 1, 1],
            glowIntensity: options.glowIntensity || 1.5,
            glowRadius: options.glowRadius || 20.0,
            emissiveTexture: emissiveTexture,
            hologramColor: options.hologramColor || [0, 1, 1],
            scanlineSpeed: options.scanlineSpeed || 2.0,
            scanlineIntensity: options.scanlineIntensity || 0.5,
            flickerAmount: options.flickerAmount || 0.1
        });
    }
    
    async createMetalMaterial(options) {
        const albedoTexture = await this.textureLoader.loadTexture('metal_albedo.jpg', 'metal');
        const normalTexture = await this.textureLoader.loadTexture('metal_normal.jpg', 'metal');
        const metallicTexture = await this.textureLoader.loadTexture('metal_metallic.jpg', 'metal');
        const roughnessTexture = await this.textureLoader.loadTexture('metal_roughness.jpg', 'metal');
        const aoTexture = await this.textureLoader.loadTexture('metal_ao.jpg', 'metal');
        
        return new MetalMaterial({
            albedoTexture: albedoTexture,
            normalTexture: normalTexture,
            metallicTexture: metallicTexture,
            roughnessTexture: roughnessTexture,
            aoTexture: aoTexture,
            albedoColor: options.albedoColor || [0.7, 0.7, 0.8],
            metallic: options.metallic || 1.0,
            roughness: options.roughness || 0.1,
            ao: options.ao || 1.0,
            metalType: options.metalType || 'steel',
            oxidation: options.oxidation || 0.0,
            scratches: options.scratches || 0.0
        });
    }
    
    async createGlassMaterial(options) {
        const albedoTexture = await this.textureLoader.loadTexture('glass_albedo.jpg', 'glass');
        const normalTexture = await this.textureLoader.loadTexture('glass_normal.jpg', 'glass');
        const roughnessTexture = await this.textureLoader.loadTexture('glass_roughness.jpg', 'glass');
        
        return new GlassMaterial({
            albedoTexture: albedoTexture,
            normalTexture: normalTexture,
            roughnessTexture: roughnessTexture,
            albedoColor: options.albedoColor || [0.9, 0.9, 1.0],
            metallic: options.metallic || 0.0,
            roughness: options.roughness || 0.0,
            ao: options.ao || 1.0,
            refraction: options.refraction || 1.5,
            transparency: options.transparency || 0.8,
            fresnel: options.fresnel || 0.04
        });
    }
    
    async createWoodMaterial(options) {
        const albedoTexture = await this.textureLoader.loadTexture('wood_albedo.jpg', 'wood');
        const normalTexture = await this.textureLoader.loadTexture('wood_normal.jpg', 'wood');
        const roughnessTexture = await this.textureLoader.loadTexture('wood_roughness.jpg', 'wood');
        const aoTexture = await this.textureLoader.loadTexture('wood_ao.jpg', 'wood');
        
        return new WoodMaterial({
            albedoTexture: albedoTexture,
            normalTexture: normalTexture,
            roughnessTexture: roughnessTexture,
            aoTexture: aoTexture,
            albedoColor: options.albedoColor || [0.8, 0.6, 0.4],
            metallic: options.metallic || 0.0,
            roughness: options.roughness || 0.8,
            ao: options.ao || 1.0,
            woodType: options.woodType || 'oak',
            grainIntensity: options.grainIntensity || 1.0,
            age: options.age || 0.0
        });
    }
    
    async createPlasticMaterial(options) {
        const albedoTexture = await this.textureLoader.loadTexture('plastic_albedo.jpg', 'plastic');
        const normalTexture = await this.textureLoader.loadTexture('plastic_normal.jpg', 'plastic');
        const roughnessTexture = await this.textureLoader.loadTexture('plastic_roughness.jpg', 'plastic');
        
        return new PBRMaterial({
            albedoTexture: albedoTexture,
            normalTexture: normalTexture,
            roughnessTexture: roughnessTexture,
            albedoColor: options.albedoColor || [0.8, 0.8, 0.8],
            metallic: options.metallic || 0.0,
            roughness: options.roughness || 0.4,
            ao: options.ao || 1.0
        });
    }
    
    async createCeramicMaterial(options) {
        const albedoTexture = await this.textureLoader.loadTexture('ceramic_albedo.jpg', 'ceramic');
        const normalTexture = await this.textureLoader.loadTexture('ceramic_normal.jpg', 'ceramic');
        const roughnessTexture = await this.textureLoader.loadTexture('ceramic_roughness.jpg', 'ceramic');
        
        return new PBRMaterial({
            albedoTexture: albedoTexture,
            normalTexture: normalTexture,
            roughnessTexture: roughnessTexture,
            albedoColor: options.albedoColor || [0.9, 0.9, 0.9],
            metallic: options.metallic || 0.0,
            roughness: options.roughness || 0.1,
            ao: options.ao || 1.0
        });
    }
    
    async createDefaultMaterial(options) {
        return new Material({
            diffuseColor: options.diffuseColor || [0.8, 0.8, 0.8],
            specularColor: options.specularColor || [0.2, 0.2, 0.2],
            shininess: options.shininess || 32
        });
    }
}
```

## 🔍 Glow and Realistic Material Concepts
- **Glow Effects**: Emissive materials that emit light
- **PBR Rendering**: Physically accurate material properties
- **Texture Mapping**: Multiple texture channels for realistic materials
- **Animation**: Time-based effects for dynamic materials
- **Performance**: Optimized rendering for complex materials
- **Artistic Control**: Creative control over material appearance

## 💡 Learning Points
- **Glow effects** add visual impact and atmosphere
- **PBR materials** create realistic appearances
- **Texture channels** provide detailed material control
- **Animation** brings materials to life
- **Performance optimization** is crucial for complex materials
- **Artistic vision** guides material creation

## 🛠️ Implementation Tips
1. **Start with basic materials** and add complexity gradually
2. **Use reference images** for realistic material creation
3. **Test on different devices** to ensure performance
4. **Experiment with parameters** to achieve desired effects
5. **Consider lighting** when designing materials
6. **Optimize texture sizes** for better performance

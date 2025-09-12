# CS-330 WebGL Basics

## 🎯 Purpose
Demonstrate WebGL programming fundamentals including shaders, buffers, and 3D rendering.

## 📝 WebGL Examples

### Basic WebGL Setup
```html
<!DOCTYPE html>
<html>
<head>
    <title>WebGL Basics</title>
    <style>
        body { margin: 0; padding: 20px; background: #f0f0f0; }
        canvas { border: 1px solid #ccc; background: white; }
    </style>
</head>
<body>
    <canvas id="webgl-canvas" width="800" height="600"></canvas>
    <script>
        // WebGL context setup
        const canvas = document.getElementById('webgl-canvas');
        const gl = canvas.getContext('webgl') || canvas.getContext('experimental-webgl');
        
        if (!gl) {
            alert('WebGL not supported');
        }
        
        // Vertex shader source
        const vertexShaderSource = `
            attribute vec4 a_position;
            attribute vec4 a_color;
            uniform mat4 u_modelViewMatrix;
            uniform mat4 u_projectionMatrix;
            varying vec4 v_color;
            
            void main() {
                gl_Position = u_projectionMatrix * u_modelViewMatrix * a_position;
                v_color = a_color;
            }
        `;
        
        // Fragment shader source
        const fragmentShaderSource = `
            precision mediump float;
            varying vec4 v_color;
            
            void main() {
                gl_FragColor = v_color;
            }
        `;
        
        // Shader compilation
        function createShader(gl, type, source) {
            const shader = gl.createShader(type);
            gl.shaderSource(shader, source);
            gl.compileShader(shader);
            
            if (!gl.getShaderParameter(shader, gl.COMPILE_STATUS)) {
                console.error('Shader compilation error:', gl.getShaderInfoLog(shader));
                gl.deleteShader(shader);
                return null;
            }
            
            return shader;
        }
        
        // Program creation
        function createProgram(gl, vertexShader, fragmentShader) {
            const program = gl.createProgram();
            gl.attachShader(program, vertexShader);
            gl.attachShader(program, fragmentShader);
            gl.linkProgram(program);
            
            if (!gl.getProgramParameter(program, gl.LINK_STATUS)) {
                console.error('Program linking error:', gl.getProgramInfoLog(program));
                gl.deleteProgram(program);
                return null;
            }
            
            return program;
        }
        
        // Create shaders and program
        const vertexShader = createShader(gl, gl.VERTEX_SHADER, vertexShaderSource);
        const fragmentShader = createShader(gl, gl.FRAGMENT_SHADER, fragmentShaderSource);
        const program = createProgram(gl, vertexShader, fragmentShader);
        
        // Get attribute and uniform locations
        const positionAttributeLocation = gl.getAttribLocation(program, 'a_position');
        const colorAttributeLocation = gl.getAttribLocation(program, 'a_color');
        const modelViewMatrixLocation = gl.getUniformLocation(program, 'u_modelViewMatrix');
        const projectionMatrixLocation = gl.getUniformLocation(program, 'u_projectionMatrix');
        
        // Create vertex data for a triangle
        const positions = [
            // Triangle 1
            0.0, 0.5, 0.0,
            -0.5, -0.5, 0.0,
            0.5, -0.5, 0.0,
        ];
        
        const colors = [
            // Red, Green, Blue
            1.0, 0.0, 0.0, 1.0,
            0.0, 1.0, 0.0, 1.0,
            0.0, 0.0, 1.0, 1.0,
        ];
        
        // Create and bind position buffer
        const positionBuffer = gl.createBuffer();
        gl.bindBuffer(gl.ARRAY_BUFFER, positionBuffer);
        gl.bufferData(gl.ARRAY_BUFFER, new Float32Array(positions), gl.STATIC_DRAW);
        
        // Create and bind color buffer
        const colorBuffer = gl.createBuffer();
        gl.bindBuffer(gl.ARRAY_BUFFER, colorBuffer);
        gl.bufferData(gl.ARRAY_BUFFER, new Float32Array(colors), gl.STATIC_DRAW);
        
        // Matrix functions
        function createPerspectiveMatrix(fov, aspect, near, far) {
            const f = 1.0 / Math.tan(fov / 2);
            const rangeInv = 1 / (near - far);
            
            return [
                f / aspect, 0, 0, 0,
                0, f, 0, 0,
                0, 0, (near + far) * rangeInv, -1,
                0, 0, near * far * rangeInv * 2, 0
            ];
        }
        
        function createIdentityMatrix() {
            return [
                1, 0, 0, 0,
                0, 1, 0, 0,
                0, 0, 1, 0,
                0, 0, 0, 1
            ];
        }
        
        function createTranslationMatrix(x, y, z) {
            return [
                1, 0, 0, 0,
                0, 1, 0, 0,
                0, 0, 1, 0,
                x, y, z, 1
            ];
        }
        
        function createRotationMatrix(angle, axis) {
            const c = Math.cos(angle);
            const s = Math.sin(angle);
            
            if (axis === 'x') {
                return [
                    1, 0, 0, 0,
                    0, c, s, 0,
                    0, -s, c, 0,
                    0, 0, 0, 1
                ];
            } else if (axis === 'y') {
                return [
                    c, 0, -s, 0,
                    0, 1, 0, 0,
                    s, 0, c, 0,
                    0, 0, 0, 1
                ];
            } else if (axis === 'z') {
                return [
                    c, s, 0, 0,
                    -s, c, 0, 0,
                    0, 0, 1, 0,
                    0, 0, 0, 1
                ];
            }
        }
        
        function multiplyMatrices(a, b) {
            const result = new Array(16);
            for (let i = 0; i < 4; i++) {
                for (let j = 0; j < 4; j++) {
                    result[i * 4 + j] = 
                        a[i * 4 + 0] * b[0 * 4 + j] +
                        a[i * 4 + 1] * b[1 * 4 + j] +
                        a[i * 4 + 2] * b[2 * 4 + j] +
                        a[i * 4 + 3] * b[3 * 4 + j];
                }
            }
            return result;
        }
        
        // Animation variables
        let rotationAngle = 0;
        
        // Render function
        function render() {
            // Clear canvas
            gl.clearColor(0.0, 0.0, 0.0, 1.0);
            gl.clear(gl.COLOR_BUFFER_BIT);
            
            // Use shader program
            gl.useProgram(program);
            
            // Set up position attribute
            gl.bindBuffer(gl.ARRAY_BUFFER, positionBuffer);
            gl.enableVertexAttribArray(positionAttributeLocation);
            gl.vertexAttribPointer(positionAttributeLocation, 3, gl.FLOAT, false, 0, 0);
            
            // Set up color attribute
            gl.bindBuffer(gl.ARRAY_BUFFER, colorBuffer);
            gl.enableVertexAttribArray(colorAttributeLocation);
            gl.vertexAttribPointer(colorAttributeLocation, 4, gl.FLOAT, false, 0, 0);
            
            // Create matrices
            const projectionMatrix = createPerspectiveMatrix(
                Math.PI / 4, 
                canvas.width / canvas.height, 
                0.1, 
                100
            );
            
            const modelMatrix = multiplyMatrices(
                createTranslationMatrix(0, 0, -3),
                multiplyMatrices(
                    createRotationMatrix(rotationAngle, 'y'),
                    createRotationMatrix(rotationAngle * 0.5, 'x')
                )
            );
            
            // Set uniforms
            gl.uniformMatrix4fv(projectionMatrixLocation, false, projectionMatrix);
            gl.uniformMatrix4fv(modelViewMatrixLocation, false, modelMatrix);
            
            // Draw triangle
            gl.drawArrays(gl.TRIANGLES, 0, 3);
            
            // Update rotation
            rotationAngle += 0.02;
            
            // Request next frame
            requestAnimationFrame(render);
        }
        
        // Start rendering
        render();
    </script>
</body>
</html>
```

### 3D Cube with WebGL
```html
<!DOCTYPE html>
<html>
<head>
    <title>WebGL 3D Cube</title>
    <style>
        body { margin: 0; padding: 20px; background: #f0f0f0; }
        canvas { border: 1px solid #ccc; background: white; }
    </style>
</head>
<body>
    <canvas id="cube-canvas" width="800" height="600"></canvas>
    <script>
        const canvas = document.getElementById('cube-canvas');
        const gl = canvas.getContext('webgl') || canvas.getContext('experimental-webgl');
        
        // Enhanced vertex shader with lighting
        const vertexShaderSource = `
            attribute vec4 a_position;
            attribute vec3 a_normal;
            uniform mat4 u_modelViewMatrix;
            uniform mat4 u_projectionMatrix;
            uniform mat4 u_normalMatrix;
            varying vec3 v_normal;
            varying vec3 v_position;
            
            void main() {
                gl_Position = u_projectionMatrix * u_modelViewMatrix * a_position;
                v_normal = mat3(u_normalMatrix) * a_normal;
                v_position = vec3(u_modelViewMatrix * a_position);
            }
        `;
        
        // Fragment shader with Phong lighting
        const fragmentShaderSource = `
            precision mediump float;
            varying vec3 v_normal;
            varying vec3 v_position;
            uniform vec3 u_lightPosition;
            uniform vec3 u_lightColor;
            uniform vec3 u_ambientColor;
            uniform vec3 u_diffuseColor;
            uniform vec3 u_specularColor;
            uniform float u_shininess;
            
            void main() {
                vec3 normal = normalize(v_normal);
                vec3 lightDirection = normalize(u_lightPosition - v_position);
                vec3 viewDirection = normalize(-v_position);
                vec3 reflectDirection = reflect(-lightDirection, normal);
                
                // Ambient
                vec3 ambient = u_ambientColor;
                
                // Diffuse
                float diff = max(dot(normal, lightDirection), 0.0);
                vec3 diffuse = diff * u_diffuseColor * u_lightColor;
                
                // Specular
                float spec = pow(max(dot(viewDirection, reflectDirection), 0.0), u_shininess);
                vec3 specular = spec * u_specularColor * u_lightColor;
                
                vec3 result = ambient + diffuse + specular;
                gl_FragColor = vec4(result, 1.0);
            }
        `;
        
        // Shader compilation functions (same as before)
        function createShader(gl, type, source) {
            const shader = gl.createShader(type);
            gl.shaderSource(shader, source);
            gl.compileShader(shader);
            
            if (!gl.getShaderParameter(shader, gl.COMPILE_STATUS)) {
                console.error('Shader compilation error:', gl.getShaderInfoLog(shader));
                gl.deleteShader(shader);
                return null;
            }
            
            return shader;
        }
        
        function createProgram(gl, vertexShader, fragmentShader) {
            const program = gl.createProgram();
            gl.attachShader(program, vertexShader);
            gl.attachShader(program, fragmentShader);
            gl.linkProgram(program);
            
            if (!gl.getProgramParameter(program, gl.LINK_STATUS)) {
                console.error('Program linking error:', gl.getProgramInfoLog(program));
                gl.deleteProgram(program);
                return null;
            }
            
            return program;
        }
        
        // Create shaders and program
        const vertexShader = createShader(gl, gl.VERTEX_SHADER, vertexShaderSource);
        const fragmentShader = createShader(gl, gl.FRAGMENT_SHADER, fragmentShaderSource);
        const program = createProgram(gl, vertexShader, fragmentShader);
        
        // Get attribute and uniform locations
        const positionAttributeLocation = gl.getAttribLocation(program, 'a_position');
        const normalAttributeLocation = gl.getAttribLocation(program, 'a_normal');
        const modelViewMatrixLocation = gl.getUniformLocation(program, 'u_modelViewMatrix');
        const projectionMatrixLocation = gl.getUniformLocation(program, 'u_projectionMatrix');
        const normalMatrixLocation = gl.getUniformLocation(program, 'u_normalMatrix');
        const lightPositionLocation = gl.getUniformLocation(program, 'u_lightPosition');
        const lightColorLocation = gl.getUniformLocation(program, 'u_lightColor');
        const ambientColorLocation = gl.getUniformLocation(program, 'u_ambientColor');
        const diffuseColorLocation = gl.getUniformLocation(program, 'u_diffuseColor');
        const specularColorLocation = gl.getUniformLocation(program, 'u_specularColor');
        const shininessLocation = gl.getUniformLocation(program, 'u_shininess');
        
        // Cube vertices (8 vertices)
        const positions = [
            // Front face
            -1, -1,  1,
             1, -1,  1,
             1,  1,  1,
            -1,  1,  1,
            // Back face
            -1, -1, -1,
            -1,  1, -1,
             1,  1, -1,
             1, -1, -1,
            // Top face
            -1,  1, -1,
            -1,  1,  1,
             1,  1,  1,
             1,  1, -1,
            // Bottom face
            -1, -1, -1,
             1, -1, -1,
             1, -1,  1,
            -1, -1,  1,
            // Right face
             1, -1, -1,
             1,  1, -1,
             1,  1,  1,
             1, -1,  1,
            // Left face
            -1, -1, -1,
            -1, -1,  1,
            -1,  1,  1,
            -1,  1, -1
        ];
        
        // Cube normals
        const normals = [
            // Front face
             0,  0,  1,
             0,  0,  1,
             0,  0,  1,
             0,  0,  1,
            // Back face
             0,  0, -1,
             0,  0, -1,
             0,  0, -1,
             0,  0, -1,
            // Top face
             0,  1,  0,
             0,  1,  0,
             0,  1,  0,
             0,  1,  0,
            // Bottom face
             0, -1,  0,
             0, -1,  0,
             0, -1,  0,
             0, -1,  0,
            // Right face
             1,  0,  0,
             1,  0,  0,
             1,  0,  0,
             1,  0,  0,
            // Left face
            -1,  0,  0,
            -1,  0,  0,
            -1,  0,  0,
            -1,  0,  0
        ];
        
        // Cube indices (12 triangles)
        const indices = [
            0,  1,  2,    0,  2,  3,    // front
            4,  5,  6,    4,  6,  7,    // back
            8,  9,  10,   8,  10, 11,   // top
            12, 13, 14,   12, 14, 15,   // bottom
            16, 17, 18,   16, 18, 19,   // right
            20, 21, 22,   20, 22, 23    // left
        ];
        
        // Create buffers
        const positionBuffer = gl.createBuffer();
        gl.bindBuffer(gl.ARRAY_BUFFER, positionBuffer);
        gl.bufferData(gl.ARRAY_BUFFER, new Float32Array(positions), gl.STATIC_DRAW);
        
        const normalBuffer = gl.createBuffer();
        gl.bindBuffer(gl.ARRAY_BUFFER, normalBuffer);
        gl.bufferData(gl.ARRAY_BUFFER, new Float32Array(normals), gl.STATIC_DRAW);
        
        const indexBuffer = gl.createBuffer();
        gl.bindBuffer(gl.ELEMENT_ARRAY_BUFFER, indexBuffer);
        gl.bufferData(gl.ELEMENT_ARRAY_BUFFER, new Uint16Array(indices), gl.STATIC_DRAW);
        
        // Matrix functions
        function createPerspectiveMatrix(fov, aspect, near, far) {
            const f = 1.0 / Math.tan(fov / 2);
            const rangeInv = 1 / (near - far);
            
            return [
                f / aspect, 0, 0, 0,
                0, f, 0, 0,
                0, 0, (near + far) * rangeInv, -1,
                0, 0, near * far * rangeInv * 2, 0
            ];
        }
        
        function createTranslationMatrix(x, y, z) {
            return [
                1, 0, 0, 0,
                0, 1, 0, 0,
                0, 0, 1, 0,
                x, y, z, 1
            ];
        }
        
        function createRotationMatrix(angle, axis) {
            const c = Math.cos(angle);
            const s = Math.sin(angle);
            
            if (axis === 'x') {
                return [
                    1, 0, 0, 0,
                    0, c, s, 0,
                    0, -s, c, 0,
                    0, 0, 0, 1
                ];
            } else if (axis === 'y') {
                return [
                    c, 0, -s, 0,
                    0, 1, 0, 0,
                    s, 0, c, 0,
                    0, 0, 0, 1
                ];
            } else if (axis === 'z') {
                return [
                    c, s, 0, 0,
                    -s, c, 0, 0,
                    0, 0, 1, 0,
                    0, 0, 0, 1
                ];
            }
        }
        
        function multiplyMatrices(a, b) {
            const result = new Array(16);
            for (let i = 0; i < 4; i++) {
                for (let j = 0; j < 4; j++) {
                    result[i * 4 + j] = 
                        a[i * 4 + 0] * b[0 * 4 + j] +
                        a[i * 4 + 1] * b[1 * 4 + j] +
                        a[i * 4 + 2] * b[2 * 4 + j] +
                        a[i * 4 + 3] * b[3 * 4 + j];
                }
            }
            return result;
        }
        
        function transposeMatrix(matrix) {
            const result = new Array(16);
            for (let i = 0; i < 4; i++) {
                for (let j = 0; j < 4; j++) {
                    result[i * 4 + j] = matrix[j * 4 + i];
                }
            }
            return result;
        }
        
        // Enable depth testing
        gl.enable(gl.DEPTH_TEST);
        
        // Animation variables
        let rotationAngle = 0;
        
        // Render function
        function render() {
            // Clear canvas
            gl.clearColor(0.1, 0.1, 0.1, 1.0);
            gl.clear(gl.COLOR_BUFFER_BIT | gl.DEPTH_BUFFER_BIT);
            
            // Use shader program
            gl.useProgram(program);
            
            // Set up position attribute
            gl.bindBuffer(gl.ARRAY_BUFFER, positionBuffer);
            gl.enableVertexAttribArray(positionAttributeLocation);
            gl.vertexAttribPointer(positionAttributeLocation, 3, gl.FLOAT, false, 0, 0);
            
            // Set up normal attribute
            gl.bindBuffer(gl.ARRAY_BUFFER, normalBuffer);
            gl.enableVertexAttribArray(normalAttributeLocation);
            gl.vertexAttribPointer(normalAttributeLocation, 3, gl.FLOAT, false, 0, 0);
            
            // Bind index buffer
            gl.bindBuffer(gl.ELEMENT_ARRAY_BUFFER, indexBuffer);
            
            // Create matrices
            const projectionMatrix = createPerspectiveMatrix(
                Math.PI / 4, 
                canvas.width / canvas.height, 
                0.1, 
                100
            );
            
            const modelMatrix = multiplyMatrices(
                createTranslationMatrix(0, 0, -5),
                multiplyMatrices(
                    createRotationMatrix(rotationAngle, 'y'),
                    createRotationMatrix(rotationAngle * 0.5, 'x')
                )
            );
            
            // Normal matrix (transpose of inverse of model matrix)
            const normalMatrix = transposeMatrix(modelMatrix);
            
            // Set uniforms
            gl.uniformMatrix4fv(projectionMatrixLocation, false, projectionMatrix);
            gl.uniformMatrix4fv(modelViewMatrixLocation, false, modelMatrix);
            gl.uniformMatrix4fv(normalMatrixLocation, false, normalMatrix);
            
            // Lighting uniforms
            gl.uniform3f(lightPositionLocation, 2, 2, 2);
            gl.uniform3f(lightColorLocation, 1, 1, 1);
            gl.uniform3f(ambientColorLocation, 0.2, 0.2, 0.2);
            gl.uniform3f(diffuseColorLocation, 0.8, 0.2, 0.2);
            gl.uniform3f(specularColorLocation, 1, 1, 1);
            gl.uniform1f(shininessLocation, 32);
            
            // Draw cube
            gl.drawElements(gl.TRIANGLES, indices.length, gl.UNSIGNED_SHORT, 0);
            
            // Update rotation
            rotationAngle += 0.02;
            
            // Request next frame
            requestAnimationFrame(render);
        }
        
        // Start rendering
        render();
    </script>
</body>
</html>
```

## 🔍 WebGL Concepts
- **Shaders**: Vertex and fragment shaders written in GLSL
- **Buffers**: Vertex data storage (positions, normals, colors)
- **Attributes**: Per-vertex data passed to vertex shader
- **Uniforms**: Global data shared across all vertices/fragments
- **Matrices**: 4x4 transformation matrices for 3D operations
- **Lighting**: Phong lighting model with ambient, diffuse, specular
- **Depth Testing**: Z-buffer for proper 3D rendering

## 💡 Learning Points
- **WebGL** provides low-level 3D graphics API
- **Shaders** run on GPU for high performance
- **Matrix math** is essential for 3D transformations
- **Lighting models** create realistic 3D appearance
- **Buffer management** optimizes data transfer to GPU
- **GLSL** is the shader programming language

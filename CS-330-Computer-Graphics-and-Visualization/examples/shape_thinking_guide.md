# CS-330 Shape Thinking Guide

## 🎯 Purpose
Develop the fundamental skill of breaking down complex objects into basic geometric shapes, enabling easier 3D modeling and scene creation.

## 📝 Shape Thinking Examples

### 1. The Art of Shape Decomposition

#### Basic Shape Library
```javascript
// File: src/thinking/basicShapes.js
class ShapeThinking {
    constructor() {
        this.basicShapes = {
            // Primitive shapes
            box: { type: 'box', dimensions: [1, 1, 1] },
            sphere: { type: 'sphere', radius: 1 },
            cylinder: { type: 'cylinder', radius: 1, height: 1 },
            cone: { type: 'cone', radius: 1, height: 1 },
            pyramid: { type: 'pyramid', base: 1, height: 1 },
            torus: { type: 'torus', majorRadius: 1, minorRadius: 0.3 },
            
            // Extended shapes
            capsule: { type: 'capsule', radius: 0.5, height: 2 },
            octahedron: { type: 'octahedron', size: 1 },
            dodecahedron: { type: 'dodecahedron', size: 1 },
            icosahedron: { type: 'icosahedron', size: 1 }
        };
    }
    
    // Analyze an object and break it down into basic shapes
    analyzeObject(objectName) {
        const analysis = {
            object: objectName,
            shapes: [],
            materials: [],
            textures: [],
            complexity: 'simple' // simple, medium, complex
        };
        
        switch (objectName.toLowerCase()) {
            case 'laptop':
                return this.analyzeLaptop();
            case 'desk':
                return this.analyzeDesk();
            case 'chair':
                return this.analyzeChair();
            case 'car':
                return this.analyzeCar();
            case 'house':
                return this.analyzeHouse();
            default:
                return this.analyzeGeneric(objectName);
        }
    }
    
    analyzeLaptop() {
        return {
            object: 'Laptop',
            shapes: [
                { type: 'box', name: 'Base', dimensions: [0.35, 0.02, 0.25], material: 'aluminum' },
                { type: 'box', name: 'Screen', dimensions: [0.35, 0.02, 0.25], material: 'aluminum' },
                { type: 'box', name: 'Keyboard', dimensions: [0.3, 0.01, 0.2], material: 'black_plastic' },
                { type: 'box', name: 'Trackpad', dimensions: [0.08, 0.01, 0.05], material: 'black_plastic' },
                { type: 'box', name: 'Screen_Display', dimensions: [0.32, 0.02, 0.22], material: 'lcd_screen' },
                { type: 'cylinder', name: 'Hinge', radius: 0.01, height: 0.1, material: 'steel' }
            ],
            materials: ['aluminum', 'black_plastic', 'lcd_screen', 'steel'],
            textures: ['brushed_metal', 'plastic', 'screen_glow'],
            complexity: 'medium'
        };
    }
    
    analyzeDesk() {
        return {
            object: 'Desk',
            shapes: [
                { type: 'box', name: 'Surface', dimensions: [4, 0.1, 2], material: 'wood' },
                { type: 'cylinder', name: 'Leg_1', radius: 0.05, height: 1.4, material: 'steel' },
                { type: 'cylinder', name: 'Leg_2', radius: 0.05, height: 1.4, material: 'steel' },
                { type: 'cylinder', name: 'Leg_3', radius: 0.05, height: 1.4, material: 'steel' },
                { type: 'cylinder', name: 'Leg_4', radius: 0.05, height: 1.4, material: 'steel' },
                { type: 'box', name: 'Drawer_1', dimensions: [0.8, 0.6, 0.4], material: 'wood' },
                { type: 'box', name: 'Drawer_2', dimensions: [0.8, 0.6, 0.4], material: 'wood' }
            ],
            materials: ['wood', 'steel'],
            textures: ['oak_wood', 'brushed_steel'],
            complexity: 'medium'
        };
    }
    
    analyzeChair() {
        return {
            object: 'Chair',
            shapes: [
                { type: 'box', name: 'Seat', dimensions: [0.5, 0.05, 0.5], material: 'wood' },
                { type: 'box', name: 'Back', dimensions: [0.5, 0.4, 0.05], material: 'wood' },
                { type: 'cylinder', name: 'Leg_1', radius: 0.02, height: 0.8, material: 'wood' },
                { type: 'cylinder', name: 'Leg_2', radius: 0.02, height: 0.8, material: 'wood' },
                { type: 'cylinder', name: 'Leg_3', radius: 0.02, height: 0.8, material: 'wood' },
                { type: 'cylinder', name: 'Leg_4', radius: 0.02, height: 0.8, material: 'wood' },
                { type: 'box', name: 'Arm_Left', dimensions: [0.05, 0.3, 0.4], material: 'wood' },
                { type: 'box', name: 'Arm_Right', dimensions: [0.05, 0.3, 0.4], material: 'wood' }
            ],
            materials: ['wood'],
            textures: ['oak_wood'],
            complexity: 'medium'
        };
    }
    
    analyzeCar() {
        return {
            object: 'Car',
            shapes: [
                { type: 'box', name: 'Body', dimensions: [4, 1.5, 2], material: 'metal' },
                { type: 'cylinder', name: 'Wheel_1', radius: 0.4, height: 0.3, material: 'rubber' },
                { type: 'cylinder', name: 'Wheel_2', radius: 0.4, height: 0.3, material: 'rubber' },
                { type: 'cylinder', name: 'Wheel_3', radius: 0.4, height: 0.3, material: 'rubber' },
                { type: 'cylinder', name: 'Wheel_4', radius: 0.4, height: 0.3, material: 'rubber' },
                { type: 'box', name: 'Windshield', dimensions: [1.5, 0.8, 0.05], material: 'glass' },
                { type: 'box', name: 'Headlight_1', dimensions: [0.2, 0.15, 0.15], material: 'glass' },
                { type: 'box', name: 'Headlight_2', dimensions: [0.2, 0.15, 0.15], material: 'glass' }
            ],
            materials: ['metal', 'rubber', 'glass'],
            textures: ['car_paint', 'tire_tread', 'glass'],
            complexity: 'complex'
        };
    }
    
    analyzeHouse() {
        return {
            object: 'House',
            shapes: [
                { type: 'box', name: 'Foundation', dimensions: [10, 1, 8], material: 'concrete' },
                { type: 'box', name: 'Walls', dimensions: [10, 6, 8], material: 'brick' },
                { type: 'pyramid', name: 'Roof', base: 12, height: 4, material: 'shingles' },
                { type: 'box', name: 'Door', dimensions: [1, 2.5, 0.1], material: 'wood' },
                { type: 'box', name: 'Window_1', dimensions: [1.5, 1.5, 0.1], material: 'glass' },
                { type: 'box', name: 'Window_2', dimensions: [1.5, 1.5, 0.1], material: 'glass' },
                { type: 'cylinder', name: 'Chimney', radius: 0.5, height: 3, material: 'brick' }
            ],
            materials: ['concrete', 'brick', 'shingles', 'wood', 'glass'],
            textures: ['concrete', 'brick', 'roof_shingles', 'wood_grain', 'glass'],
            complexity: 'complex'
        };
    }
}
```

### 2. Shape Transformation Techniques

#### Scaling and Positioning
```javascript
// File: src/thinking/transformations.js
class ShapeTransformations {
    constructor() {
        this.transformations = {
            scale: { x: 1, y: 1, z: 1 },
            position: { x: 0, y: 0, z: 0 },
            rotation: { x: 0, y: 0, z: 0 }
        };
    }
    
    // Transform a basic shape into a specific object part
    transformShape(shape, targetObject) {
        const transformations = this.getTransformations(shape, targetObject);
        
        return {
            originalShape: shape,
            transformedShape: {
                ...shape,
                ...transformations
            },
            reasoning: this.getTransformationReasoning(shape, targetObject)
        };
    }
    
    getTransformations(shape, targetObject) {
        switch (targetObject) {
            case 'table_leg':
                return this.getTableLegTransformations(shape);
            case 'laptop_screen':
                return this.getLaptopScreenTransformations(shape);
            case 'car_wheel':
                return this.getCarWheelTransformations(shape);
            case 'house_roof':
                return this.getHouseRoofTransformations(shape);
            default:
                return this.getGenericTransformations(shape);
        }
    }
    
    getTableLegTransformations(shape) {
        return {
            scale: { x: 0.1, y: 1.4, z: 0.1 },
            position: { x: 0, y: -0.7, z: 0 },
            rotation: { x: 0, y: 0, z: 0 },
            reasoning: "Table legs are tall and thin, so we scale the box to be much taller than it is wide or deep"
        };
    }
    
    getLaptopScreenTransformations(shape) {
        return {
            scale: { x: 0.35, y: 0.02, z: 0.25 },
            position: { x: 0, y: 0.15, z: 0.1 },
            rotation: { x: 0, y: 0, z: 0 },
            reasoning: "Laptop screens are wide and thin, so we scale the box to be much wider and deeper than it is tall"
        };
    }
    
    getCarWheelTransformations(shape) {
        return {
            scale: { x: 0.8, y: 0.3, z: 0.8 },
            position: { x: 0, y: 0, z: 0 },
            rotation: { x: 0, y: 0, z: 0 },
            reasoning: "Car wheels are cylindrical, so we use a cylinder shape and scale it to be wider than it is tall"
        };
    }
    
    getHouseRoofTransformations(shape) {
        return {
            scale: { x: 1.2, y: 0.4, z: 1.0 },
            position: { x: 0, y: 3, z: 0 },
            rotation: { x: 0, y: 0, z: 0 },
            reasoning: "House roofs are triangular, so we use a pyramid shape and scale it to be wider than it is tall"
        };
    }
    
    getGenericTransformations(shape) {
        return {
            scale: { x: 1, y: 1, z: 1 },
            position: { x: 0, y: 0, z: 0 },
            rotation: { x: 0, y: 0, z: 0 },
            reasoning: "Generic transformation - no specific reasoning applied"
        };
    }
    
    getTransformationReasoning(shape, targetObject) {
        const reasoning = {
            'table_leg': "Table legs need to be tall and thin to support the table surface. A box scaled to be much taller than it is wide creates the right proportions.",
            'laptop_screen': "Laptop screens are wide and thin. A box scaled to be much wider and deeper than it is tall creates the right proportions.",
            'car_wheel': "Car wheels are circular and wider than they are tall. A cylinder scaled to be wider than it is tall creates the right proportions.",
            'house_roof': "House roofs are triangular and wider than they are tall. A pyramid scaled to be wider than it is tall creates the right proportions."
        };
        
        return reasoning[targetObject] || "No specific reasoning available";
    }
}
```

### 3. Material and Texture Thinking

#### Material Selection Guide
```javascript
// File: src/thinking/materialThinking.js
class MaterialThinking {
    constructor() {
        this.materialDatabase = {
            // Metals
            steel: { type: 'metal', properties: ['hard', 'shiny', 'conductive'], textures: ['brushed', 'polished', 'rusted'] },
            aluminum: { type: 'metal', properties: ['light', 'shiny', 'conductive'], textures: ['brushed', 'anodized'] },
            copper: { type: 'metal', properties: ['conductive', 'malleable', 'corrosive'], textures: ['polished', 'patina'] },
            
            // Woods
            oak: { type: 'wood', properties: ['hard', 'durable', 'grainy'], textures: ['natural', 'stained', 'varnished'] },
            pine: { type: 'wood', properties: ['soft', 'light', 'grainy'], textures: ['natural', 'stained'] },
            mahogany: { type: 'wood', properties: ['hard', 'dark', 'grainy'], textures: ['natural', 'polished'] },
            
            // Plastics
            abs: { type: 'plastic', properties: ['durable', 'moldable', 'lightweight'], textures: ['smooth', 'matte', 'glossy'] },
            polycarbonate: { type: 'plastic', properties: ['transparent', 'durable', 'lightweight'], textures: ['clear', 'tinted'] },
            
            // Glass
            tempered: { type: 'glass', properties: ['transparent', 'hard', 'shatterproof'], textures: ['clear', 'frosted'] },
            stained: { type: 'glass', properties: ['colored', 'decorative', 'opaque'], textures: ['colored', 'patterned'] },
            
            // Fabrics
            cotton: { type: 'fabric', properties: ['soft', 'breathable', 'absorbent'], textures: ['woven', 'knit'] },
            leather: { type: 'fabric', properties: ['durable', 'flexible', 'waterproof'], textures: ['smooth', 'textured'] },
            
            // Ceramics
            porcelain: { type: 'ceramic', properties: ['hard', 'smooth', 'non-porous'], textures: ['glazed', 'matte'] },
            terracotta: { type: 'ceramic', properties: ['porous', 'natural', 'durable'], textures: ['rough', 'glazed'] }
        };
    }
    
    // Select appropriate material for an object
    selectMaterial(objectName, requirements) {
        const materialSuggestions = this.getMaterialSuggestions(objectName, requirements);
        
        return {
            object: objectName,
            requirements: requirements,
            suggestions: materialSuggestions,
            reasoning: this.getMaterialReasoning(objectName, requirements)
        };
    }
    
    getMaterialSuggestions(objectName, requirements) {
        const suggestions = [];
        
        switch (objectName.toLowerCase()) {
            case 'laptop':
                suggestions.push(
                    { material: 'aluminum', reasoning: 'Lightweight, durable, good heat dissipation' },
                    { material: 'abs', reasoning: 'Lightweight, moldable, cost-effective' }
                );
                break;
                
            case 'desk':
                suggestions.push(
                    { material: 'oak', reasoning: 'Durable, attractive grain, traditional' },
                    { material: 'steel', reasoning: 'Very durable, modern look, easy to clean' }
                );
                break;
                
            case 'car':
                suggestions.push(
                    { material: 'steel', reasoning: 'Strong, durable, good for body panels' },
                    { material: 'aluminum', reasoning: 'Lightweight, good fuel efficiency' }
                );
                break;
                
            case 'house':
                suggestions.push(
                    { material: 'brick', reasoning: 'Durable, weather-resistant, traditional' },
                    { material: 'wood', reasoning: 'Natural, insulating, traditional' }
                );
                break;
                
            default:
                suggestions.push(
                    { material: 'generic', reasoning: 'No specific material requirements' }
                );
        }
        
        return suggestions;
    }
    
    getMaterialReasoning(objectName, requirements) {
        const reasoning = {
            'laptop': "Laptops need materials that are lightweight for portability, durable for daily use, and good at dissipating heat from internal components.",
            'desk': "Desks need materials that are durable to withstand daily use, attractive for office environments, and easy to maintain.",
            'car': "Cars need materials that are strong for safety, lightweight for fuel efficiency, and durable for long-term use.",
            'house': "Houses need materials that are weather-resistant, insulating for energy efficiency, and durable for long-term use."
        };
        
        return reasoning[objectName.toLowerCase()] || "No specific reasoning available";
    }
    
    // Get texture suggestions for a material
    getTextureSuggestions(material, objectName) {
        const textureSuggestions = [];
        
        switch (material.toLowerCase()) {
            case 'aluminum':
                textureSuggestions.push(
                    { texture: 'brushed', reasoning: 'Modern, professional look' },
                    { texture: 'anodized', reasoning: 'Colorful, durable finish' }
                );
                break;
                
            case 'oak':
                textureSuggestions.push(
                    { texture: 'natural', reasoning: 'Shows natural wood grain' },
                    { texture: 'stained', reasoning: 'Enhanced color, protected surface' }
                );
                break;
                
            case 'steel':
                textureSuggestions.push(
                    { texture: 'brushed', reasoning: 'Modern, industrial look' },
                    { texture: 'polished', reasoning: 'Reflective, high-end appearance' }
                );
                break;
                
            default:
                textureSuggestions.push(
                    { texture: 'default', reasoning: 'Standard texture for material' }
                );
        }
        
        return textureSuggestions;
    }
}
```

### 4. Complex Object Breakdown

#### Advanced Shape Analysis
```javascript
// File: src/thinking/advancedAnalysis.js
class AdvancedShapeAnalysis {
    constructor() {
        this.complexObjects = {
            'gaming_setup': {
                components: [
                    'gaming_pc', 'monitor', 'keyboard', 'mouse', 'headset', 'desk', 'chair'
                ],
                relationships: {
                    'gaming_pc': ['desk'],
                    'monitor': ['desk'],
                    'keyboard': ['desk'],
                    'mouse': ['desk'],
                    'headset': ['desk'],
                    'desk': ['floor'],
                    'chair': ['floor']
                }
            },
            'kitchen': {
                components: [
                    'refrigerator', 'stove', 'sink', 'cabinet', 'counter', 'dishwasher'
                ],
                relationships: {
                    'refrigerator': ['floor'],
                    'stove': ['floor'],
                    'sink': ['counter'],
                    'cabinet': ['wall'],
                    'counter': ['floor'],
                    'dishwasher': ['floor']
                }
            },
            'bedroom': {
                components: [
                    'bed', 'dresser', 'nightstand', 'lamp', 'mirror', 'wardrobe'
                ],
                relationships: {
                    'bed': ['floor'],
                    'dresser': ['floor'],
                    'nightstand': ['floor'],
                    'lamp': ['nightstand'],
                    'mirror': ['wall'],
                    'wardrobe': ['floor']
                }
            }
        };
    }
    
    // Analyze a complex scene
    analyzeComplexScene(sceneName) {
        const scene = this.complexObjects[sceneName];
        if (!scene) {
            return { error: 'Scene not found' };
        }
        
        const analysis = {
            scene: sceneName,
            components: [],
            relationships: scene.relationships,
            totalShapes: 0,
            materials: new Set(),
            textures: new Set()
        };
        
        // Analyze each component
        scene.components.forEach(component => {
            const componentAnalysis = this.analyzeComponent(component);
            analysis.components.push(componentAnalysis);
            analysis.totalShapes += componentAnalysis.shapes.length;
            
            componentAnalysis.materials.forEach(material => analysis.materials.add(material));
            componentAnalysis.textures.forEach(texture => analysis.textures.add(texture));
        });
        
        return analysis;
    }
    
    analyzeComponent(componentName) {
        const componentAnalysis = {
            name: componentName,
            shapes: [],
            materials: [],
            textures: [],
            complexity: 'simple'
        };
        
        switch (componentName.toLowerCase()) {
            case 'gaming_pc':
                componentAnalysis.shapes = [
                    { type: 'box', name: 'Case', dimensions: [0.4, 0.6, 0.2], material: 'steel' },
                    { type: 'box', name: 'Motherboard', dimensions: [0.3, 0.02, 0.2], material: 'fiberglass' },
                    { type: 'box', name: 'GPU', dimensions: [0.25, 0.1, 0.15], material: 'plastic' },
                    { type: 'box', name: 'CPU', dimensions: [0.04, 0.04, 0.04], material: 'silicon' },
                    { type: 'box', name: 'RAM', dimensions: [0.13, 0.02, 0.03], material: 'fiberglass' },
                    { type: 'box', name: 'PSU', dimensions: [0.15, 0.1, 0.2], material: 'steel' }
                ];
                componentAnalysis.materials = ['steel', 'fiberglass', 'plastic', 'silicon'];
                componentAnalysis.textures = ['brushed_steel', 'pcb', 'plastic', 'silicon'];
                componentAnalysis.complexity = 'complex';
                break;
                
            case 'monitor':
                componentAnalysis.shapes = [
                    { type: 'box', name: 'Screen', dimensions: [0.5, 0.3, 0.05], material: 'glass' },
                    { type: 'box', name: 'Bezel', dimensions: [0.52, 0.32, 0.02], material: 'plastic' },
                    { type: 'box', name: 'Stand', dimensions: [0.2, 0.1, 0.1], material: 'steel' },
                    { type: 'box', name: 'Base', dimensions: [0.3, 0.05, 0.2], material: 'steel' }
                ];
                componentAnalysis.materials = ['glass', 'plastic', 'steel'];
                componentAnalysis.textures = ['lcd_screen', 'matte_plastic', 'brushed_steel'];
                componentAnalysis.complexity = 'medium';
                break;
                
            case 'keyboard':
                componentAnalysis.shapes = [
                    { type: 'box', name: 'Body', dimensions: [0.45, 0.02, 0.15], material: 'plastic' },
                    { type: 'box', name: 'Keys', dimensions: [0.4, 0.01, 0.13], material: 'plastic' }
                ];
                componentAnalysis.materials = ['plastic'];
                componentAnalysis.textures = ['matte_plastic'];
                componentAnalysis.complexity = 'simple';
                break;
                
            case 'mouse':
                componentAnalysis.shapes = [
                    { type: 'box', name: 'Body', dimensions: [0.12, 0.04, 0.08], material: 'plastic' },
                    { type: 'box', name: 'Wheel', dimensions: [0.01, 0.01, 0.02], material: 'rubber' }
                ];
                componentAnalysis.materials = ['plastic', 'rubber'];
                componentAnalysis.textures = ['matte_plastic', 'rubber'];
                componentAnalysis.complexity = 'simple';
                break;
                
            case 'headset':
                componentAnalysis.shapes = [
                    { type: 'box', name: 'Headband', dimensions: [0.3, 0.02, 0.05], material: 'plastic' },
                    { type: 'box', name: 'Earcup_Left', dimensions: [0.08, 0.08, 0.08], material: 'plastic' },
                    { type: 'box', name: 'Earcup_Right', dimensions: [0.08, 0.08, 0.08], material: 'plastic' },
                    { type: 'box', name: 'Microphone', dimensions: [0.02, 0.02, 0.05], material: 'plastic' }
                ];
                componentAnalysis.materials = ['plastic'];
                componentAnalysis.textures = ['matte_plastic'];
                componentAnalysis.complexity = 'medium';
                break;
                
            case 'desk':
                componentAnalysis.shapes = [
                    { type: 'box', name: 'Surface', dimensions: [1.2, 0.05, 0.6], material: 'wood' },
                    { type: 'cylinder', name: 'Leg_1', radius: 0.03, height: 0.7, material: 'steel' },
                    { type: 'cylinder', name: 'Leg_2', radius: 0.03, height: 0.7, material: 'steel' },
                    { type: 'cylinder', name: 'Leg_3', radius: 0.03, height: 0.7, material: 'steel' },
                    { type: 'cylinder', name: 'Leg_4', radius: 0.03, height: 0.7, material: 'steel' }
                ];
                componentAnalysis.materials = ['wood', 'steel'];
                componentAnalysis.textures = ['oak_wood', 'brushed_steel'];
                componentAnalysis.complexity = 'medium';
                break;
                
            case 'chair':
                componentAnalysis.shapes = [
                    { type: 'box', name: 'Seat', dimensions: [0.4, 0.05, 0.4], material: 'wood' },
                    { type: 'box', name: 'Back', dimensions: [0.4, 0.3, 0.05], material: 'wood' },
                    { type: 'cylinder', name: 'Leg_1', radius: 0.02, height: 0.7, material: 'wood' },
                    { type: 'cylinder', name: 'Leg_2', radius: 0.02, height: 0.7, material: 'wood' },
                    { type: 'cylinder', name: 'Leg_3', radius: 0.02, height: 0.7, material: 'wood' },
                    { type: 'cylinder', name: 'Leg_4', radius: 0.02, height: 0.7, material: 'wood' }
                ];
                componentAnalysis.materials = ['wood'];
                componentAnalysis.textures = ['oak_wood'];
                componentAnalysis.complexity = 'medium';
                break;
                
            default:
                componentAnalysis.shapes = [
                    { type: 'box', name: 'Generic_Shape', dimensions: [1, 1, 1], material: 'generic' }
                ];
                componentAnalysis.materials = ['generic'];
                componentAnalysis.textures = ['default'];
                componentAnalysis.complexity = 'simple';
        }
        
        return componentAnalysis;
    }
}
```

### 5. Practical Shape Thinking Exercises

#### Exercise Generator
```javascript
// File: src/thinking/exercises.js
class ShapeThinkingExercises {
    constructor() {
        this.exercises = [
            {
                name: 'Basic Shape Recognition',
                description: 'Identify the basic shapes in common objects',
                objects: ['apple', 'book', 'bottle', 'car', 'house'],
                difficulty: 'beginner'
            },
            {
                name: 'Shape Transformation',
                description: 'Transform basic shapes into specific objects',
                shapes: ['box', 'sphere', 'cylinder', 'cone'],
                targets: ['table', 'lamp', 'vase', 'ice_cream'],
                difficulty: 'intermediate'
            },
            {
                name: 'Complex Object Breakdown',
                description: 'Break down complex objects into basic shapes',
                objects: ['computer', 'bicycle', 'airplane', 'robot'],
                difficulty: 'advanced'
            },
            {
                name: 'Material Selection',
                description: 'Choose appropriate materials for objects',
                objects: ['swimming_pool', 'bridge', 'spacecraft', 'musical_instrument'],
                difficulty: 'expert'
            }
        ];
    }
    
    // Generate a random exercise
    generateExercise(difficulty = 'all') {
        let availableExercises = this.exercises;
        
        if (difficulty !== 'all') {
            availableExercises = this.exercises.filter(ex => ex.difficulty === difficulty);
        }
        
        const randomIndex = Math.floor(Math.random() * availableExercises.length);
        const exercise = availableExercises[randomIndex];
        
        return {
            ...exercise,
            id: this.generateExerciseId(),
            timeLimit: this.getTimeLimit(exercise.difficulty),
            hints: this.getHints(exercise)
        };
    }
    
    generateExerciseId() {
        return 'exercise_' + Math.random().toString(36).substr(2, 9);
    }
    
    getTimeLimit(difficulty) {
        const timeLimits = {
            'beginner': 300,    // 5 minutes
            'intermediate': 600, // 10 minutes
            'advanced': 900,    // 15 minutes
            'expert': 1200     // 20 minutes
        };
        
        return timeLimits[difficulty] || 600;
    }
    
    getHints(exercise) {
        const hints = {
            'Basic Shape Recognition': [
                'Look for the most basic geometric shapes',
                'Consider the overall form of the object',
                'Think about how the object was made'
            ],
            'Shape Transformation': [
                'Start with the basic shape and modify it',
                'Consider scaling, rotation, and positioning',
                'Think about the purpose of the object'
            ],
            'Complex Object Breakdown': [
                'Start with the largest components',
                'Work your way down to smaller details',
                'Consider the function of each part'
            ],
            'Material Selection': [
                'Think about the environment the object will be in',
                'Consider the stresses the object will face',
                'Think about the desired appearance'
            ]
        };
        
        return hints[exercise.name] || [];
    }
    
    // Check if an answer is correct
    checkAnswer(exerciseId, answer) {
        // This would contain the logic to check if an answer is correct
        // For now, return a placeholder
        return {
            correct: true,
            score: 100,
            feedback: 'Good job! Your answer is correct.'
        };
    }
}
```

## 🔍 Shape Thinking Concepts
- **Decomposition**: Breaking complex objects into simple shapes
- **Transformation**: Modifying basic shapes to create specific objects
- **Material Selection**: Choosing appropriate materials for objects
- **Texture Mapping**: Applying textures to enhance realism
- **Relationship Analysis**: Understanding how objects relate to each other
- **Complexity Management**: Handling objects of varying complexity

## 💡 Learning Points
- **Start simple** with basic shapes and build complexity
- **Think functionally** about what each shape represents
- **Consider materials** for realistic appearance
- **Plan relationships** between objects in a scene
- **Practice regularly** to develop shape thinking skills
- **Use references** to understand real-world objects

## 🛠️ Practice Tips
1. **Start with everyday objects** like furniture and electronics
2. **Practice breaking down** complex objects into basic shapes
3. **Experiment with transformations** to see how shapes change
4. **Study real objects** to understand their construction
5. **Use reference images** to guide your thinking
6. **Practice regularly** to develop your skills

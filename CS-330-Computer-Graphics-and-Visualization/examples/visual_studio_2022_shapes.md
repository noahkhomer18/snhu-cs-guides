# CS-330 Visual Studio 2022 Shape Creation

## 🎯 Purpose
Demonstrate how to create different 3D shapes using Visual Studio 2022 with C# and DirectX/OpenGL frameworks.

## 📝 Visual Studio 2022 Shape Examples

### Setting Up a 3D Graphics Project in Visual Studio 2022

#### 1. Create New Project
```csharp
// File: Program.cs
using System;
using System.Windows.Forms;
using Microsoft.DirectX;
using Microsoft.DirectX.Direct3D;

namespace ShapeRenderer
{
    public class ShapeRenderer : Form
    {
        private Device device;
        private VertexBuffer vertexBuffer;
        private Material material;
        private Light light;
        
        public ShapeRenderer()
        {
            this.Text = "3D Shape Renderer - Visual Studio 2022";
            this.Size = new System.Drawing.Size(800, 600);
            this.SetStyle(ControlStyles.AllPaintingInWmPaint | ControlStyles.Opaque, true);
        }
        
        public void InitializeGraphics()
        {
            PresentParameters presentParams = new PresentParameters();
            presentParams.Windowed = true;
            presentParams.SwapEffect = SwapEffect.Discard;
            presentParams.EnableAutoDepthStencil = true;
            presentParams.AutoDepthStencilFormat = DepthFormat.D16;
            
            device = new Device(0, DeviceType.Hardware, this, CreateFlags.SoftwareVertexProcessing, presentParams);
            SetupLighting();
            SetupMaterial();
        }
        
        private void SetupLighting()
        {
            light = new Light();
            light.Type = LightType.Directional;
            light.Direction = new Vector3(0, -1, -1);
            light.Diffuse = System.Drawing.Color.White;
            light.Ambient = System.Drawing.Color.FromArgb(50, 50, 50);
            device.Lights[0].SetLight(light);
            device.Lights[0].Enabled = true;
            device.RenderState.Lighting = true;
        }
        
        private void SetupMaterial()
        {
            material = new Material();
            material.Diffuse = System.Drawing.Color.LightBlue;
            material.Ambient = System.Drawing.Color.LightBlue;
            material.Specular = System.Drawing.Color.White;
            material.Power = 20.0f;
            device.Material = material;
        }
    }
}
```

#### 2. Basic Shape Creation Classes
```csharp
// File: ShapeGenerator.cs
using System;
using Microsoft.DirectX;
using Microsoft.DirectX.Direct3D;

namespace ShapeRenderer
{
    public class ShapeGenerator
    {
        public static CustomVertex.PositionNormalColored[] CreateCube(float size)
        {
            float halfSize = size / 2.0f;
            
            // Define 8 vertices of a cube
            Vector3[] vertices = new Vector3[]
            {
                new Vector3(-halfSize, -halfSize, -halfSize), // 0
                new Vector3(halfSize, -halfSize, -halfSize),   // 1
                new Vector3(halfSize, halfSize, -halfSize),    // 2
                new Vector3(-halfSize, halfSize, -halfSize),   // 3
                new Vector3(-halfSize, -halfSize, halfSize),  // 4
                new Vector3(halfSize, -halfSize, halfSize),    // 5
                new Vector3(halfSize, halfSize, halfSize),     // 6
                new Vector3(-halfSize, halfSize, halfSize)    // 7
            };
            
            // Define 12 triangular faces (2 per cube face)
            int[] indices = new int[]
            {
                // Front face
                0, 1, 2, 0, 2, 3,
                // Back face
                4, 7, 6, 4, 6, 5,
                // Left face
                0, 4, 7, 0, 7, 3,
                // Right face
                1, 5, 6, 1, 6, 2,
                // Top face
                3, 2, 6, 3, 6, 7,
                // Bottom face
                0, 4, 5, 0, 5, 1
            };
            
            CustomVertex.PositionNormalColored[] result = new CustomVertex.PositionNormalColored[indices.Length];
            
            for (int i = 0; i < indices.Length; i += 3)
            {
                Vector3 v1 = vertices[indices[i]];
                Vector3 v2 = vertices[indices[i + 1]];
                Vector3 v3 = vertices[indices[i + 2]];
                
                // Calculate normal
                Vector3 normal = Vector3.Normalize(Vector3.Cross(v2 - v1, v3 - v1));
                
                result[i] = new CustomVertex.PositionNormalColored(v1, normal, System.Drawing.Color.LightBlue.ToArgb());
                result[i + 1] = new CustomVertex.PositionNormalColored(v2, normal, System.Drawing.Color.LightBlue.ToArgb());
                result[i + 2] = new CustomVertex.PositionNormalColored(v3, normal, System.Drawing.Color.LightBlue.ToArgb());
            }
            
            return result;
        }
        
        public static CustomVertex.PositionNormalColored[] CreateSphere(float radius, int segments)
        {
            int vertexCount = (segments + 1) * (segments + 1);
            CustomVertex.PositionNormalColored[] vertices = new CustomVertex.PositionNormalColored[vertexCount];
            
            int index = 0;
            for (int i = 0; i <= segments; i++)
            {
                float lat = (float)Math.PI * i / segments;
                for (int j = 0; j <= segments; j++)
                {
                    float lon = 2.0f * (float)Math.PI * j / segments;
                    
                    float x = radius * (float)Math.Sin(lat) * (float)Math.Cos(lon);
                    float y = radius * (float)Math.Cos(lat);
                    float z = radius * (float)Math.Sin(lat) * (float)Math.Sin(lon);
                    
                    Vector3 position = new Vector3(x, y, z);
                    Vector3 normal = Vector3.Normalize(position);
                    
                    vertices[index] = new CustomVertex.PositionNormalColored(
                        position, 
                        normal, 
                        System.Drawing.Color.LightGreen.ToArgb()
                    );
                    index++;
                }
            }
            
            return vertices;
        }
        
        public static CustomVertex.PositionNormalColored[] CreateCylinder(float radius, float height, int segments)
        {
            int vertexCount = (segments + 1) * 4; // Top, bottom, and sides
            CustomVertex.PositionNormalColored[] vertices = new CustomVertex.PositionNormalColored[vertexCount];
            
            int index = 0;
            float halfHeight = height / 2.0f;
            
            // Top and bottom circles
            for (int i = 0; i <= segments; i++)
            {
                float angle = 2.0f * (float)Math.PI * i / segments;
                float x = radius * (float)Math.Cos(angle);
                float z = radius * (float)Math.Sin(angle);
                
                // Top circle
                vertices[index] = new CustomVertex.PositionNormalColored(
                    new Vector3(x, halfHeight, z),
                    new Vector3(0, 1, 0),
                    System.Drawing.Color.LightCoral.ToArgb()
                );
                index++;
                
                // Bottom circle
                vertices[index] = new CustomVertex.PositionNormalColored(
                    new Vector3(x, -halfHeight, z),
                    new Vector3(0, -1, 0),
                    System.Drawing.Color.LightCoral.ToArgb()
                );
                index++;
            }
            
            // Side faces
            for (int i = 0; i <= segments; i++)
            {
                float angle = 2.0f * (float)Math.PI * i / segments;
                float x = radius * (float)Math.Cos(angle);
                float z = radius * (float)Math.Sin(angle);
                
                Vector3 normal = new Vector3(x, 0, z);
                normal.Normalize();
                
                // Top vertex
                vertices[index] = new CustomVertex.PositionNormalColored(
                    new Vector3(x, halfHeight, z),
                    normal,
                    System.Drawing.Color.LightCoral.ToArgb()
                );
                index++;
                
                // Bottom vertex
                vertices[index] = new CustomVertex.PositionNormalColored(
                    new Vector3(x, -halfHeight, z),
                    normal,
                    System.Drawing.Color.LightCoral.ToArgb()
                );
                index++;
            }
            
            return vertices;
        }
        
        public static CustomVertex.PositionNormalColored[] CreatePyramid(float baseSize, float height)
        {
            CustomVertex.PositionNormalColored[] vertices = new CustomVertex.PositionNormalColored[18]; // 6 faces * 3 vertices
            
            float halfBase = baseSize / 2.0f;
            Vector3 apex = new Vector3(0, height, 0);
            
            // Base vertices
            Vector3[] baseVertices = new Vector3[]
            {
                new Vector3(-halfBase, 0, -halfBase),
                new Vector3(halfBase, 0, -halfBase),
                new Vector3(halfBase, 0, halfBase),
                new Vector3(-halfBase, 0, halfBase)
            };
            
            int index = 0;
            
            // Base (square)
            Vector3 baseNormal = new Vector3(0, -1, 0);
            vertices[index++] = new CustomVertex.PositionNormalColored(baseVertices[0], baseNormal, System.Drawing.Color.Orange.ToArgb());
            vertices[index++] = new CustomVertex.PositionNormalColored(baseVertices[1], baseNormal, System.Drawing.Color.Orange.ToArgb());
            vertices[index++] = new CustomVertex.PositionNormalColored(baseVertices[2], baseNormal, System.Drawing.Color.Orange.ToArgb());
            
            vertices[index++] = new CustomVertex.PositionNormalColored(baseVertices[0], baseNormal, System.Drawing.Color.Orange.ToArgb());
            vertices[index++] = new CustomVertex.PositionNormalColored(baseVertices[2], baseNormal, System.Drawing.Color.Orange.ToArgb());
            vertices[index++] = new CustomVertex.PositionNormalColored(baseVertices[3], baseNormal, System.Drawing.Color.Orange.ToArgb());
            
            // Side faces
            for (int i = 0; i < 4; i++)
            {
                Vector3 v1 = baseVertices[i];
                Vector3 v2 = baseVertices[(i + 1) % 4];
                
                Vector3 edge1 = v2 - v1;
                Vector3 edge2 = apex - v1;
                Vector3 normal = Vector3.Normalize(Vector3.Cross(edge1, edge2));
                
                vertices[index++] = new CustomVertex.PositionNormalColored(v1, normal, System.Drawing.Color.Orange.ToArgb());
                vertices[index++] = new CustomVertex.PositionNormalColored(v2, normal, System.Drawing.Color.Orange.ToArgb());
                vertices[index++] = new CustomVertex.PositionNormalColored(apex, normal, System.Drawing.Color.Orange.ToArgb());
            }
            
            return vertices;
        }
    }
}
```

#### 3. Main Rendering Loop
```csharp
// File: MainRenderer.cs
using System;
using System.Windows.Forms;
using Microsoft.DirectX;
using Microsoft.DirectX.Direct3D;

namespace ShapeRenderer
{
    public partial class ShapeRenderer : Form
    {
        private CustomVertex.PositionNormalColored[] cubeVertices;
        private CustomVertex.PositionNormalColored[] sphereVertices;
        private CustomVertex.PositionNormalColored[] cylinderVertices;
        private CustomVertex.PositionNormalColored[] pyramidVertices;
        
        private Matrix worldMatrix;
        private Matrix viewMatrix;
        private Matrix projectionMatrix;
        
        private float rotationAngle = 0.0f;
        
        protected override void OnLoad(EventArgs e)
        {
            base.OnLoad(e);
            InitializeGraphics();
            CreateShapes();
            SetupMatrices();
        }
        
        private void CreateShapes()
        {
            cubeVertices = ShapeGenerator.CreateCube(2.0f);
            sphereVertices = ShapeGenerator.CreateSphere(1.0f, 20);
            cylinderVertices = ShapeGenerator.CreateCylinder(1.0f, 2.0f, 20);
            pyramidVertices = ShapeGenerator.CreatePyramid(2.0f, 2.0f);
        }
        
        private void SetupMatrices()
        {
            // World matrix (identity)
            worldMatrix = Matrix.Identity;
            
            // View matrix (camera position)
            viewMatrix = Matrix.LookAtLH(
                new Vector3(0, 0, -10),  // Camera position
                new Vector3(0, 0, 0),     // Look at
                new Vector3(0, 1, 0)      // Up vector
            );
            
            // Projection matrix
            projectionMatrix = Matrix.PerspectiveFovLH(
                (float)Math.PI / 4,      // Field of view
                (float)this.Width / this.Height, // Aspect ratio
                0.1f,                    // Near plane
                100.0f                   // Far plane
            );
        }
        
        protected override void OnPaint(PaintEventArgs e)
        {
            if (device == null) return;
            
            device.Clear(ClearFlags.Target | ClearFlags.ZBuffer, System.Drawing.Color.DarkBlue, 1.0f, 0);
            device.BeginScene();
            
            // Set matrices
            device.Transform.World = worldMatrix;
            device.Transform.View = viewMatrix;
            device.Transform.Projection = projectionMatrix;
            
            // Render different shapes
            RenderShape(cubeVertices, new Vector3(-3, 0, 0));
            RenderShape(sphereVertices, new Vector3(0, 0, 0));
            RenderShape(cylinderVertices, new Vector3(3, 0, 0));
            RenderShape(pyramidVertices, new Vector3(0, 3, 0));
            
            device.EndScene();
            device.Present();
            
            // Update rotation
            rotationAngle += 0.02f;
            this.Invalidate();
        }
        
        private void RenderShape(CustomVertex.PositionNormalColored[] vertices, Vector3 position)
        {
            // Create transformation matrix
            Matrix translation = Matrix.Translation(position);
            Matrix rotation = Matrix.RotationY(rotationAngle);
            Matrix transform = rotation * translation;
            
            device.Transform.World = transform;
            
            // Set vertex format and render
            device.VertexFormat = CustomVertex.PositionNormalColored.Format;
            device.DrawUserPrimitives(PrimitiveType.TriangleList, vertices.Length / 3, vertices);
        }
    }
}
```

#### 4. Advanced Shape: Torus
```csharp
// File: AdvancedShapes.cs
using System;
using Microsoft.DirectX;
using Microsoft.DirectX.Direct3D;

namespace ShapeRenderer
{
    public class AdvancedShapes
    {
        public static CustomVertex.PositionNormalColored[] CreateTorus(float majorRadius, float minorRadius, int majorSegments, int minorSegments)
        {
            int vertexCount = (majorSegments + 1) * (minorSegments + 1);
            CustomVertex.PositionNormalColored[] vertices = new CustomVertex.PositionNormalColored[vertexCount];
            
            int index = 0;
            for (int i = 0; i <= majorSegments; i++)
            {
                float majorAngle = 2.0f * (float)Math.PI * i / majorSegments;
                Vector3 center = new Vector3(
                    majorRadius * (float)Math.Cos(majorAngle),
                    0,
                    majorRadius * (float)Math.Sin(majorAngle)
                );
                
                for (int j = 0; j <= minorSegments; j++)
                {
                    float minorAngle = 2.0f * (float)Math.PI * j / minorSegments;
                    
                    Vector3 position = new Vector3(
                        center.X + minorRadius * (float)Math.Cos(minorAngle) * (float)Math.Cos(majorAngle),
                        minorRadius * (float)Math.Sin(minorAngle),
                        center.Z + minorRadius * (float)Math.Cos(minorAngle) * (float)Math.Sin(majorAngle)
                    );
                    
                    Vector3 normal = Vector3.Normalize(position - center);
                    
                    vertices[index] = new CustomVertex.PositionNormalColored(
                        position,
                        normal,
                        System.Drawing.Color.Purple.ToArgb()
                    );
                    index++;
                }
            }
            
            return vertices;
        }
        
        public static CustomVertex.PositionNormalColored[] CreateCone(float radius, float height, int segments)
        {
            int vertexCount = (segments + 1) * 3; // Base + sides
            CustomVertex.PositionNormalColored[] vertices = new CustomVertex.PositionNormalColored[vertexCount];
            
            int index = 0;
            Vector3 apex = new Vector3(0, height, 0);
            
            // Base circle
            for (int i = 0; i <= segments; i++)
            {
                float angle = 2.0f * (float)Math.PI * i / segments;
                float x = radius * (float)Math.Cos(angle);
                float z = radius * (float)Math.Sin(angle);
                
                vertices[index] = new CustomVertex.PositionNormalColored(
                    new Vector3(x, 0, z),
                    new Vector3(0, -1, 0),
                    System.Drawing.Color.Yellow.ToArgb()
                );
                index++;
            }
            
            // Side faces
            for (int i = 0; i <= segments; i++)
            {
                float angle = 2.0f * (float)Math.PI * i / segments;
                float x = radius * (float)Math.Cos(angle);
                float z = radius * (float)Math.Sin(angle);
                
                Vector3 baseVertex = new Vector3(x, 0, z);
                Vector3 edge1 = baseVertex;
                Vector3 edge2 = apex - baseVertex;
                Vector3 normal = Vector3.Normalize(Vector3.Cross(edge1, edge2));
                
                vertices[index] = new CustomVertex.PositionNormalColored(
                    baseVertex,
                    normal,
                    System.Drawing.Color.Yellow.ToArgb()
                );
                index++;
                
                vertices[index] = new CustomVertex.PositionNormalColored(
                    apex,
                    normal,
                    System.Drawing.Color.Yellow.ToArgb()
                );
                index++;
            }
            
            return vertices;
        }
    }
}
```

#### 5. Project Configuration (App.config)
```xml
<?xml version="1.0" encoding="utf-8" ?>
<configuration>
    <startup>
        <supportedRuntime version="v4.0" sku=".NETFramework,Version=v4.8" />
    </startup>
</configuration>
```

#### 6. NuGet Package References
```xml
<!-- File: ShapeRenderer.csproj -->
<Project Sdk="Microsoft.NET.Sdk">
  <PropertyGroup>
    <OutputType>Exe</OutputType>
    <TargetFramework>net48</TargetFramework>
    <UseWindowsForms>true</UseWindowsForms>
  </PropertyGroup>
  
  <ItemGroup>
    <PackageReference Include="Microsoft.DirectX" Version="9.0.0" />
    <PackageReference Include="Microsoft.DirectX.Direct3D" Version="9.0.0" />
  </ItemGroup>
</Project>
```

## 🔍 Visual Studio 2022 Concepts
- **DirectX Integration**: Using Microsoft.DirectX for 3D graphics
- **Vertex Buffers**: Storing geometric data for rendering
- **Matrix Transformations**: World, view, and projection matrices
- **Lighting Models**: Directional and ambient lighting
- **Primitive Types**: Triangle lists for shape rendering
- **Custom Vertices**: Position, normal, and color data

## 💡 Learning Points
- **Visual Studio 2022** provides excellent 3D graphics development tools
- **DirectX** offers hardware-accelerated 3D rendering
- **Matrix math** is essential for 3D transformations
- **Vertex formats** determine how data is passed to the GPU
- **Lighting calculations** create realistic 3D appearance
- **Shape generation** requires understanding of 3D geometry

## 🛠️ Setup Instructions
1. Open Visual Studio 2022
2. Create new Windows Forms Application (.NET Framework)
3. Install DirectX NuGet packages
4. Add the shape generation classes
5. Configure the main form for 3D rendering
6. Run the application to see rotating 3D shapes

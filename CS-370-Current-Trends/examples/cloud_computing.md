# CS-370 Cloud Computing

## 🎯 Purpose
Demonstrate cloud computing concepts, services, and implementation using major cloud providers like AWS, Azure, and Google Cloud.

## 📝 Cloud Computing Examples

### AWS Services Implementation

#### AWS Lambda Functions
```python
# lambda_function.py
import json
import boto3
from datetime import datetime
import os

# Initialize AWS services
dynamodb = boto3.resource('dynamodb')
s3 = boto3.client('s3')
sns = boto3.client('sns')

# Environment variables
TABLE_NAME = os.environ['DYNAMODB_TABLE']
BUCKET_NAME = os.environ['S3_BUCKET']
SNS_TOPIC_ARN = os.environ['SNS_TOPIC_ARN']

def lambda_handler(event, context):
    """
    AWS Lambda function to process user data
    """
    try:
        # Parse the incoming event
        if 'Records' in event:
            # S3 trigger
            for record in event['Records']:
                if record['eventName'].startswith('ObjectCreated'):
                    process_s3_object(record)
        else:
            # Direct invocation
            process_user_data(event)
        
        return {
            'statusCode': 200,
            'body': json.dumps({
                'message': 'Processing completed successfully',
                'timestamp': datetime.utcnow().isoformat()
            })
        }
    
    except Exception as e:
        print(f"Error: {str(e)}")
        return {
            'statusCode': 500,
            'body': json.dumps({
                'error': str(e),
                'timestamp': datetime.utcnow().isoformat()
            })
        }

def process_user_data(data):
    """
    Process user data and store in DynamoDB
    """
    table = dynamodb.Table(TABLE_NAME)
    
    user_item = {
        'user_id': data['user_id'],
        'name': data['name'],
        'email': data['email'],
        'created_at': datetime.utcnow().isoformat(),
        'ttl': int((datetime.utcnow().timestamp() + 86400 * 30))  # 30 days TTL
    }
    
    # Store in DynamoDB
    table.put_item(Item=user_item)
    
    # Send notification
    sns.publish(
        TopicArn=SNS_TOPIC_ARN,
        Message=f"New user registered: {data['name']}",
        Subject="User Registration"
    )

def process_s3_object(record):
    """
    Process file uploaded to S3
    """
    bucket = record['s3']['bucket']['name']
    key = record['s3']['object']['key']
    
    # Get object metadata
    response = s3.head_object(Bucket=bucket, Key=key)
    file_size = response['ContentLength']
    
    # Log file processing
    print(f"Processing file: {key}, Size: {file_size} bytes")
    
    # Store processing result in DynamoDB
    table = dynamodb.Table(TABLE_NAME)
    table.put_item(Item={
        'file_id': key,
        'bucket': bucket,
        'size': file_size,
        'processed_at': datetime.utcnow().isoformat()
    })

# requirements.txt
# boto3==1.26.137
# requests==2.28.2
```

#### AWS API Gateway with Lambda
```python
# api_handler.py
import json
import boto3
from decimal import Decimal

dynamodb = boto3.resource('dynamodb')
table = dynamodb.Table('Users')

def lambda_handler(event, context):
    """
    API Gateway Lambda handler
    """
    http_method = event['httpMethod']
    path = event['path']
    
    try:
        if http_method == 'GET':
            if path == '/users':
                return get_all_users()
            elif path.startswith('/users/'):
                user_id = path.split('/')[-1]
                return get_user(user_id)
        
        elif http_method == 'POST':
            if path == '/users':
                body = json.loads(event['body'])
                return create_user(body)
        
        elif http_method == 'PUT':
            if path.startswith('/users/'):
                user_id = path.split('/')[-1]
                body = json.loads(event['body'])
                return update_user(user_id, body)
        
        elif http_method == 'DELETE':
            if path.startswith('/users/'):
                user_id = path.split('/')[-1]
                return delete_user(user_id)
        
        return {
            'statusCode': 404,
            'headers': {
                'Content-Type': 'application/json',
                'Access-Control-Allow-Origin': '*'
            },
            'body': json.dumps({'error': 'Not found'})
        }
    
    except Exception as e:
        return {
            'statusCode': 500,
            'headers': {
                'Content-Type': 'application/json',
                'Access-Control-Allow-Origin': '*'
            },
            'body': json.dumps({'error': str(e)})
        }

def get_all_users():
    """Get all users from DynamoDB"""
    response = table.scan()
    users = response['Items']
    
    # Convert Decimal to int for JSON serialization
    for user in users:
        if 'age' in user:
            user['age'] = int(user['age'])
    
    return {
        'statusCode': 200,
        'headers': {
            'Content-Type': 'application/json',
            'Access-Control-Allow-Origin': '*'
        },
        'body': json.dumps(users)
    }

def get_user(user_id):
    """Get specific user by ID"""
    response = table.get_item(Key={'user_id': user_id})
    
    if 'Item' not in response:
        return {
            'statusCode': 404,
            'headers': {
                'Content-Type': 'application/json',
                'Access-Control-Allow-Origin': '*'
            },
            'body': json.dumps({'error': 'User not found'})
        }
    
    user = response['Item']
    if 'age' in user:
        user['age'] = int(user['age'])
    
    return {
        'statusCode': 200,
        'headers': {
            'Content-Type': 'application/json',
            'Access-Control-Allow-Origin': '*'
        },
        'body': json.dumps(user)
    }

def create_user(user_data):
    """Create new user"""
    user_item = {
        'user_id': user_data['user_id'],
        'name': user_data['name'],
        'email': user_data['email'],
        'age': Decimal(str(user_data.get('age', 0))),
        'created_at': datetime.utcnow().isoformat()
    }
    
    table.put_item(Item=user_item)
    
    return {
        'statusCode': 201,
        'headers': {
            'Content-Type': 'application/json',
            'Access-Control-Allow-Origin': '*'
        },
        'body': json.dumps({'message': 'User created successfully'})
    }

def update_user(user_id, user_data):
    """Update existing user"""
    update_expression = "SET "
    expression_attribute_values = {}
    
    if 'name' in user_data:
        update_expression += "name = :name, "
        expression_attribute_values[':name'] = user_data['name']
    
    if 'email' in user_data:
        update_expression += "email = :email, "
        expression_attribute_values[':email'] = user_data['email']
    
    if 'age' in user_data:
        update_expression += "age = :age, "
        expression_attribute_values[':age'] = Decimal(str(user_data['age']))
    
    update_expression += "updated_at = :updated_at"
    expression_attribute_values[':updated_at'] = datetime.utcnow().isoformat()
    
    table.update_item(
        Key={'user_id': user_id},
        UpdateExpression=update_expression,
        ExpressionAttributeValues=expression_attribute_values
    )
    
    return {
        'statusCode': 200,
        'headers': {
            'Content-Type': 'application/json',
            'Access-Control-Allow-Origin': '*'
        },
        'body': json.dumps({'message': 'User updated successfully'})
    }

def delete_user(user_id):
    """Delete user"""
    table.delete_item(Key={'user_id': user_id})
    
    return {
        'statusCode': 200,
        'headers': {
            'Content-Type': 'application/json',
            'Access-Control-Allow-Origin': '*'
        },
        'body': json.dumps({'message': 'User deleted successfully'})
    }
```

### Azure Cloud Services

#### Azure Functions with Cosmos DB
```csharp
// Azure Function - User Management
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Azure.WebJobs;
using Microsoft.Azure.WebJobs.Extensions.Http;
using Microsoft.Extensions.Logging;
using Microsoft.Azure.Cosmos;
using System;
using System.Threading.Tasks;
using Newtonsoft.Json;

public static class UserManagementFunction
{
    private static readonly string CosmosDbConnectionString = Environment.GetEnvironmentVariable("CosmosDbConnectionString");
    private static readonly string DatabaseName = "UserDatabase";
    private static readonly string ContainerName = "Users";

    [FunctionName("GetUsers")]
    public static async Task<IActionResult> GetUsers(
        [HttpTrigger(AuthorizationLevel.Function, "get", Route = "users")] HttpRequest req,
        ILogger log)
    {
        try
        {
            using var cosmosClient = new CosmosClient(CosmosDbConnectionString);
            var database = cosmosClient.GetDatabase(DatabaseName);
            var container = database.GetContainer(ContainerName);

            var query = "SELECT * FROM c";
            var queryDefinition = new QueryDefinition(query);
            var queryResultSetIterator = container.GetItemQueryIterator<dynamic>(queryDefinition);

            var users = new List<dynamic>();
            while (queryResultSetIterator.HasMoreResults)
            {
                var currentResultSet = await queryResultSetIterator.ReadNextAsync();
                users.AddRange(currentResultSet);
            }

            return new OkObjectResult(users);
        }
        catch (Exception ex)
        {
            log.LogError(ex, "Error retrieving users");
            return new StatusCodeResult(500);
        }
    }

    [FunctionName("CreateUser")]
    public static async Task<IActionResult> CreateUser(
        [HttpTrigger(AuthorizationLevel.Function, "post", Route = "users")] HttpRequest req,
        ILogger log)
    {
        try
        {
            string requestBody = await new StreamReader(req.Body).ReadToEndAsync();
            dynamic userData = JsonConvert.DeserializeObject(requestBody);

            using var cosmosClient = new CosmosClient(CosmosDbConnectionString);
            var database = cosmosClient.GetDatabase(DatabaseName);
            var container = database.GetContainer(ContainerName);

            var user = new
            {
                id = Guid.NewGuid().ToString(),
                name = userData.name,
                email = userData.email,
                age = userData.age,
                created_at = DateTime.UtcNow
            };

            await container.CreateItemAsync(user);

            return new CreatedResult($"/api/users/{user.id}", user);
        }
        catch (Exception ex)
        {
            log.LogError(ex, "Error creating user");
            return new StatusCodeResult(500);
        }
    }

    [FunctionName("UpdateUser")]
    public static async Task<IActionResult> UpdateUser(
        [HttpTrigger(AuthorizationLevel.Function, "put", Route = "users/{id}")] HttpRequest req,
        string id,
        ILogger log)
    {
        try
        {
            string requestBody = await new StreamReader(req.Body).ReadToEndAsync();
            dynamic userData = JsonConvert.DeserializeObject(requestBody);

            using var cosmosClient = new CosmosClient(CosmosDbConnectionString);
            var database = cosmosClient.GetDatabase(DatabaseName);
            var container = database.GetContainer(ContainerName);

            var existingUser = await container.ReadItemAsync<dynamic>(id, new PartitionKey(id));
            var user = existingUser.Resource;

            user.name = userData.name ?? user.name;
            user.email = userData.email ?? user.email;
            user.age = userData.age ?? user.age;
            user.updated_at = DateTime.UtcNow;

            await container.ReplaceItemAsync(user, id);

            return new OkObjectResult(user);
        }
        catch (Exception ex)
        {
            log.LogError(ex, "Error updating user");
            return new StatusCodeResult(500);
        }
    }
}
```

### Google Cloud Platform

#### Google Cloud Functions with Firestore
```javascript
// Google Cloud Function - User Management
const functions = require('@google-cloud/functions-framework');
const { Firestore } = require('@google-cloud/firestore');

const firestore = new Firestore();

// HTTP Cloud Function
functions.http('userManagement', async (req, res) => {
    // Enable CORS
    res.set('Access-Control-Allow-Origin', '*');
    res.set('Access-Control-Allow-Methods', 'GET, POST, PUT, DELETE, OPTIONS');
    res.set('Access-Control-Allow-Headers', 'Content-Type');

    if (req.method === 'OPTIONS') {
        res.status(204).send('');
        return;
    }

    try {
        const { method, path } = req;
        const pathParts = path.split('/').filter(part => part);

        switch (method) {
            case 'GET':
                if (pathParts[0] === 'users') {
                    if (pathParts.length === 2) {
                        // Get specific user
                        await get_user(req, res, pathParts[1]);
                    } else {
                        // Get all users
                        await get_all_users(req, res);
                    }
                }
                break;

            case 'POST':
                if (pathParts[0] === 'users') {
                    await create_user(req, res);
                }
                break;

            case 'PUT':
                if (pathParts[0] === 'users' && pathParts.length === 2) {
                    await update_user(req, res, pathParts[1]);
                }
                break;

            case 'DELETE':
                if (pathParts[0] === 'users' && pathParts.length === 2) {
                    await delete_user(req, res, pathParts[1]);
                }
                break;

            default:
                res.status(404).json({ error: 'Not found' });
        }
    } catch (error) {
        console.error('Error:', error);
        res.status(500).json({ error: error.message });
    }
});

async function get_all_users(req, res) {
    const usersRef = firestore.collection('users');
    const snapshot = await usersRef.get();
    
    const users = [];
    snapshot.forEach(doc => {
        users.push({
            id: doc.id,
            ...doc.data()
        });
    });

    res.status(200).json(users);
}

async function get_user(req, res, userId) {
    const userRef = firestore.collection('users').doc(userId);
    const doc = await userRef.get();

    if (!doc.exists) {
        res.status(404).json({ error: 'User not found' });
        return;
    }

    res.status(200).json({
        id: doc.id,
        ...doc.data()
    });
}

async function create_user(req, res) {
    const { name, email, age } = req.body;

    if (!name || !email) {
        res.status(400).json({ error: 'Name and email are required' });
        return;
    }

    const userData = {
        name,
        email,
        age: age || 0,
        created_at: new Date(),
        updated_at: new Date()
    };

    const docRef = await firestore.collection('users').add(userData);
    
    res.status(201).json({
        id: docRef.id,
        ...userData
    });
}

async function update_user(req, res, userId) {
    const { name, email, age } = req.body;
    const userRef = firestore.collection('users').doc(userId);
    const doc = await userRef.get();

    if (!doc.exists) {
        res.status(404).json({ error: 'User not found' });
        return;
    }

    const updateData = {
        updated_at: new Date()
    };

    if (name !== undefined) updateData.name = name;
    if (email !== undefined) updateData.email = email;
    if (age !== undefined) updateData.age = age;

    await userRef.update(updateData);
    
    const updatedDoc = await userRef.get();
    res.status(200).json({
        id: updatedDoc.id,
        ...updatedDoc.data()
    });
}

async function delete_user(req, res, userId) {
    const userRef = firestore.collection('users').doc(userId);
    const doc = await userRef.get();

    if (!doc.exists) {
        res.status(404).json({ error: 'User not found' });
        return;
    }

    await userRef.delete();
    res.status(200).json({ message: 'User deleted successfully' });
}
```

### Container Orchestration with Kubernetes

#### Kubernetes Deployment Configuration
```yaml
# kubernetes-deployment.yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: user-service
  labels:
    app: user-service
spec:
  replicas: 3
  selector:
    matchLabels:
      app: user-service
  template:
    metadata:
      labels:
        app: user-service
    spec:
      containers:
      - name: user-service
        image: user-service:latest
        ports:
        - containerPort: 8080
        env:
        - name: DATABASE_URL
          valueFrom:
            secretKeyRef:
              name: database-secret
              key: url
        - name: DATABASE_USERNAME
          valueFrom:
            secretKeyRef:
              name: database-secret
              key: username
        - name: DATABASE_PASSWORD
          valueFrom:
            secretKeyRef:
              name: database-secret
              key: password
        resources:
          requests:
            memory: "256Mi"
            cpu: "250m"
          limits:
            memory: "512Mi"
            cpu: "500m"
        livenessProbe:
          httpGet:
            path: /health
            port: 8080
          initialDelaySeconds: 30
          periodSeconds: 10
        readinessProbe:
          httpGet:
            path: /ready
            port: 8080
          initialDelaySeconds: 5
          periodSeconds: 5

---
apiVersion: v1
kind: Service
metadata:
  name: user-service
spec:
  selector:
    app: user-service
  ports:
  - protocol: TCP
    port: 80
    targetPort: 8080
  type: LoadBalancer

---
apiVersion: v1
kind: Secret
metadata:
  name: database-secret
type: Opaque
data:
  url: <base64-encoded-database-url>
  username: <base64-encoded-username>
  password: <base64-encoded-password>
```

## 🔍 Cloud Computing Concepts
- **Serverless Computing**: AWS Lambda, Azure Functions, Google Cloud Functions
- **Database Services**: DynamoDB, Cosmos DB, Firestore
- **API Management**: API Gateway, Azure API Management
- **Container Orchestration**: Kubernetes, Docker Swarm
- **Infrastructure as Code**: Terraform, CloudFormation

## 💡 Learning Points
- Cloud services provide scalable, managed solutions
- Serverless functions eliminate server management overhead
- Cloud databases offer automatic scaling and backup
- Container orchestration manages complex deployments
- Cloud security requires proper configuration and monitoring

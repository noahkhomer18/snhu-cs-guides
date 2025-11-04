# Neural Network Overview - Jupyter Notebook Template

## Overview
This notebook demonstrates basic neural network concepts and implementation using PyTorch.

## Installation and Setup

```python
# Install required packages
# !pip install torch torchvision numpy matplotlib scikit-learn
```

```python
import torch
import torch.nn as nn
import torch.optim as optim
import torch.nn.functional as F
from torch.utils.data import DataLoader, TensorDataset
import numpy as np
import matplotlib.pyplot as plt
from sklearn.model_selection import train_test_split
from sklearn.preprocessing import StandardScaler
from sklearn.metrics import accuracy_score, confusion_matrix, classification_report
import seaborn as sns
```

## 1. Data Preparation

### Generate Synthetic Dataset

```python
# Generate synthetic classification dataset
def generate_dataset(n_samples=1000, n_features=20, n_classes=3, random_state=42):
    """Generate a synthetic dataset for classification"""
    np.random.seed(random_state)
    
    X = np.random.randn(n_samples, n_features)
    y = np.random.randint(0, n_classes, n_samples)
    
    # Make dataset more separable by adding class-specific patterns
    for i in range(n_classes):
        mask = y == i
        X[mask] += np.random.randn(n_features) * 2
    
    return X, y

# Generate dataset
X, y = generate_dataset(n_samples=2000, n_features=20, n_classes=3)
print(f"Dataset shape: {X.shape}")
print(f"Number of classes: {len(np.unique(y))}")
print(f"Class distribution: {np.bincount(y)}")
```

### Train/Test Split

```python
# Split dataset into training and testing sets
X_train, X_test, y_train, y_test = train_test_split(
    X, y, test_size=0.2, random_state=42, stratify=y
)

print(f"Training set: {X_train.shape[0]} samples")
print(f"Test set: {X_test.shape[0]} samples")
```

### Feature Scaling

```python
# Standardize features
scaler = StandardScaler()
X_train_scaled = scaler.fit_transform(X_train)
X_test_scaled = scaler.transform(X_test)

# Convert to PyTorch tensors
X_train_tensor = torch.FloatTensor(X_train_scaled)
X_test_tensor = torch.FloatTensor(X_test_scaled)
y_train_tensor = torch.LongTensor(y_train)
y_test_tensor = torch.LongTensor(y_test)

# Create data loaders
train_dataset = TensorDataset(X_train_tensor, y_train_tensor)
test_dataset = TensorDataset(X_test_tensor, y_test_tensor)

train_loader = DataLoader(train_dataset, batch_size=32, shuffle=True)
test_loader = DataLoader(test_dataset, batch_size=32, shuffle=False)

print(f"Training batches: {len(train_loader)}")
print(f"Test batches: {len(test_loader)}")
```

## 2. Model Architecture

### Define Neural Network

```python
class NeuralNetwork(nn.Module):
    """Multi-layer perceptron for classification"""
    
    def __init__(self, input_dim, hidden_dims, num_classes, activation='relu'):
        super(NeuralNetwork, self).__init__()
        
        self.activation_name = activation
        
        # Define layers
        layers = []
        prev_dim = input_dim
        
        # Hidden layers
        for hidden_dim in hidden_dims:
            layers.append(nn.Linear(prev_dim, hidden_dim))
            if activation == 'relu':
                layers.append(nn.ReLU())
            elif activation == 'sigmoid':
                layers.append(nn.Sigmoid())
            elif activation == 'tanh':
                layers.append(nn.Tanh())
            layers.append(nn.Dropout(0.2))
            prev_dim = hidden_dim
        
        # Output layer
        layers.append(nn.Linear(prev_dim, num_classes))
        
        self.network = nn.Sequential(*layers)
    
    def forward(self, x):
        """Forward pass through the network"""
        return self.network(x)
    
    def predict(self, x):
        """Make predictions"""
        self.eval()
        with torch.no_grad():
            logits = self.forward(x)
            predictions = torch.argmax(logits, dim=1)
        return predictions

# Create model
input_dim = X_train.shape[1]
hidden_dims = [128, 64, 32]
num_classes = len(np.unique(y))

model = NeuralNetwork(input_dim, hidden_dims, num_classes, activation='relu')
print(model)
```

### Model Summary

```python
# Count parameters
def count_parameters(model):
    """Count trainable parameters in the model"""
    return sum(p.numel() for p in model.parameters() if p.requires_grad)

total_params = count_parameters(model)
print(f"Total trainable parameters: {total_params:,}")
```

### Visualize Model Architecture

```python
# Print model architecture
print("Model Architecture:")
print("=" * 50)
for name, module in model.named_modules():
    if name:  # Skip empty name (root module)
        print(f"{name}: {module}")
```

## 3. Training Process

### Loss Function and Optimizer

```python
# Define loss function and optimizer
criterion = nn.CrossEntropyLoss()
optimizer = optim.Adam(model.parameters(), lr=0.001)

print(f"Loss function: {criterion}")
print(f"Optimizer: {optimizer}")
```

### Training Loop

```python
def train_model(model, train_loader, criterion, optimizer, num_epochs=50):
    """Train the neural network"""
    model.train()
    train_losses = []
    train_accuracies = []
    
    for epoch in range(num_epochs):
        running_loss = 0.0
        correct_predictions = 0
        total_samples = 0
        
        for batch_idx, (data, targets) in enumerate(train_loader):
            # Forward pass
            optimizer.zero_grad()
            outputs = model(data)
            loss = criterion(outputs, targets)
            
            # Backward pass
            loss.backward()
            optimizer.step()
            
            # Statistics
            running_loss += loss.item()
            _, predicted = torch.max(outputs.data, 1)
            total_samples += targets.size(0)
            correct_predictions += (predicted == targets).sum().item()
        
        # Calculate epoch metrics
        epoch_loss = running_loss / len(train_loader)
        epoch_accuracy = 100 * correct_predictions / total_samples
        
        train_losses.append(epoch_loss)
        train_accuracies.append(epoch_accuracy)
        
        if (epoch + 1) % 10 == 0:
            print(f'Epoch [{epoch+1}/{num_epochs}], '
                  f'Loss: {epoch_loss:.4f}, '
                  f'Accuracy: {epoch_accuracy:.2f}%')
    
    return train_losses, train_accuracies

# Train the model
print("Starting training...")
train_losses, train_accuracies = train_model(
    model, train_loader, criterion, optimizer, num_epochs=100
)
print("Training completed!")
```

## 4. Evaluation

### Test Model Performance

```python
def evaluate_model(model, test_loader):
    """Evaluate model on test set"""
    model.eval()
    test_loss = 0.0
    all_predictions = []
    all_targets = []
    
    with torch.no_grad():
        for data, targets in test_loader:
            outputs = model(data)
            loss = criterion(outputs, targets)
            test_loss += loss.item()
            
            _, predicted = torch.max(outputs.data, 1)
            all_predictions.extend(predicted.cpu().numpy())
            all_targets.extend(targets.cpu().numpy())
    
    test_loss /= len(test_loader)
    accuracy = accuracy_score(all_targets, all_predictions)
    
    return test_loss, accuracy, all_predictions, all_targets

# Evaluate model
test_loss, test_accuracy, predictions, targets = evaluate_model(model, test_loader)
print(f"\nTest Loss: {test_loss:.4f}")
print(f"Test Accuracy: {test_accuracy*100:.2f}%")
```

### Confusion Matrix

```python
# Generate confusion matrix
cm = confusion_matrix(targets, predictions)

# Plot confusion matrix
plt.figure(figsize=(8, 6))
sns.heatmap(cm, annot=True, fmt='d', cmap='Blues', 
            xticklabels=[f'Class {i}' for i in range(num_classes)],
            yticklabels=[f'Class {i}' for i in range(num_classes)])
plt.title('Confusion Matrix')
plt.ylabel('True Label')
plt.xlabel('Predicted Label')
plt.tight_layout()
plt.show()
```

### Classification Report

```python
# Print classification report
print("\nClassification Report:")
print("=" * 50)
print(classification_report(targets, predictions, 
                            target_names=[f'Class {i}' for i in range(num_classes)]))
```

## 5. Visualization

### Loss Curves

```python
# Plot training loss and accuracy
fig, (ax1, ax2) = plt.subplots(1, 2, figsize=(14, 5))

# Loss curve
ax1.plot(train_losses, label='Training Loss', color='blue')
ax1.set_xlabel('Epoch')
ax1.set_ylabel('Loss')
ax1.set_title('Training Loss Over Time')
ax1.legend()
ax1.grid(True, alpha=0.3)

# Accuracy curve
ax2.plot(train_accuracies, label='Training Accuracy', color='green')
ax2.set_xlabel('Epoch')
ax2.set_ylabel('Accuracy (%)')
ax2.set_title('Training Accuracy Over Time')
ax2.legend()
ax2.grid(True, alpha=0.3)

plt.tight_layout()
plt.show()
```

### Activation Functions Comparison

```python
# Visualize different activation functions
x = torch.linspace(-5, 5, 100)

fig, axes = plt.subplots(1, 3, figsize=(15, 4))

activations = {
    'ReLU': F.relu(x),
    'Sigmoid': torch.sigmoid(x),
    'Tanh': torch.tanh(x)
}

for idx, (name, y_vals) in enumerate(activations.items()):
    axes[idx].plot(x.numpy(), y_vals.numpy(), linewidth=2)
    axes[idx].set_title(f'{name} Activation Function')
    axes[idx].set_xlabel('Input')
    axes[idx].set_ylabel('Output')
    axes[idx].grid(True, alpha=0.3)
    axes[idx].axhline(y=0, color='k', linestyle='--', alpha=0.3)
    axes[idx].axvline(x=0, color='k', linestyle='--', alpha=0.3)

plt.tight_layout()
plt.show()
```

## 6. Model Comparison

### Compare Different Activation Functions

```python
def compare_activations(X_train, y_train, X_test, y_test, activations=['relu', 'sigmoid', 'tanh']):
    """Compare models with different activation functions"""
    results = {}
    
    for activation in activations:
        # Create model
        model = NeuralNetwork(input_dim, hidden_dims, num_classes, activation=activation)
        criterion = nn.CrossEntropyLoss()
        optimizer = optim.Adam(model.parameters(), lr=0.001)
        
        # Train
        train_dataset = TensorDataset(X_train_tensor, y_train_tensor)
        train_loader = DataLoader(train_dataset, batch_size=32, shuffle=True)
        
        _, _ = train_model(model, train_loader, criterion, optimizer, num_epochs=50)
        
        # Evaluate
        test_dataset = TensorDataset(X_test_tensor, y_test_tensor)
        test_loader = DataLoader(test_dataset, batch_size=32, shuffle=False)
        
        _, accuracy, _, _ = evaluate_model(model, test_loader)
        results[activation] = accuracy
    
    return results

# Compare activations (commented out to save time)
# activation_results = compare_activations(X_train_scaled, y_train, X_test_scaled, y_test)
# print("\nActivation Function Comparison:")
# for activation, accuracy in activation_results.items():
#     print(f"{activation.upper()}: {accuracy*100:.2f}%")
```

## Key Concepts Demonstrated
- Forward propagation
- Backpropagation
- Activation functions (ReLU, Sigmoid, Tanh)
- Gradient descent optimization
- Batch processing
- Model evaluation metrics

## Ethical Considerations
- Bias in training data
- Fairness in model predictions
- Transparency in decision-making
- Need for diverse and representative datasets
- Importance of model interpretability

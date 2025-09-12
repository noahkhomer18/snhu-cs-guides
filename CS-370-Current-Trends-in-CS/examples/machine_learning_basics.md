# CS-370 Machine Learning Basics

## 🎯 Purpose
Demonstrate fundamental machine learning concepts including supervised learning, neural networks, and data preprocessing.

## 📝 Machine Learning Examples

### Linear Regression with Scikit-learn
```python
# Linear Regression Example
import numpy as np
import matplotlib.pyplot as plt
from sklearn.linear_model import LinearRegression
from sklearn.model_selection import train_test_split
from sklearn.metrics import mean_squared_error, r2_score

# Generate sample data
np.random.seed(42)
X = np.random.randn(100, 1) * 10
y = 2 * X.flatten() + 3 + np.random.randn(100) * 2

# Split data into training and testing sets
X_train, X_test, y_train, y_test = train_test_split(X, y, test_size=0.2, random_state=42)

# Create and train the model
model = LinearRegression()
model.fit(X_train, y_train)

# Make predictions
y_pred = model.predict(X_test)

# Evaluate the model
mse = mean_squared_error(y_test, y_pred)
r2 = r2_score(y_test, y_pred)

print(f"Mean Squared Error: {mse:.2f}")
print(f"R² Score: {r2:.2f}")
print(f"Model coefficients: {model.coef_[0]:.2f}")
print(f"Model intercept: {model.intercept_:.2f}")

# Plot the results
plt.figure(figsize=(10, 6))
plt.scatter(X_test, y_test, color='blue', alpha=0.6, label='Actual')
plt.scatter(X_test, y_pred, color='red', alpha=0.6, label='Predicted')
plt.plot(X_test, model.predict(X_test), color='green', linewidth=2, label='Regression Line')
plt.xlabel('X')
plt.ylabel('y')
plt.title('Linear Regression Results')
plt.legend()
plt.show()
```

### Classification with Decision Trees
```python
# Decision Tree Classification
from sklearn.datasets import load_iris
from sklearn.tree import DecisionTreeClassifier, plot_tree
from sklearn.model_selection import train_test_split
from sklearn.metrics import classification_report, confusion_matrix
import matplotlib.pyplot as plt

# Load the iris dataset
iris = load_iris()
X, y = iris.data, iris.target

# Split the data
X_train, X_test, y_train, y_test = train_test_split(X, y, test_size=0.3, random_state=42)

# Create and train the decision tree
clf = DecisionTreeClassifier(max_depth=3, random_state=42)
clf.fit(X_train, y_train)

# Make predictions
y_pred = clf.predict(X_test)

# Evaluate the model
print("Classification Report:")
print(classification_report(y_test, y_pred, target_names=iris.target_names))

print("\nConfusion Matrix:")
print(confusion_matrix(y_test, y_pred))

# Visualize the decision tree
plt.figure(figsize=(12, 8))
plot_tree(clf, feature_names=iris.feature_names, class_names=iris.target_names, filled=True)
plt.title("Decision Tree Visualization")
plt.show()
```

### Neural Network with TensorFlow/Keras
```python
# Neural Network with Keras
import tensorflow as tf
from tensorflow import keras
from tensorflow.keras import layers
import numpy as np
import matplotlib.pyplot as plt

# Generate sample data
np.random.seed(42)
X = np.random.randn(1000, 2)
y = (X[:, 0] + X[:, 1] > 0).astype(int)

# Split the data
X_train, X_test, y_train, y_test = train_test_split(X, y, test_size=0.2, random_state=42)

# Create a neural network model
model = keras.Sequential([
    layers.Dense(64, activation='relu', input_shape=(2,)),
    layers.Dropout(0.2),
    layers.Dense(32, activation='relu'),
    layers.Dropout(0.2),
    layers.Dense(1, activation='sigmoid')
])

# Compile the model
model.compile(optimizer='adam',
              loss='binary_crossentropy',
              metrics=['accuracy'])

# Train the model
history = model.fit(X_train, y_train, 
                    epochs=100, 
                    batch_size=32, 
                    validation_split=0.2,
                    verbose=0)

# Evaluate the model
test_loss, test_accuracy = model.evaluate(X_test, y_test, verbose=0)
print(f"Test Accuracy: {test_accuracy:.4f}")

# Plot training history
plt.figure(figsize=(12, 4))

plt.subplot(1, 2, 1)
plt.plot(history.history['loss'], label='Training Loss')
plt.plot(history.history['val_loss'], label='Validation Loss')
plt.title('Model Loss')
plt.xlabel('Epoch')
plt.ylabel('Loss')
plt.legend()

plt.subplot(1, 2, 2)
plt.plot(history.history['accuracy'], label='Training Accuracy')
plt.plot(history.history['val_accuracy'], label='Validation Accuracy')
plt.title('Model Accuracy')
plt.xlabel('Epoch')
plt.ylabel('Accuracy')
plt.legend()

plt.tight_layout()
plt.show()
```

### Clustering with K-Means
```python
# K-Means Clustering
from sklearn.cluster import KMeans
from sklearn.datasets import make_blobs
import matplotlib.pyplot as plt
import numpy as np

# Generate sample data
X, y_true = make_blobs(n_samples=300, centers=4, cluster_std=0.60, random_state=42)

# Apply K-Means clustering
kmeans = KMeans(n_clusters=4, random_state=42)
y_pred = kmeans.fit_predict(X)

# Plot the results
plt.figure(figsize=(12, 5))

plt.subplot(1, 2, 1)
plt.scatter(X[:, 0], X[:, 1], c=y_true, cmap='viridis', alpha=0.7)
plt.title('True Clusters')
plt.xlabel('Feature 1')
plt.ylabel('Feature 2')

plt.subplot(1, 2, 2)
plt.scatter(X[:, 0], X[:, 1], c=y_pred, cmap='viridis', alpha=0.7)
plt.scatter(kmeans.cluster_centers_[:, 0], kmeans.cluster_centers_[:, 1], 
           c='red', marker='x', s=200, linewidths=3)
plt.title('K-Means Clusters')
plt.xlabel('Feature 1')
plt.ylabel('Feature 2')

plt.tight_layout()
plt.show()

# Print cluster centers
print("Cluster Centers:")
for i, center in enumerate(kmeans.cluster_centers_):
    print(f"Cluster {i}: {center}")
```

### Natural Language Processing
```python
# Text Classification with NLP
from sklearn.feature_extraction.text import TfidfVectorizer
from sklearn.naive_bayes import MultinomialNB
from sklearn.model_selection import train_test_split
from sklearn.metrics import classification_report
import pandas as pd

# Sample text data
texts = [
    "I love this product, it's amazing!",
    "This is terrible, waste of money.",
    "Great quality, highly recommend.",
    "Poor customer service, very disappointed.",
    "Excellent value for money.",
    "Not worth the price, very cheap quality.",
    "Outstanding performance, love it!",
    "Worst purchase ever, avoid this.",
    "Good product, works as expected.",
    "Terrible experience, would not buy again."
]

labels = [1, 0, 1, 0, 1, 0, 1, 0, 1, 0]  # 1 for positive, 0 for negative

# Create DataFrame
df = pd.DataFrame({'text': texts, 'label': labels})

# Split the data
X_train, X_test, y_train, y_test = train_test_split(df['text'], df['label'], 
                                                    test_size=0.3, random_state=42)

# Vectorize the text data
vectorizer = TfidfVectorizer(max_features=1000, stop_words='english')
X_train_vectorized = vectorizer.fit_transform(X_train)
X_test_vectorized = vectorizer.transform(X_test)

# Train the model
classifier = MultinomialNB()
classifier.fit(X_train_vectorized, y_train)

# Make predictions
y_pred = classifier.predict(X_test_vectorized)

# Evaluate the model
print("Text Classification Results:")
print(classification_report(y_test, y_pred, target_names=['Negative', 'Positive']))

# Test with new text
new_text = "This product exceeded my expectations!"
new_text_vectorized = vectorizer.transform([new_text])
prediction = classifier.predict(new_text_vectorized)[0]
sentiment = "Positive" if prediction == 1 else "Negative"
print(f"\nNew text: '{new_text}'")
print(f"Predicted sentiment: {sentiment}")
```

### Computer Vision with OpenCV
```python
# Computer Vision with OpenCV
import cv2
import numpy as np
import matplotlib.pyplot as plt

def detect_edges(image_path):
    """Detect edges in an image using Canny edge detection"""
    # Read the image
    image = cv2.imread(image_path)
    if image is None:
        print("Error: Could not load image")
        return None
    
    # Convert to grayscale
    gray = cv2.cvtColor(image, cv2.COLOR_BGR2GRAY)
    
    # Apply Gaussian blur
    blurred = cv2.GaussianBlur(gray, (5, 5), 0)
    
    # Apply Canny edge detection
    edges = cv2.Canny(blurred, 50, 150)
    
    return image, gray, edges

def detect_faces(image_path):
    """Detect faces in an image using Haar cascades"""
    # Load the image
    image = cv2.imread(image_path)
    if image is None:
        print("Error: Could not load image")
        return None
    
    # Load the Haar cascade for face detection
    face_cascade = cv2.CascadeClassifier(cv2.data.haarcascades + 'haarcascade_frontalface_default.xml')
    
    # Convert to grayscale
    gray = cv2.cvtColor(image, cv2.COLOR_BGR2GRAY)
    
    # Detect faces
    faces = face_cascade.detectMultiScale(gray, 1.1, 4)
    
    # Draw rectangles around faces
    for (x, y, w, h) in faces:
        cv2.rectangle(image, (x, y), (x+w, y+h), (255, 0, 0), 2)
    
    return image, len(faces)

def create_simple_image():
    """Create a simple test image"""
    # Create a white image
    img = np.ones((300, 300, 3), dtype=np.uint8) * 255
    
    # Draw a circle
    cv2.circle(img, (150, 150), 50, (0, 0, 255), -1)
    
    # Draw a rectangle
    cv2.rectangle(img, (50, 50), (100, 100), (0, 255, 0), -1)
    
    # Draw a line
    cv2.line(img, (200, 200), (250, 250), (255, 0, 0), 3)
    
    # Add text
    cv2.putText(img, 'OpenCV Test', (50, 250), cv2.FONT_HERSHEY_SIMPLEX, 1, (0, 0, 0), 2)
    
    return img

# Example usage
def main():
    # Create a test image
    test_image = create_simple_image()
    cv2.imwrite('test_image.jpg', test_image)
    
    # Detect edges
    original, gray, edges = detect_edges('test_image.jpg')
    
    if original is not None:
        # Display results
        plt.figure(figsize=(15, 5))
        
        plt.subplot(1, 3, 1)
        plt.imshow(cv2.cvtColor(original, cv2.COLOR_BGR2RGB))
        plt.title('Original Image')
        plt.axis('off')
        
        plt.subplot(1, 3, 2)
        plt.imshow(gray, cmap='gray')
        plt.title('Grayscale')
        plt.axis('off')
        
        plt.subplot(1, 3, 3)
        plt.imshow(edges, cmap='gray')
        plt.title('Edge Detection')
        plt.axis('off')
        
        plt.tight_layout()
        plt.show()

if __name__ == "__main__":
    main()
```

### Deep Learning with PyTorch
```python
# Deep Learning with PyTorch
import torch
import torch.nn as nn
import torch.optim as optim
import torch.nn.functional as F
from torch.utils.data import DataLoader, TensorDataset
import numpy as np
import matplotlib.pyplot as plt

# Define a simple neural network
class SimpleNet(nn.Module):
    def __init__(self, input_size, hidden_size, output_size):
        super(SimpleNet, self).__init__()
        self.fc1 = nn.Linear(input_size, hidden_size)
        self.fc2 = nn.Linear(hidden_size, hidden_size)
        self.fc3 = nn.Linear(hidden_size, output_size)
        self.dropout = nn.Dropout(0.2)
    
    def forward(self, x):
        x = F.relu(self.fc1(x))
        x = self.dropout(x)
        x = F.relu(self.fc2(x))
        x = self.dropout(x)
        x = self.fc3(x)
        return x

# Generate sample data
def generate_data(n_samples=1000):
    X = torch.randn(n_samples, 2)
    y = ((X[:, 0] + X[:, 1]) > 0).float().unsqueeze(1)
    return X, y

# Training function
def train_model(model, train_loader, test_loader, epochs=100):
    criterion = nn.BCEWithLogitsLoss()
    optimizer = optim.Adam(model.parameters(), lr=0.001)
    
    train_losses = []
    test_losses = []
    
    for epoch in range(epochs):
        # Training
        model.train()
        train_loss = 0
        for batch_X, batch_y in train_loader:
            optimizer.zero_grad()
            outputs = model(batch_X)
            loss = criterion(outputs, batch_y)
            loss.backward()
            optimizer.step()
            train_loss += loss.item()
        
        # Testing
        model.eval()
        test_loss = 0
        with torch.no_grad():
            for batch_X, batch_y in test_loader:
                outputs = model(batch_X)
                loss = criterion(outputs, batch_y)
                test_loss += loss.item()
        
        train_losses.append(train_loss / len(train_loader))
        test_losses.append(test_loss / len(test_loader))
        
        if epoch % 20 == 0:
            print(f'Epoch {epoch}, Train Loss: {train_losses[-1]:.4f}, Test Loss: {test_losses[-1]:.4f}')
    
    return train_losses, test_losses

# Main execution
def main():
    # Generate data
    X, y = generate_data(1000)
    
    # Split data
    train_size = int(0.8 * len(X))
    X_train, X_test = X[:train_size], X[train_size:]
    y_train, y_test = y[:train_size], y[train_size:]
    
    # Create data loaders
    train_dataset = TensorDataset(X_train, y_train)
    test_dataset = TensorDataset(X_test, y_test)
    train_loader = DataLoader(train_dataset, batch_size=32, shuffle=True)
    test_loader = DataLoader(test_dataset, batch_size=32, shuffle=False)
    
    # Create model
    model = SimpleNet(input_size=2, hidden_size=64, output_size=1)
    
    # Train model
    train_losses, test_losses = train_model(model, train_loader, test_loader)
    
    # Plot training history
    plt.figure(figsize=(10, 6))
    plt.plot(train_losses, label='Training Loss')
    plt.plot(test_losses, label='Test Loss')
    plt.xlabel('Epoch')
    plt.ylabel('Loss')
    plt.title('Training History')
    plt.legend()
    plt.show()
    
    # Evaluate model
    model.eval()
    with torch.no_grad():
        test_outputs = model(X_test)
        predictions = (torch.sigmoid(test_outputs) > 0.5).float()
        accuracy = (predictions == y_test).float().mean()
        print(f'Test Accuracy: {accuracy:.4f}')

if __name__ == "__main__":
    main()
```

## 🔍 Machine Learning Concepts
- **Supervised Learning**: Learning from labeled data
- **Unsupervised Learning**: Finding patterns in unlabeled data
- **Neural Networks**: Multi-layer perceptrons for complex patterns
- **Feature Engineering**: Preparing data for machine learning
- **Model Evaluation**: Measuring model performance
- **Cross-validation**: Robust model evaluation
- **Overfitting**: When models memorize training data
- **Regularization**: Techniques to prevent overfitting

## 💡 Learning Points
- **Data preprocessing** is crucial for ML success
- **Feature selection** improves model performance
- **Cross-validation** provides reliable performance estimates
- **Neural networks** can learn complex patterns
- **Regularization** prevents overfitting
- **Model evaluation** metrics depend on the problem type
- **Hyperparameter tuning** optimizes model performance
- **Ensemble methods** often improve predictions

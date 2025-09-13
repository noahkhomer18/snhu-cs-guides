# CS-370 AI/ML Tools Setup Guide

## 🎯 Purpose
Complete setup guide for artificial intelligence and machine learning development using Python, TensorFlow, PyTorch, and data science tools.

## 🐍 Python Data Science Stack

### Core Installation
```bash
# Install Python (3.8+ recommended)
# Download from: https://www.python.org/downloads/

# Verify installation
python --version
pip --version

# Upgrade pip
python -m pip install --upgrade pip
```

### Essential Data Science Packages
```bash
# Create virtual environment
python -m venv cs370_ml_env

# Activate environment (Windows)
cs370_ml_env\Scripts\activate

# Activate environment (Mac/Linux)
source cs370_ml_env/bin/activate

# Install core packages
pip install numpy pandas matplotlib seaborn scikit-learn

# Install Jupyter Notebook
pip install jupyter notebook jupyterlab

# Install additional data science tools
pip install plotly bokeh altair
pip install requests beautifulsoup4
pip install opencv-python pillow
```

### Jupyter Notebook Setup
```bash
# Start Jupyter Notebook
jupyter notebook

# Start JupyterLab (recommended)
jupyter lab

# Create new notebook
# File -> New -> Notebook -> Python 3
```

**Jupyter Extensions:**
```bash
# Install Jupyter extensions
pip install jupyter_contrib_nbextensions
jupyter contrib nbextension install --user

# Install JupyterLab extensions
pip install jupyterlab-git
pip install jupyterlab-lsp
pip install jupyterlab-code-formatter
```

## 🤖 Machine Learning Frameworks

### Scikit-learn
**Installation:**
```bash
pip install scikit-learn
```

**Essential Imports:**
```python
# Core ML imports
from sklearn.model_selection import train_test_split
from sklearn.preprocessing import StandardScaler, LabelEncoder
from sklearn.linear_model import LinearRegression, LogisticRegression
from sklearn.ensemble import RandomForestClassifier, GradientBoostingRegressor
from sklearn.metrics import accuracy_score, classification_report, confusion_matrix
from sklearn.cluster import KMeans
from sklearn.decomposition import PCA

# Data manipulation
import pandas as pd
import numpy as np

# Visualization
import matplotlib.pyplot as plt
import seaborn as sns
```

### TensorFlow & Keras
**Installation:**
```bash
# Install TensorFlow
pip install tensorflow

# Install TensorFlow with GPU support (if you have CUDA)
pip install tensorflow-gpu

# Install additional TensorFlow tools
pip install tensorflow-datasets
pip install tensorflow-hub
```

**Verify Installation:**
```python
import tensorflow as tf
print("TensorFlow version:", tf.__version__)
print("GPU available:", tf.config.list_physical_devices('GPU'))

# Test basic functionality
x = tf.constant([[1, 2], [3, 4]])
print("Tensor:", x)
```

**Keras Setup:**
```python
from tensorflow import keras
from tensorflow.keras import layers, models, optimizers, callbacks

# Create simple model
model = keras.Sequential([
    layers.Dense(64, activation='relu', input_shape=(784,)),
    layers.Dropout(0.2),
    layers.Dense(10, activation='softmax')
])

model.compile(optimizer='adam',
              loss='sparse_categorical_crossentropy',
              metrics=['accuracy'])
```

### PyTorch
**Installation:**
```bash
# Install PyTorch (CPU version)
pip install torch torchvision torchaudio

# Install PyTorch with CUDA support
pip install torch torchvision torchaudio --index-url https://download.pytorch.org/whl/cu118
```

**Verify Installation:**
```python
import torch
import torch.nn as nn
import torch.optim as optim

print("PyTorch version:", torch.__version__)
print("CUDA available:", torch.cuda.is_available())

# Test basic functionality
x = torch.tensor([[1, 2], [3, 4]], dtype=torch.float32)
print("Tensor:", x)
```

**PyTorch Neural Network Example:**
```python
class SimpleNet(nn.Module):
    def __init__(self, input_size, hidden_size, output_size):
        super(SimpleNet, self).__init__()
        self.fc1 = nn.Linear(input_size, hidden_size)
        self.fc2 = nn.Linear(hidden_size, output_size)
        self.relu = nn.ReLU()
    
    def forward(self, x):
        x = self.relu(self.fc1(x))
        x = self.fc2(x)
        return x

# Create model
model = SimpleNet(784, 128, 10)
criterion = nn.CrossEntropyLoss()
optimizer = optim.Adam(model.parameters(), lr=0.001)
```

## 📊 Data Visualization Tools

### Matplotlib & Seaborn
```python
import matplotlib.pyplot as plt
import seaborn as sns

# Set style
plt.style.use('seaborn-v0_8')
sns.set_palette("husl")

# Create plots
fig, axes = plt.subplots(2, 2, figsize=(12, 10))

# Scatter plot
axes[0, 0].scatter(x, y, alpha=0.6)
axes[0, 0].set_title('Scatter Plot')

# Histogram
axes[0, 1].hist(data, bins=30, alpha=0.7)
axes[0, 1].set_title('Histogram')

# Box plot
sns.boxplot(data=df, ax=axes[1, 0])
axes[1, 0].set_title('Box Plot')

# Heatmap
sns.heatmap(correlation_matrix, annot=True, ax=axes[1, 1])
axes[1, 1].set_title('Correlation Heatmap')

plt.tight_layout()
plt.show()
```

### Plotly (Interactive Visualizations)
```bash
pip install plotly dash
```

```python
import plotly.express as px
import plotly.graph_objects as go

# Interactive scatter plot
fig = px.scatter(df, x='feature1', y='feature2', color='target',
                 title='Interactive Scatter Plot')
fig.show()

# 3D scatter plot
fig = px.scatter_3d(df, x='x', y='y', z='z', color='cluster')
fig.show()

# Dashboard with Dash
import dash
from dash import dcc, html

app = dash.Dash(__name__)
app.layout = html.Div([
    html.H1("ML Dashboard"),
    dcc.Graph(figure=fig)
])

if __name__ == '__main__':
    app.run_server(debug=True)
```

## 🧠 Deep Learning Tools

### OpenCV (Computer Vision)
```bash
pip install opencv-python
pip install opencv-contrib-python
```

```python
import cv2
import numpy as np

# Load image
img = cv2.imread('image.jpg')
img_rgb = cv2.cvtColor(img, cv2.COLOR_BGR2RGB)

# Image processing
gray = cv2.cvtColor(img, cv2.COLOR_BGR2GRAY)
blurred = cv2.GaussianBlur(gray, (5, 5), 0)
edges = cv2.Canny(blurred, 50, 150)

# Face detection
face_cascade = cv2.CascadeClassifier(cv2.data.haarcascades + 'haarcascade_frontalface_default.xml')
faces = face_cascade.detectMultiScale(gray, 1.1, 4)

# Draw rectangles around faces
for (x, y, w, h) in faces:
    cv2.rectangle(img, (x, y), (x+w, y+h), (255, 0, 0), 2)

cv2.imshow('Image', img)
cv2.waitKey(0)
cv2.destroyAllWindows()
```

### Natural Language Processing
```bash
pip install nltk spacy transformers
pip install textblob wordcloud
```

```python
import nltk
import spacy
from transformers import pipeline

# Download NLTK data
nltk.download('punkt')
nltk.download('stopwords')
nltk.download('vader_lexicon')

# Load spaCy model
nlp = spacy.load('en_core_web_sm')

# Text processing
text = "This is a sample text for NLP processing."
doc = nlp(text)

# Extract entities
for ent in doc.ents:
    print(ent.text, ent.label_)

# Sentiment analysis with transformers
classifier = pipeline('sentiment-analysis')
result = classifier("I love this product!")
print(result)
```

## 🔬 Reinforcement Learning

### OpenAI Gym
```bash
pip install gym
pip install gym[atari]
pip install stable-baselines3
```

```python
import gym
import numpy as np
from stable_baselines3 import PPO, DQN

# Create environment
env = gym.make('CartPole-v1')

# Random agent
observation = env.reset()
for _ in range(1000):
    action = env.action_space.sample()
    observation, reward, done, info = env.step(action)
    if done:
        observation = env.reset()

# Train PPO agent
model = PPO('MlpPolicy', env, verbose=1)
model.learn(total_timesteps=10000)

# Test trained agent
obs = env.reset()
for i in range(1000):
    action, _states = model.predict(obs, deterministic=True)
    obs, reward, done, info = env.step(action)
    if done:
        obs = env.reset()
```

## ☁️ Cloud ML Platforms

### Google Colab
**Setup:**
1. Go to https://colab.research.google.com/
2. Sign in with Google account
3. Create new notebook
4. Enable GPU: Runtime -> Change runtime type -> GPU

**Colab Features:**
```python
# Check GPU availability
import torch
print("CUDA available:", torch.cuda.is_available())
print("GPU count:", torch.cuda.device_count())

# Mount Google Drive
from google.colab import drive
drive.mount('/content/drive')

# Install packages
!pip install transformers datasets

# Download files
!wget https://example.com/dataset.csv
```

### Kaggle
**Setup:**
1. Sign up at https://www.kaggle.com/
2. Download Kaggle API key
3. Install Kaggle CLI

```bash
pip install kaggle
# Place API key in ~/.kaggle/kaggle.json
```

```python
# Download datasets
from kaggle.api.kaggle_api_extended import KaggleApi
api = KaggleApi()
api.authenticate()

# Download dataset
api.dataset_download_files('dataset-name', path='./data', unzip=True)
```

## 🛠️ Development Environment

### VS Code Setup
**Essential Extensions:**
- **Python**: Python language support
- **Jupyter**: Jupyter notebook support
- **Python Docstring Generator**: Auto-generate docstrings
- **Python Indent**: Correct Python indentation
- **Python Test Explorer**: Test discovery and execution
- **GitLens**: Git integration
- **Remote - SSH**: Remote development

**VS Code Settings:**
```json
{
    "python.defaultInterpreterPath": "./cs370_ml_env/Scripts/python.exe",
    "python.terminal.activateEnvironment": true,
    "jupyter.askForKernelRestart": false,
    "python.linting.enabled": true,
    "python.linting.pylintEnabled": true,
    "python.formatting.provider": "black"
}
```

### JupyterLab Extensions
```bash
# Install JupyterLab extensions
pip install jupyterlab-git
pip install jupyterlab-lsp
pip install jupyterlab-code-formatter
pip install jupyterlab-drawio
pip install jupyterlab-plotly
```

## 📊 Data Management

### Data Storage
```python
# HDF5 for large datasets
import h5py
import pandas as pd

# Save data
with h5py.File('data.h5', 'w') as f:
    f.create_dataset('features', data=features)
    f.create_dataset('labels', data=labels)

# Load data
with h5py.File('data.h5', 'r') as f:
    features = f['features'][:]
    labels = f['labels'][:]

# Parquet for structured data
df.to_parquet('data.parquet')
df = pd.read_parquet('data.parquet')
```

### Model Persistence
```python
# Save scikit-learn models
import joblib
joblib.dump(model, 'model.pkl')
model = joblib.load('model.pkl')

# Save TensorFlow models
model.save('my_model')
loaded_model = tf.keras.models.load_model('my_model')

# Save PyTorch models
torch.save(model.state_dict(), 'model.pth')
model.load_state_dict(torch.load('model.pth'))
```

## 🧪 Testing & Validation

### Unit Testing
```bash
pip install pytest pytest-cov
```

```python
# test_ml_utils.py
import pytest
import numpy as np
from sklearn.linear_model import LinearRegression

def test_linear_regression():
    X = np.array([[1], [2], [3], [4]])
    y = np.array([2, 4, 6, 8])
    
    model = LinearRegression()
    model.fit(X, y)
    
    predictions = model.predict([[5]])
    assert abs(predictions[0] - 10) < 0.1

# Run tests
# pytest test_ml_utils.py -v
```

### Model Validation
```python
from sklearn.model_selection import cross_val_score, validation_curve

# Cross-validation
scores = cross_val_score(model, X, y, cv=5)
print("Cross-validation scores:", scores)
print("Mean score:", scores.mean())

# Learning curves
train_sizes, train_scores, val_scores = validation_curve(
    model, X, y, param_name='max_depth', param_range=[1, 3, 5, 7, 9], cv=5
)
```

## 📚 Learning Resources

### Online Courses
- **Coursera ML Course**: https://www.coursera.org/learn/machine-learning
- **Fast.ai**: https://www.fast.ai/
- **Deep Learning Specialization**: https://www.coursera.org/specializations/deep-learning
- **CS229 Stanford**: http://cs229.stanford.edu/

### Books
- **Hands-On Machine Learning**: https://www.oreilly.com/library/view/hands-on-machine-learning/9781492032632/
- **Deep Learning**: https://www.deeplearningbook.org/
- **Pattern Recognition and Machine Learning**: https://www.microsoft.com/en-us/research/uploads/prod/2006/01/Bishop-Pattern-Recognition-and-Machine-Learning-2006.pdf

### Datasets
- **Kaggle Datasets**: https://www.kaggle.com/datasets
- **UCI ML Repository**: https://archive.ics.uci.edu/ml/index.php
- **Google Dataset Search**: https://datasetsearch.research.google.com/
- **Papers with Code**: https://paperswithcode.com/datasets

### Documentation
- **Scikit-learn**: https://scikit-learn.org/stable/
- **TensorFlow**: https://www.tensorflow.org/
- **PyTorch**: https://pytorch.org/
- **Pandas**: https://pandas.pydata.org/
- **NumPy**: https://numpy.org/

## 🎯 CS-370 Project Checklist

### Phase 1: Environment Setup
- [ ] Install Python and create virtual environment
- [ ] Install core data science packages
- [ ] Set up Jupyter Notebook/Lab
- [ ] Configure VS Code with ML extensions

### Phase 2: Data Preparation
- [ ] Load and explore dataset
- [ ] Perform data cleaning and preprocessing
- [ ] Create visualizations and EDA
- [ ] Split data into train/validation/test sets

### Phase 3: Model Development
- [ ] Implement baseline models
- [ ] Experiment with different algorithms
- [ ] Tune hyperparameters
- [ ] Implement cross-validation

### Phase 4: Deep Learning
- [ ] Set up TensorFlow/PyTorch
- [ ] Design neural network architecture
- [ ] Train deep learning models
- [ ] Implement transfer learning (if applicable)

### Phase 5: Evaluation & Deployment
- [ ] Evaluate model performance
- [ ] Create model persistence
- [ ] Build prediction pipeline
- [ ] Document results and methodology

## 💡 Pro Tips

1. **Start Simple**: Begin with basic models before complex ones
2. **Data First**: Spend time on data quality and preprocessing
3. **Visualize Everything**: Create plots to understand your data
4. **Version Control**: Use Git for code and DVC for data
5. **Document Experiments**: Keep track of hyperparameters and results
6. **Use Virtual Environments**: Isolate project dependencies
7. **Test Your Code**: Write unit tests for ML functions
8. **Monitor Performance**: Track training metrics and model performance
9. **Reproducibility**: Set random seeds for consistent results
10. **Stay Updated**: Follow ML research and new tools

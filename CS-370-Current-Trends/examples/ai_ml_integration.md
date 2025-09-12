# CS-370 AI/ML Integration in Software

## 🎯 Purpose
Demonstrate integration of artificial intelligence and machine learning in modern software applications.

## 📝 AI/ML Integration Examples

### Machine Learning with Python
```python
import numpy as np
import pandas as pd
from sklearn.model_selection import train_test_split
from sklearn.ensemble import RandomForestClassifier
from sklearn.metrics import accuracy_score, classification_report
import joblib

class MLPredictor:
    def __init__(self):
        self.model = RandomForestClassifier(n_estimators=100, random_state=42)
        self.is_trained = False
    
    def load_data(self, file_path):
        """Load and preprocess data"""
        data = pd.read_csv(file_path)
        
        # Handle missing values
        data = data.fillna(data.mean())
        
        # Encode categorical variables
        categorical_columns = data.select_dtypes(include=['object']).columns
        for col in categorical_columns:
            data[col] = pd.Categorical(data[col]).codes
        
        return data
    
    def train_model(self, X, y):
        """Train the machine learning model"""
        X_train, X_test, y_train, y_test = train_test_split(
            X, y, test_size=0.2, random_state=42
        )
        
        self.model.fit(X_train, y_train)
        
        # Evaluate model
        y_pred = self.model.predict(X_test)
        accuracy = accuracy_score(y_test, y_pred)
        
        print(f"Model Accuracy: {accuracy:.2f}")
        print("\nClassification Report:")
        print(classification_report(y_test, y_pred))
        
        self.is_trained = True
        return accuracy
    
    def predict(self, features):
        """Make predictions on new data"""
        if not self.is_trained:
            raise ValueError("Model must be trained before making predictions")
        
        return self.model.predict(features)
    
    def save_model(self, file_path):
        """Save trained model to file"""
        joblib.dump(self.model, file_path)
        print(f"Model saved to {file_path}")
    
    def load_model(self, file_path):
        """Load pre-trained model from file"""
        self.model = joblib.load(file_path)
        self.is_trained = True
        print(f"Model loaded from {file_path}")

# Example usage
if __name__ == "__main__":
    predictor = MLPredictor()
    
    # Load and prepare data
    data = predictor.load_data('customer_data.csv')
    X = data.drop('target', axis=1)
    y = data['target']
    
    # Train model
    accuracy = predictor.train_model(X, y)
    
    # Save model
    predictor.save_model('customer_model.pkl')
    
    # Make predictions
    new_customer = [[25, 50000, 2, 1]]  # Example features
    prediction = predictor.predict(new_customer)
    print(f"Prediction for new customer: {prediction[0]}")
```

### Natural Language Processing
```python
import nltk
from nltk.sentiment import SentimentIntensityAnalyzer
from nltk.tokenize import word_tokenize
from nltk.corpus import stopwords
import re

class TextAnalyzer:
    def __init__(self):
        self.sia = SentimentIntensityAnalyzer()
        self.stop_words = set(stopwords.words('english'))
    
    def preprocess_text(self, text):
        """Clean and preprocess text"""
        # Convert to lowercase
        text = text.lower()
        
        # Remove special characters and digits
        text = re.sub(r'[^a-zA-Z\s]', '', text)
        
        # Tokenize
        tokens = word_tokenize(text)
        
        # Remove stopwords
        tokens = [word for word in tokens if word not in self.stop_words]
        
        return ' '.join(tokens)
    
    def analyze_sentiment(self, text):
        """Analyze sentiment of text"""
        scores = self.sia.polarity_scores(text)
        
        if scores['compound'] >= 0.05:
            sentiment = 'Positive'
        elif scores['compound'] <= -0.05:
            sentiment = 'Negative'
        else:
            sentiment = 'Neutral'
        
        return {
            'sentiment': sentiment,
            'scores': scores
        }
    
    def extract_keywords(self, text, num_keywords=5):
        """Extract important keywords from text"""
        processed_text = self.preprocess_text(text)
        tokens = word_tokenize(processed_text)
        
        # Simple frequency-based keyword extraction
        word_freq = {}
        for word in tokens:
            if len(word) > 3:  # Filter short words
                word_freq[word] = word_freq.get(word, 0) + 1
        
        # Sort by frequency and return top keywords
        keywords = sorted(word_freq.items(), key=lambda x: x[1], reverse=True)
        return [word for word, freq in keywords[:num_keywords]]

# Example usage
analyzer = TextAnalyzer()

text = "I love this product! It's amazing and works perfectly. Highly recommended!"
sentiment_result = analyzer.analyze_sentiment(text)
keywords = analyzer.extract_keywords(text)

print(f"Sentiment: {sentiment_result['sentiment']}")
print(f"Keywords: {keywords}")
```

### Computer Vision with OpenCV
```python
import cv2
import numpy as np
from tensorflow.keras.models import load_model

class ImageProcessor:
    def __init__(self, model_path=None):
        self.model = None
        if model_path:
            self.model = load_model(model_path)
    
    def detect_faces(self, image_path):
        """Detect faces in an image"""
        # Load the image
        image = cv2.imread(image_path)
        gray = cv2.cvtColor(image, cv2.COLOR_BGR2GRAY)
        
        # Load face cascade classifier
        face_cascade = cv2.CascadeClassifier(cv2.data.haarcascades + 'haarcascade_frontalface_default.xml')
        
        # Detect faces
        faces = face_cascade.detectMultiScale(gray, 1.1, 4)
        
        # Draw rectangles around faces
        for (x, y, w, h) in faces:
            cv2.rectangle(image, (x, y), (x+w, y+h), (255, 0, 0), 2)
        
        return image, len(faces)
    
    def classify_image(self, image_path):
        """Classify image using pre-trained model"""
        if not self.model:
            raise ValueError("Model not loaded")
        
        # Load and preprocess image
        image = cv2.imread(image_path)
        image = cv2.resize(image, (224, 224))
        image = image.astype('float32') / 255.0
        image = np.expand_dims(image, axis=0)
        
        # Make prediction
        prediction = self.model.predict(image)
        class_index = np.argmax(prediction[0])
        
        # Map to class names (example)
        class_names = ['Cat', 'Dog', 'Bird', 'Fish']
        return class_names[class_index], prediction[0][class_index]

# Example usage
processor = ImageProcessor('image_classifier.h5')

# Detect faces
image_with_faces, face_count = processor.detect_faces('photo.jpg')
print(f"Found {face_count} faces")

# Classify image
class_name, confidence = processor.classify_image('animal.jpg')
print(f"Predicted class: {class_name} (confidence: {confidence:.2f})")
```

### AI-Powered Chatbot
```python
import json
import random
from datetime import datetime

class Chatbot:
    def __init__(self):
        self.responses = {
            'greeting': [
                "Hello! How can I help you today?",
                "Hi there! What can I do for you?",
                "Good to see you! How may I assist?"
            ],
            'goodbye': [
                "Goodbye! Have a great day!",
                "See you later!",
                "Take care!"
            ],
            'help': [
                "I can help you with various tasks. What do you need?",
                "I'm here to assist you. What would you like to know?",
                "How can I be of service today?"
            ],
            'default': [
                "I'm not sure I understand. Can you rephrase that?",
                "Could you provide more details?",
                "I'm still learning. Can you help me understand?"
            ]
        }
    
    def process_input(self, user_input):
        """Process user input and generate response"""
        user_input = user_input.lower().strip()
        
        # Simple keyword matching
        if any(word in user_input for word in ['hello', 'hi', 'hey']):
            return random.choice(self.responses['greeting'])
        elif any(word in user_input for word in ['bye', 'goodbye', 'see you']):
            return random.choice(self.responses['goodbye'])
        elif any(word in user_input for word in ['help', 'assist', 'support']):
            return random.choice(self.responses['help'])
        else:
            return random.choice(self.responses['default'])
    
    def chat(self):
        """Main chat loop"""
        print("Chatbot: Hello! I'm your AI assistant. Type 'quit' to exit.")
        
        while True:
            user_input = input("You: ")
            
            if user_input.lower() == 'quit':
                print("Chatbot: Goodbye!")
                break
            
            response = self.process_input(user_input)
            print(f"Chatbot: {response}")

# Example usage
if __name__ == "__main__":
    chatbot = Chatbot()
    chatbot.chat()
```

## 🔍 AI/ML Integration Concepts
- **Machine Learning**: Pattern recognition and prediction
- **Natural Language Processing**: Text analysis and understanding
- **Computer Vision**: Image processing and recognition
- **Chatbots**: Conversational AI interfaces
- **Model Deployment**: Integrating ML models into applications

## 💡 Learning Points
- AI/ML integration enhances software capabilities
- Data preprocessing is crucial for model performance
- Pre-trained models accelerate development
- Real-time processing requires efficient algorithms
- User experience design is important for AI features

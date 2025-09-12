# CS-370 Artificial Intelligence Applications

## 🎯 Purpose
Demonstrate practical AI applications including chatbots, recommendation systems, and computer vision projects.

## 📝 AI Application Examples

### Chatbot with Natural Language Processing
```python
# Simple Chatbot with NLP
import nltk
import numpy as np
from sklearn.feature_extraction.text import TfidfVectorizer
from sklearn.metrics.pairwise import cosine_similarity
import random
import re

class SimpleChatbot:
    def __init__(self):
        self.responses = {
            'greeting': [
                "Hello! How can I help you today?",
                "Hi there! What can I do for you?",
                "Hey! Nice to meet you!"
            ],
            'goodbye': [
                "Goodbye! Have a great day!",
                "See you later!",
                "Take care!"
            ],
            'thanks': [
                "You're welcome!",
                "Happy to help!",
                "No problem!"
            ],
            'help': [
                "I can help you with general questions. What would you like to know?",
                "I'm here to assist you. What do you need help with?",
                "Feel free to ask me anything!"
            ],
            'default': [
                "I'm not sure I understand. Can you rephrase that?",
                "Could you provide more details?",
                "I'm still learning. Can you help me understand better?"
            ]
        }
        
        # Sample knowledge base
        self.knowledge_base = {
            'what is ai': 'Artificial Intelligence (AI) is the simulation of human intelligence in machines.',
            'what is machine learning': 'Machine Learning is a subset of AI that enables computers to learn without being explicitly programmed.',
            'what is deep learning': 'Deep Learning is a subset of machine learning that uses neural networks with multiple layers.',
            'what is nlp': 'Natural Language Processing (NLP) is a field of AI that focuses on the interaction between computers and human language.',
            'what is computer vision': 'Computer Vision is a field of AI that enables computers to interpret and understand visual information.',
            'how does ai work': 'AI works by processing data, learning patterns, and making decisions or predictions based on that learning.',
            'what are neural networks': 'Neural networks are computing systems inspired by biological neural networks that can learn and make decisions.',
            'what is data science': 'Data Science is an interdisciplinary field that uses scientific methods to extract insights from data.'
        }
        
        # Initialize TF-IDF vectorizer
        self.vectorizer = TfidfVectorizer()
        self.knowledge_vectors = None
        self.knowledge_questions = list(self.knowledge_base.keys())
        self._prepare_knowledge_base()
    
    def _prepare_knowledge_base(self):
        """Prepare the knowledge base for similarity matching"""
        self.knowledge_vectors = self.vectorizer.fit_transform(self.knowledge_questions)
    
    def _classify_intent(self, user_input):
        """Classify user intent based on input"""
        user_input = user_input.lower().strip()
        
        # Check for greetings
        if any(word in user_input for word in ['hello', 'hi', 'hey', 'good morning', 'good afternoon']):
            return 'greeting'
        
        # Check for goodbye
        if any(word in user_input for word in ['bye', 'goodbye', 'see you', 'farewell']):
            return 'goodbye'
        
        # Check for thanks
        if any(word in user_input for word in ['thank', 'thanks', 'appreciate']):
            return 'thanks'
        
        # Check for help
        if any(word in user_input for word in ['help', 'assist', 'support']):
            return 'help'
        
        return 'question'
    
    def _find_similar_question(self, user_input):
        """Find the most similar question in knowledge base"""
        user_vector = self.vectorizer.transform([user_input])
        similarities = cosine_similarity(user_vector, self.knowledge_vectors)[0]
        max_similarity_idx = np.argmax(similarities)
        
        if similarities[max_similarity_idx] > 0.3:  # Threshold for similarity
            return self.knowledge_questions[max_similarity_idx]
        return None
    
    def get_response(self, user_input):
        """Get response for user input"""
        intent = self._classify_intent(user_input)
        
        if intent in ['greeting', 'goodbye', 'thanks', 'help']:
            return random.choice(self.responses[intent])
        
        elif intent == 'question':
            similar_question = self._find_similar_question(user_input)
            if similar_question:
                return self.knowledge_base[similar_question]
            else:
                return random.choice(self.responses['default'])
        
        return random.choice(self.responses['default'])

# Example usage
def main():
    chatbot = SimpleChatbot()
    
    print("Chatbot: Hello! I'm an AI assistant. Type 'quit' to exit.")
    
    while True:
        user_input = input("\nYou: ").strip()
        
        if user_input.lower() in ['quit', 'exit', 'bye']:
            print("Chatbot:", chatbot.get_response('goodbye'))
            break
        
        if user_input:
            response = chatbot.get_response(user_input)
            print("Chatbot:", response)

if __name__ == "__main__":
    main()
```

### Recommendation System
```python
# Movie Recommendation System
import pandas as pd
import numpy as np
from sklearn.feature_extraction.text import TfidfVectorizer
from sklearn.metrics.pairwise import cosine_similarity
from sklearn.decomposition import TruncatedSVD
from sklearn.metrics.pairwise import linear_kernel

class MovieRecommendationSystem:
    def __init__(self):
        self.movies_df = None
        self.ratings_df = None
        self.tfidf_matrix = None
        self.cosine_sim = None
        self.svd = None
        self.user_movie_matrix = None
        
    def load_data(self, movies_file, ratings_file):
        """Load movie and rating data"""
        self.movies_df = pd.read_csv(movies_file)
        self.ratings_df = pd.read_csv(ratings_file)
        
        # Create content-based features
        self._create_content_features()
        
        # Create collaborative filtering matrix
        self._create_collaborative_matrix()
    
    def _create_content_features(self):
        """Create TF-IDF features for content-based filtering"""
        # Combine genre and overview for content features
        self.movies_df['content'] = self.movies_df['genres'].fillna('') + ' ' + self.movies_df['overview'].fillna('')
        
        # Create TF-IDF matrix
        tfidf = TfidfVectorizer(stop_words='english')
        self.tfidf_matrix = tfidf.fit_transform(self.movies_df['content'])
        
        # Compute cosine similarity matrix
        self.cosine_sim = cosine_similarity(self.tfidf_matrix, self.tfidf_matrix)
    
    def _create_collaborative_matrix(self):
        """Create user-movie rating matrix for collaborative filtering"""
        # Create pivot table
        self.user_movie_matrix = self.ratings_df.pivot_table(
            index='userId', 
            columns='movieId', 
            values='rating'
        ).fillna(0)
        
        # Apply SVD for dimensionality reduction
        self.svd = TruncatedSVD(n_components=50, random_state=42)
        self.user_movie_matrix_svd = self.svd.fit_transform(self.user_movie_matrix)
    
    def get_content_recommendations(self, movie_title, n_recommendations=10):
        """Get content-based recommendations"""
        # Find movie index
        movie_idx = self.movies_df[self.movies_df['title'] == movie_title].index
        if len(movie_idx) == 0:
            return "Movie not found"
        
        movie_idx = movie_idx[0]
        
        # Get similarity scores
        sim_scores = list(enumerate(self.cosine_sim[movie_idx]))
        sim_scores = sorted(sim_scores, key=lambda x: x[1], reverse=True)
        
        # Get top recommendations
        top_indices = [i[0] for i in sim_scores[1:n_recommendations+1]]
        recommendations = self.movies_df.iloc[top_indices][['title', 'genres', 'overview']]
        
        return recommendations
    
    def get_collaborative_recommendations(self, user_id, n_recommendations=10):
        """Get collaborative filtering recommendations"""
        if user_id not in self.user_movie_matrix.index:
            return "User not found"
        
        # Get user's rating vector
        user_ratings = self.user_movie_matrix.loc[user_id]
        
        # Find movies not rated by user
        unrated_movies = user_ratings[user_ratings == 0].index
        
        if len(unrated_movies) == 0:
            return "User has rated all movies"
        
        # Calculate predicted ratings for unrated movies
        user_svd = self.user_movie_matrix_svd[self.user_movie_matrix.index.get_loc(user_id)]
        movie_svd = self.svd.transform(self.user_movie_matrix[unrated_movies].T)
        
        predicted_ratings = np.dot(movie_svd, user_svd)
        
        # Get top recommendations
        top_movie_indices = np.argsort(predicted_ratings)[::-1][:n_recommendations]
        top_movie_ids = unrated_movies[top_movie_indices]
        
        recommendations = self.movies_df[self.movies_df['movieId'].isin(top_movie_ids)][
            ['title', 'genres', 'overview']
        ]
        
        return recommendations
    
    def get_hybrid_recommendations(self, user_id, movie_title, n_recommendations=10):
        """Get hybrid recommendations combining content and collaborative filtering"""
        # Get content-based recommendations
        content_recs = self.get_content_recommendations(movie_title, n_recommendations)
        
        # Get collaborative recommendations
        collab_recs = self.get_collaborative_recommendations(user_id, n_recommendations)
        
        # Combine recommendations (simple approach)
        if isinstance(content_recs, str) or isinstance(collab_recs, str):
            return content_recs if isinstance(content_recs, pd.DataFrame) else collab_recs
        
        # Merge and deduplicate
        all_recs = pd.concat([content_recs, collab_recs]).drop_duplicates(subset=['title'])
        return all_recs.head(n_recommendations)

# Example usage
def main():
    # Create sample data
    movies_data = {
        'movieId': [1, 2, 3, 4, 5],
        'title': ['The Matrix', 'Inception', 'Interstellar', 'The Dark Knight', 'Pulp Fiction'],
        'genres': ['Action|Sci-Fi', 'Action|Sci-Fi|Thriller', 'Adventure|Drama|Sci-Fi', 'Action|Crime|Drama', 'Crime|Drama'],
        'overview': ['A computer hacker learns about the true nature of reality', 
                    'A thief who steals corporate secrets through dream-sharing technology',
                    'A team of explorers travel through a wormhole in space',
                    'Batman faces the Joker in Gotham City',
                    'The lives of two mob hitmen, a boxer, and others intertwine']
    }
    
    ratings_data = {
        'userId': [1, 1, 1, 2, 2, 2, 3, 3, 3],
        'movieId': [1, 2, 3, 1, 2, 4, 2, 3, 5],
        'rating': [5, 4, 5, 4, 5, 4, 3, 4, 5]
    }
    
    movies_df = pd.DataFrame(movies_data)
    ratings_df = pd.DataFrame(ratings_data)
    
    # Save to CSV files
    movies_df.to_csv('movies.csv', index=False)
    ratings_df.to_csv('ratings.csv', index=False)
    
    # Create recommendation system
    rec_system = MovieRecommendationSystem()
    rec_system.load_data('movies.csv', 'ratings.csv')
    
    # Get recommendations
    print("Content-based recommendations for 'The Matrix':")
    print(rec_system.get_content_recommendations('The Matrix'))
    
    print("\nCollaborative recommendations for user 1:")
    print(rec_system.get_collaborative_recommendations(1))
    
    print("\nHybrid recommendations for user 1 and 'The Matrix':")
    print(rec_system.get_hybrid_recommendations(1, 'The Matrix'))

if __name__ == "__main__":
    main()
```

### Computer Vision Object Detection
```python
# Object Detection with OpenCV and YOLO
import cv2
import numpy as np
import matplotlib.pyplot as plt

class ObjectDetector:
    def __init__(self, config_path, weights_path, names_path):
        """Initialize YOLO object detector"""
        self.net = cv2.dnn.readNet(weights_path, config_path)
        self.classes = []
        
        # Load class names
        with open(names_path, 'r') as f:
            self.classes = [line.strip() for line in f.readlines()]
        
        # Generate random colors for bounding boxes
        self.colors = np.random.uniform(0, 255, size=(len(self.classes), 3))
    
    def detect_objects(self, image, confidence_threshold=0.5, nms_threshold=0.4):
        """Detect objects in image"""
        height, width = image.shape[:2]
        
        # Create blob from image
        blob = cv2.dnn.blobFromImage(image, 1/255.0, (416, 416), swapRB=True, crop=False)
        
        # Set input to network
        self.net.setInput(blob)
        
        # Get output layer names
        output_layers = self.net.getUnconnectedOutLayersNames()
        
        # Forward pass
        outputs = self.net.forward(output_layers)
        
        # Process detections
        boxes = []
        confidences = []
        class_ids = []
        
        for output in outputs:
            for detection in output:
                scores = detection[5:]
                class_id = np.argmax(scores)
                confidence = scores[class_id]
                
                if confidence > confidence_threshold:
                    # Get bounding box coordinates
                    center_x = int(detection[0] * width)
                    center_y = int(detection[1] * height)
                    w = int(detection[2] * width)
                    h = int(detection[3] * height)
                    
                    # Calculate top-left corner
                    x = int(center_x - w / 2)
                    y = int(center_y - h / 2)
                    
                    boxes.append([x, y, w, h])
                    confidences.append(float(confidence))
                    class_ids.append(class_id)
        
        # Apply non-maximum suppression
        indices = cv2.dnn.NMSBoxes(boxes, confidences, confidence_threshold, nms_threshold)
        
        return boxes, confidences, class_ids, indices
    
    def draw_detections(self, image, boxes, confidences, class_ids, indices):
        """Draw bounding boxes and labels on image"""
        result_image = image.copy()
        
        if len(indices) > 0:
            for i in indices.flatten():
                x, y, w, h = boxes[i]
                class_id = class_ids[i]
                confidence = confidences[i]
                
                # Get color for this class
                color = self.colors[class_id]
                
                # Draw bounding box
                cv2.rectangle(result_image, (x, y), (x + w, y + h), color, 2)
                
                # Draw label
                label = f"{self.classes[class_id]}: {confidence:.2f}"
                label_size = cv2.getTextSize(label, cv2.FONT_HERSHEY_SIMPLEX, 0.5, 2)[0]
                
                # Draw label background
                cv2.rectangle(result_image, (x, y - label_size[1] - 10), 
                            (x + label_size[0], y), color, -1)
                
                # Draw label text
                cv2.putText(result_image, label, (x, y - 5), 
                          cv2.FONT_HERSHEY_SIMPLEX, 0.5, (255, 255, 255), 2)
        
        return result_image

# Example usage
def main():
    # Create a simple test image
    def create_test_image():
        img = np.ones((400, 600, 3), dtype=np.uint8) * 255
        
        # Draw some shapes to simulate objects
        cv2.rectangle(img, (50, 50), (150, 150), (0, 0, 255), -1)  # Red rectangle
        cv2.circle(img, (300, 100), 50, (0, 255, 0), -1)  # Green circle
        cv2.rectangle(img, (450, 50), (550, 150), (255, 0, 0), -1)  # Blue rectangle
        
        # Add text
        cv2.putText(img, 'Test Objects', (200, 200), cv2.FONT_HERSHEY_SIMPLEX, 1, (0, 0, 0), 2)
        
        return img
    
    # Create test image
    test_image = create_test_image()
    cv2.imwrite('test_objects.jpg', test_image)
    
    # Note: In a real application, you would need actual YOLO weights and config files
    # For demonstration, we'll create a simple mock detector
    print("Object Detection Demo")
    print("Note: This is a simplified example. Real YOLO implementation requires:")
    print("1. YOLO configuration file (.cfg)")
    print("2. YOLO weights file (.weights)")
    print("3. Class names file (.names)")
    
    # Display the test image
    plt.figure(figsize=(10, 6))
    plt.imshow(cv2.cvtColor(test_image, cv2.COLOR_BGR2RGB))
    plt.title('Test Image for Object Detection')
    plt.axis('off')
    plt.show()

if __name__ == "__main__":
    main()
```

### Sentiment Analysis
```python
# Sentiment Analysis with TextBlob and VADER
from textblob import TextBlob
from vaderSentiment.vaderSentiment import SentimentIntensityAnalyzer
import pandas as pd
import matplotlib.pyplot as plt

class SentimentAnalyzer:
    def __init__(self):
        self.vader_analyzer = SentimentIntensityAnalyzer()
    
    def analyze_textblob(self, text):
        """Analyze sentiment using TextBlob"""
        blob = TextBlob(text)
        polarity = blob.sentiment.polarity
        
        if polarity > 0.1:
            return 'Positive'
        elif polarity < -0.1:
            return 'Negative'
        else:
            return 'Neutral'
    
    def analyze_vader(self, text):
        """Analyze sentiment using VADER"""
        scores = self.vader_analyzer.polarity_scores(text)
        
        if scores['compound'] >= 0.05:
            return 'Positive'
        elif scores['compound'] <= -0.05:
            return 'Negative'
        else:
            return 'Neutral'
    
    def analyze_batch(self, texts):
        """Analyze sentiment for multiple texts"""
        results = []
        
        for text in texts:
            textblob_result = self.analyze_textblob(text)
            vader_result = self.analyze_vader(text)
            
            results.append({
                'text': text,
                'textblob': textblob_result,
                'vader': vader_result
            })
        
        return pd.DataFrame(results)
    
    def plot_sentiment_distribution(self, df):
        """Plot sentiment distribution"""
        fig, (ax1, ax2) = plt.subplots(1, 2, figsize=(12, 5))
        
        # TextBlob distribution
        textblob_counts = df['textblob'].value_counts()
        ax1.pie(textblob_counts.values, labels=textblob_counts.index, autopct='%1.1f%%')
        ax1.set_title('TextBlob Sentiment Distribution')
        
        # VADER distribution
        vader_counts = df['vader'].value_counts()
        ax2.pie(vader_counts.values, labels=vader_counts.index, autopct='%1.1f%%')
        ax2.set_title('VADER Sentiment Distribution')
        
        plt.tight_layout()
        plt.show()

# Example usage
def main():
    # Sample texts for sentiment analysis
    texts = [
        "I love this product! It's amazing and works perfectly.",
        "This is terrible. I hate it and want my money back.",
        "The product is okay, nothing special but it works.",
        "Outstanding quality and excellent customer service!",
        "Worst purchase ever. Complete waste of money.",
        "It's fine, does what it's supposed to do.",
        "Absolutely fantastic! Highly recommend to everyone.",
        "Very disappointed with the quality and service.",
        "Good product overall, meets my expectations.",
        "Not impressed at all. Would not buy again."
    ]
    
    # Create analyzer
    analyzer = SentimentAnalyzer()
    
    # Analyze sentiments
    results = analyzer.analyze_batch(texts)
    
    # Display results
    print("Sentiment Analysis Results:")
    print("=" * 50)
    for _, row in results.iterrows():
        print(f"Text: {row['text']}")
        print(f"TextBlob: {row['textblob']}")
        print(f"VADER: {row['vader']}")
        print("-" * 30)
    
    # Plot distribution
    analyzer.plot_sentiment_distribution(results)
    
    # Calculate agreement
    agreement = (results['textblob'] == results['vader']).mean()
    print(f"\nAgreement between TextBlob and VADER: {agreement:.2%}")

if __name__ == "__main__":
    main()
```

## 🔍 AI Application Concepts
- **Natural Language Processing**: Understanding and generating human language
- **Recommendation Systems**: Suggesting relevant items to users
- **Computer Vision**: Interpreting visual information
- **Sentiment Analysis**: Determining emotional tone in text
- **Chatbots**: Conversational AI interfaces
- **Object Detection**: Identifying and locating objects in images
- **Content-Based Filtering**: Recommendations based on item features
- **Collaborative Filtering**: Recommendations based on user behavior

## 💡 Learning Points
- **NLP techniques** enable human-computer communication
- **Recommendation systems** improve user experience
- **Computer vision** opens many practical applications
- **Sentiment analysis** provides business insights
- **Hybrid approaches** often outperform single methods
- **Data quality** is crucial for AI success
- **User feedback** improves AI system performance
- **Ethical considerations** are important in AI development

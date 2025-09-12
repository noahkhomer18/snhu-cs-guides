# CS-350 Raspberry Pi Programming

## 🎯 Purpose
Demonstrate Raspberry Pi programming with Python, GPIO control, and IoT applications.

## 📝 Raspberry Pi Programming Examples

### Basic GPIO Control with Python
```python
# Basic GPIO Control
import RPi.GPIO as GPIO
import time

# Set up GPIO numbering
GPIO.setmode(GPIO.BCM)

# Define pins
LED_PIN = 18
BUTTON_PIN = 24

# Set up pins
GPIO.setup(LED_PIN, GPIO.OUT)
GPIO.setup(BUTTON_PIN, GPIO.IN, pull_up_down=GPIO.PUD_UP)

def blink_led(times=5):
    """Blink LED specified number of times"""
    for i in range(times):
        GPIO.output(LED_PIN, GPIO.HIGH)
        time.sleep(0.5)
        GPIO.output(LED_PIN, GPIO.LOW)
        time.sleep(0.5)

def read_button():
    """Read button state"""
    return GPIO.input(BUTTON_PIN)

try:
    print("Raspberry Pi GPIO Control")
    print("Press Ctrl+C to exit")
    
    while True:
        if not read_button():  # Button pressed (pulled low)
            print("Button pressed!")
            blink_led(3)
            time.sleep(0.2)  # Debounce
        
        time.sleep(0.01)  # Small delay

except KeyboardInterrupt:
    print("\nProgram terminated")
finally:
    GPIO.cleanup()
```

### Sensor Reading and Data Logging
```python
# Temperature and Humidity Sensor (DHT22)
import Adafruit_DHT
import time
import csv
from datetime import datetime

# Sensor configuration
DHT_SENSOR = Adafruit_DHT.DHT22
DHT_PIN = 4

def read_sensor():
    """Read temperature and humidity from DHT22"""
    humidity, temperature = Adafruit_DHT.read_retry(DHT_SENSOR, DHT_PIN)
    return humidity, temperature

def log_data(temperature, humidity):
    """Log data to CSV file"""
    timestamp = datetime.now().strftime("%Y-%m-%d %H:%M:%S")
    
    with open('sensor_data.csv', 'a', newline='') as file:
        writer = csv.writer(file)
        writer.writerow([timestamp, temperature, humidity])
    
    print(f"Data logged: {timestamp}, Temp: {temperature:.1f}°C, Humidity: {humidity:.1f}%")

def main():
    print("DHT22 Sensor Data Logger")
    print("Press Ctrl+C to stop")
    
    # Create CSV file with headers
    with open('sensor_data.csv', 'w', newline='') as file:
        writer = csv.writer(file)
        writer.writerow(['Timestamp', 'Temperature (°C)', 'Humidity (%)'])
    
    try:
        while True:
            humidity, temperature = read_sensor()
            
            if humidity is not None and temperature is not None:
                log_data(temperature, humidity)
            else:
                print("Failed to read sensor data")
            
            time.sleep(60)  # Read every minute
            
    except KeyboardInterrupt:
        print("\nData logging stopped")

if __name__ == "__main__":
    main()
```

### Camera Module Programming
```python
# Raspberry Pi Camera Module
from picamera import PiCamera
import time
import os
from datetime import datetime

class CameraController:
    def __init__(self):
        self.camera = PiCamera()
        self.camera.resolution = (1920, 1080)
        self.camera.framerate = 30
        
    def take_photo(self, filename=None):
        """Take a single photo"""
        if filename is None:
            timestamp = datetime.now().strftime("%Y%m%d_%H%M%S")
            filename = f"photo_{timestamp}.jpg"
        
        self.camera.capture(filename)
        print(f"Photo saved: {filename}")
        return filename
    
    def record_video(self, duration=10, filename=None):
        """Record a video"""
        if filename is None:
            timestamp = datetime.now().strftime("%Y%m%d_%H%M%S")
            filename = f"video_{timestamp}.h264"
        
        self.camera.start_recording(filename)
        time.sleep(duration)
        self.camera.stop_recording()
        print(f"Video saved: {filename}")
        return filename
    
    def timelapse(self, interval=5, duration=60):
        """Create timelapse photos"""
        print(f"Starting timelapse: {duration} seconds, {interval}s intervals")
        
        start_time = time.time()
        photo_count = 0
        
        while time.time() - start_time < duration:
            photo_count += 1
            filename = f"timelapse_{photo_count:04d}.jpg"
            self.take_photo(filename)
            time.sleep(interval)
        
        print(f"Timelapse complete: {photo_count} photos taken")
    
    def close(self):
        """Close camera"""
        self.camera.close()

# Usage example
def main():
    camera = CameraController()
    
    try:
        # Take a single photo
        camera.take_photo()
        
        # Record a 10-second video
        camera.record_video(10)
        
        # Create a 1-minute timelapse
        camera.timelapse(interval=2, duration=60)
        
    finally:
        camera.close()

if __name__ == "__main__":
    main()
```

### Web Server with Flask
```python
# Web Server for IoT Dashboard
from flask import Flask, render_template, jsonify, request
import RPi.GPIO as GPIO
import time
import threading
import json

app = Flask(__name__)

# GPIO setup
GPIO.setmode(GPIO.BCM)
LED_PIN = 18
SENSOR_PIN = 4

GPIO.setup(LED_PIN, GPIO.OUT)
GPIO.setup(SENSOR_PIN, GPIO.IN, pull_up_down=GPIO.PUD_UP)

# Global variables for sensor data
sensor_data = {
    'temperature': 0,
    'humidity': 0,
    'button_pressed': False,
    'led_status': False
}

def read_sensors():
    """Background thread to read sensor data"""
    global sensor_data
    
    while True:
        # Read button state
        sensor_data['button_pressed'] = not GPIO.input(SENSOR_PIN)
        
        # Read LED state
        sensor_data['led_status'] = GPIO.input(LED_PIN)
        
        # Simulate temperature and humidity readings
        sensor_data['temperature'] = 20 + (time.time() % 10)
        sensor_data['humidity'] = 50 + (time.time() % 20)
        
        time.sleep(1)

@app.route('/')
def index():
    """Main dashboard page"""
    return render_template('dashboard.html')

@app.route('/api/data')
def get_data():
    """API endpoint to get sensor data"""
    return jsonify(sensor_data)

@app.route('/api/led/<state>')
def control_led(state):
    """API endpoint to control LED"""
    if state == 'on':
        GPIO.output(LED_PIN, GPIO.HIGH)
        sensor_data['led_status'] = True
    elif state == 'off':
        GPIO.output(LED_PIN, GPIO.LOW)
        sensor_data['led_status'] = False
    
    return jsonify({'status': 'success', 'led': state})

@app.route('/api/led/toggle')
def toggle_led():
    """API endpoint to toggle LED"""
    current_state = GPIO.input(LED_PIN)
    GPIO.output(LED_PIN, not current_state)
    sensor_data['led_status'] = not current_state
    
    return jsonify({'status': 'success', 'led': 'on' if not current_state else 'off'})

def main():
    # Start sensor reading thread
    sensor_thread = threading.Thread(target=read_sensors, daemon=True)
    sensor_thread.start()
    
    print("Starting IoT Dashboard Server")
    print("Access at: http://localhost:5000")
    
    try:
        app.run(host='0.0.0.0', port=5000, debug=False)
    except KeyboardInterrupt:
        print("\nServer stopped")
    finally:
        GPIO.cleanup()

if __name__ == "__main__":
    main()
```

### MQTT Communication
```python
# MQTT Communication for IoT
import paho.mqtt.client as mqtt
import json
import time
import RPi.GPIO as GPIO

# MQTT Configuration
MQTT_BROKER = "broker.hivemq.com"
MQTT_PORT = 1883
MQTT_TOPIC_PUBLISH = "sensor/data"
MQTT_TOPIC_SUBSCRIBE = "sensor/control"

# GPIO setup
GPIO.setmode(GPIO.BCM)
LED_PIN = 18
SENSOR_PIN = 4

GPIO.setup(LED_PIN, GPIO.OUT)
GPIO.setup(SENSOR_PIN, GPIO.IN, pull_up_down=GPIO.PUD_UP)

class MQTTController:
    def __init__(self):
        self.client = mqtt.Client()
        self.client.on_connect = self.on_connect
        self.client.on_message = self.on_message
        self.client.on_disconnect = self.on_disconnect
        
    def on_connect(self, client, userdata, flags, rc):
        """Callback for when connected to MQTT broker"""
        if rc == 0:
            print("Connected to MQTT broker")
            client.subscribe(MQTT_TOPIC_SUBSCRIBE)
        else:
            print(f"Failed to connect to MQTT broker: {rc}")
    
    def on_message(self, client, userdata, msg):
        """Callback for when message is received"""
        try:
            data = json.loads(msg.payload.decode())
            print(f"Received message: {data}")
            
            # Handle LED control
            if 'led' in data:
                if data['led'] == 'on':
                    GPIO.output(LED_PIN, GPIO.HIGH)
                    print("LED turned ON")
                elif data['led'] == 'off':
                    GPIO.output(LED_PIN, GPIO.LOW)
                    print("LED turned OFF")
                    
        except json.JSONDecodeError:
            print(f"Invalid JSON received: {msg.payload.decode()}")
    
    def on_disconnect(self, client, userdata, rc):
        """Callback for when disconnected from MQTT broker"""
        print("Disconnected from MQTT broker")
    
    def connect(self):
        """Connect to MQTT broker"""
        try:
            self.client.connect(MQTT_BROKER, MQTT_PORT, 60)
            self.client.loop_start()
            return True
        except Exception as e:
            print(f"Error connecting to MQTT broker: {e}")
            return False
    
    def publish_sensor_data(self):
        """Publish sensor data to MQTT broker"""
        # Read sensor data
        button_state = not GPIO.input(SENSOR_PIN)
        led_state = GPIO.input(LED_PIN)
        
        # Create data payload
        data = {
            'timestamp': time.time(),
            'button_pressed': button_state,
            'led_status': bool(led_state),
            'temperature': 20 + (time.time() % 10),  # Simulated
            'humidity': 50 + (time.time() % 20)      # Simulated
        }
        
        # Publish data
        message = json.dumps(data)
        result = self.client.publish(MQTT_TOPIC_PUBLISH, message)
        
        if result.rc == mqtt.MQTT_ERR_SUCCESS:
            print(f"Published: {data}")
        else:
            print(f"Failed to publish: {result.rc}")
    
    def disconnect(self):
        """Disconnect from MQTT broker"""
        self.client.loop_stop()
        self.client.disconnect()

def main():
    mqtt_controller = MQTTController()
    
    if not mqtt_controller.connect():
        return
    
    print("MQTT IoT Controller Started")
    print("Press Ctrl+C to stop")
    
    try:
        while True:
            mqtt_controller.publish_sensor_data()
            time.sleep(5)  # Publish every 5 seconds
            
    except KeyboardInterrupt:
        print("\nStopping MQTT controller...")
    finally:
        mqtt_controller.disconnect()
        GPIO.cleanup()

if __name__ == "__main__":
    main()
```

### Machine Learning with TensorFlow Lite
```python
# Machine Learning on Raspberry Pi with TensorFlow Lite
import numpy as np
import tensorflow as tf
from PIL import Image
import cv2
import time

class MLModel:
    def __init__(self, model_path):
        """Initialize TensorFlow Lite model"""
        self.interpreter = tf.lite.Interpreter(model_path=model_path)
        self.interpreter.allocate_tensors()
        
        # Get input and output details
        self.input_details = self.interpreter.get_input_details()
        self.output_details = self.interpreter.get_output_details()
        
        print(f"Model loaded: {model_path}")
        print(f"Input shape: {self.input_details[0]['shape']}")
        print(f"Output shape: {self.output_details[0]['shape']}")
    
    def preprocess_image(self, image_path, target_size=(224, 224)):
        """Preprocess image for model input"""
        # Load and resize image
        image = Image.open(image_path).convert('RGB')
        image = image.resize(target_size)
        
        # Convert to numpy array and normalize
        image_array = np.array(image, dtype=np.float32)
        image_array = image_array / 255.0
        
        # Add batch dimension
        image_array = np.expand_dims(image_array, axis=0)
        
        return image_array
    
    def predict(self, image_path):
        """Make prediction on image"""
        # Preprocess image
        input_data = self.preprocess_image(image_path)
        
        # Set input tensor
        self.interpreter.set_tensor(self.input_details[0]['index'], input_data)
        
        # Run inference
        self.interpreter.invoke()
        
        # Get output
        output_data = self.interpreter.get_tensor(self.output_details[0]['index'])
        
        return output_data[0]

def main():
    # Example usage with a simple model
    model_path = "model.tflite"  # Replace with actual model path
    
    try:
        # Initialize model
        ml_model = MLModel(model_path)
        
        # Example image path
        image_path = "test_image.jpg"
        
        # Make prediction
        start_time = time.time()
        prediction = ml_model.predict(image_path)
        inference_time = time.time() - start_time
        
        print(f"Prediction: {prediction}")
        print(f"Inference time: {inference_time:.3f} seconds")
        
        # Find class with highest probability
        predicted_class = np.argmax(prediction)
        confidence = prediction[predicted_class]
        
        print(f"Predicted class: {predicted_class}")
        print(f"Confidence: {confidence:.3f}")
        
    except FileNotFoundError:
        print("Model file not found. Please provide a valid .tflite model file.")
    except Exception as e:
        print(f"Error: {e}")

if __name__ == "__main__":
    main()
```

## 🔍 Raspberry Pi Concepts
- **GPIO Control**: Direct hardware interface with Python
- **Sensor Integration**: Reading various sensors and actuators
- **Camera Module**: Image and video capture capabilities
- **Web Development**: Creating IoT dashboards with Flask
- **MQTT Communication**: Publish/subscribe messaging for IoT
- **Machine Learning**: Running ML models on edge devices
- **Multithreading**: Concurrent processing for real-time applications
- **Data Logging**: Storing sensor data for analysis

## 💡 Learning Points
- **Python** is the primary language for Raspberry Pi programming
- **GPIO libraries** provide hardware abstraction
- **Camera module** enables computer vision applications
- **Web frameworks** create user interfaces for IoT projects
- **MQTT** is ideal for IoT device communication
- **TensorFlow Lite** enables ML on resource-constrained devices
- **Multithreading** improves application responsiveness
- **Edge computing** reduces latency and bandwidth requirements

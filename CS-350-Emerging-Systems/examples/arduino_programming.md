# CS-350 Arduino Programming

## 🎯 Purpose
Demonstrate Arduino programming concepts including sensors, actuators, and IoT connectivity.

## 📝 Arduino Programming Examples

### Basic Arduino Setup and Blink
```cpp
// Basic Arduino Blink Program
// Blinks an LED connected to pin 13

void setup() {
  // Initialize digital pin 13 as an output
  pinMode(13, OUTPUT);
  
  // Initialize serial communication
  Serial.begin(9600);
  Serial.println("Arduino Blink Program Started");
}

void loop() {
  // Turn LED on
  digitalWrite(13, HIGH);
  Serial.println("LED ON");
  delay(1000);  // Wait for 1 second
  
  // Turn LED off
  digitalWrite(13, LOW);
  Serial.println("LED OFF");
  delay(1000);  // Wait for 1 second
}
```

### Sensor Reading and Processing
```cpp
// Temperature and Humidity Sensor (DHT22)
#include <DHT.h>

#define DHT_PIN 2
#define DHT_TYPE DHT22

DHT dht(DHT_PIN, DHT_TYPE);

void setup() {
  Serial.begin(9600);
  dht.begin();
  Serial.println("DHT22 Temperature and Humidity Sensor");
}

void loop() {
  // Read temperature and humidity
  float humidity = dht.readHumidity();
  float temperature = dht.readTemperature();
  
  // Check if readings are valid
  if (isnan(humidity) || isnan(temperature)) {
    Serial.println("Failed to read from DHT sensor!");
    return;
  }
  
  // Calculate heat index
  float heatIndex = dht.computeHeatIndex(temperature, humidity, false);
  
  // Print readings
  Serial.print("Humidity: ");
  Serial.print(humidity);
  Serial.print("%\t");
  Serial.print("Temperature: ");
  Serial.print(temperature);
  Serial.print("°C\t");
  Serial.print("Heat Index: ");
  Serial.print(heatIndex);
  Serial.println("°C");
  
  delay(2000); // Wait 2 seconds between readings
}
```

### Motor Control with PWM
```cpp
// DC Motor Control with PWM and Direction
#define MOTOR_PIN1 5
#define MOTOR_PIN2 6
#define ENABLE_PIN 9
#define POTENTIOMETER_PIN A0

int motorSpeed = 0;
int motorDirection = 1;

void setup() {
  Serial.begin(9600);
  
  // Set motor control pins as outputs
  pinMode(MOTOR_PIN1, OUTPUT);
  pinMode(MOTOR_PIN2, OUTPUT);
  pinMode(ENABLE_PIN, OUTPUT);
  
  Serial.println("DC Motor Control Program");
}

void loop() {
  // Read potentiometer value (0-1023)
  int potValue = analogRead(POTENTIOMETER_PIN);
  
  // Convert to motor speed (0-255)
  motorSpeed = map(potValue, 0, 1023, 0, 255);
  
  // Control motor direction
  if (motorSpeed > 10) { // Dead zone to prevent jitter
    if (motorDirection == 1) {
      digitalWrite(MOTOR_PIN1, HIGH);
      digitalWrite(MOTOR_PIN2, LOW);
    } else {
      digitalWrite(MOTOR_PIN1, LOW);
      digitalWrite(MOTOR_PIN2, HIGH);
    }
    analogWrite(ENABLE_PIN, motorSpeed);
  } else {
    // Stop motor
    digitalWrite(MOTOR_PIN1, LOW);
    digitalWrite(MOTOR_PIN2, LOW);
    analogWrite(ENABLE_PIN, 0);
  }
  
  // Print status
  Serial.print("Speed: ");
  Serial.print(motorSpeed);
  Serial.print("\tDirection: ");
  Serial.println(motorDirection == 1 ? "Forward" : "Reverse");
  
  delay(100);
}
```

### Servo Motor Control
```cpp
// Servo Motor Control with Potentiometer
#include <Servo.h>

Servo myServo;
int potPin = A0;
int servoPin = 9;

void setup() {
  Serial.begin(9600);
  myServo.attach(servoPin);
  Serial.println("Servo Motor Control");
}

void loop() {
  // Read potentiometer value
  int potValue = analogRead(potPin);
  
  // Convert to servo angle (0-180 degrees)
  int angle = map(potValue, 0, 1023, 0, 180);
  
  // Move servo to position
  myServo.write(angle);
  
  // Print current position
  Serial.print("Servo Angle: ");
  Serial.print(angle);
  Serial.println(" degrees");
  
  delay(15); // Small delay for servo movement
}
```

### LCD Display Interface
```cpp
// LCD Display with I2C
#include <LiquidCrystal_I2C.h>

LiquidCrystal_I2C lcd(0x27, 16, 2); // Address, columns, rows

void setup() {
  lcd.init();
  lcd.backlight();
  
  lcd.setCursor(0, 0);
  lcd.print("Hello, World!");
  lcd.setCursor(0, 1);
  lcd.print("Arduino Project");
  
  delay(2000);
}

void loop() {
  // Display current time (milliseconds)
  lcd.clear();
  lcd.setCursor(0, 0);
  lcd.print("Time: ");
  lcd.print(millis() / 1000);
  lcd.print("s");
  
  lcd.setCursor(0, 1);
  lcd.print("Status: Running");
  
  delay(1000);
}
```

### Wireless Communication (WiFi)
```cpp
// WiFi Communication with ESP32
#include <WiFi.h>
#include <HTTPClient.h>

const char* ssid = "YOUR_WIFI_SSID";
const char* password = "YOUR_WIFI_PASSWORD";
const char* serverURL = "http://your-server.com/api/data";

void setup() {
  Serial.begin(115200);
  
  // Connect to WiFi
  WiFi.begin(ssid, password);
  while (WiFi.status() != WL_CONNECTED) {
    delay(1000);
    Serial.println("Connecting to WiFi...");
  }
  
  Serial.println("WiFi connected!");
  Serial.print("IP address: ");
  Serial.println(WiFi.localIP());
}

void loop() {
  if (WiFi.status() == WL_CONNECTED) {
    // Read sensor data
    int sensorValue = analogRead(A0);
    
    // Send data to server
    sendDataToServer(sensorValue);
    
    delay(5000); // Send data every 5 seconds
  } else {
    Serial.println("WiFi disconnected!");
    delay(1000);
  }
}

void sendDataToServer(int sensorValue) {
  HTTPClient http;
  http.begin(serverURL);
  http.addHeader("Content-Type", "application/json");
  
  String jsonData = "{\"sensor_value\":" + String(sensorValue) + "}";
  
  int httpResponseCode = http.POST(jsonData);
  
  if (httpResponseCode > 0) {
    String response = http.getString();
    Serial.println("Data sent successfully!");
    Serial.println("Response: " + response);
  } else {
    Serial.println("Error sending data: " + String(httpResponseCode));
  }
  
  http.end();
}
```

### Interrupt Handling
```cpp
// Interrupt-based Button Handling
volatile bool buttonPressed = false;
volatile unsigned long lastInterruptTime = 0;

#define BUTTON_PIN 2
#define LED_PIN 13

void setup() {
  Serial.begin(9600);
  
  // Set up button pin with internal pull-up
  pinMode(BUTTON_PIN, INPUT_PULLUP);
  pinMode(LED_PIN, OUTPUT);
  
  // Attach interrupt to button pin
  attachInterrupt(digitalPinToInterrupt(BUTTON_PIN), buttonISR, FALLING);
  
  Serial.println("Interrupt-based Button Program");
}

void loop() {
  if (buttonPressed) {
    // Debounce check
    if (millis() - lastInterruptTime > 200) {
      Serial.println("Button pressed!");
      
      // Toggle LED
      digitalWrite(LED_PIN, !digitalRead(LED_PIN));
      
      buttonPressed = false;
    }
  }
  
  // Other main loop tasks can go here
  delay(10);
}

// Interrupt Service Routine
void buttonISR() {
  lastInterruptTime = millis();
  buttonPressed = true;
}
```

### Data Logging to SD Card
```cpp
// Data Logging to SD Card
#include <SD.h>
#include <SPI.h>

#define CS_PIN 4
#define SENSOR_PIN A0

File dataFile;

void setup() {
  Serial.begin(9600);
  
  // Initialize SD card
  if (!SD.begin(CS_PIN)) {
    Serial.println("SD card initialization failed!");
    return;
  }
  
  Serial.println("SD card initialized successfully");
  
  // Create or open data file
  dataFile = SD.open("datalog.txt", FILE_WRITE);
  if (dataFile) {
    dataFile.println("Time, Sensor Value");
    dataFile.close();
    Serial.println("Data file created");
  } else {
    Serial.println("Error creating data file");
  }
}

void loop() {
  // Read sensor value
  int sensorValue = analogRead(SENSOR_PIN);
  
  // Open file for writing
  dataFile = SD.open("datalog.txt", FILE_WRITE);
  
  if (dataFile) {
    // Write timestamp and sensor value
    dataFile.print(millis());
    dataFile.print(",");
    dataFile.println(sensorValue);
    dataFile.close();
    
    Serial.print("Logged: ");
    Serial.print(millis());
    Serial.print(", ");
    Serial.println(sensorValue);
  } else {
    Serial.println("Error opening data file");
  }
  
  delay(1000); // Log data every second
}
```

## 🔍 Arduino Concepts
- **Digital I/O**: Reading and writing digital signals
- **Analog I/O**: Reading analog sensor values with ADC
- **PWM**: Pulse Width Modulation for motor control
- **Interrupts**: Hardware-triggered event handling
- **Serial Communication**: Data transmission and debugging
- **Libraries**: Using external libraries for sensors and displays
- **Timing**: Using millis() and delay() functions
- **Memory Management**: Efficient use of limited RAM and Flash

## 💡 Learning Points
- **Arduino IDE** provides simplified C++ environment
- **Pins** can be configured as inputs or outputs
- **Sensors** convert physical quantities to electrical signals
- **Actuators** convert electrical signals to physical motion
- **Interrupts** provide responsive real-time control
- **Serial communication** enables debugging and data logging
- **Libraries** extend Arduino functionality
- **Power management** is crucial for battery-operated devices

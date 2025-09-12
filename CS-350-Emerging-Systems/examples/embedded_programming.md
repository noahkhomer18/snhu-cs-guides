# CS-350 Embedded Systems Programming

## 🎯 Purpose
Demonstrate embedded systems programming with C and low-level hardware interaction.

## 📝 Embedded Programming Examples

### GPIO Control
```c
#include <stdint.h>
#include <avr/io.h>
#include <util/delay.h>

// GPIO Pin Definitions
#define LED_PIN     PB5
#define BUTTON_PIN  PD2
#define LED_PORT    PORTB
#define LED_DDR     DDRB
#define BUTTON_PORT PORTD
#define BUTTON_DDR  DDRD
#define BUTTON_PIN_REG PIND

void gpio_init(void) {
    // Set LED pin as output
    LED_DDR |= (1 << LED_PIN);
    
    // Set button pin as input with pull-up
    BUTTON_DDR &= ~(1 << BUTTON_PIN);
    BUTTON_PORT |= (1 << BUTTON_PIN);
}

void led_on(void) {
    LED_PORT |= (1 << LED_PIN);
}

void led_off(void) {
    LED_PORT &= ~(1 << LED_PIN);
}

void led_toggle(void) {
    LED_PORT ^= (1 << LED_PIN);
}

uint8_t button_pressed(void) {
    return !(BUTTON_PIN_REG & (1 << BUTTON_PIN));
}

int main(void) {
    gpio_init();
    
    while(1) {
        if (button_pressed()) {
            led_on();
        } else {
            led_off();
        }
        _delay_ms(10); // Debounce delay
    }
    
    return 0;
}
```

### Timer and Interrupts
```c
#include <avr/io.h>
#include <avr/interrupt.h>

volatile uint16_t timer_count = 0;
volatile uint8_t led_state = 0;

// Timer0 overflow interrupt
ISR(TIMER0_OVF_vect) {
    timer_count++;
    
    // Toggle LED every 1000 timer overflows
    if (timer_count >= 1000) {
        timer_count = 0;
        led_state = !led_state;
        
        if (led_state) {
            PORTB |= (1 << PB5);  // LED on
        } else {
            PORTB &= ~(1 << PB5); // LED off
        }
    }
}

void timer_init(void) {
    // Set Timer0 to normal mode
    TCCR0A = 0x00;
    
    // Set prescaler to 1024 (16MHz / 1024 = 15625 Hz)
    TCCR0B = (1 << CS02) | (1 << CS00);
    
    // Enable Timer0 overflow interrupt
    TIMSK0 = (1 << TOIE0);
    
    // Enable global interrupts
    sei();
}

int main(void) {
    // Set LED pin as output
    DDRB |= (1 << PB5);
    
    timer_init();
    
    while(1) {
        // Main loop - interrupt handles LED blinking
        // Can perform other tasks here
    }
    
    return 0;
}
```

### UART Communication
```c
#include <avr/io.h>
#include <util/setbaud.h>
#include <stdio.h>

// UART initialization
void uart_init(void) {
    // Set baud rate
    UBRR0H = UBRRH_VALUE;
    UBRR0L = UBRRL_VALUE;
    
    // Enable transmitter and receiver
    UCSR0B = (1 << TXEN0) | (1 << RXEN0);
    
    // Set frame format: 8 data bits, 1 stop bit
    UCSR0C = (1 << UCSZ01) | (1 << UCSZ00);
}

// Send a character
void uart_send_char(char data) {
    // Wait for empty transmit buffer
    while (!(UCSR0A & (1 << UDRE0)));
    
    // Put data into buffer
    UDR0 = data;
}

// Send a string
void uart_send_string(const char* str) {
    while (*str) {
        uart_send_char(*str++);
    }
}

// Receive a character
char uart_receive_char(void) {
    // Wait for data to be received
    while (!(UCSR0A & (1 << RXC0)));
    
    // Get and return received data
    return UDR0;
}

// Simple command processor
void process_command(char* command) {
    if (strcmp(command, "LED_ON") == 0) {
        PORTB |= (1 << PB5);
        uart_send_string("LED turned ON\r\n");
    }
    else if (strcmp(command, "LED_OFF") == 0) {
        PORTB &= ~(1 << PB5);
        uart_send_string("LED turned OFF\r\n");
    }
    else if (strcmp(command, "STATUS") == 0) {
        uart_send_string("System running normally\r\n");
    }
    else {
        uart_send_string("Unknown command\r\n");
    }
}

int main(void) {
    // Initialize UART
    uart_init();
    
    // Set LED pin as output
    DDRB |= (1 << PB5);
    
    uart_send_string("Embedded System Ready\r\n");
    uart_send_string("Commands: LED_ON, LED_OFF, STATUS\r\n");
    
    char buffer[32];
    uint8_t index = 0;
    
    while(1) {
        char received = uart_receive_char();
        
        if (received == '\r' || received == '\n') {
            buffer[index] = '\0';
            process_command(buffer);
            index = 0;
        }
        else if (index < 31) {
            buffer[index++] = received;
        }
    }
    
    return 0;
}
```

### ADC Reading
```c
#include <avr/io.h>
#include <util/delay.h>

void adc_init(void) {
    // Set reference voltage to AVCC
    ADMUX = (1 << REFS0);
    
    // Enable ADC and set prescaler to 128
    ADCSRA = (1 << ADEN) | (1 << ADPS2) | (1 << ADPS1) | (1 << ADPS0);
}

uint16_t adc_read(uint8_t channel) {
    // Select ADC channel
    ADMUX = (ADMUX & 0xF0) | (channel & 0x0F);
    
    // Start conversion
    ADCSRA |= (1 << ADSC);
    
    // Wait for conversion to complete
    while (ADCSRA & (1 << ADSC));
    
    // Return ADC result
    return ADC;
}

int main(void) {
    // Initialize ADC
    adc_init();
    
    // Initialize UART for output
    uart_init();
    
    // Set LED pins as outputs
    DDRB |= (1 << PB5) | (1 << PB4) | (1 << PB3);
    
    while(1) {
        // Read ADC value from channel 0
        uint16_t adc_value = adc_read(0);
        
        // Convert to voltage (assuming 5V reference)
        uint16_t voltage = (adc_value * 5000) / 1024;
        
        // Control LEDs based on voltage level
        if (voltage < 1000) {
            PORTB = (1 << PB5); // Red LED
        }
        else if (voltage < 3000) {
            PORTB = (1 << PB4); // Yellow LED
        }
        else {
            PORTB = (1 << PB3); // Green LED
        }
        
        // Send voltage reading via UART
        char buffer[20];
        sprintf(buffer, "Voltage: %d mV\r\n", voltage);
        uart_send_string(buffer);
        
        _delay_ms(500);
    }
    
    return 0;
}
```

## 🔍 Embedded Systems Concepts
- **GPIO**: General Purpose Input/Output pins
- **Interrupts**: Hardware-triggered event handling
- **Timers**: Precise timing and PWM generation
- **UART**: Serial communication protocol
- **ADC**: Analog-to-Digital conversion

## 💡 Learning Points
- Embedded programming requires direct hardware control
- Interrupts provide efficient event handling
- Memory and processing resources are limited
- Real-time constraints require careful timing
- Low-level programming skills are essential

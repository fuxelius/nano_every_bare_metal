

#define F_CPU 2666666
#define USART_BAUD_RATE(BAUD_RATE) ((float)(F_CPU * 64 / (16 * (float)BAUD_RATE)) + 0.5)

#include <avr/io.h>
#include <util/delay.h>
#include <string.h>

/*
void USART0_init(void);
void USART0_sendChar(char c);
void USART0_sendString(char *str);

void USART0_init(void) {
    PORTA.DIR &= ~PIN1_bm;
    PORTA.DIR |= PIN0_bm;
    
    USART0.BAUD = (uint16_t)USART0_BAUD_RATE(9600);

    USART0.CTRLB |= USART_TXEN_bm; 
}

void USART0_sendChar(char c) {
    while (!(USART0.STATUS & USART_DREIF_bm)) {
        ;
    }     

    USART0.TXDATAL = c;
}

void USART0_sendString(char *str) {
    for(size_t i = 0; i < strlen(str); i++) {
        USART0_sendChar(str[i]);
    }
}

int main(void) {
    USART0_init();
    
    while (1) {
        USART0_sendString("Hello World!\r\n");
        _delay_ms(500);
    }
}
*/


void USART3_init(void);
void USART3_sendChar(char c);
void USART3_sendString(char *str);

void USART3_init(void) {
    PORTMUX.USARTROUTEA = 0b01111111; // Set PB04, PB05

    PORTB.DIR &= ~PIN5_bm;  // RX
    PORTB.DIR |= PIN4_bm;   // TX
    USART3.BAUD = (uint16_t)USART_BAUD_RATE(9600);
    USART3.CTRLB |= USART_TXEN_bm; 
}

void USART3_sendChar(char c) {
    while (!(USART3.STATUS & USART_DREIF_bm)) {
        ;
    }     

    USART3.TXDATAL = c;
}

void USART3_sendString(char *str) {
    for(size_t i = 0; i < strlen(str); i++) {
        USART3_sendChar(str[i]);
    }
}

int main(void) {
    USART3_init();
    
    while (1) {
        USART3_sendString("Hello World!\r\n");
        _delay_ms(500);
    }
}



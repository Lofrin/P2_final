/*********************************************
Project : Test software
**********************************************
Chip type: ATmega164A
Clock frequency: 20 MHz
Compilers:  CVAVR 2.x
*********************************************/

#include <mega164a.h>

#include <stdio.h>
#include <delay.h>  
#include <string.h> 
#include <stdlib.h>
#include <stdint.h>
#include <i2c.h>
#include "defs.h"

//*************************************************************************************************
//*********** BEGIN SERIAL STUFF (interrupt-driven, generated by Code Wizard) *********************
//*************************************************************************************************

#ifndef RXB8
#define RXB8 1
#endif

#ifndef TXB8
#define TXB8 0
#endif

#ifndef UPE
#define UPE 2
#endif

#ifndef DOR
#define DOR 3
#endif

#ifndef FE
#define FE 4
#endif

#ifndef UDRE
#define UDRE 5
#endif

#ifndef RXC
#define RXC 7
#endif

#define FRAMING_ERROR (1<<FE)
#define PARITY_ERROR (1<<UPE)
#define DATA_OVERRUN (1<<DOR)
#define DATA_REGISTER_EMPTY (1<<UDRE)
#define RX_COMPLETE (1<<RXC)

// USART0 Receiver buffer
#define RX_BUFFER_SIZE0 8
char rx_buffer0[RX_BUFFER_SIZE0];

#if RX_BUFFER_SIZE0 <= 256
unsigned char rx_wr_index0,rx_rd_index0,rx_counter0;
#else
unsigned int rx_wr_index0,rx_rd_index0,rx_counter0;
#endif

// This flag is set on USART0 Receiver buffer overflow
bit rx_buffer_overflow0;

// USART0 Receiver interrupt service routine
interrupt [USART0_RXC] void usart0_rx_isr(void)
{
char status,data;
status=UCSR0A;
data=UDR0;
if ((status & (FRAMING_ERROR | PARITY_ERROR | DATA_OVERRUN))==0)
   {
   rx_buffer0[rx_wr_index0++]=data;
#if RX_BUFFER_SIZE0 == 256
   // special case for receiver buffer size=256
   if (++rx_counter0 == 0) rx_buffer_overflow0=1;
#else
   if (rx_wr_index0 == RX_BUFFER_SIZE0) rx_wr_index0=0;
   if (++rx_counter0 == RX_BUFFER_SIZE0)
      {
      rx_counter0=0;
      rx_buffer_overflow0=1;
      }
#endif
   }
}

#ifndef _DEBUG_TERMINAL_IO_
// Get a character from the USART0 Receiver buffer
#define _ALTERNATE_GETCHAR_
#pragma used+
char getchar(void)
{
char data;
while (rx_counter0==0);
data=rx_buffer0[rx_rd_index0++];
#if RX_BUFFER_SIZE0 != 256
if (rx_rd_index0 == RX_BUFFER_SIZE0) rx_rd_index0=0;
#endif
#asm("cli")
--rx_counter0;
#asm("sei")
return data;
}
#pragma used-
#endif

// USART0 Transmitter buffer
#define TX_BUFFER_SIZE0 8
char tx_buffer0[TX_BUFFER_SIZE0];

#if TX_BUFFER_SIZE0 <= 256
unsigned char tx_wr_index0,tx_rd_index0,tx_counter0;
#else
unsigned int tx_wr_index0,tx_rd_index0,tx_counter0;
#endif

// USART0 Transmitter interrupt service routine
interrupt [USART0_TXC] void usart0_tx_isr(void)
{
if (tx_counter0)
   {
   --tx_counter0;
   UDR0=tx_buffer0[tx_rd_index0++];
#if TX_BUFFER_SIZE0 != 256
   if (tx_rd_index0 == TX_BUFFER_SIZE0) tx_rd_index0=0;
#endif
   }
}

#ifndef _DEBUG_TERMINAL_IO_
// Write a character to the USART0 Transmitter buffer
#define _ALTERNATE_PUTCHAR_
#pragma used+
void putchar(char c)
{
while (tx_counter0 == TX_BUFFER_SIZE0);
#asm("cli")
if (tx_counter0 || ((UCSR0A & DATA_REGISTER_EMPTY)==0))
   {
   tx_buffer0[tx_wr_index0++]=c;
#if TX_BUFFER_SIZE0 != 256
   if (tx_wr_index0 == TX_BUFFER_SIZE0) tx_wr_index0=0;
#endif
   ++tx_counter0;
   }
else
   UDR0=c;
#asm("sei")
}
#pragma used-
#endif
//*************************************************************************************************
//********************END SERIAL STUFF (USART0)  **************************************************
//*************************************************************************************************
//*******   if you need USART1, enable it in Code Wizard and copy coresponding code here  *********
//*************************************************************************************************

/*
 * Timer 1 Output Compare A interrupt is used to blink LED
 */
interrupt [TIM1_COMPA] void timer1_compa_isr(void)
{
LED1 = ~LED1; // invert LED    
}     

//unsigned char AdresaNebuna = 0x3F;  
//unsigned char ComandaFantastica = 0x08; 

/*interrupt [TWI]    void i2c_isr(void)
{ 
    if(StareI2c == 0){    //s-a trimis start, fa setup pentru adresa
       StareI2c = 1;  
       LED1 = 1;     
       TWDR = AdresaNebuna;
    }
    else if(StareI2c == 1){//s-a trimis adresa, fa setup pentru stop
        StareI2c = 2; 
        LED1 = 0; 
        TWCR |= (1<<TWSTO);   
    }               
    else{
        StareI2c = 0;
    }
    
}    */                      

/*
 * main function of program
 */  
unsigned short ButoaneUpdate(){
    volatile unsigned short StareButoane = 0x00, i;  
    volatile unsigned char aux;  
    
    PORTA = (1<<PINA4);// & 0xF0; 
    DDRA = 0xFF;
    delay_us(1);
    DDRA = (1<<PINA4);
    for(i=0; i<10;i++){
        aux = PINA;
    }       
    StareButoane |= (unsigned short)(aux & ((1<<PINA0) | (1<<PINA1) | (1<< PINA2) | (1<<PINA3)));   

    PORTA = (1<<PINA5);// & 0xF0;
    DDRA = 0xFF;
    delay_us(1);
    DDRA = (1<<PINA5);                                      
    for(i=0; i<10;i++){
        aux = PINA;
    } 
    StareButoane |= (unsigned short)(aux & ((1<<PINA0) | (1<<PINA1) | (1<< PINA2) | (1<<PINA3))) << 4;   
    
    PORTA = (1<<PINA6);// & 0xF0;
    DDRA = 0xFF;
    delay_us(1);
    DDRA = (1<<PINA6);
    for(i=0; i<10;i++){
        aux = PINA;
    }    
    StareButoane |= (unsigned short)(aux & ((1<<PINA0) | (1<<PINA1) | (1<< PINA2) | (1<<PINA3))) << 8;   
    
    PORTA = (1<<PINA7);// & 0xF0;
    DDRA = 0xFF;
    delay_us(1);
    DDRA = (1<<PINA7);
    for(i=0; i<10;i++){
        aux = PINA;
    }           
    PORTA = 0;
    StareButoane |= (unsigned short)(aux & ((1<<PINA0) | (1<<PINA1) | (1<< PINA2) | (1<<PINA3))) << 12; 
      
    return StareButoane;               
}

void TrimiteButoane(unsigned short Butoane){
    unsigned char i;
    for(i = 0; i < 16; i++){
        if(Butoane % 2 == 1){
            putchar(i + 'a');
        }        
        Butoane /= 2;
    }  
    putchar(' ');
}
void main (void)
{          
unsigned short butoane;
	Init_initController();  // this must be the first "init" action/call!
	#asm("sei")             // enable interrupts
	LED1 = 1;           	// initial state, will be changed by timer 1
    //putchar(AdresaNebuna);
    //DDRC &= (1<<0) | (1<<1); 
    //PORTC=(1<<0) | (1<<1);
    //TWBR = (1<<6) & (1<<3);
    //TWCR = (1<<TWIE);      
    
	while(TRUE)
	{                         
        //LED1 = ~LED1;           
        delay_ms(1);
        butoane = ButoaneUpdate();
        TrimiteButoane(butoane);
        //ComandaFantastica = 0x0F;     
        //TWDR = AdresaNebuna;
        //TWCR |= (1<<TWEN) | (1<<TWSTA);
    } 

            
}// end main loop 



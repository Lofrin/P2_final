#include "functii.h"
#include <mega164a.h>
#include <delay.h>  
#include <stdio.h>

unsigned short ButoaneUpdate(){
    static unsigned short StareButoaneInainte = 0x00;
    volatile unsigned short StareButoane = 0x00, ButoaneApasate = 0x00, i;  
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
    
    for(i=0;i<16;i++){
        if(((StareButoaneInainte & ((unsigned short)1<<i)) == 0) && ((StareButoane & ((unsigned short)1<<i)) != 0)){
            ButoaneApasate |= ((unsigned short)1<<i);
        }
    }            
    StareButoaneInainte = StareButoane;
    return ButoaneApasate;               
}

void TrimiteButoane(unsigned short Butoane){
    unsigned char i, Printez = 0;
    for(i = 0; i < 16; i++){
        if(Butoane % 2 == 1){
            putchar(i + 'a');    
            Printez = 1;
        }        
        Butoane /= 2;
    }                   
    if(Printez){
        putchar('\r');
    }

}

#include "functii.h"
#include <mega164a.h>
#include <delay.h>  
#include <stdio.h>
#include <i2c.h>
unsigned char displayJoc[9] = {'.', '.', '.','.', '.', '.','.', '.', '.'};
unsigned char caracterUrmator = 'X', remiza = 9, castigat = 0;
#define AdresaDisplayMic 0x3C
                                
unsigned char font8x8_basic[65][8] = {
    { 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00},   // U+0020 (space)
    { 0x18, 0x3C, 0x3C, 0x18, 0x18, 0x00, 0x18, 0x00},   // U+0021 (!)
    { 0x36, 0x36, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00},   // U+0022 (")
    { 0x36, 0x36, 0x7F, 0x36, 0x7F, 0x36, 0x36, 0x00},   // U+0023 (#)
    { 0x0C, 0x3E, 0x03, 0x1E, 0x30, 0x1F, 0x0C, 0x00},   // U+0024 ($)
    { 0x00, 0x63, 0x33, 0x18, 0x0C, 0x66, 0x63, 0x00},   // U+0025 (%)
    { 0x1C, 0x36, 0x1C, 0x6E, 0x3B, 0x33, 0x6E, 0x00},   // U+0026 (&)
    { 0x06, 0x06, 0x03, 0x00, 0x00, 0x00, 0x00, 0x00},   // U+0027 (')
    { 0x18, 0x0C, 0x06, 0x06, 0x06, 0x0C, 0x18, 0x00},   // U+0028 (()
    { 0x06, 0x0C, 0x18, 0x18, 0x18, 0x0C, 0x06, 0x00},   // U+0029 ())
    { 0x00, 0x66, 0x3C, 0xFF, 0x3C, 0x66, 0x00, 0x00},   // U+002A (*)
    { 0x00, 0x0C, 0x0C, 0x3F, 0x0C, 0x0C, 0x00, 0x00},   // U+002B (+)
    { 0x00, 0x00, 0x00, 0x00, 0x00, 0x0C, 0x0C, 0x06},   // U+002C (,)
    { 0x00, 0x00, 0x00, 0x3F, 0x00, 0x00, 0x00, 0x00},   // U+002D (-)
    { 0x00, 0x00, 0x00, 0x00, 0x00, 0x0C, 0x0C, 0x00},   // U+002E (.)
    { 0x60, 0x30, 0x18, 0x0C, 0x06, 0x03, 0x01, 0x00},   // U+002F (/)
    { 0x3E, 0x63, 0x73, 0x7B, 0x6F, 0x67, 0x3E, 0x00},   // U+0030 (0)
    { 0x0C, 0x0E, 0x0C, 0x0C, 0x0C, 0x0C, 0x3F, 0x00},   // U+0031 (1)
    { 0x1E, 0x33, 0x30, 0x1C, 0x06, 0x33, 0x3F, 0x00},   // U+0032 (2)
    { 0x1E, 0x33, 0x30, 0x1C, 0x30, 0x33, 0x1E, 0x00},   // U+0033 (3)
    { 0x38, 0x3C, 0x36, 0x33, 0x7F, 0x30, 0x78, 0x00},   // U+0034 (4)
    { 0x3F, 0x03, 0x1F, 0x30, 0x30, 0x33, 0x1E, 0x00},   // U+0035 (5)
    { 0x1C, 0x06, 0x03, 0x1F, 0x33, 0x33, 0x1E, 0x00},   // U+0036 (6)
    { 0x3F, 0x33, 0x30, 0x18, 0x0C, 0x0C, 0x0C, 0x00},   // U+0037 (7)
    { 0x1E, 0x33, 0x33, 0x1E, 0x33, 0x33, 0x1E, 0x00},   // U+0038 (8)
    { 0x1E, 0x33, 0x33, 0x3E, 0x30, 0x18, 0x0E, 0x00},   // U+0039 (9)
    { 0x00, 0x0C, 0x0C, 0x00, 0x00, 0x0C, 0x0C, 0x00},   // U+003A (:)
    { 0x00, 0x0C, 0x0C, 0x00, 0x00, 0x0C, 0x0C, 0x06},   // U+003B (;)
    { 0x18, 0x0C, 0x06, 0x03, 0x06, 0x0C, 0x18, 0x00},   // U+003C (<)
    { 0x00, 0x00, 0x3F, 0x00, 0x00, 0x3F, 0x00, 0x00},   // U+003D (=)
    { 0x06, 0x0C, 0x18, 0x30, 0x18, 0x0C, 0x06, 0x00},   // U+003E (>)
    { 0x1E, 0x33, 0x30, 0x18, 0x0C, 0x00, 0x0C, 0x00},   // U+003F (?)
    { 0x3E, 0x63, 0x7B, 0x7B, 0x7B, 0x03, 0x1E, 0x00},   // U+0040 (@)
    { 0x0C, 0x1E, 0x33, 0x33, 0x3F, 0x33, 0x33, 0x00},   // U+0041 (A)
    { 0x3F, 0x66, 0x66, 0x3E, 0x66, 0x66, 0x3F, 0x00},   // U+0042 (B)
    { 0x3C, 0x66, 0x03, 0x03, 0x03, 0x66, 0x3C, 0x00},   // U+0043 (C)
    { 0x1F, 0x36, 0x66, 0x66, 0x66, 0x36, 0x1F, 0x00},   // U+0044 (D)
    { 0x7F, 0x46, 0x16, 0x1E, 0x16, 0x46, 0x7F, 0x00},   // U+0045 (E)
    { 0x7F, 0x46, 0x16, 0x1E, 0x16, 0x06, 0x0F, 0x00},   // U+0046 (F)
    { 0x3C, 0x66, 0x03, 0x03, 0x73, 0x66, 0x7C, 0x00},   // U+0047 (G)
    { 0x33, 0x33, 0x33, 0x3F, 0x33, 0x33, 0x33, 0x00},   // U+0048 (H)
    { 0x1E, 0x0C, 0x0C, 0x0C, 0x0C, 0x0C, 0x1E, 0x00},   // U+0049 (I)
    { 0x78, 0x30, 0x30, 0x30, 0x33, 0x33, 0x1E, 0x00},   // U+004A (J)
    { 0x67, 0x66, 0x36, 0x1E, 0x36, 0x66, 0x67, 0x00},   // U+004B (K)
    { 0x0F, 0x06, 0x06, 0x06, 0x46, 0x66, 0x7F, 0x00},   // U+004C (L)
    { 0x63, 0x77, 0x7F, 0x7F, 0x6B, 0x63, 0x63, 0x00},   // U+004D (M)
    { 0x63, 0x67, 0x6F, 0x7B, 0x73, 0x63, 0x63, 0x00},   // U+004E (N)
    { 0x1C, 0x36, 0x63, 0x63, 0x63, 0x36, 0x1C, 0x00},   // U+004F (O)
    { 0x3F, 0x66, 0x66, 0x3E, 0x06, 0x06, 0x0F, 0x00},   // U+0050 (P)
    { 0x1E, 0x33, 0x33, 0x33, 0x3B, 0x1E, 0x38, 0x00},   // U+0051 (Q)
    { 0x3F, 0x66, 0x66, 0x3E, 0x36, 0x66, 0x67, 0x00},   // U+0052 (R)
    { 0x1E, 0x33, 0x07, 0x0E, 0x38, 0x33, 0x1E, 0x00},   // U+0053 (S)
    { 0x3F, 0x2D, 0x0C, 0x0C, 0x0C, 0x0C, 0x1E, 0x00},   // U+0054 (T)
    { 0x33, 0x33, 0x33, 0x33, 0x33, 0x33, 0x3F, 0x00},   // U+0055 (U)
    { 0x33, 0x33, 0x33, 0x33, 0x33, 0x1E, 0x0C, 0x00},   // U+0056 (V)
    { 0x63, 0x63, 0x63, 0x6B, 0x7F, 0x77, 0x63, 0x00},   // U+0057 (W)
    { 0x63, 0x63, 0x36, 0x1C, 0x1C, 0x36, 0x63, 0x00},   // U+0058 (X)
    { 0x33, 0x33, 0x33, 0x1E, 0x0C, 0x0C, 0x1E, 0x00},   // U+0059 (Y)
    { 0x7F, 0x63, 0x31, 0x18, 0x4C, 0x66, 0x7F, 0x00},   // U+005A (Z)
    { 0x1E, 0x06, 0x06, 0x06, 0x06, 0x06, 0x1E, 0x00},   // U+005B ([)
    { 0x03, 0x06, 0x0C, 0x18, 0x30, 0x60, 0x40, 0x00},   // U+005C (\)
    { 0x1E, 0x18, 0x18, 0x18, 0x18, 0x18, 0x1E, 0x00},   // U+005D (])
    { 0x08, 0x1C, 0x36, 0x63, 0x00, 0x00, 0x00, 0x00},   // U+005E (^)
    { 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0xFF},   // U+005F (_)
    { 0x0C, 0x0C, 0x18, 0x00, 0x00, 0x00, 0x00, 0x00}   // U+0060 (`)
};

unsigned short ButoaneUpdate(){
    static unsigned short StareButoaneInainte = 0x00;    //16 biti
    volatile unsigned short StareButoane = 0x00, ButoaneApasate = 0x00, i; //16 biti  
    volatile unsigned char aux; //8 biti, folosesc 4  
    
    PORTA = (1<<PINA4);// pornesc pullup pe pinul a4
    DDRA = 0xFF;   //fac tot portul a sa fie sink pentru a scoate pinii din high-impedance si a ii aduce intr-o stare definita
    delay_us(1);  
    DDRA = (1<<PINA4);  //fac pinul a4 de iesire pentru a alimenta butoanele
    for(i=0; i<10;i++){
        aux = PINA;      //citesc pinul de mai multe ori pentru a face debounce
    }       
    StareButoane |= (unsigned short)(aux & ((1<<PINA0) | (1<<PINA1) | (1<< PINA2) | (1<<PINA3)));//citesc cei 4 pini de intrare si ii salvez in variabila   

    PORTA = (1<<PINA5);// pornesc pullup pe pinul a5
    DDRA = 0xFF;   //fac tot portul a sa fie sink pentru a scoate pinii din high-impedance si a ii aduce intr-o stare definita
    delay_us(1);
    DDRA = (1<<PINA5);   //fac pinul a5 de iesire pentru a alimenta butoanele                                    
    for(i=0; i<10;i++){
        aux = PINA;
    } 
    StareButoane |= (unsigned short)(aux & ((1<<PINA0) | (1<<PINA1) | (1<< PINA2) | (1<<PINA3))) << 4;//citesc cei 4 pini si ii salvez in variabila cu un offset de 4   
    
    PORTA = (1<<PINA6);// pornesc pullup pe pinul a6
    DDRA = 0xFF;   //fac tot portul a sa fie sink pentru a scoate pinii din high-impedance si a ii aduce intr-o stare definita
    delay_us(1);
    DDRA = (1<<PINA6);    //fac pinul a6 de iesire pentru a alimenta butoanele 
    for(i=0; i<10;i++){
        aux = PINA;      //citesc pinul de mai multe ori pentru a face debounce
    }    
    StareButoane |= (unsigned short)(aux & ((1<<PINA0) | (1<<PINA1) | (1<< PINA2) | (1<<PINA3))) << 8; //citesc cei 4 pini si ii salvez in variabila cu un offset de 8  
    
    PORTA = (1<<PINA7);// pornesc pullup pe pinul a7
    DDRA = 0xFF;   //fac tot portul a sa fie sink pentru a scoate pinii din high-impedance si a ii aduce intr-o stare definita
    delay_us(1);
    DDRA = (1<<PINA7);  //fac pinul a7 de iesire pentru a alimenta butoanele 
    for(i=0; i<10;i++){
        aux = PINA;      //citesc pinul de mai multe ori pentru a face debounce
    }           
    PORTA = 0;         
    //dupa asta am starea curenta a butoanelor (apasate/neapasate)
    StareButoane |= (unsigned short)(aux & ((1<<PINA0) | (1<<PINA1) | (1<< PINA2) | (1<<PINA3))) << 12;  //citesc cei 4 pini si ii salvez in variabila cu un offset de 12       
    
    for(i=0;i<16;i++){//pentru a nu primi input incontinuu, salvam doar trecerea din 0 in 1 a pinilor
        if(((StareButoaneInainte & ((unsigned short)1<<i)) == 0) && ((StareButoane & ((unsigned short)1<<i)) != 0)){//daca la ultimul test pinii erau opriti iar acum sunt porniti, butonul a fost apasat 
            ButoaneApasate |= ((unsigned short)1<<i);//salvez apasarea o singura data
        }
    }            
    StareButoaneInainte = StareButoane;   //memorez noua stare a pinilor 
    return ButoaneApasate;               //intorc apasarea o singura data
}

void TrimiteButoane(unsigned short Butoane){
    unsigned char i, Printez = 0;
    for(i = 0; i < 16; i++){
        if(Butoane % 2 == 1){
            putchar(i + 'a');//printez butoanele apasate ca litere pe uart    
            Printez = 1;
        }        
        Butoane /= 2;
    }                   
    if(Printez){    //daca a fost printat macar un buton, merg si pe urmatoarea linie
        putchar('\r');
    }

}

void PrinteazaJoc(){
    unsigned char i = 0, j=0;  
    for(i=0;i<3;i++){
        for(j=0;j<3;j++){
            putchar(displayJoc[i*3U+j]);//printez matricea jocului 3x3
        }                              
        putchar('\r');
    }  
    putchar('\r');
}

void VerificaInvingatorul(){
    unsigned char i; 
    for(i=0;i<3;i++){  
        //verifica invingatorul pe linii
        if(((displayJoc[i*3U] == displayJoc[i*3U+1U]) &&( displayJoc[i*3U+1U] == displayJoc[i*3U+2U])) && displayJoc[i*3U] != '.'){
            castigat = displayJoc[i*3U];
        }       
        //verifica invingatorul pe coloane
        if(((displayJoc[i] == displayJoc[i+3U]) &&( displayJoc[i+3U] == displayJoc[i+6U])) && displayJoc[i] != '.'){
            castigat = displayJoc[i];
        }            
    }       
    //verifica invingatorul pe diagonale
    if(((displayJoc[0U] == displayJoc[4U]) &&( displayJoc[4U] == displayJoc[8U])) && displayJoc[0U] != '.'){
            castigat = displayJoc[4U];
    } 
    if(((displayJoc[6U] == displayJoc[4U]) &&( displayJoc[4U] == displayJoc[2U])) && displayJoc[2U] != '.'){
            castigat = displayJoc[4U];
    } 
}

void UpdateJoc(unsigned short butoane){
    unsigned char i, j;
    for(i=0;i<3;i++){
        for(j=0; j<3;j++){
            if((butoane & ((unsigned short)1<<(i*4+j))) != 0){ //trec prin fiecare casuta in parte si verific daca butonul ei a fost apasat
                if( displayJoc[j*3U+(2U-i)] == '.'){    //daca nu e niciun semn acolo, pot pune urmatorul caracter
                    remiza--;//scad numarul de caractere ramase pana la remiza
                    displayJoc[j*3U+(2U-i)] = caracterUrmator;//pun in casuta caracterul urmator;  
                    if(caracterUrmator == 'X'){//schimb caracterul ce urmeaza
                        caracterUrmator = '0';
                    }                        
                    else{
                        caracterUrmator = 'X';
                    }
                }
                break;
            }
        }

    }
}

void PrintCaracterDisplay(unsigned char caracter){
    unsigned char i;                              
    if(caracter >= 32){
        caracter-=32; 
        i2c_start();
        i2c_write(AdresaDisplayMic<<1);
        i2c_write(0x40);
        //construiesc caracterul
        for(i=0;i<8U;i++){
            i2c_write(font8x8_basic[caracter][i]);
        }
        i2c_stop();   
    }

}

void Data1Bit(unsigned char data){
    i2c_start();
    i2c_write(AdresaDisplayMic<<1);
    i2c_write(0xC0);
    i2c_write(data);
    i2c_stop();
}

void Comanda1Bit(unsigned char comanda1){
    i2c_start();
    i2c_write(AdresaDisplayMic<<1);
    i2c_write(0x80);
    i2c_write(comanda1);
    i2c_stop();
}

void Comanda2Biti(unsigned char comanda1, unsigned char comanda2){
    i2c_start();
    i2c_write(AdresaDisplayMic<<1);
    i2c_write(0x00);
    i2c_write(comanda1);  
    i2c_write(comanda2);
    i2c_stop();
}

void Comanda3Biti(unsigned char comanda1, unsigned char comanda2, unsigned char comanda3){
    i2c_start();
    i2c_write(AdresaDisplayMic<<1);
    i2c_write(0x00);
    i2c_write(comanda1);  
    i2c_write(comanda2);
    i2c_write(comanda3);
    i2c_stop();
}

void InitDisplay(){
    Comanda1Bit(0xAF);//on
    Comanda2Biti(0xD5, 0x80);//clk
    Comanda2Biti(0xA8, 0x1F);//multiplex
    Comanda1Bit(0x40);//start line
    Comanda2Biti(0x8D, 0x14);//charge pump
    Comanda2Biti(0xA1, 0xC8);//segmente remap
    Comanda2Biti(0xDA, 0x02);//com hw config
    Comanda2Biti(0xD3, 0x00);//offset
    Comanda2Biti(0x81, 0x05);//contrast/luminozitate
    Comanda2Biti(0xD9, 0xF1);//precharge period
    Comanda2Biti(0xDB, 0x20);//VCOMh deselect level
    Comanda3Biti(0x22, 0x00, 0x03);//page range
    Comanda3Biti(0x21, 0x00, 0x7F);//column range
    Comanda1Bit(0xA4);//all pixeli on
    Comanda1Bit(0xA6);//non inverted
    Comanda1Bit(0xAF);//display on
    Comanda2Biti(0x20, 0x00);//address mode
}

void DisplayClear(){
    unsigned char i; 
    Comanda3Biti(0x22, 0x00, 0x03);//page range
    Comanda3Biti(0x21, 0x00, 0x7F);//column range
    for(i = 0U; i < 16U*4U; i++){
        PrintCaracterDisplay(32);
    }
}   

void RotescLiterele(){
    unsigned char CharactersLine, BitmapCharacterIndex, BitmapLineIndex, i;
    unsigned char TempCharactersLine[8];                                
    int j;
    for(BitmapCharacterIndex = 0U; BitmapCharacterIndex < 65U; BitmapCharacterIndex++){
        for(BitmapLineIndex = 0U; BitmapLineIndex < 8U; BitmapLineIndex++){
            CharactersLine = 0;
            for(j = 7U; j >= 0U; j--){
                CharactersLine = CharactersLine << 1U;
                CharactersLine += ((font8x8_basic[BitmapCharacterIndex][j]) >> BitmapLineIndex) % 2U;
            }                                                                                        
            TempCharactersLine[BitmapLineIndex] = CharactersLine;
        }                                                        
        for(i = 0U; i < 8U; i++){
            font8x8_basic[BitmapCharacterIndex][i] = TempCharactersLine[i];
        }
    }
}

void PrinteazaJocDisplay(){
    unsigned char i = 0, j=0;
    Comanda3Biti(0x22, 0x00, 0x03);//page range
    Comanda3Biti(0x21, 0x00, 0x7F);//column range  
    for(i=0;i<3;i++){
        for(j=0;j<3;j++){
            PrintCaracterDisplay(displayJoc[i*3U+j]);//printez matricea jocului 3x3
        } 
        for(j=3;j<16;j++){
            PrintCaracterDisplay(' ');
        }                             
    }  
}
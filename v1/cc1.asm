
;CodeVisionAVR C Compiler V3.12 Advanced
;(C) Copyright 1998-2014 Pavel Haiduc, HP InfoTech s.r.l.
;http://www.hpinfotech.com

;Build configuration    : Release
;Chip type              : ATmega164A
;Program type           : Application
;Clock frequency        : 20,000000 MHz
;Memory model           : Small
;Optimize for           : Size
;(s)printf features     : int, width
;(s)scanf features      : int, width
;External RAM size      : 0
;Data Stack size        : 256 byte(s)
;Heap size              : 0 byte(s)
;Promote 'char' to 'int': No
;'char' is unsigned     : No
;8 bit enums            : Yes
;Global 'const' stored in FLASH: No
;Enhanced function parameter passing: Yes
;Enhanced core instructions: On
;Automatic register allocation for global variables: On
;Smart register allocation: On

	#define _MODEL_SMALL_

	#pragma AVRPART ADMIN PART_NAME ATmega164A
	#pragma AVRPART MEMORY PROG_FLASH 16384
	#pragma AVRPART MEMORY EEPROM 512
	#pragma AVRPART MEMORY INT_SRAM SIZE 1024
	#pragma AVRPART MEMORY INT_SRAM START_ADDR 0x100

	#define CALL_SUPPORTED 1

	.LISTMAC
	.EQU EERE=0x0
	.EQU EEWE=0x1
	.EQU EEMWE=0x2
	.EQU UDRE=0x5
	.EQU RXC=0x7
	.EQU EECR=0x1F
	.EQU EEDR=0x20
	.EQU EEARL=0x21
	.EQU EEARH=0x22
	.EQU SPSR=0x2D
	.EQU SPDR=0x2E
	.EQU SMCR=0x33
	.EQU MCUSR=0x34
	.EQU MCUCR=0x35
	.EQU WDTCSR=0x60
	.EQU UCSR0A=0xC0
	.EQU UDR0=0xC6
	.EQU SPL=0x3D
	.EQU SPH=0x3E
	.EQU SREG=0x3F
	.EQU GPIOR0=0x1E
	.EQU GPIOR1=0x2A
	.EQU GPIOR2=0x2B

	.DEF R0X0=R0
	.DEF R0X1=R1
	.DEF R0X2=R2
	.DEF R0X3=R3
	.DEF R0X4=R4
	.DEF R0X5=R5
	.DEF R0X6=R6
	.DEF R0X7=R7
	.DEF R0X8=R8
	.DEF R0X9=R9
	.DEF R0XA=R10
	.DEF R0XB=R11
	.DEF R0XC=R12
	.DEF R0XD=R13
	.DEF R0XE=R14
	.DEF R0XF=R15
	.DEF R0X10=R16
	.DEF R0X11=R17
	.DEF R0X12=R18
	.DEF R0X13=R19
	.DEF R0X14=R20
	.DEF R0X15=R21
	.DEF R0X16=R22
	.DEF R0X17=R23
	.DEF R0X18=R24
	.DEF R0X19=R25
	.DEF R0X1A=R26
	.DEF R0X1B=R27
	.DEF R0X1C=R28
	.DEF R0X1D=R29
	.DEF R0X1E=R30
	.DEF R0X1F=R31

	.EQU __SRAM_START=0x0100
	.EQU __SRAM_END=0x04FF
	.EQU __DSTACK_SIZE=0x0100
	.EQU __HEAP_SIZE=0x0000
	.EQU __CLEAR_SRAM_SIZE=__SRAM_END-__SRAM_START+1

	.MACRO __CPD1N
	CPI  R30,LOW(@0)
	LDI  R26,HIGH(@0)
	CPC  R31,R26
	LDI  R26,BYTE3(@0)
	CPC  R22,R26
	LDI  R26,BYTE4(@0)
	CPC  R23,R26
	.ENDM

	.MACRO __CPD2N
	CPI  R26,LOW(@0)
	LDI  R30,HIGH(@0)
	CPC  R27,R30
	LDI  R30,BYTE3(@0)
	CPC  R24,R30
	LDI  R30,BYTE4(@0)
	CPC  R25,R30
	.ENDM

	.MACRO __CPWRR
	CP   R@0,R@2
	CPC  R@1,R@3
	.ENDM

	.MACRO __CPWRN
	CPI  R@0,LOW(@2)
	LDI  R30,HIGH(@2)
	CPC  R@1,R30
	.ENDM

	.MACRO __ADDB1MN
	SUBI R30,LOW(-@0-(@1))
	.ENDM

	.MACRO __ADDB2MN
	SUBI R26,LOW(-@0-(@1))
	.ENDM

	.MACRO __ADDW1MN
	SUBI R30,LOW(-@0-(@1))
	SBCI R31,HIGH(-@0-(@1))
	.ENDM

	.MACRO __ADDW2MN
	SUBI R26,LOW(-@0-(@1))
	SBCI R27,HIGH(-@0-(@1))
	.ENDM

	.MACRO __ADDW1FN
	SUBI R30,LOW(-2*@0-(@1))
	SBCI R31,HIGH(-2*@0-(@1))
	.ENDM

	.MACRO __ADDD1FN
	SUBI R30,LOW(-2*@0-(@1))
	SBCI R31,HIGH(-2*@0-(@1))
	SBCI R22,BYTE3(-2*@0-(@1))
	.ENDM

	.MACRO __ADDD1N
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	SBCI R22,BYTE3(-@0)
	SBCI R23,BYTE4(-@0)
	.ENDM

	.MACRO __ADDD2N
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	SBCI R24,BYTE3(-@0)
	SBCI R25,BYTE4(-@0)
	.ENDM

	.MACRO __SUBD1N
	SUBI R30,LOW(@0)
	SBCI R31,HIGH(@0)
	SBCI R22,BYTE3(@0)
	SBCI R23,BYTE4(@0)
	.ENDM

	.MACRO __SUBD2N
	SUBI R26,LOW(@0)
	SBCI R27,HIGH(@0)
	SBCI R24,BYTE3(@0)
	SBCI R25,BYTE4(@0)
	.ENDM

	.MACRO __ANDBMNN
	LDS  R30,@0+(@1)
	ANDI R30,LOW(@2)
	STS  @0+(@1),R30
	.ENDM

	.MACRO __ANDWMNN
	LDS  R30,@0+(@1)
	ANDI R30,LOW(@2)
	STS  @0+(@1),R30
	LDS  R30,@0+(@1)+1
	ANDI R30,HIGH(@2)
	STS  @0+(@1)+1,R30
	.ENDM

	.MACRO __ANDD1N
	ANDI R30,LOW(@0)
	ANDI R31,HIGH(@0)
	ANDI R22,BYTE3(@0)
	ANDI R23,BYTE4(@0)
	.ENDM

	.MACRO __ANDD2N
	ANDI R26,LOW(@0)
	ANDI R27,HIGH(@0)
	ANDI R24,BYTE3(@0)
	ANDI R25,BYTE4(@0)
	.ENDM

	.MACRO __ORBMNN
	LDS  R30,@0+(@1)
	ORI  R30,LOW(@2)
	STS  @0+(@1),R30
	.ENDM

	.MACRO __ORWMNN
	LDS  R30,@0+(@1)
	ORI  R30,LOW(@2)
	STS  @0+(@1),R30
	LDS  R30,@0+(@1)+1
	ORI  R30,HIGH(@2)
	STS  @0+(@1)+1,R30
	.ENDM

	.MACRO __ORD1N
	ORI  R30,LOW(@0)
	ORI  R31,HIGH(@0)
	ORI  R22,BYTE3(@0)
	ORI  R23,BYTE4(@0)
	.ENDM

	.MACRO __ORD2N
	ORI  R26,LOW(@0)
	ORI  R27,HIGH(@0)
	ORI  R24,BYTE3(@0)
	ORI  R25,BYTE4(@0)
	.ENDM

	.MACRO __DELAY_USB
	LDI  R24,LOW(@0)
__DELAY_USB_LOOP:
	DEC  R24
	BRNE __DELAY_USB_LOOP
	.ENDM

	.MACRO __DELAY_USW
	LDI  R24,LOW(@0)
	LDI  R25,HIGH(@0)
__DELAY_USW_LOOP:
	SBIW R24,1
	BRNE __DELAY_USW_LOOP
	.ENDM

	.MACRO __GETD1S
	LDD  R30,Y+@0
	LDD  R31,Y+@0+1
	LDD  R22,Y+@0+2
	LDD  R23,Y+@0+3
	.ENDM

	.MACRO __GETD2S
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	LDD  R24,Y+@0+2
	LDD  R25,Y+@0+3
	.ENDM

	.MACRO __PUTD1S
	STD  Y+@0,R30
	STD  Y+@0+1,R31
	STD  Y+@0+2,R22
	STD  Y+@0+3,R23
	.ENDM

	.MACRO __PUTD2S
	STD  Y+@0,R26
	STD  Y+@0+1,R27
	STD  Y+@0+2,R24
	STD  Y+@0+3,R25
	.ENDM

	.MACRO __PUTDZ2
	STD  Z+@0,R26
	STD  Z+@0+1,R27
	STD  Z+@0+2,R24
	STD  Z+@0+3,R25
	.ENDM

	.MACRO __CLRD1S
	STD  Y+@0,R30
	STD  Y+@0+1,R30
	STD  Y+@0+2,R30
	STD  Y+@0+3,R30
	.ENDM

	.MACRO __POINTB1MN
	LDI  R30,LOW(@0+(@1))
	.ENDM

	.MACRO __POINTW1MN
	LDI  R30,LOW(@0+(@1))
	LDI  R31,HIGH(@0+(@1))
	.ENDM

	.MACRO __POINTD1M
	LDI  R30,LOW(@0)
	LDI  R31,HIGH(@0)
	LDI  R22,BYTE3(@0)
	LDI  R23,BYTE4(@0)
	.ENDM

	.MACRO __POINTW1FN
	LDI  R30,LOW(2*@0+(@1))
	LDI  R31,HIGH(2*@0+(@1))
	.ENDM

	.MACRO __POINTD1FN
	LDI  R30,LOW(2*@0+(@1))
	LDI  R31,HIGH(2*@0+(@1))
	LDI  R22,BYTE3(2*@0+(@1))
	LDI  R23,BYTE4(2*@0+(@1))
	.ENDM

	.MACRO __POINTB2MN
	LDI  R26,LOW(@0+(@1))
	.ENDM

	.MACRO __POINTW2MN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	.ENDM

	.MACRO __POINTW2FN
	LDI  R26,LOW(2*@0+(@1))
	LDI  R27,HIGH(2*@0+(@1))
	.ENDM

	.MACRO __POINTD2FN
	LDI  R26,LOW(2*@0+(@1))
	LDI  R27,HIGH(2*@0+(@1))
	LDI  R24,BYTE3(2*@0+(@1))
	LDI  R25,BYTE4(2*@0+(@1))
	.ENDM

	.MACRO __POINTBRM
	LDI  R@0,LOW(@1)
	.ENDM

	.MACRO __POINTWRM
	LDI  R@0,LOW(@2)
	LDI  R@1,HIGH(@2)
	.ENDM

	.MACRO __POINTBRMN
	LDI  R@0,LOW(@1+(@2))
	.ENDM

	.MACRO __POINTWRMN
	LDI  R@0,LOW(@2+(@3))
	LDI  R@1,HIGH(@2+(@3))
	.ENDM

	.MACRO __POINTWRFN
	LDI  R@0,LOW(@2*2+(@3))
	LDI  R@1,HIGH(@2*2+(@3))
	.ENDM

	.MACRO __GETD1N
	LDI  R30,LOW(@0)
	LDI  R31,HIGH(@0)
	LDI  R22,BYTE3(@0)
	LDI  R23,BYTE4(@0)
	.ENDM

	.MACRO __GETD2N
	LDI  R26,LOW(@0)
	LDI  R27,HIGH(@0)
	LDI  R24,BYTE3(@0)
	LDI  R25,BYTE4(@0)
	.ENDM

	.MACRO __GETB1MN
	LDS  R30,@0+(@1)
	.ENDM

	.MACRO __GETB1HMN
	LDS  R31,@0+(@1)
	.ENDM

	.MACRO __GETW1MN
	LDS  R30,@0+(@1)
	LDS  R31,@0+(@1)+1
	.ENDM

	.MACRO __GETD1MN
	LDS  R30,@0+(@1)
	LDS  R31,@0+(@1)+1
	LDS  R22,@0+(@1)+2
	LDS  R23,@0+(@1)+3
	.ENDM

	.MACRO __GETBRMN
	LDS  R@0,@1+(@2)
	.ENDM

	.MACRO __GETWRMN
	LDS  R@0,@2+(@3)
	LDS  R@1,@2+(@3)+1
	.ENDM

	.MACRO __GETWRZ
	LDD  R@0,Z+@2
	LDD  R@1,Z+@2+1
	.ENDM

	.MACRO __GETD2Z
	LDD  R26,Z+@0
	LDD  R27,Z+@0+1
	LDD  R24,Z+@0+2
	LDD  R25,Z+@0+3
	.ENDM

	.MACRO __GETB2MN
	LDS  R26,@0+(@1)
	.ENDM

	.MACRO __GETW2MN
	LDS  R26,@0+(@1)
	LDS  R27,@0+(@1)+1
	.ENDM

	.MACRO __GETD2MN
	LDS  R26,@0+(@1)
	LDS  R27,@0+(@1)+1
	LDS  R24,@0+(@1)+2
	LDS  R25,@0+(@1)+3
	.ENDM

	.MACRO __PUTB1MN
	STS  @0+(@1),R30
	.ENDM

	.MACRO __PUTW1MN
	STS  @0+(@1),R30
	STS  @0+(@1)+1,R31
	.ENDM

	.MACRO __PUTD1MN
	STS  @0+(@1),R30
	STS  @0+(@1)+1,R31
	STS  @0+(@1)+2,R22
	STS  @0+(@1)+3,R23
	.ENDM

	.MACRO __PUTB1EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	CALL __EEPROMWRB
	.ENDM

	.MACRO __PUTW1EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	CALL __EEPROMWRW
	.ENDM

	.MACRO __PUTD1EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	CALL __EEPROMWRD
	.ENDM

	.MACRO __PUTBR0MN
	STS  @0+(@1),R0
	.ENDM

	.MACRO __PUTBMRN
	STS  @0+(@1),R@2
	.ENDM

	.MACRO __PUTWMRN
	STS  @0+(@1),R@2
	STS  @0+(@1)+1,R@3
	.ENDM

	.MACRO __PUTBZR
	STD  Z+@1,R@0
	.ENDM

	.MACRO __PUTWZR
	STD  Z+@2,R@0
	STD  Z+@2+1,R@1
	.ENDM

	.MACRO __GETW1R
	MOV  R30,R@0
	MOV  R31,R@1
	.ENDM

	.MACRO __GETW2R
	MOV  R26,R@0
	MOV  R27,R@1
	.ENDM

	.MACRO __GETWRN
	LDI  R@0,LOW(@2)
	LDI  R@1,HIGH(@2)
	.ENDM

	.MACRO __PUTW1R
	MOV  R@0,R30
	MOV  R@1,R31
	.ENDM

	.MACRO __PUTW2R
	MOV  R@0,R26
	MOV  R@1,R27
	.ENDM

	.MACRO __ADDWRN
	SUBI R@0,LOW(-@2)
	SBCI R@1,HIGH(-@2)
	.ENDM

	.MACRO __ADDWRR
	ADD  R@0,R@2
	ADC  R@1,R@3
	.ENDM

	.MACRO __SUBWRN
	SUBI R@0,LOW(@2)
	SBCI R@1,HIGH(@2)
	.ENDM

	.MACRO __SUBWRR
	SUB  R@0,R@2
	SBC  R@1,R@3
	.ENDM

	.MACRO __ANDWRN
	ANDI R@0,LOW(@2)
	ANDI R@1,HIGH(@2)
	.ENDM

	.MACRO __ANDWRR
	AND  R@0,R@2
	AND  R@1,R@3
	.ENDM

	.MACRO __ORWRN
	ORI  R@0,LOW(@2)
	ORI  R@1,HIGH(@2)
	.ENDM

	.MACRO __ORWRR
	OR   R@0,R@2
	OR   R@1,R@3
	.ENDM

	.MACRO __EORWRR
	EOR  R@0,R@2
	EOR  R@1,R@3
	.ENDM

	.MACRO __GETWRS
	LDD  R@0,Y+@2
	LDD  R@1,Y+@2+1
	.ENDM

	.MACRO __PUTBSR
	STD  Y+@1,R@0
	.ENDM

	.MACRO __PUTWSR
	STD  Y+@2,R@0
	STD  Y+@2+1,R@1
	.ENDM

	.MACRO __MOVEWRR
	MOV  R@0,R@2
	MOV  R@1,R@3
	.ENDM

	.MACRO __INWR
	IN   R@0,@2
	IN   R@1,@2+1
	.ENDM

	.MACRO __OUTWR
	OUT  @2+1,R@1
	OUT  @2,R@0
	.ENDM

	.MACRO __CALL1MN
	LDS  R30,@0+(@1)
	LDS  R31,@0+(@1)+1
	ICALL
	.ENDM

	.MACRO __CALL1FN
	LDI  R30,LOW(2*@0+(@1))
	LDI  R31,HIGH(2*@0+(@1))
	CALL __GETW1PF
	ICALL
	.ENDM

	.MACRO __CALL2EN
	PUSH R26
	PUSH R27
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	CALL __EEPROMRDW
	POP  R27
	POP  R26
	ICALL
	.ENDM

	.MACRO __CALL2EX
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	CALL __EEPROMRDD
	ICALL
	.ENDM

	.MACRO __GETW1STACK
	IN   R30,SPL
	IN   R31,SPH
	ADIW R30,@0+1
	LD   R0,Z+
	LD   R31,Z
	MOV  R30,R0
	.ENDM

	.MACRO __GETD1STACK
	IN   R30,SPL
	IN   R31,SPH
	ADIW R30,@0+1
	LD   R0,Z+
	LD   R1,Z+
	LD   R22,Z
	MOVW R30,R0
	.ENDM

	.MACRO __NBST
	BST  R@0,@1
	IN   R30,SREG
	LDI  R31,0x40
	EOR  R30,R31
	OUT  SREG,R30
	.ENDM


	.MACRO __PUTB1SN
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SN
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SN
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1SNS
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	ADIW R26,@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SNS
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	ADIW R26,@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SNS
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	ADIW R26,@1
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1PMN
	LDS  R26,@0
	LDS  R27,@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1PMN
	LDS  R26,@0
	LDS  R27,@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1PMN
	LDS  R26,@0
	LDS  R27,@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1PMNS
	LDS  R26,@0
	LDS  R27,@0+1
	ADIW R26,@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1PMNS
	LDS  R26,@0
	LDS  R27,@0+1
	ADIW R26,@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1PMNS
	LDS  R26,@0
	LDS  R27,@0+1
	ADIW R26,@1
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RN
	MOVW R26,R@0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RN
	MOVW R26,R@0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RN
	MOVW R26,R@0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RNS
	MOVW R26,R@0
	ADIW R26,@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RNS
	MOVW R26,R@0
	ADIW R26,@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RNS
	MOVW R26,R@0
	ADIW R26,@1
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RON
	MOV  R26,R@0
	MOV  R27,R@1
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RON
	MOV  R26,R@0
	MOV  R27,R@1
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RON
	MOV  R26,R@0
	MOV  R27,R@1
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RONS
	MOV  R26,R@0
	MOV  R27,R@1
	ADIW R26,@2
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RONS
	MOV  R26,R@0
	MOV  R27,R@1
	ADIW R26,@2
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RONS
	MOV  R26,R@0
	MOV  R27,R@1
	ADIW R26,@2
	CALL __PUTDP1
	.ENDM


	.MACRO __GETB1SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R30,Z
	.ENDM

	.MACRO __GETB1HSX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R31,Z
	.ENDM

	.MACRO __GETW1SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R0,Z+
	LD   R31,Z
	MOV  R30,R0
	.ENDM

	.MACRO __GETD1SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R0,Z+
	LD   R1,Z+
	LD   R22,Z+
	LD   R23,Z
	MOVW R30,R0
	.ENDM

	.MACRO __GETB2SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R26,X
	.ENDM

	.MACRO __GETW2SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	.ENDM

	.MACRO __GETD2SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R1,X+
	LD   R24,X+
	LD   R25,X
	MOVW R26,R0
	.ENDM

	.MACRO __GETBRSX
	MOVW R30,R28
	SUBI R30,LOW(-@1)
	SBCI R31,HIGH(-@1)
	LD   R@0,Z
	.ENDM

	.MACRO __GETWRSX
	MOVW R30,R28
	SUBI R30,LOW(-@2)
	SBCI R31,HIGH(-@2)
	LD   R@0,Z+
	LD   R@1,Z
	.ENDM

	.MACRO __GETBRSX2
	MOVW R26,R28
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	LD   R@0,X
	.ENDM

	.MACRO __GETWRSX2
	MOVW R26,R28
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	LD   R@0,X+
	LD   R@1,X
	.ENDM

	.MACRO __LSLW8SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R31,Z
	CLR  R30
	.ENDM

	.MACRO __PUTB1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X+,R31
	ST   X+,R22
	ST   X,R23
	.ENDM

	.MACRO __CLRW1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X,R30
	.ENDM

	.MACRO __CLRD1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X+,R30
	ST   X+,R30
	ST   X,R30
	.ENDM

	.MACRO __PUTB2SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	ST   Z,R26
	.ENDM

	.MACRO __PUTW2SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	ST   Z+,R26
	ST   Z,R27
	.ENDM

	.MACRO __PUTD2SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	ST   Z+,R26
	ST   Z+,R27
	ST   Z+,R24
	ST   Z,R25
	.ENDM

	.MACRO __PUTBSRX
	MOVW R30,R28
	SUBI R30,LOW(-@1)
	SBCI R31,HIGH(-@1)
	ST   Z,R@0
	.ENDM

	.MACRO __PUTWSRX
	MOVW R30,R28
	SUBI R30,LOW(-@2)
	SBCI R31,HIGH(-@2)
	ST   Z+,R@0
	ST   Z,R@1
	.ENDM

	.MACRO __PUTB1SNX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SNX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SNX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X+,R31
	ST   X+,R22
	ST   X,R23
	.ENDM

	.MACRO __MULBRR
	MULS R@0,R@1
	MOVW R30,R0
	.ENDM

	.MACRO __MULBRRU
	MUL  R@0,R@1
	MOVW R30,R0
	.ENDM

	.MACRO __MULBRR0
	MULS R@0,R@1
	.ENDM

	.MACRO __MULBRRU0
	MUL  R@0,R@1
	.ENDM

	.MACRO __MULBNWRU
	LDI  R26,@2
	MUL  R26,R@0
	MOVW R30,R0
	MUL  R26,R@1
	ADD  R31,R0
	.ENDM

;NAME DEFINITIONS FOR GLOBAL VARIABLES ALLOCATED TO REGISTERS
	.DEF _rx_wr_index0=R3
	.DEF _rx_rd_index0=R2
	.DEF _rx_counter0=R5
	.DEF _tx_wr_index0=R4
	.DEF _tx_rd_index0=R7
	.DEF _tx_counter0=R6
	.DEF _caracterUrmator=R9

;GPIOR0-GPIOR2 INITIALIZATION VALUES
	.EQU __GPIOR0_INIT=0x00
	.EQU __GPIOR1_INIT=0x00
	.EQU __GPIOR2_INIT=0x00

	.CSEG
	.ORG 0x00

;START OF CODE MARKER
__START_OF_CODE:

;INTERRUPT VECTORS
	JMP  __RESET
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  _usart0_rx_isr
	JMP  0x00
	JMP  _usart0_tx_isr
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00

_tbl10_G100:
	.DB  0x10,0x27,0xE8,0x3,0x64,0x0,0xA,0x0
	.DB  0x1,0x0
_tbl16_G100:
	.DB  0x0,0x10,0x0,0x1,0x10,0x0,0x1,0x0

;GLOBAL REGISTER VARIABLES INITIALIZATION
__REG_VARS:
	.DB  0x58

_0x40003:
	.DB  0x2E,0x2E,0x2E,0x2E,0x2E,0x2E,0x2E,0x2E
	.DB  0x2E
_0x40004:
	.DB  0x9
_0x40005:
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x18,0x3C,0x3C,0x18,0x18,0x0,0x18,0x0
	.DB  0x36,0x36,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x36,0x36,0x7F,0x36,0x7F,0x36,0x36,0x0
	.DB  0xC,0x3E,0x3,0x1E,0x30,0x1F,0xC,0x0
	.DB  0x0,0x63,0x33,0x18,0xC,0x66,0x63,0x0
	.DB  0x1C,0x36,0x1C,0x6E,0x3B,0x33,0x6E,0x0
	.DB  0x6,0x6,0x3,0x0,0x0,0x0,0x0,0x0
	.DB  0x18,0xC,0x6,0x6,0x6,0xC,0x18,0x0
	.DB  0x6,0xC,0x18,0x18,0x18,0xC,0x6,0x0
	.DB  0x0,0x66,0x3C,0xFF,0x3C,0x66,0x0,0x0
	.DB  0x0,0xC,0xC,0x3F,0xC,0xC,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0xC,0xC,0x6
	.DB  0x0,0x0,0x0,0x3F,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0xC,0xC,0x0
	.DB  0x60,0x30,0x18,0xC,0x6,0x3,0x1,0x0
	.DB  0x3E,0x63,0x73,0x7B,0x6F,0x67,0x3E,0x0
	.DB  0xC,0xE,0xC,0xC,0xC,0xC,0x3F,0x0
	.DB  0x1E,0x33,0x30,0x1C,0x6,0x33,0x3F,0x0
	.DB  0x1E,0x33,0x30,0x1C,0x30,0x33,0x1E,0x0
	.DB  0x38,0x3C,0x36,0x33,0x7F,0x30,0x78,0x0
	.DB  0x3F,0x3,0x1F,0x30,0x30,0x33,0x1E,0x0
	.DB  0x1C,0x6,0x3,0x1F,0x33,0x33,0x1E,0x0
	.DB  0x3F,0x33,0x30,0x18,0xC,0xC,0xC,0x0
	.DB  0x1E,0x33,0x33,0x1E,0x33,0x33,0x1E,0x0
	.DB  0x1E,0x33,0x33,0x3E,0x30,0x18,0xE,0x0
	.DB  0x0,0xC,0xC,0x0,0x0,0xC,0xC,0x0
	.DB  0x0,0xC,0xC,0x0,0x0,0xC,0xC,0x6
	.DB  0x18,0xC,0x6,0x3,0x6,0xC,0x18,0x0
	.DB  0x0,0x0,0x3F,0x0,0x0,0x3F,0x0,0x0
	.DB  0x6,0xC,0x18,0x30,0x18,0xC,0x6,0x0
	.DB  0x1E,0x33,0x30,0x18,0xC,0x0,0xC,0x0
	.DB  0x3E,0x63,0x7B,0x7B,0x7B,0x3,0x1E,0x0
	.DB  0xC,0x1E,0x33,0x33,0x3F,0x33,0x33,0x0
	.DB  0x3F,0x66,0x66,0x3E,0x66,0x66,0x3F,0x0
	.DB  0x3C,0x66,0x3,0x3,0x3,0x66,0x3C,0x0
	.DB  0x1F,0x36,0x66,0x66,0x66,0x36,0x1F,0x0
	.DB  0x7F,0x46,0x16,0x1E,0x16,0x46,0x7F,0x0
	.DB  0x7F,0x46,0x16,0x1E,0x16,0x6,0xF,0x0
	.DB  0x3C,0x66,0x3,0x3,0x73,0x66,0x7C,0x0
	.DB  0x33,0x33,0x33,0x3F,0x33,0x33,0x33,0x0
	.DB  0x1E,0xC,0xC,0xC,0xC,0xC,0x1E,0x0
	.DB  0x78,0x30,0x30,0x30,0x33,0x33,0x1E,0x0
	.DB  0x67,0x66,0x36,0x1E,0x36,0x66,0x67,0x0
	.DB  0xF,0x6,0x6,0x6,0x46,0x66,0x7F,0x0
	.DB  0x63,0x77,0x7F,0x7F,0x6B,0x63,0x63,0x0
	.DB  0x63,0x67,0x6F,0x7B,0x73,0x63,0x63,0x0
	.DB  0x1C,0x36,0x63,0x63,0x63,0x36,0x1C,0x0
	.DB  0x3F,0x66,0x66,0x3E,0x6,0x6,0xF,0x0
	.DB  0x1E,0x33,0x33,0x33,0x3B,0x1E,0x38,0x0
	.DB  0x3F,0x66,0x66,0x3E,0x36,0x66,0x67,0x0
	.DB  0x1E,0x33,0x7,0xE,0x38,0x33,0x1E,0x0
	.DB  0x3F,0x2D,0xC,0xC,0xC,0xC,0x1E,0x0
	.DB  0x33,0x33,0x33,0x33,0x33,0x33,0x3F,0x0
	.DB  0x33,0x33,0x33,0x33,0x33,0x1E,0xC,0x0
	.DB  0x63,0x63,0x63,0x6B,0x7F,0x77,0x63,0x0
	.DB  0x63,0x63,0x36,0x1C,0x1C,0x36,0x63,0x0
	.DB  0x33,0x33,0x33,0x1E,0xC,0xC,0x1E,0x0
	.DB  0x7F,0x63,0x31,0x18,0x4C,0x66,0x7F,0x0
	.DB  0x1E,0x6,0x6,0x6,0x6,0x6,0x1E,0x0
	.DB  0x3,0x6,0xC,0x18,0x30,0x60,0x40,0x0
	.DB  0x1E,0x18,0x18,0x18,0x18,0x18,0x1E,0x0
	.DB  0x8,0x1C,0x36,0x63,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0xFF
	.DB  0xC,0xC,0x18
_0x2040060:
	.DB  0x1
_0x2040000:
	.DB  0x2D,0x4E,0x41,0x4E,0x0,0x49,0x4E,0x46
	.DB  0x0

__GLOBAL_INI_TBL:
	.DW  0x01
	.DW  0x09
	.DW  __REG_VARS*2

	.DW  0x09
	.DW  _displayJoc
	.DW  _0x40003*2

	.DW  0x01
	.DW  _remiza
	.DW  _0x40004*2

	.DW  0x203
	.DW  _font8x8_basic
	.DW  _0x40005*2

	.DW  0x01
	.DW  __seed_G102
	.DW  _0x2040060*2

_0xFFFFFFFF:
	.DW  0

#define __GLOBAL_INI_TBL_PRESENT 1

__RESET:
	CLI
	CLR  R30
	OUT  EECR,R30

;INTERRUPT VECTORS ARE PLACED
;AT THE START OF FLASH
	LDI  R31,1
	OUT  MCUCR,R31
	OUT  MCUCR,R30

;DISABLE WATCHDOG
	LDI  R31,0x18
	WDR
	IN   R26,MCUSR
	CBR  R26,8
	OUT  MCUSR,R26
	STS  WDTCSR,R31
	STS  WDTCSR,R30

;CLEAR R2-R14
	LDI  R24,(14-2)+1
	LDI  R26,2
	CLR  R27
__CLEAR_REG:
	ST   X+,R30
	DEC  R24
	BRNE __CLEAR_REG

;CLEAR SRAM
	LDI  R24,LOW(__CLEAR_SRAM_SIZE)
	LDI  R25,HIGH(__CLEAR_SRAM_SIZE)
	LDI  R26,LOW(__SRAM_START)
	LDI  R27,HIGH(__SRAM_START)
__CLEAR_SRAM:
	ST   X+,R30
	SBIW R24,1
	BRNE __CLEAR_SRAM

;GLOBAL VARIABLES INITIALIZATION
	LDI  R30,LOW(__GLOBAL_INI_TBL*2)
	LDI  R31,HIGH(__GLOBAL_INI_TBL*2)
__GLOBAL_INI_NEXT:
	LPM  R24,Z+
	LPM  R25,Z+
	SBIW R24,0
	BREQ __GLOBAL_INI_END
	LPM  R26,Z+
	LPM  R27,Z+
	LPM  R0,Z+
	LPM  R1,Z+
	MOVW R22,R30
	MOVW R30,R0
__GLOBAL_INI_LOOP:
	LPM  R0,Z+
	ST   X+,R0
	SBIW R24,1
	BRNE __GLOBAL_INI_LOOP
	MOVW R30,R22
	RJMP __GLOBAL_INI_NEXT
__GLOBAL_INI_END:

;GPIOR0-GPIOR2 INITIALIZATION
	LDI  R30,__GPIOR0_INIT
	OUT  GPIOR0,R30
	;__GPIOR1_INIT = __GPIOR0_INIT
	OUT  GPIOR1,R30
	;__GPIOR2_INIT = __GPIOR0_INIT
	OUT  GPIOR2,R30

;HARDWARE STACK POINTER INITIALIZATION
	LDI  R30,LOW(__SRAM_END-__HEAP_SIZE)
	OUT  SPL,R30
	LDI  R30,HIGH(__SRAM_END-__HEAP_SIZE)
	OUT  SPH,R30

;DATA STACK POINTER INITIALIZATION
	LDI  R28,LOW(__SRAM_START+__DSTACK_SIZE)
	LDI  R29,HIGH(__SRAM_START+__DSTACK_SIZE)

	JMP  _main

	.ESEG
	.ORG 1

	.DSEG
	.ORG 0x200

	.CSEG
;/*********************************************
;Project : Test software
;**********************************************
;Chip type: ATmega164A
;Clock frequency: 20 MHz
;Compilers:  CVAVR 2.x
;*********************************************/
;
;#include <mega164a.h>
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x01
	.EQU __sm_mask=0x0E
	.EQU __sm_powerdown=0x04
	.EQU __sm_powersave=0x06
	.EQU __sm_standby=0x0C
	.EQU __sm_ext_standby=0x0E
	.EQU __sm_adc_noise_red=0x02
	.SET power_ctrl_reg=smcr
	#endif
;
;#include <stdio.h>
;#include <delay.h>
;#include <string.h>
;#include <stdlib.h>
;#include <stdint.h>
;#include <i2c.h>
;#include "defs.h"
;#include "functii.h"
;//#include "ecran.h"
;//*************************************************************************************************
;//*********** BEGIN SERIAL STUFF (interrupt-driven, generated by Code Wizard) *********************
;//*************************************************************************************************
;
;#ifndef RXB8
;#define RXB8 1
;#endif
;
;#ifndef TXB8
;#define TXB8 0
;#endif
;
;#ifndef UPE
;#define UPE 2
;#endif
;
;#ifndef DOR
;#define DOR 3
;#endif
;
;#ifndef FE
;#define FE 4
;#endif
;
;#ifndef UDRE
;#define UDRE 5
;#endif
;
;#ifndef RXC
;#define RXC 7
;#endif
;
;#define FRAMING_ERROR (1<<FE)
;#define PARITY_ERROR (1<<UPE)
;#define DATA_OVERRUN (1<<DOR)
;#define DATA_REGISTER_EMPTY (1<<UDRE)
;#define RX_COMPLETE (1<<RXC)
;
;// USART0 Receiver buffer
;#define RX_BUFFER_SIZE0 8
;char rx_buffer0[RX_BUFFER_SIZE0];
;
;#if RX_BUFFER_SIZE0 <= 256
;unsigned char rx_wr_index0,rx_rd_index0,rx_counter0;
;#else
;unsigned int rx_wr_index0,rx_rd_index0,rx_counter0;
;#endif
;
;// This flag is set on USART0 Receiver buffer overflow
;bit rx_buffer_overflow0;
;
;// USART0 Receiver interrupt service routine
;interrupt [USART0_RXC] void usart0_rx_isr(void)
; 0000 0049 {

	.CSEG
_usart0_rx_isr:
; .FSTART _usart0_rx_isr
	ST   -Y,R30
	ST   -Y,R31
	IN   R30,SREG
	ST   -Y,R30
; 0000 004A char status,data;
; 0000 004B status=UCSR0A;
	ST   -Y,R17
	ST   -Y,R16
;	status -> R17
;	data -> R16
	LDS  R17,192
; 0000 004C data=UDR0;
	LDS  R16,198
; 0000 004D if ((status & (FRAMING_ERROR | PARITY_ERROR | DATA_OVERRUN))==0)
	MOV  R30,R17
	ANDI R30,LOW(0x1C)
	BRNE _0x3
; 0000 004E    {
; 0000 004F    rx_buffer0[rx_wr_index0++]=data;
	MOV  R30,R3
	INC  R3
	LDI  R31,0
	SUBI R30,LOW(-_rx_buffer0)
	SBCI R31,HIGH(-_rx_buffer0)
	ST   Z,R16
; 0000 0050 #if RX_BUFFER_SIZE0 == 256
; 0000 0051    // special case for receiver buffer size=256
; 0000 0052    if (++rx_counter0 == 0) rx_buffer_overflow0=1;
; 0000 0053 #else
; 0000 0054    if (rx_wr_index0 == RX_BUFFER_SIZE0) rx_wr_index0=0;
	LDI  R30,LOW(8)
	CP   R30,R3
	BRNE _0x4
	CLR  R3
; 0000 0055    if (++rx_counter0 == RX_BUFFER_SIZE0)
_0x4:
	INC  R5
	LDI  R30,LOW(8)
	CP   R30,R5
	BRNE _0x5
; 0000 0056       {
; 0000 0057       rx_counter0=0;
	CLR  R5
; 0000 0058       rx_buffer_overflow0=1;
	SBI  0x1E,0
; 0000 0059       }
; 0000 005A #endif
; 0000 005B    }
_0x5:
; 0000 005C }
_0x3:
	LD   R16,Y+
	LD   R17,Y+
	RJMP _0x2B
; .FEND
;
;#ifndef _DEBUG_TERMINAL_IO_
;// Get a character from the USART0 Receiver buffer
;#define _ALTERNATE_GETCHAR_
;#pragma used+
;char getchar(void)
; 0000 0063 {
; 0000 0064 char data;
; 0000 0065 while (rx_counter0==0);
;	data -> R17
; 0000 0066 data=rx_buffer0[rx_rd_index0++];
; 0000 0067 #if RX_BUFFER_SIZE0 != 256
; 0000 0068 if (rx_rd_index0 == RX_BUFFER_SIZE0) rx_rd_index0=0;
; 0000 0069 #endif
; 0000 006A #asm("cli")
; 0000 006B --rx_counter0;
; 0000 006C #asm("sei")
; 0000 006D return data;
; 0000 006E }
;#pragma used-
;#endif
;
;// USART0 Transmitter buffer
;#define TX_BUFFER_SIZE0 8
;char tx_buffer0[TX_BUFFER_SIZE0];
;
;#if TX_BUFFER_SIZE0 <= 256
;unsigned char tx_wr_index0,tx_rd_index0,tx_counter0;
;#else
;unsigned int tx_wr_index0,tx_rd_index0,tx_counter0;
;#endif
;
;// USART0 Transmitter interrupt service routine
;interrupt [USART0_TXC] void usart0_tx_isr(void)
; 0000 007E {
_usart0_tx_isr:
; .FSTART _usart0_tx_isr
	ST   -Y,R30
	ST   -Y,R31
	IN   R30,SREG
	ST   -Y,R30
; 0000 007F if (tx_counter0)
	TST  R6
	BREQ _0xC
; 0000 0080    {
; 0000 0081    --tx_counter0;
	DEC  R6
; 0000 0082    UDR0=tx_buffer0[tx_rd_index0++];
	MOV  R30,R7
	INC  R7
	LDI  R31,0
	SUBI R30,LOW(-_tx_buffer0)
	SBCI R31,HIGH(-_tx_buffer0)
	LD   R30,Z
	STS  198,R30
; 0000 0083 #if TX_BUFFER_SIZE0 != 256
; 0000 0084    if (tx_rd_index0 == TX_BUFFER_SIZE0) tx_rd_index0=0;
	LDI  R30,LOW(8)
	CP   R30,R7
	BRNE _0xD
	CLR  R7
; 0000 0085 #endif
; 0000 0086    }
_0xD:
; 0000 0087 }
_0xC:
_0x2B:
	LD   R30,Y+
	OUT  SREG,R30
	LD   R31,Y+
	LD   R30,Y+
	RETI
; .FEND
;
;#ifndef _DEBUG_TERMINAL_IO_
;// Write a character to the USART0 Transmitter buffer
;#define _ALTERNATE_PUTCHAR_
;#pragma used+
;void putchar(char c)
; 0000 008E {
; 0000 008F while (tx_counter0 == TX_BUFFER_SIZE0);
;	c -> Y+0
; 0000 0090 #asm("cli")
; 0000 0091 if (tx_counter0 || ((UCSR0A & DATA_REGISTER_EMPTY)==0))
; 0000 0092    {
; 0000 0093    tx_buffer0[tx_wr_index0++]=c;
; 0000 0094 #if TX_BUFFER_SIZE0 != 256
; 0000 0095    if (tx_wr_index0 == TX_BUFFER_SIZE0) tx_wr_index0=0;
; 0000 0096 #endif
; 0000 0097    ++tx_counter0;
; 0000 0098    }
; 0000 0099 else
; 0000 009A    UDR0=c;
; 0000 009B #asm("sei")
; 0000 009C }
;#pragma used-
;#endif
;//*************************************************************************************************
;//********************END SERIAL STUFF (USART0)  **************************************************
;//*************************************************************************************************
;//*******   if you need USART1, enable it in Code Wizard and copy coresponding code here  *********
;//*************************************************************************************************
;/*
; * main function of program
; */
;extern unsigned char castigat, remiza;
;
;void main (void)
; 0000 00AA {
_main:
; .FSTART _main
; 0000 00AB unsigned short butoane;
; 0000 00AC unsigned char temp;
; 0000 00AD 	Init_initController();  // this must be the first "init" action/call!
;	butoane -> R16,R17
;	temp -> R19
	RCALL _Init_initController
; 0000 00AE 	#asm("sei")             // enable interrupts
	sei
; 0000 00AF     i2c_init();
	CALL _i2c_init
; 0000 00B0     InitDisplay();
	CALL _InitDisplay
; 0000 00B1     RotescLiterele();
	CALL _RotescLiterele
; 0000 00B2     DisplayClear();
	CALL _DisplayClear
; 0000 00B3     PrinteazaJocDisplay();
	CALL _PrinteazaJocDisplay
; 0000 00B4 	while(TRUE)
_0x16:
; 0000 00B5 	{
; 0000 00B6        /* if(rx_counter0)     // if a character is available on serial port USART0
; 0000 00B7 		{
; 0000 00B8 			temp = getchar();
; 0000 00B9             PrintCaracterDisplay(temp);
; 0000 00BA 		}*/
; 0000 00BB         butoane = ButoaneUpdate();
	CALL _ButoaneUpdate
	MOVW R16,R30
; 0000 00BC         if(butoane && !castigat){
	MOV  R0,R16
	OR   R0,R17
	BREQ _0x1A
	LDS  R30,_castigat
	CPI  R30,0
	BREQ _0x1B
_0x1A:
	RJMP _0x19
_0x1B:
; 0000 00BD             //TrimiteButoane(butoane);
; 0000 00BE             UpdateJoc(butoane);
	MOVW R26,R16
	CALL _UpdateJoc
; 0000 00BF             PrinteazaJocDisplay();
	CALL _PrinteazaJocDisplay
; 0000 00C0             VerificaInvingatorul();
	CALL _VerificaInvingatorul
; 0000 00C1         }
; 0000 00C2         else if(castigat){
	RJMP _0x1C
_0x19:
	LDS  R30,_castigat
	CPI  R30,0
	BREQ _0x1D
; 0000 00C3             LED1 = 1;
	SBI  0xB,6
; 0000 00C4             PrintCaracterDisplay('W');
	LDI  R26,LOW(87)
	CALL _PrintCaracterDisplay
; 0000 00C5             PrintCaracterDisplay('I');
	LDI  R26,LOW(73)
	CALL _PrintCaracterDisplay
; 0000 00C6             PrintCaracterDisplay('N');
	LDI  R26,LOW(78)
	CALL _PrintCaracterDisplay
; 0000 00C7             PrintCaracterDisplay(' ');
	LDI  R26,LOW(32)
	CALL _PrintCaracterDisplay
; 0000 00C8             PrintCaracterDisplay(castigat);
	LDS  R26,_castigat
	CALL _PrintCaracterDisplay
; 0000 00C9             while(1);
_0x20:
	RJMP _0x20
; 0000 00CA         }
; 0000 00CB         else if (remiza == 0){
_0x1D:
	LDS  R30,_remiza
	CPI  R30,0
	BRNE _0x24
; 0000 00CC             LED1 = 1;
	SBI  0xB,6
; 0000 00CD             PrintCaracterDisplay('D');
	LDI  R26,LOW(68)
	CALL _PrintCaracterDisplay
; 0000 00CE             PrintCaracterDisplay('R');
	LDI  R26,LOW(82)
	CALL _PrintCaracterDisplay
; 0000 00CF             PrintCaracterDisplay('A');
	LDI  R26,LOW(65)
	CALL _PrintCaracterDisplay
; 0000 00D0             PrintCaracterDisplay('W');
	LDI  R26,LOW(87)
	CALL _PrintCaracterDisplay
; 0000 00D1             while(1);
_0x27:
	RJMP _0x27
; 0000 00D2         }
; 0000 00D3     }
_0x24:
_0x1C:
	RJMP _0x16
; 0000 00D4 }// end main loop
_0x2A:
	RJMP _0x2A
; .FEND
;
;
;/* initialization file */
;
;#include <mega164a.h>
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x01
	.EQU __sm_mask=0x0E
	.EQU __sm_powerdown=0x04
	.EQU __sm_powersave=0x06
	.EQU __sm_standby=0x0C
	.EQU __sm_ext_standby=0x0E
	.EQU __sm_adc_noise_red=0x02
	.SET power_ctrl_reg=smcr
	#endif
;#include "defs.h"
;
;
;/*
; * most intialization values are generated using Code Wizard and depend on clock value
; */
;void Init_initController(void)
; 0001 000B {

	.CSEG
_Init_initController:
; .FSTART _Init_initController
; 0001 000C // Crystal Oscillator division factor: 1
; 0001 000D #pragma optsize-
; 0001 000E CLKPR=0x80;
	LDI  R30,LOW(128)
	STS  97,R30
; 0001 000F CLKPR=0x00;
	LDI  R30,LOW(0)
	STS  97,R30
; 0001 0010 #ifdef _OPTIMIZE_SIZE_
; 0001 0011 #pragma optsize+
; 0001 0012 #endif
; 0001 0013 
; 0001 0014 // Input/Output Ports initialization
; 0001 0015 // Port A initialization
; 0001 0016 // Func7=In Func6=In Func5=In Func4=In Func3=In Func2=In Func1=In Func0=In
; 0001 0017 // State7=T State6=T State5=T State4=T State3=T State2=T State1=T State0=T
; 0001 0018 PORTA=0x00;
	OUT  0x2,R30
; 0001 0019 DDRA=0x00;
	OUT  0x1,R30
; 0001 001A 
; 0001 001B // Port B initialization
; 0001 001C PORTB=0x00;
	OUT  0x5,R30
; 0001 001D DDRB=0x00;
	OUT  0x4,R30
; 0001 001E 
; 0001 001F // Port C initialization
; 0001 0020 PORTC=0x00;
	OUT  0x8,R30
; 0001 0021 DDRC=0x00;
	OUT  0x7,R30
; 0001 0022 
; 0001 0023 // Port D initialization
; 0001 0024 PORTD=0b00100000; // D.5 needs pull-up resistor
	LDI  R30,LOW(32)
	OUT  0xB,R30
; 0001 0025 DDRD= 0b01010000; // D.6 is LED, D.4 is test output
	LDI  R30,LOW(80)
	OUT  0xA,R30
; 0001 0026 
; 0001 0027 // Timer/Counter 0 initialization
; 0001 0028 // Clock source: System Clock
; 0001 0029 // Clock value: Timer 0 Stopped
; 0001 002A // Mode: Normal top=FFh
; 0001 002B // OC0 output: Disconnected
; 0001 002C TCCR0A=0x00;
	LDI  R30,LOW(0)
	OUT  0x24,R30
; 0001 002D TCCR0B=0x00;
	OUT  0x25,R30
; 0001 002E TCNT0=0x00;
	OUT  0x26,R30
; 0001 002F OCR0A=0x00;
	OUT  0x27,R30
; 0001 0030 OCR0B=0x00;
	OUT  0x28,R30
; 0001 0031 
; 0001 0032 // Timer/Counter 1 initialization
; 0001 0033 // Clock source: System Clock
; 0001 0034 // Clock value: 19.531 kHz = CLOCK/256
; 0001 0035 // Mode: CTC top=OCR1A
; 0001 0036 // OC1A output: Discon.
; 0001 0037 // OC1B output: Discon.
; 0001 0038 // Noise Canceler: Off
; 0001 0039 // Input Capture on Falling Edge
; 0001 003A // Timer 1 Overflow Interrupt: Off
; 0001 003B // Input Capture Interrupt: Off
; 0001 003C // Compare A Match Interrupt: On
; 0001 003D // Compare B Match Interrupt: Off
; 0001 003E 
; 0001 003F TCCR1A=0x00;
	STS  128,R30
; 0001 0040 TCCR1B=0x0D;
	LDI  R30,LOW(13)
	STS  129,R30
; 0001 0041 TCNT1H=0x00;
	LDI  R30,LOW(0)
	STS  133,R30
; 0001 0042 TCNT1L=0x00;
	STS  132,R30
; 0001 0043 ICR1H=0x00;
	STS  135,R30
; 0001 0044 ICR1L=0x00;
	STS  134,R30
; 0001 0045 
; 0001 0046 // 1 sec = 19531 counts = 4C41H counts, from 0 to 4C40
; 0001 0047 // 4C40H = 4CH (MSB) and 40H (LSB)
; 0001 0048 OCR1AH=0x4C;
	LDI  R30,LOW(76)
	STS  137,R30
; 0001 0049 OCR1AL=0x40;
	LDI  R30,LOW(64)
	STS  136,R30
; 0001 004A 
; 0001 004B OCR1BH=0x00;
	LDI  R30,LOW(0)
	STS  139,R30
; 0001 004C OCR1BL=0x00;
	STS  138,R30
; 0001 004D 
; 0001 004E // Timer/Counter 2 initialization
; 0001 004F // Clock source: System Clock
; 0001 0050 // Clock value: Timer2 Stopped
; 0001 0051 // Mode: Normal top=0xFF
; 0001 0052 // OC2A output: Disconnected
; 0001 0053 // OC2B output: Disconnected
; 0001 0054 ASSR=0x00;
	STS  182,R30
; 0001 0055 TCCR2A=0x00;
	STS  176,R30
; 0001 0056 TCCR2B=0x00;
	STS  177,R30
; 0001 0057 TCNT2=0x00;
	STS  178,R30
; 0001 0058 OCR2A=0x00;
	STS  179,R30
; 0001 0059 OCR2B=0x00;
	STS  180,R30
; 0001 005A 
; 0001 005B // External Interrupt(s) initialization
; 0001 005C // INT0: Off
; 0001 005D // INT1: Off
; 0001 005E // INT2: Off
; 0001 005F // Interrupt on any change on pins PCINT0-7: Off
; 0001 0060 // Interrupt on any change on pins PCINT8-15: Off
; 0001 0061 // Interrupt on any change on pins PCINT16-23: Off
; 0001 0062 // Interrupt on any change on pins PCINT24-31: Off
; 0001 0063 EICRA=0x00;
	STS  105,R30
; 0001 0064 EIMSK=0x00;
	OUT  0x1D,R30
; 0001 0065 PCICR=0x00;
	STS  104,R30
; 0001 0066 
; 0001 0067 // Timer/Counter 0,1,2 Interrupt(s) initialization
; 0001 0068 TIMSK0=0x00;
	STS  110,R30
; 0001 0069 TIMSK1=0x00;
	STS  111,R30
; 0001 006A TIMSK2=0x00;
	STS  112,R30
; 0001 006B 
; 0001 006C // USART0 initialization
; 0001 006D // Communication Parameters: 8 Data, 1 Stop, No Parity
; 0001 006E // USART0 Receiver: On
; 0001 006F // USART0 Transmitter: On
; 0001 0070 // USART0 Mode: Asynchronous
; 0001 0071 // USART0 Baud rate: 9600
; 0001 0072 UCSR0A=0x00;
	STS  192,R30
; 0001 0073 UCSR0B=0xD8;
	LDI  R30,LOW(216)
	STS  193,R30
; 0001 0074 UCSR0C=0x06;
	LDI  R30,LOW(6)
	STS  194,R30
; 0001 0075 UBRR0H=0x00;
	LDI  R30,LOW(0)
	STS  197,R30
; 0001 0076 UBRR0L=0x81;
	LDI  R30,LOW(129)
	STS  196,R30
; 0001 0077 
; 0001 0078 // USART1 initialization
; 0001 0079 // USART1 disabled
; 0001 007A UCSR1B=0x00;
	LDI  R30,LOW(0)
	STS  201,R30
; 0001 007B 
; 0001 007C 
; 0001 007D // Analog Comparator initialization
; 0001 007E // Analog Comparator: Off
; 0001 007F // Analog Comparator Input Capture by Timer/Counter 1: Off
; 0001 0080 ACSR=0x80;
	LDI  R30,LOW(128)
	OUT  0x30,R30
; 0001 0081 ADCSRB=0x00;
	LDI  R30,LOW(0)
	STS  123,R30
; 0001 0082 DIDR1=0x00;
	STS  127,R30
; 0001 0083 
; 0001 0084 // Watchdog Timer initialization
; 0001 0085 // Watchdog Timer Prescaler: OSC/2048
; 0001 0086 #pragma optsize-
; 0001 0087 #asm("wdr")
	wdr
; 0001 0088 // Write 2 consecutive values to enable watchdog
; 0001 0089 // this is NOT a mistake !
; 0001 008A WDTCSR=0x10;
	LDI  R30,LOW(16)
	STS  96,R30
; 0001 008B WDTCSR=0x00;
	LDI  R30,LOW(0)
	STS  96,R30
; 0001 008C #ifdef _OPTIMIZE_SIZE_
; 0001 008D #pragma optsize+
; 0001 008E #endif
; 0001 008F 
; 0001 0090 }
	RET
; .FEND
;
;
;
;#include "functii.h"
;#include <mega164a.h>
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x01
	.EQU __sm_mask=0x0E
	.EQU __sm_powerdown=0x04
	.EQU __sm_powersave=0x06
	.EQU __sm_standby=0x0C
	.EQU __sm_ext_standby=0x0E
	.EQU __sm_adc_noise_red=0x02
	.SET power_ctrl_reg=smcr
	#endif
;#include <delay.h>
;#include <stdio.h>
;#include <i2c.h>
;unsigned char displayJoc[9] = {'.', '.', '.','.', '.', '.','.', '.', '.'};

	.DSEG
;unsigned char caracterUrmator = 'X', remiza = 9, castigat = 0;
;#define AdresaDisplayMic 0x3C
;
;unsigned char font8x8_basic[65][8] = {
;    { 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00},   // U+0020 (space)
;    { 0x18, 0x3C, 0x3C, 0x18, 0x18, 0x00, 0x18, 0x00},   // U+0021 (!)
;    { 0x36, 0x36, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00},   // U+0022 (")
;    { 0x36, 0x36, 0x7F, 0x36, 0x7F, 0x36, 0x36, 0x00},   // U+0023 (#)
;    { 0x0C, 0x3E, 0x03, 0x1E, 0x30, 0x1F, 0x0C, 0x00},   // U+0024 ($)
;    { 0x00, 0x63, 0x33, 0x18, 0x0C, 0x66, 0x63, 0x00},   // U+0025 (%)
;    { 0x1C, 0x36, 0x1C, 0x6E, 0x3B, 0x33, 0x6E, 0x00},   // U+0026 (&)
;    { 0x06, 0x06, 0x03, 0x00, 0x00, 0x00, 0x00, 0x00},   // U+0027 (')
;    { 0x18, 0x0C, 0x06, 0x06, 0x06, 0x0C, 0x18, 0x00},   // U+0028 (()
;    { 0x06, 0x0C, 0x18, 0x18, 0x18, 0x0C, 0x06, 0x00},   // U+0029 ())
;    { 0x00, 0x66, 0x3C, 0xFF, 0x3C, 0x66, 0x00, 0x00},   // U+002A (*)
;    { 0x00, 0x0C, 0x0C, 0x3F, 0x0C, 0x0C, 0x00, 0x00},   // U+002B (+)
;    { 0x00, 0x00, 0x00, 0x00, 0x00, 0x0C, 0x0C, 0x06},   // U+002C (,)
;    { 0x00, 0x00, 0x00, 0x3F, 0x00, 0x00, 0x00, 0x00},   // U+002D (-)
;    { 0x00, 0x00, 0x00, 0x00, 0x00, 0x0C, 0x0C, 0x00},   // U+002E (.)
;    { 0x60, 0x30, 0x18, 0x0C, 0x06, 0x03, 0x01, 0x00},   // U+002F (/)
;    { 0x3E, 0x63, 0x73, 0x7B, 0x6F, 0x67, 0x3E, 0x00},   // U+0030 (0)
;    { 0x0C, 0x0E, 0x0C, 0x0C, 0x0C, 0x0C, 0x3F, 0x00},   // U+0031 (1)
;    { 0x1E, 0x33, 0x30, 0x1C, 0x06, 0x33, 0x3F, 0x00},   // U+0032 (2)
;    { 0x1E, 0x33, 0x30, 0x1C, 0x30, 0x33, 0x1E, 0x00},   // U+0033 (3)
;    { 0x38, 0x3C, 0x36, 0x33, 0x7F, 0x30, 0x78, 0x00},   // U+0034 (4)
;    { 0x3F, 0x03, 0x1F, 0x30, 0x30, 0x33, 0x1E, 0x00},   // U+0035 (5)
;    { 0x1C, 0x06, 0x03, 0x1F, 0x33, 0x33, 0x1E, 0x00},   // U+0036 (6)
;    { 0x3F, 0x33, 0x30, 0x18, 0x0C, 0x0C, 0x0C, 0x00},   // U+0037 (7)
;    { 0x1E, 0x33, 0x33, 0x1E, 0x33, 0x33, 0x1E, 0x00},   // U+0038 (8)
;    { 0x1E, 0x33, 0x33, 0x3E, 0x30, 0x18, 0x0E, 0x00},   // U+0039 (9)
;    { 0x00, 0x0C, 0x0C, 0x00, 0x00, 0x0C, 0x0C, 0x00},   // U+003A (:)
;    { 0x00, 0x0C, 0x0C, 0x00, 0x00, 0x0C, 0x0C, 0x06},   // U+003B (;)
;    { 0x18, 0x0C, 0x06, 0x03, 0x06, 0x0C, 0x18, 0x00},   // U+003C (<)
;    { 0x00, 0x00, 0x3F, 0x00, 0x00, 0x3F, 0x00, 0x00},   // U+003D (=)
;    { 0x06, 0x0C, 0x18, 0x30, 0x18, 0x0C, 0x06, 0x00},   // U+003E (>)
;    { 0x1E, 0x33, 0x30, 0x18, 0x0C, 0x00, 0x0C, 0x00},   // U+003F (?)
;    { 0x3E, 0x63, 0x7B, 0x7B, 0x7B, 0x03, 0x1E, 0x00},   // U+0040 (@)
;    { 0x0C, 0x1E, 0x33, 0x33, 0x3F, 0x33, 0x33, 0x00},   // U+0041 (A)
;    { 0x3F, 0x66, 0x66, 0x3E, 0x66, 0x66, 0x3F, 0x00},   // U+0042 (B)
;    { 0x3C, 0x66, 0x03, 0x03, 0x03, 0x66, 0x3C, 0x00},   // U+0043 (C)
;    { 0x1F, 0x36, 0x66, 0x66, 0x66, 0x36, 0x1F, 0x00},   // U+0044 (D)
;    { 0x7F, 0x46, 0x16, 0x1E, 0x16, 0x46, 0x7F, 0x00},   // U+0045 (E)
;    { 0x7F, 0x46, 0x16, 0x1E, 0x16, 0x06, 0x0F, 0x00},   // U+0046 (F)
;    { 0x3C, 0x66, 0x03, 0x03, 0x73, 0x66, 0x7C, 0x00},   // U+0047 (G)
;    { 0x33, 0x33, 0x33, 0x3F, 0x33, 0x33, 0x33, 0x00},   // U+0048 (H)
;    { 0x1E, 0x0C, 0x0C, 0x0C, 0x0C, 0x0C, 0x1E, 0x00},   // U+0049 (I)
;    { 0x78, 0x30, 0x30, 0x30, 0x33, 0x33, 0x1E, 0x00},   // U+004A (J)
;    { 0x67, 0x66, 0x36, 0x1E, 0x36, 0x66, 0x67, 0x00},   // U+004B (K)
;    { 0x0F, 0x06, 0x06, 0x06, 0x46, 0x66, 0x7F, 0x00},   // U+004C (L)
;    { 0x63, 0x77, 0x7F, 0x7F, 0x6B, 0x63, 0x63, 0x00},   // U+004D (M)
;    { 0x63, 0x67, 0x6F, 0x7B, 0x73, 0x63, 0x63, 0x00},   // U+004E (N)
;    { 0x1C, 0x36, 0x63, 0x63, 0x63, 0x36, 0x1C, 0x00},   // U+004F (O)
;    { 0x3F, 0x66, 0x66, 0x3E, 0x06, 0x06, 0x0F, 0x00},   // U+0050 (P)
;    { 0x1E, 0x33, 0x33, 0x33, 0x3B, 0x1E, 0x38, 0x00},   // U+0051 (Q)
;    { 0x3F, 0x66, 0x66, 0x3E, 0x36, 0x66, 0x67, 0x00},   // U+0052 (R)
;    { 0x1E, 0x33, 0x07, 0x0E, 0x38, 0x33, 0x1E, 0x00},   // U+0053 (S)
;    { 0x3F, 0x2D, 0x0C, 0x0C, 0x0C, 0x0C, 0x1E, 0x00},   // U+0054 (T)
;    { 0x33, 0x33, 0x33, 0x33, 0x33, 0x33, 0x3F, 0x00},   // U+0055 (U)
;    { 0x33, 0x33, 0x33, 0x33, 0x33, 0x1E, 0x0C, 0x00},   // U+0056 (V)
;    { 0x63, 0x63, 0x63, 0x6B, 0x7F, 0x77, 0x63, 0x00},   // U+0057 (W)
;    { 0x63, 0x63, 0x36, 0x1C, 0x1C, 0x36, 0x63, 0x00},   // U+0058 (X)
;    { 0x33, 0x33, 0x33, 0x1E, 0x0C, 0x0C, 0x1E, 0x00},   // U+0059 (Y)
;    { 0x7F, 0x63, 0x31, 0x18, 0x4C, 0x66, 0x7F, 0x00},   // U+005A (Z)
;    { 0x1E, 0x06, 0x06, 0x06, 0x06, 0x06, 0x1E, 0x00},   // U+005B ([)
;    { 0x03, 0x06, 0x0C, 0x18, 0x30, 0x60, 0x40, 0x00},   // U+005C (\)
;    { 0x1E, 0x18, 0x18, 0x18, 0x18, 0x18, 0x1E, 0x00},   // U+005D (])
;    { 0x08, 0x1C, 0x36, 0x63, 0x00, 0x00, 0x00, 0x00},   // U+005E (^)
;    { 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0xFF},   // U+005F (_)
;    { 0x0C, 0x0C, 0x18, 0x00, 0x00, 0x00, 0x00, 0x00}   // U+0060 (`)
;};
;
;unsigned short ButoaneUpdate(){
; 0002 004E unsigned short ButoaneUpdate(){

	.CSEG
_ButoaneUpdate:
; .FSTART _ButoaneUpdate
; 0002 004F     static unsigned short StareButoaneInainte = 0x00;    //16 biti
; 0002 0050     volatile unsigned short StareButoane = 0x00, ButoaneApasate = 0x00, i; //16 biti
; 0002 0051     volatile unsigned char aux; //8 biti, folosesc 4
; 0002 0052 
; 0002 0053     PORTA = (1<<PINA4);// pornesc pullup pe pinul a4
	SBIW R28,7
	LDI  R30,LOW(0)
	STD  Y+3,R30
	STD  Y+4,R30
	STD  Y+5,R30
	STD  Y+6,R30
;	StareButoane -> Y+5
;	ButoaneApasate -> Y+3
;	i -> Y+1
;	aux -> Y+0
	LDI  R30,LOW(16)
	CALL SUBOPT_0x0
; 0002 0054     DDRA = 0xFF;   //fac tot portul a sa fie sink pentru a scoate pinii din high-impedance si a ii aduce intr-o stare de ...
; 0002 0055     delay_us(1);
; 0002 0056     DDRA = (1<<PINA4);  //fac pinul a4 de iesire pentru a alimenta butoanele
	LDI  R30,LOW(16)
	CALL SUBOPT_0x1
; 0002 0057     for(i=0; i<10;i++){
_0x40007:
	LDD  R26,Y+1
	LDD  R27,Y+1+1
	SBIW R26,10
	BRSH _0x40008
; 0002 0058         aux = PINA;      //citesc pinul de mai multe ori pentru a face debounce
	IN   R30,0x0
	ST   Y,R30
; 0002 0059     }
	CALL SUBOPT_0x2
	RJMP _0x40007
_0x40008:
; 0002 005A     StareButoane |= (unsigned short)(aux & ((1<<PINA0) | (1<<PINA1) | (1<< PINA2) | (1<<PINA3)));//citesc cei 4 pini de  ...
	LD   R30,Y
	ANDI R30,LOW(0xF)
	LDI  R31,0
	CALL SUBOPT_0x3
; 0002 005B 
; 0002 005C     PORTA = (1<<PINA5);// pornesc pullup pe pinul a5
	LDI  R30,LOW(32)
	CALL SUBOPT_0x0
; 0002 005D     DDRA = 0xFF;   //fac tot portul a sa fie sink pentru a scoate pinii din high-impedance si a ii aduce intr-o stare de ...
; 0002 005E     delay_us(1);
; 0002 005F     DDRA = (1<<PINA5);   //fac pinul a5 de iesire pentru a alimenta butoanele
	LDI  R30,LOW(32)
	CALL SUBOPT_0x1
; 0002 0060     for(i=0; i<10;i++){
_0x4000A:
	LDD  R26,Y+1
	LDD  R27,Y+1+1
	SBIW R26,10
	BRSH _0x4000B
; 0002 0061         aux = PINA;
	IN   R30,0x0
	ST   Y,R30
; 0002 0062     }
	CALL SUBOPT_0x2
	RJMP _0x4000A
_0x4000B:
; 0002 0063     StareButoane |= (unsigned short)(aux & ((1<<PINA0) | (1<<PINA1) | (1<< PINA2) | (1<<PINA3))) << 4;//citesc cei 4 pin ...
	LD   R30,Y
	ANDI R30,LOW(0xF)
	LDI  R31,0
	CALL __LSLW4
	CALL SUBOPT_0x3
; 0002 0064 
; 0002 0065     PORTA = (1<<PINA6);// pornesc pullup pe pinul a6
	LDI  R30,LOW(64)
	CALL SUBOPT_0x0
; 0002 0066     DDRA = 0xFF;   //fac tot portul a sa fie sink pentru a scoate pinii din high-impedance si a ii aduce intr-o stare de ...
; 0002 0067     delay_us(1);
; 0002 0068     DDRA = (1<<PINA6);    //fac pinul a6 de iesire pentru a alimenta butoanele
	LDI  R30,LOW(64)
	CALL SUBOPT_0x1
; 0002 0069     for(i=0; i<10;i++){
_0x4000D:
	LDD  R26,Y+1
	LDD  R27,Y+1+1
	SBIW R26,10
	BRSH _0x4000E
; 0002 006A         aux = PINA;      //citesc pinul de mai multe ori pentru a face debounce
	IN   R30,0x0
	ST   Y,R30
; 0002 006B     }
	CALL SUBOPT_0x2
	RJMP _0x4000D
_0x4000E:
; 0002 006C     StareButoane |= (unsigned short)(aux & ((1<<PINA0) | (1<<PINA1) | (1<< PINA2) | (1<<PINA3))) << 8; //citesc cei 4 pi ...
	LD   R30,Y
	ANDI R30,LOW(0xF)
	MOV  R31,R30
	LDI  R30,0
	CALL SUBOPT_0x3
; 0002 006D 
; 0002 006E     PORTA = (1<<PINA7);// pornesc pullup pe pinul a7
	LDI  R30,LOW(128)
	CALL SUBOPT_0x0
; 0002 006F     DDRA = 0xFF;   //fac tot portul a sa fie sink pentru a scoate pinii din high-impedance si a ii aduce intr-o stare de ...
; 0002 0070     delay_us(1);
; 0002 0071     DDRA = (1<<PINA7);  //fac pinul a7 de iesire pentru a alimenta butoanele
	LDI  R30,LOW(128)
	CALL SUBOPT_0x1
; 0002 0072     for(i=0; i<10;i++){
_0x40010:
	LDD  R26,Y+1
	LDD  R27,Y+1+1
	SBIW R26,10
	BRSH _0x40011
; 0002 0073         aux = PINA;      //citesc pinul de mai multe ori pentru a face debounce
	IN   R30,0x0
	ST   Y,R30
; 0002 0074     }
	CALL SUBOPT_0x2
	RJMP _0x40010
_0x40011:
; 0002 0075     PORTA = 0;
	LDI  R30,LOW(0)
	OUT  0x2,R30
; 0002 0076     //dupa asta am starea curenta a butoanelor (apasate/neapasate)
; 0002 0077     StareButoane |= (unsigned short)(aux & ((1<<PINA0) | (1<<PINA1) | (1<< PINA2) | (1<<PINA3))) << 12;  //citesc cei 4  ...
	LD   R30,Y
	ANDI R30,LOW(0xF)
	LDI  R31,0
	CALL __LSLW4
	MOV  R31,R30
	LDI  R30,0
	CALL SUBOPT_0x3
; 0002 0078 
; 0002 0079     for(i=0;i<16;i++){//pentru a nu primi input incontinuu, salvam doar trecerea din 0 in 1 a pinilor
	LDI  R30,LOW(0)
	STD  Y+1,R30
	STD  Y+1+1,R30
_0x40013:
	LDD  R26,Y+1
	LDD  R27,Y+1+1
	SBIW R26,16
	BRSH _0x40014
; 0002 007A         if(((StareButoaneInainte & ((unsigned short)1<<i)) == 0) && ((StareButoane & ((unsigned short)1<<i)) != 0)){//da ...
	CALL SUBOPT_0x4
	LDS  R26,_StareButoaneInainte_S0020000000
	LDS  R27,_StareButoaneInainte_S0020000000+1
	AND  R30,R26
	AND  R31,R27
	SBIW R30,0
	BRNE _0x40016
	CALL SUBOPT_0x4
	LDD  R26,Y+5
	LDD  R27,Y+5+1
	AND  R30,R26
	AND  R31,R27
	SBIW R30,0
	BRNE _0x40017
_0x40016:
	RJMP _0x40015
_0x40017:
; 0002 007B             ButoaneApasate |= ((unsigned short)1<<i);//salvez apasarea o singura data
	CALL SUBOPT_0x4
	LDD  R26,Y+3
	LDD  R27,Y+3+1
	OR   R30,R26
	OR   R31,R27
	STD  Y+3,R30
	STD  Y+3+1,R31
; 0002 007C         }
; 0002 007D     }
_0x40015:
	CALL SUBOPT_0x2
	RJMP _0x40013
_0x40014:
; 0002 007E     StareButoaneInainte = StareButoane;   //memorez noua stare a pinilor
	LDD  R30,Y+5
	LDD  R31,Y+5+1
	STS  _StareButoaneInainte_S0020000000,R30
	STS  _StareButoaneInainte_S0020000000+1,R31
; 0002 007F     return ButoaneApasate;               //intorc apasarea o singura data
	LDD  R30,Y+3
	LDD  R31,Y+3+1
	ADIW R28,7
	RET
; 0002 0080 }
; .FEND
;
;void TrimiteButoane(unsigned short Butoane){
; 0002 0082 void TrimiteButoane(unsigned short Butoane){
; 0002 0083     unsigned char i, Printez = 0;
; 0002 0084     for(i = 0; i < 16; i++){
;	Butoane -> Y+2
;	i -> R17
;	Printez -> R16
; 0002 0085         if(Butoane % 2 == 1){
; 0002 0086             putchar(i + 'a');//printez butoanele apasate ca litere pe uart
; 0002 0087             Printez = 1;
; 0002 0088         }
; 0002 0089         Butoane /= 2;
; 0002 008A     }
; 0002 008B     if(Printez){    //daca a fost printat macar un buton, merg si pe urmatoarea linie
; 0002 008C         putchar('\r');
; 0002 008D     }
; 0002 008E 
; 0002 008F }
;
;void PrinteazaJoc(){
; 0002 0091 void PrinteazaJoc(){
; 0002 0092     unsigned char i = 0, j=0;
; 0002 0093     for(i=0;i<3;i++){
;	i -> R17
;	j -> R16
; 0002 0094         for(j=0;j<3;j++){
; 0002 0095             putchar(displayJoc[i*3U+j]);//printez matricea jocului 3x3
; 0002 0096         }
; 0002 0097         putchar('\r');
; 0002 0098     }
; 0002 0099     putchar('\r');
; 0002 009A }
;
;void VerificaInvingatorul(){
; 0002 009C void VerificaInvingatorul(){
_VerificaInvingatorul:
; .FSTART _VerificaInvingatorul
; 0002 009D     unsigned char i;
; 0002 009E     for(i=0;i<3;i++){
	ST   -Y,R17
;	i -> R17
	LDI  R17,LOW(0)
_0x40024:
	CPI  R17,3
	BRLO PC+2
	RJMP _0x40025
; 0002 009F         //verifica invingatorul pe linii
; 0002 00A0         if(((displayJoc[i*3U] == displayJoc[i*3U+1U]) &&( displayJoc[i*3U+1U] == displayJoc[i*3U+2U])) && displayJoc[i*3 ...
	LDI  R30,LOW(3)
	MUL  R30,R17
	MOVW R30,R0
	MOVW R22,R30
	SUBI R30,LOW(-_displayJoc)
	SBCI R31,HIGH(-_displayJoc)
	LD   R26,Z
	MOVW R30,R0
	__ADDW1MN _displayJoc,1
	LD   R30,Z
	CP   R30,R26
	BRNE _0x40027
	MOVW R30,R22
	__ADDW1MN _displayJoc,1
	LD   R26,Z
	MOVW R30,R22
	__ADDW1MN _displayJoc,2
	LD   R30,Z
	CP   R30,R26
	BREQ _0x40028
_0x40027:
	RJMP _0x40029
_0x40028:
	MOVW R30,R22
	CALL SUBOPT_0x5
	BRNE _0x4002A
_0x40029:
	RJMP _0x40026
_0x4002A:
; 0002 00A1             castigat = displayJoc[i*3U];
	LDI  R30,LOW(3)
	MUL  R30,R17
	MOVW R30,R0
	SUBI R30,LOW(-_displayJoc)
	SBCI R31,HIGH(-_displayJoc)
	LD   R30,Z
	STS  _castigat,R30
; 0002 00A2         }
; 0002 00A3         //verifica invingatorul pe coloane
; 0002 00A4         if(((displayJoc[i] == displayJoc[i+3U]) &&( displayJoc[i+3U] == displayJoc[i+6U])) && displayJoc[i] != '.'){
_0x40026:
	MOV  R30,R17
	LDI  R31,0
	SUBI R30,LOW(-_displayJoc)
	SBCI R31,HIGH(-_displayJoc)
	LD   R26,Z
	MOV  R30,R17
	LDI  R31,0
	__ADDW1MN _displayJoc,3
	LD   R30,Z
	CP   R30,R26
	BRNE _0x4002C
	MOV  R30,R17
	LDI  R31,0
	__ADDW1MN _displayJoc,3
	LD   R26,Z
	MOV  R30,R17
	LDI  R31,0
	__ADDW1MN _displayJoc,6
	LD   R30,Z
	CP   R30,R26
	BREQ _0x4002D
_0x4002C:
	RJMP _0x4002E
_0x4002D:
	MOV  R30,R17
	LDI  R31,0
	CALL SUBOPT_0x5
	BRNE _0x4002F
_0x4002E:
	RJMP _0x4002B
_0x4002F:
; 0002 00A5             castigat = displayJoc[i];
	MOV  R30,R17
	LDI  R31,0
	SUBI R30,LOW(-_displayJoc)
	SBCI R31,HIGH(-_displayJoc)
	LD   R30,Z
	STS  _castigat,R30
; 0002 00A6         }
; 0002 00A7     }
_0x4002B:
	SUBI R17,-1
	RJMP _0x40024
_0x40025:
; 0002 00A8     //verifica invingatorul pe diagonale
; 0002 00A9     if(((displayJoc[0U] == displayJoc[4U]) &&( displayJoc[4U] == displayJoc[8U])) && displayJoc[0U] != '.'){
	__GETB1MN _displayJoc,4
	LDS  R26,_displayJoc
	CP   R30,R26
	BRNE _0x40031
	__GETB2MN _displayJoc,4
	__GETB1MN _displayJoc,8
	CP   R30,R26
	BREQ _0x40032
_0x40031:
	RJMP _0x40033
_0x40032:
	LDS  R26,_displayJoc
	CPI  R26,LOW(0x2E)
	BRNE _0x40034
_0x40033:
	RJMP _0x40030
_0x40034:
; 0002 00AA             castigat = displayJoc[4U];
	__GETB1MN _displayJoc,4
	STS  _castigat,R30
; 0002 00AB     }
; 0002 00AC     if(((displayJoc[6U] == displayJoc[4U]) &&( displayJoc[4U] == displayJoc[2U])) && displayJoc[2U] != '.'){
_0x40030:
	__GETB2MN _displayJoc,6
	__GETB1MN _displayJoc,4
	CP   R30,R26
	BRNE _0x40036
	__GETB2MN _displayJoc,4
	__GETB1MN _displayJoc,2
	CP   R30,R26
	BREQ _0x40037
_0x40036:
	RJMP _0x40038
_0x40037:
	__GETB2MN _displayJoc,2
	CPI  R26,LOW(0x2E)
	BRNE _0x40039
_0x40038:
	RJMP _0x40035
_0x40039:
; 0002 00AD             castigat = displayJoc[4U];
	__GETB1MN _displayJoc,4
	STS  _castigat,R30
; 0002 00AE     }
; 0002 00AF }
_0x40035:
	RJMP _0x20A0001
; .FEND
;
;void UpdateJoc(unsigned short butoane){
; 0002 00B1 void UpdateJoc(unsigned short butoane){
_UpdateJoc:
; .FSTART _UpdateJoc
; 0002 00B2     unsigned char i, j;
; 0002 00B3     for(i=0;i<3;i++){
	ST   -Y,R27
	ST   -Y,R26
	ST   -Y,R17
	ST   -Y,R16
;	butoane -> Y+2
;	i -> R17
;	j -> R16
	LDI  R17,LOW(0)
_0x4003B:
	CPI  R17,3
	BRSH _0x4003C
; 0002 00B4         for(j=0; j<3;j++){
	LDI  R16,LOW(0)
_0x4003E:
	CPI  R16,3
	BRSH _0x4003F
; 0002 00B5             if((butoane & ((unsigned short)1<<(i*4+j))) != 0){ //trec prin fiecare casuta in parte si verific daca buton ...
	MOV  R30,R17
	LSL  R30
	LSL  R30
	ADD  R30,R16
	LDI  R26,LOW(1)
	LDI  R27,HIGH(1)
	CALL __LSLW12
	LDD  R26,Y+2
	LDD  R27,Y+2+1
	AND  R30,R26
	AND  R31,R27
	SBIW R30,0
	BREQ _0x40040
; 0002 00B6                 if( displayJoc[j*3U+(2U-i)] == '.'){    //daca nu e niciun semn acolo, pot pune urmatorul caracter
	CALL SUBOPT_0x6
	CALL SUBOPT_0x5
	BRNE _0x40041
; 0002 00B7                     remiza--;//scad numarul de caractere ramase pana la remiza
	LDS  R30,_remiza
	SUBI R30,LOW(1)
	STS  _remiza,R30
; 0002 00B8                     displayJoc[j*3U+(2U-i)] = caracterUrmator;//pun in casuta caracterul urmator;
	CALL SUBOPT_0x6
	SUBI R30,LOW(-_displayJoc)
	SBCI R31,HIGH(-_displayJoc)
	ST   Z,R9
; 0002 00B9                     if(caracterUrmator == 'X'){//schimb caracterul ce urmeaza
	LDI  R30,LOW(88)
	CP   R30,R9
	BRNE _0x40042
; 0002 00BA                         caracterUrmator = '0';
	LDI  R30,LOW(48)
	RJMP _0x40060
; 0002 00BB                     }
; 0002 00BC                     else{
_0x40042:
; 0002 00BD                         caracterUrmator = 'X';
	LDI  R30,LOW(88)
_0x40060:
	MOV  R9,R30
; 0002 00BE                     }
; 0002 00BF                 }
; 0002 00C0                 break;
_0x40041:
	RJMP _0x4003F
; 0002 00C1             }
; 0002 00C2         }
_0x40040:
	SUBI R16,-1
	RJMP _0x4003E
_0x4003F:
; 0002 00C3 
; 0002 00C4     }
	SUBI R17,-1
	RJMP _0x4003B
_0x4003C:
; 0002 00C5 }
	LDD  R17,Y+1
	LDD  R16,Y+0
	ADIW R28,4
	RET
; .FEND
;
;void PrintCaracterDisplay(unsigned char caracter){
; 0002 00C7 void PrintCaracterDisplay(unsigned char caracter){
_PrintCaracterDisplay:
; .FSTART _PrintCaracterDisplay
; 0002 00C8     unsigned char i;
; 0002 00C9     if(caracter >= 32){
	ST   -Y,R26
	ST   -Y,R17
;	caracter -> Y+1
;	i -> R17
	LDD  R26,Y+1
	CPI  R26,LOW(0x20)
	BRLO _0x40044
; 0002 00CA         caracter-=32;
	LDD  R30,Y+1
	SUBI R30,LOW(32)
	STD  Y+1,R30
; 0002 00CB         i2c_start();
	CALL SUBOPT_0x7
; 0002 00CC         i2c_write(AdresaDisplayMic<<1);
; 0002 00CD         i2c_write(0x40);
	LDI  R26,LOW(64)
	CALL _i2c_write
; 0002 00CE         //construiesc caracterul
; 0002 00CF         for(i=0;i<8U;i++){
	LDI  R17,LOW(0)
_0x40046:
	MOV  R26,R17
	CLR  R27
	SBIW R26,8
	BRGE _0x40047
; 0002 00D0             i2c_write(font8x8_basic[caracter][i]);
	LDD  R30,Y+1
	CALL SUBOPT_0x8
	MOVW R26,R30
	CLR  R30
	ADD  R26,R17
	ADC  R27,R30
	LD   R26,X
	CALL _i2c_write
; 0002 00D1         }
	SUBI R17,-1
	RJMP _0x40046
_0x40047:
; 0002 00D2         i2c_stop();
	CALL _i2c_stop
; 0002 00D3     }
; 0002 00D4 
; 0002 00D5 }
_0x40044:
	LDD  R17,Y+0
	RJMP _0x20A0002
; .FEND
;
;void Data1Bit(unsigned char data){
; 0002 00D7 void Data1Bit(unsigned char data){
; 0002 00D8     i2c_start();
;	data -> Y+0
; 0002 00D9     i2c_write(AdresaDisplayMic<<1);
; 0002 00DA     i2c_write(0xC0);
; 0002 00DB     i2c_write(data);
; 0002 00DC     i2c_stop();
; 0002 00DD }
;
;void Comanda1Bit(unsigned char comanda1){
; 0002 00DF void Comanda1Bit(unsigned char comanda1){
_Comanda1Bit:
; .FSTART _Comanda1Bit
; 0002 00E0     i2c_start();
	ST   -Y,R26
;	comanda1 -> Y+0
	CALL SUBOPT_0x7
; 0002 00E1     i2c_write(AdresaDisplayMic<<1);
; 0002 00E2     i2c_write(0x80);
	LDI  R26,LOW(128)
	CALL SUBOPT_0x9
; 0002 00E3     i2c_write(comanda1);
; 0002 00E4     i2c_stop();
; 0002 00E5 }
	ADIW R28,1
	RET
; .FEND
;
;void Comanda2Biti(unsigned char comanda1, unsigned char comanda2){
; 0002 00E7 void Comanda2Biti(unsigned char comanda1, unsigned char comanda2){
_Comanda2Biti:
; .FSTART _Comanda2Biti
; 0002 00E8     i2c_start();
	ST   -Y,R26
;	comanda1 -> Y+1
;	comanda2 -> Y+0
	CALL SUBOPT_0x7
; 0002 00E9     i2c_write(AdresaDisplayMic<<1);
; 0002 00EA     i2c_write(0x00);
	LDI  R26,LOW(0)
	CALL _i2c_write
; 0002 00EB     i2c_write(comanda1);
	LDD  R26,Y+1
	CALL SUBOPT_0x9
; 0002 00EC     i2c_write(comanda2);
; 0002 00ED     i2c_stop();
; 0002 00EE }
_0x20A0002:
	ADIW R28,2
	RET
; .FEND
;
;void Comanda3Biti(unsigned char comanda1, unsigned char comanda2, unsigned char comanda3){
; 0002 00F0 void Comanda3Biti(unsigned char comanda1, unsigned char comanda2, unsigned char comanda3){
_Comanda3Biti:
; .FSTART _Comanda3Biti
; 0002 00F1     i2c_start();
	ST   -Y,R26
;	comanda1 -> Y+2
;	comanda2 -> Y+1
;	comanda3 -> Y+0
	CALL SUBOPT_0x7
; 0002 00F2     i2c_write(AdresaDisplayMic<<1);
; 0002 00F3     i2c_write(0x00);
	LDI  R26,LOW(0)
	CALL _i2c_write
; 0002 00F4     i2c_write(comanda1);
	LDD  R26,Y+2
	CALL _i2c_write
; 0002 00F5     i2c_write(comanda2);
	LDD  R26,Y+1
	CALL SUBOPT_0x9
; 0002 00F6     i2c_write(comanda3);
; 0002 00F7     i2c_stop();
; 0002 00F8 }
	ADIW R28,3
	RET
; .FEND
;
;void InitDisplay(){
; 0002 00FA void InitDisplay(){
_InitDisplay:
; .FSTART _InitDisplay
; 0002 00FB     Comanda1Bit(0xAF);//on
	LDI  R26,LOW(175)
	RCALL _Comanda1Bit
; 0002 00FC     Comanda2Biti(0xD5, 0x80);//clk
	LDI  R30,LOW(213)
	ST   -Y,R30
	LDI  R26,LOW(128)
	RCALL _Comanda2Biti
; 0002 00FD     Comanda2Biti(0xA8, 0x1F);//multiplex
	LDI  R30,LOW(168)
	ST   -Y,R30
	LDI  R26,LOW(31)
	RCALL _Comanda2Biti
; 0002 00FE     Comanda1Bit(0x40);//start line
	LDI  R26,LOW(64)
	RCALL _Comanda1Bit
; 0002 00FF     Comanda2Biti(0x8D, 0x14);//charge pump
	LDI  R30,LOW(141)
	ST   -Y,R30
	LDI  R26,LOW(20)
	RCALL _Comanda2Biti
; 0002 0100     Comanda2Biti(0xA1, 0xC8);//segmente remap
	LDI  R30,LOW(161)
	ST   -Y,R30
	LDI  R26,LOW(200)
	RCALL _Comanda2Biti
; 0002 0101     Comanda2Biti(0xDA, 0x02);//com hw config
	LDI  R30,LOW(218)
	ST   -Y,R30
	LDI  R26,LOW(2)
	RCALL _Comanda2Biti
; 0002 0102     Comanda2Biti(0xD3, 0x00);//offset
	LDI  R30,LOW(211)
	ST   -Y,R30
	LDI  R26,LOW(0)
	RCALL _Comanda2Biti
; 0002 0103     Comanda2Biti(0x81, 0x05);//contrast/luminozitate
	LDI  R30,LOW(129)
	ST   -Y,R30
	LDI  R26,LOW(5)
	RCALL _Comanda2Biti
; 0002 0104     Comanda2Biti(0xD9, 0xF1);//precharge period
	LDI  R30,LOW(217)
	ST   -Y,R30
	LDI  R26,LOW(241)
	RCALL _Comanda2Biti
; 0002 0105     Comanda2Biti(0xDB, 0x20);//VCOMh deselect level
	LDI  R30,LOW(219)
	ST   -Y,R30
	LDI  R26,LOW(32)
	RCALL _Comanda2Biti
; 0002 0106     Comanda3Biti(0x22, 0x00, 0x03);//page range
	CALL SUBOPT_0xA
; 0002 0107     Comanda3Biti(0x21, 0x00, 0x7F);//column range
; 0002 0108     Comanda1Bit(0xA4);//all pixeli on
	LDI  R26,LOW(164)
	RCALL _Comanda1Bit
; 0002 0109     Comanda1Bit(0xA6);//non inverted
	LDI  R26,LOW(166)
	RCALL _Comanda1Bit
; 0002 010A     Comanda1Bit(0xAF);//display on
	LDI  R26,LOW(175)
	RCALL _Comanda1Bit
; 0002 010B     Comanda2Biti(0x20, 0x00);//address mode
	LDI  R30,LOW(32)
	ST   -Y,R30
	LDI  R26,LOW(0)
	RCALL _Comanda2Biti
; 0002 010C }
	RET
; .FEND
;
;void DisplayClear(){
; 0002 010E void DisplayClear(){
_DisplayClear:
; .FSTART _DisplayClear
; 0002 010F     unsigned char i;
; 0002 0110     Comanda3Biti(0x22, 0x00, 0x03);//page range
	ST   -Y,R17
;	i -> R17
	CALL SUBOPT_0xA
; 0002 0111     Comanda3Biti(0x21, 0x00, 0x7F);//column range
; 0002 0112     for(i = 0U; i < 16U*4U; i++){
	LDI  R17,LOW(0)
_0x40049:
	CPI  R17,64
	BRSH _0x4004A
; 0002 0113         PrintCaracterDisplay(32);
	LDI  R26,LOW(32)
	RCALL _PrintCaracterDisplay
; 0002 0114     }
	SUBI R17,-1
	RJMP _0x40049
_0x4004A:
; 0002 0115 }
_0x20A0001:
	LD   R17,Y+
	RET
; .FEND
;
;void RotescLiterele(){
; 0002 0117 void RotescLiterele(){
_RotescLiterele:
; .FSTART _RotescLiterele
; 0002 0118     unsigned char CharactersLine, BitmapCharacterIndex, BitmapLineIndex, i;
; 0002 0119     unsigned char TempCharactersLine[8];
; 0002 011A     int j;
; 0002 011B     for(BitmapCharacterIndex = 0U; BitmapCharacterIndex < 65U; BitmapCharacterIndex++){
	SBIW R28,8
	CALL __SAVELOCR6
;	CharactersLine -> R17
;	BitmapCharacterIndex -> R16
;	BitmapLineIndex -> R19
;	i -> R18
;	TempCharactersLine -> Y+6
;	j -> R20,R21
	LDI  R16,LOW(0)
_0x4004C:
	MOV  R26,R16
	CLR  R27
	CPI  R26,LOW(0x41)
	LDI  R30,HIGH(0x41)
	CPC  R27,R30
	BRGE _0x4004D
; 0002 011C         for(BitmapLineIndex = 0U; BitmapLineIndex < 8U; BitmapLineIndex++){
	LDI  R19,LOW(0)
_0x4004F:
	MOV  R26,R19
	CLR  R27
	SBIW R26,8
	BRGE _0x40050
; 0002 011D             CharactersLine = 0;
	LDI  R17,LOW(0)
; 0002 011E             for(j = 7U; j >= 0U; j--){
	__GETWRN 20,21,7
_0x40052:
	TST  R21
	BRMI _0x40053
; 0002 011F                 CharactersLine = CharactersLine << 1U;
	LSL  R17
; 0002 0120                 CharactersLine += ((font8x8_basic[BitmapCharacterIndex][j]) >> BitmapLineIndex) % 2U;
	MOV  R30,R16
	CALL SUBOPT_0x8
	ADD  R30,R20
	ADC  R31,R21
	LD   R26,Z
	MOV  R30,R19
	CALL __LSRB12
	ANDI R30,LOW(0x1)
	ADD  R17,R30
; 0002 0121             }
	__SUBWRN 20,21,1
	RJMP _0x40052
_0x40053:
; 0002 0122             TempCharactersLine[BitmapLineIndex] = CharactersLine;
	MOV  R30,R19
	LDI  R31,0
	MOVW R26,R28
	ADIW R26,6
	ADD  R30,R26
	ADC  R31,R27
	ST   Z,R17
; 0002 0123         }
	SUBI R19,-1
	RJMP _0x4004F
_0x40050:
; 0002 0124         for(i = 0U; i < 8U; i++){
	LDI  R18,LOW(0)
_0x40055:
	MOV  R26,R18
	CLR  R27
	SBIW R26,8
	BRGE _0x40056
; 0002 0125             font8x8_basic[BitmapCharacterIndex][i] = TempCharactersLine[i];
	MOV  R30,R16
	CALL SUBOPT_0x8
	MOVW R26,R30
	MOV  R30,R18
	LDI  R31,0
	ADD  R30,R26
	ADC  R31,R27
	MOVW R0,R30
	MOV  R30,R18
	LDI  R31,0
	MOVW R26,R28
	ADIW R26,6
	ADD  R26,R30
	ADC  R27,R31
	LD   R30,X
	MOVW R26,R0
	ST   X,R30
; 0002 0126         }
	SUBI R18,-1
	RJMP _0x40055
_0x40056:
; 0002 0127     }
	SUBI R16,-1
	RJMP _0x4004C
_0x4004D:
; 0002 0128 }
	CALL __LOADLOCR6
	ADIW R28,14
	RET
; .FEND
;
;void PrinteazaJocDisplay(){
; 0002 012A void PrinteazaJocDisplay(){
_PrinteazaJocDisplay:
; .FSTART _PrinteazaJocDisplay
; 0002 012B     unsigned char i = 0, j=0;
; 0002 012C     Comanda3Biti(0x22, 0x00, 0x03);//page range
	ST   -Y,R17
	ST   -Y,R16
;	i -> R17
;	j -> R16
	LDI  R17,0
	LDI  R16,0
	CALL SUBOPT_0xA
; 0002 012D     Comanda3Biti(0x21, 0x00, 0x7F);//column range
; 0002 012E     for(i=0;i<3;i++){
	LDI  R17,LOW(0)
_0x40058:
	CPI  R17,3
	BRSH _0x40059
; 0002 012F         for(j=0;j<3;j++){
	LDI  R16,LOW(0)
_0x4005B:
	CPI  R16,3
	BRSH _0x4005C
; 0002 0130             PrintCaracterDisplay(displayJoc[i*3U+j]);//printez matricea jocului 3x3
	LDI  R30,LOW(3)
	MUL  R30,R17
	MOVW R30,R0
	MOVW R26,R30
	MOV  R30,R16
	LDI  R31,0
	ADD  R30,R26
	ADC  R31,R27
	SUBI R30,LOW(-_displayJoc)
	SBCI R31,HIGH(-_displayJoc)
	LD   R26,Z
	RCALL _PrintCaracterDisplay
; 0002 0131         }
	SUBI R16,-1
	RJMP _0x4005B
_0x4005C:
; 0002 0132         for(j=3;j<16;j++){
	LDI  R16,LOW(3)
_0x4005E:
	CPI  R16,16
	BRSH _0x4005F
; 0002 0133             PrintCaracterDisplay(' ');
	LDI  R26,LOW(32)
	RCALL _PrintCaracterDisplay
; 0002 0134         }
	SUBI R16,-1
	RJMP _0x4005E
_0x4005F:
; 0002 0135     }
	SUBI R17,-1
	RJMP _0x40058
_0x40059:
; 0002 0136 }
	LD   R16,Y+
	LD   R17,Y+
	RET
; .FEND
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x01
	.EQU __sm_mask=0x0E
	.EQU __sm_powerdown=0x04
	.EQU __sm_powersave=0x06
	.EQU __sm_standby=0x0C
	.EQU __sm_ext_standby=0x0E
	.EQU __sm_adc_noise_red=0x02
	.SET power_ctrl_reg=smcr
	#endif

	.CSEG

	.CSEG

	.CSEG

	.DSEG

	.CSEG

	.CSEG

	.CSEG

	.DSEG
_rx_buffer0:
	.BYTE 0x8
_tx_buffer0:
	.BYTE 0x8
_castigat:
	.BYTE 0x1
_remiza:
	.BYTE 0x1
_displayJoc:
	.BYTE 0x9
_font8x8_basic:
	.BYTE 0x208
_StareButoaneInainte_S0020000000:
	.BYTE 0x2
__seed_G102:
	.BYTE 0x4

	.CSEG
;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x0:
	OUT  0x2,R30
	LDI  R30,LOW(255)
	OUT  0x1,R30
	__DELAY_USB 7
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x1:
	OUT  0x1,R30
	LDI  R30,LOW(0)
	STD  Y+1,R30
	STD  Y+1+1,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x2:
	LDD  R30,Y+1
	LDD  R31,Y+1+1
	ADIW R30,1
	STD  Y+1,R30
	STD  Y+1+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x3:
	LDD  R26,Y+5
	LDD  R27,Y+5+1
	OR   R30,R26
	OR   R31,R27
	STD  Y+5,R30
	STD  Y+5+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x4:
	LDD  R30,Y+1
	LDI  R26,LOW(1)
	LDI  R27,HIGH(1)
	CALL __LSLW12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x5:
	SUBI R30,LOW(-_displayJoc)
	SBCI R31,HIGH(-_displayJoc)
	LD   R26,Z
	CPI  R26,LOW(0x2E)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:8 WORDS
SUBOPT_0x6:
	LDI  R30,LOW(3)
	MUL  R30,R16
	MOVW R22,R0
	MOV  R30,R17
	LDI  R31,0
	LDI  R26,LOW(2)
	LDI  R27,HIGH(2)
	CALL __SWAPW12
	SUB  R30,R26
	SBC  R31,R27
	ADD  R30,R22
	ADC  R31,R23
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x7:
	CALL _i2c_start
	LDI  R26,LOW(120)
	JMP  _i2c_write

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x8:
	LDI  R31,0
	CALL __LSLW3
	SUBI R30,LOW(-_font8x8_basic)
	SBCI R31,HIGH(-_font8x8_basic)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x9:
	CALL _i2c_write
	LD   R26,Y
	CALL _i2c_write
	JMP  _i2c_stop

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:21 WORDS
SUBOPT_0xA:
	LDI  R30,LOW(34)
	ST   -Y,R30
	LDI  R30,LOW(0)
	ST   -Y,R30
	LDI  R26,LOW(3)
	CALL _Comanda3Biti
	LDI  R30,LOW(33)
	ST   -Y,R30
	LDI  R30,LOW(0)
	ST   -Y,R30
	LDI  R26,LOW(127)
	JMP  _Comanda3Biti


	.CSEG
	.equ __sda_bit=1
	.equ __scl_bit=0
	.equ __i2c_port=0x08 ;PORTC
	.equ __i2c_dir=__i2c_port-1
	.equ __i2c_pin=__i2c_port-2

_i2c_init:
	cbi  __i2c_port,__scl_bit
	cbi  __i2c_port,__sda_bit
	sbi  __i2c_dir,__scl_bit
	cbi  __i2c_dir,__sda_bit
	rjmp __i2c_delay2
_i2c_start:
	cbi  __i2c_dir,__sda_bit
	cbi  __i2c_dir,__scl_bit
	clr  r30
	nop
	sbis __i2c_pin,__sda_bit
	ret
	sbis __i2c_pin,__scl_bit
	ret
	rcall __i2c_delay1
	sbi  __i2c_dir,__sda_bit
	rcall __i2c_delay1
	sbi  __i2c_dir,__scl_bit
	ldi  r30,1
__i2c_delay1:
	ldi  r22,33
	rjmp __i2c_delay2l
_i2c_stop:
	sbi  __i2c_dir,__sda_bit
	sbi  __i2c_dir,__scl_bit
	rcall __i2c_delay2
	cbi  __i2c_dir,__scl_bit
	rcall __i2c_delay1
	cbi  __i2c_dir,__sda_bit
__i2c_delay2:
	ldi  r22,67
__i2c_delay2l:
	dec  r22
	brne __i2c_delay2l
	ret
_i2c_read:
	ldi  r23,8
__i2c_read0:
	cbi  __i2c_dir,__scl_bit
	rcall __i2c_delay1
__i2c_read3:
	sbis __i2c_pin,__scl_bit
	rjmp __i2c_read3
	rcall __i2c_delay1
	clc
	sbic __i2c_pin,__sda_bit
	sec
	sbi  __i2c_dir,__scl_bit
	rcall __i2c_delay2
	rol  r30
	dec  r23
	brne __i2c_read0
	mov  r23,r26
	tst  r23
	brne __i2c_read1
	cbi  __i2c_dir,__sda_bit
	rjmp __i2c_read2
__i2c_read1:
	sbi  __i2c_dir,__sda_bit
__i2c_read2:
	rcall __i2c_delay1
	cbi  __i2c_dir,__scl_bit
	rcall __i2c_delay2
	sbi  __i2c_dir,__scl_bit
	rcall __i2c_delay1
	cbi  __i2c_dir,__sda_bit
	rjmp __i2c_delay1

_i2c_write:
	ldi  r23,8
__i2c_write0:
	lsl  r26
	brcc __i2c_write1
	cbi  __i2c_dir,__sda_bit
	rjmp __i2c_write2
__i2c_write1:
	sbi  __i2c_dir,__sda_bit
__i2c_write2:
	rcall __i2c_delay2
	cbi  __i2c_dir,__scl_bit
	rcall __i2c_delay1
__i2c_write3:
	sbis __i2c_pin,__scl_bit
	rjmp __i2c_write3
	rcall __i2c_delay1
	sbi  __i2c_dir,__scl_bit
	dec  r23
	brne __i2c_write0
	cbi  __i2c_dir,__sda_bit
	rcall __i2c_delay1
	cbi  __i2c_dir,__scl_bit
	rcall __i2c_delay2
	ldi  r30,1
	sbic __i2c_pin,__sda_bit
	clr  r30
	sbi  __i2c_dir,__scl_bit
	rjmp __i2c_delay1

__LSRB12:
	TST  R30
	MOV  R0,R30
	MOV  R30,R26
	BREQ __LSRB12R
__LSRB12L:
	LSR  R30
	DEC  R0
	BRNE __LSRB12L
__LSRB12R:
	RET

__LSLW12:
	TST  R30
	MOV  R0,R30
	MOVW R30,R26
	BREQ __LSLW12R
__LSLW12L:
	LSL  R30
	ROL  R31
	DEC  R0
	BRNE __LSLW12L
__LSLW12R:
	RET

__LSLW4:
	LSL  R30
	ROL  R31
__LSLW3:
	LSL  R30
	ROL  R31
__LSLW2:
	LSL  R30
	ROL  R31
	LSL  R30
	ROL  R31
	RET

__SWAPW12:
	MOV  R1,R27
	MOV  R27,R31
	MOV  R31,R1

__SWAPB12:
	MOV  R1,R26
	MOV  R26,R30
	MOV  R30,R1
	RET

__SAVELOCR6:
	ST   -Y,R21
__SAVELOCR5:
	ST   -Y,R20
__SAVELOCR4:
	ST   -Y,R19
__SAVELOCR3:
	ST   -Y,R18
__SAVELOCR2:
	ST   -Y,R17
	ST   -Y,R16
	RET

__LOADLOCR6:
	LDD  R21,Y+5
__LOADLOCR5:
	LDD  R20,Y+4
__LOADLOCR4:
	LDD  R19,Y+3
__LOADLOCR3:
	LDD  R18,Y+2
__LOADLOCR2:
	LDD  R17,Y+1
	LD   R16,Y
	RET

;END OF CODE MARKER
__END_OF_CODE:

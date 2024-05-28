
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
	.DEF _remiza=R8
	.DEF _castigat=R11
	.DEF __Addr=R10
	.DEF __displayfunction=R13
	.DEF __displaycontrol=R12

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
	JMP  _timer1_compa_isr
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
	.DB  0x9,0x58,0x0,0x0

_0x16:
	.DB  0x2E,0x2E,0x2E,0x2E,0x2E,0x2E,0x2E,0x2E
	.DB  0x2E
_0x0:
	.DB  0xD,0x53,0x55,0x49,0x49,0x49,0x49,0x49
	.DB  0x49,0x49,0x49,0x20,0x61,0x20,0x63,0x61
	.DB  0x73,0x74,0x69,0x67,0x61,0x74,0x20,0x25
	.DB  0x63,0xD,0x0,0x4D,0x69,0x20,0x73,0x65
	.DB  0x20,0x66,0x61,0x63,0x65,0x20,0x72,0x61
	.DB  0x75,0x0
_0x2040060:
	.DB  0x1
_0x2040000:
	.DB  0x2D,0x4E,0x41,0x4E,0x0,0x49,0x4E,0x46
	.DB  0x0

__GLOBAL_INI_TBL:
	.DW  0x04
	.DW  0x08
	.DW  __REG_VARS*2

	.DW  0x09
	.DW  _displayJoc
	.DW  _0x16*2

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
	RJMP _0x4C
; .FEND
;
;#ifndef _DEBUG_TERMINAL_IO_
;// Get a character from the USART0 Receiver buffer
;#define _ALTERNATE_GETCHAR_
;#pragma used+
;char getchar(void)
; 0000 0063 {
_getchar:
; .FSTART _getchar
; 0000 0064 char data;
; 0000 0065 while (rx_counter0==0);
	ST   -Y,R17
;	data -> R17
_0x8:
	TST  R5
	BREQ _0x8
; 0000 0066 data=rx_buffer0[rx_rd_index0++];
	MOV  R30,R2
	INC  R2
	LDI  R31,0
	SUBI R30,LOW(-_rx_buffer0)
	SBCI R31,HIGH(-_rx_buffer0)
	LD   R17,Z
; 0000 0067 #if RX_BUFFER_SIZE0 != 256
; 0000 0068 if (rx_rd_index0 == RX_BUFFER_SIZE0) rx_rd_index0=0;
	LDI  R30,LOW(8)
	CP   R30,R2
	BRNE _0xB
	CLR  R2
; 0000 0069 #endif
; 0000 006A #asm("cli")
_0xB:
	cli
; 0000 006B --rx_counter0;
	DEC  R5
; 0000 006C #asm("sei")
	sei
; 0000 006D return data;
	MOV  R30,R17
	RJMP _0x20A0001
; 0000 006E }
; .FEND
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
_0x4C:
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
_putchar:
; .FSTART _putchar
; 0000 008F while (tx_counter0 == TX_BUFFER_SIZE0);
	ST   -Y,R26
;	c -> Y+0
_0xE:
	LDI  R30,LOW(8)
	CP   R30,R6
	BREQ _0xE
; 0000 0090 #asm("cli")
	cli
; 0000 0091 if (tx_counter0 || ((UCSR0A & DATA_REGISTER_EMPTY)==0))
	TST  R6
	BRNE _0x12
	LDS  R30,192
	ANDI R30,LOW(0x20)
	BRNE _0x11
_0x12:
; 0000 0092    {
; 0000 0093    tx_buffer0[tx_wr_index0++]=c;
	MOV  R30,R4
	INC  R4
	LDI  R31,0
	SUBI R30,LOW(-_tx_buffer0)
	SBCI R31,HIGH(-_tx_buffer0)
	LD   R26,Y
	STD  Z+0,R26
; 0000 0094 #if TX_BUFFER_SIZE0 != 256
; 0000 0095    if (tx_wr_index0 == TX_BUFFER_SIZE0) tx_wr_index0=0;
	LDI  R30,LOW(8)
	CP   R30,R4
	BRNE _0x14
	CLR  R4
; 0000 0096 #endif
; 0000 0097    ++tx_counter0;
_0x14:
	INC  R6
; 0000 0098    }
; 0000 0099 else
	RJMP _0x15
_0x11:
; 0000 009A    UDR0=c;
	LD   R30,Y
	STS  198,R30
; 0000 009B #asm("sei")
_0x15:
	sei
; 0000 009C }
	ADIW R28,1
	RET
; .FEND
;#pragma used-
;#endif
;//*************************************************************************************************
;//********************END SERIAL STUFF (USART0)  **************************************************
;//*************************************************************************************************
;//*******   if you need USART1, enable it in Code Wizard and copy coresponding code here  *********
;//*************************************************************************************************
;
;/*
; * Timer 1 Output Compare A interrupt is used to blink LED
; */
;
;interrupt [TIM1_COMPA] void timer1_compa_isr(void)
; 0000 00AA {
_timer1_compa_isr:
; .FSTART _timer1_compa_isr
; 0000 00AB //LED1 = ~LED1; // invert LED
; 0000 00AC }
	RETI
; .FEND
;
;/*
; * main function of program
; */
;unsigned char displayJoc[9] = {'.', '.', '.','.', '.', '.','.', '.', '.'};

	.DSEG
;unsigned char caracterUrmator = 'X', remiza = 9, castigat = 0;
;
;void UpdateJoc(unsigned short butoane){
; 0000 00B4 void UpdateJoc(unsigned short butoane){

	.CSEG
_UpdateJoc:
; .FSTART _UpdateJoc
; 0000 00B5     unsigned char i, j;
; 0000 00B6     for(i=0;i<3;i++){
	ST   -Y,R27
	ST   -Y,R26
	ST   -Y,R17
	ST   -Y,R16
;	butoane -> Y+2
;	i -> R17
;	j -> R16
	LDI  R17,LOW(0)
_0x18:
	CPI  R17,3
	BRSH _0x19
; 0000 00B7         for(j=0; j<3;j++){
	LDI  R16,LOW(0)
_0x1B:
	CPI  R16,3
	BRSH _0x1C
; 0000 00B8             if((butoane & ((unsigned short)1<<(i*4+j))) != 0){
	MOV  R30,R17
	LSL  R30
	LSL  R30
	ADD  R30,R16
	CALL SUBOPT_0x0
	LDD  R26,Y+2
	LDD  R27,Y+2+1
	AND  R30,R26
	AND  R31,R27
	SBIW R30,0
	BREQ _0x1D
; 0000 00B9                 if( displayJoc[j*3U+(2U-i)] == '.'){
	CALL SUBOPT_0x1
	LD   R26,Z
	CPI  R26,LOW(0x2E)
	BRNE _0x1E
; 0000 00BA                     remiza--;
	DEC  R8
; 0000 00BB                     displayJoc[j*3U+(2U-i)] = caracterUrmator;
	CALL SUBOPT_0x1
	ST   Z,R9
; 0000 00BC                     if(caracterUrmator == 'X'){
	LDI  R30,LOW(88)
	CP   R30,R9
	BRNE _0x1F
; 0000 00BD                         caracterUrmator = '0';
	LDI  R30,LOW(48)
	RJMP _0x4B
; 0000 00BE                     }
; 0000 00BF                     else{
_0x1F:
; 0000 00C0                         caracterUrmator = 'X';
	LDI  R30,LOW(88)
_0x4B:
	MOV  R9,R30
; 0000 00C1                     }
; 0000 00C2                 }
; 0000 00C3                 break;
_0x1E:
	RJMP _0x1C
; 0000 00C4             }
; 0000 00C5         }
_0x1D:
	SUBI R16,-1
	RJMP _0x1B
_0x1C:
; 0000 00C6 
; 0000 00C7     }
	SUBI R17,-1
	RJMP _0x18
_0x19:
; 0000 00C8 }
	LDD  R17,Y+1
	LDD  R16,Y+0
	ADIW R28,4
	RET
; .FEND
;
;void VerificaInvingatorul(){
; 0000 00CA void VerificaInvingatorul(){
_VerificaInvingatorul:
; .FSTART _VerificaInvingatorul
; 0000 00CB     unsigned char i;
; 0000 00CC     for(i=0;i<3;i++){
	ST   -Y,R17
;	i -> R17
	LDI  R17,LOW(0)
_0x22:
	CPI  R17,3
	BRLO PC+2
	RJMP _0x23
; 0000 00CD         if(((displayJoc[i*3U] == displayJoc[i*3U+1U]) &&( displayJoc[i*3U+1U] == displayJoc[i*3U+2U])) && displayJoc[i*3 ...
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
	BRNE _0x25
	MOVW R30,R22
	__ADDW1MN _displayJoc,1
	LD   R26,Z
	MOVW R30,R22
	__ADDW1MN _displayJoc,2
	LD   R30,Z
	CP   R30,R26
	BREQ _0x26
_0x25:
	RJMP _0x27
_0x26:
	MOVW R30,R22
	SUBI R30,LOW(-_displayJoc)
	SBCI R31,HIGH(-_displayJoc)
	LD   R26,Z
	CPI  R26,LOW(0x2E)
	BRNE _0x28
_0x27:
	RJMP _0x24
_0x28:
; 0000 00CE             castigat = displayJoc[i*3U];
	LDI  R30,LOW(3)
	MUL  R30,R17
	MOVW R30,R0
	SUBI R30,LOW(-_displayJoc)
	SBCI R31,HIGH(-_displayJoc)
	LD   R11,Z
; 0000 00CF         }
; 0000 00D0         if(((displayJoc[i] == displayJoc[i+3U]) &&( displayJoc[i+3U] == displayJoc[i+6U])) && displayJoc[i] != '.'){
_0x24:
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
	BRNE _0x2A
	MOV  R30,R17
	LDI  R31,0
	__ADDW1MN _displayJoc,3
	LD   R26,Z
	MOV  R30,R17
	LDI  R31,0
	__ADDW1MN _displayJoc,6
	LD   R30,Z
	CP   R30,R26
	BREQ _0x2B
_0x2A:
	RJMP _0x2C
_0x2B:
	MOV  R30,R17
	LDI  R31,0
	SUBI R30,LOW(-_displayJoc)
	SBCI R31,HIGH(-_displayJoc)
	LD   R26,Z
	CPI  R26,LOW(0x2E)
	BRNE _0x2D
_0x2C:
	RJMP _0x29
_0x2D:
; 0000 00D1             castigat = displayJoc[i];
	MOV  R30,R17
	LDI  R31,0
	SUBI R30,LOW(-_displayJoc)
	SBCI R31,HIGH(-_displayJoc)
	LD   R11,Z
; 0000 00D2         }
; 0000 00D3     }
_0x29:
	SUBI R17,-1
	RJMP _0x22
_0x23:
; 0000 00D4     if(((displayJoc[0U] == displayJoc[4U]) &&( displayJoc[4U] == displayJoc[8U])) && displayJoc[0U] != '.'){
	__GETB1MN _displayJoc,4
	LDS  R26,_displayJoc
	CP   R30,R26
	BRNE _0x2F
	__GETB2MN _displayJoc,4
	__GETB1MN _displayJoc,8
	CP   R30,R26
	BREQ _0x30
_0x2F:
	RJMP _0x31
_0x30:
	LDS  R26,_displayJoc
	CPI  R26,LOW(0x2E)
	BRNE _0x32
_0x31:
	RJMP _0x2E
_0x32:
; 0000 00D5             castigat = displayJoc[4U];
	__GETBRMN 11,_displayJoc,4
; 0000 00D6     }
; 0000 00D7     if(((displayJoc[6U] == displayJoc[4U]) &&( displayJoc[4U] == displayJoc[2U])) && displayJoc[2U] != '.'){
_0x2E:
	__GETB2MN _displayJoc,6
	__GETB1MN _displayJoc,4
	CP   R30,R26
	BRNE _0x34
	__GETB2MN _displayJoc,4
	__GETB1MN _displayJoc,2
	CP   R30,R26
	BREQ _0x35
_0x34:
	RJMP _0x36
_0x35:
	__GETB2MN _displayJoc,2
	CPI  R26,LOW(0x2E)
	BRNE _0x37
_0x36:
	RJMP _0x33
_0x37:
; 0000 00D8             castigat = displayJoc[4U];
	__GETBRMN 11,_displayJoc,4
; 0000 00D9     }
; 0000 00DA     if(castigat){
_0x33:
	TST  R11
	BREQ _0x38
; 0000 00DB         LED1 = 1;
	SBI  0xB,6
; 0000 00DC         printf("\rSUIIIIIIII a castigat %c\r", castigat);
	__POINTW1FN _0x0,0
	ST   -Y,R31
	ST   -Y,R30
	MOV  R30,R11
	CLR  R31
	CLR  R22
	CLR  R23
	CALL __PUTPARD1
	LDI  R24,4
	CALL _printf
	ADIW R28,6
; 0000 00DD     }
; 0000 00DE     else if(remiza == 0){
	RJMP _0x3B
_0x38:
	TST  R8
	BRNE _0x3C
; 0000 00DF         castigat = 1;
	LDI  R30,LOW(1)
	MOV  R11,R30
; 0000 00E0         printf("Mi se face rau");
	__POINTW1FN _0x0,27
	ST   -Y,R31
	ST   -Y,R30
	LDI  R24,0
	CALL _printf
	ADIW R28,2
; 0000 00E1     }
; 0000 00E2 
; 0000 00E3 
; 0000 00E4 }
_0x3C:
_0x3B:
_0x20A0001:
	LD   R17,Y+
	RET
; .FEND
;
;void PrinteazaJoc(){
; 0000 00E6 void PrinteazaJoc(){
_PrinteazaJoc:
; .FSTART _PrinteazaJoc
; 0000 00E7     unsigned char i = 0, j=0;
; 0000 00E8     for(i=0;i<3;i++){
	ST   -Y,R17
	ST   -Y,R16
;	i -> R17
;	j -> R16
	LDI  R17,0
	LDI  R16,0
	LDI  R17,LOW(0)
_0x3E:
	CPI  R17,3
	BRSH _0x3F
; 0000 00E9         for(j=0;j<3;j++){
	LDI  R16,LOW(0)
_0x41:
	CPI  R16,3
	BRSH _0x42
; 0000 00EA             putchar(displayJoc[i*3U+j]);
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
	RCALL _putchar
; 0000 00EB         }
	SUBI R16,-1
	RJMP _0x41
_0x42:
; 0000 00EC         putchar('\r');
	LDI  R26,LOW(13)
	RCALL _putchar
; 0000 00ED     }
	SUBI R17,-1
	RJMP _0x3E
_0x3F:
; 0000 00EE     putchar('\r');
	LDI  R26,LOW(13)
	RCALL _putchar
; 0000 00EF }
	LD   R16,Y+
	LD   R17,Y+
	RET
; .FEND
;
;void main (void)
; 0000 00F2 {
_main:
; .FSTART _main
; 0000 00F3 unsigned short butoane;
; 0000 00F4 	Init_initController();  // this must be the first "init" action/call!
;	butoane -> R16,R17
	RCALL _Init_initController
; 0000 00F5 	#asm("sei")             // enable interrupts
	sei
; 0000 00F6 	//LED1 = 1;           	// initial state, will be changed by timer 1
; 0000 00F7     //putchar(AdresaNebuna);
; 0000 00F8     DDRC &= (1<<0) | (1<<1);
	IN   R30,0x7
	ANDI R30,LOW(0x3)
	OUT  0x7,R30
; 0000 00F9     PORTC=(1<<0) | (1<<1);
	LDI  R30,LOW(3)
	OUT  0x8,R30
; 0000 00FA     //TWBR = (1<<6) & (1<<3);
; 0000 00FB     //TWCR = (1<<TWIE);
; 0000 00FC     //i2c_init();
; 0000 00FD     /*lcd(0x27,20,4);
; 0000 00FE     init();
; 0000 00FF     // Print a message to the LCD.
; 0000 0100     backlight();
; 0000 0101     setCursor(3,0);
; 0000 0102     //print("Hello, world!");
; 0000 0103     setCursor(2,1);
; 0000 0104     //print("Ywrobot Arduino!");
; 0000 0105     setCursor(0,2);
; 0000 0106     //print("Arduino LCM IIC 2004");
; 0000 0107     setCursor(2,3);
; 0000 0108     //print("Power By Ec-yuan!");*/
; 0000 0109     PrinteazaJoc();
	RCALL _PrinteazaJoc
; 0000 010A 	while(TRUE)
_0x43:
; 0000 010B 	{
; 0000 010C         unsigned char temp;
; 0000 010D         if(rx_counter0)     // if a character is available on serial port USART0
	SBIW R28,1
;	temp -> Y+0
	TST  R5
	BREQ _0x46
; 0000 010E 		{
; 0000 010F 			temp = getchar();
	RCALL _getchar
	ST   Y,R30
; 0000 0110             //command(temp);
; 0000 0111             //putchar(temp);
; 0000 0112 		}
; 0000 0113         butoane = ButoaneUpdate();
_0x46:
	CALL _ButoaneUpdate
	MOVW R16,R30
; 0000 0114         if(butoane && !castigat){
	MOV  R0,R16
	OR   R0,R17
	BREQ _0x48
	TST  R11
	BREQ _0x49
_0x48:
	RJMP _0x47
_0x49:
; 0000 0115             //TrimiteButoane(butoane);
; 0000 0116             //update joc
; 0000 0117             UpdateJoc(butoane);
	MOVW R26,R16
	RCALL _UpdateJoc
; 0000 0118             PrinteazaJoc();
	RCALL _PrinteazaJoc
; 0000 0119             VerificaInvingatorul();
	RCALL _VerificaInvingatorul
; 0000 011A         }
; 0000 011B 
; 0000 011C     }
_0x47:
	ADIW R28,1
	RJMP _0x43
; 0000 011D 
; 0000 011E 
; 0000 011F }// end main loop
_0x4A:
	RJMP _0x4A
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
; 0001 0069 TIMSK1=0x02;
	LDI  R30,LOW(2)
	STS  111,R30
; 0001 006A TIMSK2=0x00;
	LDI  R30,LOW(0)
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
;
;unsigned short ButoaneUpdate(){
; 0002 0006 unsigned short ButoaneUpdate(){

	.CSEG
_ButoaneUpdate:
; .FSTART _ButoaneUpdate
; 0002 0007     static unsigned short StareButoaneInainte = 0x00;
; 0002 0008     volatile unsigned short StareButoane = 0x00, ButoaneApasate = 0x00, i;
; 0002 0009     volatile unsigned char aux;
; 0002 000A 
; 0002 000B     PORTA = (1<<PINA4);// & 0xF0;
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
	CALL SUBOPT_0x2
; 0002 000C     DDRA = 0xFF;
; 0002 000D     delay_us(1);
; 0002 000E     DDRA = (1<<PINA4);
	LDI  R30,LOW(16)
	CALL SUBOPT_0x3
; 0002 000F     for(i=0; i<10;i++){
_0x40004:
	LDD  R26,Y+1
	LDD  R27,Y+1+1
	SBIW R26,10
	BRSH _0x40005
; 0002 0010         aux = PINA;
	IN   R30,0x0
	ST   Y,R30
; 0002 0011     }
	CALL SUBOPT_0x4
	RJMP _0x40004
_0x40005:
; 0002 0012     StareButoane |= (unsigned short)(aux & ((1<<PINA0) | (1<<PINA1) | (1<< PINA2) | (1<<PINA3)));
	LD   R30,Y
	ANDI R30,LOW(0xF)
	LDI  R31,0
	CALL SUBOPT_0x5
; 0002 0013 
; 0002 0014     PORTA = (1<<PINA5);// & 0xF0;
	LDI  R30,LOW(32)
	CALL SUBOPT_0x2
; 0002 0015     DDRA = 0xFF;
; 0002 0016     delay_us(1);
; 0002 0017     DDRA = (1<<PINA5);
	LDI  R30,LOW(32)
	CALL SUBOPT_0x3
; 0002 0018     for(i=0; i<10;i++){
_0x40007:
	LDD  R26,Y+1
	LDD  R27,Y+1+1
	SBIW R26,10
	BRSH _0x40008
; 0002 0019         aux = PINA;
	IN   R30,0x0
	ST   Y,R30
; 0002 001A     }
	CALL SUBOPT_0x4
	RJMP _0x40007
_0x40008:
; 0002 001B     StareButoane |= (unsigned short)(aux & ((1<<PINA0) | (1<<PINA1) | (1<< PINA2) | (1<<PINA3))) << 4;
	LD   R30,Y
	ANDI R30,LOW(0xF)
	LDI  R31,0
	CALL __LSLW4
	CALL SUBOPT_0x5
; 0002 001C 
; 0002 001D     PORTA = (1<<PINA6);// & 0xF0;
	LDI  R30,LOW(64)
	CALL SUBOPT_0x2
; 0002 001E     DDRA = 0xFF;
; 0002 001F     delay_us(1);
; 0002 0020     DDRA = (1<<PINA6);
	LDI  R30,LOW(64)
	CALL SUBOPT_0x3
; 0002 0021     for(i=0; i<10;i++){
_0x4000A:
	LDD  R26,Y+1
	LDD  R27,Y+1+1
	SBIW R26,10
	BRSH _0x4000B
; 0002 0022         aux = PINA;
	IN   R30,0x0
	ST   Y,R30
; 0002 0023     }
	CALL SUBOPT_0x4
	RJMP _0x4000A
_0x4000B:
; 0002 0024     StareButoane |= (unsigned short)(aux & ((1<<PINA0) | (1<<PINA1) | (1<< PINA2) | (1<<PINA3))) << 8;
	LD   R30,Y
	ANDI R30,LOW(0xF)
	MOV  R31,R30
	LDI  R30,0
	CALL SUBOPT_0x5
; 0002 0025 
; 0002 0026     PORTA = (1<<PINA7);// & 0xF0;
	LDI  R30,LOW(128)
	CALL SUBOPT_0x2
; 0002 0027     DDRA = 0xFF;
; 0002 0028     delay_us(1);
; 0002 0029     DDRA = (1<<PINA7);
	LDI  R30,LOW(128)
	CALL SUBOPT_0x3
; 0002 002A     for(i=0; i<10;i++){
_0x4000D:
	LDD  R26,Y+1
	LDD  R27,Y+1+1
	SBIW R26,10
	BRSH _0x4000E
; 0002 002B         aux = PINA;
	IN   R30,0x0
	ST   Y,R30
; 0002 002C     }
	CALL SUBOPT_0x4
	RJMP _0x4000D
_0x4000E:
; 0002 002D     PORTA = 0;
	LDI  R30,LOW(0)
	OUT  0x2,R30
; 0002 002E     StareButoane |= (unsigned short)(aux & ((1<<PINA0) | (1<<PINA1) | (1<< PINA2) | (1<<PINA3))) << 12;
	LD   R30,Y
	ANDI R30,LOW(0xF)
	LDI  R31,0
	CALL __LSLW4
	MOV  R31,R30
	LDI  R30,0
	CALL SUBOPT_0x5
; 0002 002F 
; 0002 0030     for(i=0;i<16;i++){
	LDI  R30,LOW(0)
	STD  Y+1,R30
	STD  Y+1+1,R30
_0x40010:
	LDD  R26,Y+1
	LDD  R27,Y+1+1
	SBIW R26,16
	BRSH _0x40011
; 0002 0031         if(((StareButoaneInainte & ((unsigned short)1<<i)) == 0) && ((StareButoane & ((unsigned short)1<<i)) != 0)){
	LDD  R30,Y+1
	CALL SUBOPT_0x0
	LDS  R26,_StareButoaneInainte_S0020000000
	LDS  R27,_StareButoaneInainte_S0020000000+1
	AND  R30,R26
	AND  R31,R27
	SBIW R30,0
	BRNE _0x40013
	LDD  R30,Y+1
	CALL SUBOPT_0x0
	LDD  R26,Y+5
	LDD  R27,Y+5+1
	AND  R30,R26
	AND  R31,R27
	SBIW R30,0
	BRNE _0x40014
_0x40013:
	RJMP _0x40012
_0x40014:
; 0002 0032             ButoaneApasate |= ((unsigned short)1<<i);
	LDD  R30,Y+1
	CALL SUBOPT_0x0
	LDD  R26,Y+3
	LDD  R27,Y+3+1
	OR   R30,R26
	OR   R31,R27
	STD  Y+3,R30
	STD  Y+3+1,R31
; 0002 0033         }
; 0002 0034     }
_0x40012:
	CALL SUBOPT_0x4
	RJMP _0x40010
_0x40011:
; 0002 0035     StareButoaneInainte = StareButoane;
	LDD  R30,Y+5
	LDD  R31,Y+5+1
	STS  _StareButoaneInainte_S0020000000,R30
	STS  _StareButoaneInainte_S0020000000+1,R31
; 0002 0036     return ButoaneApasate;
	LDD  R30,Y+3
	LDD  R31,Y+3+1
	ADIW R28,7
	RET
; 0002 0037 }
; .FEND
;
;void TrimiteButoane(unsigned short Butoane){
; 0002 0039 void TrimiteButoane(unsigned short Butoane){
; 0002 003A     unsigned char i, Printez = 0;
; 0002 003B     for(i = 0; i < 16; i++){
;	Butoane -> Y+2
;	i -> R17
;	Printez -> R16
; 0002 003C         if(Butoane % 2 == 1){
; 0002 003D             putchar(i + 'a');
; 0002 003E             Printez = 1;
; 0002 003F         }
; 0002 0040         Butoane /= 2;
; 0002 0041     }
; 0002 0042     if(Printez){
; 0002 0043         putchar('\r');
; 0002 0044     }
; 0002 0045 
; 0002 0046 }
;#include "ecran.h"
;#include <stdio.h>
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
;#include <i2c.h>
;
;  uint8_t _Addr;
;  uint8_t _displayfunction;
;  uint8_t _displaycontrol;
;  uint8_t _displaymode;
;  uint8_t _numlines;
;  uint8_t _cols;
;  uint8_t _rows;
;  uint8_t _backlightval;
;
;  // Based on the work by DFRobot
;
;#define printIIC(args)    i2c_write(args)//Wire.send(args)
;void write(uint8_t value) {
; 0003 0012 void write(uint8_t value) {

	.CSEG
; 0003 0013     send(value, Rs);
;	value -> Y+0
; 0003 0014 }
;
;
;// When the display powers up, it is configured as follows:
;//
;// 1. Display clear
;// 2. Function set:
;//    DL = 1; 8-bit interface data
;//    N = 0; 1-line display
;//    F = 0; 5x8 dot character font
;// 3. Display on/off control:
;//    D = 0; Display off
;//    C = 0; Cursor off
;//    B = 0; Blinking off
;// 4. Entry mode set:
;//    I/D = 1; Increment by 1
;//    S = 0; No shift
;//
;// Note, however, that resetting the Arduino doesn't reset the LCD, so we
;// can't assume that its in that state when a sketch starts (and the
;// LiquidCrystal constructor is called).
;
;void lcd(uint8_t lcd_Addr,uint8_t lcd_cols,uint8_t lcd_rows)
; 0003 002B {
; 0003 002C   _Addr = lcd_Addr;
;	lcd_Addr -> Y+2
;	lcd_cols -> Y+1
;	lcd_rows -> Y+0
; 0003 002D   _cols = lcd_cols;
; 0003 002E   _rows = lcd_rows;
; 0003 002F   _backlightval = LCD_NOBACKLIGHT;
; 0003 0030 }
;
;void init(){
; 0003 0032 void init(){
; 0003 0033     init_priv();
; 0003 0034 }
;
;void init_priv()
; 0003 0037 {
; 0003 0038     //Wire.begin();
; 0003 0039     i2c_init();
; 0003 003A     _displayfunction = LCD_4BITMODE | LCD_1LINE | LCD_5x8DOTS;
; 0003 003B     begin(_cols, _rows, LCD_5x8DOTS);
; 0003 003C }
;
;void begin(uint8_t cols, uint8_t lines, uint8_t dotsize) {
; 0003 003E void begin(uint8_t cols, uint8_t lines, uint8_t dotsize) {
; 0003 003F     if (lines > 1) {
;	cols -> Y+2
;	lines -> Y+1
;	dotsize -> Y+0
; 0003 0040         _displayfunction |= LCD_2LINE;
; 0003 0041     }
; 0003 0042     _numlines = lines;
; 0003 0043 
; 0003 0044     // for some 1 line displays you can select a 10 pixel high font
; 0003 0045     if ((dotsize != 0) && (lines == 1)) {
; 0003 0046         _displayfunction |= LCD_5x10DOTS;
; 0003 0047     }
; 0003 0048 
; 0003 0049     // SEE PAGE 45/46 FOR INITIALIZATION SPECIFICATION!
; 0003 004A     // according to datasheet, we need at least 40ms after power rises above 2.7V
; 0003 004B     // before sending commands. Arduino can turn on way befer 4.5V so we'll wait 50
; 0003 004C     delay_ms(50);
; 0003 004D 
; 0003 004E     // Now we pull both RS and R/W low to begin commands
; 0003 004F     expanderWrite(_backlightval);    // reset expanderand turn backlight off (Bit 8 =1)
; 0003 0050     delay_ms(1000);
; 0003 0051 
; 0003 0052       //put the LCD into 4 bit mode
; 0003 0053     // this is according to the hitachi HD44780 datasheet
; 0003 0054     // figure 24, pg 46
; 0003 0055 
; 0003 0056       // we start in 8bit mode, try to set 4 bit mode
; 0003 0057    write4bits(0x03 << 4);
; 0003 0058    delay_us(4500); // wait min 4.1ms
; 0003 0059 
; 0003 005A    // second try
; 0003 005B    write4bits(0x03 << 4);
; 0003 005C    delay_us(4500); // wait min 4.1ms
; 0003 005D 
; 0003 005E    // third go!
; 0003 005F    write4bits(0x03 << 4);
; 0003 0060    delay_us(150);
; 0003 0061 
; 0003 0062    // finally, set to 4-bit interface
; 0003 0063    write4bits(0x02 << 4);
; 0003 0064 
; 0003 0065 
; 0003 0066     // set # lines, font size, etc.
; 0003 0067     command(LCD_FUNCTIONSET | _displayfunction);
; 0003 0068 
; 0003 0069     // turn the display on with no cursor or blinking default
; 0003 006A     _displaycontrol = LCD_DISPLAYON | LCD_CURSOROFF | LCD_BLINKOFF;
; 0003 006B     display();
; 0003 006C 
; 0003 006D     // clear it off
; 0003 006E     clear();
; 0003 006F 
; 0003 0070     // Initialize to default text direction (for roman languages)
; 0003 0071     _displaymode = LCD_ENTRYLEFT | LCD_ENTRYSHIFTDECREMENT;
; 0003 0072 
; 0003 0073     // set the entry mode
; 0003 0074     command(LCD_ENTRYMODESET | _displaymode);
; 0003 0075 
; 0003 0076     home();
; 0003 0077 
; 0003 0078 }
;
;/********** high level commands, for the user! */
;void clear(){
; 0003 007B void clear(){
; 0003 007C     command(LCD_CLEARDISPLAY);// clear display, set cursor position to zero
; 0003 007D     delay_us(2000);  // this command takes a long time!
; 0003 007E }
;
;void home(){
; 0003 0080 void home(){
; 0003 0081     command(LCD_RETURNHOME);  // set cursor position to zero
; 0003 0082     delay_us(2000);  // this command takes a long time!
; 0003 0083 }
;
;void setCursor(uint8_t col, uint8_t row){
; 0003 0085 void setCursor(uint8_t col, uint8_t row){
; 0003 0086     int row_offsets[] = { 0x00, 0x40, 0x14, 0x54 };
; 0003 0087     if ( row > _numlines ) {
;	col -> Y+9
;	row -> Y+8
;	row_offsets -> Y+0
; 0003 0088         row = _numlines-1;    // we count rows starting w/0
; 0003 0089     }
; 0003 008A     command(LCD_SETDDRAMADDR | (col + row_offsets[row]));
; 0003 008B }
;
;// Turn the display on/off (quickly)
;void noDisplay() {
; 0003 008E void noDisplay() {
; 0003 008F     _displaycontrol &= ~LCD_DISPLAYON;
; 0003 0090     command(LCD_DISPLAYCONTROL | _displaycontrol);
; 0003 0091 }
;void display() {
; 0003 0092 void display() {
; 0003 0093     _displaycontrol |= LCD_DISPLAYON;
; 0003 0094     command(LCD_DISPLAYCONTROL | _displaycontrol);
; 0003 0095 }
;
;// Turns the underline cursor on/off
;void noCursor() {
; 0003 0098 void noCursor() {
; 0003 0099     _displaycontrol &= ~LCD_CURSORON;
; 0003 009A     command(LCD_DISPLAYCONTROL | _displaycontrol);
; 0003 009B }
;void cursor() {
; 0003 009C void cursor() {
; 0003 009D     _displaycontrol |= LCD_CURSORON;
; 0003 009E     command(LCD_DISPLAYCONTROL | _displaycontrol);
; 0003 009F }
;
;// Turn on and off the blinking cursor
;void noBlink() {
; 0003 00A2 void noBlink() {
; 0003 00A3     _displaycontrol &= ~LCD_BLINKON;
; 0003 00A4     command(LCD_DISPLAYCONTROL | _displaycontrol);
; 0003 00A5 }
;void blink() {
; 0003 00A6 void blink() {
; 0003 00A7     _displaycontrol |= LCD_BLINKON;
; 0003 00A8     command(LCD_DISPLAYCONTROL | _displaycontrol);
; 0003 00A9 }
;
;// These commands scroll the display without changing the RAM
;void scrollDisplayLeft(void) {
; 0003 00AC void scrollDisplayLeft(void) {
; 0003 00AD     command(LCD_CURSORSHIFT | LCD_DISPLAYMOVE | LCD_MOVELEFT);
; 0003 00AE }
;void scrollDisplayRight(void) {
; 0003 00AF void scrollDisplayRight(void) {
; 0003 00B0     command(LCD_CURSORSHIFT | LCD_DISPLAYMOVE | LCD_MOVERIGHT);
; 0003 00B1 }
;
;// This is for text that flows Left to Right
;void leftToRight(void) {
; 0003 00B4 void leftToRight(void) {
; 0003 00B5     _displaymode |= LCD_ENTRYLEFT;
; 0003 00B6     command(LCD_ENTRYMODESET | _displaymode);
; 0003 00B7 }
;
;// This is for text that flows Right to Left
;void rightToLeft(void) {
; 0003 00BA void rightToLeft(void) {
; 0003 00BB     _displaymode &= ~LCD_ENTRYLEFT;
; 0003 00BC     command(LCD_ENTRYMODESET | _displaymode);
; 0003 00BD }
;
;// This will 'right justify' text from the cursor
;void autoscroll(void) {
; 0003 00C0 void autoscroll(void) {
; 0003 00C1     _displaymode |= LCD_ENTRYSHIFTINCREMENT;
; 0003 00C2     command(LCD_ENTRYMODESET | _displaymode);
; 0003 00C3 }
;
;// This will 'left justify' text from the cursor
;void noAutoscroll(void) {
; 0003 00C6 void noAutoscroll(void) {
; 0003 00C7     _displaymode &= ~LCD_ENTRYSHIFTINCREMENT;
; 0003 00C8     command(LCD_ENTRYMODESET | _displaymode);
; 0003 00C9 }
;
;// Allows us to fill the first 8 CGRAM locations
;// with custom characters
;void createChar(uint8_t location, uint8_t charmap[]) {
; 0003 00CD void createChar(uint8_t location, uint8_t charmap[]) {
; 0003 00CE     int i;
; 0003 00CF     location &= 0x7; // we only have 8 locations 0-7
;	location -> Y+4
;	charmap -> Y+2
;	i -> R16,R17
; 0003 00D0     command(LCD_SETCGRAMADDR | (location << 3));
; 0003 00D1     for (i=0; i<8; i++) {
; 0003 00D2         write(charmap[i]);
; 0003 00D3     }
; 0003 00D4 }
;
;// Turn the (optional) backlight off/on
;void noBacklight(void) {
; 0003 00D7 void noBacklight(void) {
; 0003 00D8     _backlightval=LCD_NOBACKLIGHT;
; 0003 00D9     expanderWrite(0);
; 0003 00DA }
;
;void backlight(void) {
; 0003 00DC void backlight(void) {
; 0003 00DD     _backlightval=LCD_BACKLIGHT;
; 0003 00DE     expanderWrite(0);
; 0003 00DF }
;
;
;
;/*********** mid level commands, for sending data/cmds */
;void command(uint8_t value) {
; 0003 00E4 void command(uint8_t value) {
; 0003 00E5     send(value, 0);
;	value -> Y+0
; 0003 00E6 }
;
;
;/************ low level data pushing commands **********/
;
;// write either command or data
;void send(uint8_t value, uint8_t mode) {
; 0003 00EC void send(uint8_t value, uint8_t mode) {
; 0003 00ED     uint8_t highnib=value&0xf0;
; 0003 00EE     uint8_t lownib=(value<<4)&0xf0;
; 0003 00EF        write4bits((highnib)|mode);
;	value -> Y+3
;	mode -> Y+2
;	highnib -> R17
;	lownib -> R16
; 0003 00F0     write4bits((lownib)|mode);
; 0003 00F1 }
;
;void write4bits(uint8_t value) {
; 0003 00F3 void write4bits(uint8_t value) {
; 0003 00F4     expanderWrite(value);
;	value -> Y+0
; 0003 00F5     pulseEnable(value);
; 0003 00F6 }
;
;void expanderWrite(uint8_t _data){
; 0003 00F8 void expanderWrite(uint8_t _data){
; 0003 00F9     //Wire.beginTransmission(_Addr);
; 0003 00FA     i2c_start();
;	_data -> Y+0
; 0003 00FB     i2c_write(_Addr);
; 0003 00FC     printIIC((int)(_data) | _backlightval);
; 0003 00FD     //Wire.endTransmission();
; 0003 00FE     i2c_stop();
; 0003 00FF }
;
;void pulseEnable(uint8_t _data){
; 0003 0101 void pulseEnable(uint8_t _data){
; 0003 0102     expanderWrite(_data | En);    // En high
;	_data -> Y+0
; 0003 0103     delay_us(1);        // enable pulse must be >450ns
; 0003 0104 
; 0003 0105     expanderWrite(_data & ~En);    // En low
; 0003 0106     delay_us(50);        // commands need > 37us to settle
; 0003 0107 }
;
;
;// Alias functions
;
;void cursor_on(){
; 0003 010C void cursor_on(){
; 0003 010D     cursor();
; 0003 010E }
;
;void cursor_off(){
; 0003 0110 void cursor_off(){
; 0003 0111     noCursor();
; 0003 0112 }
;
;void blink_on(){
; 0003 0114 void blink_on(){
; 0003 0115     blink();
; 0003 0116 }
;
;void blink_off(){
; 0003 0118 void blink_off(){
; 0003 0119     noBlink();
; 0003 011A }
;
;void load_custom_character(uint8_t char_num, uint8_t *rows){
; 0003 011C void load_custom_character(uint8_t char_num, uint8_t *rows){
; 0003 011D         createChar(char_num, rows);
;	char_num -> Y+2
;	*rows -> Y+0
; 0003 011E }
;
;void setBacklight(uint8_t new_val){
; 0003 0120 void setBacklight(uint8_t new_val){
; 0003 0121     if(new_val){
;	new_val -> Y+0
; 0003 0122         backlight();        // turn backlight on
; 0003 0123     }else{
; 0003 0124         noBacklight();        // turn backlight off
; 0003 0125     }
; 0003 0126 }
;
;/*void printstr(const char c[]){
;    //This function is not identical to the function used for "real" I2C displays
;    //it's here so the user sketch doesn't have to be changed
;    //print(c);
;} */
;
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
_put_usart_G100:
; .FSTART _put_usart_G100
	ST   -Y,R27
	ST   -Y,R26
	LDD  R26,Y+2
	CALL _putchar
	LD   R26,Y
	LDD  R27,Y+1
	LD   R30,X+
	LD   R31,X+
	ADIW R30,1
	ST   -X,R31
	ST   -X,R30
	ADIW R28,3
	RET
; .FEND
__print_G100:
; .FSTART __print_G100
	ST   -Y,R27
	ST   -Y,R26
	SBIW R28,6
	CALL __SAVELOCR6
	LDI  R17,0
	LDD  R26,Y+12
	LDD  R27,Y+12+1
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	ST   X+,R30
	ST   X,R31
_0x2000016:
	LDD  R30,Y+18
	LDD  R31,Y+18+1
	ADIW R30,1
	STD  Y+18,R30
	STD  Y+18+1,R31
	SBIW R30,1
	LPM  R30,Z
	MOV  R18,R30
	CPI  R30,0
	BRNE PC+2
	RJMP _0x2000018
	MOV  R30,R17
	CPI  R30,0
	BRNE _0x200001C
	CPI  R18,37
	BRNE _0x200001D
	LDI  R17,LOW(1)
	RJMP _0x200001E
_0x200001D:
	CALL SUBOPT_0x6
_0x200001E:
	RJMP _0x200001B
_0x200001C:
	CPI  R30,LOW(0x1)
	BRNE _0x200001F
	CPI  R18,37
	BRNE _0x2000020
	CALL SUBOPT_0x6
	RJMP _0x20000CC
_0x2000020:
	LDI  R17,LOW(2)
	LDI  R20,LOW(0)
	LDI  R16,LOW(0)
	CPI  R18,45
	BRNE _0x2000021
	LDI  R16,LOW(1)
	RJMP _0x200001B
_0x2000021:
	CPI  R18,43
	BRNE _0x2000022
	LDI  R20,LOW(43)
	RJMP _0x200001B
_0x2000022:
	CPI  R18,32
	BRNE _0x2000023
	LDI  R20,LOW(32)
	RJMP _0x200001B
_0x2000023:
	RJMP _0x2000024
_0x200001F:
	CPI  R30,LOW(0x2)
	BRNE _0x2000025
_0x2000024:
	LDI  R21,LOW(0)
	LDI  R17,LOW(3)
	CPI  R18,48
	BRNE _0x2000026
	ORI  R16,LOW(128)
	RJMP _0x200001B
_0x2000026:
	RJMP _0x2000027
_0x2000025:
	CPI  R30,LOW(0x3)
	BREQ PC+2
	RJMP _0x200001B
_0x2000027:
	CPI  R18,48
	BRLO _0x200002A
	CPI  R18,58
	BRLO _0x200002B
_0x200002A:
	RJMP _0x2000029
_0x200002B:
	LDI  R26,LOW(10)
	MUL  R21,R26
	MOV  R21,R0
	MOV  R30,R18
	SUBI R30,LOW(48)
	ADD  R21,R30
	RJMP _0x200001B
_0x2000029:
	MOV  R30,R18
	CPI  R30,LOW(0x63)
	BRNE _0x200002F
	CALL SUBOPT_0x7
	LDD  R30,Y+16
	LDD  R31,Y+16+1
	LDD  R26,Z+4
	ST   -Y,R26
	CALL SUBOPT_0x8
	RJMP _0x2000030
_0x200002F:
	CPI  R30,LOW(0x73)
	BRNE _0x2000032
	CALL SUBOPT_0x7
	CALL SUBOPT_0x9
	CALL _strlen
	MOV  R17,R30
	RJMP _0x2000033
_0x2000032:
	CPI  R30,LOW(0x70)
	BRNE _0x2000035
	CALL SUBOPT_0x7
	CALL SUBOPT_0x9
	CALL _strlenf
	MOV  R17,R30
	ORI  R16,LOW(8)
_0x2000033:
	ORI  R16,LOW(2)
	ANDI R16,LOW(127)
	LDI  R19,LOW(0)
	RJMP _0x2000036
_0x2000035:
	CPI  R30,LOW(0x64)
	BREQ _0x2000039
	CPI  R30,LOW(0x69)
	BRNE _0x200003A
_0x2000039:
	ORI  R16,LOW(4)
	RJMP _0x200003B
_0x200003A:
	CPI  R30,LOW(0x75)
	BRNE _0x200003C
_0x200003B:
	LDI  R30,LOW(_tbl10_G100*2)
	LDI  R31,HIGH(_tbl10_G100*2)
	STD  Y+6,R30
	STD  Y+6+1,R31
	LDI  R17,LOW(5)
	RJMP _0x200003D
_0x200003C:
	CPI  R30,LOW(0x58)
	BRNE _0x200003F
	ORI  R16,LOW(8)
	RJMP _0x2000040
_0x200003F:
	CPI  R30,LOW(0x78)
	BREQ PC+2
	RJMP _0x2000071
_0x2000040:
	LDI  R30,LOW(_tbl16_G100*2)
	LDI  R31,HIGH(_tbl16_G100*2)
	STD  Y+6,R30
	STD  Y+6+1,R31
	LDI  R17,LOW(4)
_0x200003D:
	SBRS R16,2
	RJMP _0x2000042
	CALL SUBOPT_0x7
	CALL SUBOPT_0xA
	LDD  R26,Y+11
	TST  R26
	BRPL _0x2000043
	LDD  R30,Y+10
	LDD  R31,Y+10+1
	CALL __ANEGW1
	STD  Y+10,R30
	STD  Y+10+1,R31
	LDI  R20,LOW(45)
_0x2000043:
	CPI  R20,0
	BREQ _0x2000044
	SUBI R17,-LOW(1)
	RJMP _0x2000045
_0x2000044:
	ANDI R16,LOW(251)
_0x2000045:
	RJMP _0x2000046
_0x2000042:
	CALL SUBOPT_0x7
	CALL SUBOPT_0xA
_0x2000046:
_0x2000036:
	SBRC R16,0
	RJMP _0x2000047
_0x2000048:
	CP   R17,R21
	BRSH _0x200004A
	SBRS R16,7
	RJMP _0x200004B
	SBRS R16,2
	RJMP _0x200004C
	ANDI R16,LOW(251)
	MOV  R18,R20
	SUBI R17,LOW(1)
	RJMP _0x200004D
_0x200004C:
	LDI  R18,LOW(48)
_0x200004D:
	RJMP _0x200004E
_0x200004B:
	LDI  R18,LOW(32)
_0x200004E:
	CALL SUBOPT_0x6
	SUBI R21,LOW(1)
	RJMP _0x2000048
_0x200004A:
_0x2000047:
	MOV  R19,R17
	SBRS R16,1
	RJMP _0x200004F
_0x2000050:
	CPI  R19,0
	BREQ _0x2000052
	SBRS R16,3
	RJMP _0x2000053
	LDD  R30,Y+6
	LDD  R31,Y+6+1
	LPM  R18,Z+
	STD  Y+6,R30
	STD  Y+6+1,R31
	RJMP _0x2000054
_0x2000053:
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	LD   R18,X+
	STD  Y+6,R26
	STD  Y+6+1,R27
_0x2000054:
	CALL SUBOPT_0x6
	CPI  R21,0
	BREQ _0x2000055
	SUBI R21,LOW(1)
_0x2000055:
	SUBI R19,LOW(1)
	RJMP _0x2000050
_0x2000052:
	RJMP _0x2000056
_0x200004F:
_0x2000058:
	LDI  R18,LOW(48)
	LDD  R30,Y+6
	LDD  R31,Y+6+1
	CALL __GETW1PF
	STD  Y+8,R30
	STD  Y+8+1,R31
	LDD  R30,Y+6
	LDD  R31,Y+6+1
	ADIW R30,2
	STD  Y+6,R30
	STD  Y+6+1,R31
_0x200005A:
	LDD  R30,Y+8
	LDD  R31,Y+8+1
	LDD  R26,Y+10
	LDD  R27,Y+10+1
	CP   R26,R30
	CPC  R27,R31
	BRLO _0x200005C
	SUBI R18,-LOW(1)
	LDD  R26,Y+8
	LDD  R27,Y+8+1
	LDD  R30,Y+10
	LDD  R31,Y+10+1
	SUB  R30,R26
	SBC  R31,R27
	STD  Y+10,R30
	STD  Y+10+1,R31
	RJMP _0x200005A
_0x200005C:
	CPI  R18,58
	BRLO _0x200005D
	SBRS R16,3
	RJMP _0x200005E
	SUBI R18,-LOW(7)
	RJMP _0x200005F
_0x200005E:
	SUBI R18,-LOW(39)
_0x200005F:
_0x200005D:
	SBRC R16,4
	RJMP _0x2000061
	CPI  R18,49
	BRSH _0x2000063
	LDD  R26,Y+8
	LDD  R27,Y+8+1
	SBIW R26,1
	BRNE _0x2000062
_0x2000063:
	RJMP _0x20000CD
_0x2000062:
	CP   R21,R19
	BRLO _0x2000067
	SBRS R16,0
	RJMP _0x2000068
_0x2000067:
	RJMP _0x2000066
_0x2000068:
	LDI  R18,LOW(32)
	SBRS R16,7
	RJMP _0x2000069
	LDI  R18,LOW(48)
_0x20000CD:
	ORI  R16,LOW(16)
	SBRS R16,2
	RJMP _0x200006A
	ANDI R16,LOW(251)
	ST   -Y,R20
	CALL SUBOPT_0x8
	CPI  R21,0
	BREQ _0x200006B
	SUBI R21,LOW(1)
_0x200006B:
_0x200006A:
_0x2000069:
_0x2000061:
	CALL SUBOPT_0x6
	CPI  R21,0
	BREQ _0x200006C
	SUBI R21,LOW(1)
_0x200006C:
_0x2000066:
	SUBI R19,LOW(1)
	LDD  R26,Y+8
	LDD  R27,Y+8+1
	SBIW R26,2
	BRLO _0x2000059
	RJMP _0x2000058
_0x2000059:
_0x2000056:
	SBRS R16,0
	RJMP _0x200006D
_0x200006E:
	CPI  R21,0
	BREQ _0x2000070
	SUBI R21,LOW(1)
	LDI  R30,LOW(32)
	ST   -Y,R30
	CALL SUBOPT_0x8
	RJMP _0x200006E
_0x2000070:
_0x200006D:
_0x2000071:
_0x2000030:
_0x20000CC:
	LDI  R17,LOW(0)
_0x200001B:
	RJMP _0x2000016
_0x2000018:
	LDD  R26,Y+12
	LDD  R27,Y+12+1
	CALL __GETW1P
	CALL __LOADLOCR6
	ADIW R28,20
	RET
; .FEND
_printf:
; .FSTART _printf
	PUSH R15
	MOV  R15,R24
	SBIW R28,6
	ST   -Y,R17
	ST   -Y,R16
	MOVW R26,R28
	ADIW R26,4
	CALL __ADDW2R15
	MOVW R16,R26
	LDI  R30,LOW(0)
	STD  Y+4,R30
	STD  Y+4+1,R30
	STD  Y+6,R30
	STD  Y+6+1,R30
	MOVW R26,R28
	ADIW R26,8
	CALL __ADDW2R15
	CALL __GETW1P
	ST   -Y,R31
	ST   -Y,R30
	ST   -Y,R17
	ST   -Y,R16
	LDI  R30,LOW(_put_usart_G100)
	LDI  R31,HIGH(_put_usart_G100)
	ST   -Y,R31
	ST   -Y,R30
	MOVW R26,R28
	ADIW R26,8
	RCALL __print_G100
	LDD  R17,Y+1
	LDD  R16,Y+0
	ADIW R28,8
	POP  R15
	RET
; .FEND

	.CSEG
_strlen:
; .FSTART _strlen
	ST   -Y,R27
	ST   -Y,R26
    ld   r26,y+
    ld   r27,y+
    clr  r30
    clr  r31
strlen0:
    ld   r22,x+
    tst  r22
    breq strlen1
    adiw r30,1
    rjmp strlen0
strlen1:
    ret
; .FEND
_strlenf:
; .FSTART _strlenf
	ST   -Y,R27
	ST   -Y,R26
    clr  r26
    clr  r27
    ld   r30,y+
    ld   r31,y+
strlenf0:
	lpm  r0,z+
    tst  r0
    breq strlenf1
    adiw r26,1
    rjmp strlenf0
strlenf1:
    movw r30,r26
    ret
; .FEND

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
_displayJoc:
	.BYTE 0x9
_StareButoaneInainte_S0020000000:
	.BYTE 0x2
__displaymode:
	.BYTE 0x1
__numlines:
	.BYTE 0x1
__cols:
	.BYTE 0x1
__rows:
	.BYTE 0x1
__backlightval:
	.BYTE 0x1
__seed_G102:
	.BYTE 0x4

	.CSEG
;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x0:
	LDI  R26,LOW(1)
	LDI  R27,HIGH(1)
	CALL __LSLW12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:10 WORDS
SUBOPT_0x1:
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
	SUBI R30,LOW(-_displayJoc)
	SBCI R31,HIGH(-_displayJoc)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x2:
	OUT  0x2,R30
	LDI  R30,LOW(255)
	OUT  0x1,R30
	__DELAY_USB 7
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x3:
	OUT  0x1,R30
	LDI  R30,LOW(0)
	STD  Y+1,R30
	STD  Y+1+1,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x4:
	LDD  R30,Y+1
	LDD  R31,Y+1+1
	ADIW R30,1
	STD  Y+1,R30
	STD  Y+1+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x5:
	LDD  R26,Y+5
	LDD  R27,Y+5+1
	OR   R30,R26
	OR   R31,R27
	STD  Y+5,R30
	STD  Y+5+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:13 WORDS
SUBOPT_0x6:
	ST   -Y,R18
	LDD  R26,Y+13
	LDD  R27,Y+13+1
	LDD  R30,Y+15
	LDD  R31,Y+15+1
	ICALL
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x7:
	LDD  R30,Y+16
	LDD  R31,Y+16+1
	SBIW R30,4
	STD  Y+16,R30
	STD  Y+16+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x8:
	LDD  R26,Y+13
	LDD  R27,Y+13+1
	LDD  R30,Y+15
	LDD  R31,Y+15+1
	ICALL
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x9:
	LDD  R26,Y+16
	LDD  R27,Y+16+1
	ADIW R26,4
	CALL __GETW1P
	STD  Y+6,R30
	STD  Y+6+1,R31
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0xA:
	LDD  R26,Y+16
	LDD  R27,Y+16+1
	ADIW R26,4
	CALL __GETW1P
	STD  Y+10,R30
	STD  Y+10+1,R31
	RET


	.CSEG
__ADDW2R15:
	CLR  R0
	ADD  R26,R15
	ADC  R27,R0
	RET

__ANEGW1:
	NEG  R31
	NEG  R30
	SBCI R31,0
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

__GETW1P:
	LD   R30,X+
	LD   R31,X
	SBIW R26,1
	RET

__GETW1PF:
	LPM  R0,Z+
	LPM  R31,Z
	MOV  R30,R0
	RET

__PUTPARD1:
	ST   -Y,R23
	ST   -Y,R22
	ST   -Y,R31
	ST   -Y,R30
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

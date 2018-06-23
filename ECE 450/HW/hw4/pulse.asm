*  filename:  pulse.asm

	ORG	MAIN_START

variable_irRange:
	FDB	0

subroutine_pulse:

* disable interrupts
	SEI

* equates
IN	EQU	$1000
OUT	EQU	$1000
LOMASK	EQU	%11011111
HIMASK	EQU	%00100000

* shut off TOC3
* clear TCTL1
	LDAA	$1020
	ANDA	#%11001111
	STAA	$1020

* clear TMSK1
	LDAA	$1022
	ANDA	#%11011111
	STAA	$1022

* clear OC1M
	LDAA	$100C
	ANDA	#%01000000
	STAA	$100C

* take the input low for 50 ms (note: this delay 
* is now in the C routine)

*	LDAA	OUT
*	ANDA	#LOMASK
*	STAA	OUT
*	LDX	#16666
*	DELAY1	DEX
*	BNE	DELAY1

*go out and get range byte
	LDD	#0
	STD	variable_irRange
	LDY	#8
REPEAT	LDD	variable_irRange
	ASLD
	STD	variable_irRange
	LDAA	OUT
	ORA	#HIMASK
	STAA	OUT
	BSR	DELAY
	LDAA	OUT
	ANDA	#LOMASK
	STAA	OUT
	BSR	DELAY
	CLRB
	LDAA	IN
	LSRA
	ROLB
	BEQ	GOMOR
	LDD	variable_irRange
	ADDD	#1
	STD	variable_irRange
GOMOR	DEY
	BNE	REPEAT

*finish by taking output high for 2ms, then low
	LDAA	OUT
	ORA	#HIMASK
	STAA	OUT
	LDX	#666
DELAYX	DEX
	BNE	DELAYX
	LDAA	OUT
	ANDA	#LOMASK
	STAA	OUT

*finish by reenabling interrupts
	LDD	variable_irRange
	CLI
	RTS

*delay routine
DELAY	LDX	#30
LOOPX	DEX
	BNE	LOOPX
	RTS


//constant and defines
P1IN  EQU 0x0020 // port1
P1OUT EQU 0x0021
P1DIR EQU 0x0022
P1IFG EQU 0x0023
P1IES EQU 0x0024
P1IE  EQU 0x0025
P2IN  EQU 0x0028 // port2
P2OUT EQU 0x0029  
P2DIR EQU 0x002A 
P2IFG EQU 0x002B
P2IES EQU 0x002C
P2IE  EQU 0x002D
P3IN  EQU 0x0018 // port2
P3OUT EQU 0x0019  
P3DIR EQU 0x001A 
P3SEL EQU 0x001B
P6OUT EQU 0x0035 // port6 
P6DIR EQU 0x0036 
P5OUT EQU 0x0031 //
P5DIR EQU 0x0032 

TACTL   EQU 0X0160
TACCR0  EQU 0X0172
TACCR1  EQU 0X0174
TACCTL1 EQU 0x0164

TBR     EQU 0x0190
TBCTL   EQU 0X0180
TBCCR0  EQU 0X0192
TBCCTL0 EQU 0x0182
TBCCR1  EQU 0X0194
TBCCTL1 EQU 0x0184
TBCCR4  EQU 0X019A
TBCCTL4 EQU 0x018A

PORT1_VECTOR  EQU (20 * 2u) 
RESET_VECTOR  EQU (31 * 2u)
TIMERB0_VECTOR  EQU (29 * 2U) // 0xFFFA Timer B CC0
CNTL_3          EQU (3 * 0x0800u) // counter length: 8 bit
OUTMOD_3        EQU (3 * 0x20u) // PWM output mode: 3 - PWM set/reset
TBSSEL_1        EQU (1 * 0x0100u) // clk source: ACLK
MC_1            EQU (1 * 0x10u) // Timer A mode control: 1 - up to CCR0
TBCLR           EQU (0x0004)
ID_0            EQU (0 * 0x40u) // Timer A input divider: 0 - /1
CCIE            EQU (0x0010) // Timer Enable Interrupt


BIT0  EQU 0x01
BIT1  EQU 0x02
BIT2  EQU 0x04
BIT3  EQU 0x08
BIT4  EQU 0x10
BIT5  EQU 0x20
BIT6  EQU 0x40
BIT7  EQU 0x80

// 7 segments
SEGA     EQU BIT0
SEGB     EQU BIT1
SEGC     EQU BIT2
SEGD     EQU BIT3
SEGE     EQU BIT4
SEGF     EQU BIT5
SEGG     EQU BIT6
// numbers from 0-15
//-AA-
//F  B
//-GG-
//E  C
//-DD-
NUM0     EQU SEGA|SEGB|SEGC|SEGD|SEGE|SEGF//SEGA+SEGB+SEGC+SEGD+SEGE+SEGF
NUM1     EQU SEGB|SEGC//SEGB+SEGC
NUM2     EQU SEGA|SEGB|SEGD|SEGE|SEGG//SEGA+SEGB+SEGD+SEGE+SEGG
NUM3     EQU SEGA|SEGB|SEGC|SEGD|SEGG//SEGA+SEGB+SEGC+SEGD+SEGG
NUM4     EQU SEGB|SEGC|SEGF|SEGG//SEGB+SEGC+SEGF+SEGG
NUM5     EQU SEGA|SEGC|SEGD|SEGF|SEGG//SEGA+SEGC+SEGD+SEGF+SEGG
NUM6     EQU SEGA|SEGC|SEGD|SEGE|SEGF|SEGG//SEGA+SEGC+SEGD+SEGE+SEGF+SEGG
NUM7     EQU SEGA|SEGB|SEGC//SEGA+SEGB+SEGC
NUM8     EQU SEGA|SEGB|SEGC|SEGD|SEGE|SEGF|SEGG//SEGA+SEGB+SEGC+SEGD+SEGE+SEGF+SEGG
NUM9     EQU SEGA|SEGB|SEGC|SEGD|SEGF|SEGG//SEGA+SEGB+SEGC+SEGD+SEGF+SEGG
NUMA     EQU SEGA|SEGB|SEGC|SEGE|SEGF|SEGG//SEGA+SEGB+SEGC+SEGE+SEGF+SEGG
NUMB     EQU SEGC|SEGD|SEGE|SEGF|SEGG
NUMC     EQU SEGA|SEGD|SEGE|SEGF
NUMD     EQU SEGB|SEGC|SEGD|SEGE|SEGG
NUME     EQU SEGA|SEGD|SEGE|SEGF|SEGG
NUMF     EQU SEGA|SEGE|SEGF|SEGG

DELAY_FACTOR      EQU 0xFFFF
DELAY_SEC     EQU 1
COUNT_MIN     EQU 0
COUNT_MAX     EQU 0xFF
TRUE          EQU 0xFF
FALSE         EQU 0


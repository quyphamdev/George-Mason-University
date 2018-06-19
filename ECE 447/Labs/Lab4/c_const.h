//constant and defines
#define WDTCTL *(unsigned int *)0x0120 
#define WDTPW 0x5A00 // password for WDT
#define WDTHOLD 0x0080

#define P1IN  *(unsigned char *)0x0020 // port 1
#define P1OUT *(unsigned char *)0x0021
#define P1DIR *(unsigned char *)0x0022
#define P1IFG *(unsigned char *)0x0023 // port 1 interrupt
#define P1IES *(unsigned char *)0x0024
#define P1IE  *(unsigned char *)0x0025
#define P2IN  *(unsigned char *)0x0028
#define P2OUT *(unsigned char *)0x0029 // port2                                  
#define P2DIR *(unsigned char *)0x002A 
#define P2IFG *(unsigned char *)0x002B // p2 interrupt
#define P2IES *(unsigned char *)0x002C
#define P2IE  *(unsigned char *)0x002D
#define P3IN  *(unsigned char *)0x0018 // port3 for buzz
#define P3OUT *(unsigned char *)0x0019
#define P3DIR *(unsigned char *)0x001A
#define P6OUT *(unsigned char *)0x0035 // port6 
#define P6IN  *(unsigned char *)0x0034
#define P6DIR *(unsigned char *)0x0036 
#define P5OUT *(unsigned char *)0x0031 // port 5
#define P5DIR *(unsigned char *)0x0032 
// timer A ports
#define TACTL   *(unsigned int *)0X0160
#define TACCR0  *(unsigned int *)0X0172
#define TACCTL0 *(unsigned int *)0x0162
#define TACCR1  *(unsigned int *)0X0174
#define TACCTL1 *(unsigned int *)0x0164

#define TIMERA0_VECTOR  (22 * 2u)
#define PORT1_VECTOR    (20 * 2u)

// timer A
#define OUTMOD_7        (7*0x20u)  // PWM output mode: 7 - PWM reset/set 
#define TASSEL_1      (1*0x0100u)  // Clock Source: ACLK  
#define MC_1            (1*0x10u)  // Timer A mode control: 1 - Up to CCR0 
#define TACLR           (0x0004)
#define ID_0            (0*0x40u)  // Timer A input divider: 0 - /1 
#define CCIE             (0x0010)  // timer enable interrupt

#define EN7SEG1 BIT0
#define EN7SEG2 BIT1
#define EN7SEG3 BIT2
#define DISABLE7SEG BIT3
#define DOT BIT7

#define BIT0 0x01
#define BIT1 0x02
#define BIT2 0x04
#define BIT3 0x08
#define BIT4 0x10
#define BIT5 0x20
#define BIT6 0x40
#define BIT7 0x80
// 7 segments
#define SEGA BIT0
#define SEGB BIT1
#define SEGC BIT2
#define SEGD BIT3
#define SEGE BIT4
#define SEGF BIT5
#define SEGG BIT6
// numbers from 0-9
#define NUM0 SEGA|SEGB|SEGC|SEGD|SEGE|SEGF
#define NUM1 SEGB|SEGC
#define NUM2 SEGA|SEGB|SEGD|SEGE|SEGG
#define NUM3 SEGA|SEGB|SEGC|SEGD|SEGG
#define NUM4 SEGB|SEGC|SEGF|SEGG
#define NUM5 SEGA|SEGC|SEGD|SEGF|SEGG
#define NUM6 SEGA|SEGC|SEGD|SEGE|SEGF|SEGG
#define NUM7 SEGA|SEGB|SEGC
#define NUM8 SEGA|SEGB|SEGC|SEGD|SEGE|SEGF|SEGG
#define NUM9 SEGA|SEGB|SEGC|SEGD|SEGF|SEGG

#define DELAY_FACTOR 60000
#define DELAY_FACTOR2 60000
#define COUNT_MIN 0
#define COUNT_MAX 99
#define FALSE 0
#define TRUE 1

#define PORT2_VECTOR (17 * 2u) //0xFFE2

// constants (menu.c)
#define MAIN_MENU 0
#define SM_1_TOGGLE_ALARM 1
#define SM_2_SETTING 2
#define SM_2A_SET_TIME 3
#define SM_2B_SET_ALARM 4
#define SM_2C_SET_DISPLAY_MODE 5
#define SM_2D_BACK 6
#define SM_3_EXIT 7
#define NO_KEY 0
// constants (alarm.c)
#define SNOOZE_TIME 20 // 10 sec
// constants (keypad.c)
#define NONE_KEY_PRESSED 0
#define KEY_0 0x30
#define KEY_1 0x31
#define KEY_2 0x32
#define KEY_3 0x33
#define KEY_4 0x34
#define KEY_5 0x35
#define KEY_6 0x36
#define KEY_7 0x37
#define KEY_8 0x38
#define KEY_9 0x39
#define KEY_STAR 0x2A
#define KEY_PAO_SIGN 0x23
// constants (time.c)
#define HR_MODE_24 24
#define HR_MODE_12 12
#define TEN 1
#define ONE 2
// realtime clock (time.c)
#define RTCCTL  *(unsigned char *)0x0041
#define RTCSEC  *(unsigned char *)0x0042
#define RTCMIN  *(unsigned char *)0x0043
#define RTCHOUR *(unsigned char *)0x0044
#define RTCDOW  *(unsigned char *)0x0045
#define RTCDAY  *(unsigned char *)0x004C
#define RTCMON  *(unsigned char *)0x004D
#define RTCYEAR *(unsigned int *)0x004E


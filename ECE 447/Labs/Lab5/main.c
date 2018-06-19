#include "msp430xG46x.h"
#include "c_const.h"
#include "lcd.h"
#include "time.h"

void ConfigADC();
void ConfigDAC();
void SetBuzzerOn();
void SetBuzzerOff();

void main(void)
{
  WDTCTL = WDTPW + WDTHOLD; // stop watch dog timer to avoid time out reset
  // setup interrupt on Port 1
  // port 1 conncect to keypad
  P1DIR = 0x70; // input on pins: 0~3 (keypad row), output on pins: 4~6 (keypad col)
  P1IE |= BIT0|BIT1|BIT2|BIT3; // interrupt on pins: 0~3 (any change on these pins (rows) indicate a key on keypad is pressed/released)  
  P1IES |= BIT0|BIT1|BIT2|BIT3; // falling edge
  P1OUT = 0;
  //-------------------------------------------------
  // setup timer interrupt for controlling the buzzer time, trigger every 0.5sec
  //-------------------------------------------------
  // initialize the PWM frequency (1 KHz)
  // ACLK is 32kHz/1s: 
  // so to make the timer count every half of seconds, we set the timer to 1/2
  // 32kHz / 2 = 16 kHz
  TACCR0 = 16000;  
  // turn on the timer
  // - source: ACLK
  // - input divider: /1
  // - up mode
  // - clear TAR
  TACTL = TASSEL_1 | ID_0 | MC_1 | TACLR;
  // enable timer interrupt for CCR0
  TACCTL0 = CCIE;
  // Port 6 connect to LCD
  P7DIR = 0xFF; // all output
  
  asm(" EINT"); // enable interrupt
    
  LCDInit(); // setting up LCD display
  ConfigADC();
  ConfigDAC();
  
  // print LCD
  LCDPrintStrAt(1,0,"Knob:+0000 000Hz");
  LCDPrintStrAt(2,0,"00.0 C 0.0V 000%");
  LCDPrintCharAt(2,4,0xDF);
  LCDSetCurPos(1,LCD_ADC_START);
  
  for(;;)
  {
    // low power mode 3 (LPM3), only ACLK remains active
    // this is the standard LPM when the MSP430 must awaken itself at regular time intervals
    // and therefore needs a slow clock.
    // SCG1--SCG0--OSC_OFF--CPU_OFF
    //  1      1      0        1     = 0x0D0
    // CPU, MCLK, SMCLK, DCO are disabled
    asm("BIS.W  #0x0D0, SR"); 
  }
}
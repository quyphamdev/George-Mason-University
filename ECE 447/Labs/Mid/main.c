#include "c_const.h"

void SetSensor();

void main(void)
{
  WDTCTL = WDTPW + WDTHOLD; // stop watch dog timer to avoid time out reset
  //-------------------------------------------------
  // setup interrupt on button SW1 and SW2
  //-------------------------------------------------
  // set interrupt on btn SW1 and define interrupt routine
  P1DIR = 0; // set all pins to input
  P1IE |= BIT0; // interrupt on bit 0 (btn SW1)
  //P1IES |= BIT0|BIT1; // falling edge
  //-------------------------------------------------
  // setup timer interrupt
  //-------------------------------------------------
  // initialize the PWM frequency (1 KHz)
  // ACLK is 32kHz/1s: 
  // so to make the timer count every tenth of seconds, we set the timer to 1/10
  // 32kHz / 10 = 3200 Hz
  TACCR0 = 3200;  
  // turn on the timer
  // - source: ACLK
  // - input divider: /1
  // - up mode
  // - clear TAR
  TACTL = TASSEL_1 | ID_0 | MC_1 | TACLR;
  // enable timer interrupt for CCR0
  TACCTL0 = CCIE;
  
  asm(" EINT"); // enable interrupt
  
  SetSensor();
  
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
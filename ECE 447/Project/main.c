#include  <msp430xG46x.h>
#include "lcd.h"
#include "Bluetooth.h"
#include "btn_isr.h"

int main( void )
{
  // Stop watchdog timer to prevent time out reset
  WDTCTL = WDTPW + WDTHOLD;

  FLL_CTL0 |= XCAP14PF;                     // Configure load caps
  do
  {
  IFG1 &= ~OFIFG;                           // Clear OSCFault flag
  for (int i = 0x47FF; i > 0; i--);             // Time for flag to set
  }
  while ((IFG1 & OFIFG));                   // OSCFault flag still set?  
  
  
  setupBtnISR();
  LCDInit();
  LCDClear();
  LCDPrintStr("ConfigBT..");
  configBT();  
  
  _BIS_SR(LPM0_bits + GIE);                 // Enter LPM0 w/ interrupt
  return 0;
}

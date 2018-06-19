#include "c_const.h"

#define LCDMEMS 32
unsigned int * const LCDMem = (unsigned int *) 0x091;

void initLCD(void)
{
  int i;
  for(i = 0; i < LCDMEMS, i++) // clear LCD screen
  {
    LCDMem[i] = 0;
  }
  P5SEL = BIT4|BIT3|BIT2;
  LCDAPCTL0 = LCDS4|LCDS8|LCDS12|LCDS16|LCDS20|LCDS24;
  LCDAVCTL0 = 0;
  LCDACTL = LCDFREQ_128 | LCD4MUX | LCDSON | LCDON;
}
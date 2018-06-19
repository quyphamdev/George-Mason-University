#include "msp430xG46x.h"

// to convert, assign value to DAC12_1DAT
void ConfigDAC()
{
  DAC12_1CTL = DAC12LSEL0 + DAC12OPS + DAC12IR + DAC12AMP_5 + DAC12ENC;
  // convert right after assign to DAT, output on P5.1, input range 1x Vref + Med speed/current + enable conversion    
  DAC12_1DAT = (int)(4095l*15/25); // 0xFFF = 4095 (12 bits)
}
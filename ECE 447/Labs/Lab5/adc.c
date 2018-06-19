#include "msp430xG46x.h"
#include "c_const.h"

int knob = 0; // connect to P6.0 (A0)

void ConfigADC()
{
  ADC12CTL0 = SHT0_2 + ADC12ON; // sample and hold time 16 cycle, ADC12 on
  ADC12CTL1 = SHP; // source from sampling timer
  ADC12IE = BIT0; // interrupt on ADC12MEM0
  ADC12CTL0 |= REF2_5V + REFON + ENC; // Vref = 2.5V, enable conversion
  for(int i = 500; i--;); // delay for ref update
  ADC12MCTL0 |= INCH_0; // use channel A0 as input (knob) P6.0
  P6SEL |= BIT0; // P6.0 = ADC input
  P6DIR = 0;
}

#pragma vector = ADC12_VECTOR
__interrupt void Knob_ISR(void)
{
  knob = (int)(ADC12MEM0 - 2048);
}
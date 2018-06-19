#include "msp430xG46x.h"

// use P6.1~3 for connect to temperature sensor
// P6.1: data
// P6.2: n_reset
// P6.3: clk

#define DATA  BIT1
#define RST BIT2 // low: terminate comm
#define CLK   BIT3

void delay(); // lcd.c

int GetTemp()
{
  unsigned char read = 0xAA;
  int temp = 0;
  P6DIR |= BIT1|BIT2|BIT3; // set those to output
  // start new conversion in temp chip
  P6OUT &= ~RST; // set _RESET to low
  P6OUT |= CLK; // set clk to high
  delay();
  P6OUT &= ~CLK; // then set clk to low
  delay();
  P6OUT |= CLK; // set clk to high again to get new conversion
  delay();
  // sending reading cmd
  P6OUT |= RST; // set reset to high to start communication
  delay();
  for(int i=8;i--;)
  {
    P6OUT &= ~CLK; // set clk to low
    // send data during falling edge, before rising edge
    if(read & BIT0) // send LSB first
      P6OUT |= DATA; // send data bit 1
    else
      P6OUT &= ~DATA; // send data bit 0
    delay();
    P6OUT |= CLK; // set clk to high
    delay();
    read = read>>1; // throw out the transfered bit, get next bit
  }
  // read back the temp
  P6DIR &= ~DATA; // switch data port to input
  for(int i=9;i--;)
  {
    P6OUT &= ~CLK; // set clk to low
    delay();
    // read data during falling edge and before rising edge    
    if(P6IN & DATA)
      temp |= BIT9; // LSB first    
    delay();
    P6OUT |= CLK; // set clk to high
    delay();
    temp = temp>>1;
  }
  P6OUT &= ~RST; // set reset to low to terminate comm
  temp &= 0x01FF;
  if(temp & BIT9) // negative degree ?
  {
    temp &= ~BIT9; // clear the sign bit
    temp = -temp; // convert to neg num
  }
  return ((temp*10)/2);
}
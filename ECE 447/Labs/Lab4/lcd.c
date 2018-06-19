#include "lcd.h"
#include "c_const.h"

// P3.0~2 use for RS,RW,E
// P6.0~7 use for DB0~DB7

void delay()
{
  for(int i=0;i<10;i++){};
}

char isLCDBusy()
{
  char ON;
  P6DIR = 0x00; // all input, to read BF and Address Counter (AC)  
  P3DIR = 0xFF; // all output, to set RS,RW,E
  P3OUT = (P3OUT&(~RS))|RW; // to read BF(busy flag): RS=0,RW=1
  P3OUT |= E; // read/write operation enable signal
  delay();
  ON = P6IN & BF; // get busy flag status bit
  P3OUT &= ~E; // read/write operation disable signal
  if(ON) // BF is on ?      
    return TRUE;
  else
    return FALSE;
}

void LCDClear()
{
  while(isLCDBusy()); // wait till all cmd is processed
  P6DIR = 0xFF; // all output
  P6OUT = BIT0; // set bit 0 up to clear display
  P3DIR = 0xFF; // all output
  P3OUT &= ~(RS|RW); // set RS = RW = 0
  P3OUT |= E; // read/write operation enalbe signal
  delay();
  P3OUT &= ~E; // disable
}

void LCDDisplay(char DisplayOn, char CursorOn, char CurBlinkOn)
{
  while(isLCDBusy());
  P6DIR = 0xFF; // all output
  P3DIR = 0xFF; // all output
  P3OUT &= ~(RS|RW); // set RS = RW = 0
  P6OUT = BIT3; // display on/off control cmd
  P6OUT = (DisplayOn) ? P6OUT|BIT2 : (P6OUT&(~BIT2));
  P6OUT = (CursorOn) ? P6OUT|BIT1 : (P6OUT&(~BIT1));
  P6OUT = (CurBlinkOn) ? P6OUT|BIT0 : (P6OUT&(~BIT0));
  P3OUT |= E; // read/write operation enalbe signal
  delay();
  P3OUT &= ~E; // disable
}

void LCDFuncSet()
{
  while(isLCDBusy());
  P6DIR = 0xFF; // all output
  P3DIR = 0xFF; // all output
  P6OUT = BIT5; // fucntion set bit
  P6OUT |= BIT4|BIT3; //8-bit data len, 2-line display, font type 5x8
  P3OUT &= ~(RS|RW); // set RS = RW = 0
  P3OUT |= E; // read/write operation enalbe signal
  delay();
  P3OUT &= ~E; // disable
}
  
void LCDInit()
{
  LCDFuncSet(); // set LCD display to show 2 lines, 8-bit data len, font type 5x8
  LCDDisplay(1,1,1); // display on, cursor on, cursor blinking on
  LCDClear(); // clear LCD screen
}

void LCDReturnHome() // move cursor to the top left corner
{
  while(isLCDBusy());
  P6DIR = 0xFF; // all output
  P3DIR = 0xFF; // all output
  P6OUT = BIT1; // return home bit set
  P3OUT &= ~(RS|RW); // set RS = RW = 0
  P3OUT |= E; // read/write operation enalbe signal
  delay();
  P3OUT &= ~E; // disable
}

void LCDEntryModeSet()
{
  while(isLCDBusy());
  P6DIR = 0xFF; // all output
  P3DIR = 0xFF; // all output
  P6OUT = BIT2; // entry mode set bit
  P6OUT |= BIT1; // cursor/blink move to right and DDRAM addr inc by 1, no shift
  P3OUT &= ~(RS|RW); // set RS = RW = 0
  P3OUT |= E; // read/write operation enalbe signal
  delay();
  P3OUT &= ~E; // disable
}

void LCDSetCurPos(char row, char col)
{
  while(isLCDBusy());
  P6DIR = 0xFF; // all output
  P3DIR = 0xFF; // all output
  P6OUT = BIT7; // return home bit set
  if(row == 1)
  {
    P6OUT |= col & 0x7F; // set cursor position on row 1
  }
  else
  {
    P6OUT |= 0x40 | (col & 0x7F); // set cursor pos on row 2
  }
  P3OUT &= ~(RS|RW); // set RS = RW = 0
  P3OUT |= E; // read/write operation enalbe signal
  delay();
  P3OUT &= ~E; // disable
}

void LCDPrintChar(char c)
{
  while(isLCDBusy());
  P6DIR = 0xFF; // all output
  P3DIR = 0xFF; // all output
  P6OUT = c; // write char to DDRAM
  P3OUT = RS|(P3OUT&(~RW)); // RS=1, RW=0, write data to RAM
  P3OUT |= E; // read/write operation enalbe signal
  delay();
  P3OUT &= ~E; // disable
}

void LCDPrintCharAt(char row, char col, char c)
{
  LCDSetCurPos(row,col);
  LCDPrintChar(c);
}

void LCDPrintStr(char *s)
{
  for(; *s != 0; s++)
  {
    LCDPrintChar(*s);
  }
}

void LCDPrintStrAt(char row, char col, char *s)
{
  LCDSetCurPos(row,col);
  LCDPrintStr(s);
}

#include "ecgmap.h"

//constant and defines
#define WDTCTL *(unsigned int *)0x0120 
#define WDTSTP 0x5A80
#define P1IN  *(unsigned int *)0x0020 // buttons/switches
#define P1DIR *(unsigned int *)0x0022
#define P2IN *(unsigned int *)0x0028
#define P2OUT *(unsigned int *)0x0029
#define P2DIR *(unsigned int *)0x002A
#define P6IN *(unsigned int *)0x0034
#define P6OUT *(unsigned int *)0x0035
#define P6DIR *(unsigned int *)0x0036

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
#define NUM4 SEGB|SEGC|SEGE|SEGF|SEGG
#define NUM5 SEGA|SEGC|SEGD|SEGF|SEGG
#define NUM6 SEGA|SEGC|SEGD|SEGE|SEGF|SEGG
#define NUM7 SEGA|SEGB|SEGC
#define NUM8 SEGA|SEGB|SEGC|SEGD|SEGE|SEGF|SEGG
#define NUM9 SEGA|SEGB|SEGC|SEGD|SEGF|SEGG

#define DELAY_FACTOR 60000
#define COUNT_MIN 0
#define COUNT_MAX 99

int nums[] = {NUM0,NUM1,NUM2,NUM3,NUM4,NUM5,NUM6,NUM7,NUM8,NUM9};
unsigned int count;
int EnBtnState, CountUpBtnState, RollOverBtnState;
int En, CountUp, RollOver;


void Delay(int sec)
{
  int time = DELAY_FACTOR*sec;
  for(int i=0; i<time; i++) {}   
}

int GetOneth(unsigned int num)
{
  return (num >= 10) ? (num%100)%10 : num;
}

int GetTenth(unsigned int num)
{
  return (num >= 10) ? (num%100)/10 : 0;
}

void CheckEnabledBtn()
{
  if(!(P1IN & BIT0)) // active low
  {
    // check for raising edge
    if(!EnBtnState)
    {
      En ^= 1;
      EnBtnState = 1;
    }
  }
  else
  {
    EnBtnState = 0;
  }
}

void CheckCountUpBtn()
{
  if(!(P1IN & BIT1)) // active low
  {
    // check for raising edge
    if(!CountUpBtnState)
    {
      CountUp ^= 1;
      CountUpBtnState = 1;
    }
  }
  else
  {
    CountUpBtnState = 0;
  }
}

void CheckRollOverBtn()
{
  if(!(P2IN & BIT7)) // active low
  {
    // check for raising edge
    if(RollOverBtnState)
    {
      RollOver ^= 1;
      RollOverBtnState = 1;
    }
  }
  else
  {
    RollOverBtnState = 0;
  }
}

void GetCurCountNum()
{
  if(En)
  {
    if(CountUp)
    {
      if(count < COUNT_MAX)
      {
        count++;
      }
      else
      {
        if(RollOver)
        {
          count = COUNT_MIN;
        }
        else
        {
          count--;        
          CountUp = 0;
        }
      }
    }
    else // count down
    {
      if(count > COUNT_MIN)
      {
        count--;
      }
      else
      {
        if(RollOver)
        {
          count = COUNT_MAX;
        }
        else
        {
          count++;        
          CountUp = 1;
        }
      }
    }
  }
}

void DisplayNum(unsigned int num)
{
  P6OUT = ~nums[GetTenth(num)]; // active low
  P2OUT = ~nums[GetOneth(num)];
}

/*
- mask bit 7 from P2 to become input = S3 btn
- add global vars: RollOverBtnState, RollOver
- add func check btn S3 is pressed: CheckRollOverBtn()
- edit GetCurCountNum()
- edit main() at the infinity loop while
- edit main: set bit 7 of pin2.7
*/

int main(void) {
  
  //STOP the watchdog timer
  WDTCTL = WDTSTP;  
  P1DIR = 0; // set as input buttons
  P2DIR = 0x007F; // set which bit to be outputs to 7 seg
  P6DIR = 0x007F; // 0000 0000 0111 1111
  // BONUS 1 - active low on PIN2.7
  P2IN |= BIT7; // set bit 7 = 1 (high)
  // int counter
  count = COUNT_MIN;
  En = 0; // enabled toggle btn flag
  CountUp = 1; // count up/down toggle btn flag
  RollOver = 0; // BONUS 1 - roll over flag
  EnBtnState = 0;
  CountUpBtnState = 0;
  RollOverBtnState = 0; // BONUS 1  
  // button S1 is bit 0, S2 = bit 1 in P1IN
  while(1)
  {
    CheckEnabledBtn();
    CheckCountUpBtn();
    CheckRollOverBtn(); // BONUS 1
    GetCurCountNum();
    DisplayNum(count);
  }
}

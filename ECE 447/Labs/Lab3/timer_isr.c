#include "c_const.h"

int nums[] = {NUM0,NUM1,NUM2,NUM3,NUM4,NUM5,NUM6,NUM7,NUM8,NUM9};
unsigned int Timer = 0; // counter
int TimerEnFlag = 0; // TRUE: start count, FALSE: stop count
int Timer5SecDelay = 0;
int Timer5SecDelayEn = 0;

void SetBuzzerOn(); // func definition in buzzer_pwm_isr.asm
void SetBuzzerOff();

void IncTimer()
{
  if(Timer <= 600)
  {
    Timer += 100; 
  }
  else if(Timer <= 2400)
  {
    Timer += 200; 
  }
  else if(Timer <= 9990)
  {
    Timer += 300;
    if(Timer > 9990)
    {
      Timer = 9990; 
    }
  }
}

void DisplayToSeg(int seg, int digit)
{
  P2OUT = ~digit;
  P6OUT = seg;
  P6OUT = 0;
}

#pragma vector = TIMERA0_VECTOR
__interrupt void DisplaySegs_ISR(void)
{
  int tenth = Timer%10,
      one = (Timer/10)%10,
      ten = (Timer/100)%10,
      hundred = (Timer/1000)%10;
  if(Timer < 100) // dont display the tenth of second ss.0 = ss.tenth
  {
    DisplayToSeg(EN7SEG3, 0x0); // Turn Off 3rd Seg
    DisplayToSeg(EN7SEG2, nums[one]);
    DisplayToSeg(EN7SEG1, nums[tenth]|DOT);    
  }
  else if(Timer < 1000) // display the tenth of second
  {
    DisplayToSeg(EN7SEG3, nums[ten]);
    DisplayToSeg(EN7SEG2, nums[one]);
    DisplayToSeg(EN7SEG1, nums[tenth]|DOT);
  }
  else
  {
    DisplayToSeg(EN7SEG3, nums[hundred]);
    DisplayToSeg(EN7SEG2, nums[ten]);
    DisplayToSeg(EN7SEG1, nums[one]);
  }
  
  if(TimerEnFlag)
  {
    if(Timer > 0)
    {
      Timer--;      
    }
    else
    {
      if(Timer5SecDelayEn == 0)
      {
        SetBuzzerOff(); // make sure buzzer is off before turn it on
        SetBuzzerOn(); // buzz for 5s when timer = 0
        Timer5SecDelay = 50; // buzz in 5 sec
        Timer5SecDelayEn = 1;
      }
    }
    
    if(Timer5SecDelayEn == 1) // buzz in 5 sec
    {
      if(Timer5SecDelay > 0)
      {
        Timer5SecDelay--;
      }
      else // then stop buzz
      {
        SetBuzzerOff();
      }
      
    }    
  }
  else
  {
    Timer5SecDelayEn = 0;
  }
}
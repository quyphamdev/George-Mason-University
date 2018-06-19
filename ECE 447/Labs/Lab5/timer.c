#include "msp430xG46x.h"
#include "c_const.h"
#include "lcd.h"

// function prototype (buzzer.asm)
void SetBuzzerOn(); // func definition in buzzer_pwm_isr.asm
void SetBuzzerOff();
int GetTemp(); // temp.c

// extern vars
extern int knob;

// global vars
char BuzzerOn = FALSE;
unsigned int BuzzerTimer = BUZZER_TIME;

void adc()
{
  char s[] = "0000";
  int knb;
  if(knob >= 0)
  {
    knb = knob;
    LCDPrintCharAt(1,LCD_ADC_START-1,'+');
  }
  else
  {
    knb = -knob;
    LCDPrintCharAt(1,LCD_ADC_START-1,'-');
  }  
  s[0] = knb/1000 + 0x30;
  s[1] = (knb%1000)/100 + 0x30;
  s[2] = (knb%100)/10 + 0x30;
  s[3] = (knb%10) + 0x30;
  LCDPrintStrAt(1,LCD_ADC_START,s);  
}


#pragma vector = TIMERA0_VECTOR
__interrupt void TA_ISR(void) // trigger every 1/2 of second
{   
  int temp = 0;
  // Input Freq Buzz
  if((BuzzerOn == TRUE)&&(BuzzerTimer == BUZZER_TIME)) // first start ? sound the buzzer ?
  {
    SetBuzzerOn(); // set buzzer on
    BuzzerTimer = BUZZER_TIME; // set duration time (2 sec)
  } 
  
  if(BuzzerTimer > 0)  // buzzer is currently on
  {
    BuzzerTimer--; // count down from 2 sec
  }
  else // turn off buzzer
  {
    if(BuzzerOn == TRUE)
    {
      SetBuzzerOff();
      BuzzerTimer = BUZZER_TIME; // reset timer
      BuzzerOn = FALSE;
    }
  } 
  // knob process
  ADC12CTL0 |= ADC12SC; // set to start ADC conversion on knob
  adc(); // print new value of knob on LCD
  
  // get temp and print it on LCD
  temp = GetTemp();
  LCDPrintCharAt(2,LCD_SERIAL_START,((temp%1000)/100+0x30));
  LCDPrintCharAt(2,LCD_SERIAL_START+1,((temp%100)/10+0x30));
  LCDPrintCharAt(2,LCD_SERIAL_START+3,(temp%10+0x30));
}
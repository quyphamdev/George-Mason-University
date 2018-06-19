#include "msp430xG46x.h"
#include "c_const.h"
#include "lcd.h"
#include "time.h"


// function prototype
char is_star_key(char k); // check if key = '*'
char is_pao_sign(char k); // check if key = '#'
char is_num_key(char k); // check if key = 0..9
void menu_key_process(char key); // process key input for displaying menu, submenu


// extern vars (timer.c)
extern char BuzzerOn;
extern unsigned int BuzzerTimer;

// global vars
char ModeSel = BUZZER_FREQ_INPUT; // use for choosing which menu or submenu should be displayed/processed
char input[] = "000";
int BuzzerFreq = 200;
int BuzzerPwm = 200*40/100;
unsigned int LED4Brightness = 5; // 5=0.5


char GetFreqInput(char key)
{
  static char digit = 0;  
  switch(digit)
  {
    case 0: // hundred
      LCDSetCurPos(1,LCD_FREQ_START);
      if(key >= KEY_2 && key <= KEY_9)
      {
        input[0] = key;
        LCDPrintCharAt(1,LCD_FREQ_START+digit,key);
        digit++;
      }
      break;
    case 1: // ten
      if(key >= KEY_0 && key <= KEY_9)
      {
        input[1] = key;
        LCDPrintCharAt(1,LCD_FREQ_START+digit,key);
        digit++;
      }
      break;
    case 2: // one
      if(key >= KEY_0 && key <= KEY_9)
      {
        input[2] = key;
        LCDPrintCharAt(1,LCD_FREQ_START+digit,key);
        digit = 0;
        return 3; // done with key input
      }            
      break;
  }
  return digit; // setting (current/alarm) time str is not ready
}

char GetPwmInput(char key)
{
  static char digit = 0;
  static char fkey = 0;  
  switch(digit)
  {
    case 0: // hundred
      LCDSetCurPos(2,LCD_PWM_START);
      if(key >= KEY_0 && key <= KEY_1)
      {
        input[0] = key;
        LCDPrintCharAt(2,LCD_PWM_START+digit,key);
        fkey = key;
        digit++; // go to digit ten
      }
      break;
    case 1: // ten
    case 2: // one
      if(fkey == KEY_0) // hundred is 0
      {
        if(key >= KEY_0 && key <= KEY_9)
        {
          input[digit] = key;
          LCDPrintCharAt(2,LCD_PWM_START+digit,key);
          digit++; // go to digit one
        }
      }
      else // hundred is 1
      {
        if(key == KEY_0)
        {
          input[digit] = key;
          LCDPrintCharAt(2,LCD_PWM_START+digit,key);
          digit++;
        }
      }
      if(digit >= 3)
      {
        digit = 0;
        return 3; // done with key input
      }                
      break;
  }
  return digit; // setting (current/alarm) time str is not ready
}


int StrToNum(char *s)
{
  return (s[2]-0x30)*100+(s[1]-0x30)*10+(s[0]-0x30);
}

void BuzzerFreqInput(char key)
{
  char digit;
  digit = GetFreqInput(key);
  //LCDPrintStrAt(1,LCD_FREQ_START+3,"Hz");    
  if(digit == 3) // done with freq input, buzzer on with that input freq
  {
    BuzzerFreq = 32000/StrToNum(input);
    BuzzerPwm = BuzzerFreq*40/100;
    BuzzerOn = TRUE;
    BuzzerTimer = BUZZER_TIME;    
  }
}

void LedPwmInput(char key)
{
  char digit;
  int PwmInput;
  digit = GetPwmInput(key);
  if(digit == 3) // done with pwm input
  {
    PwmInput = StrToNum(input);
    P2DIR |= BIT2; // set P2.2 = ouput
    P2SEL |= BIT2; // pwm output to LED 1
    TBCCR0 = 32000/50;
    TBCCR1 = TBCCR0*PwmInput/100; // pwm of 50Hz
    TBCTL = TBSSEL_1|CNTL_0|ID_0|MC_1|TBCLR; // ACLK, 16-bit counter, div /1, upmode, clear TAR
    TBCCTL1 = OUTMOD_7; // reset/set
  }
}

void dac()
{    
  char one,tenth;
  if(P1IFG & BIT0) // SW1 btn pressed ?
  {
    // increase brightness of LED4
    LED4Brightness++;
  }
  else if(P1IFG & BIT1) // SW2 btn pressed ?
  {
    // decrease brightness of LED4     
     if(LED4Brightness > 0)
       LED4Brightness--;
  }
  DAC12_1DAT = (int)(LED4Brightness*4095l/25); // set new brightness
  // show new brightness value on LCD
  one = LED4Brightness/10 + 0x30;
  tenth = LED4Brightness%10 + 0x30;
  LCDPrintCharAt(2,LCD_DAC_START,one);
  LCDPrintCharAt(2,LCD_DAC_START+2,tenth);
  LCDSetCurPos(2,LCD_DAC_START);
}

void menu_key_process(char key)
{
  switch(ModeSel)
  {
    case DAC: // 
      dac();
      break;
    case BUZZER_FREQ_INPUT: // 
      BuzzerFreqInput(key);
      break;
    case LED_PWM_INPUT: // 
      LedPwmInput(key);
      break;
  }
}
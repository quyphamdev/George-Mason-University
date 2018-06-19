#include "msp430xG46x.h"
#include "c_const.h"

// function prototype
void menu_key_process(char key); // menu.c

// extern vars
extern char ModeSel;

// global vars
char keys[] = {KEY_1,KEY_2,KEY_3,
              KEY_4,KEY_5,KEY_6,
              KEY_7,KEY_8,KEY_9,
              KEY_STAR,KEY_0,KEY_PAO_SIGN};

char is_star_key(char k)
{
  return (k == KEY_STAR) ? TRUE : FALSE;
}

char is_pao_sign(char k)
{
  return (k == KEY_PAO_SIGN) ? TRUE : FALSE;
}

char is_num_key(char k)
{
  return ((k >= KEY_0)&&(k <= KEY_9)) ? TRUE : FALSE;
}

char get_row(char r)
{
  switch(r)
  {
    case 0x0E /*00001110*/: return 0;
    case 0x0D /*00001101*/: return 1;
    case 0x0B /*00001011*/: return 2;
    case 0x07 /*00000111*/: return 3;
  }  
  return 0;
}

char decode_output(char P1_IN, char col)
{
  char row = get_row(P1_IN & 0x0F);
  char idx = row*3+col;
  return keys[idx];
}

char decode_key(void)
{
  P1OUT = BIT5|BIT6;
  for(int i=10;i--;);
  if((P1IN & 0x0F) != 0x0F) // check column 1
  {
    return decode_output(P1IN,0);
  }
  else
  {
    P1OUT = BIT4|BIT6;
    for(int i=10;i--;);
    if((P1IN & 0x0F) != 0x0F) // check column 2
    {
      return decode_output(P1IN,1);
    }
    else
    {
      P1OUT = BIT4|BIT5;
      for(int i=10;i--;);
      if((P1IN & 0x0F) != 0x0F) // check column 3
      {
        return decode_output(P1IN,2);
      }
      else
      {
        return NONE_KEY_PRESSED;
      }
    }
  }
}

#pragma vector = PORT1_VECTOR
__interrupt void keypad_isr(void)
{
  char key;
  key = decode_key(); // scan and determine which key was pressed
  
  for(int i=500;i--;);
  
  // do something with key input here  
  if(is_star_key(key) == TRUE) // press '*' to switch between freq/pwm setting
  {
    //ModeSel = (ModeSel == LED_PWM_INPUT) ? BUZZER_FREQ_INPUT : LED_PWM_INPUT;
    switch(ModeSel)
    {
    case LED_PWM_INPUT:
      ModeSel = BUZZER_FREQ_INPUT;
      break;
    case BUZZER_FREQ_INPUT:
      ModeSel = DAC;
      break;
    case DAC:
      ModeSel = LED_PWM_INPUT;
      break;
    }
  }
  menu_key_process(key);
  
  P1IFG = 0;
  P1OUT = 0; // without this, only last col keys work !!
}
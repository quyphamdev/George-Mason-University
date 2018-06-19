#include "c_const.h"

// function prototype
void menu_key_process(char key);
void main_menu(char key);

// extern vars
extern char DisplayTimeOn, ModeSel; // (menu.c)

// global vars
char keys[] = {KEY_1,KEY_2,KEY_3,
              KEY_4,KEY_5,KEY_6,
              KEY_7,KEY_8,KEY_9,
              KEY_STAR,KEY_0,KEY_PAO_SIGN};
char DisplayMenuOn = FALSE;

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
  
  for(int i=200;i--;);
  
  if(DisplayTimeOn == TRUE) // currently showing time
  {
    if(is_pao_sign(key) == TRUE) // and user presses '#'
    {
      // then stop showing clock time. Show menu
      DisplayTimeOn = FALSE;
      ModeSel = MAIN_MENU;
      main_menu(NO_KEY);
    }
  }
  else
  {
    menu_key_process(key);
  }
  
  P1IFG = 0;
  P1OUT = 0; // without this, only last col keys work !!
}
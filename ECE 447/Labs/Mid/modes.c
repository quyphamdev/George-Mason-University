#include "c_const.h"
extern int timer;
int wait_btn_push = 1;
int wait_btn_release = 0;
int mode = 1;
int mode2_counter = 0;

void CheckModeSwitch()
{
  if((wait_btn_push == 1)&&(wait_btn_release == 0))
  {
    wait_btn_push = 0;
    wait_btn_release = 1;
    timer = 0;    
    P1IES ^= BIT0; // switching between rising and falling edge
  }
  else if((wait_btn_push == 0)&&(wait_btn_release == 1))
  {
    if(timer <= 20) // btn push within 2 sec, toggle mode
    {
      wait_btn_push = 1;
      wait_btn_release = 0;
      mode = (mode == 1)? 2:1;
    }
    else if(timer > 20) // btn push longer than 2 sec
    {
      if(mode == 2) // reset mode 2 counter
      {
        
      }
      wait_btn_push = 1;
      wait_btn_release = 0;
    }
  }
}
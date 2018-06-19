#include "c_const.h"

int timer = 0;
int timer_buzz = 0;
int timer_buzz_prev = 0;
int pulses = 0;
int speed = 0;
int distance = 0;
int calibration_factor;

void SetBuzzerOn();
void SetBuzzerOff();

void alarm_control()
{
  if((timer_buzz >= 50)&&(speed > 65)) // speed >= 65MPH, turn on alarm
  {
    if(timer_buzz == timer_buzz_prev) // alarm will on for 0.1s for every 5sec
    {
      SetBuzzerOn();
    }
    else
    {
      SetBuzzerOff();
      timer_buzz_prev = timer_buzz;
    }
  }
  else
  {
    
  }
}

#pragma vector = TIMERA0_VECTOR
__interrupt void Timer_ISR(void)
{
  timer += 1; // increase this by 1 every 1/10 sec
  timer_buzz += 1; // use for alarm timer
  alarm_control();
}

#pragma vector = TIMERB1_VECTOR
__interrupt void Pulse_ISR(void)
{
  pulses += 1;
  speed = pulses/(1000/calibration_factor); // in MPH
  distance = pulses/(3600000/calibration_factor); // in miles
  // show speed and distance on LCD
}
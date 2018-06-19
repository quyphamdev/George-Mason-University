#include "c_const.h"
#include "time.h"
#include "lcd.h"

// function prototype (buzzer.asm)
void SetBuzzerOn(); // func definition in buzzer_pwm_isr.asm
void SetBuzzerOff();
void sm_toggle_alarm(char key); // (menu.c)

// extern vars
extern char ModeSel, MenuEn; // (menu.c)
extern char DisplayTimeOn; // (menu.c)
extern unsigned long CurrentTime; // (menu.c)
extern char curTimeStr[]; // (menu.c)
extern char hr_mode;

// global vars
unsigned int Timer = 0; // counter
char AlarmEn = 0; // if alarm is enabled (1), disabled (0)
char AlarmOn = 0; // if alarm is on (1), off (0)
char AlarmSnoozeEn = 0; // flag, indicate alarm is in snooze mode
unsigned long SnoozeTime = 0; // equal to the current time + SNOOZE_TIME
unsigned long AlarmTime = 0; // store the alarm time
char AToggle = 1; // when alarm first start, there should be sound

#pragma vector = TIMERA0_VECTOR
__interrupt void alarm_ISR(void) // trigger every 1/2 of second
{   
  CurrentTime = getCurTime();
  timeToStr(CurrentTime,curTimeStr,hr_mode);
  if(DisplayTimeOn) // display current time on LCD screen
  {
    LCDClear();
    LCDPrintStrAt(1,0,curTimeStr);
    if(AlarmEn)
      LCDPrintCharAt(1,15,'.');
    else
      LCDPrintCharAt(1,15,' ');
  }
  if(CurrentTime == AlarmTime)
  {
    AlarmOn = 1;
  }
  // if alarm is on and no in snooze mode, sound the alarm
  if((AlarmEn == 1)&&(AlarmOn == 1))//&&(AlarmSnoozeEn == 0))
  {
    // sound the alarm for 1/2 sec, then off for 1/2 sec
    if(AToggle == 0)
    {
      SetBuzzerOff();
    }
    else
    {
      SetBuzzerOn();
    }
    AToggle = (AToggle == 1) ? 0 : 1;
    
    // when alarm is on, display alarm toggle mode menu, so user can:
    // press '*' to enter snooze mode
    // press '#' to stop alarm
    DisplayTimeOn = FALSE;
    ModeSel = SM_1_TOGGLE_ALARM;
    sm_toggle_alarm(NO_KEY);
  }
  else // turn off the alarm
  {
    AlarmOn = 0;
    SetBuzzerOff();
  }
}
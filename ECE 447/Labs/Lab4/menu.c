#include "c_const.h"
#include "lcd.h"
#include "time.h"

// function prototype
char is_star_key(char k); // check if key = '*'
char is_pao_sign(char k); // check if key = '#'
char is_num_key(char k); // check if key = 0..9
void menu_key_process(char key); // process key input for displaying menu, submenu

// extern vars (alarm.c)
extern char AlarmEn, AlarmOn, AlarmSnoozeEn;
extern unsigned long SnoozeTime, AlarmTime;
// AlarmEn: if = 1, the alarm will sound when AlarmTime = CurrentTime
// AlarmTime: the time which user set to thru menu setting

// global vars
char ModeSel = SM_3_EXIT; // use for choosing which menu or submenu should be displayed/processed
char DisplayTimeOn = TRUE; // when = TRUE, check input key for '#' -> displaying menu, otherwise displaying time
char mainmenu[] = {SM_1_TOGGLE_ALARM, SM_2_SETTING, SM_3_EXIT};
char setting[] = {SM_2A_SET_TIME, SM_2B_SET_ALARM, SM_2C_SET_DISPLAY_MODE, SM_2D_BACK};
char timestr[] = "00:00:00 AM"; // use for storing user setting for current/alarm time
unsigned long CurrentTime;
char curTimeStr[] = "00:00:00 AM";
char hr_mode = HR_MODE_12; // 24/12 hour mode
char* s_mainmenu[] = {
  "Alarm On/Off",
  "Setting",
  "Exit"
};
char* s_setting[] = {
  "Set Current Time",
  "Set Alarm Time",
  "Set Display Mode",
  "Back"
};

// press * to show main menu.
// 0 - main menu: display
//    + row1: "alarm on/off"
//    + row2: "setting"
//                press * to cycle thru 2 modes.
//                press # to select.
// 1 - sub menu 1 (alarm on/off) toggle with #. press * to go back to main menu.
//    + row1: current time "hh:mm:ss xM" and alarm on/off icon
//    + row2: "alarm is on"/"alarm is off" or "press # to toggle alarm"
// 2 - sub menu 2a: 2 rows: "set current time" and "set alarm time"
//      press * to cycle thru next
// 3 - sub menu 2b: 2 rows: "Display mode 12/24hrs" and "back"(to main menu)

void main_menu(char key)
{
  static char idx = 0;
  if(is_star_key(key) == TRUE) // key = '*' -> move seletion to next menu item
  {
    idx = (idx >= 2) ? 0 : (idx+1);
  }
  else
  {
    if(is_pao_sign(key) == TRUE) // key = '#' -> go into current selecting menu
    {      
      ModeSel = mainmenu[idx];
      menu_key_process(NO_KEY); // displaying the selected menu
      return;
    }
  }  
  // Main Menu:
  // - Alarm on/off
  // - Setting
  // - Exit
  LCDClear();
  LCDPrintStrAt(1,0,"Main Menu:");
  LCDPrintStrAt(2,2,s_mainmenu[idx]);
}

// use for toggle the alarm on/off
void sm_toggle_alarm(char key)
{  
  LCDClear(); // clear LCD screen
  if(is_pao_sign(key) == TRUE) // key = '#' -> toggle
  {
    if(AlarmEn == 1) // alarm currently on, turn it off
    {
      AlarmEn = 0;
      // clear the alarm symbol on lcd      
      LCDPrintCharAt(1,15,' ');
    }
    else // alarm currently off, turn it on
    {
      AlarmEn = 1;
      // show the alarm symbol on lcd
      LCDPrintCharAt(1,15,'.');
    }
  }
  else if(is_star_key(key) == TRUE) // key = '*' ?
  {
    if((AlarmEn == 1)&&(AlarmOn == 1))  // press '*' key during alarm is on ?
    {
      AlarmTime = getCurTime() + SNOOZE_TIME;
      AlarmOn = 0;
      DisplayTimeOn = TRUE; // current time will auto display if DisplayTimeOn = TRUE
      LCDClear();
    }
    else // exit submenu
    {
      DisplayTimeOn = FALSE;
      ModeSel = MAIN_MENU; //  set current menu to selected menu
      menu_key_process(NO_KEY); // display selected menu
      return;      
    }
  }
  // display submenu toogle alarm
  // display current time
  LCDPrintStrAt(1,0,"Toggle Alarm:");
  LCDPrintStrAt(2,2,curTimeStr);
}

// displaying/processing key input for setting menu
void sm_setting(int key)
{
  static char idx = 0;
  if(is_star_key(key) == TRUE) // key = '*' -> go to next menu item
  {
    idx++;
    idx = (idx > 3) ? 0 : idx;
  }
  else
  {
    if(is_pao_sign(key) == TRUE) // key = '#'
    {
      ModeSel = setting[idx]; // set current menu to selected menu
      menu_key_process(NO_KEY); // display selected menu
      return;
    }
  }
  LCDClear();
  LCDPrintStrAt(1,0,"Setting:");
  LCDPrintStrAt(2,2,s_setting[idx]);
}

// process key input for setting current/alarm time
char set_time(char key)
{
  static unsigned char digit = 0;
  switch(digit)
  {
    case 0: // ten of hour "X0:00:00 AM"
      if(is_valid_hr(key,TEN,hr_mode) == TRUE)
      {
        timestr[0] = key;
      }
      else
      {
        if((is_pao_sign(key) == TRUE)&&(is_valid_hr(timestr[0],TEN,hr_mode) == TRUE))
        {          
          digit++;
        }
      }
      break;
    case 1: // one of hour "0X:00:00 AM"
      if(is_valid_hr(key,ONE,hr_mode) == TRUE)
      {
        timestr[1] = key;
        timestr[2] = ':';
      }
      else
      {
        if((is_pao_sign(key) == TRUE)&&(is_valid_hr(timestr[1],ONE,hr_mode) == TRUE))
        {
          digit += 2;
        }
      }
      break;
    case 3: // ten of min "00:X0:00 AM"
      if(is_valid_min_sec(key,TEN) == TRUE)
      {
        timestr[3] = key;
      }
      else
      {
        if((is_pao_sign(key) == TRUE)&&(is_valid_min_sec(timestr[3],TEN) == TRUE))
        {
          digit++;
        }
      }
      break;
    case 4: // one of min "00:0X:00 AM"
      if(is_valid_min_sec(key,ONE) == TRUE)
      {
        timestr[4] = key;
        timestr[5] = ':';
      }
      else
      {
        if((is_pao_sign(key) == TRUE)&&(is_valid_min_sec(timestr[4],ONE) == TRUE))
        {
          digit += 2;
        }
      }
      break;
    case 6: // ten of sec "00:00:X0 AM"
      if(is_valid_min_sec(key,TEN) == TRUE)
      {
        timestr[6] = key;
      }
      else
      {
        if((is_pao_sign(key) == TRUE)&&(is_valid_min_sec(timestr[6],TEN) == TRUE))
        {
          digit++;
        }
      }
      break;
    case 7: // one of sec "00:00:0X AM"
      if(is_valid_min_sec(key,ONE) == TRUE)
      {
        timestr[7] = key;
        timestr[8] = ' ';
      }
      else
      {
        if((is_pao_sign(key) == TRUE)&&(is_valid_min_sec(timestr[7],ONE) == TRUE))
        {
          digit += 2;
        }
      }
      break;
    case 9: // AM/PM "00:00:00 XM"
      if((is_num_key(key))||(is_star_key(key))) // toggle between AM/PM
      {
        timestr[9] = (timestr[9] == 'A') ? 'P' : 'A';        
        timestr[10] = 'M';
      }
      else
      {
        if(is_pao_sign(key) == TRUE) // accept setting time ?
        {
          digit = 0; // set to first digit for next time setting                    
          ModeSel = SM_2_SETTING; // go back to setting menu
          sm_setting(NO_KEY); // print out setting menu
          return '#'; // time setting is done
        }
      }
      break;
  }  
  return digit; // setting (current/alarm) time str is not ready
}

// use for setting current time
void sm_set_time(char key)
{
  char k;
  k = set_time(key);
  if(k == '#') // finish setting current time yet ?
  {
    CurrentTime = strToTime(timestr);// set current time to setting time in timestr[]    
    setCurTime(CurrentTime);
  }
  else // display what user currently type in
  {
    LCDClear();
    LCDPrintStrAt(1,0,"Set Time:");
    LCDPrintStrAt(2,2,timestr);
    LCDSetCurPos(2,(2+k));
  }
}

void sm_set_alarm(char key)
{
  char k;
  k = set_time(key);
  if(k == '#') // finish setting alarm time yet ?
  {
    AlarmTime = strToTime(timestr); // set alarm time to alarm setting time in timestr[]
  }
  else // display what user currently type in
  {
    LCDClear();
    LCDPrintStrAt(1,0,"Alarm Time:");
    LCDPrintStrAt(2,2,timestr);
    LCDSetCurPos(2,(2+k));      
  }
}

// use for setting time display mode: 12/24 hour
void sm_set_display_mode(char key)
{
  if((is_num_key(key))||(is_star_key(key))) // toggle between AM/PM
  {
    hr_mode = (hr_mode == HR_MODE_24) ? HR_MODE_12 : HR_MODE_24;
  }
  else
  {
    if(is_pao_sign(key) == TRUE) // accept setting hour mode ?
    {
      ModeSel = SM_2_SETTING;
      sm_setting(NO_KEY);
      return;
    }
  }  
  LCDClear();
  LCDPrintStrAt(1,0,"Display Mode:");
  timeToStr(CurrentTime,curTimeStr,hr_mode); // convert current time str to 12/24 according to hour mode
  LCDPrintStrAt(2,2,curTimeStr); // show time on lcd
}

void menu_key_process(char key)
{
  switch(ModeSel)
  {
    case MAIN_MENU:
      main_menu(key);
      break;
    case SM_1_TOGGLE_ALARM: // alarm on/off submenu, press # to toggle
      sm_toggle_alarm(key);
      break;
    case SM_2_SETTING: // setting submenu, press * to cycle thru, # to select
      sm_setting(key);
      break;
    case SM_2A_SET_TIME: // process key input for setting current time
      sm_set_time(key);
      break;
    case SM_2B_SET_ALARM: // process key input for setting alarm time
      sm_set_alarm(key);
      break;
    case SM_2C_SET_DISPLAY_MODE: // process key input for displaying 12/24hr mode
      sm_set_display_mode(key);
      break;
    case SM_2D_BACK: // go back to main menu
      ModeSel = MAIN_MENU;
      main_menu(NO_KEY); // print out main menu
      break;
    case SM_3_EXIT: // exit the main menu, go back to show current time
      DisplayTimeOn = TRUE; // current time will auto display if DisplayTimeOn = TRUE
      LCDClear();
      break;
  }
}
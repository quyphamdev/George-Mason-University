#include "c_const.h"
#include "time.h"

// global vars
char ten_of_hr; // keep the value of: ten of hr, ten of min, ten of sec. for later check one of...    
char one_of_hr;

void initRTC(int yr, unsigned char mon, unsigned char day, unsigned char hr, unsigned char min, unsigned char sec)
{
  RTCCTL = BIT5|BIT4; // calendar clock mode
  // set clock to current time
  RTCYEAR = yr;
  RTCMON = mon;
  RTCDAY = day;
  RTCHOUR = hr;
  RTCMIN = min;
  RTCSEC = sec;
}

unsigned long getCurTime()
{
  return (unsigned long)RTCHOUR*60*60 + (unsigned long)RTCMIN*60 + (unsigned long)RTCSEC;
}

void setCurTime(unsigned long ct)
{
  RTCHOUR = getHour(ct);
  RTCMIN = getMin(ct);
  RTCSEC = getSec(ct);
}

char getHour(unsigned long ct)
{
  return (char)(ct/3600);
}

char getMin(unsigned long ct)
{
  return (char)((ct%3600)/60);
}

char getSec(unsigned long ct)
{
  return (char)((ct%3600)%60);
}

void timeToStr(unsigned long t,char *s,char hm) // time, string[11], hr_mode
{
  char hr,min,sec;
  hr = getHour(t);
  min = getMin(t);
  sec = getSec(t);
  if(hm == HR_MODE_12)
  {
    if(hr > 12)
    {
      hr -= 12;
      s[9] = 'P';
    }
    else
    {
      s[9] = 'A';
    }
    s[10] = 'M';
  }
  else // 24 hr mode
  {
    s[9] = ' ';
    s[10] = ' ';
  }
  if(hr <= 9)
    s[0] = ' ';
  else
    s[0] = hr/10 + 0x30;
  s[1] = hr%10 + 0x30;
  s[2] = ':';
  s[3] = min/10 + 0x30;
  s[4] = min%10 + 0x30;
  s[5] = ':';
  s[6] = sec/10 + 0x30;
  s[7] = sec%10 + 0x30;
  s[8] = ' ';
}

unsigned long strToTime(char *st) // "00:00:00 AM"
{
  unsigned long hr,min,sec;
  if(st[0] == ' ')
    hr = st[1]-0x30;
  else
    hr = (st[0]-0x30)*10 + (st[1]-0x30);
  min = (st[3]-0x30)*10 + (st[4]-0x30);
  sec = (st[6]-0x30)*10 + (st[7]-0x30);
  if((hr < 12)&&(st[9] == 'P'))
  {
    hr += 12;
  }
  return (hr*3600+min*60+sec);
}


char is_valid_hr(char key, char digit, char hrm)
{
  if(digit == TEN) // ten of hour
  {
    ten_of_hr = key;
    if(hrm == HR_MODE_24) // 24 hour mode
    {
      if((key >= KEY_0)&&(key <= KEY_2))
      {
        return TRUE;
      }
      else return FALSE;
    }
    else // hrm == 12 hour mode
    {
      if((key >= KEY_0)&&(key <= KEY_1))
      {
        return TRUE;
      }
      else return FALSE;
    }
  }
  else // digit == one of hour
  {
    one_of_hr = key;
    if(hrm == HR_MODE_24) // 24 hour mode
    {
      if(ten_of_hr == KEY_2) // ten of hr is a number 2
      {
        if((key >= KEY_0)&&(key <= KEY_3))
        {
          return TRUE;
        }
        else return FALSE;
      }
      else // ten of hour is 0 or 1
      {
        if((key >= KEY_0)&&(key <= KEY_9))
        {
          return TRUE;
        }
        else return FALSE;
      }
    }
    else // 12 hour mode
    {
      if(ten_of_hr == KEY_1) // ten of hr is a number 1
      {
        if((key >= KEY_0)&&(key <= KEY_2)) // then one of hr should be 0..2
        {
          return TRUE;
        }
        else return FALSE;
      }
      else // ten of hour is 0
      {
        if((key >= KEY_0)&&(key <= KEY_9)) // then one of hr is 0..9
        {
          return TRUE;
        }
        else return FALSE;
      }
    }
  }
}

char is_valid_min_sec(char key, char digit)
{
  if(digit == TEN)
  {
    if((key >= KEY_0)&&(key <= KEY_5))
    {
      return TRUE;
    } else return FALSE;
  }
  else
  {
    if((key >= KEY_0)&&(key <= KEY_9))
      return TRUE;
    else return FALSE;
  }
}

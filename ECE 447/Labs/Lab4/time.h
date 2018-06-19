
void initRTC(int yr, unsigned char mon, unsigned char day, unsigned char hr, unsigned char min, unsigned char sec);
unsigned long getCurTime();
void setCurTime(unsigned long ct);
char getHour(unsigned long ct);
char getMin(unsigned long ct);
char getSec(unsigned long ct);
void timeToStr(unsigned long t,char *s,char hm); // time, string[11], hr_mode
unsigned long strToTime(char *st); // "00:00:00 AM"
char is_valid_hr(char key, char digit, char hrm);
char is_valid_min_sec(char key, char digit);

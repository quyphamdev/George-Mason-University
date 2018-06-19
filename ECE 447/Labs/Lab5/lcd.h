// constants
#define RS BIT0
#define RW BIT1
#define E BIT2
#define BF BIT7

// function prototypes
void delay();
char isLCDBusy(); // check if LCD is currently execute any instruction
void LCDClear(); // clear LCD screen
void LCDDisplay(char DisplayOn, char CursorOn, char CurBlinkOn); // set up LCD
void LCDFuncSet(); //8-bit data len, 2-line display, font type 5x8
void LCDInit(); // initialize LCD, call this function before calling other LCD func
void LCDReturnHome(); // move cursor to the top left corner
void LCDEntryModeSet();// cursor/blink move to right and DDRAM addr inc by 1, no shift
void LCDSetCurPos(char row, char col);
void LCDPrintChar(char c);
void LCDPrintCharAt(char row, char col, char c);
void LCDPrintStr(char *s);
void LCDPrintStrAt(char row, char col, char *s);

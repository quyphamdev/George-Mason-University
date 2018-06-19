#include "asm_const.h"

; this is for the alarm when speed > 65 MPH.
; used port 3.5

    PUBLIC SetBuzzerOn ; make it public so other file could call it
    PUBLIC SetBuzzerOff
    RSEG    CODE
    
    // Timer on CCR4              out to buzzer(active low)
    //    |-------|      |------  this waveform goes out to P3.5 pin
    // ___|       |______|
SetBuzzerOn:
    MOV.W   #64,&TBCCR1 ; 32KHZ/500Hz = 64 cycles
    MOV.W   #29,&TBCCR4 ; 45% of a cycle (64*45/100=28.8 ~ 29)
    MOV.W   #TBSSEL_1|CNTL_3|ID_0|MC_1|TBCLR,&TBCTL ; ACLK, 8-bit counter, div /1, upmode, clear TAR
    MOV.W   #OUTMOD_3,&TBCCTL4 ; set/reset
    BIS.B   #BIT5,&P3DIR ; set P3.5 = output
    BIS.B   #BIT5,&P3SEL ; set P3.5 to timer output
    RETA
    
SetBuzzerOff:
    BIC.B   #BIT5,&P3SEL
    RETA
    
    END
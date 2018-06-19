#include "asm_const.h"
; generate sensor pulse and output it to port 3.4

    PUBLIC SetSensor
    RSEG    CODE
    
    // Timer on CCR4              out to buzzer(active low)
    //    |-------|      |------  this waveform goes out to P3.5 pin
    // ___|       |______|
SetSensor:
    MOV.W   #128,&TBCCR0 ; 128 pulses
    MOV.W   #64,&TBCCR1 ; 50% of a cycle (128*50/100=64)
    MOV.W   #TBSSEL_1|CNTL_3|ID_0|MC_1|TBCLR,&TBCTL ; ACLK, 8-bit counter, div /1, upmode, clear TAR
    MOV.W   #OUTMOD_3,&TBCCTL1 ; set/reset
    BIS.B   #BIT4,&P3DIR ; set P3.4 = output
    BIS.B   #BIT4,&P3SEL ; set P3.4 to timer output
    BIS.B   #CCIE,&TBCCTL1 ; set interrupt on CCR4
    RETA

    END
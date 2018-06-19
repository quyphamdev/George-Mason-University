#include "asm_const.h"
#include "msp430xG46x.h"

    EXTERN BuzzerFreq
    EXTERN BuzzerPwm
    PUBLIC SetBuzzerOn ; make it public so other file could call it
    PUBLIC SetBuzzerOff
    RSEG    CODE
    
    // Timer on CCR4              out to buzzer(active low)
    //    |-------|      |------  this waveform goes out to P3.5 pin
    // ___|       |______|
SetBuzzerOn:
    MOV.W   &BuzzerFreq,&TBCCR0 ; 32KHZ/500Hz = 64 cycles
    MOV.W   &BuzzerPwm,&TBCCR4 ; 40% of a cycle (64*40/100=25.6 ~ 26)
    MOV.W   #TBSSEL_1|CNTL_0|ID_0|MC_1|TBCLR,&TBCTL ; ACLK, 16-bit counter, div /1, upmode, clear TAR
    MOV.W   #OUTMOD_3,&TBCCTL4 ; set/reset
    BIS.B   #BIT5,&P3DIR ; set P3.5 = output
    BIS.B   #BIT5,&P3SEL ; set P3.5 to timer output
    RETA
    
SetBuzzerOff:
    BIC.B   #BIT5,&P3SEL
    RETA
    
    END
#include "asm_const.h"

        ;PUBLIC  SetBtnISR ; so other file could call this function
        EXTERN  TimerEnFlag ; external variable for determining timer is currently enable or disable
        EXTERN  Timer5SecDelayEn
        EXTERN  IncTimer  ; func locate in timer_isr.c: inc timer by 10,20 or 30 depends on current timer
        EXTERN  SetBuzzerOff ; func locate in buzzer_pwm_isr.asm: set buzz sound off        

        RSEG    CODE                    ; place program in 'CODE' segment

;------------------------------------------------
BTNPUSH_ISR:    
    BIT.B   #BIT0,&P1IFG ; if btn SW1 is pressed ?
    JNZ     EN_BTN
    BIT.B   #BIT1,&P1IFG ; if btn SW2 is pressed ?
    JNZ     INC_COUNT_BTN  
    JMP     RESET_IF ; no btn is pressed, clear interrupt flag general and then exit
  EN_BTN:
    INV.B   &TimerEnFlag
    CALLA   #SetBuzzerOff ; when enable btn is pressed, turn buzz off
    JMP     RESET_IF
  INC_COUNT_BTN:
    CALLA   #SetBuzzerOff ; when increase timer btn is pressed, turn buzz off
    CALLA   #IncTimer ; func locate in timer_isr.c: inc timer by 10,20 or 30 depends on current timer
    MOV.W   #0,&Timer5SecDelayEn
  RESET_IF:
    BIC.B   #BIT0|BIT1,&P1IFG ; clear interrupt flag so it won't jump back to this interrupt routine
    RETI
;------------------------------------------------
    COMMON  INTVEC
    ORG     PORT1_VECTOR
    DW      BTNPUSH_ISR
    END

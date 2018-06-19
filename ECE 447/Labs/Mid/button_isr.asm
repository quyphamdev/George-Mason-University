#include "asm_const.h"

        ;PUBLIC  SetBtnISR ; so other file could call this function
        EXTERN  CheckModeSwitch   

        RSEG    CODE                    ; place program in 'CODE' segment

;------------------------------------------------
BTNPUSH_ISR:    
    BIT.B   #BIT0,&P1IFG ; if btn SW1 is pressed ?
    JNZ     MODE_SWITCH
    JMP     RESET_IF ; no btn is pressed, clear interrupt flag general and then exit
  MODE_SWITCH:    
    CALLA   #CheckModeSwitch ; switching mode, function locate in button.c
  RESET_IF:
    ;XOR.B   #BIT0,&P1IES ; switch between rising and falling edge
    BIC.B   #BIT0,&P1IFG ; clear interrupt flag so it won't jump back to this interrupt routine
    RETI
;------------------------------------------------
    COMMON  INTVEC
    ORG     PORT1_VECTOR
    DW      BTNPUSH_ISR
    END

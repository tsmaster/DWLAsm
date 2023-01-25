;;; Chapter 8 Program 8.3
;;; UNPK & MULT

        .ORG $800
        .OUT "prog_8_03.obj"

movmi:  .EQU $EAF9
lmult:  .EQU $E97F
        
begin:  LDY #$EE
        LDA #$64
        JSR movmi
        LDY #$E9
        LDA #$37
        JSR lmult
        BRK
        

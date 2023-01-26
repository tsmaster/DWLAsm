;;; Chapter 8 Program 8.14
;;; Conversion CMIE

        .ORG $800
        .OUT "prog_8_14.obj"

cmie:   .EQU $EBF2
movmi:  .EQU $EAF9
        
begin:  LDY #$ED                ; page part of 1 billion
        LDA #$14                ; loc on page of 1 billion
        JSR movmi               ; move it to MFAC
        JSR cmie                ; do the conv into 9E-A1
        BRK                     ; call monitor

        

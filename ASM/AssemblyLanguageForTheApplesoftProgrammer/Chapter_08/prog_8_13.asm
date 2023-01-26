;;; Chapter 8 Program 8.13
;;; Conversion CMI

        .ORG $800
        .OUT "prog_8_13.obj"

cmi:    .EQU $E10C
movmi:  .EQU $EAF9
        
begin:  LDY #$F0                ; page part of 2*pi
        LDA #$6B                ; loc on page of 2*pi
        JSR movmi               ; move it to MFAC
        JSR cmi                 ; do the conv into A0,A1
        BRK                     ; call monitor

        

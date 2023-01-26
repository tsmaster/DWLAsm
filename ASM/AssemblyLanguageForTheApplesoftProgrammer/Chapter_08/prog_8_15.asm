;;; Chapter 8 Program 8.15
;;; Conversion CLIM

        .ORG $800
        .OUT "prog_8_15.obj"

clim:   .EQU $DEE9
        
begin:  LDA #$00                ; initialize
        STA $4000               ; loc with the
        LDA #$05                ; integer to be
        STA $4001               ; converted
        LDA #$40                ; establish its
        STA $A1                 ; address for
        LDA #$00                ; use with the
        STA $A0                 ; subroutine CLIM
        JSR clim                ; do conv into mfac
        BRK                     ; call monitor

        
        

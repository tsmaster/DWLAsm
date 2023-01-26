;;; Chapter 8 Program 8.8
;;; POWER & MOVES

        .ORG $300
        .OUT "prog_8_08.obj"

movsi:  .EQU $E9E3
movmi:  .EQU $EAF9
movmo:  .EQU $EB2B
power:  .EQU $EE97
        
begin:  LDY /datax              ; var addr, hi
        LDA #datax              ; var addr, lo
        JSR movmi               ; copy to MFAC
        LDY /datay              ; var addr, hi
        LDA #datay              ; var addr, lo
        JSR movsi               ; (Y,A) -> SFAC
        JSR power               ; (SFAC) ^ (MFAC) -> MFAC
        LDY /dataz              ; var addr, hi
        LDX #dataz              ; var addr, lo
        JSR movmo               ; MFAC -> (Y,X)
        BRK
        
datax:  .HS 844BAE147B
datay:  .HS 8440000000
dataz:  .HS 0000000000
        

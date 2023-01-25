;;; Chapter 8 Program 8.6
;;; LSUB & MOVE

        .ORG $300
        .OUT "prog_8_06.obj"

lsub:   .EQU $E7A7
movmi:  .EQU $EAF9
        
begin:  LDY /datax              ; var addr, hi
        LDA #datax              ; var addr, lo
        JSR movmi               ; copy to MFAC
        LDY /datay              ; var addr, hi
        LDA #datay              ; var addr, lo
        JSR lsub                ; (Y,A) -> MFAC, SFAC - MFAC -> MFAC
        BRK
        
datax:  .HS 8440000000
datay:  .HS 78D25EDD03
        

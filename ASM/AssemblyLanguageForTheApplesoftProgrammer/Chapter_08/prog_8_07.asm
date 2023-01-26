;;; Chapter 8 Program 8.7
;;; LDIV & PRNTFAC

        .ORG $300
        .OUT "prog_8_07.obj"

ldiv:    .EQU $EA66
movmi:   .EQU $EAF9
prntfac: .EQU $ED2E
        
begin:  LDY /datax              ; var addr, hi
        LDA #datax              ; var addr, lo
        JSR movmi               ; copy to MFAC
        LDY /datay              ; var addr, hi
        LDA #datay              ; var addr, lo
        JSR ldiv                ; (Y,A) -> SFAC, SFAC/MFAC -> MFAC
        JSR prntfac
        RTS
        
datax:  .HS 78D25EDD03
datay:  .HS 6B9DC68F46
        

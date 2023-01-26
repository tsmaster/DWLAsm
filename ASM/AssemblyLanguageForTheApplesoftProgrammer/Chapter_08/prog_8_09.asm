;;; Chapter 8 Program 8.9
;;; SQR; USES LOMEM
;;; LINK WITH BASIC EXAMPLE 8.9a

        .ORG $300
        .OUT "prog_8_09.obj"

movmi:  .EQU $EAF9
movmo:  .EQU $EB2B
sqr:    .EQU $EE8D
        
begin:  LDY #$20                ; addr of
        LDA #$02                ;   var #1
        JSR movmi               ; (Y,A) -> MFAC
        JSR sqr                 ; SQR(MFAC) -> MFAC

        LDY #$20                ; addr of
        LDX #$09                ;   var #2
        JSR movmo               ; MFAC -> (Y,X)
        RTS
        

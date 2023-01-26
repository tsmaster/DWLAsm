;;; Chapter 8 Program 8.17
;;; MSTAK and STAKS

        .ORG $800
        .OUT "prog_8_17.obj"

mstak:  .EQU $DE10
staks:  .EQU $DE47
movmi:  .EQU $EAF9
        
begin:  LDY #$E9                ; page part of sqrt(2)
        LDA #$32                ; loc on pg of sqrt(2)
        JSR movmi               ; move it to MFAC
        LDA /end                ; set up
        PHA                     ; the return
        LDA #end                ; from
        PHA                     ; staks
        JSR mstak               ; MFAC -> stack
        JMP staks               ; note JMP not JSR
        RTS
end:    BRK

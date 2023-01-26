;;; Chapter 8 Program 8.16
;;; Stack Saves

        .ORG $800
        .OUT "prog_8_16.obj"

mstak:  .EQU $DE10
movmi:  .EQU $EAF9
save:   .EQU $4000
        
begin:  LDY #$E9                ; page part of sqrt(2)
        LDA #$32                ; loc on pg of sqrt(2)
        JSR movmi               ; move it to MFAC
        TSX                     ; put next stack address in X
        STX save                ; save it
        JSR mstak               ; push MFAC onto the stack
        BRK

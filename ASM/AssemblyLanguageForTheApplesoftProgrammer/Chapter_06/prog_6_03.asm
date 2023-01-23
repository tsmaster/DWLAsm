;;; Chapter 6 Program 6.3
;;; Logical ORA (inclusive or)

        .ORG $800
        .OUT "prog_6_03.obj"

eor:    LDA #$33
        ORA #$BB
        BRK
        

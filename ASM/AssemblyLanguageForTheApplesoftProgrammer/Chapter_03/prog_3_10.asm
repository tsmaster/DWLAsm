;;; Chapter 3 Program 3.10
;;; Program Counter Register (PCR)

        .ORG $800
        .OUT "prog_3_10.obj"

pcr:    TSX
        TXA
        TAY
        JSR stk
        LDA #$AA
        BRK
stk:    LDA #$BB
        LDA #$CC
        BRK

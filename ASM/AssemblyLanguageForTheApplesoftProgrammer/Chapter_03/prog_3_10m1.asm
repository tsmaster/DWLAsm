;;; Chapter 3 Program 3.10m1
;;; Program Counter Register (PCR)

        .ORG $800
        .OUT "prog_3_10m1.obj"

pcr:    TSX
        TXA
        TAY
        JSR stk
        BRK
stk:    PLA
        TAY
        PLA
        TAX
        PHA
        TYA
        PHA
        RTS

;;; Chapter 3 Program 3.9
;;; stack

        .ORG $800
        .OUT "prog_3_09.obj"

pull:   CLC
        TSX
        TXA
        LDA #$86
        PHA
        PHP
        PLA
        BRK

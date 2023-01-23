;;; Chapter 6 Program 6.2
;;; Logical EOR (xor)

        .ORG $800
        .OUT "prog_6_02.obj"

eor:    LDA #$33
        EOR #$BB
        BRK
        

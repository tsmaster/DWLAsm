;;; Chapter 6 Program 6.4
;;; Logical BIT

        .ORG $800
        .OUT "prog_6_04.obj"

bit:    LDA #$BB
        STA $07
        LDA #$77
        BIT $07
        BRK
        

;;; Chapter 6 Program 6.8
;;; move bits in byte

        .ORG $800
        .OUT "prog_6_08.obj"

rol:    SEC
        LDA #$56
        STA $3FF8
        ROR $3FF8
        BRK
        

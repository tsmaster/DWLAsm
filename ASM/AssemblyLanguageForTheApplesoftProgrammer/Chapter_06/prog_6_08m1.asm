;;; Chapter 6 Program 6.8m1
;;; move bits in byte

        .ORG $800
        .OUT "prog_6_08m1.obj"

rol:    SEC
        LDA #$56
        STA $3FF8
        ROR $3FF8
        ROR $3FF8
        BRK
        

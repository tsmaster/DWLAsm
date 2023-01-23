;;; Chapter 6 Program 6.6
;;; move bits in byte

        .ORG $800
        .OUT "prog_6_06.obj"

lsr:    LDA #$51
        STA $3FF8
        LSR $3FF8
        BRK
        

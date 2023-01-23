;;; Chapter 6 Program 6.6m1
;;; move bits in byte

        .ORG $800
        .OUT "prog_6_06m1.obj"

lsr:    LDA #$51
        STA $3FF8
        LSR $3FF8
        LSR $3FF8
        BRK
        

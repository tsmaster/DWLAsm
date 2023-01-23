;;; Chapter 6 Program 6.5m3
;;; move bits in byte

        .ORG $800
        .OUT "prog_6_05m3.obj"

asl:    LDA #$43
        ASL
        ASL
        ASL
        ASL
        BRK
        

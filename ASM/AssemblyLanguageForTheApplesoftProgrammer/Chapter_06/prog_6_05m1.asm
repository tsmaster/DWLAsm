;;; Chapter 6 Program 6.5m1
;;; move bits in byte

        .ORG $800
        .OUT "prog_6_05m1.obj"

asl:    LDA #$43
        ASL
        ASL
        BRK
        

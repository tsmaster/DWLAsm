;;; Chapter 6 Program 6.5m2
;;; move bits in byte

        .ORG $800
        .OUT "prog_6_05m2.obj"

asl:    LDA #$03
        ASL
        ASL
        ASL
        BRK
        

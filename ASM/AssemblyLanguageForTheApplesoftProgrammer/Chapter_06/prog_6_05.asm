;;; Chapter 6 Program 6.5
;;; move bits in byte

        .ORG $800
        .OUT "prog_6_05.obj"

asl:    LDA #$43
        ASL
        BRK
        

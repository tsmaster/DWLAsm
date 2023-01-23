;;; Chapter 6 Program 6.7
;;; move bits in byte

        .ORG $800
        .OUT "prog_6_07.obj"

rol:    SEC
        LDA #$56
        ROL
        BRK
        

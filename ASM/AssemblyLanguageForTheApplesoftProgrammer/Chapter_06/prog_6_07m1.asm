;;; Chapter 6 Program 6.7m1
;;; move bits in byte

        .ORG $800
        .OUT "prog_6_07m1.obj"

rol:    SEC
        LDA #$56
        ROL
        ROL
        BRK
        

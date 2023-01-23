;;  Chapter 3 Program 3.3
;;  subtract

        .ORG $800
        .OUT "prog_3_03.obj"
        
sub:    CLC
        SED
        LDA #$86
        SBC #$13
        BRK
        

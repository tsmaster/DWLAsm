;;  Chapter 3 Program 3.2
;;  subtract

        .ORG $800
        .OUT "prog_3_02.obj"
        
sub:    SEC
        SED
        LDA #$86
        SBC #$13
        BRK
        

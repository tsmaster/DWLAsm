;;  Chapter 3 Program 3.4
;;  subtract

        .ORG $800
        .OUT "prog_3_04.obj"
        
sub:    SEC
        SED
        LDA #$86
        SBC #$87
        BRK
        

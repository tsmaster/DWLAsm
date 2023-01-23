;;  Chapter 3 Program 3.6
;;  subtract

        .ORG $800
        .OUT "prog_3_06.obj"
        
sub:    SEC
        CLD
        LDA #$86
        SBC #$87
        BRK
        

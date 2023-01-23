;;  Chapter 3 Program 3.5
;;  subtract

        .ORG $800
        .OUT "prog_3_05.obj"
        
sub:    SEC
        CLD
        LDA #$86
        SBC #$0A
        BRK
        

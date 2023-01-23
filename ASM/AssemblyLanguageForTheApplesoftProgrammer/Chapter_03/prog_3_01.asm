;;  Chapter 3 Program 3.1
;;  add

            .ORG $800
            .OUT "prog_3_01.obj"
        
sum:    CLC
        SED
        LDA #$86
        ADC #$13
        BRK
        

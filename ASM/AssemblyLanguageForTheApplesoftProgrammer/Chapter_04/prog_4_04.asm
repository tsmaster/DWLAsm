;;; Chapter 4 Program 4.4
;;; ADD ABSOLUTE

        .ORG $800
        .OUT "prog_4_04.obj"

sum:    CLC
        SED
        LDA #$13
        STA $4000
        LDA #$86
        ADC $4000
        STA $4001
        BRK
        

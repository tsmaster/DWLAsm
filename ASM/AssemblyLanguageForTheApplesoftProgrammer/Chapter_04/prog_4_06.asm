;;; Chapter 4 Program 4.6
;;; ADD ABSOLUTE,X

        .ORG $800
        .OUT "prog_4_06.obj"

sum:    CLC
        SED
        LDA #$13
        STA $4000
        LDA #$86
        LDX #$20
        ADC $3FE0,X
        STA $4001
        BRK
        

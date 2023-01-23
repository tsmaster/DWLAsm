;;; Chapter 4 Program 4.5
;;; ADD ZERO-PAGE,X

        .ORG $800
        .OUT "prog_4_05.obj"

sum:    CLC
        SED
        LDA #$13
        STA $6F
        LDA #$86
        LDX #$5A
        ADC $15,X
        STA $06
        BRK
        

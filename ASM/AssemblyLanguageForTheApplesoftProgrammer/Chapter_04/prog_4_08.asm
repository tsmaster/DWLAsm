;;; Chapter 4 Program 4.8
;;; ADD (ZERO PAGE,X)

        .ORG $800
        .OUT "prog_4_08.obj"

sum:    CLC
        SED
        LDA #$40
        STA $E9
        LDA #$07
        STA $E8
        LDA #$13
        STA $4007
        LDA #$86
        LDX #$20
        ADC ($C8,X)
        STA $4001
        BRK
        

;;; Chapter 4 Program 4.3
;;; ADD (ZERO-PAGE)

        .ORG $800
        .OUT "prog_4_03.obj"

sum:    CLC
        SED
        LDA #$13
        STA $06
        LDA #$86
        ADC $06
        STA $07
        BRK
        

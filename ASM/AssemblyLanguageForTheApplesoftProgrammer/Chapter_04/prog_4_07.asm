;;; Chapter 4 Program 4.7
;;; ADD (ZERO PAGE),Y

        .ORG $800
        .OUT "prog_4_07.obj"

sum:    CLC
        LDA #$3F
        STA $07
        LDA #$E0
        STA $06
        LDA #$13
        STA $4000
        LDA #$86
        LDY #$20
        ADC ($06),Y
        STA $4001
        BRK

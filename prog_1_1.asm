        ;; program 1.1 The Apple Bell

        ORG $FBE2

        LDY #$C0
loop:   LDA #$0C
        JSR $FCA8
        LDA $C030
        DEY
        BNE loop
        RTS
        

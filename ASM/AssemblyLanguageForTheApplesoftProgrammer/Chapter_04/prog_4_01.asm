;;; Chapter 4 Program 4.1
;;; JUMPS

        .ORG $800
        .OUT "prog_4_01.obj"

jmps:   LDA #$08
        STA $3FFF
        LDA #$11
        STA $3FFE
        TSX
        TXA
        TAY
        JMP ($3FFE)
        BRK
stk:    PLA
        TAY
        PLA
        TAX
        PHA
        TYA
        PHA
        LDA #$00
        BRK
        

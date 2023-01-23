;;; Chapter 3 Program 3.7
;;; DEMO (?)

        .ORG $800
        .OUT "prog_3_07.obj"

x:      CLC
y:      LDX #$05
        LDY #$15
        LDA #$00
        TXA
        INX
        DEY
        BRK
        

;;; Chapter 4 Program 4.2
;;; REL ADR

        .ORG $800
        .OUT "prog_4_02.obj"

top:    LDA #$DD
        BRK
brch:   CLC
        BCC here
        LDA #$11
        LDX #$22
        LDY #$33
        BRK
here:   SEC
        LDA #$AA
        LDX #$BB
        LDY #$CC
        BCS top
        

;;; Chapter 3 Program 3.11
;;; Branch

        .ORG $800
        .OUT "prog_3_11.obj"

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
        BRK

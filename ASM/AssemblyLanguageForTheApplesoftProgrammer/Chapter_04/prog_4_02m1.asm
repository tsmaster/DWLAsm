;;; Chapter 4 Program 4.2m1
;;; REL ADR DOES NOT BUILD, * for PC NOT SUPPORTED

        .ORG $800
        .OUT "prog_4_02m1.obj"

top:    LDA #$DD
        BRK
brch:   CLC
        BCC *+$9
        LDA #$11
        LDX #$22
        LDY #$33
        BRK
here:   SEC
        LDA #$AA
        LDX #$BB
        LDY #$CC
        BCS *-$14
        

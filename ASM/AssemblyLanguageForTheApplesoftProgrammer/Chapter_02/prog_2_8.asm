;;  Chapter 2 Program 2.8
;;  tone subroutine BROKEN B/C FORWARD REFERENCE

            .ORG $300
            .OUT "prog_2_8.obj"
        
spkr:       .EQU $C030
counter:    .EQU $06
pitch:      .EQU $07


tweak:  LDA spkr
        LDX pitch
count:  DEY                     ; another counter
        BNE freq                ; 256 DEYs
        DEC counter
        BEQ done
freq:   DEX
        BNE count
        BEQ tweak
done:   RTS
        

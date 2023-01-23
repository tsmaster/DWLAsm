;;  Chapter 2 Program 2.10
;;  paddle tone

            .ORG $300
            .OUT "prog_2_10.obj"
        
spkr:       .EQU $C030
counter:    .EQU $06
pitch:      .EQU $07
pdl:        .EQU $FB1E

;;; main program
start:  LDA #$20
        STA counter
        LDX #$00                ; read
        JSR pdl                 ; paddle 0
        STA pitch
        JSR tweak
        JMP start

;;; tone subroutine
tweak:  LDA spkr
        LDX pitch
count:  DEY
        BNE freq
        DEC counter
        BEQ done
freq:   DEX
        BNE count
        BEQ tweak
done:   RTS

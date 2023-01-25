;;; Chapter 8 Program 8.1
;;; Normalization

        .ORG $800
        .OUT "prog_8_01.obj"

norm:   .EQU $E82E
        
begin:  LDA #$84                ; exp
        STA $9D
        STA $A5
        LDA #$50                ; mantissa, hi
        STA $9E
        STA $A6
        LDA #$00                ; mantissa, sign
        LDX #$03
loop:   STA $9F,X
        STA $A7,X
        DEX
        BPL loop
        JSR norm
        BRK
        

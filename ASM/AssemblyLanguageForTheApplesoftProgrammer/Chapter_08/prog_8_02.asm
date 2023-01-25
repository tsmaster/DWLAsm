;;; Chapter 8 Program 8.2
;;; Multiplication MFAC & SFAC

        .ORG $800
        .OUT "prog_8_02.obj"

mult:   .EQU $E982
        
begin:  LDA #$84                ; exp
        STA $9D
        STA $A5
        LDA #$80                ; mantissa, hi
        STA $9E
        STA $A6
        LDA #$00                ; mantissa, sign
        LDX #$03
loop:   STA $9F,X               ; fill mantissa
        STA $A7,X
        DEX
        BPL loop
        STA $AB                 ; set $AB and
        STA $AC                 ; $AC to 0
        LDA $9D                 ; also sets Z
        JSR mult                ; (MFAC)*(SFAC) -> (MFAC)
        BRK
        

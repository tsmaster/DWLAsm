;;; Chapter 7 Program 7.5

        .ORG $300
        .OUT "prog_7_05.obj"

;;; set up "&" vector on BRUN

        LDA #$4C
        STA $3F5
        CLC
        LDA $AA72
        ADC #$17                ; $17 plus
        STA $3f6                ; destination of
        LDA $AA73               ; file most
        ADC #$00                ; recently BLOADed
        STA $3F7
        RTS

;;; ----------------------------------------
;;; interpret "&" command string

        LDY #$00
a:      LDA ($B8),Y             ; read character
        LDX #$08                ; test against 8 commands
b:      DEX
        BMI ret                 ; no match, quit
        CMP data,X
        BNE b                   ; not a match
        STA $C050,X             ; toggle soft switch
        INC $B8
        BNE c                   ;   increment txtptr
        INC $B9
c:      BNE a
ret:    RTS
data:   .AS "GTFM12LH"
        
        

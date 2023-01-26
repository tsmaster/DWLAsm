;;; Chapter 10 Program 10.2
;;; prints using ASCII codes

        .ORG $300
        .OUT "prog_10_02.obj"

basl:   .EQU $26
bash:   .EQU $27
home:   .EQU $FC58

;;; --------------------
        JSR home                ; clear screen
        LDA #$80                ; set base
        STA basl                ;   address to
        LDA #$06                ;   $0680
        STA bash                ;   (VTAB 6)
        LDY #$0E                ; HTAB
        LDX #$00
loop:   LDA mesg,X              ; read a character
        BEQ end                 ; if end of message
        STA (basl),Y            ; print character
        INY                     ; inc htab
        INX                     ; inc index
        BNE loop                ; get next character
end:    RTS
mesg:   .HAS "EXAMPLE 10.2"
        .DA $0

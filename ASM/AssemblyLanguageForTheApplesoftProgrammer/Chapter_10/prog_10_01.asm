;;; Chapter 10 Program 10.1
;;; printing on text page 1

        .ORG $300
        .OUT "prog_10_01.obj"

ch:     .EQU $24
cv:     .EQU $25
cout:   .EQU $FDED
vtab:   .EQU $FC22
home:   .EQU $FC58

;;; --------------------
        JSR home                ; clear screen
        LDA #$0E                ; set
        STA ch                  ;   horizontal position
        LDA #$05                ; set
        STA cv                  ;   vertical position
        JSR vtab
        LDX #$00
        
loop:   LDA mesg,X              ; read a character
        BEQ end                 ; if end of message
        JSR cout                ; print it
        INX                     ; inc index
        BNE loop                ; get next character

end:    RTS

mesg:   .HAS "EXAMPLE 10.1"
        .DA $0

        
        

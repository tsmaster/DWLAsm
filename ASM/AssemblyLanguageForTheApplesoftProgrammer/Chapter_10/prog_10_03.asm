;;; Chapter 10 Program 10.3
;;; printing on text page 2

        .ORG $6000
        .OUT "prog_10_03.obj"

indx:   .EQU $07
npgs:   .EQU $08
mesg:   .EQU $08
ch:     .EQU $24
page:   .EQU $26
basl:   .EQU $26
bash:   .EQU $27
kbd:    .EQU $C000
strobe: .EQU $C010
text:   .EQU $C051
pag1:   .EQU $C054
pag2:   .EQU $C055

;;; --------------------
begin:  BIT text                ; display text
        BIT pag2                ;   page2
        JSR clear               ; clear screen
        
;;;  print first message
        LDA #$08                ; htab
        STA ch
        LDA /m1                 ; hi byte of address
        LDY #m1                 ; lo byte of address
        LDX #$02                ; vtab * 2
        JSR print

;;; print second message
        LDA #$0B                ; htab
        STA ch
        LDA /m2                 ; hi byte of address
        LDY #m2                 ; lo byte of address
        LDX #$08                ; vtab * 2
        JSR print

;;; print third message
        LDA #$0E                ; htab
        STA ch
        LDA /m3                 ; hi byte of address
        LDY #m3                 ; lo byte of address
        LDX #$0E                ; vtab * 2
        JSR print

;;; --------------------
.1:     LDA kbd                 ; read keyboard
        BPL .1                  ; if no keypresses
        BIT strobe              ; clear strobe
        BIT pag1                ; display page 1
        RTS                     ; done

;;; --------------------
print:  STY mesg
        STA mesg+1
        LDA addr,X
        STA bash
        INX
        LDA addr,X
        STA basl
        LDY #$00
        STY indx

ploop:  LDY indx
        LDA (mesg),Y            ; read a character
        BEQ end                 ; if end of string
        LDY ch                  ; get htab
        STA (basl),Y            ; store character
        INC ch                  ; for next htab
        INC indx                ; for next character
        BNE ploop               ; if not done
end:    RTS

;;; --------------------
clear:  LDA #$04                ; 4 pages of memory
        STA npgs
        LDA #$08                ; starting with page 8
        STA page+1              ;
        LDY #$00                ; initialize Y and
        STY page                ;   complete page address
        LDA #$A0                ; fill value (SPACE)

loop:   STA (page),Y            ; store it at (page)+Y
        INY                     ; next byte
        BNE loop                ; if not end of page
        INC page+1              ; next page
        DEC npgs                ; counter
        BNE loop                ; if not done
        RTS

;;; --------------------

m1:     .HAS "EXAMPLE 10.3"
        .HS  00
m2:     .HAS "PRINTING MESSAGES"
        .HS  00
m3:     .HAS "ON TEXT PAGE 2"
        .HS  00

addr:   .HS 08000880090009800A000A800B000B80
        .HS 082808A8092809A80A280AA80B280BA8
        .HS 085008D0095009D00A500AD00B500BD0
        
        

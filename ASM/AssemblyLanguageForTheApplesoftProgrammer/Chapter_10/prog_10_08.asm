;;; Chapter 10 Program 10.8
;;; Screen Addressing
;;; and THE GREMLIN

        .ORG $7000
        .OUT "prog_10_08.obj"

width:  .EQU $7FFE
height: .EQU $7FFF
baset:  .EQU $06
baseb:  .EQU $0A
hgr2:   .EQU $F3D8
keyin:  .EQU $FD1B


grem:   LDA #$42                ; page part
        STA baset+1             ;   of top
        STA baseb+1             ;   and bottom
        LDA #$00                ; loc on page  
        STA baset               ;   of top  (line 32)
        LDA #$80                ; loc on page
        STA baseb               ;   of bottom (line 40)
        LDA #$08                ; Gremlin is 8
        STA height              ;   bytes high

        JSR hgr2                ; clear screen to black
        LDX #$00                ; init x, get gremlin index
        
loop0:  LDA #$02                ; the width of the gremlin
        STA width               ; store it
        JSR keyin               ; wait for keypress
        LDY #$00                ; init y, send gremlin index 
loopi:  LDA datgt,X             ; get top of gremlin
        STA (baset),Y             ; send top to screen
        LDA datgb,X             ; get bottom of gremlin
        STA (baseb),Y             ; send bottom to screen
        INX                     ; inc to next 'get' byte
        INY                     ; inc to next 'send' byte
        DEC width               ; keep track of which part
        BNE loopi               ; moved both sides of gremlin?
        
        CLC                     ; clear carry for add
        LDA baset+1             ; need to add
        ADC #$04                ;   $04 to top to step down to
        STA baset+1             ;   next screen line
        LDA baseb+1             ; do the same thing
        ADC #$04                ;   to bottom of
        STA baseb+1             ;   the gremlin
        DEC height              ; keep track of which line
        BNE loop0               ; moved 8 slices of gremlin?
        
        JSR keyin
        RTS

;;; data storage of the gremlin. Data is
;;; stored in pairs by line: Left byte, right byte.
;;; Next pair is next line, etc.

datgt:  .DA 48, 12, 124, 63, 68, 35, 70, 99
        .DA 70, 99, 126, 127, 120, 31, 72, 19
datgb:  .DA 78, 115, 14, 112, 126, 127, 4, 32
        .DA 4, 32, 4, 32, 4, 32, 14, 112
        

;;; Chapter 11 Program 11.2
;;; Move a dot across the screen

        .ORG $800
        .OUT "prog_11_02.obj"

xposl:  .EQU $00
xposh:  .EQU $01
ypos:   .EQU $02
oldxh:  .EQU $03
oldxl:  .EQU $04
endflg: .EQU $05
color:  .EQU $E4
text:   .EQU $C051
page1:  .EQU $C054
hgr2:   .EQU $F3D8
hplot:  .EQU $F457
home:   .EQU $FC58
wait:   .EQU $FCA8

;;; initialization
        LDA #$00
        STA endflg
        STA xposl               ; start at left
        STA xposh               ;   of screen
        LDA #$14                ; set vertical
        STA ypos                ;   screen position
        JSR hgr2                ; page 2

;;; main control loop
rept:   JSR draw
        JSR incpos
        JSR compare
        LDA #$30                ; pause to
        JSR wait                ;   decrease speed
        JSR erase
        LDA endflg
        BEQ rept
;;; end main control loop

;;; exit
        JSR home
        BIT page1
        BIT text
        RTS

;;; draw
draw:   LDA #$7F
        STA color               ; white 1
        LDA ypos                ; vertical
        LDX xposl               ; horiz low
        LDY xposh               ; horiz high
        JSR hplot               ; draw the dot
        RTS

;;; erase
erase:  LDA #$00
        STA color               ; black (1)
        LDA ypos                ; vertical
        LDX oldxl               ; horiz low
        LDY oldxh               ; horiz high
        JSR hplot               ; draw the dot at x=low, y=high
        RTS

;;; increment position
incpos: LDA xposl               ; horiz low
        STA oldxl               ; save for erase
        CLC
        ADC #$01                ; inc horiz low
        STA xposl               ; save new value
        LDA xposh               ; horiz high
        STA oldxh               ; save for erase
        ADC #$00                ; inc horiz high
        STA xposh               ;   if carry is set
        RTS

;;; has the dot crossed the screen?
compare:  LDA xposh       ; horiz high
        BEQ ret           ; if horiz < 256
        LDA xposl         ; if horiz > 255
        CMP #$18          ; is horiz = 280?
        BNE ret           ; if not
        STA endflg        ; signal exit

ret:    RTS

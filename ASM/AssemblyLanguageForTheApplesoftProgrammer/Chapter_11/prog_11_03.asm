;;; Chapter 11 Program 11.3
;;; 2-d animation

        .ORG $6000
        .OUT "prog_11_03.obj"

data:   .EQU $01
xpos:   .EQU $01
ypos:   .EQU $02
dlx:    .EQU $03
dly:    .EQU $04
oldx:   .EQU $05
oldy:   .EQU $06
xhi:    .EQU #$E0
xlo:    .EQU #$20
yhi:    .EQU #$90
ylo:    .EQU #$20
color:  .EQU $E4
hgr2:   .EQU $F3D8
hplot:  .EQU $F457
wait:   .EQU $FCA8

;;; initialization
init:   LDA #$70                ; initial
        STA xpos                ;   horizontal posn
        LDA #$80                ; initial
        STA ypos                ;   vertical posn
        LDA #$01                
        STA dlx                 ; initial
        STA dly                 ;   increments
        JSR hgr2   

;;; main control loop
rept:   JSR draw
        LDA #$30                ; pause to
        JSR wait                ;   decrease speed
        JSR incpos
        JSR erase
        JMP rept
;;; end main control loop

;;; erase
erase:  LDA #$00
        STA color               ; black (1)
        LDA oldy                ; vertical
        LDX oldx                ; horiz low
        LDY #$00                ; horiz high
        JSR hplot               ; draw the dot
        RTS
        
;;; draw
draw:   LDA #$7F
        STA color               ; white 1
        LDA ypos                ; vertical
        LDX xpos                ; horiz low
        LDY #$00                ; horiz high
        JSR hplot               ; draw the dot
        RTS

;;; increment position
incpos: LDA xpos                ; horiz
        STA oldx                ; save for erase
        CLC
        ADC dlx                 ; xpos += dlx
        STA xpos                ; save new value
        CMP xhi                 ; at right boundary
        BEQ b1                  ; if so bounc
        CMP xlo                 ; at left boundary
        BNE b2                  ; if not check vert
b1:     LDA #$FF
        CLC
        EOR dlx                 ; negate
        ADC #$01                ;   dlx
        STA dlx
b2:     LDA ypos                ; vert
        STA oldy                ; save for erase
        CLC
        ADC dly                 ; ypos += dly
        STA ypos
        CMP yhi                 ; at bottom boundary
        BEQ b3                  ; if so, bounce
        CMP ylo                 ; at top boundary
        BNE b4
b3:     LDA #$FF
        CLC
        EOR dly                 ; negate
        ADC #$01                ;  dly
        STA dly
b4:     RTS

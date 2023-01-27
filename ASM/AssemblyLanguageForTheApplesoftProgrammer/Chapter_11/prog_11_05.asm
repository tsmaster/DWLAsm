;;; Chapter 11 Program 11.5
;;;  animated bit pattern


        .ORG $6000
        .OUT "prog_11_05.obj"

flag:   .EQU $00
data:   .EQU $01
xpos:   .EQU $01
ypos:   .EQU $02
dlx:    .EQU $03
dly:    .EQU $04
oldx:   .EQU $05
oldy:   .EQU $06
endflg: .EQU $07
xhi:    .EQU #$90
xlo:    .EQU #$20
yhi:    .EQU #$91
ylo:    .EQU #$21
basl:   .EQU $26
bash:   .EQU $27        
countr: .EQU $0B
pntr:   .EQU $0C
cntr:   .EQU $0E
color:  .EQU $E4
btmsk:  .EQU $30
text:   .EQU $C051
page1:  .EQU $C054
hgr2:   .EQU $F3D8
hposn:  .EQU $F411
home:   .EQU $FC58

;;; initialization

        LDA #$00
        STA cntr
        STA endflg
        STA flag
        JSR hgr2
        JSR initptr

;;; main control loop

rept:   JSR cpdin
        JSR erase
        JSR draw
        JSR incpos
        JSR cpdout
        JSR bkkp
        LDA endflg
        BNE exit
        JMP rept
;;; end main control loop


exit:   JSR home                ; clear screen
        BIT page1               ; display page 1
        BIT text                ;   of text
        RTS                     ; end program

initptr:  LDA #data0             ; low byte of data
        STA pntr                 ; storage address
        LDA /data0               ; high byte of data
        STA pntr+1               ; storage address
        LDA #$00                 ; start draw cycle
        STA countr               ;   over again
        RTS

cpdin:  LDY #$05                ; move 6 numbers
c1:     LDA (pntr),Y            ; from storage
        STA data,Y              ; to workspace
        DEY
        BPL c1
        RTS

cpdout: LDY #$05                ; move 6 numbers
d1:     LDA data,Y              ; from workspace
        STA (pntr),Y            ; to storage
        DEY
        BPL d1
        RTS

incpos: LDA xpos                ; horiz
        STA oldx                ; save for erase
        CLC
        ADC dlx                 ; xpos += dlx
        STA xpos                ; new horiz
        CMP xhi                 ; at right boundary
        BEQ bn1                 ; if so, bounce
        CMP xlo                 ; at left boundary
        BNE bn2                 ; if not check vert
bn1:    LDA #$FF
        CLC
        EOR dlx                 ; negate
        ADC #$01                ;   dlx
        STA dlx
bn2:    LDA ypos                ; vert
        STA oldy                ; save for erase
        CLC
        ADC dly                 ; ypos += dly
        STA ypos                ; new vert
        CMP yhi                 ; at bottom boundary
        BEQ bn3                 ; if so, bounce
        CMP ylo                 ; at top boundary
        BNE bn4
bn3:    LDA #$FF
        CLC
        EOR dly                 ; negate
        ADC #$01                ;   dly
        STA dly
bn4:    RTS

;;; erase

erase:  LDA flag                ; don't erase on
        BEQ ret                 ; first cycle
        LDA oldy
        LDX oldx
        LDY #$00                ; horiz high
        JSR hposn               ; get address, bitmask
        LDA btmsk
        EOR (basl),Y            ; bitmask EOR screen
        STA (basl),Y            ; save to screen
ret:    RTS

;;;  draw
        
draw:   LDA ypos
        LDX xpos
        LDY #$00                ; horiz high
        JSR hposn               ; get address, bitmask
        LDA btmsk
        EOR (basl),Y            ; bitmask EOR screen
        STA (basl),Y            ; save to screen
        RTS

bkkp:   INC countr              ; count number of
        LDA countr              ; dots drawn so far
        CMP #$10                ; all dots done?
        BEQ bk1                 ; if so, start over
        CLC
        LDA pntr                ; point
        ADC #$06                ;   to
        STA pntr                ;   data
        LDA pntr+1              ;   for
        ADC #$00                ;   next
        STA pntr+1              ;   dot
        LDA $C000               ; keypress?
        BPL bk2                 ; if not, return
        LDA $C010               ; clear kb strobe
        LDA #$01
        STA endflg              ; set exit flag
        RTS
bk1:    JSR initptr
        INC cntr                ; number of cycles
        LDA cntr
        STA flag                ; set to nonzero
        CMP #$E1                ; back to original?
        BNE bk2
        JSR $FD0c               ; wait for keypress
        LDA #$01
        STA cntr                ; reset
bk2:    RTS

data0:  .DA $8A, $63, $01, $02, $00, $00
data1:  .DA $8A, $62, $FE, $01, $00, $00
data2:  .DA $8A, $61, $FE, $02, $00, $00
data3:  .DA $8A, $60, $02, $01, $00, $00  
data4:  .DA $8A, $5F, $FF, $02, $00, $00  
data5:  .DA $8B, $5E, $FF, $01, $00, $00  
data6:  .DA $8C, $5D, $02, $02, $00, $00  
data7:  .DA $8D, $5E, $01, $01, $00, $00  
data8:  .DA $8E, $5F, $FF, $FE, $00, $00  
data9:  .DA $8E, $60, $02, $FF, $00, $00  
data10: .DA $8E, $61, $FE, $FE, $00, $00  
data11: .DA $8E, $62, $FE, $FF, $00, $00  
data12: .DA $8E, $63, $01, $FE, $00, $00  
data13: .DA $8B, $61, $FF, $FF, $00, $00  
data14: .DA $8C, $61, $02, $FE, $00, $00  
data15: .DA $8D, $61, $01, $FF, $00, $00  

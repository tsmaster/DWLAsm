;;; Chapter 11 Program 11.6
;;; faster animation


        .ORG $6000
        .OUT "prog_11_06.obj"

flag:   .EQU $00
data:   .EQU $01
xpos:   .EQU $01
ypos:   .EQU $02
dlx:    .EQU $03
dly:    .EQU $04
oldx:   .EQU $05
oldy:   .EQU $06
endflg: .EQU $07
linnum: .EQU $09
indx:   .EQU $0A
countr: .EQU $0B
pntr:   .EQU $0C
cntr:   .EQU $0E
ndots:  .EQU #$0F
offset: .EQU $10
xhi:    .EQU #$90
xlo:    .EQU #$20
yhi:    .EQU #$91
ylo:    .EQU #$21
basl:   .EQU $26
bash:   .EQU $27        
temp:   .EQU $30
hpage:  .EQU $E6
text:   .EQU $C051
page1:  .EQU $C054
hgr2:   .EQU $F3D8
hposn:  .EQU $F411
home:   .EQU $FC58

;;; initialization

        JSR filtab
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
        LDY oldy
        LDX oldx
        JSR hposn1              ; get address, bitmask
        EOR (basl),Y            ; bitmask EOR screen
        STA (basl),Y            ; save to screen
ret:    RTS

;;;  draw
        
draw:   LDY ypos
        LDX xpos
        JSR hposn1              ; get address, bitmask
        EOR (basl),Y            ; bitmask EOR screen
        STA (basl),Y            ; save to screen
        RTS

;;; get BASH

hposn1: LDA tblyh,Y
        STA bash
        LDA tblyl,Y
        STA basl

;;; get offset
        LDY offtbl,X
        STY offset

;;; get bitmask
        TYA
        ASL                     ; multiply
        ASL                     ;   offset
        ASL                     ;   by 8
        SEC
        SBC offset
        STA temp                ; 7*offset
        TXA
        SBC temp                ; xpos - 7*offset
        TAX
        LDA masktbl,X
        RTS

;;; bookkeeping

bkkp:   INC countr              ; count number of
        LDA countr              ; dots drawn so far
        CMP ndots               ; all dots done?
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

;;; load offtbl
filtab: CLC
        LDA #$00                ; initial value to table
        LDY #$00                ; index to table
ft1:    LDX #$06                ;
ft2:    STA offtbl,Y
        INY
        BEQ ft3                 ; offtbl holds 256 numbers
        DEX
        BPL ft2                 ; until 7 numbers stored
        ADC #$01                ; increase # to be stored
        BNE ft1                 ; always

;;; load tblyl and tblyh
ft3:    LDA #$40                ; designate high
        STA hpage               ;   res page 2
        LDA #$00                ; start at top
        STA linnum              ;   of screen
        STA indx                ; index to table storage
ft4:    LDY #$00                ; horiz high byte
        LDX #$00                ; horiz low byte
        JSR hposn
        LDY indx                ; table index
        LDA basl                ; base address low byte
        STA tblyl,Y
        LDA bash                ; base address high byte
        STA tblyh,Y
        INC indx
        INC linnum              ; down one line
        LDA linnum              ; vertical position
        CMP #$C0                ; bottom of screen?
        BNE ft4                 ; if not
        RTS                     ; done, exit

masktbl:        .DA $01, $02, $04, $08, $10, $20, $40
offtbl: .BS $100
tblyh:  .BS $C0
tblyl:  .BS $C0

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

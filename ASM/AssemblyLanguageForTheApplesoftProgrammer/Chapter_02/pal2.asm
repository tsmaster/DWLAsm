;  Chapter 2 Example PAL2

        .ORG $300
        .OUT "chap_2_pal2.obj"

width:  .EQU #$28
zero:   .EQU #$00
line1:  .EQU $0400
line2:  .EQU $0480
space:  .EQU #$A0

begin:  LDY width               ; width of screen
loop1:  DEY                     ; dec line1 index
        LDA line1,Y             ; get char from line1
        CMP space               ; is it a space?
        BEQ loop1               ; if so, skip it
        LDX zero                ; initialize x
loop:   LDA line1,Y             ; get char from line 1
        STA line2,X             ; store it in line 2
        INX                     ; inc line2 index
        DEY                     ; dec line1 index
        BPL loop                ; continue across screen
        RTS                     ; done. return to main pgm

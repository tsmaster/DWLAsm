;  Chapter 2 Example PAL1

        .ORG $300
        .OUT "chap_2_pal1.obj"

width:  .EQU #$27
zero:   .EQU #$00
line1:  .EQU $0400
line2:  .EQU $0480

begin:  LDY width               ; width of screen
        LDX zero                ; initialize x
loop:   LDA line1,Y             ; get char from line 1
        STA line2,X             ; store it in line 2
        INX                     ; inc line2 index
        DEY                     ; dec line1 index
        BPL loop                ; continue across screen
        RTS                     ; done. return to main pgm

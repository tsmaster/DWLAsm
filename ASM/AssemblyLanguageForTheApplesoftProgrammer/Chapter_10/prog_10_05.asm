;;; Chapter 10 Program 10.5
;;; hi-res colors

        .ORG $300
        .OUT "prog_10_05.obj"
        
hgr2:   .EQU $F3D8
keyin:  .EQU $FD1B


begin:  JSR hgr2                ; display hi-res page 2
        LDX #$00                ; init x

loop:   JSR keyin               ; get a keycode
        STA $4000,X             ; store it
        INX                     ; inc to next value
        CPX #$27                ; end of row?
        BNE loop                ; if not, keep going
        RTS                     ; stop
        

;;; Chapter 10 Program 10.6m1
;;; see the dots

        .ORG $7000
        .OUT "prog_10_06m1.obj"
        
hgr2:   .EQU $F3D8
keyin:  .EQU $FD1B


begin:  JSR hgr2                ; display hi-res page 2
        LDX #$00                ; init x

loop:   STX $423C               ; put it in the byte
        STX $463C               ; and successive bytes
        STX $4A3C               
        STX $4E3C               
        STX $523C               
        STX $563C               
        STX $5E3C               ; skip $5A3C, to make a ! (?!)
        
        JSR keyin               ; wait for keypress
        JSR hgr2                ; clear screen each time
        INX                     ; inc to next value
        BNE loop
        RTS
        

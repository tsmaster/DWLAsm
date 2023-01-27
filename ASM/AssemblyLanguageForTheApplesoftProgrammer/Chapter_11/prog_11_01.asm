;;; Chapter 11 Program 11.1
;;; Draw a rectangle

        .ORG $800
        .OUT "prog_11_01.obj"

color:  .EQU $E4
hgr2:   .EQU $F3D8
hplot:  .EQU $F457
hlin:   .EQU $F53A

        LDA #$7F
        STA color               ; white
        JSR hgr2                ; page 2
        LDA #$46                ; vertical
        LDX #$64                ; horiz low
        LDY #$00                ; horiz high
        JSR hplot               ; point at 100, 70

        LDA #$0E                ; horiz low
        LDX #$01                ; horiz high
        LDY #$46                ; vertical
        JSR hlin                ; line to 270, 70

        LDA #$0E                ; horiz low
        LDX #$01                ; horiz high
        LDY #$7D                ; vertical
        JSR hlin                ; line to 270, 125

        LDA #$64                ; horiz low
        LDX #$00                ; horiz high
        LDY #$7D                ; vertical
        JSR hlin                ; line to 100, 125

        LDA #$64                ; horiz low
        LDX #$00                ; horiz high
        LDY #$46                ; vertical
        JSR hlin                ; line to 100, 70

        RTS
        

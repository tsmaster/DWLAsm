;;; Chapter 10 Program 10.4
;;; lo-res colors

        .ORG $300
        .OUT "prog_10_04.obj"
        
gr:     .EQU $C050
pag1:   .EQU $C054
lores:  .EQU $C056
clrtop: .EQU $F836
keyin:  .EQU $FD1B


begin:  BIT gr                  ; toggle graphics
        BIT pag1                ; toggle page 1
        BIT lores               ; toggle lo-res
        JSR clrtop              ; clear screen to black
        LDX #$00                ; set X

loop:   JSR keyin               ; get a color
        STA $0400,X             ; store it at $400+X
        INX                     ; inc X to next block
        CPX #$28                ; end of row?
        BNE loop                ; if not, keep going
        RTS

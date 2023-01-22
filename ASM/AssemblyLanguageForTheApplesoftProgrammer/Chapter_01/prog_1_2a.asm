;; Program 1.2a
;; display white HGR page, with labels for readability

                 .ORG $300
                 .OUT "prog_1_2a.obj"

scr_1:           .EQU #$20
white_1:         .EQU #$7F
color:           .EQU $1C
scr:             .EQU $E6
sub_clrscr:      .EQU $F3F6
sub_getkey:      .EQU $FD1B
ss_setgraphics:  .EQU $C050
ss_settext:      .EQU $C051
ss_sethires:     .EQU $C057

                 LDA scr_1               ; A9 20
                 STA scr                 ; 85 e6
                 LDA white_1             ; A9 7F
                 STA color               ; 85 1C
                 JSR sub_clrscr          ; 20 F6 F3
                 STA ss_sethires         ; 8D 57 C0
                 STA ss_setgraphics      ; 8d 50 C0
                 JSR sub_getkey          ; 20 1B FD
                 STA ss_settext          ; 8D 51 C0
                 RTS                     ; 60

;; Program 1.3
;; display white HGR mixed page

                 .ORG $300
                 .OUT "prog_1_3.obj"

scr_1:           .EQU #$20
black_1:         .EQU #$00
green:           .EQU #$2A
purple:          .EQU #$55
white_1:         .EQU #$7F
black_2:         .EQU #$80
orange:          .EQU #$AA
blue:            .EQU #$D5
white_2:         .EQU #$FF
color:           .EQU $1C
scr:             .EQU $E6
sub_clrscr:      .EQU $F3F6
sub_getkey:      .EQU $FD1B
ss_setgraphics:  .EQU $C050
ss_settext:      .EQU $C051
ss_showmixed:    .EQU $C053
ss_disppg1:      .EQU $C054
ss_sethires:     .EQU $C057

                 LDA scr_1               ; A9 20
                 STA scr                 ; 85 e6
                 LDA white_1             ; A9 7F
                 STA color               ; 85 1C
                 JSR sub_clrscr          ; 20 F6 F3
                 STA ss_disppg1          ; 8D 54 C0
                 STA ss_sethires         ; 8D 57 C0
                 STA ss_showmixed        ; 8D 53 C0
                 STA ss_setgraphics      ; 8d 50 C0
                 RTS                     ; 60

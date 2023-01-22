        ;; Program 1.2
        ;; display white HGR page

        ORG $300

        LDA #$20                ; A9 20
        STA $E6                 ; 85 e6
        LDA #$7F                ; A9 7F
        STA $1C                 ; 85 1C
        JSR $F3F6               ; 20 F6 F3
        STA $C057               ; 8D 57 C0
        STA $C050               ; 8d 50 C0
        JSR $FD1B               ; 20 1B FD
        STA $C051               ; 8D 51 C0
        RTS                     ; 60

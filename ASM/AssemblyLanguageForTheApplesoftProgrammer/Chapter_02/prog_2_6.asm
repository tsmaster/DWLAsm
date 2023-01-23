;;  Chapter 2 Program 2.6
;;  variable tone

        .ORG $300
        .OUT "prog_2_6.obj"
        
spkr:   .EQU $C030
        
tweak:  LDA spkr                ; tweak speaker
        LDX #$FF                ; delay between tweaks
pause:  DEX                     ; count down
        BNE pause               ; done?
        BEQ tweak               ; start over
        RTS
        

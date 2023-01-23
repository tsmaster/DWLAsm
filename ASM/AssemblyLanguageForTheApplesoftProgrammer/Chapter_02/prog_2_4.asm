;;  Chapter 2 Program 2.4
;;  audible tweaker

        .ORG $300
        .OUT "prog_2_4.obj"
        
spkr:   .EQU $C030
        
tweak:  LDA spkr
        NOP                     ; delay
        NOP                     ; between
        NOP                     ; successive
        NOP                     ; tweaks
        JMP tweak
        

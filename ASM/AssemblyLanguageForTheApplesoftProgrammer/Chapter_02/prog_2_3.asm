;;  Chapter 2 Program 2.3
;;  Too fast to hear

        .ORG $300
        .OUT "prog_2_3.obj"
        
spkr:   .EQU $C030
        
tweak:  LDA spkr
        JMP tweak
        

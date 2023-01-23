;;  Chapter 2 Program 2.5
;;  apple bell subroutine

        .ORG $300
        .OUT "prog_2_5.obj"
        
spkr:   .EQU $C030
wait:   .EQU $FCA8
        
bell:   LDY #$C0                ; number of tweaks
bell2:  LDA #$0C                ; duration of delay
        JSR wait                ; between successive tweaks
        LDA spkr
        DEY                     ; count number of tweaks
        BNE bell2               ; done yet?
        RTS                     ; done
        

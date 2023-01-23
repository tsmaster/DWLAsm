;;  Chapter 2 Program 2.7
;;  intermediate / not audible DOES NOT YET BUILD BECAUSE OF FORWARD REFERENCE

            .ORG $300
            .OUT "prog_2_7.obj"
        
spkr:       .EQU $C030
counter:    .EQU $06    

        LDA #$FF                ; init counter for
        STA counter             ; duration of tone
tweak:  LDA spkr
        LDX #$20                ; set pitch
count:  DEC counter
        BEQ done
        DEX
        BNE count
        BEQ tweak
done:   RTS
        

;;; Chapter 5 Program 5.1m2
;;; MEM FILL

        .ORG $800
        .OUT "prog_5_01m2.obj"

begin:  LDA #$33                ; load fill value
        LDY #$10                ; load stopping value
top:    STA $406F,Y             ; store value at $406F+(Y)
        DEY                     ; set n & z-flags
        BNE top                 ; test z branch if not done
done:   BRK
        

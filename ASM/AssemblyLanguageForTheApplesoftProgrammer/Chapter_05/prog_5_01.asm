;;; Chapter 5 Program 5.1
;;; MEM FILL

        .ORG $800
        .OUT "prog_5_01.obj"

begin:  LDA #$11                ; load fill value
        LDY #$00                ; init y
top:    STA $4000,Y             ; store value at $4000+(Y)
        INY                     ; set z-flag
        BNE top                 ; test z branch if page not filled
done:   BRK
        

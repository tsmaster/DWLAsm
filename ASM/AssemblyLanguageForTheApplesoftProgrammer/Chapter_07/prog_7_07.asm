;;; Chapter 7 Program 7.7
;;; USR

        .ORG $300
        .OUT "prog_7_07.obj"

        LDA #$64                ; 0.5 stored
        LDY #$EE                ; at $EE64
        JSR $E97F               ; mult by 0.5
        LDA #$6B                ; 2*pi stored
        LDY #$F0                ; at $F068
        JSR $E97F               ; mult by 2*pi
        RTS
        

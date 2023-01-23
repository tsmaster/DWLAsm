;;; Chapter 3 Program 3.8
;;; stack

        .ORG $800
        .OUT "prog_3_08.obj"

stack:  CLC
        TSX
        TXA
        TAY
        LDA #$86
        PHA
        PHP
        SEC
        LDA #$87
        PHA
        PHP
        LDA #$88
        PHA
        PHP
        TSX
        BRK
        
        

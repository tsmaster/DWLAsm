;;; Chapter 6 Program 6.1
;;; Logical AND

        .ORG $800
        .OUT "prog_6_01.obj"

and:    LDA #$33
        AND #$BB
        BRK
        

;;; Chapter 8 Program 8.12
;;; CIAYM

        .ORG $800
        .OUT "prog_8_12.obj"

ciaym:  .EQU $E2F2
        
begin:  LDA #$FF                ; hex rep.
        LDY #$FB                ; of -5
        JSR ciaym
        BRK
        

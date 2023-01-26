;;; Chapter 8 Program 8.19
;;; sin(degrees)
;;; link with example 8.19a

        .ORG $300
        .OUT "prog_8_19.obj"

ciym:   .EQU $E301
lmult:  .EQU $E97F
div:    .EQU $EA69
movms:  .EQU $EB63
sin:    .EQU $EFF1
        
begin:  JSR movms               ; MFAC -> SFAC
        LDY #$5A                ; decimal 90
        JSR ciym                ; 90 -> MFAC
        LDA $A2                 ; set $AB to
        EOR $AA                 ; EOR the sign of
        STA $AB                 ; MFAC and SFAC
        LDA $9D                 ; also sets Z
        JSR div                 ; D/90 -> MFAC
        LDY #$F0                ; addr of
        LDA #$66                ;   pi/2
        JSR lmult               ; radian measure
        JSR sin                 ; sin(MFAC) -> MFAC
        RTS

        

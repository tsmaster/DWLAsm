;;; Chapter 5 Program 5.2m1
;;; Fill Pages mod 1

        .ORG $800
        .OUT "prog_5_02m1.obj"

;;; initialization
        
pstart: .EQU $3FF8              ; starting page
pstop:  .EQU $3FF9              ; stopping page
page:   .EQU $08                ; current page
lstart: .EQU $3FFB              ; starting loc on 1st pg
        

begin:  LDA #$40                ; starting page
        STA page+1              ; store it
        STA pstart              ; again for safe keeping
        LDA #$00                ; init start page loc
        STA page                ; store it
        LDA #$70                ; stopping page
        STA pstop               ; store it
        LDY #$00                ; starting loc on 1st page

;;; top of outer loop
topout: LDA page+1              ; reset fill value

;;; top of inner loop
topin:  STA (page),Y            ; store value at PAGE+Y
;;; inner loop control
        INY                     ; and set N & Z
;;; test inside loop
        BNE topin               ; finished with this page?
        STY page                ; store it
;;; outer loop control
        INC page+1              ; inc to next page
        LDA pstop               ; load stopping page
        CMP page+1              ; set N, Z, and C
;;; test outside loop
        BNE topout              ; finished all pages?
done:   BRK                     ; stop and call monitor
        
        

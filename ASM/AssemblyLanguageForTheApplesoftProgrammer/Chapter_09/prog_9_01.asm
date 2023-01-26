;;; Chapter 9 Program 9.1 (I guess?)
;;; user-defined functions


        .ORG $300
        .OUT "prog_9_01.obj"

chargot: .EQU $00B7
fnadr:   .EQU $FB
fnptr:   .EQU $FD
tknz:    .EQU $D559
fnfind:  .EQU $DFEA

;;; --------------------
;;; locate function pointer

        JSR chargot             ; read 1st byte of fn label
        ORA #$80                ; set high bit
        STA $14                 ; store for access by fnfind
        JSR fnfind              ; locate or create fn pointer

;;; --------------------
;;; fnptr, fnptr+1 get address of function ptr
        LDA $9B
        STA fnptr
        LDA $9C
        STA fnptr+1

;;; --------------------
;;; fnadr, fnadr+1 get address of function
        LDY #$02
        LDA (fnptr),Y
        STA fnadr
        INY
        LDA (fnptr),Y
        STA fnadr+1
        
;;; --------------------
;;; save txtptr when calling tknz
        LDA $B8
        PHA
        LDA $B9
        PHA

;;; --------------------
;;; tokenize the string
        LDA #$00
        STA $B8                 ; needed for tknz subroutine

;;; --------------------
        JSR tknz                ; tokenize the string

;;; --------------------
;;; subtract 5 from y to get the
;;; length of the tokenized string
        TYA
        CLC
        SBC #$03                ; length + 2
        TAY

;;; --------------------
;;; store a "REM"
        LDA #$B2                ; token for REM
        STA (fnadr),Y
        DEY


;;; --------------------
;;; store a ":"
        LDA #$3A                ; code for ":"
        STA (fnadr),Y
        DEY

;;; --------------------
;;; store tokenized function
a:      LDA $200,Y
        STA (fnadr),Y
        DEY
        BPL a

;;; --------------------
;;; set last byte of function pointer
;;; to the first byte of the function
        LDA $200
        LDY #$06
        STA (fnptr),Y

;;; --------------------
;;; restore txtptr
        PLA
        STA $B9
        PLA
        STA $B8

;;; --------------------
        RTS

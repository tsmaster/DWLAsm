;;; Chapter 8 Program 8.10
;;; LOG AND VARFND
;;; LINK WITH BASIC EXAMPLE 8.10a

        .ORG $300
        .OUT "prog_8_10.obj"

log:    .EQU $E941
movmi:  .EQU $EAF9
movmo:  .EQU $EB2B
varfnd: .EQU $E053
        
begin:  LDA #$58                ; ASCII code for X
        STA $81                 ; 1st char of var name
        LDA #$00                ; null character
        STA $82                 ; 2nd char of var name
        JSR varfnd              ; locate the variable
                                ; addr in (Y,A)
        JSR movmi               ; (Y,A) -> MFAC
        JSR log                 ; log(MFAC) -> MFAC
        LDA #$5A                ; ASCII code for "Z"
        STA $81                 ; 1st char of var name
        LDA #$31                ; ASCII code for "1"
        STA $82                 ; 2nd char of var name
        ;;  note, only ever need 2 characters
        JSR varfnd              ; create the variable
        ;; addr in (Y,A)
        TAX                     ; movemo requires(Y,X)
        JSR movmo               ; MFAC -> (Y,X)
        RTS
        

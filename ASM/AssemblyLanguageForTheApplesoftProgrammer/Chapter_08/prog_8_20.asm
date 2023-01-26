;;; Chapter 8 Program 8.20
;;; random numbers
;;; link with example 8.20a

        .ORG $300
        .OUT "prog_8_20.obj"

len:    .EQU $06
loc:    .EQU $07
page:   .EQU $08
frmevl: .EQU $DD7B
chkcom: .EQU $DEBE
cmix:   .EQU $E6FB
movmo:  .EQU $EB2B
rnd:    .EQU $EFAE

        LDA #$40                ; address
        STA page                ; of
        LDA #$00                ; table
        STA loc                 ; storage

        JSR frmevl              ; evaluate formula at txtptr
        JSR cmix                ; int(MFAC) -> X
        
        STX len                 ; length of table
        JSR chkcom              ; confirm comma
        JSR frmevl              ; read next formula
        
loop:   JSR rnd                 ; generate a random number
        LDY page                ; destination
        LDX loc                 ;   address
        JSR movmo               ; MFAC -> (Y,X)
        CLC                     ; ready to
        LDA loc                 ; inc destination
        ADC #$05                ; for next random
        STA loc                 ;   number
        DEC len                 ; count down
        BNE loop                ;   to 0
        RTS                     ; table complete

        

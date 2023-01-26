;;; Chapter 8 Program 8.11
;;; EXP, FRMEVL, PTRGET
;;; LINK WITH BASIC EXAMPLE 8.11a

        .ORG $300
        .OUT "prog_8_11.obj"

chkcom: .EQU $DEBE
exp:    .EQU $EF09
frmevl: .EQU $DD7B
movmo:  .EQU $EB2B
ptrget: .EQU $DFE3
        
begin:  JSR frmevl              ; expr at txtptr
        ;;  is put in MFAC
        JSR exp                 ; exp(MFAC) -> MFAC
        JSR chkcom              ; confirm comma
        JSR ptrget              ; addr of var at txtptr
        ;; is put in (Y,A)
        TAX                     ; movmo requires (Y,X)
        JSR movmo               ; MFAC -> (Y,X)
        RTS
        

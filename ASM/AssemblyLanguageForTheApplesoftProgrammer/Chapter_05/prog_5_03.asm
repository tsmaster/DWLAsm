;;; Chapter 5 Program 5.3
;;; Build Table

        .ORG $800
        .OUT "prog_5_03.obj"

;;; initialization

table:  .EQU $08                ; starting address of table
lr:     .EQU $3ff8              ; length of a row
lc:     .EQU $3ff9              ; length of a column
lrs:    .EQU $3FFA              ; keep lr safe
lcs:    .EQU $3FFB              ; keep lc safe

begin:  LDA #$40                ; page of table
        STA table+1             ; store it
        LDA #$00                ; loc on page for table
        STA table               ; store it
        LDA #$08                ; number of rows
        STA lr                  ; store it
        STA lrs                 ; again to keep it safe
        LDA #$08                ; number of columns
        STA lc                  ; store it
        STA lcs                 ; again to keep it safe
        LDY #$00                ; init loc counter
        LDA #$11                ; init fill value

topout: LDX lcs                 ; reload no. of columns
        STX lc                  ; reset no. of columns
        
topin:  STA (table),Y           ; store value at table+Y
        CLC                     ; clear carry for addition
        ADC #$01                ; inc accum to next col value
        INY                     ; inc y to next loc
        DEC lc                  ; count columns, set n,z,c
        BNE topin               ; finished this row?
        CLC                     ; clear carry for addition
        ADC #$08                ; inc accum to next col value
        DEC lr                  ; count rows, set n, z, c
        BNE topout              ; finished table?
        
done:   BRK                     ; stop and call monitor

        

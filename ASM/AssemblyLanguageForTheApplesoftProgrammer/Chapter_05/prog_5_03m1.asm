;;; Chapter 5 Program 5.3m1
;;; Build Table Mod1

        .ORG $800
        .OUT "prog_5_03m1.obj"

;;; initialization

lr:     .EQU $3ff8              ; length of a row
lc:     .EQU $3ff9              ; length of a column
lcs:    .EQU $3FFA              ; keep lc safe
cntr:   .EQU $3FFB              ; position counter
keep:   .EQU $3FFC              ; keep accumulator here

begin:  LDA #$04                ; number of rows
        STA lr                  ; store it
        LDA #$04                ; number of columns
        STA lc                  ; store it
        STA lcs                 ; again to keep it safe
        LDY #$00                ; init loc counter
        LDA #$11                ; init fill value

topout: LDX #$08                ; reset counter
        STX cntr                ; store it
        LDX lcs                 ; reload no of columns
        STX lc                  ; reset no. of columns
        
topin:  STA $4000,Y             ; store value at table+Y
        CLC                     ; clear carry for addition
        ADC #$01                ; inc accum to next col value
        INY                     ; inc y to next loc
        DEC cntr                ; count positions
        DEC lc                  ; count columns, set n, z, c
        BNE topin               ; finished this row?
        STA keep                ; keep accum for later
        CLC                     ; clear carry for addition
        TYA                     ; put current address into A
        ADC cntr                ; add on left over addresses
        TAY                     ; put updated address back into y
        LDA keep                ; restore accumulator
        CLC                     ; clear carry for addition
        ADC cntr                ; add on left over positions
        ADC #$08                ; inc accum to next col value
        DEC lr                  ; count rows, set n, z, c
        BNE topout              ; finished table?
        
done:   BRK                     ; stop and call monitor

        

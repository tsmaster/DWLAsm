;;; Chapter 13 Program 13.1
;;; Bubble sort

;;; ------------------------------
;;; This example will sort 256 or fewer
;;; numbers that were loaded into an
;;; array by the BASIC program that calls it
;;; ------------------------------

        .ORG $300
        .OUT "prog_13_01.obj"

;;; ------------------------------
;;; must stay out of $800
;;; because that is the starting location
;;; of Applesoft
;;; ------------------------------

eleml:  .EQU $06                ; left hand elem
elemr:  .EQU $08                ; right hand elem
mask:   .EQU $16                ; for the comparison
flag:   .EQU $19                ; keep flag here
numb:   .EQU $1E                ; the number of elems
count:  .EQU $1F                ; the current number
first:  .EQU $94                ; address of first number
mfac:   .EQU $9D
comp:   .EQU $DF6A
ptrget: .EQU $DFE3
movsi:  .EQU $E9E3
movmi:  .EQU $EAF9
movmo:  .EQU $EB2B
movsm:  .EQU $EB53

;;; ------------------------------
;;; beginning of program
;;; ------------------------------
begin:  JSR ptrget              ; put addr of 1st number into first
        LDA first               ; get location part of first number
        SEC                     ; set carry for subtraction
        SBC #$01                ; backup to number to sort
        STA numb                ; location part
        LDA first+1             ; get page part of first number
        SBC #$00                ; neat way to take care of page boundary
        STA numb+1              ; page part of address
        LDY #$00                ; prepare for indirect addressing
        LDA (numb),Y            ; load number to be sorted into A
        TAX                     ; move it to X
        DEX                     ; take off 1
        STX numb                ; store it here
        LDA #$06                ; select comparison   < = >
        STA mask                ; comp wants it here  4 2 1

;;; ------------------------------
;;; this is the top of the outer loop
;;; ------------------------------
pass:   LDA numb                ; reload number of elements
        STA count               ; set the counter
        LDA #$00                ; clear the flag
        STA flag                ; it is cleared
        LDY first+1             ; get page part of first number
        STY eleml+1             ; save it here
        LDA first               ; get loc part of its address
        STA eleml               ; loc of first number on list

;;; ------------------------------
;;; this is the top of the inner loop
;;; ------------------------------
top:    JSR movsi               ; move it into SFAC
        LDY eleml+1             ; must recover these
        LDA eleml               ; after the JSR in line 1570 (top)
        CLC                     ; set up to
        ADC #$05                ; right elem
        STA elemr               ; save it here
        TYA                     ; prepare to check for page boundary
        ADC #$00                ; fix if necessary
        TAY                     ; put it back
        STA elemr+1             ; save it here
        LDA elemr               ; right elem is ready
        JSR movmi               ; move it into MFAC
        JSR comp                ; do the comparison
        LDA mfac                ; set Z flag, is MFAC = 0?
        BNE noswp               ; need to swap them?

;;; ------------------------------
;;; this section swaps the right and the left elements
;;; ------------------------------
        LDA #$FF                ; YES!
        STA flag                ; so set flag
        LDY #$04                ; move all 5 parts
swap:   LDA (elemr),Y           ; of the floating point number
        TAX                     ; use X as temp storage
        LDA (eleml),Y           ; move left part
        STA (elemr),Y           ; to the right
        TXA                     ; move old right
        STA (eleml),Y           ; to the left
        DEY                     ; count down
        BPL swap                ; move them all yet?

;;; ------------------------------
noswp:  LDY elemr+1             ; do not need to swap em
        STY eleml+1             ; old right becomes new left
        LDA elemr               ; prepare to move up right
        STA eleml               ; this takes care of page part
        DEC count               ; count off another 1
        BNE top                 ; do them all yet?

;;; ------------------------------
;;; bottom of inner loop
;;; ------------------------------
        DEC numb                ; do not need to re-check the rest
        LDA flag                ; set Z flag; is it 0?
        BNE pass                ; do any swaps?
;;; ------------------------------
;;; bottom of the outer loop
;;; ------------------------------
        RTS                     ; HOW NICE IT IS!
        

;;; Chapter 13 Program 13.2
;;; String sort

;;; ------------------------------
;;; This program will sort 256 or fewer string
;;; elements (names) which were loaded into an
;;; array by the associated BASIC program.
;;; ------------------------------

        .ORG $300
        .OUT "prog_13_02.obj"

;;; ------------------------------
;;; must stay out of $800
;;; because that is the starting location
;;; of Applesoft
;;; ------------------------------

eleml:  .EQU $06                ; left hand elem
elemr:  .EQU $08                ; right hand elem
mask:   .EQU $16                ; for the comparison
flag:   .EQU $19                ; keep flag
numb:   .EQU $1E                ; the number of names
count:  .EQU $1F                ; the current numb
first:  .EQU $94                ; address of first name
mfac:   .EQU $9D
sfac:   .EQU $A5
ptrget: .EQU $DFE3
strcmp: .EQU $DF7D

;;; ------------------------------
;;; beginning of program
;;; ------------------------------

begin:  JSR ptrget              ; put addr of 1st elem into first
        LDA first               ; get location part of first elem
        SEC                     ; set carry for subtraction
        SBC #$01                ; backup to number of names
        STA numb                ; location part
        LDA first+1             ; get page part of first elem
        SBC #$00                ; neat way to take care of page boundary
        STA numb+1              ; page part of numb address
        LDY #$00                ; prepare for indirect addressing
        LDA (numb),Y            ; load number of names into A
        TAX                     ; move it to X
        DEX                     ; take off 1
        STX numb                ; store it here
        LDA #$06                ; select comparison     < = >
        STA mask                ; strcmp wants it here  4 2 1

;;; ------------------------------
;;; this is the top of the outer loop
;;; ------------------------------

pass:   LDA numb                ; reset the
        STA count               ; counter
        LDA #$00                ; clear the flag
        STA flag                ; it is cleared
        LDX first+1             ; get page part
        STX eleml+1             ; save it here
        LDA first               ; get loc part of address
        STA eleml               ; save it here

;;; ------------------------------
;;; this is the top of the inner loop
;;; ------------------------------
        
top:    CLC                     ; establish address of
        ADC #$03                ; right hand elem
        STA mfac+3              ; loc is ready to go
        STA elemr               ; save it here
        TXA                     ; prepare to check for page boundary
        ADC #$00                ; fix it if necessary
        STA mfac+4              ; page is ready
        STA elemr+1             ; save it here
        LDA eleml               ; establish address of
        STA sfac+3              ; left-hand elem
        LDA eleml+1             ; loc is ready
        STA sfac+4              ; pg is ready
        JSR strcmp              ; do the comparison
        LDA mfac                ; set Z flag. Is MFAC = 0 ?
        BNE noswp               ; need to swap them?

;;; ------------------------------
;;; this section swaps the right and left elements
;;; ------------------------------

        LDA #$FF                ; YES! SET FLAG!
        STA flag                ; the flag is set
        LDY #$02                ; move all 3 parts
swap:   LDA (elemr),Y           ; of the address
        TAX                     ; right elem to temp
        LDA (eleml),Y           ; move left elem
        STA (elemr),Y           ; to right elem
        TXA                     ; move the right
        STA (eleml),Y           ; to the left
        DEY                     ; count down
        BPL swap                ; done yet?

;;; ------------------------------

noswp:  LDX elemr+1             ; do not need to swap them
        STX eleml+1             ; old right becomes new left
        LDA elemr               ; prepare to move up right
        STA eleml               ; this takes care of page part
        STA eleml               ; save it (again?)
        DEC count               ; count down
        BNE top                 ; do them all yet?
        
;;; ------------------------------
;;; bottom of inner loop
;;; ------------------------------
        DEC numb                ; do not need to re-check the rest
        LDA flag                ; set Z-flag. Is it zero?
        BNE pass                ; do any swaps?

;;; ------------------------------
;;; bottom of outer loop
;;; ------------------------------
        RTS                     ; HOW NICE IT IS!
        
        

;;; Chapter 12 Prgram 12.1
;;; Game Development
;;; The Game

        .ORG $6000
        .OUT "prog_12_01.obj"

horzd:  .EQU $06                ; horz byte loc of defender
horzg:  .EQU $07                ; horz byte loc of gremlin
horzm:  .EQU $08                ; horz byte loc of missile
frmnumd:        .EQU $09        ; frame number of defender
frmnumg:        .EQU $0A        ; frame number of gremlin
dir:    .EQU $0B                ; direction of defender's movement
height: .EQU $0C                ; height (# of bytes) to be drawn
width:  .EQU $0D                ; width (# of bytes) to be drawn
temp:   .EQU $0E                ; temporary storage
mflg:   .EQU $0F                ; flag if missle drawn
mslnum: .EQU $10                ; missile number (0-6)
mlevl:  .EQU $11                ; index to base address table for missiles
basb:   .EQU $12                ; base address of barricades
basmd:  .EQU $14                ; screen base address (upper) of missile
basme:  .EQU $16                ; screen base address (lower) of missile
colflg: .EQU $18                ; collision flag
brkd:   .EQU $19                ; barricade bit pattern
basd:   .EQU $FA                ; uses $FB also
basg1:  .EQU $FC                ; uses $FD also
basg2:  .EQU $FE                ; uses $FF also
kbd:    .EQU $C000              ; read keyboard here
strobe: .EQU $C010              ; clear keyboard strobe
bell:   .EQU $FBDD              ; beep speaker
wait:   .EQU $FCA8              ; monitor "pause" routine


;;; ------------------------------
init:   LDA #$00
        STA brkd
        STA horzg
        STA mflg
        STA frmnumg
        STA frmnumd
        STA basg1
        LDA #$01
        STA dir
        LDA #$52
        STA basb+1
        LDA #$27
        STA basb
        LDA #$80
        STA basg2
        LDA #$50
        STA basd
        LDA #$15
        STA horzd
        JSR $F3D8               ; hgr2

;;; ------------------------------
;;; Controller
a:      JSR gremlin
        JSR keyboard
        JSR defender
        JSR missiles
        JSR barricades
        JSR gremlin
        JSR missiles
        LDA #$60
        JSR wait
        BIT brkd
        BPL a
        RTS

;;; ------------------------------
defender:       LDA dir
;;; stationary?
        BEQ draw                ; if stopped
;;; move left?
        BMI left                ; if moving left
;;; move right
        LDA horzd               ; if moving right
        CMP #$25                ; far right byte?
        BNE movrt               ; if not, then move
        LDA frmnumd
        CMP #$06                ; last posn?
        BNE movrt
        LDA #$00                ; if so, stop it
        STA dir
        BEQ draw                ; always
;;; ------------------------------
movrt:  INC frmnumd             ; keep moving right
        LDA frmnumd
        CMP #$07                ; past last frame?
        BNE draw                ;   if not, draw
        INC horzd               ; next byte to right
        LDA #$00                ; reset frmnumd to zero
        STA frmnumd
        BEQ draw                ; always
;;; ------------------------------
;;; (top of p280)
;;; ------------------------------
;;; move left
left:   LDA horzd               ; moving left
        CMP #$00                ; far left byte?
        BNE movlft              ; if not then move
        LDA frmnumd             ; last position?
        BNE movlft              ;   if not, then move
        LDA #$00                ;   if last posn
        STA dir                 ;     stop moving
        BEQ draw                ; always
movlft: DEC frmnumd             ; keep moving left
        BPL draw
        LDA #$06                ; if frmnumd is neg
        STA frmnumd             ;   reset it to 6
        DEC horzd               ;   and decrement horz index
;;; ------------------------------
draw:   LDA #$43                ; set defender base
        STA basd+1              ;   address to $4350
        LDA #$06                ; defender is
        STA height              ;   6 bytes high
;;; ------------------------------
;;; calculate index for defender data table
        LDA frmnumd             ; index is
        ASL                     ;   frmnumd x 2
        STA temp                ; temp has frmnumd x 2
        ASL
        ASL
        ASL                     ; acc has frmnumd x 16
        CLC
        ADC temp                ; acc has frmnumd x 18
        TAX                     ; X register gets index
;;; ------------------------------
draw1:  LDA #$03                 ; defender is
        STA width               ;   3 bytes wide
        LDY horzd               ; screen horz pos
draw2:  LDA datad,X             ; copy image
        STA (basd),Y            ;   to screen
        INX                     ; increment
        INY                     ;   indices
        DEC width               ; do this
        BNE draw2               ;   3 times
        CLC
        LDA basd+1              ; add $400 (1024)
        ADC #$04                ;   to defender's screen
        STA basd+1              ;   base address
        DEC height              ; do this
        BNE draw1               ;   6 times
        RTS
;;; ------------------------------
;;; (top-ish, p281)
;;; ------------------------------
gremlin:        LDA #$42        ; set gremlin screen base
        STA basg1+1             ;   addresses to
        STA basg2+1             ;   $4200 and $4280
        LDA #$08                ; gremlin is two parts,
        STA height              ;   each 8 bytes high
;;; ------------------------------
;;; calculate index
        LDA frmnumg             ; index is
        ASL                     ;   frmnumg x 24
        ASL
        ASL
        STA temp                ; temp has frmnumg x 8
        ASL                     ; acc has frmnumg x 16
        CLC
        ADC temp                ; acc has frmnumg x 24
        TAX                     ; X register gets index
;;; ------------------------------
grem1:  LDA #$03                ; gremlin is
        STA width               ;   3 bytes wide
        LDY horzg               ; index to gremlin screen loc
grem2:  LDA datg1,X             ; copy top of gremlin
        STA (basg1),Y           ;   to screen
        LDA datg2,X             ; copy bottom of gremlin
        STA (basg2),Y           ;   to screen
        INX                     ; increment
        INY                     ;   indices
        DEC width               ; do this
        BNE grem2               ;   3 times
        CLC
        LDA basg1+1             ; add $400 (1024)
        ADC #$04
        STA basg1+1             ; to gremlin screen base
        LDA basg2+1             ;   (move down
        ADC #$04                ;    one raster line)
        STA basg2+1            
        DEC height              ; do this
        BNE grem1               ;   8 times
        INC frmnumg             ; move right
        LDA frmnumg
        CMP #$07                ; past last frame
        BNE ret                 ;   if not, continue
        LDA #$00                ; if so,
        STA frmnumg             ;   reset frmnumg
        INC horzg               ;   move to next byte
        LDA horzg
        CMP #$24                ; at far right of screen?
        BNE ret                 ; if not, continue
        JSR eraseg              ; if so, erase image
        LDA #$00                ; go to left
        STA horzg               ;   of graphics screen
ret:    RTS
;;; ------------------------------
eraseg: LDA #$42                ; set gremlin screen base
        STA basg1+1             ;   addresses to
        STA basg2+1             ;   $4200 and $4280
        LDA #$08                ; gremlin is
        STA height              ;   8 bytes high
erg1:   LDA #$03                ; gremlin is
        STA width               ;   3 bytes wide
        LDY horzg               ; index to gremlin screen loc
        LDA #$00                ; store zeroes in
erg2:   STA (basg1),Y           ;   screen locations
        STA (basg2),Y           ;   which contained gremlin
        INY                     ; inc index
        DEC width               ; do this
        BNE erg2                ;   3 times
        CLC
        LDA basg1+1             ; add $400 (1024)
        ADC #$04                ;   to gremlin
        STA basg1+1             ;   screen base addresses
        LDA basg2+1
        ADC #$04                ; (move down one
        STA basg2+1             ;   raster line)
        DEC height              ; do this
        BNE erg1                ;   8 times
        RTS
;;; ------------------------------
;;; (top of page 283)
;;; ------------------------------
keyboard:       LDA kbd         ; read keyboard
        BPL rtn                 ; if no keypress, return
        CMP #$95                ; right arrow
        BNE kb1
        LDA #$01                ; signal to
        STA dir                 ;   move right
kb1:    CMP #$88                ; left arrow
        BNE kb2
        LDA #$FF                ; signal to
        STA dir                 ;   move left
kb2:    CMP #$AF                ; "/" key
        BNE kb3
        LDA #$00                ; signal for
        STA dir                 ;   no movement
kb3:    CMP #$A0                ; fire (space bar)
        BNE kb4
        LDA mflg                ; if missile is moving
        BMI kb4                 ;   don't launch another
        LDA #$01
        STA mflg                ; set missile flag
kb4:    LDA strobe
rtn:    RTS
;;; ------------------------------
barricades:     LDY #$28        ; screen index
        LDA brkd                ; get barricade code byte
brk1:   STA (basb),Y            ;   and store on screen
        DEY
        BNE brk1
        LDA brkd
        CMP #$7F                ; across screen?
        BNE brk2                ;   if not
        INC brkd                ; set exit signal
brk2:   RTS
;;; ------------------------------
delay:  LDA #$10
        JSR wait
        RTS
;;; ------------------------------
;;; (top of 284)
;;; ------------------------------
missiles:       LDA mflg
        BEQ delay               ; mflg = 0 : no missile
        BMI cont                ; mflg < 0 : continue a missile
        LDA #$FF                ; mflg > 0 : launch a new missile
        STA mflg                ; reset mflg
        LDA #$00
        STA colflg              ; zero collision flag
        LDA frmnumd
        STA mslnum              ; identify missile number
        LDA horzd               ; missile screen byte location
        STA horzm               ;   is 1 larger
        INC horzm               ;   than defender location
        LDA #$50                ; starting level
        STA mlevl               ;   of missile
;;; ------------------------------
cont:   LDX mlevl               ; serves as index
        DEC mlevl
        DEC mlevl
        LDA addr,X
        STA basmd               ; establish
        INX                     ;   screen base
        LDA addr,X              ;   address for
        STA basmd+1             ;   drawing missile
        INX
        LDA addr,X
        STA basme               ; establish
        INX                     ;   screen base
        LDA addr,X              ;   address for
        STA basme+1             ;   erasing missile
;;; ------------------------------
        LDX mslnum              ; missile index
        LDY horzm               ; index to screen byte location
        LDA mlevl               ; index to missile addres table
        CMP #$06                ; top of screen
        BNE drw                 ; if not there yet
        SEC                     ; missed gremlin
        ROL brkd                ; add a bit to barricades
        LDA #$00                ; reset missile flag
        STA mflg
        BEQ erase               ; always
;;; ------------------------------
;;; (bottom of 284)
;;; ------------------------------
drw:    LDA #$04                ; missile is
        STA height              ;   4 bytes high
drw1:   LDA misl,X              ; get missile bit pattern
        AND (basmd),Y           ; is bit on already?
        ORA colflg              ; if so, set collision flag
        STA colflg              ;   to nonzero
        BNE erase
        LDA misl,X              ; get missile bit pattern
        ORA (basmd),Y           ; add it to the
        STA (basmd),Y           ;   current screen contents
        CLC
        LDA basmd+1             ; add $400 (1024)
        ADC #$04                ;   to base address
        STA basmd+1             ;   (move down 1 raster line)
        DEC height              ; do this
        BNE drw1                ;   4 times
;;; ------------------------------
erase:  LDA #$04                ; missile is
        STA height              ;   4 bytes high
drw3:   LDA misl,X              ; get missile bit pattern
        AND (basme),Y           ; is bit already on?
        BEQ drw4                ; if not, don't erase it
        EOR (basme),Y           ; complementary draw
        STA (basme),Y           ;   to erase bit
drw4:   CLC                     ; add $400 (1024)
        LDA basme+1             ;   to base address
        ADC #$04                ;   (move down
        STA basme+1             ;    one raster line)
        DEC height              ; do this
        BNE drw3                ;   4 times
;;; ------------------------------
;;; exit
        LDA colflg              ; hit anything?
        BEQ rt1                 ; if no
;;; ------------------------------
hit:    LDA #$00                ; hit something!
        STA mflg                ; reset mflg
        LDA mlevl               ; if mlvl is
        CMP #$30                ;   less than 30
        BCS rt1                 ; then hit gremlin!
;;; ------------------------------
        JSR bell                ; hit gremlin! ring bell!
        JSR eraseg
        LDA #$00                ; start it at left
        STA horzg               ;   of screen
        CLC                     ; remove 1 bit
        ROR brkd                ; from barricades
rt1:    RTS

;;; ------------------------------
;;; (page 286)
;;; ------------------------------

datg1:  .DA 48, 12, 0, 124, 63, 0, 68, 35, 0, 70, 99, 0
        .DA 70, 99, 0, 126, 127, 0, 120, 31, 0, 72, 19, 0
;;; frame 2
        .DA 96, 24, 0, 120, 127, 0, 8, 71, 0, 12, 71, 1
        .DA 12, 71, 1, 124, 127, 1, 112, 63, 0, 16, 39, 0
;;; frame 3
        .DA 64, 49, 0, 112, 127, 1, 16, 14, 1, 24, 14, 3
        .DA 24, 14, 3, 120, 127, 3, 96, 127, 0, 32, 78, 0
;;; frame 4
        .DA 0, 99, 0, 96, 127, 3, 32, 28, 2, 48, 28, 6
        .DA 48, 28, 6, 112, 127, 7, 64, 127, 1, 64, 28, 1
;;; frame 5
        .DA 0, 70, 1, 64, 127, 7, 64, 56, 4, 96, 56, 12
        .DA 96, 56, 12, 96, 127, 15, 0, 127, 3, 0, 57, 2
;;; frame 6
        .DA 0, 12, 3, 0, 127, 15, 0, 113, 8, 64, 113, 24
        .DA 64, 113, 24, 64, 127, 31, 0, 126, 7, 0, 114, 4
;;; frame 7
        .DA 0, 24, 6, 0, 126, 31, 0, 98, 17, 0, 99, 49
        .DA 0, 99, 49, 0, 127, 63, 0, 124, 15, 0, 100, 9

datg2:  .DA 78, 115, 0, 14, 112, 0, 126, 127, 0 , 4, 32, 0
        .DA 4, 32, 0, 4, 32, 0, 14, 32, 0, 0, 112, 0
;;; frame 2
        .DA 28, 103, 1, 28, 96, 1, 124, 127, 1, 16, 16, 0
        .DA 16, 16, 0, 46, 16, 0, 0, 16, 0, 0, 56, 0
;;; frame 3
        .DA 56, 78, 3, 56, 64, 3, 120, 127, 3, 64, 8, 0
        .DA 64, 8, 0, 64, 8, 0, 96, 8, 0, 0, 28, 0
;;; frame 4
        .DA 112, 28, 7, 112, 0, 7, 112, 127, 7, 0, 34, 0
        .DA 0, 34, 0, 0, 34, 0, 0, 114, 0, 0, 7, 0
;;; frame 5
        .DA 96, 57, 14, 96, 1, 14, 96, 127, 15, 0, 2, 1
        .DA 0, 2, 1, 0, 66, 3, 0, 2, 0, 0, 7, 0
;;; frame 6
        .DA 64, 115, 28, 64, 3, 28, 64, 127, 31, 0, 2, 4
        .DA 0, 2, 4, 0, 2, 14, 0, 2, 0, 0, 7, 0
;;; frame 7
        .DA 0, 103, 57, 0, 7, 56, 0, 127, 63, 0, 2, 16
        .DA 0, 2, 16, 0, 2, 16, 0, 2, 16, 0, 7, 56

datad:  .DA 0, 1, 0, 0, 1, 0, 0, 1, 0
        .DA 6, 97, 0, 126, 127, 0, 126, 127, 0
;;; frame 2
        .DA 0, 2, 0, 0, 2, 0, 0, 2, 0
        .DA 12, 66, 1, 124, 127, 1, 124, 127, 1
;;; frame 3
        .DA 0, 4, 0, 0, 4, 0, 0, 4, 0
        .DA 24, 4, 3, 120, 127, 3, 120, 127, 3
;;; frame 4
        .DA 0, 8, 0, 0, 8, 0, 0, 8, 0
        .DA 48, 8, 6, 112, 127, 7, 112, 127, 7
;;; frame 5
        .DA 0, 16, 0, 0, 16, 0, 0, 16, 0
        .DA 96, 16, 12, 96, 127, 15, 96, 127, 15
;;; frame 6
        .DA 0, 32, 0, 0, 32, 0, 0, 32, 0
        .DA 64, 33, 24, 64, 127, 31, 64, 127, 31
;;; frame 7
        .DA 0, 64, 0, 0, 64, 0, 0, 64, 0
        .DA 0, 67, 48, 0, 127, 63, 0, 127, 63

misl:   .DA 1, 2, 4, 8, 16, 32, 64
addr:   .HS 0040005080408050
        .HS 0041005180418051
        .HS 0042005280428052
        .HS 0043005380438053
        .HS 28402850A840A850
        .HS 28412851A841A851
        .HS 28422852A842A852
        .HS 28432853A843A853
        .HS 50405050D040D050
        .HS 50415051D041D051
        .HS 50425052D042D052
        .HS 50435053D043D053

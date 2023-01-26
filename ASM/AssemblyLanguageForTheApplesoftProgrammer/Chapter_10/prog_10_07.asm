;;; Chapter 10 Program 10.7
;;; Build an 'A' with high-bit off

        .ORG $800
        .OUT "prog_10_07.obj"
        
hgr2:   .EQU $F3D8
keyin:  .EQU $FD1B


begin:  JSR hgr2                ; display hi-res page 2
        LDA #$01                ; top of the A
        STA $55BC
        LDA #$40                ; next line
        STA $59BB
        LDA #$02                ; next line
        STA $59BC
        LDA #$20                ; do all at once
        STA $5DBB
        STA $423B
        STA $4A3B
        STA $4E3B
        LDA #$04                ; do all at once
        STA $5DBC
        STA $423C
        STA $4A3C
        STA $4E3C
        LDA #$60                ; left crossbar
        STA $463B
        LDA #$07                ; right crossbar
        STA $463C

        JSR keyin
        RTS
        

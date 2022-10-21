includefrom "main.asm"

incsrc "inheritance2.asm"
incsrc "autolevels.asm"
incsrc "inheritance3.asm"
incsrc "inheritance_extra.asm"

ORG $848325
jumpSomewhere:
    lda $0004,Y ; 84:8325
    asl A ; 84:8328
    tax ; 84:8329
    jsr (.jumpTable,X) ; 84:832A
    jsr $82D5 ; 84:832D
    rts ; 84:8330
.jumpTable:
; determines which child to process?
dw .first, .second, .third, .fourth
; 83:8339
.fourth:
    ; load 0 then 1
    LDA #$0000 
    sta $0574 ; 84:833C
    jsl _84BAA1 ; 84:833F
    bra .second ; 84:8343
.third:
    ; load 1 or 0 based on a 50% chance
    lda #$0032 ; 84:8345
    jsl compareToRN ; 84:8348
    bcs .second ; 84:834C
.first:
    ; load only 0
    lda #$0000 ; $84:834E
    bra ._storeAndJump
.second:
    ; load only 1
    lda #$0001
._storeAndJump:
    sta $0574 ; 84:8356
    jsl _84BAA1
    rts
    
ORG $838993
inheritanceTable:
    dw $0012, $0016, $001a, $001e, $0022, $0026, $002a, $002e, $0032
    ; Deirdre's children
    dw $0019,$0000
    ; Ethlyn's children
    dw $001d,$002c
    ; Lachesis's children
    dw $0036,$003f
    ; Ayra's children
    dw $0032,$003a
    ; Erinys's children
    dw $0035,$003c
    ; Tailtiu's children
    dw $0038,$003d
    ; Sylvia's children
    dw $0034,$003e
    ; Edain's children
    dw $0037,$003b
    ; Brigid's children
    dw $0033,$0039
    
ORG $84BB1E
inheritanceFlagsTable:
    ; the first 9 entries are offsetss to the actual flags
    ; the offsets are the same as the inheritance table
    dw $0012, $0016, $001A, $001E, $0022, $0026, $002A, $002E, $0032
    ; flags for seliph + his non-existent sibling
    dw $FFFF, $FFFF
    ; flags for leif/altena
    dw $FFFF, $FFFF
    ; flags for Lachesis's children
    dw $001A, $0023
    ; flags for Ayra's children
    dw $0016, $001E
    ; flags for Erinys's children
    dw $0019, $0020
    ; flags for Tailtiu's children
    dw $001C, $0021
    ; flags for Sylvia's children
    dw $0018, $0022
    ; flags for Edain's children
    dw $001B, $001F
    ; flags for Brigid's children
    dw $0017, $001D
        
GetRNG = $80A73A
    
ORG $84EF9C
compareToRN:
    pha ; 84:EF9C
    jsl GetRNG ; 84:EF9D
    cmp $01,S ; 84:EFA1
    pla ; 84:EFA3
    rtl ; 84:EFA4
    
MoveTo565 = $82EF83
Restore565 = $82EFA0
    
ORG $84931A
_doInheritance1:
    ; may also be called froom $848808
    ; this uses non-children IDs? 
    ; so maybe this function doesn't just perform inheritance?
    phb ; 84:931A
    php ; 84:931B
    phk ; 84:931C
    plb ; 84:931D
    phx ; 84:931E
    phy ; 84:931F
    tay ; 84:9320
    ; now y = child unit ID
    lda #$7E00 ; 84:9321
    sta $25 ; 84:9324
    lda #$22D7 ; 84:9326
    sta $24 ; 84:9329
    ; stores the values in $24 and $25 into $0565/$0566
    ; existing values are saved to $0568/$0569
    jsl MoveTo565 ; 84:932B
    lda #$0013 ; 84:932F
    jsl _82EDE7 ; 84:9332
    lda $39 ; 84:9336
    sta.w UnitPointer; 84:9338
    lda #$7E00 ; 84:933B
    sta $055D ; 84:933E
    lda #$2243 ; 84:9341
    sta $055C ; 84:9344
    lda $39 ; 84:9347
    sta $054A ; 84:9349
    ; $054A = source for copying function
    ; so this copies unit data to $7E2243 
    ;
    ; if [$7E2244] < [$7E2243], no copying is done?
    ; $7E2245 controls the length to copy?
    ; $7E2246 has some flag which may skip copying
    jsl _82E465 ; 84:934C
    ; return value is immediately discarded 
    tya ; 84:9350 - Y is still the child unit ID
    jsl _848397 ; 84:9351
    inc $056D ; 84:9355
    jsl Restore565 ; 84:9358
    ply ; 84:935C
    plx ; 84:935D
    plp ; 84:935E
    plb ; 84:935F
    rtl ; 84:9360
    
ORG $82EDE7
_82EDE7:
    ; 
    ; accumulator value + 6 stored to $00
    ; sets flag #$20 in an address pointed to by $0565
    ; 
    phb ; 82:EDE7
    php ; 82:EDE8
    phk ; 82:EDE9
    plb ; 82:EDEA
    phy ; 82:EDEB
    tay ; 82:EDEC
    lda $00 ; 82:EDED
    pha ; 82:EDEF
    lda $04 ; 82:EDF0
    pha ; 82:EDF2
    sty $00 ; 82:EDF3
    lda $0565 ; 82:EDF5
    ora $0566 ; 82:EDF8
    beq .exit ; 82:EDFB
    lda $00 ; 82:EDFD
    clc ; 82:EDFF
    adc #$0006 ; 82:EE00
    sta $00 ; 82:EE03
    ldy $0565 ; 82:EE05
    sep #$20 ; 82:EE08
    lda $0567 ; 82:EE0A
    pha ; 82:EE0D
    rep #$20 ; 82:EE0E
    plb ; 82:EE10
    sep #$20 ; 82:EE11
    lda $0000,Y ; 82:EE13
    ora #$20 ; 82:EE16
    sta $0000,Y ; 82:EE18
    rep #$20 ; 82:EE1B
    ; looking for some spot in a list which has a value
    ; greater than what's in $00
    jsr _F032 ; 82:EE1D
    tay ; 82:EE20
    lda $0001,Y ; 82:EE21
    sec ; 82:EE24
    sbc $00 ; 82:EE25
    sta $0001,Y ; 82:EE27
    cmp #$0007 ; 82:EE2A
    bcs + ; 82:EE2D
    ; if the difference is less than 7, undo?
    clc ; 82:EE2F
    adc $00 ; 82:EE30
    sta $00 ; 82:EE32
    bra ++ ; 82:EE34
+:
    jsr addDifferenceToAddress ; 82:EE36
    tay ; 82:EE39
++:
    jsr _EFF4 ; 82:EE3A
    jsr _F022 ; 82:EE3D
    phk ; 82:EE40
    plb ; 82:EE41
    lda $0566 ; 82:EE42
    sta $3A ; 82:EE45
    tya ; 82:EE47
    clc ; 82:EE48
    adc #$0006 ; 82:EE49
    sta $39 ; 82:EE4C
.exit:
    ldy #$0000 ; 82:EE4E
    pla
    sta $04 ; 82:EE52
    pla ; 82:EE54
    sta $00 ; 82:EE55
    tya ; 82:EE57
    ply ; 82:EE58
    plp ; 82:EE59
    plb ; 82:EE5A
    rtl ; 82:EE5B
    
ORG $82EED2
_82EED2:
    ; sets flag #$40 in an address pointed to by $0565
    phb ; 82:EED2
    php ; 82:EED3
    phk ; 82:EED4
    plb ; 82:EED5
    phx ; 82:EED6
    phy ; 82:EED7
    lda $02 ; 82:EED8
    pha ; 82:EEDA
    lda $04 ; 82:EEDB
    pha ; 82:EEDD
    lda $06 ; 82:EEDE
    pha ; 82:EEE0
    lda $08 ; 82:EEE1
    pha ; 82:EEE3
    ldy $0565 ; 82:EEE4
    sep #$20 ; 82:EEE7
    lda $0567 ; 82:EEE9
    pha ; 82:EEEC
    rep #$20 ; 82:EEED
    plb ; 82:EEEF
    sep #$20 ; 82:EEF0
    lda $0000,Y ; 82:EEF2
    ora #$40 ; 82:EEF5
    sta $0000,Y ; 82:EEF7
    rep #$20 ; 82:EEFA
    lda $0001,Y ; 82:EEFC
    sta $04 ; 82:EEFF
    tya ; 82:EF01
    clc ; 82:EF02
    adc #$0008 ; 82:EF03
    tay ; 82:EF06
--:
    lda $0000,Y ; 82:EF07
    bit #$0080 ; 82:EF0A
    beq .break ; 82:EF0D
    jsr _F086 ; 82:EF0F
    tax ; 82:EF12
    lda $0000,X ; 82:EF13
    bit #$0040 ; 82:EF16
    bne .break ; 82:EF19
    lda $0003,X ; 82:EF1B
    sta $02 ; 82:EF1E
    jsr _F1EA ; 82:EF20
    lda $0001,Y ; 82:EF23
    sta $08 ; 82:EF26
    lda $0001,X ; 82:EF28
    sta $06 ; 82:EF2B
-:
    sep #$20 ; 82:EF2D
    lda $0000,X ; 82:EF2F
    sta $0000,Y ; 82:EF32
    rep #$20 ; 82:EF35
    inx ; 82:EF37
    iny ; 82:EF38
    dec $06 ; 82:EF39
    bne - ; 82:EF3B
    jsr _EFE1 ; 82:EF3D
    lda $08 ; 82:EF40
    sta $0001,Y ; 82:EF42
    jsr _F0EB ; 82:EF45
.break:
    jsr _F086 ; 82:EF48
    tay ; 82:EF4B
    cpy $04 ; 82:EF4C
    bcc -- ; 82:EF4E
    pla ; 82:EF50
    sta $08 ; 82:EF51
    pla ; 82:EF53
    sta $06 ; 82:EF54
    pla ; 82:EF56
    sta $04 ; 82:EF57
    pla ; 82:EF59
    sta $02 ; 82:EF5A
    ply ; 82:EF5C
    plx ; 82:EF5D
    plp ; 82:EF5E
    plb ; 82:EF5F
    rtl ; 82:EF60
    
ORG $82F022
_F022:
    lda $00 ; 82:F022
    sta $0001,Y ; 82:F024
    rts ; 82:F027
_F028:
    lda $00 ; 82:F028
    clc ; 82:F02A
    adc #$0006 ; 82:F02B
    sta $0001,Y ; 82:F02E
    rts ; 82:F031
_F032:
    jsr _F05A ; 82:F032
    bcs + ; 82:F035
.exit:
    rts ; 82:F037
+:
    ; end of the list in _F05A was reached
    ; this whole section seems to be a failsafe
    ; doesn't  seem to be hit in actual gameplay
    jsl _82EED2 ; 82:F038
    jsr _F05A ; 82:F03C
    bcs + ; 82:F03F
    bra .exit ; 82:F041
+:
    ; end of a list  was reached again
    sep #$20 ; 82:F043
    lda #$3F ; 82:F045
    ; Writes data to color math registers
    ; probably leftover debug code since it ends with a BRK
    sta $002131 ; 82:F047 
    lda #$32 ; 82:F04B
    sta $002132 ; 82:F04D
    lda #$C0 ; 82:F051
    sta $002132 ; 82:F053
    rep #$20 ; 82:F057
    db $00 
_F05A:
    ; search through a list for something 
    ; which is greater than or equal to a paremeter in $00
    ; length of the list is taken from an address in Y
    phy
    lda $0001,Y ; 82:F05B
    sta $04 ; 82:F05E
    tya ; 82:F060
    clc ; 82:F061
    adc #$0008 ; 82:F062
    tay ; 82:F065
-:
    lda $0000,Y ; 82:F066
    bit #$0080 ; 82:F069
    beq + ; 82:F06C
    lda $0001,Y ; 82:F06E
    cmp $00 ; 82:F071
    bcs .clearAndExit ; 82:F073
+:
    tya ; 82:F075
    clc ; 82:F076
    adc $0001,Y ; 82:F077
    tay ; 82:F07A
    cpy $04 ; 82:F07B
    bcc - ; 82:F07D
    ply ; 82:F07F
    sec ; 82:F080
    rts ; 82:F081
.clearAndExit:
    tya ; 82:F082
    ply ; 82:F083
    clc ; 82:F084
    rts ; 82:F085
addDifferenceToAddress:
_F086:
    tya ; 82:F086
    clc ; 82:F087
    adc $0001,Y ; 82:F088
    rts ; 82:F08B
    
ORG $8680BE
setFlagAt5297:
    phb ; 86:80BE
    php ; 86:80BF
    phk ; 86:80C0
    plb ; 86:80C1
    phx ; 86:80C2
    phy ; 86:80C3
    cmp #$0100 ; 86:80C4
    bcs .exit ; 86:80C7
    pha ; 86:80C9
    lsr A ; 86:80CA
    lsr A ; 86:80CB
    lsr A ; 86:80CC
    tay ; 86:80CD
    sep #$20 ; 86:80CE
    lda #$7E ; 86:80D0
    pha ; 86:80D2
    rep #$20 ; 86:80D3
    plb ; 86:80D5
    pla ; 86:80D6
    and #$0007 ; 86:80D7
    tax ; 86:80DA
    sep #$20 ; 86:80DB
    lda $5297,Y ; 86:80DD
    ora.l flagsTable,X ; 86:80E0
    sta $5297,Y ; 86:80E4
    rep #$20 ; 86:80E7
.exit:
    ply ; 86:80E9
    plx ; 86:80EA
    plp ; 86:80EB
    plb ; 86:80EC
    rtl ; 86:80ED
flagsTable:
db $01, $02, $04, $08, $10, $20, $40, $80

includefrom "romance.asm"

ORG $84918E
    jsl getLovePointIndex
    sep #$20
    sta $0002,y ; stores the love point table index
    
ORG $84A3E5
getGender:
    phb ; 84:A3E5
    php ; 84:A3E6
    phk ; 84:A3E7
    plb ; 84:A3E8
    phx ; 84:A3E9
    ldx.w UnitPointer ; 84:A3EA
    lda.l UnitPointers.Status,X ; 84:A3ED
    and #$00FF ; 84:A3F1
    cmp #$0003 
    beq .enemy ; 84:A3F7
    jsl loadFrom3rdPointer ; 84:A3F9
    lda $0005,X ; 84:A3FD
    and #$00FF ; 84:A400
.exit:
    plx
    plp ; 84:A404
    plb ; 84:A405
    rtl ; 84:A406
.enemy:
    jsl $84A737 ; 84:A407
    bra .exit ; 84:A40B
    
ORG $84A737
_load4thPtrIndex5:
    phb ; 84:A737
    php ; 84:A738
    phk ; 84:A739
    plb ; 84:A73A
    phx ; 84:A73B
    jsl loadFrom4thPointer ; 84:A73C
    lda $0005,X ; 84:A740
    bit #$0080 ; 84:A743
    bne + ; 84:A746
    and #$007F ; 84:A748
    bra .exit ; 84:A74B
+:
    ora #$FF80 ; 84:A74D
.exit:
    plx ; 84:A750
    plp ; 84:A751
    plb ; 84:A752
    rtl ; 84:A753
    
ORG $87ACC2
getLovePointIndex:
    phx ; 87:ACC2
    phy ; 87:ACC3
    lda $0574 ; 87:ACC4
    pha ; 87:ACC7
    jsl getUnitId ; 87:ACC8
    cmp #$0040 ; 87:ACCC
    bcs .skip ; 87:ACCF
    sta $0574 ; 87:ACD1
    jsl getGender ; 87:ACD4
    cmp #$0000 ; 87:ACD8
    bmi .skip ; 87:ACDB
    bne + ; 87:ACDD
    ; male
    ldx #maleTable ; 87:ACDF
    bra ++ ; 87:ACE2
+:
    ; female
    ldx.w #femaleTable ; 87:ACE4
++:
    ldy #$0000 ; 87:ACE7
-:
    lda.l bank(maleTable)<<16,X ; 87:ACEA
    bmi .exitA ; 87:ACEE
    cmp $0574 ; 87:ACF0
    beq .exitY ; 87:ACF3
    iny ; 87:ACF5
    inx ; 87:ACF6
    inx ; 87:ACF7
    bra - ; 87:ACF8
.exitA:
    ; character not found
    plx ; 87:ACFA
    stx $0574 ; 87:ACFB
    ply ; 87:ACFE
    plx ; 87:ACFF
    rtl ; 87:AD00
.exitY:    
    ; character found, lover point index is in Y
    tya ; 87:AD01
    plx ; 87:AD02
    stx $0574 ; 87:AD03
    ply ; 87:AD06
    plx ; 87:AD07
    rtl ; 87:AD08
.skip:
    lda #$FFFF ; 87:AD09
    bra .exitA ; 87:AD0C

ORG $849294
_849294:
    phy ; 84:9294
    lda $00 ; 84:9295
    pha ; 84:9297
    lda $0574 ; 84:9298
    pha ; 84:929B
    jsl $848C96 ; 84:929C
    jsl getUnitSupportID ; 84:92A0
    bcs ._930D ; 84:92A4
    cmp #$0010 ; 84:92A6
    bcs + ; 84:92A9
    lda #$0000 ; 84:92AB
    sta $7E0011,X ; 84:92AE
    sta $7E0010,X ; 84:92B2
    ldx #$002E ; 84:92B6
    lda #$0009
    sta $00
    bra .loop 
+:
    ldx $056F ; 84:92C0
    lda #$7E00
    sta $25 ; 84:92C6
    lda #$3BD7 ; 84:92C8
    sta $24 ; 84:92CB
    jsl $82EF72 ; 84:92CD
    lda #$001E ; 84:92D1
    jsl $82EDE7 ; 84:92D4
    lda $3A ; 84:92D8
    sta $7E0011,X ; 84:92DA
    lda $39 ; 84:92DE
    sta $7E0010,X ; 84:92E0
    ldx #$001C ; 84:92E4
    lda #$0010 ; 84:92E7
    sta $00 ; 84:92EA
.loop:
    lda $7E2000,X ; 84:92EC
    beq + ; 84:92F0
    sta $000574 ; 84:92F2
    jsl getStartingPoints ; 84:92F6
    jsl setStatingLovePoints ; 84:92FA - jumps to setStatingLovePoints
+:
    dex ; 84:92FE
    dex ; 84:92FF
    dec $00 ; 84:9300
    bne .loop ; 84:9302
    pla ; 84:9304
    sta $0574 ; 84:9305
    pla ; 84:9308
    sta $00 ; 84:9309
    ply ; 84:930B
    rts ; 84:930C
._930D:

ORG $87ABC1
getStartingPoints:
    phb ; 87:ABC1
    php ; 87:ABC2
    phk ; 87:ABC3
    plb ; 87:ABC4
    phx ; 87:ABC5
    ldx.w UnitPointer ; 87:ABC6
    phx ; 87:ABC9
    ldx $00 ; 87:ABCA
    phx ; 87:ABCC
    ldx $02 ; 87:ABCD
    phx ; 87:ABCF
    jsl getUnitSupportID ; 87:ABD0
    bcs ._AC3E ; 87:ABD4
    cmp #$0010 ; 87:ABD6
    bcs .female ; 87:ABD9
    jsl getPointIndex ; 87:ABDB
    sta $00 ; 87:ABDF
    lda $0574 ; 87:ABE1
    sta.w UnitPointer ; 87:ABE4
    jsl getPointIndex ; 87:ABE7
    asl A ; 87:ABEB
    sta $02 ; 87:ABEC
    bra + ; 87:ABEE
.female:
    jsl getPointIndex ; 87:ABF0
    asl A ; 87:ABF4
    sta $02 ; 87:ABF5
    lda $0574 ; 87:ABF7
    sta.w UnitPointer ; 87:ABFA
    jsl getPointIndex ; 87:ABFD
    sta $00 ; 87:AC01
+:
    ldx $02 ; 87:AC03
    lda.l baseSupportTable,X ; 87:AC05
    clc ; 87:AC09
    adc $00 ; 87:AC0A
    tax ; 87:AC0C
    lda.l baseSupportTable,X ; 87:AC0D
    and #$00FF ; 87:AC11
    cmp #$00FF ; 87:AC14
    beq + ; 87:AC17
    cmp #$00FE ; 87:AC19
    beq .loadMax ; 87:AC1C
    asl A ; 87:AC1E
    sta $00 ; 87:AC1F
    asl A ; 87:AC21
    asl A ; 87:AC22
    clc ; 87:AC23
    adc $00 ; 87:AC24
    bra .exit ; 87:AC26
.loadMax:
    lda #!max_points-1 ; 87:AC28
    bra .exit ; 87:AC2B
+:
    lda #$FFFF ; 87:AC2D
.exit:
    plx ; 87:AC30
    stx $02 ; 87:AC31
    plx ; 87:AC33
    stx $00 ; 87:AC34
    plx ; 87:AC36
    stx.w UnitPointer ; 87:AC37
    plx ; 87:AC3A
    plp ; 87:AC3B
    plb ; 87:AC3C
    rtl ; 87:AC3D
._AC3E:

ORG $87ADA6
setStatingLovePoints:
    phb ; 87:ADA6
    php ; 87:ADA7
    phk ; 87:ADA8
    plb ; 87:ADA9
    phx ; 87:ADAA
    phy ; 87:ADAB
    ldx.w UnitPointer ; 87:ADAC
    phx ; 87:ADAF
    ldx $00 ; 87:ADB0
    phx ; 87:ADB2
    ldx $02 ; 87:ADB3
    phx ; 87:ADB5
    sta $00 ; 87:ADB6
    ldy.w UnitPointer ; 87:ADB8
    jsl getUnitSupportID ; 87:ADBB
    cmp #$0010 ; 87:ADBF
    bcs + ; 87:ADC2
    dec A ; 87:ADC4
    sta $02 ; 87:ADC5
    lda $0574 ; 87:ADC7
    sta.w UnitPointer ; 87:ADCA
    bra ++ ; 87:ADCD
+:
    lda $0574 ; 87:ADCF
    sta.w UnitPointer ; 87:ADD2
    jsl getUnitSupportID ; 87:ADD5
    bcs .exit ; 87:ADD9
    dec A ; 87:ADDB
    sta $02 ; 87:ADDC
    sty.w UnitPointer ; 87:ADDE
++:
    jsl getLovePointTableAddress ; 87:ADE1
    cpx #$0000 ; 87:ADE5
    beq .exit ; 87:ADE8
    txa ; 87:ADEA
    asl $02 ; 87:ADEB
    clc ; 87:ADED
    adc $02 ; 87:ADEE
    tax ; 87:ADF0
    lda $00 ; 87:ADF1
    sta $0000,X ; 87:ADF3
.exit:
    plx ; 87:ADF6
    stx $02 ; 87:ADF7
    plx ; 87:ADF9
    stx $00 ; 87:ADFA
    plx ; 87:ADFC
    stx.w UnitPointer ; 87:ADFD
    ply ; 87:AE00
    plx ; 87:AE01
    plp ; 87:AE02
    plb ; 87:AE03
    rtl ; 87:AE04

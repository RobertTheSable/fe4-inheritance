includefrom "romance.asm"

TurnCount = $7E0D8F

ORG $8495E5
_getFlag:
    phb ; 84:95E5
    php ; 84:95E6
    phk ; 84:95E7
    plb ; 84:95E8
    phx ; 84:95E9
    jsl getUnitSupportPointer ; 84:95EA
    lda $0000,X ; 84:95EE
    plx ; 84:95F1
    plp ; 84:95F2
    plb ; 84:95F3
    rtl ; 84:95F4

ORG $84C33D
probablyLovePointProc:
    phb ; 84:C33D
    php ; 84:C33E
    phk ; 84:C33F
    plb ; 84:C340
    phx ; 84:C341
    lda.w TurnCount ; 84:C342
    cmp #$0033 ; 84:C345
    bcs .exit ; 84:C348
    lda $0D91 ; 84:C34A
+:
    bne .exit ; 84:C34D
    lda #$0000 ; 84:C34F
    jsl $84C412 ; 84:C352
    ldx #$0010 ; 84:C356
-:
    lda $7E201E,x
    beq + ; 84:C35D
    sta.w UnitPointer; 84:C35F
    jsl getUnitSupportID ; 84:C362
    bcs + ; 84:C366
    jsr addPassiveGrowth ; 84:C368
+:
    dex ; 84:C36B
    dex ; 84:C36C
    bpl - ; 84:C36D
    ldx #$008E ; 84:C36F
-:
    lda $7E438B,X ; 84:C37B
    bit #$0080 ; 84:C376
    beq + ; 84:C379
    lda $7E46EB,X ; 84:C37B
    sta.w UnitPointer; 84:C37F
    jsl getUnitSupportID ; 84:C382
    bcs + ; 84:C386
    cmp #$0010 ; 84:C388
    bcc + ; 84:C38B
    jsr addAdjacentBonus ; 84:C38D
+:
    dex ; 84:C390
    dex ; 84:C391
    bpl - ; 84:C392
.exit:
    plx ; 84:C394
    plp ; 84:C395
    plb ; 84:C396
    rtl ; 84:C397
addPassiveGrowth:
    phx ; 84:C398
    phy ; 84:C399
    ldy.w UnitPointer; 84:C39A
    ldx #$001C ; 84:C39D
-:
    lda $7E2000,x ; 84:C3A0
    beq +
    sta $0574 ; 84:C3A6
    ; getPassiveIncrease uses the point increase address
    ; for the secondary unit pointer.
    sty.w UnitPointer; 84:C3A9
    jsl getPassiveIncrease ; 84:C3AC
    sta.w PointIncrease ; 84:C3B0
    txa ; 84:C3B3
    lsr A ; 84:C3B4
    inc A ; 84:C3B5
    jsl increasePoints ; 84:C3B6
+:
    dex ; 84:C3BA
    dex ; 84:C3BB
    bpl - ; 84:C3BC
    ply ; 84:C3BE
    plx ; 84:C3BF
    rts ; 84:C3C0
addAdjacentBonus:
    phx ; 84:C3C1
    phy ; 84:C3C2
    stx $00 ; 84:C3C3
    ldx #$008E ; 84:C3C5
-:
    lda $7E438B,X
    bit #$0080 ; 84:C3CC
    beq .continue ; 84:C3CF
    lda $7E477B,X ; 84:C3D1 - value read and discarded
    bne .continue ; 84:C3D5
    stx $02 ; 84:C3D7
    ; subtracts ($7e441B + the current index) from ($7e441B + ($00))
    ; and subtracts ($7e444B + the current index) from ($7e444B + ($00))
    ; adds the absolute value of the two results together
    jsl calcDistance ; 84:C3D9
    cmp #$0002 ; 84:C3DD - distance check?
    bcs .continue ; 84:C3E0
    sta.w PointIncrease ; 84:C3E2
    lda #$0006 ; 84:C3E5
    sec ; 84:C3E8
    sbc.w PointIncrease ; 84:C3E9
    sta.w PointIncrease ; 84:C3EC
    ldy.w UnitPointer; 84:C3EF
    lda $7E46EB,X ; 84:C3F2
    sta.w UnitPointer; 84:C3F6
    jsl getUnitSupportID ; 84:C3F9
    bcs .continue ; 84:C3FD
    cmp #$0010 ; 84:C3FF 
    ; prevents two female units from getting points
    ; also causes jealousy because UnitPointer isn't reset
    bcs .continue ; 84:C402
    sty.w UnitPointer; 84:C404
    jsl increasePoints ; 84:C407
.continue:
    dex ; 84:C40B
    dex ; 84:C40C
    bpl - ; 84:C40D
    ply ; 84:C40F
    plx ; 84:C410
    rts ; 84:C411
    
ORG $84D4C7
calcDistance:
    phx ; 84:D4C7
    ldx $00 ; 84:D4C8
    lda $7E441B,X ; 84:D4CA
    ldx $02 ; 84:D4CE
    sec ; 84:D4D0
    sbc $7E441B,X ; 84:D4D1
    bpl + ; 84:D4D5
    eor #$FFFF ; 84:D4D7
    inc A ; 84:D4DA
+:
    sta $22 ; 84:D4DB
    ldx $00 ; 84:D4DD
    lda $7E44AB,X ; 84:D4DF
    ldx $02 ; 84:D4E3
    sec ; 84:D4E5
    sbc $7E44AB,X ; 84:D4E6
    bpl + ; 84:D4EA
    eor #$FFFF ; 84:D4EC
    inc A ; 84:D4EF
+:
    clc ; 84:D4F0
    adc $22 ; 84:D4F1
    plx ; 84:D4F3
    rtl ; 84:D4F4
    
ORG $87AE05
increasePoints:
    phb ; 87:AE05
    php ; 87:AE06
    phk ; 87:AE07
    plb ; 87:AE08
    phx ; 87:AE09
    phy ; 87:AE0A
    ldx $0576 ; 87:AE0B
    phx ; 87:AE0E
    ldx $0578 ; 87:AE0F
    phx ; 87:AE12
    cmp #$0010 ; 87:AE13
    bcs .exit ; 87:AE16 - exit if unit is female?
    sta $0576 ; 87:AE18
    jsl getUnitSupportID ; 87:AE1B
    bcs .exit ; 87:AE1F
    sta $0578 ; 87:AE21
    jsl getUnitLover ; 87:AE24
    ora #$0000 ; 87:AE28
    bne .exit ; 87:AE2B
    ; get address to love point growth?
    jsl getLovePointTableAddress ; 87:AE2D
    txa ; 87:AE31
    clc ; 87:AE32
    adc $0576 ; 87:AE33
    clc ; 87:AE36
    adc $0576 ; 87:AE37
    dec A ; 87:AE3A
    dec A ; 87:AE3B
    tay ; 87:AE3C
    lda $0000,Y ; 87:AE3D
    and #$01FF ; 87:AE40
    cmp #$01FF ; 87:AE43
    beq .exit ; 87:AE46
    lda.w PointIncrease ; 87:AE48
    beq .exit ; 87:AE4B
    bmi ++ ; 87:AE4D
    lda $0000,Y ; 87:AE4F
    clc ; 87:AE52
    adc.w PointIncrease ; 87:AE53
    cmp.w #!max_points ; 87:AE56
    bcs + ; 87:AE59
    sta $0000,Y ; 87:AE5B
    bra .exit ; 87:AE5E
+:
    lda.w #!max_points ; 87:AE60
    sta $0000,Y ; 87:AE63
    jsl setLover ; 87:AE66
    bra .exit ; 87:AE6A
++:
    lda $0000,Y ; 87:AE6C
    clc ; 87:AE6F
    adc.w PointIncrease ; 87:AE70
    bpl + ; 87:AE73
    lda #$0000 ; 87:AE75
+:
    sta $0000,Y ; 87:AE78
.exit:
    plx ; 87:AE7B
    stx $0578 ; 87:AE7C
    plx ; 87:AE7F
    stx $0576 ; 87:AE80
    ply ; 87:AE83
    plx ; 87:AE84
    plp ; 87:AE85
    plb ; 87:AE86
    rtl ; 87:AE87
    
ORG $87AC43
getLovePointTableAddress:
    ldx.w UnitPointer; 87:AC43
    sep #$20 ; 87:AC46
    lda.l UnitPointers.HolyPointerBank,X ; 87:AC48
    pha ; 87:AC4C
    rep #$20 ; 87:AC4D
    plb ; 87:AC4F
    lda.l UnitPointers.HolyPointer,X ; 87:AC50
    tax ; 87:AC54
    rtl ; 87:AC55
    
ORG $87AD0E
getPassiveIncrease:
    ; get regular love growth?
    phb ; 87:AD0E
    php ; 87:AD0F
    phk ; 87:AD10
    plb ; 87:AD11
    phx ; 87:AD12
    ldx.w UnitPointer; 87:AD13
    phx ; 87:AD16
    ldx $00 ; 87:AD17
    phx ; 87:AD19
    ldx $02 ; 87:AD1A
    phx ; 87:AD1C
    jsl getUnitSupportID ; 87:AD1D
    bcs .exitZero ; 87:AD21
    cmp #$0010 ; 87:AD23 -reverse order of calculation for female units
    bcs + ; 87:AD26
    jsl getPointIndex ; 87:AD28
    sta $00 ; 87:AD2C
    lda.w $0574 ; 87:AD2E
    sta.w UnitPointer; 87:AD31
    jsl getPointIndex ; 87:AD34
    asl A ; 87:AD38
    sta $02 ; 87:AD39
    bra ++ ; 87:AD3B
+:
    ; switch order of calulation based off of which unit is female
    jsl getPointIndex ; 87:AD3D
    asl A ; 87:AD41
    sta $02 ; 87:AD42
    lda.w $0574 ; 87:AD44
    sta.w UnitPointer; 87:AD47
    jsl getPointIndex ; 87:AD4A
    sta $00 ; 87:AD4E
++:
    ; $00 - male unit value
    ; $02 - female unit value * 2
    ldx $02 ; 87:AD50
    lda.l supportGrowthTable,X ; 87:AD52
    clc ; 87:AD56
    adc $00 ; 87:AD57
    tax ; 87:AD59
    lda.l supportGrowthTable,X ; 87:AD5A
    bit #$0080 ; 87:AD5E
    bne + ; 87:AD61
    and #$007F ; 87:AD63
    bra .exit ; 87:AD66
+:
    ora #$FF80 ; 87:AD68
.exit:
    plx ; 87:AD6B
    stx $02 ; 87:AD6C
    plx ; 87:AD6E
    stx $00 ; 87:AD6F
    plx ; 87:AD71
    stx.w UnitPointer; 87:AD72
    plx ; 87:AD75
    plp ; 87:AD76
    plb ; 87:AD77
    rtl ; 87:AD78
.exitZero:
    lda #$0000 ; 87:AD79
    bra .exit ; 87:AD7C
  
ORG $849622
getPointIndex:
    phb ; 84:9622
    php ; 84:9623
    phk ; 84:9624
    plb ; 84:9625
    phx ; 84:9626
    jsl getUnitSupportPointer ; 84:9627
    lda $0002,X ; 84:962B
    and #$00FF ; 84:962E
    plx
    plp ; 84:9632
    plb ; 84:9633
    rtl ; 84:9634

includeonce

GetAutolevelBonus = $80A0BA

ORG $87A80A
calculateAverages:
    stz $18 ; 87:A80A
    cmp #$0065 ; 87:A80C
    bcc + ; 87:A80F
    sec ; 87:A811
    sbc #$0064 ; 87:A812
    sta $18 ; 87:A815
    lda #$0064 ; 87:A817
+:
    jsl incrementLookup ; 87:A81A
    sta $14 ; 87:A81E
    lda $18 ; 87:A820
    beq + ; 87:A822
    jsl incrementLookup ; 87:A824
    clc ; 87:A828
    adc $14 ; 87:A829
    sta $14 ; 87:A82B
+:
    lda $00 ; 87:A82D
    dec A ; 87:A82F
    xba ; 87:A830
    sta $16 ; 87:A831
    jsl GetAutolevelBonus ; 87:A833
    lda $1A ; 87:A837
    rts ; 87:A839
getCombination:
    ; divides some combination of $00, $02 by 10 and adds $04 to the result
    ; formula depends on unit gender
    ; male (0) = [$04] + ([$00] + ([$02] *2)) / 10 
    ; female (1) = [$04] + ([$02] + ([$00] *2)) / 10 
    
ORG $80A899
incrementLookup:
    ora #$0000 ; 80:A899
    beq .exit ; 80:A89C
    phx ; 80:A89E
    dec A ; 80:A89F
    asl A ; 80:A8A0
    tax ; 80:A8A1
    lda $80A8A8,X ; 80:A8A2
    plx ; 80:A8A6
.exit:
    rtl ; 80:A8A7
.table:
    ; the nummber in this table * character level = autolevel bonus
    dw $0002, $0005, $0007, $000A, $000C, $000F, $0011, $0014 
    dw $0017, $0019, $001C, $001E, $0021, $0023, $0026, $0028 
    dw $002B, $002E, $0030, $0033, $0035, $0038, $003A, $003D 
    dw $0040, $0042, $0045, $0047, $004A, $004C, $004F, $0051 
    dw $0054, $0057, $0059, $005C, $005E, $0061, $0063, $0066 
    dw $0068, $006B, $006E, $0070, $0073, $0075, $0078, $007A 
    dw $007D, $0080, $0082, $0085, $0087, $008A, $008C, $008F 
    dw $0091, $0094, $0097, $0099, $009C, $009E, $00A1, $00A3 
    dw $00A6, $00A8, $00AB, $00AE, $00B0, $00B3, $00B5, $00B8 
    dw $00BA, $00BD, $00C0, $00C2, $00C5, $00C7, $00CA, $00CC 
    dw $00CF, $00D1, $00D4, $00D7, $00D9, $00DC, $00DE, $00E1
    dw $00E3, $00E6, $00E8, $00EB, $00EE, $00F0, $00F3, $00F5
    dw $00F8, $00FA, $00FD, $0100

macro AddHolyBloodBonus(offset, param)
    phb
    php 
    phk
    plb
    phx
    lda.w #<param>
    jsl getHolyBloodBonus
    sta $0574
    jsl loadFrom3rdPointer
    lda.w <offset>,X
    and #$00FF
    clc
    adc $0574
    jsr checkForNegative
    plx
    plp
    plb
    rtl
endmacro

ORG $84A464
    ; these calls happen before extra HB is removed
    ; so calculations for Seliph inlude Loptyr bonuses
    ; These are only used for autolevel bonuses though,
    ; so in normal gameplay it never matters.
getHPGrowth:
    ; 84A464
    ; HP
    %AddHolyBloodBonus($0007, 0)
checkForNegative:
    ; return 0 if the accumulator is negative
    bpl +
    lda #$0000
+:
    rts
getStrengthGrowth:
    ; Strength
    ; 84A48E
    %AddHolyBloodBonus($0008, 1)
getMagicGrowth:
    ; Magic
    ; 84A4B2
    %AddHolyBloodBonus($0009, 2)
getSkillGrowth:
    ; Skill
    ; 84A4D6
    %AddHolyBloodBonus($000A, 3)
getSpeedGrowth:
    ; Speed
    ; 84A4FA
    %AddHolyBloodBonus($000B, 4)
getLuckGrowth:
    ; Luck
    ; 84A51E
    %AddHolyBloodBonus($000C, 5)
getResGrowth:
    ; Resistance
    ; 84A542
    %AddHolyBloodBonus($000D, 6)
getDefGrowth:
    ; Defense
    ; 84A566
    %AddHolyBloodBonus($000E, 7)
    
    
HolyBloodOffsetTable = $8389C9
HolyBloodBonusTable = $8389CB
    
ORG $84A649
getHolyBloodBonus:
    phb
    php ; 84:A64A
    phk ; 84:A64B
    plb ; 84:A64C
    phx ; 84:A64D
    phy ; 84:A64E
    ldx $00 ; 84:A64F
    phx ; 84:A651
    ldx $02 ; 84:A652
    phx ; 84:A654
    sta $0574 ; 84:A655
    stz $02 ; 84:A658
    ldy #$000C ; 84:A65A
-:
    tya
    ; returns 0, 1, or 2
    ; depending on what level of holy blood is found
    ; 0 = none, 1 = minor, 2 = major?
    jsl checkHolyBlood ; 84:A65E
    ora #$0000 ; 84:A662
    beq .continue
    sta $00 ; 84:A667
    tya ; 84:A669
    asl A ; 84:A66A
    tax ; 84:A66B
    lda.l HolyBloodOffsetTable,X ; 84:A66C
    ; $0574 = the second parameter given to StatMacro
    adc $0574 ; 84:A670
    tax ; 84:A673
    lda.l HolyBloodBonusTable,X ; 84:A674
    ; if 84A5C0 returns 2, this value is halved
    bit #$0080 ; 84:A678
    bne +
    and #$007F ; 84:A67D
    bra ++
+:
    ; extends the negative sign for negative bonuses
    ora #$FF80 ; 84:A682
++:
    dec $00 ; 84:A685
    beq +
    asl
+:
    clc ; 84:A68A
    adc $02 ; 84:A68B
    sta $02 ; 84:A68D
.continue:
    dey ; 84:A68F
    bpl - ; 84:A690
    lda $02 ; 84:A692
    plx ; 84:A694
    stx $02 ; 84:A695
    plx ; 84:A697
    stx $00 ; 84:A698
    ply ; 84:A69A
    plx ; 84:A69B
    plp ; 84:A69C
    plb ; 84:A69D
    rtl ; 84:A69E

ORG $84A5C0
checkHolyBlood:
    ; holy blood inheritance
    phb ; 84:A5C0
    php ; 84:A5C1
    phk ; 84:A5C2
    plb ; 84:A5C3
    phx ; 84:A5C4
    phy ; 84:A5C5
    ldx $00 ; 84:A5C6
    phx ; 84:A5C8
    sta $00 ; 84:A5C9
    ldx.w UnitPointer ; 84:A5CB
    lda $7E0000,X ; 84:A5CE
    and #$00FF ; 84:A5D2
    cmp #$0003
    beq .exitZero ; 84:A5D8
    jsl loadFrom3rdPointer ; 84:A5DA
    txy ; 84:A5DE
    lda $00 ; 84:A5DF
    asl A ; 84:A5E1
    tax ; 84:A5E2
    tya ; 84:A5E3
    clc ; 84:A5E4
    adc.l .offsetTable,X ; 84:A5E5
    tay ; 84:A5E9
    lda.l .dataTable,X ; 84:A5EA
    lsr A ; 84:A5EE
    ora.l .dataTable,X ; 84:A5EF
    and $0000,Y ; 84:A5F3
    beq .exit ; 84:A5F6
    cmp.l .dataTable,X ; 84:A5F8
    bcc + ; 84:A5FC
    lda #$0002 ; 84:A5FE
    bra .exit
+:
    lda #$0001
    bra .exit ; 84:A606
.exit:
    plx ; 84:A608
    stx $00 ; 84:A609
    ply ; 84:A60B
    plx ; 84:A60C
    plp ; 84:A60D
    plb ; 84:A60E
    rtl ; 84:A60F
.exitZero:
    lda #$0000
    bra .exit
.offsetTable:
    dw $0012, $0012, $0012, $0012, $0012, $0012, $0012, $0012
    dw $0014, $0014, $0014, $0014, $0014
.dataTable:
    dw $0002, $0008, $0020, $0080, $0200, $0800, $2000, $8000
    dw $0002, $0008, $0020, $0080, $0200
    
    

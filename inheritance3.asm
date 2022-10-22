includefrom "inheritance.asm"

incsrc "inherited_bases.asm"
incsrc "holyblood.asm"

; a function that pushes the program counter bank and pulls the data bank
; :v
SetPBToPC = $83F7C1

ORG $848481
getUnitTypeAddress:
    phb ; 84:8481
    php ; 84:8482
    phk ; 84:8483
    plb ; 84:8484
    phx ; 84:8485
    dec A ; 84:8486
    bmi ._84AE ; 84:8487
    pha ; 84:8489
    lda $838002 ; 84:848A
    tax ; 84:848E
    pla ; 84:848F
    asl A ; 84:8490
    cmp $838000,X ; 84:8491
    bcs ._84AE ; 84:8495
    clc ; 84:8497
    adc $838002 ; 84:8498
    tax ; 84:849C
    lda $838000,X ; 84:849D
    clc ; 84:84A1
    adc $838002 ; 84:84A2
    adc #$8000 ; 84:84A6
    plx ; 84:84A9
    plp ; 84:84AA
    plb ; 84:84AB
    clc ; 84:84AC
.exit:
    rtl ; 84:84AD
._84AE:
    plx ; 84:84AE
    plp ; 84:84AF
    plb ; 84:84B0
    sec ; 84:84B1
    bra .exit ; 84:84B2

ORG $848397
_848397:
    phb ; 84:8397
    phk ; 84:8398
    plb ; 84:8399
    jsl SetPBToPC ; 84:839A
    jsl getUnitTypeAddress ; 84:839E
    tay ; 84:83A2
    lda $0000,Y ; 84:83A3
    ; argument here = unit type?
    and #$00FF ; 84:83A6
    asl A ; 84:83A9
    tax ; 84:83AA
    jsr (.jumpTable,X) ; 84:83AB
    plb ; 84:83AE
    rtl ; 84:83AF
.jumpTable
    dw staticUnit, dynamicUnit, holyUnit, enemyUnit
    
; copies an address saved in $24-$26 to $0565-$0567
move24To565 = $82EF72

ORG $848F17
staticUnit:
    phx ; 84:8F17
    lda #$7E00 ; 84:8F18
    sta $25 ; 84:8F1B
    lda #$29E7 ; 84:8F1D
    sta $24 ; 84:8F20
    jsl move24To565 ; 84:8F22
    ldx $056F ; 84:8F26
    sep #$20 ; 84:8F29
    lda #$00 ; 84:8F2B
    sta.l UnitPointers.Status,X ; 84:8F2D
    rep #$20 ; 84:8F31
    lda #$001E ; 84:8F33
    jsl _82EDE7 ; 84:8F36
    lda $3A ; 84:8F3A
    sta.l UnitPointers.Lover+1,X ; 84:8F3C
    lda $39 ; 84:8F40
    clc ; 84:8F42
    adc #$0000 ; 84:8F43
    sta.l UnitPointers.Lover,X ; 84:8F46
    lda $3A ; 84:8F4A
    sta.l UnitPointers.Stats+1,X ; 84:8F4C
    lda $39 ; 84:8F50
    clc ; 84:8F52
    adc #$000F ; 84:8F53
    sta.l UnitPointers.Stats,X ; 84:8F56
    lda #$83AD ; 84:8F5A
    sta.l UnitPointers.Unknown2+1,X ; 84:8F5D
    tya ; 84:8F61
    clc ; 84:8F62
    adc #$000D ; 84:8F63
    sta.l UnitPointers.Unknown2,X ; 84:8F66
    lda #$0000 ; 84:8F6A
    sta.l UnitPointers.Unknown3+1,X ; 84:8F6D
    sta.l UnitPointers.Unknown3,X ; 84:8F71
    jsr $91B8 ; 84:8F75
    jsr $9148 ; 84:8F78
    jsr $9247 ; 84:8F7B - starting inventory is set here
    jsr $9294 ; 84:8F7E
    plx ; 84:8F81
    rts ; 84:8F82
    
AutoLevelBuffer = $7E4EC5
Parent1StatsBuffer = $7FEB66
Parent2StatsBuffer = $7FEBF4
    
dynamicUnit:
    ; All kids use this function?
    phx ; 84:8F83
    ldx $056F ; 84:8F84
    
macro CopyParentBases(source, currentStatBuffer, unitBuffer)
    lda.b <source>
    sta.w UnitPointer
    lda.w #bank(<currentStatBuffer>)<<8 
    sta $058E 
    lda.w #<currentStatBuffer>
    sta $058D 
    jsl copyCurrentBases
    lda.w #bank(<unitBuffer>)<<8 
    sta $058E 
    lda.w #<unitBuffer>
    sta $058D
    jsl copyUnitBases
endmacro
    %CopyParentBases($02, Parent1StatsBuffer, $7FEB84) ; 84:8F87
    %CopyParentBases($00, Parent2StatsBuffer, $7FEC12) ; 84:8FAC
    stx.w UnitPointer ; 84:8FD1
    lda $02 ; 84:8FD4
    pha ; 84:8FD6
    lda $00 ; 84:8FD7
    pha ; 84:8FD9
    lda #$7E00 ; 84:8FDA
    sta $25 ; 84:8FDD
    lda #$2D4F ; 84:8FDF
    sta $24 ; 84:8FE2
    jsl move24To565 ; 84:8FE4
    sep #$20 ; 84:8FE8
    lda #$01 ; 84:8FEA
    sta.l UnitPointers.Status,X ; 84:8FEC
    rep #$20 ; 84:8FF0
    lda #$0034 ; 84:8FF2
    jsl _82EDE7 ; 84:8FF5 - find unit slot?
    
    lda $3A ; 84:8FF9
    sta.l UnitPointers.Lover+1,X ; 84:8FFB
    lda $39 ; 84:8FFF
    clc ; 84:9001
    adc #$0000 ; 84:9002 - ???
    sta.l UnitPointers.Lover,X ; 84:9005
    
    lda $3A ; 84:9009
    sta.l UnitPointers.Stats+1,X ; 84:900B
    lda $39 ; 84:900F
    clc ; 84:9011
    adc #$000F ; 84:9012
    sta.l UnitPointers.Stats,X ; 84:9015
    
    lda $3A ; 84:9019
    sta.l UnitPointers.Unknown2+1,X ; 84:901B
    lda $39 ; 84:901F
    clc ; 84:9021
    adc #$001E ; 84:9022
    sta.l UnitPointers.Unknown2,X ; 84:9025
    
    lda #$0000 ; 84:9029
    sta UnitPointers.Unknown3+1,X ; 84:902C
    sta UnitPointers.Unknown3,X ; 84:9030
    
    jsl $87A869 ; 84:9034 - sets holy blood
    jsl setInheritedBases ; 84:9038
    jsr $9148 ; 84:903C
    jsr $9247 ; 84:903F
    jsr $9294 ; 84:9042
    pla ; 84:9045
    sta $00 ; 84:9046
    pla ; 84:9048
    sta $02 ; 84:9049
    lda $000B,Y ; 84:904B
    and #$00FF ; 84:904E
    bne + ; 84:9051
    lda $02 ; 84:9053
    sta $04 ; 84:9055
    bra .exit ; 84:9057
+:
    lda $00 ; 84:9059
    sta $04 ; 84:905B
.exit:
    jsl _87AA39 ; 84:905D - sets inventory
    plx ; 84:9061
    rts ; 84:9062
    
holyUnit:
    phx ; 84:9063
    lda #$7E00 ; 84:9064
    sta $25 ; 84:9067
    lda #$3131 ; 84:9069
    sta $24 ; 84:906C
    jsl move24To565 ; 84:906E
    ldx $056F ; 84:9072
    sep #$20 ; 84:9075
    lda #$02 ; 84:9077
    sta.l UnitPointers.Status,X ; 84:9079
    rep #$20 ; 84:907D
    lda #$000F ; 84:907F
    jsl _82EDE7 ; 84:9082
    lda $3A ; 84:9086
    sta.l UnitPointers.Lover+1,X ; 84:9088
    lda $39 ; 84:908C
    clc ; 84:908E
    adc #$0000 ; 84:908F
    sta.l UnitPointers.Lover,X ; 84:9092
    lda #$83AD ; 84:9096
    sta.l UnitPointers.Stats+1,X ; 84:9099
    tya ; 84:909D
    clc ; 84:909E
    adc #$0001 ; 84:909F
    sta.l UnitPointers.Stats,X ; 84:90A2
    lda #$83AD ; 84:90A6
    sta.l UnitPointers.Unknown2+1,X ; 84:90A9
    tya ; 84:90AD
    clc ; 84:90AE
    adc #$000D ; 84:90AF
    sta.l UnitPointers.Unknown2,X ; 84:90B2
    lda #$0000 ; 84:90B6
    sta.l UnitPointers.Unknown3+1,X ; 84:90B9
    sta.l UnitPointers.Unknown3,X ; 84:90BD
    lda #$0000 ; 84:90C1
    sta.l UnitPointers.HolyPointer+1,X ; 84:90C4
    sta.l UnitPointers.HolyPointer,X ; 84:90C8
    jsr $9148 ; 84:90CC
    jsr $9247 ; 84:90CF
    plx ; 84:90D2
    rts ; 84:90D3
enemyUnit:

GetChildLevel = $849E23

ORG $87A6E6
setInheritedBases:
    phb ; 87:A6E6
    php ; 87:A6E7
    phk ; 87:A6E8
    plb ; 87:A6E9
    phx ; 87:A6EA
    phy ; 87:A6EB
    lda $00 ; 87:A6EC
    pha ; 87:A6EE
    lda $02 ; 87:A6EF
    pha ; 87:A6F1
    lda $06 ; 87:A6F2
    pha ; 87:A6F4
    jsl getGender ; 87:A6F5
    sta $06 ; 87:A6F9
    phy ; 87:A6FB
    ldx.w UnitPointer ; 87:A6FC
    sep #$20 ; 87:A6FF
    lda.l UnitPointers.StatsBank,X ; 87:A701
    pha ; 87:A705
    rep #$20 ; 87:A706
    plb ; 87:A708
    lda.l UnitPointers.Stats,X ; 87:A709
    tay ; 87:A70D
    plx ; 87:A70E
    sep #$20 ; 87:A70F
    lda $830001,X ; 87:A711
    sta $0008,Y ; 87:A715
    lda $830002,X ; 87:A718
    sta $0009,Y ; 87:A71C
    lda #$00 ; 87:A71F
    sta $000A,Y ; 87:A721
    sta $000D,Y ; 87:A724
    rep #$20 ; 87:A727
    jsl $87A438 ; 87:A729
    lda $7E2000 ; 87:A72D
    beq + ; 87:A731
    lda $7E2002 ; 87:A733
    jsl $84A191 ; 87:A737
+:
    lda $7FEB7C ; 87:A73B
    clc ; 87:A73F
    adc $7FEC0A ; 87:A740
    sta $18 ; 87:A744
    lda #$0000 ; 87:A746
    adc #$0000 ; 87:A749
    sta $1A ; 87:A74C
    lda #$000A ; 87:A74E
    sta $1C ; 87:A751
    stz $1E ; 87:A753
    jsl $80A1D8 ; 87:A755
    lda $18 ; 87:A759
    clc ; 87:A75B
    adc #$07D0 ; 87:A75C
    sta $000B,Y ; 87:A75F
    jsl GetChildLevel ; 87:A762
    sta $00 ; 87:A766
    jsl getHPGrowth ; 87:A768
    jsr calculateAverages ; 87:A76C
    clc ; 87:A76F
    adc #$000F ; 87:A770
    ; 7E4EC5 = bonus table?
    sta.l AutoLevelBuffer ; 87:A773
    jsl getStrengthGrowth ; 87:A777
    jsr calculateAverages ; 87:A77B
    sta.l AutoLevelBuffer+2 ; 87:A77E
    jsl getMagicGrowth ; 87:A782
    jsr calculateAverages ; 87:A786
    sta.l AutoLevelBuffer+4 ; 87:A789
    jsl getSkillGrowth ; 87:A78D
    jsr calculateAverages ; 87:A791
    sta.l AutoLevelBuffer+6 ; 87:A794
    jsl getSpeedGrowth ; 87:A798
    jsr calculateAverages ; 87:A79C
    sta.l AutoLevelBuffer+8 ; 87:A79F
    jsl getLuckGrowth ; 87:A7A3
    jsr calculateAverages ; 87:A7A7
    sta.l AutoLevelBuffer+10 ; 87:A7AA
    jsl getResGrowth ; 87:A7AE
    jsr calculateAverages ; 87:A7B2
    sta.l AutoLevelBuffer+12 ; 87:A7B5
    jsl getDefGrowth ; 87:A7B9
    jsr calculateAverages ; 87:A7BD
    sta.l AutoLevelBuffer+14 ; 87:A7C0
    phy ; 87:A7C4
    ldx #$0000 ; 87:A7C5
-:
    lda.l Parent1StatsBuffer,X ; 87:A7C8 - parent stats?
    sta $00 ; 87:A7CC
    lda.l Parent2StatsBuffer,X ; 87:A7CE - other parent stats?
    sta $02 ; 87:A7D2
    lda.l AutoLevelBuffer,X ; 87:A7D4 - autolevel bonuses
    sta $04 ; 87:A7D8
    jsr getCombination ; 87:A7DA
    sep #$20 ; 87:A7DD
    sta $0000,Y ; 87:A7DF
    rep #$20 ; 87:A7E2
    inx ; 87:A7E4
    inx ; 87:A7E5
    iny ; 87:A7E6
    cpx #$0010 ; 87:A7E7
    bcc - ; 87:A7EA
    ply ; 87:A7EC
    lda #$000A ; 87:A7ED
    jsl $80A70E ; 87:A7F0
    inc A ; 87:A7F4
    clc ; 87:A7F5
    adc $0007,Y ; 87:A7F6
    sta $0007,Y ; 87:A7F9
    pla ; 87:A7FC
    sta $06 ; 87:A7FD
    pla ; 87:A7FF
    sta $02 ; 87:A800
    pla ; 87:A802
    sta $00 ; 87:A803
    ply ; 87:A805
    plx ; 87:A806
    plp ; 87:A807
    plb ; 87:A808
    rtl ; 87:A809

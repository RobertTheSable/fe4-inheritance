includeonce

struct UnitPointers $7e0000
    .Status: skip 1
    .Lover: skip 2
    .LoverBank: skip 1
    .Stats: skip 2
    .StatsBank: skip 1
    ; Unknown2 or Unknown3 may contain the Unit ID depending on if the unit is an enemy?
    ; also contains skills and holy blood
    .Unknown2: skip 2
    .Unknown2Bank: skip 1
    ; 4th pointer only seems to be used by enemies
    .Unknown3: skip 2
    .Unknown3Bank: skip 1
    ; 
    .Inventory: skip 2
    .InventoryBank: skip 1
    ; 6th pointer only seems to be used by "holy" units
    .HolyPointer: skip 2
    .HolyPointerBank: skip 1
endstruct

; actually located at $7e3d8B, but 
struct ItemList $7e0000
    .Id: skip 1
    .Uses: skip 1
    .Location: skip 1 
    ; location values: 
    ; 1 = held by unit
    ; 2 = in storage
    ; 4 = in armory
    ; 5 = in pawn shop
    ; 7 = uninherited
    .Owner: skip 2
    ; owner is a pointer to the owning unit
    .Kills: skip 1
endstruct

UnitPointer = $056F

ItemList = $7E3D87

ChapterNumber = $7E0D6A

ChapterDataPointer = $7E0D6C

ChapterDataPointersTable = $86C760

ORG $8484B4
searchForUnit:
    phb ; 84:84B4
    phx ; 84:84B5
    ldx $4C ; 84:84B6
    phx ; 84:84B8
    ldx $4E ; 84:84B9
    phx ; 84:84BB
    sta $4C ; 84:84BC
    sep #$20 ; 84:84BE
    lda.b #$7E ; 84:84C0
    pha ; 84:84C2
    rep #$20 ; 84:84C3
    plb ; 84:84C5
    lda $2243 ; 84:84C6
    and #$00FF ; 84:84C9
    asl A ; 84:84CC
    sta $4E ; 84:84CD
    ldx.w #$0000 ; 84:84CF
-:
    lda $2247,x ; 84:84D2
    sta.w UnitPointer
    jsl getUnitId ; 84:84D8
    cmp $4C ; 84:84DC
    beq + ; 84:84DE
    inx ; 84:84E0
    inx ; 84:84E1
    cpx $4E ; 84:84E2
    bcc - ; 84:84E4
    ; exit with carry set
    stz.w UnitPointer ; 84:84E6
    sec ; 84:84E9
-:
    pla ; 84:84EA
    sta $4E ; 84:84EB
    pla ; 84:84ED
    sta $4C ; 84:84EE
    plx ; 84:84F0
    plb ; 84:84F1
    rtl ; 84:84F2
+:
    ; exit with carry clear
    clc ; 84:84F3
    bra - ; 84:84F4
    
ORG $849488
getUnitSupportPointer:
    ldx.w UnitPointer ; 84:9488
    sep #$20 ; 84:948B
    lda.l UnitPointers.LoverBank,X ; 84:948D
    pha ; 84:9491
    rep #$20 ; 84:9492
    plb ; 84:9494
    lda.l UnitPointers.Lover,X ; 84:9495
    tax ; 84:9499
    rtl ; 84:949A

ORG $849635
getUnitLover:
    ; returns the ID of the unit's lover
    phb ; 84:9635
    php ; 84:9636
    phk ; 84:9637
    plb ; 84:9638
    phx ; 84:9639
    jsl getUnitSupportPointer ; 84:963A
    lda $0003,X ; 84:963E
    and #$00FF ; 84:9641
    plx ; 84:9644
    plp ; 84:9645
    plb ; 84:9646
    rtl ; 84:9647
    
    
ORG $8498ED
getUnitStatsAddress:
    ldx.w UnitPointer; 84:98ED
    sep #$20 ; 84:98F0
    lda.l UnitPointers.StatsBank,X ; 84:98F2
    pha ; 84:98F6
    rep #$20 ; 84:98F7
    plb ; 84:98F9
    lda.l UnitPointers.Stats,X ; 84:98FA
    tax ; 84:98FE
    rtl ; 84:98FF

ORG $84A1A7
loadFrom3rdPointer:
    ; unknown2 is actually the 3rd pointer in the struct
    ldx.w UnitPointer ; 84:A1A7
    sep #$20 ; 84:A1AA
    lda.l UnitPointers.Unknown2Bank,X ; 84:A1AC
    pha ; 84:A1B0
    rep #$20 ; 84:A1B1
    plb ; 84:A1B3
    lda.l UnitPointers.Unknown2,X ; 84:A1B4
    tax ; 84:A1B8
    rtl ; 84:A1B9
    
ORG $84A333
getUnitId:
    phb ; 84:A333
    php ; 84:A334
    phk ; 84:A335
    plb ; 84:A336
    phx ; 84:A337
    ldx.w UnitPointer ; 84:A338
    lda.l UnitPointers.Status,X ; 84:A33B
    and.w #$00FF ; 84:A33F
    cmp #$0003
    beq + ; 84:A345
    jsl loadFrom3rdPointer ; 84:A347
    lda $0000,X ; 84:A34B
-:
    plx ; 84:A34E
    plp ; 84:A34F
    plb ; 84:A350
    rtl ; 84:A351
+:
    ; enemy
    jsl _84A704
    bra -
    

ORG $84A02D
getUnitClass:
    phb ; 84:A02D
    php ; 84:A02E
    phk ; 84:A02F
    plb ; 84:A030
    phx ; 84:A031
    ldx.w UnitPointer ; 84:A032
    lda.l UnitPointers.Status,X ; 84:A035
    and #$00FF ; 84:A039
    cmp #$0003 ; 84:A03C
    beq .enemy ; 84:A03F
    jsl getUnitStatsAddress ; 84:A041
    lda $0008,X ; 84:A045
    and #$00FF ; 84:A048
.exit:
    plx ; 84:A04B
    plp ; 84:A04C
    plb ; 84:A04D
    rtl ; 84:A04E
.enemy:
    jsl $84A724 ; 84:A04F
    bra .exit ; 84:A053
    
ORG $84A358
getUnitSupportID:
    phb ; 84:A358
    php ; 84:A359
    phk ; 84:A35A
    plb ; 84:A35B
    phx ; 84:A35C
    ; "jealousy" occurs when the incorrect ID is loaded here
    ldx.w UnitPointer; 84:A35D
    lda.l UnitPointers.Status,X ; 84:A360
    and #$00FF ; 84:A364
    cmp #$0003 ; should only be 3 for enemies?
    beq .useOtherPointer ; 84:A36A
    jsl loadFrom3rdPointer ; 84:A36C
    lda $0004,X ; 84:A370
    and #$00FF ; 84:A373
    bit #$0080
    bne + ; 84:A379 to $A399
    and #$007F ; 84:A37B
    tax
    jsl _getFlag ; 84:A37F
    bit #$0200 ; 84:A383
    ; check if dead?
    bne .setAndExit ; to $A398
    txa
    plx ; 84:A389
    plp ; 84:A38A
    plb ; 84:A38B
    clc ; 84:A38C
.exit:
    rtl ; 84:A38D
.useOtherPointer:
    jsl $84A77A ; 84:A38E
    plx ; 84:A392
    plp ; 84:A393
    plb ; 84:A394
    sec ; 84:A395
    bra .exit ; 84:A396
.setAndExit:
    txa ; 84:A398
+:
    and #$007F ; 84:A399
    plx
    plp ; 84:A39D
    plb ; 84:A39E
    sec ; 84:A39F
    bra .exit ; 84:A3A0
    
ORG $84A714
_84A714:
    phb ; 84:A714
    php ; 84:A715
    phk ; 84:A716
    plb ; 84:A717
    phx ; 84:A718
    jsl loadFrom4thPointer ; 84:A719
    lda $0002,X ; 84:A71D
    plx ; 84:A720
    plp ; 84:A721
    plb ; 84:A722
    rtl ; 84:A723
    
ORG $84A77A
    phb ; 84:A77A
    php ; 84:A77B
    phk ; 84:A77C
    plb ; 84:A77D
    phx ; 84:A77E
    jsl loadFrom4thPointer ; 84:A77F
    lda $0008,X ; 84:A783
    and #$00FF ; 84:A786
    plx ; 84:A789
    plp ; 84:A78A
    plb ; 84:A78B
    rtl ; 84:A78C
    

ORG $84A6F1
loadFrom4thPointer:
    ; skips status check - so only used by enemies?
    ldx.w UnitPointer
    sep #$20
    lda UnitPointers.Unknown3Bank,X ; 84:A6F6
    pha ; 84:A6FA
    rep #$20 ; 84:A6FB
    plb ; 84:A6FD
    lda UnitPointers.Unknown3,X ; 84:A6FE
    tax
    rtl
_84A704:
    phb ; 84:A704
    php ; 84:A705
    phk ; 84:A706
    plb ; 84:A707
    phx ; 84:A708
    jsl loadFrom4thPointer ; 84:A709
    lda $0000,X ; 84:A70D
    plx ; 84:A710
    plp ; 84:A711
    plb ; 84:A712
    rtl ; 84:A713

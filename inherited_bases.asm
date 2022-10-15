includeonce

ORG $849900
copyCurrentBases:
    ; copies parent's current bases to a buffer
    ; for some reason it also stores their class pointer to $057A
    ; (maybe it's used outside of inheritance)
    phb ; 84:9900
    php ; 84:9901
    phk ; 84:9902
    plb ; 84:9903
    phx ; 84:9904
    phy ; 84:9905
    lda $24 ; 84:9906
    pha ; 84:9908
    lda $25 ; 84:9909
    pha ; 84:990B
    jsl getBasesForUnitClass ; 84:990C
    jsl getUnitStatsAddress ; 84:9910
    lda $058E ; 84:9914
    sta $25 ; 84:9917
    lda $058D ; 84:9919
    sta $24 ; 84:991C
    ldy #$0000 ; 84:991E
    lda $0000,X ; 84:9921
    and #$00FF ; 84:9924
    sta [$24],Y ; 84:9927
    ldy #$0002 ; 84:9929
    lda $0001,X ; 84:992C
    and #$00FF ; 84:992F
    sta [$24],Y ; 84:9932
    ldy #$0004 ; 84:9934
    lda $0002,X ; 84:9937
    and #$00FF ; 84:993A
    sta [$24],Y ; 84:993D
    ldy #$0006 ; 84:993F
    lda $0003,X ; 84:9942
    and #$00FF ; 84:9945
    sta [$24],Y ; 84:9948
    ldy #$0008 ; 84:994A
    lda $0004,X ; 84:994D
    and #$00FF ; 84:9950
    sta [$24],Y ; 84:9953
    ldy #$000A ; 84:9955
    lda $0005,X ; 84:9958
    and #$00FF ; 84:995B
    sta [$24],Y ; 84:995E
    ldy #$000C ; 84:9960
    lda $0006,X ; 84:9963
    and #$00FF ; 84:9966
    sta [$24],Y ; 84:9969
    ldy #$000E ; 84:996B
    lda $0007,X ; 84:996E
    and #$00FF ; 84:9971
    sta [$24],Y ; 84:9974
    ldy #$0010 ; 84:9976
    lda $0008,X ; 84:9979
    and #$00FF ; 84:997C
    sta [$24],Y ; 84:997F
    ldy #$0012 ; 84:9981
    lda $0009,X ; 84:9984
    and #$00FF ; 84:9987
    sta [$24],Y ; 84:998A
    ldy #$0016 ; 84:998C
    lda $000B,X ; 84:998F
    sta [$24],Y ; 84:9992
    ldy #$0018 ; 84:9994
    lda $000D,X ; 84:9997
    and #$00FF ; 84:999A
    sta [$24],Y ; 84:999D
    ldy #$001A ; 84:999F
    lda $000E,X ; 84:99A2
    and #$00FF ; 84:99A5
    sta [$24],Y ; 84:99A8
    pla ; 84:99AA
    sta $25 ; 84:99AB
    pla ; 84:99AD
    sta $24 ; 84:99AE
    ply ; 84:99B0
    plx ; 84:99B1
    plp ; 84:99B2
    plb ; 84:99B3
    rtl ; 84:99B4
    
ORG $84A1BA
copyUnitBases:
    phb ; 84:A1BA
    php ; 84:A1BB
    phk ; 84:A1BC
    plb ; 84:A1BD
    phx ; 84:A1BE
    phy ; 84:A1BF
    lda $24 ; 84:A1C0
    pha ; 84:A1C2
    lda $25 ; 84:A1C3
    pha ; 84:A1C5
    jsl loadFrom3rdPointer ; 84:A1C6
    lda $058E ; 84:A1CA
    sta $25 ; 84:A1CD
    lda $058D ; 84:A1CF
    sta $24 ; 84:A1D2
    ldy #$0000 ; 84:A1D4
    jsl getUnitId ; 84:A1D7
    sta [$24],Y ; 84:A1DB
    ldy #$0002 ; 84:A1DD
    jsl _84A3A2 ; 84:A1E0 - stores something from the 3rd pointer to $0571
    sta [$24],Y ; 84:A1E4
    ldy #$0006 ; 84:A1E6
    lda $0005,X ; 84:A1E9
    and #$00FF ; 84:A1EC
    sta [$24],Y ; 84:A1EF
    ldy #$0008 ; 84:A1F1
    lda $0006,X ; 84:A1F4
    and #$00FF ; 84:A1F7
    sta [$24],Y ; 84:A1FA
    ldy #$000A ; 84:A1FC
    lda $0007,X ; 84:A1FF
    and #$00FF ; 84:A202
    sta [$24],Y ; 84:A205
    ldy #$000C ; 84:A207
    lda $0008,X ; 84:A20A
    and #$00FF ; 84:A20D
    sta [$24],Y ; 84:A210
    ldy #$000E ; 84:A212
    lda $0009,X ; 84:A215
    and #$00FF ; 84:A218
    sta [$24],Y ; 84:A21B
    ldy #$0010 ; 84:A21D
    lda $000A,X ; 84:A220
    and #$00FF ; 84:A223
    sta [$24],Y ; 84:A226
    ldy #$0012 ; 84:A228
    lda $000B,X ; 84:A22B
    and #$00FF ; 84:A22E
    sta [$24],Y ; 84:A231
    ldy #$0014 ; 84:A233
    lda $000C,X ; 84:A236
    and #$00FF ; 84:A239
    sta [$24],Y ; 84:A23C
    ldy #$0016 ; 84:A23E
    lda $000D,X ; 84:A241
    and #$00FF ; 84:A244
    sta [$24],Y ; 84:A247
    ldy #$0018 ; 84:A249
    lda $000E,X ; 84:A24C
    and #$00FF ; 84:A24F
    sta [$24],Y ; 84:A252
    ldy #$001A ; 84:A254
    lda $000F,X ; 84:A257
    sta [$24],Y ; 84:A25A
    ldy #$001C ; 84:A25C
    lda $0011,X ; 84:A25F
    and #$00FF ; 84:A262
    sta [$24],Y ; 84:A265
    ldy #$001E ; 84:A267
    lda $0012,X ; 84:A26A
    sta [$24],Y ; 84:A26D
    ldy #$0020 ; 84:A26F
    lda $0014,X ; 84:A272
    sta [$24],Y ; 84:A275
    pla ; 84:A277
    sta $25 ; 84:A278
    pla ; 84:A27A
    sta $24 ; 84:A27B
    ply ; 84:A27D
    plx ; 84:A27E
    plp ; 84:A27F
    plb ; 84:A280
    rtl ; 84:A281
    
ORG $84A3A2
_84A3A2:
    phb ; 84:A3A2
    php ; 84:A3A3
    phk ; 84:A3A4
    plb ; 84:A3A5
    phx ; 84:A3A6
    ldx.w UnitPointer ; 84:A3A7
    lda.l UnitPointers.Status,X ; 84:A3AA
    and #$00FF ; 84:A3AE
    cmp #$0003 ; 84:A3B1
    beq .enemy ; 84:A3B4
    jsl loadFrom3rdPointer ; 84:A3B6
    lda $0002,X ; 84:A3BA
.return:
    pha ; 84:A3BD
    asl A ; 84:A3BE
    clc ; 84:A3BF
    adc $838000 ; 84:A3C0
    tax ; 84:A3C4
    lda #$8300 ; 84:A3C5
    sta $0572 ; 84:A3C8
    lda $838000,X ; 84:A3CB
    clc ; 84:A3CF
    adc $838000 ; 84:A3D0
    adc #$8000 ; 84:A3D4
    sta $0571 ; 84:A3D7
    pla ; 84:A3DA
    plx ; 84:A3DB
    plp ; 84:A3DC
    plb ; 84:A3DD
    rtl ; 84:A3DE
.enemy:
    jsl _84A714 ; 84:A3DF
    bra .return

ORG $84A084
getBasesForUnitClass:
    phb ; 84:A084
    php ; 84:A085
    phk ; 84:A086
    plb ; 84:A087
    phx ; 84:A088
    jsl getUnitClass ; 84:A089
    jsl getClassAddress ; 84:A08D
    plx ; 84:A091
    plp ; 84:A092
    plb ; 84:A093
    rtl ; 84:A094

ORG $87A49D
getClassAddress:
    phb ; 87:A49D
    php ; 87:A49E
    phk ; 87:A49F
    plb ; 87:A4A0
    phx ; 87:A4A1
    asl A ; 87:A4A2
    clc ; 87:A4A3
    adc $838006 ; 87:A4A4
    tax ; 87:A4A8
    lda $838000,X ; 87:A4A9
    clc ; 87:A4AD
    adc $838006 ; 87:A4AE
    adc #$8000 ; 87:A4B2
    sta $057A ; 87:A4B5
    plx ; 87:A4B8
    plp ; 87:A4B9
    plb ; 87:A4BA
    rtl ; 87:A4BB

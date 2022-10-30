includeonce 

ORG $82E493
popFromList:
; remove an item from a list?
; (opposite of _82E55D?)
; slot to take is $0550
; sets carry if the input is out of bounds
    phb ; 82:E493
    php ; 82:E494
    phk ; 82:E495
    plb ; 82:E496
    phx ; 82:E497
    phy ; 82:E498
    ldx $055C ; 82:E499
    sep #$20 ; 82:E49C
    lda $055E ; 82:E49E
    pha ; 82:E4A1
    rep #$20 ; 82:E4A2
    plb ; 82:E4A4
    lda $0003,X ; 82:E4A5
    bit #$0080 ; 82:E4A8
    bne .exit ; 82:E4AB
    lda $0002,X ; 82:E4AD
    and #$00FF ; 82:E4B0
    sta $000554 ; 82:E4B3
    sep #$20 ; 82:E4B7
    lda $000550 ; 82:E4B9
    beq .setAndExit ; 82:E4BD
    cmp $0000,X ; 82:E4BF
    bcc + ; 82:E4C2
    beq .skipItem ; 82:E4C4
    bra .setAndExit ; 82:E4C6
+:
    phx ; 82:E4C8
    lda $0000,X ; 82:E4C9
    rep #$20 ; 82:E4CC
    and #$00FF ; 82:E4CE
    sec ; 82:E4D1
    sbc $000550 ; 82:E4D2
    inc A ; 82:E4D6
    jsr multiply ; 82:E4D7
    sta $000556 ; 82:E4DA
    lda $000550 ; 82:E4DE
    jsr multiply ; 82:E4E2
    clc ; 82:E4E5
    adc $00055C ; 82:E4E6
    tax ; 82:E4EA
    clc ; 82:E4EB
    adc $000554 ; 82:E4EC
    tay ; 82:E4F0
-:
    sep #$20 ; 82:E4F1
    lda $0004,Y ; 82:E4F3
    sta $0004,X ; 82:E4F6
    rep #$20 ; 82:E4F9
    iny ; 82:E4FB
    inx ; 82:E4FC
    lda $000556 ; 82:E4FD
    dec A ; 82:E501
    sta $000556 ; 82:E502
    bne - ; 82:E506
    plx ; 82:E508
.skipItem:
    rep #$20 ; 82:E509
    lda $0000,X ; 82:E50B
    dec A ; 82:E50E
    sta $0000,X ; 82:E50F
.exit:
    ply ; 82:E512
    plx ; 82:E513
    plp ; 82:E514
    plb ; 82:E515
    clc ; 82:E516
    rtl ; 82:E517
.setAndExit:
    rep #$20 ; 82:E518
    ply ; 82:E51A
    plx ; 82:E51B
    plp ; 82:E51C
    plb ; 82:E51D
    sec ; 82:E51E
    rtl ; 82:E51F

; returns a pointer to some object in a list
; ($055C) contains the pointer to the list
; [$055C] is the size of the list
; [$055C]+2 is the entry size of the list.
; the ourput address is stored in $054A
ORG $82E810
getNthItemAddress:
    phb ; 82:E810
    php ; 82:E811
    phk ; 82:E812
    plb ; 82:E813
    phy ; 82:E814
    ldy $055C ; 82:E815
    sep #$20 ; 82:E818
    lda $055E ; 82:E81A
    pha ; 82:E81D
    rep #$20 ; 82:E81E
    plb ; 82:E820
    lda $0000,Y ; 82:E821
    and #$00FF ; 82:E824
    cmp $000550 ; 82:E827
    bcc .outOfBounds ; 82:E82B
    lda $0002,Y ; 82:E82D
    and #$00FF ; 82:E830
    sta $000554 ; 82:E833
    lda $00055D ; 82:E837
    sta $00054B ; 82:E83B
    lda $000550 ; 82:E83F
    jsr multiply ; 82:E843
    clc ; 82:E846
    adc #$0004 ; 82:E847
    clc ; 82:E84A
    adc $00055C ; 82:E84B
    sta $00054A ; 82:E84F
    ply ; 82:E853
    plp ; 82:E854
    plb ; 82:E855
    clc ; 82:E856
    rtl ; 82:E857
.outOfBounds:
    ply ; 82:E858
    plp ; 82:E859
    plb ; 82:E85A
    sec ; 82:E85B
    rtl ; 82:E85C

ORG $82E8EA
multiply:
    ; performs multiplication?
    phb ; 82:E8EA
    php ; 82:E8EB
    phk ; 82:E8EC
    plb ; 82:E8ED
    dec A ; 82:E8EE
    bmi .exit ; 82:E8EF
    beq .exit ; 82:E8F1
    cmp #$0004 ; 82:E8F3
    bcs .fourPlus ; 82:E8F6
    cmp #$0003 ; 82:E8F8
    beq .three ; 82:E8FB
    cmp #$0002 ; 82:E8FD
    beq .two ; 82:E900
    lda $0554 ; 82:E902
    bra .exit ; 82:E905
.two:
    ; returns $0554 *  2
    lda $0554 ; 82:E907
    asl A ; 82:E90A
    bra .exit ; 82:E90B
.three:
    ; returns $0554 *  3
    lda $0554 ; 82:E90D
    asl A ; 82:E910
    clc ; 82:E911
    adc $0554 ; 82:E912
    bra .exit ; 82:E915
.fourPlus:
    ; returns $0554 * A
    ; why not use the math registers? who knows.
    phx ; 82:E917
    xba ; 82:E918
    sta $0558 ; 82:E919
    lda $0554 ; 82:E91C
    sta $055A ; 82:E91F
    lda #$0000 ; 82:E922
    ldx #$0008 ; 82:E925
-:
    asl A
    asl $0558 ; 82:E929
    ; note: asl on $0558 inlcudes $0559
    bcc + ; 82:E92C
    clc ; 82:E92E
    adc $055A ; 82:E92F
+:
    dex ; 82:E932
    bne - ; 82:E933
    plx ; 82:E935
.exit:
    plp ; 82:E936
    plb ; 82:E937
    rts ; 82:E938
    
copyBytes:
    ; copies ($0554) bytes from $054A to ((($0554)* (A - 1)) + 4)
    ; $054A may either contain the string to copy
    ; or a pointer to the string if ($0554) >= 4
    php ; 82:E939
    phy ; 82:E93A
    jsr multiply ; 82:E93B
    clc ; 82:E93E
    adc $00055C ; 82:E93F
    tay ; 82:E943
    lda $000554 ; 82:E944
    ; the argument is the number of bytes to copy
    cmp #$0004 ; 82:E948
    bcs .moreThan4 ; 82:E94B
    cmp #$0003 ; 82:E94D
    beq .three ; 82:E950
    cmp #$0002 ; 82:E952
    beq .two ; 82:E955
    sep #$20 ; 82:E957
    lda $00054A ; 82:E959
    sta $0004,Y ; 82:E95D
    rep #$20 ; 82:E960
    bra .exit ; 82:E962
.two:
    lda $00054A ; 82:E964
    sta $0004,Y ; 82:E968
    bra .exit ; 82:E96B
.three:
    lda $00054A ; 82:E96D
    sta $0004,Y ; 82:E971
    lda $00054B ; 82:E974
    sta $0005,Y ; 82:E978
    bra .exit ; 82:E97B
.moreThan4:
    lda $000554 ; 82:E97D
    pha ; 82:E981
    lda $54 ; 82:E982
    pha ; 82:E984
    lda $55 ; 82:E985
    pha ; 82:E987
    phx ; 82:E988
    lda $00054A ; 82:E989
    sta $54 ; 82:E98D
    lda $00054B ; 82:E98F
    sta $55 ; 82:E993
    sep #$20 ; 82:E995
    tyx ; 82:E997
    ldy #$0000 ; 82:E998
-:
    lda [$54],y ; 82:E99B
    sta $0004,x
    iny
    inx ; 82:E9A1
    lda $000554 ; 82:E9A2
    dec A ; 82:E9A6
    sta $000554 ; 82:E9A7
    bne - ; 82:E9AB
    rep #$20 ; 82:E9AD
    plx ; 82:E9AF
    pla ; 82:E9B0
    sta $55 ; 82:E9B1
    pla ; 82:E9B3
    sta $54 ; 82:E9B4
    pla ; 82:E9B6
    sta $000554 ; 82:E9B7
.exit:
    ply ; 82:E9BB
    plp ; 82:E9BC
    rts ; 82:E9BD
copyBytesFrom:
    ; copies ($0554) bytes from A * ($0554) + ($055C) into a list at $054A
    ; if ($0554) >= 4, $054A is used as an indirect address instead.
    ; ...this is exactly the same as $82E939, but this pushes and pulls X for no reason
    php ; 82:E9BE
    phx ; 82:E9BF
    phy ; 82:E9C0
    jsr multiply ; 82:E9C1
    clc ; 82:E9C4
    adc $00055C ; 82:E9C5
    tay ; 82:E9C9
    lda $000554 ; 82:E9CA
    cmp #$0004 ; 82:E9CE
    bcs .moreThan4 ; 82:E9D1
    cmp #$0003 ; 82:E9D3
    beq .three ; 82:E9D6
    cmp #$0002 ; 82:E9D8
    beq .two ; 82:E9DB
    sep #$20 ; 82:E9DD
    lda $0004,Y ; 82:E9DF
    sta $00054A ; 82:E9E2
    rep #$20 ; 82:E9E6
    bra .exit ; 82:E9E8
.two:
    lda $0004,Y ; 82:E9EA
    sta $00054A ; 82:E9ED
    bra .exit ; 82:E9F1
.three:
    lda $0004,Y ; 82:E9F3
    sta $00054A ; 82:E9F6
    lda $0005,Y ; 82:E9FA
    sta $00054B ; 82:E9FD
    bra .exit ; 82:EA01
.moreThan4:
    lda $000554 ; 82:EA03
    pha ; 82:EA07
    lda $54 ; 82:EA08
    pha ; 82:EA0A
    lda $55 ; 82:EA0B
    pha ; 82:EA0D
    lda $00054A ; 82:EA0E
    sta $54 ; 82:EA12
    lda $00054B ; 82:EA14
    sta $55 ; 82:EA18
    sep #$20 ; 82:EA1A
    tyx ; 82:EA1C
    ldy #$0000 ; 82:EA1D
-:
    lda $0004,X ; 82:EA20
    sta [$54],Y ; 82:EA23
    inx ; 82:EA25
    iny ; 82:EA26
    lda $000554 ; 82:EA27
    dec A ; 82:EA2B
    sta $000554 ; 82:EA2C
    bne - ; 82:EA30
    rep #$20 ; 82:EA32
    pla ; 82:EA34
    sta $55 ; 82:EA35
    pla ; 82:EA37
    sta $54 ; 82:EA38
    pla ; 82:EA3A
    sta $000554 ; 82:EA3B
.exit:
    ply ; 82:EA3F
    plx ; 82:EA40
    plp ; 82:EA41
    rts ; 82:EA42
    
; sets carry if an event flag is set, clears it if not
CheckEventFlagSet = $869A50

SetEventFlag = $8699D6

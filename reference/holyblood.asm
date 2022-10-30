includeonce

ORG $87A869
setHolyBlood:
    phb ; 87:A869
    php ; 87:A86A
    phk ; 87:A86B
    plb ; 87:A86C
    phx ; 87:A86D
    phy ; 87:A86E
    lda $00 ; 87:A86F
    pha ; 87:A871
    lda $02 ; 87:A872
    pha ; 87:A874
    lda $04 ; 87:A875
    pha ; 87:A877
    lda $06 ; 87:A878
    pha ; 87:A87A
    lda $08 ; 87:A87B
    pha ; 87:A87D
    phy ; 87:A87E
    ldx.w UnitPointer ; 87:A87F
    sep #$20 ; 87:A882
    lda.l UnitPointers.Unknown2Bank,X ; 87:A884
    pha ; 87:A888
    rep #$20 ; 87:A889
    plb ; 87:A88B
    lda.l UnitPointers.Unknown2,X ; 87:A88C
    tay ; 87:A890
    plx ; 87:A891
    phx ; 87:A892
    phy ; 87:A893
    lda #$0007 ; 87:A894
    sta $04 ; 87:A897
    sep #$20 ; 87:A899
-:
    lda $830003,X ; 87:A89B
    sta $0000,Y ; 87:A89F
    inx ; 87:A8A2
    iny ; 87:A8A3
    dec $04 ; 87:A8A4
    bne - ; 87:A8A6
    
    rep #$20 ; 87:A8A8
    ply ; 87:A8AA
    lda $7FEC12 ; 87:A8AB
    sep #$20 ; 87:A8AF
    sta $0006,Y ; 87:A8B1
    rep #$20 ; 87:A8B4
    phy ; 87:A8B6
    lda $0005,Y ; 87:A8B7
    and #$00FF ; 87:A8BA
    sta $04 ; 87:A8BD
    ldx #$000A ; 87:A8BF
-:
    lda $7FEB84,X ; 87:A8C2
    sta $00 ; 87:A8C6
    lda $7FEC12,X ; 87:A8C8
    sta $02 ; 87:A8CC
    jsr $A9EA ; 87:A8CE
    sep #$20 ; 87:A8D1
    sta $0007,Y ; 87:A8D3
    rep #$20 ; 87:A8D6
    inx ; 87:A8D8
    inx ; 87:A8D9
    iny ; 87:A8DA
    cpx #$001A ; 87:A8DB
    bcc - ; 87:A8DE
    
    ply ; 87:A8E0
    lda $0000,Y ; 87:A8E1
    sec ; 87:A8E4
    sbc #$0019 ; 87:A8E5
    sta $06 ; 87:A8E8
    asl A ; 87:A8EA
    clc ; 87:A8EB
    adc $06 ; 87:A8EC
    tax ; 87:A8EE
    lda $7FEB9E ; 87:A8EF
    ora $7FEC2C ; 87:A8F3
    and $87A975,X ; 87:A8F7
    sta $000F,Y ; 87:A8FB
    lda $7FEB9F ; 87:A8FE
    ora $7FEC2D ; 87:A902
    and $87A976,X ; 87:A906
    sta $0010,Y ; 87:A90A
    plx ; 87:A90D
    lda $83000B,X ; 87:A90E
    and #$00FF ; 87:A912
    beq + ; 87:A915
    
    lda $7FEBA2 ; 87:A917
    sta $00 ; 87:A91B
    lda $7FEC30 ; 87:A91D
    sta $02 ; 87:A921
    jsr mergeHolyblood ; 87:A923
    sta $0012,Y ; 87:A926
    
    lda $7FEBA4 ; 87:A929
    sta $00 ; 87:A92D
    lda $7FEC32 ; 87:A92F
    sta $02 ; 87:A933
    jsr mergeHolyblood ; 87:A935
    sta $0014,Y ; 87:A938
    bra ++ ; 87:A93B
+:
    lda $7FEC30 ; 87:A93D
    sta $00 ; 87:A941
    lda $7FEBA2 ; 87:A943
    sta $02 ; 87:A947
    jsr mergeHolyblood ; 87:A949
    sta $0012,Y ; 87:A94C
    
    lda $7FEC32 ; 87:A94F
    sta $00 ; 87:A953
    lda $7FEBA4 ; 87:A955
    sta $02 ; 87:A959
    jsr mergeHolyblood ; 87:A95B
    sta $0014,Y ; 87:A95E
++:
    pla ; 87:A961
    sta $08 ; 87:A962
    pla ; 87:A964
    sta $06 ; 87:A965
    pla ; 87:A967
    sta $04 ; 87:A968
    pla ; 87:A96A
    sta $02 ; 87:A96B
    pla ; 87:A96D
    sta $00 ; 87:A96E
    ply ; 87:A970
    plx ; 87:A971
    plp ; 87:A972
    plb ; 87:A973
    rtl ; 87:A974
    
ORG $87A9FB
mergeHolyblood:
    lda $00 ; 87:A9FB
    clc ; 87:A9FD
    adc #$5555 ; 87:A9FE
    lsr A ; 87:AA01
    and #$5555 ; 87:AA02
    sta $00 ; 87:AA05
    stz $04 ; 87:AA07
    stz $06 ; 87:AA09
    stz $08 ; 87:AA0B
    ldx #$0008 ; 87:AA0D
-:
    lsr $00 ; 87:AA10
    ror $04 ; 87:AA12
    lsr $00 ; 87:AA14
    ror $04 ; 87:AA16
    lsr $02 ; 87:AA18
    ror $06 ; 87:AA1A
    lsr $02 ; 87:AA1C
    ror $06 ; 87:AA1E
    lsr $08 ; 87:AA20
    lsr $08 ; 87:AA22
    lda $04 ; 87:AA24
    clc ; 87:AA26
    adc $06 ; 87:AA27
    bcc + ; 87:AA29
    lda #$8000 ; 87:AA2B
+:
    and #$C000 ; 87:AA2E
    ora $08 ; 87:AA31
    sta $08 ; 87:AA33
    dex ; 87:AA35
    bne - ; 87:AA36
    rts ; 87:AA38

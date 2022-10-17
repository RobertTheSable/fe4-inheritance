includeonce

incsrc "inheritance_extra.asm"

!Sigurd = $0001
!Naoise = $0002
!Alec = $0003
!Arden = $0004
!Finn = $0005
!Quan = $0006
!Midir = $0007
!Lewyn = $0008
!Chulainn = $0009
!Azelle = $000A
!Jamke = $000B
!Claude = $000C
!Beowulf = $000D
!Lex = $000E
!Dew = $000F

ORG $84BAA1
_84BAA1:
    ; $0574 = 0 or 1
    ; 0 = son, 1 = daughter?
    phb ; 84:BAA1
    php ; 84:BAA2
    phk ; 84:BAA3
    plb ; 84:BAA4
    phx ; 84:BAA5
    lda.w UnitPointer ; 84:BAA6
    pha ; 84:BAA9
    lda $0574 ; 84:BAAA
    sta $04 ; 84:BAAD
    jsl getUnitId ; 84:BAAF
    ; skip death check for Deirdre and Ethlyn
    cmp #$0011 ; 84:BAB3
    beq + ; 84:BAB6
    cmp #$0010 ; 84:BAB8
    beq + ; 84:BABB
    ; probably a death check
    jsl _getFlag ; 84:BABD
    bit #$0200 ; 84:BAC1
    bne .exit ; 84:BAC4
+:
    ldx.w UnitPointer ; 84:BAC6 - save female unit's pointer
    jsl getUnitLover ; 84:BAC9
    jsr loadFallbackLover ; 84:BACD
    bcs .exit ; 84:BAD0
    ; don't know why it checks for Ethlyn but not Deirdre...
    cmp #$0011 ; 84:BAD2
    bcs .exit ; 84:BAD5
    jsl searchForUnit ; 84:BAD7
    bcs .exit ; 84:BADB
    lda.w UnitPointer ; 84:BADD
    sta $00 ; 84:BAE0
    stx.w UnitPointer ; 84:BAE2 - unit pointer is resored to the female unit
    lda.w UnitPointer ; 84:BAE5
    sta $02 ; 84:BAE8
    jsl getUnitSupportID ; 84:BAEA
    cmp #$0010 ; 84:BAEE
    bcc .exit ; 84:BAF1
    sec ; 84:BAF3
    sbc #$0010 ; 84:BAF4
    asl A ; 84:BAF7
    tax ; 84:BAF8
    lda $04 ; 84:BAF9
    asl A ; 84:BAFB
    clc ; 84:BAFC
    adc.l inheritanceTable,X ; 84:BAFD
    tax ; 84:BB01
    lda.l inheritanceTable,X ; 84:BB02
    beq .exit ; 84:BB06
    jsl _doInheritance1 ; 84:BB08
    lda.l inheritanceFlagsTable,X ; 84:BB0C
    bmi .exit ; 84:BB10
    ; setting an event flag based on inheritance result?
    jsl setFlagAt5297 ; 84:BB12
.exit:
    pla ; 84:BB16
    sta.w UnitPointer ; 84:BB17
    plx ; 84:BB1A
    plp ; 84:BB1B
    plb ; 84:BB1C
    rtl ; 84:BB1D
    
ORG $84ff10
loadFallbackLover:
    phy
    phx
    php
    rep #$30
    pha
    cmp #$0000
    bne .exit
.loadFallback:
    jsl getUnitSupportID
    pha
    cmp #$0012
    ldx.w UnitPointer
    phx
    bcs .skip
    sec 
    sbc #$0010
    asl A
    tax
    lda.w .defaults,X
    print pc
    ldx.w #((.defaults-.table))
.loop:
    jsl searchForUnit 
    bcs .panic 
    jsl getUnitLover
    ora #$0000
    bne .continue
    jsl getUnitSupportID
    ldy.w UnitPointer
    plx
    stx.w UnitPointer
    jsl $849650
    sty.w UnitPointer
    pla
    jsl $849650
    jsl getUnitSupportID
    bra .exit
.continue:
    dex
    dex
    bmi .panic
    lda.w .table,X
    bra .loop
.exit:
    plx
    plp
    plx
    ply
    clc
    rts
    print pc
.table:
    dw !Naoise, !Alec, !Arden, !Quan, !Finn, !Azelle, !Lex, !Midir,\
       !Dew, !Jamke, !Chulainn, !Lewyn, !Beowulf, !Claude
.defaults:
    dw !Sigurd, !Quan
.panic:
    bra .panic
.skip
    pla
    pla
    plp
    plx
    ply
    sec
    rts
    

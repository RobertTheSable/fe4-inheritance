includefrom "romance.asm"

ORG $848C31
setLover:
    phb ; 84:8C31
    php ; 84:8C32
    phk ; 84:8C33
    plb ; 84:8C34
    lda.w UnitPointer; 84:8C35
    pha ; 84:8C38
    lda $0576 ; 84:8C39
    sta $0574 ; 84:8C3C
    lda #$0000 ; 84:8C3F
    jsl getUnitPointerBySupportID ; 84:8C42
    jsl $849635 ; 84:8C46
    ora #$0000 ; 84:8C4A
    bne .exit ; 84:8C4D
    lda $0578 ; 84:8C4F
    cmp #$0010 ; 84:8C52
    bcc .break ; 84:8C55
    jsl $849650 ; 84:8C57
    ; ^ this function sets the lover value in the unit struct
    jsl getUnitId ; 84:8C5B
    pha ; 84:8C5F
    lda $0578 ; 84:8C60
    sta $0574 ; 84:8C63
    lda #$0000 ; 84:8C66
    jsl getUnitPointerBySupportID ; 84:8C69
    lda $0576 ; 84:8C6D
    cmp #$0010 ; 84:8C70
    bcs .break ; 84:8C73
    jsl $849650 ; 84:8C75
    lda #$0011 ; 84:8C79
    sta $0EBC ; 84:8C7C
    jsl getUnitId ; 84:8C7F
    sta $0EBD ; 84:8C83
    pla ; 84:8C86
    sta $0EBF ; 84:8C87
    jsl $8682BC ; 84:8C8A
.exit:
    pla ; 84:8C8E
    sta.w UnitPointer; 84:8C8F
    plp ; 84:8C92
    plb ; 84:8C93
    rtl ; 84:8C94
.break:
    ; I guess the game expects this to not happen :v
    brk #$8B

ORG $84BF67
getUnitPointerBySupportID:
    ; search for a unit by support ID 
    ; and store their pointer in $056F
    phb ; 84:BF67
    php ; 84:BF68
    phk ; 84:BF69
    plb ; 84:BF6A
    phx ; 84:BF6B
    phy ; 84:BF6C
    jsr _BD24 ; 84:BF6D
    bcs .exit ; 84:BF70
    lda $7E0004,X ; 84:BF72
    and #$00FF ; 84:BF76
    beq .exitZero ; 84:BF79
    tay ; 84:BF7B
-:
    lda $7E0005,X ; 84:BF7C
    sta.w UnitPointer; 84:BF80
    jsl getUnitSupportID ; 84:BF83
    cmp $0574 ; 84:BF87
    beq .exit ; 84:BF8A
    inx ; 84:BF8C
    inx ; 84:BF8D
    dey ; 84:BF8E
    bne - ; 84:BF8F
.exitZero:
    stz.w UnitPointer; 84:BF91
.exit
    ply ; 84:BF94
    plx ; 84:BF95
    plp ; 84:BF96
    plb ; 84:BF97
    rtl ; 84:BF98
    
ORG $84BD24
_BD24:
    cmp #$0007 ; 84:BD24
    bcs .exitGreaterThan7 ; 84:BD27
    asl A ; 84:BD29
    tax ; 84:BD2A
    lda $7E2180,X ; 84:BD2B
    clc ; 84:BD2F
    adc #$2180 ; 84:BD30
    tax ; 84:BD33
    clc ; 84:BD34
    rts ; 84:BD35
.exitGreaterThan7:
    rts ; 84:BD36

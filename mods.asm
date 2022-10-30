includeonce

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
    
ORG $84835E
overrideSeliphStats:
    phb ; 84:835E
    jsl loadFrom3rdPointer ; 84:835F
    ; grant Seliph some special skill
    lda $000F,X ; 84:8363
    ora #$0008 ; 84:8366
    sta $000F,X ; 84:8369
    ; override Seliph's holy blood
    ; modified to just remove the loptyr blood
    lda $0014,X ; 84:8375
    and #$FCFF
    sta $0014,X
    jsl getUnitStatsAddress ; 84:8378
    sep #$20 ; 84:837C
    ; Sets Seliph's Authority
    lda #$02 ; 84:837E
    sta $000A,X ; 84:8380
    rep #$20 ; 84:8383
    plb ; 84:8385
    rts ; 84:8386

; add the ch8 steel lance to Altenna's base inventory
ORG $83b89e
    db $34, $FF

; override the chapter 8 vendor
ORG $86F34C
    db $08, $1c, $23, $29, $32, $33, $44, $47, $4a, $50, $55, $58, $65, $72, $06, $30, $48, $5d, $64, $67
    dw $FFFF

ORG $87AB51
isHolyWeapon:
    ; other holy weapons:
    ; $24 - Gae Bolg
    ; $15 - Tyrfing
    jsl LoadFrom0587 ; 87:AB51
    jsr holyWeaponOverride
    bcs .clear
    jsl GetWeaponRank ;
    ora #$0000 ;
    bmi .set ;
    lda #$0000 ;
    clc ;
.exit:
    rts ;
.clear:
    lda #$0001 ;
    clc ;
    bra .exit ;
.set:
    ; holy weapon, don't inherit
    sec ;
    bra .exit ;

namespace Talks

ORG $879EB1
    jsr (ConditionTable,X)

namespace off

ORG $87FDE0
holyWeaponOverride:
    phx
    php
    sep #$10
    ldx #$06
-:
    cmp.w .table,X
    bne .continue
    plp
    sec
    bra .exit
.continue:
    dex
    dex
    bpl -
    plp
    clc
.exit:
    plx
    rts
.table:
    dw $004B, $0062, $0036, $0024

namespace Talks

Enabled = $879ED8
RequiresGold = $879EDC

ConditionTable:
    dw Enabled, RequiresGold, SigurdChildOnly
SigurdChildOnly:
    jsl $84A43D
    cmp #$0001
    bne .notSigurd
    lda #$0000
    jsl checkHolyBlood
    cmp #$0002
    bne .notSigurd
    sec
    rts
.notSigurd
    clc
    rts
global setupHolyFlash:
    lda $0ea7
    sta.w UnitPointer
    ; jump part of the way into $91C947, skipping the unit search
    jsl $91C94D
    rtl

ORG $B083E3
    %NPCTalkEnablingHeader(10, $2B, $FFFF, $0195, 2)

ORG $B08087
    %TalkEventHeader($2B, $FFFF, $0195, $FFFF)

namespace off

; trying to keep the text pointer the same, regardless of the TL used
if canread3($8D8BCD) == 1 && read1($8D8BCC) == $0C
    !TextOffset = read3($8D8BCD)
else
    !TextOffset = $B3C673
endif

ORG $8d8bbd
; Palmark event script
    %PauseMusic()
    %SetMusic($62)
    %GiveItemToUnit($27) ; $27 = Tyrfing item index
    %ShowText(!TextOffset)
    %ASM(setupHolyFlash)
    %ASM($8d8be5)
    %YIELD()
    %PauseMusic()
    %RestartMusic()
    %ENDEVENT()

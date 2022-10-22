includeonce

ORG $84835E
overrideSeliphStats:
    phb ; 84:835E
    jsl loadFrom3rdPointer ; 84:835F
    ; grant Seliph some special skill
    lda $000F,X ; 84:8363
    ora #$0008 ; 84:8366
    sta $000F,X ; 84:8369
    ; override Seliph's holy blood
    ; seems like they could've just unset the Lopt flags
    ; but what do I know
    lda #$0006 ; 84:836C
    sta $0012,X ; 84:836F
    lda #$0000 ; 84:8372
    sta $0014,X ; 84:8375
    jsl getUnitStatsAddress ; 84:8378
    sep #$20 ; 84:837C
    ; Sets Seliph's Authority
    lda #$02 ; 84:837E
    sta $000A,X ; 84:8380
    rep #$20 ; 84:8383
    plb ; 84:8385
    rts ; 84:8386
    

; loads either the first or 2nd index of [$0587]
; then gets an offset to a table at $83E9D0
; output is saved to $0583
; if the weapon is broken, the offset for 
GetOffsetFor83E9D0 = $87E0A0
    ; unbroken weapons jump direcrtly to $87E31D and returns
    ;
    ; broken weapons jump to $87E31D
    ; but then also jumps to $87e422
    ; which returns [$0583]+7
    ;
    ; then it jumps to $87e48d
    ; which returns [$0583]+0x0A
    ; unless [$0583]+1 == 2 (checking for rings?)
    ; then it returns 0
    ; 
    ; then uses that as an offset for a table at $87e2dc
    ; (presumably this is getting the "broken" equivalent of any weapon type)
    ; 
    ; then it jumps to $87E31D again, then returns

; Get the Nth item from a list at 7E3D87
; N = accumulator
; returns a pointer or 0 if N is out of bounds
; output is stored in $0587
GetNthObjectFrom7E3D87 = $87E01E

; sets $0550 to 1, then jumps to $82E55D
; (defined in inheritance2.asm)
AddItemToList = $82E477

; copies an 8-bit value from $00 and an address from $02 to $7E:([$0587]+2)
Copy00And02To0587 = $87E1A7

; does bound checking,
; loading $0550 in the accumulator 
; and then jumps to "copyBytesFrom"
; (copies the parent's inventory to [$054A])
CopyItemsFromInventory = $82E7BF

GetWeaponRank = $87E422
    
ORG $87AA39
; parent's inventory is treated like a stack
; items are read from the first slot, removed and then others are shifted forward
; (Tyrfing isn't shifted?)
_87AA39:
    phb ; 87:AA39
    php ; 87:AA3A
    phk ; 87:AA3B
    plb ; 87:AA3C
    phx ; 87:AA3D
    phy ; 87:AA3E
    jsr _AAC9 ; 87:AA3F - Tyrfing is "removed" from sigurd's inventory here
    jsl $84F316 ; 87:AA42 - gets the child unit's starting size
    sta $06 ; 87:AA46
    lda #$0001 ; 87:AA48
    jsl _84F3B5 ; 87:AA4B
    lda $0583 ; 87:AA4F
    beq + ; 87:AA52
    jsl $87E4B9 ; 87:AA54
+:
    sta $08 ; 87:AA58
    ldx.w UnitPointer ; 87:AA5A
-:
    lda $04 ; 87:AA5D
    sta.w UnitPointer ; 87:AA5F
    lda #$0001 ; 87:AA62
    jsl $84F338 ; 87:AA65 - loads item from parent's inventory
    ; holy weapons may already have been moved at this point?
    bcs .break ; 87:AA69
    tay ; 87:AA6B
    lda #$0001 ; 87:AA6C
    jsl $84F23E ; 87:AA6F
    tya ; 87:AA73
    jsl GetNthObjectFrom7E3D87 ; 87:AA74
    jsl GetOffsetFor83E9D0 ; 87:AA78
    ; 
    stx.w UnitPointer ; 87:AA7C
    jsr _AB7B ; 87:AA7F - sets items
    bra - ; 87:AA82
.break:
    stx.w UnitPointer ; 87:AA84
    ldy #$0001 ; 87:AA87
-:
    lda #$7E00 ; 87:AA8A
    sta $055D ; 87:AA8D
    lda #$3D87 ; 87:AA90
    sta $055C ; 87:AA93
    sty $0550 ; 87:AA96
    jsl getNthItemAddress ; 87:AA99
    bcs .exit ; 87:AA9D
    lda $054A ; 87:AA9F
    sta $0587 ; 87:AAA2
    jsl GetOffsetFor83E9D0 ; 87:AAA5
    ; saves the 3rd and 4th offsets of [$0587] to $00 and $02
    jsl $87E188 ; 87:AAA9
    lda $02 ; 87:AAAD
    cmp $04 ; 87:AAAF
    bne .continue ; 87:AAB1
    lda $00 ; 87:AAB3
    cmp #$0002 ; 87:AAB5
    bne .continue ; 87:AAB8
    jsr _AB7B ; 87:AABA
.continue:
    iny ; 87:AABD
    bra - ; 87:AABE
.exit:
    jsl $84F939 ; 87:AAC0
    ply ; 87:AAC4
    plx ; 87:AAC5
    plp ; 87:AAC6
    plb ; 87:AAC7
    rtl ; 87:AAC8
_AAC9:
    phx ; 87:AAC9
    phy ; 87:AACA
    ldx.w UnitPointer; 87:AACB
    lda $04 ; 87:AACE
    sta.w UnitPointer ; 87:AAD0
    ldy #$0001 ; 87:AAD3
    ; this first loop finds and removes holy weapons?
-:
    tya ; 87:AAD6
    jsl _84F3B5 ; 87:AAD7 - reads parent's inventory?
    lda $0583 ; 87:AADB
    beq .break1 ; 87:AADE
    jsr isHolyWeapon ; 87:AAE0
    bcc + ; 87:AAE3f
    tya ; 87:AAE5
    jsl _84F23E ; 87:AAE6
    jsl $87E188 ; 87:AAEA - gets a pointer from the current item
                ; [$0587] + 2 gets stored to $00
                ; [$0587] + 3 gets stored to $02
    cpx $02 ; 87:AAEE - sanity check to avoid overwriting own weapon?
    beq + ; 87:AAF0
    jsl $87E1C7 ; 87:AAF2
                ; writes 7 and 0000 to the address which was just read
                ; then loads [$0587] and jumps to $87e31d to get the weapon table index
                ; then jumps to $87e3be (this seems to return the maximum uses)
                ; 
    bra - ; 87:AAF6
+:
    iny ; 87:AAF8
    bra - ; 87:AAF9
.break1:
    ldy #$0001 ; 87:AAFB
--:
    lda $04 ; 87:AAFE
    sta.w UnitPointer ; 87:AB00
    tya ; 87:AB03
    jsl $84F38B ; 87:AB04 - reads parent's inventory?
    bcs .break2 ; 87:AB08
    sta $00 ; 87:AB0A
    phy ; 87:AB0C
    stx.w UnitPointer ; 87:AB0D
    ldy #$0001 ; 87:AB10
-:
    tya ; 87:AB13
    jsl $84F38B ; 87:AB14
    bcs .breakInner ; 87:AB18
    cmp $00 ; 87:AB1A
    bne + ; 87:AB1C
          ; when checking Sigurd's inventory, doesn't branch for Tyrfing
          ; all other items branch
    tya ; 87:AB1E
    jsl _84F23E ; 87:AB1F
    jsl $87E1C7 ; 87:AB23
    bra .breakInner ; 87:AB27
+:
    iny ; 87:AB29
    bra - ; 87:AB2A
.breakInner:
    ply ; 87:AB2C
    iny ; 87:AB2D
    bra -- ; 87:AB2E
.break2:
    stx.w UnitPointer ; 87:AB30
    ply ; 87:AB33
    plx ; 87:AB34
    rts ; 87:AB35
    
; loads an 8-bit value from [$0583]+1
LoadFrom0583 = $87E38E
; loads a value from [$0587]
LoadFrom0587 = $87E088
; loads a value from [$0587]+2 and [$0587]+3
; writes to $00 and $02, repsectively
LoadFrom0587Offset = $87E188

ORG $87AB36
checkUsability:
    phx ; 87:AB36
    jsl LoadFrom0583  ; 87:AB37
    asl A ; 87:AB3B
    tax ; 87:AB3C
    jsr (.table,X) ; 87:AB3D
    plx ; 87:AB40
    rts ; 87:AB41
.table:
    dw .first, .first, .second, .second
.first:
    jsl $84F70A ; 87:AB4A
    rts ; 87:AB4E
.second:
    ; probably items?
    sec ; 87:AB4F
    rts ; 87:AB50
    
isHolyWeapon:
    ; other holy weapons: 
    ; $24 - Gae Bolg
    ; $15 - Tyrfing
    jsl LoadFrom0587 ; 87:AB51
    cmp #$004B ; 87:AB55 - Forseti
    beq .clear ; 87:AB58
    cmp #$0062 ; 87:AB5A - Valkyrie
    beq .clear ; 87:AB5D
    cmp #$0036 ; 87:AB5F - Yewfelle
    beq .clear ; 87:AB62
    jsl GetWeaponRank ; 87:AB64
    ora #$0000 ; 87:AB68
    bmi .set ; 87:AB6B
    lda #$0000 ; 87:AB6D
    clc ; 87:AB70
.exit:
    rts ; 87:AB71
.clear:
    lda #$0001 ; 87:AB72
    clc ; 87:AB75
    bra .exit ; 87:AB76
.set:
    ; holy weapon
    sec ; 87:AB78
    bra .exit ; 87:AB79
    
_AB7B:
    jsr isHolyWeapon ; 87:AB7B
    bcs .jumpAndExit ; 87:AB7E
    bne .one ; 87:AB80
    jsr checkUsability ; 87:AB82
    bcc .jumpAndExit ; 87:AB85
    lda $06 ; 87:AB87
    cmp #$0007 ; 87:AB89
    bcs .finished ; 87:AB8C
.one:
    inc $06 ; 87:AB8E
    jsl $87E4B9 ; 87:AB90
    cmp $08 ; 87:AB94
    bcc + ; 87:AB96
    sta $08 ; 87:AB98
    sty $0574 ; 87:AB9A
    jsl doWeaponInheritance ; 87:AB9D - sets weapons?
    bra .exit ; 87:ABA1
+:
    sty $0574 ; 87:ABA3
    jsl doItemInheritance ; 87:ABA6 - sets items?
    bra .exit ; 87:ABAA
.finished:
    lda #$0002 ; 87:ABAC
    sta $00 ; 87:ABAF
    lda.w UnitPointer ; 87:ABB1
    sta $02 ; 87:ABB4
    jsl Copy00And02To0587 ; 87:ABB6
    bra .exit ; 87:ABBA
.jumpAndExit:
    jsl $87E1C7 ; 87:ABBC
.exit:
    rts ; 87:ABC0
    
ORG $87E4B9
_87E4B9:
    phb ; 87:E4B9
    php ; 87:E4BA
    sep #$20 ; 87:E4BB
    lda #$83 ; 87:E4BD
    pha ; 87:E4BF
    rep #$20 ; 87:E4C0
    plb ; 87:E4C2
    phx ; 87:E4C3
    ldx $0583 ; 87:E4C4
    beq .returnZero ; 87:E4C7
    lda $0001,X ; 87:E4C9
    and #$00FF ; 87:E4CC
    cmp #$0002 ; 87:E4CF
    bcs .returnZero ; 87:E4D2
    lda $000B,X ; 87:E4D4
    and #$00FF ; 87:E4D7
    plx ; 87:E4DA
    plp ; 87:E4DB
    plb ; 87:E4DC
.exit:
    rtl ; 87:E4DD
.returnZero:
    lda #$0000 ; 87:E4DE
    plx ; 87:E4E1
    plp ; 87:E4E2
    plb ; 87:E4E3
    bra .exit ; 87:E4E4
    
ORG $84F142
doItemInheritance:
    phb ; 84:F142
    php ; 84:F143
    phk ; 84:F144
    plb ; 84:F145
    phx ; 84:F146
    lda $00 ; 84:F147
    pha ; 84:F149
    lda $02 ; 84:F14A
    pha ; 84:F14C
    lda $0574 ; 84:F14D
    pha ; 84:F150
    lda $0574 ; 84:F151
    jsl GetNthObjectFrom7E3D87 ; 84:F154
    lda $0574 ; 84:F158
    sta $054A ; 84:F15B
    ldx.w UnitPointer ; 84:F15E
    lda.l UnitPointers.Inventory+1,X ; 84:F161
    sta $055D ; 84:F165
    lda.l UnitPointers.Inventory,X ; 84:F168
    clc ; 84:F16C
    adc #$0001 ; 84:F16D
    sta $055C ; 84:F170
    jsl $82E465 ; 84:F173
    bcs + ; 84:F177
    lda #$0001 ; 84:F179
    sta $00 ; 84:F17C
    lda.w UnitPointer ; 84:F17E
    sta $02 ; 84:F181
    jsl Copy00And02To0587 ; 84:F183
    jsr _F1A8 ; 84:F187
    jsl $84EFD4 ; 84:F18A
    lda $0000,X ; 84:F18E
    and #$00FF ; 84:F191
    bne + ; 84:F194
    jsl $84F939 ; 84:F196
+:
    pla ; 84:F19A
    sta $0574 ; 84:F19B
    pla ; 84:F19E
    sta $02 ; 84:F19F
    pla ; 84:F1A1
    sta $00 ; 84:F1A2
    plx ; 84:F1A4
    plp ; 84:F1A5
    plb ; 84:F1A6
    rtl ; 84:F1A7

macro checkBonusAndJump(jumpAddr)
    jsl GetOffsetFor83E9D0 
    jsl LoadFrom0583 ; 
    cmp #$0002 ; checking type
    bne ?exit 
    jsl $87E3EB ; checking ring stat bonus?
    ora #$0000 
    beq ?exit 
    tax 
    lda.l ringBonusTable,X 
    jsl <jumpAddr> 
?exit:
    rts 
endmacro
    
_F1A8:
    %checkBonusAndJump($8497CD) ; 84:F1A8
_F1C8:
    %checkBonusAndJump($8497E5) ; 84:F1C8
ringBonusTable:
    db $00, $10, $40, $80, $08, $04, $02, $20
doWeaponInheritance:
    phb
    php
    phk ; 84:F1F2
    plb ; 84:F1F3
    phx ; 84:F1F4
    lda $00 ; 84:F1F5
    pha ; 84:F1F7
    lda $02 ; 84:F1F8
    pha ; 84:F1FA
    lda $0574 ; 84:F1FB
    jsl GetNthObjectFrom7E3D87 ; 84:F1FE
    lda $0574 ; 84:F202
    sta $054A ; 84:F205
    ldx.w UnitPointer ; 84:F208
    lda.l UnitPointers.Inventory+1,X ; 84:F20B
    sta $055D ; 84:F20F
    lda.l UnitPointers.Inventory,X ; 84:F212
    clc ; 84:F216
    adc #$0001 ; 84:F217
    sta $055C ; 84:F21A 
    jsl AddItemToList ; 84:F21D
    bcs + ; 84:F221
    lda #$0001 ; 84:F223
    sta $00 ; 84:F226
    lda.w UnitPointer ; 84:F228
    sta $02 ; 84:F22B
    jsl Copy00And02To0587 ; 84:F22D
    jsr _F1A8 ; 84:F231
+:
    pla ; 84:F234
    sta $02 ; 84:F235
    pla ; 84:F237
    sta $00 ; 84:F238
    plx ; 84:F23A
    plp ; 84:F23B
    plb ; 84:F23C
    rtl ; 84:F23D
_84F23E:
    phb ; 84:F23E
    phk ; 84:F23F
    plb ; 84:F240
    phx ; 84:F241
    ldx $0574 ; 84:F242
    phx ; 84:F245
    sta $0550 ; 84:F246
    sta $0574 ; 84:F249
    ldx.w UnitPointer ; 84:F24C
    lda.l UnitPointers.Inventory+1,X ; 84:F24F
    sta $055D ; 84:F253
    lda.l UnitPointers.Inventory,X ; 84:F256
    clc ; 84:F25A
    adc #$0001 ; 84:F25B
    sta $055C ; 84:F25E
    jsl CopyItemsFromInventory ; 84:F261
    bcs .setAndExit ; 84:F265
    jsl popFromList ; 84:F267
    bcs .setAndExit ; 84:F26B
    lda $054A ; 84:F26D
    and #$00FF ; 84:F270
    jsl GetNthObjectFrom7E3D87 ; 84:F273
    jsr _F1C8 ; 84:F277
    jsr _F288 ; 84:F27A
    clc ; 84:F27D
.exit:
    plx ; 84:F27E
    stx $0574 ; 84:F27F
    plx ; 84:F282
    plb ; 84:F283
    rtl ; 84:F284
.setAndExit:
    sec ; 84:F285
    bra .exit ; 84:F286
_F288:
    phb ; 84:F288
    phx ; 84:F289
    ldx $0574 ; 84:F28A - contains the inventory slot?
    dex ; 84:F28D
    lda $84F2BE,X ; 84:F28E
    and #$00FF ; 84:F292
    sta $0574 ; 84:F295
    jsl $84EFD4 ; 84:F298
    lda $0000,X ; 84:F29C
    and #$00FF ; 84:F29F
    cmp $0574 ; 84:F2A2
    beq + ; 84:F2A5
    bcs .exit ; 84:F2A7
    asl A ; 84:F2A9
    sep #$20 ; 84:F2AA
    sta $0000,X ; 84:F2AC
    rep #$20 ; 84:F2AF
    bra .exit ; 84:F2B1
+:
    jsl $84F939 ; 84:F2B3
    jsl $84F9F2 ; 84:F2B7
.exit:
    plx ; 84:F2BB
    plb ; 84:F2BC
    rts ; 84:F2BD
    
    
ORG $84F316
    phb ; 84:F316
    php ; 84:F317
    phk ; 84:F318
    plb ; 84:F319
    phx ; 84:F31A
    ldx.w UnitPointer ; 84:F31B
    lda.l UnitPointers.Inventory+1,X ; 84:F31E
    sta $055D ; 84:F322
    lda.l UnitPointers.Inventory,X ; 84:F325
    clc ; 84:F329
    adc #$0001 ; 84:F32A
    sta $055C ; 84:F32D
    jsl loadIndirectValueFrom55C ; 84:F330
    plx ; 84:F334
    plp ; 84:F335
    plb ; 84:F336
    rtl ; 84:F337
_84F338:
    phb ; 84:F338
    phk ; 84:F339
    plb ; 84:F33A
    phx ; 84:F33B
    ora #$0000 ; 84:F33C
    beq .setAndExit ; 84:F33F
    sta $0550 ; 84:F341
    jsl $849461 ; 84:F344
    cmp #$0002 ; 84:F348
    bcs .setAndExit ; 84:F34B
    ldx.w UnitPointer ; 84:F34D
    lda.l UnitPointers.Inventory+1,X ; 84:F350
    sta $055D ; 84:F354
    lda.l UnitPointers.Inventory,X ; 84:F357
    clc ; 84:F35B
    adc #$0001 ; 84:F35C
    sta $055C ; 84:F35F
    jsl CopyItemsFromInventory ; 84:F362
    bcs .setAndExit ; 84:F366
    lda $054A ; 84:F368
    and #$00FF ; 84:F36B
    clc ; 84:F36E
.exit:
    plx ; 84:F36F
    plb ; 84:F370
    rtl ; 84:F371
.setAndExit:
    lda #$0000 ; 84:F372
    sec ; 84:F375
    bra .exit ; 84:F376
getItem:
    phb ; 84:F378
    phk ; 84:F379
    plb ; 84:F37A
    stz $0587 ; 84:F37B
    jsl _84F338 ; 84:F37E
    bcs + ; 84:F382
    jsl GetNthObjectFrom7E3D87 ; 84:F384
    clc ; 84:F388
+:
    plb ; 84:F389
    rtl ; 84:F38A
    
ORG $84F3B5
_84F3B5:
    phb ; 84:F3B5
    php ; 84:F3B6
    phk ; 84:F3B7
    plb ; 84:F3B8
    sta $0585 ; 84:F3B9
    jsl $849461 ; 84:F3BC
    cmp #$0002 ; 84:F3C0
    bcs ._F3DA ; 84:F3C3
    lda $0585 ; 84:F3C5
    jsl getItem ; 84:F3C8
    bcs .exitZero ; 84:F3CC
    jsl GetOffsetFor83E9D0 ; 84:F3CE
.exit:
    plp ; 84:F3D2
    plb ; 84:F3D3
    rtl ; 84:F3D4
.exitZero:
    stz $0583 ; 84:F3D5
    bra .exit ; 84:F3D8
._F3DA
    stz $0587
    lda $0585
    jsl $84F41A
    bra .exit

includefrom "main.asm"

PointIncrease = $0574 ; address is used for multiple things
!max_points = 500

incsrc "unit_memory.asm"
incsrc "romance2.asm"
incsrc "setLover.asm"
incsrc "loading.asm"
; 
; notable addresses:
; ethlyn/quan support points: $7e3d0f
; ethlyn lover value: $7e2c14
; sigurd lover value: $7e2d34

    
ORG $8683D8
mysteryQueue:
-:
    lda $0000,Y ; 86:83D8
    cmp #$FFFF ; 86:83DB
    beq .exit ; 86:83DE
    jsr + ; 86:83E0
    bra - ; 86:83E3
.exit:
    rtl ; 86:83E5
+:
    iny ; 86:83E6
    and #$00FF ; 86:83E7
    asl A ; 86:83EA
    tax ; 86:83EB
    clc ; 86:83EC
    ; this jumps to _869970 at some point
    jmp ($83FA,X) ; 86:83ED
    
ORG $869970
_869970:
    ; does something at the start of the turn if two characters are lovers?
    bcs .exit ; 86:9970
    lda.w UnitPointer ; 86:9972
    pha ; 86:9975
    phb ; 86:9976
    phy ; 86:9977
    lda $0000,Y ; 86:9978
    tax ; 86:997B
    sep #$20 ; 86:997C
    lda $0002,Y ; 86:997E
    pha ; 86:9981
    rep #$20 ; 86:9982
    plb ; 86:9984
-:
    ; Edain's table: 17 07 17 0a 17 0f ff ff
    ; 17 = Edain, 07 = Midir, 0A = Azelle, 0F = Dew
    lda $0000,X ; 86:9985
    bmi .endLoop ; 86:9988
    lda $0001,X ; 86:998A
    and #$00FF ; 86:998D
    jsl searchForUnit ; 86:9990
    bcs + ; 86:9994
    jsl getUnitLover ; 86:9996
    ora #$0000 ; 86:999A
    bne .hasLover ; 86:999D
    ldy.w UnitPointer ; 86:999F
    lda $0000,X ; 86:99A2
    and #$00FF ; 86:99A5
    jsl searchForUnit ; 86:99A8
    bcs + ; 86:99AC
    jsl getUnitLover ; 86:99AE
    ora #$0000 ; 86:99B2
    beq + ; 86:99B5
    sty.w UnitPointer ; 86:99B7
.hasLover:
    lda #$0000 ; 86:99BA
    jsl $849EF7 ; 86:99BD
+:
    inx ; 86:99C1
    inx ; 86:99C2
    bra - ; 86:99C3
.endLoop:
    ply ; 86:99C5
    plb ; 86:99C6
    pla ; 86:99C7
    sta.w UnitPointer ; 86:99C8
.exit:
    iny ; 86:99CB
    iny ; 86:99CC
    iny ; 86:99CD
    rts ; 86:99CE

includefrom "inheritance.asm"

ORG $82EFE1
_EFE1:
    sep #$20 ; 82:EFE1
    lda #$80 ; 82:EFE3
    sta $0000,Y ; 82:EFE5
    rep #$20 ; 82:EFE8
    lda #$0000 ; 82:EFEA
    sta $0004,Y ; 82:EFED
    sta $0003,Y ; 82:EFF0
    rts ; 82:EFF3
_EFF4:
    sep #$20 ; 82:EFF4
    lda #$40 ; 82:EFF6
    sta $0000,Y ; 82:EFF8
    rep #$20 ; 82:EFFB
    lda $000566 ; 82:EFFD
    sta $0004,Y ; 82:F001
    lda $000565 ; 82:F004
    sta $0003,Y ; 82:F008
    rts ; 82:F00B

ORG $82F0EB
_F0EB:
    phx ; 82:F0EB
    phy ; 82:F0EC
    lda $04 ; 82:F0ED
    pha ; 82:F0EF
    lda $000565 ; 82:F0F0
    tay ; 82:F0F4
    lda $0001,Y ; 82:F0F5
    sta $04 ; 82:F0F8
    tya ; 82:F0FA
    clc ; 82:F0FB
    adc #$0008 ; 82:F0FC
    tay ; 82:F0FF
--:
    lda $0000,Y ; 82:F100
    bit #$0080 ; 82:F103
    beq + ; 82:F106
-:
    jsr _F086 ; 82:F108
    tax ; 82:F10B
    cpx $04 ; 82:F10C
    bcs .exit ; 82:F10E
    lda $0000,X ; 82:F110
    bit #$0080 ; 82:F113
    beq + ; 82:F116
    lda $0001,Y ; 82:F118
    clc ; 82:F11B
    adc $0001,X ; 82:F11C
    sta $0001,Y ; 82:F11F
    lda #$0000 ; 82:F122
    sta $0000,X ; 82:F125
    sta $0001,X ; 82:F128
    sta $0004,X ; 82:F12B
    sta $0003,X ; 82:F12E
    bra - ; 82:F131
+:
    tya ; 82:F133
    clc ; 82:F134
    adc $0001,Y ; 82:F135
    tay ; 82:F138
    cpy $04 ; 82:F139
    bcc -- ; 82:F13B
.exit:
    pla ; 82:F13D
    sta $04 ; 82:F13E
    ply ; 82:F140
    plx ; 82:F141
    rts ; 82:F142

ORG $82F1EA
_F1EA:
    phx ; 82:F1EA
    ldx $02 ; 82:F1EB
    sep #$20 ; 82:F1ED
    lda #$00 ; 82:F1EF
    sta $0003,X ; 82:F1F1
    rep #$20 ; 82:F1F4
    lda $000566 ; 82:F1F6
    sta $0001,X ; 82:F1FA
    tya ; 82:F1FD
    clc ; 82:F1FE
    adc #$0006 ; 82:F1FF
    sta $0000,X ; 82:F202
    plx ; 82:F205
    rts ; 82:F206
    
ORG $82E465
_82E465:
    jsl loadIndirectValueFrom55C ; 82:E465
    inc A ; 82:E469
    sta $000550 ; 82:E46A
    jsl _82E55D ; 82:E46E
    lda $000550 ; 82:E472
    rtl ; 82:E476

ORG $82E747
loadIndirectValueFrom55C:
    phb ; 82:E747
    php ; 82:E748
    phk ; 82:E749
    plb ; 82:E74A
    phy ; 82:E74B
    ldy $055C ; 82:E74C
    sep #$20 ; 82:E74F
    lda $055E ; 82:E751
    pha ; 82:E754
    rep #$20 ; 82:E755
    plb ; 82:E757
    lda $0000,Y ; 82:E758
    and #$00FF ; 82:E75B
    ply ; 82:E75E
    plp ; 82:E75F
    plb ; 82:E760
    rtl ; 82:E761

ORG $82E55D
_82E55D:
    ; push ($0550) items onto a list
    phb ; 82:E55D
    php ; 82:E55E
    phk ; 82:E55F
    plb ; 82:E560
    phx ; 82:E561
    phy ; 82:E562
    ldx $055C ; 82:E563
    sep #$20 ; 82:E566
    lda $055E ; 82:E568
    pha ; 82:E56B
    rep #$20 ; 82:E56C
    plb ; 82:E56E
    lda $0003,X ; 82:E56F
    bit #$0080 ; 82:E572
    bne .exit ; 82:E575
    lda $0002,X ; 82:E577
    and #$00FF ; 82:E57A
    sta $000554 ; 82:E57D
    sep #$20 ; 82:E581
    lda $0000,X ; 82:E583
    sta $000552 ; 82:E586
    cmp $0001,X ; 82:E58A - check against list length?
    bcs .setAndExit ; 82:E58D
    cmp $000550 ; 82:E58F
    bcc + ; 82:E593
    phx ; 82:E595
    rep #$20 ; 82:E596
    and #$00FF ; 82:E598
    sec ; 82:E59B
    sbc $000550 ; 82:E59C
    inc A ; 82:E5A0
    inc A ; 82:E5A1
    jsr multiply ; 82:E5A2
    sta $000556 ; 82:E5A5
    lda $000552 ; 82:E5A9
    and #$00FF ; 82:E5AD
    jsr multiply ; 82:E5B0
    clc ; 82:E5B3
    adc $00055C ; 82:E5B4
    clc ; 82:E5B8
    adc $000554 ; 82:E5B9
    tay ; 82:E5BD
    clc ; 82:E5BE
    adc $000554 ; 82:E5BF
    tax ; 82:E5C3
    sep #$20 ; 82:E5C4
-:
    ; Y is some value + [$055C] + [$0554]
    ; X is some value + [$055C] + [$0554] + [$0554]
    ; so this copies some data forward one slot?
    lda $0003,Y ; 82:E5C6
    sta $0003,X ; 82:E5C9
    dey ; 82:E5CC
    dex ; 82:E5CD
    lda $000556 ; 82:E5CE
    dec A ; 82:E5D2
    sta $000556 ; 82:E5D3
    bne - ; 82:E5D7
    plx ; 82:E5D9
    bra ++ ; 82:E5DA
+:
    inc A ; 82:E5DC
    sta $000550 ; 82:E5DD - if accessed from $82E465, this stores the same value...
++:
    rep #$20 ; 82:E5E1
    lda $000550 ; 82:E5E3
    jsr copyBytes ; 82:E5E7
    lda $0000,X ; 82:E5EA
    inc A ; 82:E5ED
    sta $0000,X ; 82:E5EE
.exit:
    ply ; 82:E5F1
    plx ; 82:E5F2
    plp ; 82:E5F3
    plb ; 82:E5F4
    clc ; 82:E5F5
    rtl ; 82:E5F6
.setAndExit:
    rep #$20
    ply 
    plx 
    plp 
    plb 
    sec 
    rtl 

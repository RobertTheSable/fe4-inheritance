includefrom "romance.asm"

ORG $83848D
maleTable:
; gen 1
dw $0001, $0002, $0003, $0004, $0005, $0006, $0007, $0008
dw $0009, $000A, $000B, $000C, $000D, $000E, $000F
; gen 2
dw $0019, $001A, $001B, $001C, $001D, $001E, $001F, $0020
dw $0021, $0022, $0023, $0024, $0025, $0026, $0027, $0031
dw $0032, $0033, $0034, $0035, $0036, $0037, $0038, $FFFF
femaleTable:
; gen 1
dw $0010, $0011, $0012, $0013, $0014, $0015, $0016, $0017
dw $0018
; gen 2
dw $0028, $0029, $002A, $002B, $002C, $002D, $002E, $002F
dw $0030, $0039, $003A, $003B, $003C, $003D, $003E, $003F
dw $FFFF

ORG $838738
supportGrowthTable:
; gen 1
dw $0032, $0041, $0050, $005F, $006E, $007D, $008C, $009B
dw $00AA
; gen 2
; since the algorithm for loading these growths doesn't account for gen 1 vs 2
; or whether you have subs, the gen 2 offsets are 15 (0xF) less than where
; the "actual" data starts.
; hency why Daisy has the same offset as Bridget.
dw $00AA, $00C1, $00D8, $00EF, $0106, $011D, $0134, $014B
dw $0162, $0179, $0190, $01A7, $01BE, $01D5, $01EC, $0203
; and the actual growths start here
; deirdre
db  2, 2, 2, 2,  2,  2, 2, 2, 2, 2, 2, 2, 2, 2, 2
; ethlyn
db -5, 2, 2, 2,  2,  2, 2, 2, 2, 2, 2, 2, 2, 2, 2
; Lachesis
db  2, 2, 2, 2,  2,  2, 2, 2, 2, 2, 2, 3, 2, 2, 2
; Ayra
db  2, 2, 2, 2,  2,  2, 2, 2, 2, 2, 2, 2, 2, 2, 2
; Erinys
db  2, 2, 2, 2,  2,  2, 2, 2, 2, 2, 2, 3, 2, 2, 2
; Tailtiu
db  3, 3, 3, 3, 10, 10, 3, 3, 3, 3, 3, 3, 3, 3, 3
; Sylvia
db  4, 3, 3, 3,  3,  3, 3, 2, 3, 3, 3, 1, 3, 3, 3
; Edain
db  2, 2, 2, 2,  2,  2, 1, 2, 2, 1, 1, 3, 2, 2, 2
; Brigid
db  4, 4, 4, 4, 10, 10, 3, 4, 3, 3, 3, 4, 4, 4, 2
; and after this are the Gen 2 growths, which I won't copy because I'm lazy.
; example: daisy (data from $8387F1)
; 02 02 02 -5 02 02 03 03 02 -5 02 -5 02 02 02 02 02 -5 03 03 02 02 02
; negative growth with Asaello, Finn, Hannibal, and Faval

ORG $83850F
baseSupportTable:
!noSupport = $FF
!maxSupport = $FE
; gen 1
dw $0032, $0041, $0050, $005F, $006E, $007D, $008C, $009B
dw $00AA
; gen 2
dw $00AA, $00C1, $00D8, $00EF, $0106, $011D, $0134, $014B
dw $0162, $0179, $0190, $01A7, $01BE, $01D5, $01EC, $0203
; yes, the offset values are the same as the growth table
; values in this table are multiplied  by 10 for the starting value
; deidre
db          0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0
;Ethlyn
db !noSupport,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0, 18,  0,  0,  0
; Lachesis
db          5,  5,  5,  5,  5,  5,  5,  5,  5,  5,  5,  5,  5,  5,  5
; Ayra
db          0,  0,  0,  0,  0,  0,  0,  5,  0,  0,  0, 20,  5,  0,  0
; Erinys
db          5,  5,  5,  5,  5,  5,  5, 21,  5,  5,  5, 10,  5,  5,  5
; Tailtiu
db         12, 12, 12, 12, 18, 18, 12, 12, 12, 12, 12, 18, 12, 12, 12
; Sylvia
db          0,  0,  0,  0,  0,  0,  0, 20,  0,  0,  0, 19,  0,  0,  0
; Edain
db          0,  0,  0,  0,  0,  0, 12,  5,  0, 12, 25, 15, 10,  0,  0
; Brigid - her base support with Holyn is either increased somewhere else, or SF is wrong.
db          5,  5,  5,  5, 18, 18, 10,  5,  5, 15, 15,  5,  5,  5,  5



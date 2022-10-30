includeonce

; header that's used to enable talks that don't appear in the "talk to" field
; usually used for talking to NPCs/enemies, but it could be used for player events too.
macro NPCTalkEnablingHeader(id, flag, unit1, unit2, condition)
    dw <id>
    db <flag>
    dw <unit1>, <unit2>
    db <condition>
endmacro

; Does nothing
macro NullHeader()
    db $00
endmacro

; event for when a castle is seized
; 1st argument: event flag for the event
; 2nd argument: probably unit faction?
; 3rd argument: caste index
macro CastleSeizeHeader(flag, faction, castle)
    db $02, <flag>
    dw <faction>, <castle>
endmacro

macro TalkEventHeader(flag, unit1, unit2, arg4)
    db $04, <flag>
    dw <unit1>, <unit2>
    ; arg4 is checked to some value stored in $0EC1
    dw <arg4>
endmacro

; run some event if a given unit visits a given castle
; (might only be when visiting the town?)
macro CastleVisitEvent(flag, unit, castle)
    db $07, <flag>
    dw <unit>, <castle>
endmacro

; Header for village events
; - flag: enable event only if a flag is set. set to $FF to skip the check.
; - unit: chekced against the unit visiting the village. 
;    set to $FFFF to enable for all units.
; - village: the village number to check against.
;    the numbers don't seem to be chapter specific
;    (i.e. the villages in chapter have IDs 5, 6, and 7)
;    but I don't know any more details.
macro VillageHeader(flag, unit, village)
    db $0A, <flag>
    dw <unit>, <village>
endmacro

; first argument: unit which activates the event
; second/third arugment: upper left x/y boundary of the area
; fourth/fifth argument: lower right x/y boundary of the area
; 6th argument: ???
macro AreaEventHeader(flag, unit, x1, ...)
    !y1 = <0>
    !argc #= sizeof(...)
    if !argc >= 3
        !x2 = <1>
        !y2 = <2>
    else
        !x2 = <x1>
        !y2 = !y1
    endif
    if !argc >= 4
        !arg6 = <3>
    else 
        !arg6 = $FF
    endif
    db $0B, <flag>
    dw <unit>
    db <x1>, !y1, !x2, !y2, !arg6
endmacro

; flag - flag required to enable event. leave as $FF to skip.
; arg2 - purpose unknown, compared with $0EBD. (Maybe a faction?)
; unit - player/initiating unit.
; arg3 - purpose unknown, compared with $0EC1. (Maybe a faction?)
; enemy - enemy unit ID
macro BattleEventHeader(flag, arg2, unit, arg3, enemy)
    db $0D, <flag>
    dw <arg2>, <unit>, <arg3>, <enemy>
endmacro

; Seems similar to BattleEventHeader
macro _Header0E(flag, arg2, unit, arg3, enemy)
    db $0E, <flag>
    dw <arg2>, <unit>, <arg3>, <enemy>
endmacro

; run some event after a unit dies
; arguments:
;  - flag: event flag linked to this event.
;    will be skipped if set, and will be set after running.
;  - unit1: the dead unit.
;  - faction: faction the unit is linked to
; $FF/$FFFF can be given for any argument to skip its check.
macro PostDeathEventHeader(flag, unit1, faction)
    db $0F, <flag>
    dw <unit1>, <faction>
endmacro

; probably another death or battle event header?
macro _Header1A(flag, unit1, faction)
    db $1A, <flag>
    dw <unit1>, <faction>
endmacro

; does something if:
; - $0ebc == $1B
; - $0eae == (the second argument)
; - the third agument is another event header
; - which is parsed if the condition for this event is not met
macro _Header1D(flag, arg1)
    db $1d, <flag>
    dw <arg1>
endmacro

; Used for Holyn's recruitment in ch2
; might be arena specific?
macro PostDefeatEventHeader(flag, unit1, faction, unit2)
    db $1E, <flag>
    dw <unit1>, <faction>, <unit2>
endmacro

; parameters:
; - turn: the turn number. Set to $FF for any turn.
; - faction: which faction's turn will trigger the event. Set to $FF for any faction.
; - unitIndex: seems to check against the offset of the current unit in the faction's list?
;    for example: Ayra is index 4 in Verdane's list, 
;    so all the events related to when she's an enemy check for index 4.
; - unitID: checks the ID of the current active unit. 
;    Set to $FFFF skip this check. 
;    Set to $0000 for events at the start of a phase.
macro TurnCheckHeader(turn, faction, unitIndex, unitID)
    db $21, <turn>, <faction>, <unitIndex>
    dw <unitID>
endmacro

; Set a flag
macro SetFlagHeader(flag)
    db $27, <flag>
endmacro

; Check if an event flag is set or not.
macro CheckFlagSetHeader(arg1)
    db $29, <arg1>
endmacro

macro CheckFlagNotSetHeader(flag)
    db $2A, <flag>
endmacro

; Require all flags in a list to be set
macro CheckAllFlagsSetHeader(...)
    db $2C
    !a #= 0
    !limit #= sizeof(...)
    while !a < !limit
        db <!a>
        !a #= !a+1
    endif
    db $FF
endmacro

; Require at least one of a given list of flags to be set
macro CheckAnyFlagsAreSetHeader(...)
    db $2D
    !a #= 0
    !limit #= sizeof(...)
    while !a < !limit
        db <!a>
        !a #= !a+1
    endif
    db $FF
endmacro

; These all do nothing but increment the counter by 2 if parsed
; But the type parameter may have different effects:
; - $20 separates talk/village/turn events from turn/phase events?
;   (maybe including area events)
; - $25 - terminates $21 - type headers
; - $2D - purpose unknown
; - $2E - terminates CheckFlagsAreSetHeaders
; - $2F - purpose unknown
macro HeaderSeparator(type)
    db <type>
    dw $6666
endmacro

; runs an event if the last header check was successful
macro RunEventHeader(flag, event)
    db $30, <flag>
    dw <event>
endmacro

; show text inside the battle
; if DeathFlag is nonzero, the text will be shown 
;  on the enemies death instead of at the start of the fight.
macro InBattleTextHeader(flag, text, deathFlag)
    db $31, <flag>
    dl <text>
    db <deathFlag>
endmacro

; show the specified text with the given music
macro PreBattleTextHeader(flag, text, track)
    db $32, <flag>
    dl <text>
    dw <track>
endmacro

; documentation tbd
macro _Header44(arg1)
    db $44, $05
endmacro

; ???
; searches for some unit based on the first argument 
; and sets something based on the second
macro _Header4B(arg1, arg2)
    db $4B, <arg1>, <arg2>
endmacro

; ???
; searches for some unit based on the first argument 
; and sets something based on the second
macro _Header4D(arg1, arg2)
    db $4D, <arg1>
    dw <arg2>
endmacro

; sets flag #$0001 at $7E4ED9 and $7E4F39
; this gets activated after Elliot's defeat in Ch1
; so maybe it has something to do with AI?
macro _Header74()
    db $74
endmacro

; runs $869970 with the given address as a list to search
; the function seems to check if any two units in the list are lovers
macro _CheckList(address)
    db $77
    dl <address>
endmacro

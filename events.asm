includeonce

; set of macros for events in FE4.
; I've only documented ones that I've seen, so this list is incomplete.

; raw events
; if a macro or define starts with a _, it means I'm not sure what it does.

; jump the event parser to the specified location
; location must be in the same bank as the starting event address
macro GOTO(location)
    db $02
    dw <location>
endmacro

; display text from the given long address
macro TEXT(text)
    db $0C
    dl <text>
endmacro

; shows castle name
; first parameter is probably the text pointer
; second parameter controls the color of the window
; third parameter is how long to keep the window shown for
; (note: using 0 for the timer will lock up the game)
macro CASTLENAME(name, affl, timer)
    db $0D
    dl <name>
    db <affl>, <timer>
endmacro

; sets music for an event.
macro MUSIC1(track)
    db $0E, <track>
endmacro

; usually used to stop or reduce volume for music
macro _12(arg1)
    db $12
    dw <arg1>
endmacro

; Resumes map music after an event.
macro RESMUSIC()
    db $13
endmacro

; Show text with a background
; - text is a long pointer to text
; - bg selects which background to use
; - exitfade and introfade control behavior at 
; the end and beginning of the scene, respectively
macro BGTEXT(text, bg, exitfade, introfade)
    db $14
    dl <text>
    db <bg>, <exitfade>, <introfade>
endmacro

; load unit + movement script?
; may loop until any previous movement scripts are done
macro LOADUNIT2(arg1, arg2, arg3, arg4, speed, arg6)
    db $23, <arg1>
    dw <arg2>
    db <arg3>, <arg4>, <speed>, <arg6>
endmacro

; loads a unit at startx/y, and moves them to endx/y at the given speed
; other parameters are a mystery to me
; setting _color to 1 messes up the moving sprite palette
macro LOADUNIT1(unit, arg1, startx, starty, endx, endy, speed, _color, arg2)
    db $24
    dw <unit>
    db <arg1>, <startx>, <starty>, <endx>, <endy>, <speed>, <_color>, <arg2>
endmacro

; ???
macro _28(arg1, arg2)
    db $28, <arg1>
    dw <arg2>
endmacro

; wait for movement from _23 to finish
macro _29()
    db $29
endmacro

; similar to _29, but isn't blocking?
macro _2A()
    db $2A
endmacro

; also used for sound/music, but only(?) in conjunction with _12
; also used to fade in on overwold events?
macro _34(arg1)
    db $34
    dw <arg1>
endmacro

; sets the camera's X, Y position
; usually used while the screen is black.
macro SETCAM(x, y)
    db $3A, <x>, <y>
endmacro

; ???
macro _3B(arg1)
    db $3B, <arg1>
endmacro

; move the camera based on some data at <location>
; the second argument controls the panning speed
macro MOVECAM(location, speed)
    db $3F
    dl <location>
    db <speed>
endmacro

; searches for a given unit and grabs some data for them
; stores the reults in $1722-$1728
macro _42(arg1, arg2)
    ; does something different if arg2 is nonzero
    db $42
    dw <arg1>
    db <arg2>
endmacro

; runs an arbitrary routine at the given long address
macro ASM(arg1)
    db $45
    dl <arg1>
endmacro

; fade in from black over the given time
macro FADEIN(time)
    db $46, <time>
endmacro

; seems generally to be used for giving items.
; the exact behavior depends of the first argument
; the 3rd and 4th are used for the Unit ID and Item index, respectively.
; other possible argument values: 
;   $49 (1 word argument) - loads units?
;   $4A (1 byte argument) - used as an offset for $81C000 + ???
;   $4E (1 byte argument) - maybe used for fading out music?
macro _GiveItem(arg1, ...)
    db $4A
    db <arg1>
    if <arg1> == $58 || <arg1> == $57
        if sizeof(...) < 2
            error "Wrong number of arguments for item giving."
        else
            ; TODO: synax may change here in asar 1.9x
            dw <0>
            db <1>
        endif
    else
        error "Undocumented _4A argument."
    endif
endmacro

; ???
macro _4F()
    db $4F
endmacro

; Move camera for overworld events
macro MAPPAN(arg1, arg2)
    db $51
    dw <arg1>, <arg2>
endmacro

; Sets text address for overworld events.
; Text is displayed on the next YIELD
macro MAPTEXT(text)
    db $58
    dl <text>
endmacro

; Clears overworld text?
macro _5A()
    db $5A
endmacro

; process all queued events
macro YIELD()
    db $FD
endmacro

; End the current event script
macro ENDEVENT()
    db $FFFF
endmacro

; helper macros
; these are shortcuts for common event arguments
; or combinations of multiple events
; usually some event(s) plus a RunEvents command

; combines all the event commands which are used to pause music
macro PauseMusic()
    %_12($00E0)
    %_34($0023)
    %YIELD()
endmacro

; sets music for an event, and also runs all queued events
macro SetMusic(arg1)
    %MUSIC1(<arg1>)
    %YIELD()
endmacro

; Restars map music
macro RestartMusic()
    %RESMUSIC()
    %YIELD()
endmacro

; display text from the given long address
; also runs all queued events
macro ShowText(arg1)
    %TEXT(<arg1>)
    %YIELD()
endmacro

; gives an item and equips it
; will abort if $FFFF is given as the unit number
macro GiveWeaponToUnit(unit, item)
    %_4A($58, <unit>, <item>)
endmacro

; adds an item to a units inventory
; the unit ID is optional. 
; this macro will automatically insert a $FFFF if no Unit ID is given.
macro GiveItemToUnit(...)
    if sizeof(...) > 1
        %_GiveItem($57, <0>, <1>)
    else 
        %_GiveItem($57, $FFFF, <0>)
    endif
endmacro

; Some recursive helpers to avoid having to insert RunEvents or EventEnd commands
; Depending on usage, there may be a risk of hitting a recursion limit.
; Also, Asar's syntax for passing macros to other macros is finnicky.
; Expecially if you want to put arguments on multiple lines.
; Caveat emptor.

; run some arbitrary number of event commands, with an $FD event at the end.
macro Yield(...)
    !a #= 0
    !limit #= sizeof(...)
    while !a < !limit
        <!a>
        !a #= !a+1
    endif
    %YIELD()
endmacro

; macro to automatically terminate a series of events.
macro Event(...)
    !a #= 0
    !limit #= sizeof(...)
    while !a < !limit
        <!a>
        !a #= !a+1
    endif
    %ENDEVENT()
endmacro

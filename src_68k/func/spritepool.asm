; freemlib for Neo-Geo - Sprite Pool routines
;==============================================================================;
; Having to manage sprite indexes manually sucks. That's what the Sprite Pool
; was designed to avoid. It was originally created when developing FM Studio.

; The general idea:
; In order to not hard-code sprite indexes, a pool of used sprites needs to be
; created. An "object map" for metasprites should also be available, allowing
; for ranges to be allocated and de-allocated almost automatically.
;==============================================================================;
; [Terms and Variables Overview]
; * "Sprite Pool"
;   The combined name for the functionality encompassing the sprite pool vars,
;   the sprite usage flags, and the object map.

; * "Sprite Usage Flags"
;   A very large bitfield that shows what sprites are free to use.

; * "Object Map"
;   A collection of metasprite data used by the sprite pool for rendering.

; * "nextFreeObject" (byte)
;   The next free slot in the object map.

; * "nextFreeSprite" (byte?)
;   I might need to rethink this.

; * "openSpaceCount" (byte)
;   Represents the number of free bits currently found in a search.

; * "openSpaceFlags" (byte)
;   Various flags relating to the searching functionality of sprite usage bits.
;   76543210
;   xxxxxx||
;         |+- Current sequence adds to counter (0:no, 1:yes)
;         +-- Complete match found? (0:no, 1:yes)

;==============================================================================;
; [Routine Overview]
; * spritePool_Init
;   Initializes the sprite pool variables, sprite usage flags, and object map.

; * spritePool_Allocate
;   Allocates a number of sprites and returns the first free sprite number.

; * spritePool_AddObject
;   Adds an object (metasprite) to the object map.

; * spritePool_FreeObject
;   Frees an object (metasprite) from the object map.

; * spritePool_Render
;   Renders the sprites in the object map. Called during VBlank.

; * spritePool_ClearObjects
;   Clears all entries in the object map.

;==============================================================================;
; [Object Map]
; Implementor's Note:
; The sprite pool functionality uses freemlib sprites/metasprites.

; (original object map data structure from FM Studio)
; Each entry takes up 8 bytes:
; $00     [byte] metasprite width (number of sprites needed)
; $01     [byte] metasprite height (number of tiles to write in SCB1)
; $02,$03 [word] starting sprite index (as assigned by spritePool_Allocate)
; $04-$07 [long] pointer to metasprite data (typically in RAM)


;==============================================================================;

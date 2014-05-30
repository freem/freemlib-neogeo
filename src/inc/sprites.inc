; freemlib for Neo-Geo - Sprite Functions
;==============================================================================;
; todo: a lot of things need to exist here.

; Overall a sprite consists of values written to four sections:
; * SCB1 ($0000-$6FFF)		Tilemaps, palette, auto-animation, and flip bits
; * SCB2 ($8000-$81FF)		Shrinking coefficients
; * SCB3 ($8200-$83FF)		Y position, Sticky bit, Sprite height
; * SCB4 ($8400-$85FF)		X position

; There's also some values that I'm not sure of yet:
; * ($8600-$867F)			Sprite list for even scanlines
; * ($8680-$86FF)			Sprite list for odd scanlines

;==============================================================================;
; Calculating X position:
; FEDCBA9876543210
; 000000000xxxxxxx
; |||||||||
; +++++++++- 9-bit X position, relative to left border of screen. (0-511)
; xPos = (x<<7)

;------------------------------------------------------------------------------;
; Calculating Y position:
; FEDCBA9876543210
; 000000000~~~~~~~
; |||||||||
; +++++++++- 9-bit Y position; Position is 496-Y from top border of the screen.
; yPos = ((496-y)<<7)

;==============================================================================;
; [Sprites]

;==============================================================================;
; [Metasprites]

;==============================================================================;
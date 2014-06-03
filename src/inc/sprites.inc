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
;------------------------------------------------------------------------------;
; spr_Load
; Loads a sprite into the VRAM.

; (Params)
; d*			Sprite index
; a*			Pointer to Sprite Data Block

spr_Load:
	; convert sprite index into locations for SCB1-4
	; write those locations into d?-d?.

	; start reading from sprite data block
	; $00		sprite height

	; $02-05	pointer to SCB1 tilemap data
	;jsr	spr_ParseSCB1

	; $06		SCB2 data
	; $08,$0A	SCB3 data
	; $0C		SCB4 data

	rts

;------------------------------------------------------------------------------;
; spr_ParseSCB1
; Internal function for parsing SCB1 tilemap data.

; (Params)
; d?			Number of Sprites to parse

spr_ParseSCB1:
	; 1) Tile Number LSB

	; 2-1) Palette
	; 2-2) Tile Number MSB
	; 2-3) Auto-Animation flags
	; 2-4) V/H flip flags

	rts

;==============================================================================;
; [Metasprites]
;------------------------------------------------------------------------------;
; msp_Load
; Loads a Metasprite into the VRAM.

; (Params)
; d*			Metasprite starting index
; a*			Pointer to Metasprite Data Block

msp_Load:
	; $00		number of sprites in metasprite

; metasprite sprite loading loop:
	; load pointer to sprite data
	; set sprite index and data pointer
	;jsr spr_Load
	; loop until finished

	rts

;==============================================================================;
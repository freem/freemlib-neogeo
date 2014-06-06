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
; 000000000-------
; |||||||||
; +++++++++- 9-bit X position, relative to left border of screen. (0-511)
; xPos = (x<<7)

; utilmac_CalcSprX
; Calculates a Sprite's X value (for SCB4).

; \1

utilmac_CalcSprX:	macro
	endm

;------------------------------------------------------------------------------;
; Calculating Y position:
; FEDCBA9876543210
; 000000000~~~~~~~
; |||||||||
; +++++++++- 9-bit Y position; Position is 496-Y from top border of the screen.
; yPos = ((496-y)<<7)

; utilmac_CalcSprY
; Calculates a Sprite's Y value (for SCB3).

utilmac_CalcSprY:	macro
	endm

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
; d?			Sprite index (carried over from spr_Load or msp_Load)
; d?			Number of Sprites to parse

spr_ParseSCB1:
	; 1) Tile Number LSB

	; 2-1) Palette
	; 2-2) Tile Number MSB
	; 2-3) Auto-Animation flags
	; 2-4) V/H flip flags

	rts

;==============================================================================;
; Sprite Macros
;------------------------------------------------------------------------------;
; sprmac_SCB1Data
; Writes a single SCB1 data entry into the binary.
; This macro converts normal values to their SCB1 equivalents.
; You will want to use this macro multiple times for Sprites with Height > 1.

; \1			Tile Number				(long) 20 bits; SCB1 even, SCB1 odd (bits 4-7)
; \2			Palette Number			(word) 8 bits; SCB1 odd (bits 8-15)
; \3			Auto-Animation (0,2,3)	(byte) 2 bits; SCB1 odd (bits 2,3)
; \4			Vertical Flip			(byte) 1 bit; SCB1 odd (bit 1)
; \5			Horizontal Flip			(byte) 1 bit; SCB1 odd (bit 0)

sprmac_SCB1Data:	macro
	endm

;------------------------------------------------------------------------------;
; sprmac_SpriteData
; Writes Sprite data into the binary.
; This macro converts normal values to their SCB* section equivalents.
; (Aside from SCB1 tilemaps, which are handled with the sprmac_SCB1Data macro.)

; The point of this macro is to be user-friendly, so that they don't need to
; handle all the crap required to create the SCB data.

; \1			Sprite Height (in tiles)		(word) (bottom 6 bits of SCB3)
; \2			X position						(word) 9 bits (SCB4); X<<7
; \3			Y position						(word) 9 bits (SCB3); convert to (496-Y)<<7
; \4			Pointer to SCB1 tilemap data	(long)
; \5			Horizontal Shrink (0-F)			(byte)
; \6			Vertical Shrink (00-FF)			(byte)

sprmac_SpriteData:	macro
	endm

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
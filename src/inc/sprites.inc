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

; (Input)
; \1			X value
; (Output)
; d0			Shifted X value

utilmac_CalcSprX:	macro
	move.w	(\1<<7),d0
	endm

;------------------------------------------------------------------------------;
; Calculating Y position:
; FEDCBA9876543210
; 000000000~~~~~~~
; |||||||||
; +++++++++- 9-bit Y position; Position is 496-Y from top border of the screen.
; yPos = ((496-y)<<7)

; It's up to you to combine the rest of the SCB3 values as needed.

; utilmac_CalcSprY
; Calculates a Sprite's Y value (for SCB3).

; (Input)
; \1			Y value
; (Output)
; d0			Calculated Y value

utilmac_CalcSprY:	macro
	move.w	((496-\1)<<7),d0
	endm

;==============================================================================;
; [Sprites]
;------------------------------------------------------------------------------;
; spr_Load
; Loads a single sprite into the VRAM. Can be called on its own, or by mspr_Load.

; (Params)
; d0			Sprite index (0-511; sprite 0 is not recommended!)
; a0			Pointer to Sprite Data Block

spr_Load:
	; start reading from sprite data block
	move.w	(a0)+,d1			; $00		sprite height (in tiles)

	; Handle SCB1
	move.l	(a0)+,a1			; $02-05	pointer to SCB1 tilemap data
	jsr		spr_ParseSCB1

	; SCB2 ($8000-$81FF)
	move.w	#$8000,d2			; begin at $8000
	add.w	d0,d2				; add sprite index
	move.w	d2,LSPC_ADDR		; set new VRAM address
	move.w	(a0)+,LSPC_DATA		; $06		SCB2 data

	; SCB3 ($8200-$83FF)
	move.w	#$8200,d2			; begin at $8200
	add.w	d0,d2				; add sprite index
	move.w	d2,LSPC_ADDR		; set new VRAM address
	move.w	(a0)+,LSPC_DATA		; $08		SCB3 data

	; SCB4 ($8400-$85FF)
	move.w	#$8400,d2			; begin at $8400
	add.w	d0,d2				; add sprite index
	move.w	d2,LSPC_ADDR		; set new VRAM address
	move.w	(a0)+,LSPC_DATA		; $0A		SCB4 data

	rts

;------------------------------------------------------------------------------;
; spr_ParseSCB1
; Internal routine for writing SCB1 tilemap data.

; (Params)
; d0			Sprite index (carried over from spr_Load or mspr_Load)
; d1			Number of tiles to parse
; a1			Pointer to SCB1 tilemap data

spr_ParseSCB1:
	move.w	#1,LSPC_INCR		; VRAM increment +1

	moveq	#0,d2				; clear d2
	; convert sprite index into starting SCB1 location
	;(either d0*64 or d0<<6) = SCB1 VRAM location
	move.w	d0,d2				; copy sprite index (d0) to temp
	lsl.w	#6,d2				; d2 << 6
	move.w	d2,LSPC_ADDR		; write new vram address

	; check number of tiles
	cmpi.w	#1,d1				; numTiles == 1?
	bgt		spr_ParseSCB1_Multiple	; otherwise, loop.

	; if numTiles == 1, do a single write.
spr_ParseSCB1_Single:
	move.w	(a1)+,LSPC_DATA		; 1) Tile Number LSB
	move.w	(a1)+,LSPC_DATA		; 2) Palette, Tile Number MSB, Auto-Animation flags, V/H flip flags
	bra		spr_ParseSCB1_End

spr_ParseSCB1_Multiple:
	move.w	d1,d7				; copy num tiles (d1) to temp
	subi.w	#1,d7				; subtract 1 for loop counter

; tile loop
spr_ParseSCB1_Loop:
	move.w	(a1)+,LSPC_DATA		; 1) Tile Number LSB
	move.w	(a1)+,LSPC_DATA		; 2) Palette, Tile Number MSB, Auto-Animation flags, V/H flip flags
	dbra	d7,spr_ParseSCB1_Loop

spr_ParseSCB1_End:
	rts

;==============================================================================;
; Sprite Macros
;------------------------------------------------------------------------------;
; sprmac_SCB1Data
; Writes a single SCB1 data entry into the binary.
; This macro converts normal values to their SCB1 equivalents.
; You will want to use this macro multiple times for Sprites with Height > 1.

; \1			Tile Number				(long) 20 bits; SCB1 even, SCB1 odd (bits 4-7)
; \2			Palette Number			(byte) 8 bits; SCB1 odd (bits 8-15)
; \3			Auto-Animation (0,4,8)	(byte) 2 bits; SCB1 odd (bits 2,3) 4=2bit, 8=3bit
; \4			Vertical Flip			(byte) 1 bit; SCB1 odd (bit 1)
; \5			Horizontal Flip			(byte) 1 bit; SCB1 odd (bit 0)

sprmac_SCB1Data:	macro
	dc.w	(\1&$0FFFF)
	dc.w	(\2<<8)|((\1&$F0000)>>12)|(\3)|(\4<<1)|\5
	endm

;------------------------------------------------------------------------------;
; sprmac_SpriteData
; Writes Sprite data into the binary.
; This macro converts normal values to their SCB* section equivalents.
; (Aside from SCB1 tilemaps, which are handled with the sprmac_SCB1Data macro.)

; The point of this macro is to be user-friendly, so that they don't need to
; handle all the crap required to create the SCB data.

; Major Note: This does not handle the sticky bit in SCB3.

; \1			Sprite Height (in tiles)		(word) (bottom 6 bits of SCB3)
; \2			X position						(word) 9 bits (SCB4); X<<7
; \3			Y position						(word) 9 bits (SCB3); convert to (496-Y)<<7
; \4			Pointer to SCB1 tilemap data	(long)
; \5			Horizontal Shrink (0-F)			(byte)
; \6			Vertical Shrink (00-FF)			(byte)

sprmac_SpriteData:	macro
	dc.w	\1						; Sprite Height (in tiles)
	dc.l	\4						; pointer to SCB1 data
	dc.w	((\5&$0F)<<8)|(\6&$FF)	; SCB2
	dc.w	((496-\3)<<7)|(\1&$3F)	; SCB3 (sans sticky bit)
	dc.w	(\2)<<7					; SCB4
	endm

;==============================================================================;
; [Metasprites]
;------------------------------------------------------------------------------;
; mspr_Load
; Loads a Metasprite into the VRAM.

; (Params)
; d0			Metasprite starting sprite index
; a0			Pointer to Metasprite Data Block

mspr_Load:
	move.w	d0,d5				; save initial sprite number
	movea.l	a0,a2				; a0 is used by other routines
	move.w	(a2)+,d6			; $00	number of sprites in metasprite
	subi.w	#1,d6				; subtract 1 for loop counter

; metasprite sprite loading loop
mspr_Load_Loop:
	movea.l	(a2)+,a0			; get sprite data block pointer
	jsr		spr_Load			; load sprite

	; something about automatically setting sticky bit if d0 > d5
	cmp.w	d5,d0
	beq		mspr_LoadLoop_Continue

	; set sticky bit for this sprite
	move.w	d0,d4				; temporary for getting SCB3 addr
	addi.w	#$8200,d4			; address into SCB3
	move.w	d4,LSPC_ADDR		; set VRAM addr
	move.w	#$0040,LSPC_DATA	; set sticky bit

mspr_LoadLoop_Continue:
	addq.w	#1,d0				; update sprite index
	dbra	d6,mspr_Load_Loop	; loop until finished

mspr_Load_End:
	rts

;==============================================================================;

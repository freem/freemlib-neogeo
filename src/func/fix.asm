; freemlib for Neo-Geo - Fix Layer Functions
;==============================================================================;
; [Ranges/Valid Values]
; Combined Cell Location	$XXYY, where XX=$0-$27,YY=$00-$1F
; Raw VRAM Address			$7000-$74FF

; [Notes]
; Most of these functions change LSPC_INCR values, so it's up to the caller to
; reset LSPC_INCR after calling any function in this file.

; todo: add vram <-> 68k ram routines
;==============================================================================;
; fixmac_CalcVRAMAddr
; This macro is slightly complicated...
; 1) Determine if the param passed in is a combined cell location or VRAM address.
; 2) If it's a combined cell location, calculate the VRAM address; otherwise, do nothing.

; (Params)
; d0				Combined cell location (x,y) or Raw VRAM address ($7000-$74FF)
; (Combined cell location format: $XXYY, where XX=$0-$27,YY=$00-$1F)

; (Output)
; d0				output VRAM address

; (Clobbers)
; d6				Used for calculating X coordinate
; d7				Used for calculating Y coordinate

fixmac_CalcVRAMAddr:	macro
	; 1) do check for vram addr or cell location (d0 >= $7000)
	cmpi.w	#$7000,d0
	bge		.fm_CVA_End			; no need to process values $7000 or greater

	; 2) Calculate VRAM address from cell location
	move.w	d0,d7				; put combined cell location in d7
	andi.w	#$00FF,d7			; mask for Y position

	move.w	d0,d6				; put combined cell location in d6
	andi.w	#$FF00,d6			; mask for X position
	asl.w	#8,d6				; shift over

	; convert to vram address
	; VRAM Address from Cells = $7000 + (X*$20) + (Y)
	move.w	#$0020,d5			; store $20 for multiplying
	mulu.w	d5,d6				; do X*20
	add.w	d7,d6				; add Y
	addi.w	#$7000,d6			; add $7000
	move.w	d6,d0				; = new value in d0 (other fix functions depend on this)

.fm_CVA_End:
	endm

;==============================================================================;
; fix_UpdateTile
; Change the tile number and palette index of a fix map location.

; (Params)
; d0				Combined cell location (x,y) or Raw VRAM address ($7000-$74FF)
; d1				New palette index (pppp) and tile number (TTTT tttttttt)

fix_UpdateTile:
	fixmac_CalcVRAMAddr			; VRAM address check/combined cell loc. conversion

	move.w	d0,LSPC_ADDR		; set vram address
	move.w	d1,LSPC_DATA		; change tile number and palette index
	rts

;==============================================================================;
; fix_ChangeTile
; Change the tile number of a fix map location.

; (Params)
; d0				Combined cell location (x,y) or Raw VRAM address ($7000-$74FF)
; d1				New tile number

fix_ChangeTile:
	fixmac_CalcVRAMAddr			; VRAM address check/combined cell loc. conversion

	move.w	d0,LSPC_ADDR		; set vram address
	move.w	LSPC_DATA,d2		; get current data
	andi.w	#$F000,d2			; mask for palette
	or.w	d2,d1				; OR with new tile data
	move.w	d1,LSPC_DATA		; change tile number
	rts

;==============================================================================;
; fix_ChangePal
; Change the palette index of a fix map location.

; (Params)
; d0				Combined cell location (x,y) or Raw VRAM address ($7000-$74FF)
; d1				New palette number

fix_ChangePal:
	fixmac_CalcVRAMAddr			; VRAM address check/combined cell loc. conversion

	move.w	d0,LSPC_ADDR		; set vram address
	move.w	LSPC_DATA,d2		; get current data
	andi.w	#$0FFF,d2			; mask for tile index
	or.w	d2,d1				; OR with new palette
	move.w	d1,LSPC_DATA		; change palette index
	rts

;==============================================================================;
; fix_Draw8x16
; Draws "normal" 8x16 text to the screen. End code is $FF.

; "normal 8x16 text" means this font layout:
; A B C D <- top half
; A B C D <- bottom half

; (Params)
; d0				Combined cell location (x,y) or Raw VRAM address ($7000-$74FF)
; d1				Palette index and tile number MSB
; a0				Pointer to string to draw

fix_Draw8x16:
	fixmac_CalcVRAMAddr			; VRAM address check/combined cell loc. conversion

	move.w	#$20,LSPC_INCR		; set VRAM increment +$20 (horiz. writing)

	; draw top line
.fix_d8x16_TopLoop:
	

	; prepare to draw bottom line
	; (change VRAM address, reset loop vars)

	; draw bottom line
.fix_d8x16_BotLoop:
	

	rts

;==============================================================================;
; fix_Draw16x16
; Draws "normal" 16x16 text to the screen. End code is $FF.

; "normal 16x16 text" means this font layout:
; A A <- top left/top right
; A A <- bottom left/bottom right

; (Params)
; d0				Combined cell location (x,y) or Raw VRAM address ($7000-$74FF)
; d1				Palette index and tile number MSB
; a0				Pointer to string to draw

fix_Draw16x16:
	fixmac_CalcVRAMAddr			; VRAM address check/combined cell loc. conversion

	move.w	#$20,LSPC_INCR		; set VRAM increment +$20 (horiz. writing)

	; draw top line
.fix_d16x16_TopLoop:
	

	; prepare to draw bottom line
	; (change VRAM address, reset loop vars)

	; draw bottom line
.fix_d16x16_BotLoop:

	rts

;==============================================================================;
; fix_DrawRegion
; Draws a rectangular region of tiles.

; (Params)
; d0				Combined cell location (x,y) or Raw VRAM address ($7000-$74FF)
; d1				Combined rows/columns size ($XXYY)
; d2				Palette index and tile number MSB
; a0				Pointer to data to draw

; (Clobbers)
; d6				Used for column/X size
; d7				Used for row/Y size

fix_DrawRegion:
	fixmac_CalcVRAMAddr			; VRAM address check/combined cell loc. conversion

	move.w	#$20,LSPC_INCR		; set VRAM increment +$20 (horiz. writing)
	move.w	d0,LSPC_ADDR		; set initial VRAM address

	; get rows
	move.w	d1,d7
	andi.w	#$FF00,d7
	lsr.w	#8,d7				; shift right

	; loop 1 (row/Y)
fix_DrawRegion_Rows:
	; get cols
	move.w	d1,d6
	andi.w	#$00FF,d6

	; loop 2 (column/X)
fix_DrawRegion_Cols:
	; write data
	move.w	(a0)+,LSPC_DATA
	; loop cols
	dbra	d6,fix_DrawRegion_Cols

	; update vram address
	addi.w	#$20,d0
	move.w	d0,LSPC_ADDR

	; loop rows
	dbra	d7,fix_DrawRegion_Rows

fix_DrawRegion_End:
	rts

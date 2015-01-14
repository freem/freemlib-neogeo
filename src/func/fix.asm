; freemlib for Neo-Geo - Fix Layer Functions
;==============================================================================;
; [Ranges/Valid Values]
; Combined Cell Location	$XXYY, where XX=$0-$27,YY=$00-$1F
; Raw VRAM Address			$7000-$74FF

; [Notes]
; Most of these functions change LSPC_INCR values, so it's up to the caller to
; reset LSPC_INCR after calling any function in this file.

; todo:
; * fix_Draw8x16 needs to be easier to use
;  * string data (no "&$FF" everywhere)
;  * ability to use multiple pages in a single string (currently limited to 1)
; * test fix_ClearAll
; * finish writing fix_Draw16x16
; * finish writing vram <-> 68k ram routines
; * routine for taking a "nametable" and writing it to the fix layer

;==============================================================================;
; fixmac_CalcVRAMAddr
; This macro is slightly complicated...
; 1) Determine if the param passed in is a combined cell location or VRAM address.
; 2) If it's a combined cell location, calculate the VRAM address; otherwise, do nothing.

; (Params)
; d0		[word] Combined cell location (x,y) or raw VRAM address ($7000-$74FF)
; (Combined cell location format: $XXYY, where XX=$00-$27,YY=$00-$1F)
; Note: No sanity checking is done here with the ranges.

; (Output)
; d0		[word] output VRAM address

; (Clobbers)
; d5		Used for converting X/Y location to VRAM address
; d6		Used for calculating X coordinate
; d7		Used for calculating Y coordinate

fixmac_CalcVRAMAddr:	macro
	; 1) do check for vram addr or cell location (d0 >= $7000)
	cmpi.w	#$7000,d0
	bge		.fm_CVA_End			; no need to process values $7000 or greater

	; 2) Calculate VRAM address from cell location
	move.w	d0,d7				; put combined cell location in d7
	andi.w	#$00FF,d7			; mask for Y position

	move.w	d0,d6				; put combined cell location in d6
	andi.w	#$FF00,d6			; mask for X position
	asr.w	#8,d6				; shift over

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
; d0		[word] Combined cell location (x,y) or raw VRAM address ($7000-$74FF)
; d1		[long] New palette index (pppp) and tile number (TTTT tttttttt)

fix_UpdateTile:
	fixmac_CalcVRAMAddr			; VRAM address check/combined cell loc. conversion

	move.w	d0,LSPC_ADDR		; set vram address
	move.w	d1,LSPC_DATA		; change tile number and palette index
	rts

;==============================================================================;
; fix_ChangeTile
; Change the tile number of a fix map location.

; (Params)
; d0		[word] Combined cell location (x,y) or raw VRAM address ($7000-$74FF)
; d1		[word] New tile number ($000-$FFF)

; (Clobbers)
; d2		Used for reading from VRAM

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
; d0		[word] Combined cell location (x,y) or raw VRAM address ($7000-$74FF)
; d1		[word] New palette number ($0000-$F000, only incrementing the first value)

; (Clobbers)
; d2		Used for reading from VRAM

fix_ChangePal:
	fixmac_CalcVRAMAddr			; VRAM address check/combined cell loc. conversion
	move.w	d0,LSPC_ADDR		; set vram address

	move.w	LSPC_DATA,d2		; get current data
	andi.w	#$0FFF,d2			; mask for tile index
	or.w	d2,d1				; OR with new palette
	move.w	d1,LSPC_DATA		; change palette index
	rts

;==============================================================================;
; fix_DrawString
; Draws horizontal text to the screen manually. End code is $FF.

; (Params)
; d0		[word] Combined cell location (x,y) or raw VRAM address ($7000-$74FF)
; d1		[byte] Palette index and tile number MSB
; a0		[long] Pointer to string to draw

; (Clobbers)
; d2		Byte for writing
; d3		Used for temporary tile assembly

fix_DrawString:
	fixmac_CalcVRAMAddr			; VRAM address check/combined cell loc. conversion
	move.w	d0,LSPC_ADDR		; set new VRAM address

	move.w	#$20,LSPC_INCR		; set VRAM increment +$20 (horiz. writing)

	moveq	#0,d2				; set up d2
	moveq	#0,d3				; set up d3

.fix_DrawString_Loop:
	cmpi.b	#$FF,(a0)
	beq.b	.fix_DrawString_End
	move.w	d1,d3				; get pal. index and tile number MSB
	lsl.w	#8,d3				; shift into upper byte of word
	move.b	(a0)+,d2			; read byte from string, increment read position
	or.w	d3,d2				; OR with shifted pal. index and tile number MSB
	move.w	d2,LSPC_DATA		; write combined tile to VRAM
	bra.b	.fix_DrawString_Loop	; loop until finding $FF

.fix_DrawString_End:
	rts

;==============================================================================;
; fix_Draw8x16
; Draws "normal" 8x16 text to the screen. End code is $FF.

; "normal 8x16 text" means this font layout:
; A B C D <- top half
; A B C D <- bottom half

; (Params)
; d0		Combined cell location (x,y) or raw VRAM address ($7000-$74FF)
; d1		Palette index
; a0		Pointer to string to draw
; a1		Pointer to character map

; (Clobbers)
; a2		Used for original string pointer
; d2		Byte for writing
; d3		Used for temporary tile assembly and VRAM address changing

fix_Draw8x16:
	fixmac_CalcVRAMAddr			; VRAM address check/combined cell loc. conversion
	move.w	d0,LSPC_ADDR		; set new VRAM address

	move.w	#$20,LSPC_INCR		; set VRAM increment +$20 (horiz. writing)
	movea.l	a0,a2				; copy original string pointer for later

	; set up d3
	moveq	#0,d3
	move.b	d1,d3				; get pal. index
	andi.w	#$F0,d3				; mask for palette
	lsl.w	#8,d3				; shift into upper byte of word

	; draw top line
.fix_d8x16_TopLoop:
	; check for end code
	cmpi.b	#$FF,(a0)
	beq.b	.fix_d8x16_FinishTop

	moveq	#0,d2				; set up d2
	move.b	(a0)+,d2			; read byte from string, increment read position
	lsl.w	#1,d2
	move.w	(a1,d2),d2

	or.w	d3,d2				; OR with shifted pal. index
	move.w	d2,LSPC_DATA		; write combined tile to VRAM
	bra.b	.fix_d8x16_TopLoop	; loop until finding $FF

.fix_d8x16_FinishTop:
	; prepare to draw bottom line

	; change VRAM address
	move.w	d0,d3				; get original VRAM position
	addi.w	#$01,d3				; add +1 for next vertical line
	move.w	d3,LSPC_ADDR		; set new VRAM address

	; reset original string pointer
	movea.l	a2,a0

	; set up d3
	moveq	#0,d3
	move.b	d1,d3				; get pal. index
	andi.w	#$F0,d3				; mask for palette
	lsl.w	#8,d3				; shift into upper byte of word

	; draw bottom line
.fix_d8x16_BotLoop:
	; check for end code
	cmpi.b	#$FF,(a0)
	beq.b	.fix_d8x16_End

	moveq	#0,d2				; set up d2
	move.b	(a0)+,d2			; read byte from string, increment read position
	lsl.w	#1,d2
	move.w	(a1,d2),d2
	addi.b	#$10,d2				; bottom tile is $10 below top tile

	or.w	d3,d2				; OR with shifted pal. index
	move.w	d2,LSPC_DATA		; write combined tile to VRAM
	bra.b	.fix_d8x16_BotLoop	; loop until finding $FF

.fix_d8x16_End:
	rts

;==============================================================================;
; fix_Draw16x16
; Draws "normal" 16x16 text to the screen. End code is $FF.

; "normal 16x16 text" means this font layout:
; A A <- top left, top right
; A A <- bottom left, bottom right

; (Params)
; d0		[word] Combined cell location (x,y) or raw VRAM address ($7000-$74FF)
; d1		Palette index
; a0		[long] Pointer to string to draw
; a1		[long] Pointer to character map

fix_Draw16x16:
	fixmac_CalcVRAMAddr			; VRAM address check/combined cell loc. conversion
	move.w	d0,LSPC_ADDR		; set new VRAM address

	move.w	#$20,LSPC_INCR		; set VRAM increment +$20 (horiz. writing)

	; draw top line
.fix_d16x16_TopLoop:
	; check for end code
	cmpi.b	#$FF,(a0)
	beq.b	.fix_d16x16_FinishTop

	;char and char+1

	bra.b	.fix_d16x16_TopLoop	; loop until finding $FF

.fix_d16x16_FinishTop:
	; prepare to draw bottom line

	; change VRAM address
	move.w	d0,d3				; get original VRAM position
	addi.w	#$01,d3				; add +1 for next vertical line
	move.w	d3,LSPC_ADDR		; set new VRAM address

	; reset loop vars

	; draw bottom line
.fix_d16x16_BotLoop:
	; check for end code
	cmpi.b	#$FF,(a0)
	beq.b	.fix_d16x16_End

	;char+$10 and char+$11

	bra.b	.fix_d16x16_BotLoop	; loop until finding $FF

.fix_d16x16_End:
	rts

;==============================================================================;
; fix_DrawRegion
; Draws a rectangular region of tiles using a single palette and tile number MSB.

; (Params)
; d0		Combined cell location (x,y) or raw VRAM address ($7000-$74FF)
; d1		Combined rows/columns size ($YYXX)
; d2		Palette index and tile number MSB
; a0		Pointer to data to draw

; (Clobbers)
; d5		Combined value to write to VRAM
; d6		Used for column/X size
; d7		Used for row/Y size

fix_DrawRegion:
	fixmac_CalcVRAMAddr			; VRAM address check/combined cell loc. conversion
	move.w	d0,LSPC_ADDR		; set initial VRAM address

	move.w	#$20,LSPC_INCR		; set VRAM increment +$20 (horiz. writing)

	; get rows
	move.w	d1,d7
	andi.w	#$FF00,d7
	lsr.w	#8,d7				; shift right

	; loop 1 (row/Y)
.fix_DrawRegion_Rows:
	; get cols
	move.w	d1,d6
	andi.w	#$00FF,d6

	; loop 2 (column/X)
.fix_DrawRegion_Cols:
	moveq	#0,d5				; clear d5 for combiation
	move.b	d2,d5				; copy d2 to d5
	lsl.w	#8,d5				; shift d2 to upper byte
	move.b	(a0)+,d5			; get byte from data

	; write data
	move.w	d5,LSPC_DATA
	; loop cols
	dbra	d6,.fix_DrawRegion_Cols

	; update vram address
	addi.w	#1,d0
	move.w	d0,LSPC_ADDR

	; loop rows
	dbra	d7,.fix_DrawRegion_Rows

.fix_DrawRegion_End:
	rts

;==============================================================================;
; fix_FillRegion
; Fills a rectangular region of tiles with the specified tile.

; (Params)
; d0		[word] Combined cell location (x,y) or raw VRAM address ($7000-$74FF)
; d1		[word] Combined rows/columns size ($YYXX)
; d2		[word] Tile data to use for filling.

fix_FillRegion:
	fixmac_CalcVRAMAddr			; VRAM address check/combined cell loc. conversion
	move.w	d0,LSPC_ADDR		; set initial VRAM address

	move.w	#$20,LSPC_INCR		; set VRAM increment +$20 (horiz. writing)

	; get rows
	move.w	d1,d7
	andi.w	#$FF00,d7
	lsr.w	#8,d7				; shift right

	; loop 1 (row/Y)
.fix_FillRegion_Rows:
	; get cols
	move.w	d1,d6
	andi.w	#$00FF,d6

	; loop 2 (column/X)
.fix_FillRegion_Cols:
	move.w	d2,LSPC_DATA		; write data

	; loop cols
	dbra	d6,.fix_FillRegion_Cols

	; update vram address
	addi.w	#1,d0
	move.w	d0,LSPC_ADDR

	; loop rows
	dbra	d7,.fix_FillRegion_Rows

.fix_FillRegion_End:
	rts

;------------------------------------------------------------------------------;
; fix_ClearRegion
; Macro for clearing a region using tile $00FF.

; (Params)
; d0		[word] Starting combined cell location (x,y) or raw VRAM address ($7000-$74FF)
; d1		[word] Combined rows/columns size ($YYXX)

fix_ClearRegion:	macro
	move.w	#$00FF,d2			; clear tile
	jsr		fix_FillRegion
	endm

;==============================================================================;
; fix_CopyToRAM
; Copies Fix tilemap data from VRAM to 68K RAM.

; (Params)
; a?		[long] Starting 68K RAM location
; d?		[word] Starting combined cell location (x,y) or raw VRAM address ($7000-$74FF)
; d?		[word] Copy region size ($XXYY)

fix_CopyToRAM:
	; force MESS_OUT busy? (don't modify while we read)

	rts

;==============================================================================;
; fix_WriteFromRAM
; Writes Fix tilemap data from 68K RAM to VRAM.

; (Params)
; a?		[long] Starting 68K RAM location
; d?		[word] Starting combined cell location (x,y) or raw VRAM address ($7000-$74FF)
; d?		[word] Write region size ($XXYY)

fix_WriteFromRAM:
	; force MESS_OUT busy? (don't modify while we write)

	rts

;==============================================================================;
; fix_ClearAll
; Clears all tiles on the fix layer, including the leftmost and rightmost columns.
; Uses tile number $0FF, palette 0.

; (Clobbers)
; d7		Loop counter

fix_ClearAll:
	move.w	#$7000,LSPC_ADDR	; start at $7000 (end at $74FF)
	move.w	#1,LSPC_INCR		; VRAM increment +1
	move.w	#$4FF,d7			; loop counter (xxx: does it need to be $4FF-1?)

.fix_ClearAll_Loop:
	move.w	#$00FF,LSPC_DATA	; write blank tile (palette 0, tile $0FF)
	dbra	d7,.fix_ClearAll_Loop	;loop

	rts

; freemlib for Neo-Geo - Palette Functions
;==============================================================================;
; It should be noted that most of the functions in here modify the palette
; buffers, which are written to palette RAM every vblank/int1.

; [Effects?]
; * Fade In
; * Fade Out
; * Palette Cycling
; * Color Pulsing (0->1->0; repeat)
; * Color Ramping (0->1, then flatlines to 0; repeat)

;==============================================================================;
; palmac_PalBufIndex
; Internal macro for calculating the palette buffer index.

; (Params)
; d7				Palette Set, Palette Index ($SS0i; SS=$00-$FF, i=$0-$F)

palmac_PalBufIndex:	macro
	; d5 = (d7 & $FF00)>>3) (palette set number)
	move.w	d7,d5
	andi.w	#$FF00,d5			; d7 & $FF00
	lsr.w	#3,d5				; d7 >> 3

	; d4 = d7 & $0F (index inside of palette set)
	move.w	d7,d4
	andi.w	#$0F,d4
	add.w	d4,d5				; add palette set and palette index

	addi.l	#PaletteBuffer,d5	; add palette buffer location
	movea.l	d5,a0				; palette buffer location in a0

	endm

;==============================================================================;
; pal_LoadData
; Load raw color data into the palette RAM.

; (Params)
; d7				Number of color entries-1
; a0				Address to load palette data from
; a1				Beginning palette address to load data into ($400000-$401FFE)

pal_LoadData:
	move.w	(a0)+,(a1)+
	dbra	d7,pal_LoadData
	rts

; palmac_LoadData
; For extremely lazy people. \1 through \3 are the same params as pal_LoadData.

palmac_LoadData:	macro
	move.l	#\1,d7
	lea		\2,a0
	lea		\3,a1
	jsr		pal_LoadData
	endm

;==============================================================================;
; pal_LoadBuf
; Load raw color data into the palette buffer.

; d7				Number of color entries-1
; d6				Beginning buffer index to load data into ($0-$1FFE?)
; a0				Address to load palette data from

pal_LoadBuf:
	; todo: load data into PaletteBuffer
	;lea		PaletteBuffer+d6,a1
	rts

; palmac_LoadBuf
; For extremely lazy people. \1 through \3 are the same params as pal_LoadBuf.

palmac_LoadBuf:		macro
	move.l	#\1,d7
	move.w	#\2,d6
	lea		\3,a0
	jsr		pal_LoadBuf
	endm

;==============================================================================;
; pal_LoadSetBuf
; Load a single palette set (16 colors) into the palette buffer.

; (Params)
; d7				Palette set to load data into ($00-$FF)
; a0				Address to load palette data from

pal_LoadSetBuf:
	; calculate starting address in palette buffer
	lsl.w	#5,d7				; (d7<<5)
	addi.l	#PaletteBuffer,d7	; add palette buffer location
	movea.l	d7,a1

	; 2 colors x8 times = 16 colors
	move.l	(a0)+,(a1)+			; color indices $00 and $01
	move.l	(a0)+,(a1)+			; color indices $02 and $03
	move.l	(a0)+,(a1)+			; color indices $04 and $05
	move.l	(a0)+,(a1)+			; color indices $06 and $07
	move.l	(a0)+,(a1)+			; color indices $08 and $09
	move.l	(a0)+,(a1)+			; color indices $0A and $0B
	move.l	(a0)+,(a1)+			; color indices $0C and $0D
	move.l	(a0)+,(a1)+			; color indices $0E and $0F

	rts

;==============================================================================;
; pal_SetColor
; Set the value of a single color in the palette buffer.

; (Params)
; d7				Palette Set, Palette Index ($SS0i; SS=$00-$FF, i=$0-$F)
; d6				New color value

pal_SetColor:
	palmac_PalBufIndex			; get address in palette buffer
	move.w	d6,(a0)				; write new color value
	rts

;==============================================================================;
; pal_SoftShadow
; Halves the color values of the specified color in the palette buffer.

; (Params)
; d7				Palette Set, Palette Index ($SS0i; SS=$00-$FF, i=$0-$F)

pal_SoftShadow:
	palmac_PalBufIndex			; get address in palette buffer

	move.w	(a0),d6				; get current color value

	; separate components
	; multiply components (0.5)
	; re-combine components

	move.w	d6,(a0)				; update color value

	rts

;==============================================================================;
; pal_SoftBright
; Doubles the color values of the specified color in the palette buffer.

; (Params)
; d7				Palette Set, Palette Index ($SS0i; SS=$00-$FF, i=$0-$F)

pal_SoftBright:
	palmac_PalBufIndex			; get address in palette buffer

	move.w	(a0),d6				; get current color value

	; separate components
	; multiply components (1.5)
	; re-combine components

	move.w	d6,(a0)				; update color value

	rts

;==============================================================================;
; pal_SetSingleRed
; Modify the Red channel of the specified color in the palette buffer.

; (Params)
; d7				Palette Set, Palette Index ($SS0i; SS=$00-$FF, i=$0-$F)
; d6				New Red channel value (0011111d)

; Dr__RRRR________

pal_SetSingleRed:
	palmac_PalBufIndex			; get address in palette buffer

	move.w	(a0),d5				; get current color value

	; deconstruct passed Red channel value into palette Red
	; change Red

	move.w	d5,(a0)				; update color value

	rts

;==============================================================================;
; pal_SetSingleGreen
; Modify the Green channel of the specified color in the palette buffer.

; (Params)
; d7				Palette Set, Palette Index ($SS0i; SS=$00-$FF, i=$0-$F)
; d6				New Green channel value (0011111d)

; D_g_____GGGG____

pal_SetSingleGreen:
	palmac_PalBufIndex			; get address in palette buffer

	move.w	(a0),d5				; get current color value

	; deconstruct passed Green channel value into palette Green
	; change Green

	move.w	d5,(a0)				; update color value

	rts

;==============================================================================;
; pal_SetSingleBlue
; Modify the Blue channel of the specified color in the palette buffer.

; (Params)
; d7				Palette Set, Palette Index ($SS0i; SS=$00-$FF, i=$0-$F)
; d6				New Blue channel value (0011111d)

; D__b________BBBB

pal_SetSingleBlue:
	palmac_PalBufIndex			; get address in palette buffer

	move.w	(a0),d5				; get current color value

	; deconstruct passed Blue channel value into palette Blue
	; change Blue

	move.w	d5,(a0)				; update color value

	rts

; freemlib for Neo-Geo - Palette Functions
;==============================================================================;
; It should be noted that most of the functions in here modify the palette
; buffers, which are written to palette RAM every vblank/int1.

; * Palette Buffers

; [Effects?]
; * Fade In
; * Fade Out
; * Palette Cycling
; * Color Pulsing (0->1->0; repeat)
; * Color Ramping (0->1, then flatlines to 0; repeat)

;==============================================================================;
; pal_LoadData
; Load raw color data into the palette RAM.

; (Params)
; d7				Number of color entries
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

; d7				Number of color entries
; d6				Beginning buffer index to load data into ($0-$1FFE?)
; a0				Address to load palette data from

pal_LoadBuf:
	; todo: figure out where the palette buffer is being stored.
	rts

; palmac_LoadBuf
; For extremely lazy people. \1 through \3 are the same params as pal_LoadBuf.

palmac_LoadBuf:		macro
	move.l	#\1,d7
	lea		\2,a0
	lea		\3,a1
	jsr		pal_LoadBuf
	endm

;==============================================================================;
; pal_LoadSet
; Load a single palette set (16 colors) into the palette buffer.

; (Params)
; d7				Palette set to load data into ($00-$FF)
; a0				Address to load palette data from

pal_LoadSet:
	; calculate starting address in palette buffer

	;move.l	#16-1,d6			; 16 colors
.pal_LoadSetLoop:
	;
	;dbra	d6,.pal_LoadSetLoop

	rts

;==============================================================================;
; pal_SetColor
; Set the value of a single color in the palette buffer.

; (Params)
; d7				Palette Set, Palette Index ($SS0i; SS=$00-$FF, i=$0-$F)
; d6				New color value

pal_SetColor:
	rts

;==============================================================================;
; pal_SoftShadow
; Halves the color values of the specified color in the palette buffer.

; (Params)
; d7				Palette Set, Palette Index ($SS0i; SS=$00-$FF, i=$0-$F)

pal_SoftShadow:
	rts

;==============================================================================;
; pal_SoftBright
; Doubles the color values of the specified color in the palette buffer.

; (Params)
; d7				Palette Set, Palette Index ($SS0i; SS=$00-$FF, i=$0-$F)

pal_SoftBright:
	rts

;==============================================================================;
; pal_SetSingleRed
; Modify the Red channel of the specified color in the palette buffer.

; (Params)
; d7				Palette Set, Palette Index ($SS0i; SS=$00-$FF, i=$0-$F)
; d6				New Red channel value

pal_SetSingleRed:
	rts

;==============================================================================;
; pal_SetSingleGreen
; Modify the Green channel of the specified color in the palette buffer.

; (Params)
; d7				Palette Set, Palette Index ($SS0i; SS=$00-$FF, i=$0-$F)
; d6				New Green channel value

pal_SetSingleGreen:
	rts

;==============================================================================;
; pal_SetSingleBlue
; Modify the Blue channel of the specified color in the palette buffer.

; (Params)
; d7				Palette Set, Palette Index ($SS0i; SS=$00-$FF, i=$0-$F)
; d6				New Blue channel value

pal_SetSingleBlue:
	rts

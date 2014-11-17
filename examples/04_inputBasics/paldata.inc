; [Palette Data]

NUM_PALETTES	equ 2		; used in palette loading loop

paletteData:
	; Palette Set $00 (Fix/Spr) - Main text (White)
	dc.w	$8000			; reference color, must be $8000 black
	dc.w	$7FFF			; White
	dc.w	$0000			; normal Black
	dc.w	$7777			; 50% gray (10/10/10)
	dc.w	$8DDD			; (1c/1c/1c)-1	1 000 1110 1110 1110
	dc.w	$0666			; (0c/0c/0c)	0 000 0110 0110 0110
	dc.w	$0000
	dc.w	$0000
	dc.w	$0000
	dc.w	$0000
	dc.w	$0000
	dc.w	$0000
	dc.w	$0000
	dc.w	$0000
	dc.w	$0000
	dc.w	$0000

	; Palette Set $01 (Fix/Spr) - Headers (Teal/Green)
	dc.w	$0000			; transparent
	dc.w	$28FC			; (10/1f/18)	0 010 1000 1111 1100
	dc.w	$0000			; normal Black
	dc.w	$7777			; 50% gray (10/10/10)
	dc.w	$06EA			; (0c/1c/14)	0 000 0110 1110 1010
	dc.w	$0666			; (0c/0c/0c)	0 000 0110 0110 0110
	dc.w	$0000
	dc.w	$0000
	dc.w	$0000
	dc.w	$0000
	dc.w	$0000
	dc.w	$0000
	dc.w	$0000
	dc.w	$0000
	dc.w	$0000
	dc.w	$0000

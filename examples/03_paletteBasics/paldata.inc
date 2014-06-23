; [Palette Data]

NUM_PALETTES	equ 4		; used in palette loading loop

paletteData:
	; Palette Set $00 (Fix/Spr)
	dc.w	$8000			; reference color, must be $8000 black
	dc.w	$7FFF			; White
	dc.w	$0000			; normal Black
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
	dc.w	$0000
	dc.w	$0000
	dc.w	$0000
	;--------------------------------------------------------------------------;
	; Palette Set $01 (Fix/Spr): White (lowest bit unset)
	dc.w	$0000			; transparent color
	dc.w	$0FFF
	dc.w	$0EEE
	dc.w	$0DDD
	dc.w	$0CCC
	dc.w	$0BBB
	dc.w	$0AAA
	dc.w	$0999
	dc.w	$0888
	dc.w	$0777
	dc.w	$0666
	dc.w	$0555
	dc.w	$0444
	dc.w	$0333
	dc.w	$0222
	dc.w	$0111
	;--------------------------------------------------------------------------;
	; Palette Set $02 (Fix/Spr): Green (lowest bit set)
	dc.w	$0000			; transparent color
	dc.w	$20F0			; brightest green
	dc.w	$20E0
	dc.w	$20D0
	dc.w	$20C0
	dc.w	$20B0
	dc.w	$20A0
	dc.w	$2090
	dc.w	$2080
	dc.w	$2070
	dc.w	$2060
	dc.w	$2050
	dc.w	$2040
	dc.w	$2030
	dc.w	$2020
	dc.w	$2010			; darkest green
	;--------------------------------------------------------------------------;
	; Palette Set $03 (Fix/Spr): Green (lowest bit unset)
	dc.w	$0000			; transparent color
	dc.w	$00F0			; brightest green
	dc.w	$00E0
	dc.w	$00D0
	dc.w	$00C0
	dc.w	$00B0
	dc.w	$00A0
	dc.w	$0090
	dc.w	$0080
	dc.w	$0070
	dc.w	$0060
	dc.w	$0050
	dc.w	$0040
	dc.w	$0030
	dc.w	$0020
	dc.w	$0010			; darkest green

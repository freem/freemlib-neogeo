; Neo-Geo Cart Header
	dc.b	"NEO-GEO"
	dc.b	$00				; System Version (0=cart; 1/2 are used for CD games)

	dc.w	$0FFF			; NGH number ($0000 is prohibited)
	dc.l	$00080000		; game prog size in bytes
							; $00080000 =  4Mbits/512KB
							; $00100000 =  8Mbits/1MB
							; etc.
	dc.l	$00108000		; pointer to backup RAM block (first two bytes are debug dips)
	dc.w	$0000			; game save size in bytes

	dc.b	$00				; Eye catcher anim flag (0=BIOS,1=game,2=nothing)
	dc.b	$00				; Sprite bank for eyecatch if done by BIOS

	dc.l	softDips_Japan	; Software dips for Japan
	dc.l	softDips_USA	; Software dips for USA
	dc.l	softDips_Europe	; Software dips for Europe

	jmp		USER			; $122
	jmp		PLAYER_START	; $128
	jmp		DEMO_END		; $12E
	jmp		COIN_SOUND		; $134

	dc.l	$FFFFFFFF,$FFFFFFFF,$FFFFFFFF,$FFFFFFFF
	dc.l	$FFFFFFFF,$FFFFFFFF,$FFFFFFFF,$FFFFFFFF
	dc.l	$FFFFFFFF,$FFFFFFFF,$FFFFFFFF,$FFFFFFFF
	dc.l	$FFFFFFFF,$FFFFFFFF,$FFFFFFFF,$FFFFFFFF
	dc.l	$FFFFFFFF,$FFFFFFFF

	;org $00000182
	dc.l	TRAP_CODE		;pointer to TRAP_CODE

	; these next three are from Art of Fighting...
	;dc.l	0
	;dc.l	1
	;dc.l	softDips_Spain	; Software dips for Spain
	; not sure if they're official or what, though.

TRAP_CODE:
	dc.l	$76004A6D,$0A146600,$003C206D,$0A043E2D
	dc.l	$0A0813C0,$00300001,$32100C01,$00FF671A
	dc.l	$30280002,$B02D0ACE,$66103028,$0004B02D
	dc.l	$0ACF6606,$B22D0AD0,$67085088,$51CFFFD4
	dc.l	$36074E75,$206D0A04,$3E2D0A08,$3210E049
	dc.l	$0C0100FF,$671A3010,$B02D0ACE,$66123028
	dc.l	$0002E048,$B02D0ACF,$6606B22D,$0AD06708
	dc.l	$588851CF,$FFD83607
	dc.w	$4e75

	.include "softdips.inc"

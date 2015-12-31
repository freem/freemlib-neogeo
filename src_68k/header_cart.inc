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

	include "security.inc"
	include "softdips.inc"

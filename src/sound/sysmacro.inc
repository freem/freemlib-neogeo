; freemlib for Neo-Geo: Sound Driver System Macros
;==============================================================================;
; SetBank
; A macro for setting one of the Z80 banks.
; Params:
; \1			Bank number
; \2			Bank slot (8,9,0xA,0xB)

	macro	SetBank
	ld		a,#\1
	in		a,(\2)
	endm
;==============================================================================;

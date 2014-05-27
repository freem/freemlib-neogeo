; freemlib for Neo-Geo: Sound Driver System Macros
;==============================================================================;
; Shorthand macros for write_45 and write_67, using the rst opcodes.

	macro	write45
	rst		$18
	endm

	macro	write67
	rst		$20
	endm
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

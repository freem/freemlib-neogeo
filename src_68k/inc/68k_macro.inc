; freemlib for Neo-Geo - General 68000 Macros
;==============================================================================;
; push
; Push data to the stack.
push: macro
	movem.l \1,-(sp)
	endm

;==============================================================================;
; pop
; Pop data off the stack.

pop: macro
	movem.l (sp)+,\1
	endm

; Macros for MESS_OUT
; In case you want things to be a little more semantic...
;==============================================================================;
; messmac_Format (Command 1: Set Data Format)
; \1		flags (0=bytes+end code, 1=bytes+length, 2=word+end code, 3=word+length)
; \2		data (depends on what flags you set)

messmac_Format:		macro
	dc.w	((\1<<8)|($0001))
	dc.w	\2
	endm

;==============================================================================;
; messmac_SetIncr (Command 2: Set VRAM Increment)
; \1		New VRAM increment

messmac_SetIncr:	macro
	dc.w	((\1<<8)|($0002))
	endm

;==============================================================================;
; messmac_SetAddr (Command 3: Set VRAM Address)
; \1		New VRAM address

messmac_SetAddr:	macro
	dc.w	$0003
	dc.w	\1
	endm

;==============================================================================;
; messmac_OutPtr (Command 4: Pointer to data)
; \1		Pointer to Commands

messmac_OutPtr:		macro
	dc.w	$0004
	dc.l	\1
	endm

;==============================================================================;
; messmac_AddAddr (Command 5: Add to VRAM Address)
; \1		Value to add to VRAM address

messmac_AddAddr:	macro
	dc.w	$0005
	dc.w	\1
	endm

;==============================================================================;
; messmac_Continue (Command 6: Continue output)

messmac_Continue:	macro
	dc.w	$0006
	endm

;==============================================================================;
; messmac_OutData (Command 7: Direct output)

messmac_OutData:	macro
	dc.w	$0007
	endm

;==============================================================================;
; messmac_Out8x16 (Command 8: 8x16 output)
; \1		VRAM output upper byte

messmac_Out8x16:	macro
	dc.w	((\1<<8)|($0008))
	endm

;==============================================================================;
; messmac_Out8x16J (Command 9: 8x16 voiced Japanese text)
; \1		VRAM output upper byte

messmac_Out8x16J:	macro
	dc.w	((\1<<8)|($0009))
	endm

;==============================================================================;
; messmac_CallSub (Command A: Call sub-command list)
; \1		Pointer to command list (must end with command B)

messmac_CallSub:	macro
	dc.w	$000A
	dc.l	\1
	endm

;==============================================================================;
; messmac_EndSub (Command B: Return to calling command list)

messmac_EndSub:		macro
	dc.w	$000B
	endm

;==============================================================================;
; messmac_Repeat (Command C: Repeat output)
; \1		Times to repeat
; \2		Value to write

messmac_Repeat:		macro
	dc.w	((\1<<8)|($000C))
	dc.w	\2
	endm

;==============================================================================;
; messmac_RepIncr (Command D: Repeat and increment output)
; \1		Times to repeat and increment
; \2		Value to write (lower byte gets incremented)

messmac_RepIncr:	macro
	dc.w	((\1<<8)|($000D))
	dc.w	\2
	endm

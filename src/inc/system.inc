; freemlib for Neo-Geo - System Functions
;==============================================================================;
; Hardware Dipswitches (MVS-only)

; Read data from REG_DIPSW
;==============================================================================;
; Software Dipswitches

; Read data from BIOS_GAME_DIP

; macr_GetSoftDipNum
; Returns the setting of the specified dip switch number (0-15).
; \1			Soft DIP number to read

macr_GetSoftDipNum:	macro
	move.b	(BIOS_GAME_DIP)+\1,d0
	endm
;------------------------------------------------------------------------------;

;==============================================================================;
; Debug Dipswitches (address found in header; $10E)

;==============================================================================;
; Calendar (MVS-only)
; the various DATE_TIME elements.

; mvsCal_GetDayNum
; Get day number (1-366).
;------------------------------------------------------------------------------;

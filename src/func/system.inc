; freemlib for Neo-Geo - System Functions
;==============================================================================;
; Hardware Dipswitches (MVS-only)

; Read data from REG_DIPSW
;==============================================================================;
; Software Dipswitches
;------------------------------------------------------------------------------;
; macr_GetSoftDipNum
; Returns the setting of the specified dip switch number.
; \1			Soft DIP number to read (0-15)
; d0			Value of requested Soft DIP

macr_GetSoftDipNum:	macro
	move.b	BIOS_GAME_DIP+\1,d0
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

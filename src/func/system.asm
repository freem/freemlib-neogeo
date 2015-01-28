; freemlib for Neo-Geo - System Functions
;==============================================================================;
; Hardware Dipswitches (MVS-only)

; Read data from REG_DIPSW
;==============================================================================;
; Software Dipswitches
;------------------------------------------------------------------------------;
; macr_GetSoftDipNum
; Returns the setting of the specified soft dip switch number.
; Does not handle the two Time values (BIOS_GAMEDIP_TIME1, BIOS_GAMEDIP_TIME2)
; or the two Count values (BIOS_GAMEDIP_COUNT1, BIOS_GAMEDIP_COUNT2).

; (Params)
; \1			Soft DIP number to read (0-9)
; (Returns)
; d0			Value of requested Soft DIP

macr_GetSoftDipNum:	macro
	move.b	BIOS_GAMEDIP_01+\1,d0
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

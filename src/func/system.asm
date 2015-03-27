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
; Routines for handling the various DATE_TIME elements.
;------------------------------------------------------------------------------;
; mvsCal_GetDayNum
; Get day number (1-366).

; On CD systems, this routine short circuits because there is no calendar chip.

; On cart systems, the System Type value is checked to ensure we are on MVS.
; If we are not on MVS, the routine ends early.

; (Returns)
; d0			(word) Day number 1-366, or 0 if routine not run (e.g. home system)

; (Thrashes)
; d0			Used for return value

mvsCal_GetDayNum:
	moveq	#0,d0
	ifd TARGET_CD
		rts					; short circuit when building for CD systems
	else

	; check for MVS
	move.b	REG_STATUS_B,d0
	andi.b	#$80
	beq		.mvsCal_GetDayNum_end	; not MVS, skip this.

	; MVS mode, get the calendar values
	jsr		READ_CALENDAR

	; (rest of this routine is WIP)
	; Check for leap year

	; not divisible by 4: not leap year
	; if divisible by 4 and not divisible by 100: leap year
	; if divisible by 4 and 100, but not 400: not leap year
	; otherwise: leap year

.mvsCal_GetDayNum_end:
	rts
	endif

;------------------------------------------------------------------------------;

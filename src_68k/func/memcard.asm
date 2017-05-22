; freemlib for Neo-Geo - Memory Card Functions
;==============================================================================;
; Even though it says "Memory Card" above, these functions are also meant to
; work on the Neo-Geo CD's internal save memory.

; IMPORTANT NOTE: It's up to you to ensure the memory card is inserted on cart
; systems before issuing most of these commands.

; Developer note: Any "short" commands should be a macro. (Examples include
; enabling/disabling memcard write, getting single bytes/words...)
;==============================================================================;
; memCard_Inserted
; Check if the memory card is inserted. Always true on CD systems.

; (Outputs)
; d0     Card insertion status (0=no card, nonzero=card inserted)

memCard_Inserted:
	ifd	TARGET_CD
		moveq #1,d0 ; "card" always inserted on CD systems
	else
		move.b REG_STATUS_B,d0	; load REG_STATUS_B
		andi.b #$30,d0 ; mask for "card inserted"
		; "Card Inserted" bits are actually 0 when the card is inserted.
		eori.b #$30,d0 ; flip meaning of the card inserted bits
	endif

	rts

;==============================================================================;
; memCard_WriteProtected
; Check if the memory card is write protected.

; (Outputs)
; d0     Card Write Protect status (0=not protected, nonzero=write protected)

memCard_WriteProtected:	macro
	move.b REG_STATUS_B,d0 ; load REG_STATUS_B
	andi.b #$40,d0 ; mask for "write protected"
	endm

;==============================================================================;
; memCard_EnableWrite
; Enables writes to the memory card by poking CARD_ENABLE_1 and CARD_ENABLE_2.

memCard_EnableWrite: macro
	move.b d0,CARD_ENABLE_1
	move.b d0,CARD_ENABLE_2
	endm

;==============================================================================;
; memCard_DisableWrite
; Disables writes to the memory card by poking CARD_DISABLE_1 and CARD_DISABLE_2.

memCard_DisableWrite: macro
	move.b d0,CARD_DISABLE_2
	move.b d0,CARD_DISABLE_1
	endm

;==============================================================================;
; memCard_GetRegion
; Return the region of the machine that formatted the card.

; (Outputs)
; d0     Region (byte; 0=Japan, 1=USA, 2=Europe)

memCard_GetRegion: macro
	move.b MEMCARD_DATA+$30,d0
	endm

;==============================================================================;
; memCard_GetSize
; Returns the size of the memory card (as stored on the card itself).

; (Outputs)
; d0     Memory card size (word)

memCard_GetSize: macro
	move.w MEMCARD_DATA+$A,d0
	endm

;==============================================================================;


; freemlib for Neo-Geo - Memory Card Functions
;==============================================================================;
; Even though it says "Memory Card" above, these functions are also meant to
; work on the Neo-Geo CD's internal save memory.
;==============================================================================;
; memCard_Inserted
; Check if the memory card is inserted. Always true on CD systems.

; (Outputs)
; d0			Card insertion status (0=no card, nonzero=card inserted)

memCard_Inserted:
	ifd	TARGET_CD
		moveq	#1,d0			; "card" always inserted on CD systems
	else
		move.b	REG_STATUS_B,d0	; load REG_STATUS_B
		andi.b	#$30,d0			; mask for "card inserted"
		eor.i	#$30,d0			; flip meaning of the card inserted bits
	endif

	rts

;==============================================================================;
; memCard_WriteProtected
; Check if the memory card is write protected.

; (Outputs)
; d0			Card Write Protect status (0=not protected, 1=write protected)

memCard_WriteProtected:
	move.b	REG_STATUS_B,d0	; load REG_STATUS_B
	andi.b	#$40,d0			; mask for "write protected"
	rts

;==============================================================================;
; memCard_EnableWrite
; Enables writes to the memory card by poking CARD_ENABLE_1 and CARD_ENABLE_2.

memCard_EnableWrite:
	move.b	d0,CARD_ENABLE_1
	move.b	d0,CARD_ENABLE_2
	rts

;==============================================================================;
; memCard_DisableWrite
; Disables writes to the memory card by poking CARD_DISABLE_1 and CARD_DISABLE_2.

memCard_DisableWrite:
	move.b	d0,CARD_DISABLE_2
	move.b	d0,CARD_DISABLE_1
	rts

;==============================================================================;
; memCard_GetRegion
; Return the region of the machine that formatted the card.

; (Outputs)
; d0			Region (0=Japan, 1=USA, 2=Europe)

memCard_GetRegion:
	move.b	MEMCARD_DATA+$30,d0
	rts

;==============================================================================;
; memCard_GetSize
; Returns the size of the memory card (as stored on the card itself).

memCard_GetSize:
	rts

;==============================================================================;


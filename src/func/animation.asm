; freemlib for Neo-Geo - Animation Functions
;==============================================================================;
; Animation functions rely on the sprite functions, so be sure to include those.

; The high concept of an animation is a number of frames, with each frame played
; back at a certain speed. We bend this to include collision data as well,
; because video games.
;==============================================================================;
; (Animation Data)
; $00		(word) Primary ID/"Category"
; $02		(word) Secondary ID/"Action" or "State"
; $04		(byte) Tertiary ID
; $05		(byte) Number of Frames in Animation
; $06		(long) Pointer to first Animation Frame Data

;------------------------------------------------------------------------------;
; (Animation Frame Data)
; $00		(word) Number of frames to display frame (60 frames = 1 sec)
; $02		(long) Metasprite pointer for this frame
; $06		(word) Anchor Point X
; $08		(word) Anchor Point Y
; $0A		(long) Pointer to Collision Data (see doc/collision.txt)
; $0E		(long) Pointer to next displayed frame ($FFFFFFFF if none)

;==============================================================================;
; animmac_AnimData
; Store Animation Data in the binary.

animmac_AnimData:	macro
	dc.w	\1			; (word) Primary ID/"Category"
	dc.w	\2			; (word) Secondary ID/"Action" or "State"
	dc.b	\3			; (byte) Tertiary ID (leave 0 if not using)
	dc.b	\4			; (byte) Number of frames in Animation
	dc.l	\5			; (long) Pointer to first Animation Frame Data
	endm

;==============================================================================;
; animmac_AnimFrameData
; Store Animation Frame Data in the binary.

animmac_AnimFrameData:	macro
	dc.w	\1			; (word) Number of frames to display frame
	dc.l	\2			; (long) Metasprite Pointer for this frame
	dc.w	\3			; (word) Anchor Point X
	dc.w	\4			; (word) Anchor Point Y
	dc.l	\5			; (long) Pointer to Collision Data
	dc.l	\6			; (long) Pointer to next displayed frame
	endm
;==============================================================================;

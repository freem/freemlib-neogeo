; freemlib for Neo-Geo - Collision Functions
;==============================================================================;
; Collision data is tied to Animation data.
; There are two types of collision boxes, "normal" and "attack".
;==============================================================================;
; collmac_CollisionBoxData
; Writes Collision Box data into the binary.

; \1 Collision Type (word; 0=normal, 1=attack)
; \2 Box X1 (word; start)
; \3 Box Y1 (word; start)
; \4 Box X2 (word; end)
; \5 Box Y2 (word; end)

collmac_CollisionBoxData: macro
	dc.w (\1)&1
	dc.w \2
	dc.w \3
	dc.w \4
	dc.w \5
	endm
;==============================================================================;

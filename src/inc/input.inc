; freemlib for Neo-Geo - Input Functions
;==============================================================================;
; [Control Defines]

; (REG_P1CNT, REG_P2CNT)
INPUT_UP			equ $01
INPUT_DOWN			equ $02
INPUT_LEFT			equ $04
INPUT_RIGHT			equ $08
INPUT_A				equ $10
INPUT_B				equ $20
INPUT_C				equ $40
INPUT_D				equ $80

; (REG_STATUS_A)
INPUT_COIN1			equ $01
INPUT_COIN2			equ $02
INPUT_COIN3			equ $08
INPUT_COIN4			equ $10
INPUT_SERVICE		equ $04

; (REG_STATUS_B)
INPUT_START1		equ $01
INPUT_START2		equ $04
INPUT_SELECT1		equ $02
INPUT_SELECT2		equ $08

;==============================================================================;
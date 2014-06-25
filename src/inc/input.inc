; freemlib for Neo-Geo - Input Defines
;==============================================================================;
; [Control Defines]

; (REG_P1CNT, REG_P2CNT)
INPUT_UP				equ $01
INPUT_DOWN				equ $02
INPUT_LEFT				equ $04
INPUT_RIGHT				equ $08
INPUT_A					equ $10
INPUT_B					equ $20
INPUT_C					equ $40
INPUT_D					equ $80

; (REG_STATUS_A)
INPUT_COIN1				equ $01
INPUT_COIN2				equ $02
INPUT_COIN3				equ $08
INPUT_COIN4				equ $10
INPUT_SERVICE			equ $04

; (REG_STATUS_B)
INPUT_STATB_START1		equ $01
INPUT_STATB_SELECT1		equ $02
INPUT_STATB_START2		equ $04
INPUT_STATB_SELECT2		equ $08

; (BIOS_STATCURNT/BIOS_STATCHANGE, BIOS_STATCURNT_RAW/BIOS_STATCHANGE_RAW)
INPUT_STATC_START1		equ $01
INPUT_STATC_SELECT1		equ $02
INPUT_STATC_START2		equ $04
INPUT_STATC_SELECT2		equ $08
INPUT_STATC_START3		equ $10
INPUT_STATC_SELECT3		equ $20
INPUT_STATC_START4		equ $40
INPUT_STATC_SELECT4		equ $80

; todo: mahjong controller, trackball

;==============================================================================;
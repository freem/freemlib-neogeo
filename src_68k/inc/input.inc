; freemlib for Neo-Geo - Input Defines
;==============================================================================;
; [Control Defines]

; (REG_P1CNT, REG_P2CNT, BIOS_P*PREVIOUS, BIOS_P*CURRENT, etc.)
INPUT_UP    equ $01
INPUT_DOWN  equ $02
INPUT_LEFT  equ $04
INPUT_RIGHT equ $08

; bi-directional, "impossible" masks
INPUT_UD equ INPUT_UP|INPUT_DOWN
INPUT_LR equ INPUT_LEFT|INPUT_RIGHT

; diagonal direction masks
INPUT_UL equ INPUT_UP|INPUT_LEFT
INPUT_UR equ INPUT_UP|INPUT_RIGHT
INPUT_DL equ INPUT_DOWN|INPUT_LEFT
INPUT_DR equ INPUT_DOWN|INPUT_RIGHT

; all-direction mask
INPUT_UDLR equ INPUT_UP|INPUT_DOWN|INPUT_LEFT|INPUT_RIGHT

INPUT_A equ $10
INPUT_B equ $20
INPUT_C equ $40
INPUT_D equ $80

; two-button combos
INPUT_AB equ INPUT_A|INPUT_B
INPUT_AC equ INPUT_A|INPUT_C
INPUT_AD equ INPUT_A|INPUT_D
INPUT_BC equ INPUT_B|INPUT_C
INPUT_BD equ INPUT_B|INPUT_D
INPUT_CD equ INPUT_C|INPUT_D

; three-button combos
INPUT_ABC equ INPUT_A|INPUT_B|INPUT_C
INPUT_ABD equ INPUT_A|INPUT_B|INPUT_D
INPUT_ACD equ INPUT_A|INPUT_C|INPUT_D
INPUT_BCD equ INPUT_B|INPUT_C|INPUT_D

; all four buttons
INPUT_ABCD equ INPUT_A|INPUT_B|INPUT_C|INPUT_D

; bit numbers (for use with btst)
INBIT_UP    equ 0
INBIT_DOWN  equ 1
INBIT_LEFT  equ 2
INBIT_RIGHT equ 3
INBIT_A     equ 4
INBIT_B     equ 5
INBIT_C     equ 6
INBIT_D     equ 7

;------------------------------------------------------------------------------;
; (REG_STATUS_A)
INPUT_COIN1   equ $01
INPUT_COIN2   equ $02
INPUT_COIN3   equ $08
INPUT_COIN4   equ $10
INPUT_SERVICE equ $04

; bit numbers (for use with btst)
INBIT_COIN1   equ 0
INBIT_COIN2   equ 1
INBIT_SERVICE equ 2
INBIT_COIN3   equ 3
INBIT_COIN4   equ 4

;------------------------------------------------------------------------------;
; (REG_STATUS_B)
INPUT_STATB_START1  equ $01
INPUT_STATB_SELECT1 equ $02
INPUT_STATB_START2  equ $04
INPUT_STATB_SELECT2 equ $08

; bit numbers (for use with btst)
INBIT_STATB_START1  equ 0
INBIT_STATB_SELECT1 equ 1
INBIT_STATB_START2  equ 2
INBIT_STATB_SELECT2 equ 3

;------------------------------------------------------------------------------;
; (BIOS_STATCURNT/BIOS_STATCHANGE, BIOS_STATCURNT_RAW/BIOS_STATCHANGE_RAW)
INPUT_STATC_START1  equ $01
INPUT_STATC_SELECT1 equ $02
INPUT_STATC_START2  equ $04
INPUT_STATC_SELECT2 equ $08
INPUT_STATC_START3  equ $10
INPUT_STATC_SELECT3 equ $20
INPUT_STATC_START4  equ $40
INPUT_STATC_SELECT4 equ $80

; bit numbers (for use with btst)
INBIT_STATC_START1  equ 0
INBIT_STATC_SELECT1 equ 1
INBIT_STATC_START2  equ 2
INBIT_STATC_SELECT2 equ 3
INBIT_STATC_START3  equ 4
INBIT_STATC_SELECT3 equ 5
INBIT_STATC_START4  equ 6
INBIT_STATC_SELECT4 equ 7

;==============================================================================;
; "expanded" controller (Do any games use this?)
; INPUT_1/BIOS_P1* = Controller 1A
; INPUT_2/BIOS_P2* = Controller 1B
; INPUT_3/BIOS_P3* = Controller 2A
; INPUT_4/BIOS_P4* = Controller 2B

;==============================================================================;
; mahjong controller (WIP)

; INPUT_1/2 has raw mahjong data (?); INPUT_3/4 has active-edge mahjong data.
; Both use this table:
; of.| 7 6 5 4 3 2 1 0 | BIOS RAM equiv.
; ---+-----------------+-----------------+
; +1 | x G F E D C B A | BIOS_P*PREVIOUS
; +2 | x N M L K J I H | BIOS_P*CURRENT
; +3 | x x x R r k c P | BIOS_P*CHANGE

; R = Reach
; r = Ron
; k = Kan
; c = Chi
; P = Pong

; INPUT_5, INPUT_6 table:
; Mahjong | Normal
; --------+--------
;    A    |  d4/A
;    B    |  d5/B
;    C    |  d6/C
;    D    |  d7/D
;    E    |  d0/Up
;    F    |  d1/Down
;    G    |  d2/Left
;    H    |  d3/Right

;==============================================================================;
; todo: trackball

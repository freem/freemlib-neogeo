; normal RAM begins at $100000
RAMBEGIN			equ $100000

; USER RAM (begins at $100000)
USER_RAM			equ $100000

flag_VBlank			equ $100000
; variables for this example
curSprPalette		equ $100002	; (word) current sprite palette (0-3)
spriteX				equ $100004	; (word) current sprite X position
spriteY				equ $100006	; (word) current sprite Y position

; normal RAM begins at $100000
RAMBEGIN			equ $100000

; USER RAM (begins at $100000)
USER_RAM			equ $100000

;==============================================================================;
; [freemlib RAM usage]
; If you're not using the freemlib in your project, feel free to nuke this part.

; (Palettes)
PaletteBuffer		equ $100000	; transferred during vblank ($2000 bytes)

; (Sprites)

;==============================================================================;
; you'll want to add your own things to this, of course.

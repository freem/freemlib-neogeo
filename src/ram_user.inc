; normal RAM begins at $100000
RAMBEGIN			equ $100000

; USER RAM (begins at $100000)
USER_RAM			equ $100000

;==============================================================================;
; [freemlib RAM usage]
; If you're not using the freemlib in your project, feel free to nuke this part.

flag_VBlank			equ $100000	; (byte) vblank flag
flag_HBlank			equ $100001	; (byte) hblank flag

; <$101000-$10xxxx: Buffers>

; (Palettes)
PaletteBuffer		equ $101000	; transferred during VBlank ($2000 bytes)
PaletteActions		equ $103000	; Palette Action buffer ($400 bytes)

; (Sprites)
;BackgroundBuffer	equ $103400	; Background buffer (1280/$500 bytes)

;==============================================================================;
; you'll want to add your own things to this, of course.

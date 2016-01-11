; normal RAM begins at $100000
RAMBEGIN equ $100000

; USER RAM (begins at $100000)
USER_RAM equ $100000

;==============================================================================;
; [freemlib RAM usage]
; If you're not using the freemlib in your project, feel free to nuke this part.
; You really should have some sort of VBlank flag, though. And if you're using
; the VBlank/INT2/IRQ2/whatever, a flag for that as well.

flag_VBlank equ USER_RAM   ; (byte) vblank flag
flag_HBlank equ USER_RAM+1 ; (byte) hblank flag

; <$101000-$10xxxx: Buffers>

; (Palettes)
PaletteBuffer   equ $101000 ; transferred during VBlank ($2000 bytes)
PaletteActions  equ $103000 ; Palette Action buffer ($400 bytes)

; (Sprites)
;BackgroundBuffer equ $103400 ; Background buffer (1280/$500 bytes)

;==============================================================================;
; you'll want to add your own variables to this, of course.

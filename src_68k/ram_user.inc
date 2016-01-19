; Neo-Geo User RAM template
;==============================================================================;
; Note: This isn't using vlink; this will be replaced in the future.
;==============================================================================;
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

;==============================================================================;
; you'll want to add your own variables to this, of course.

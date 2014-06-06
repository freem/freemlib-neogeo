; normal RAM begins at $100000
RAMBEGIN			equ $100000

; USER RAM (begins at $100000)
USER_RAM			equ $100000

	org $100000
flag_VBlank			ds.b 1
; you'll want to add your own things to this, of course.
; however, we're not using anything else in this demo.

	even			; keep this line here.

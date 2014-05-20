; freemlib for Neo-Geo: Sound Driver (ROM)
; assemble with vasm z80 (oldstyle syntax)
;==============================================================================;
	include "sounddef.inc"
	include "sysmacro.inc"
;==============================================================================;
	org $0000
; $0000: Disable interrupts and jump to the real entry point
Start:
	di
	jp		EntryPoint
;------------------------------------------------------------------------------;
	org $0008
portWriteDelayPart1:
	jp		portWriteDelayPart2
;------------------------------------------------------------------------------;
	org $0010
portWriteDelayPart3:
	jp		portWriteDelayPart4
;------------------------------------------------------------------------------;
	org $0018
j_write45:
	jp		write_45
;------------------------------------------------------------------------------;
	org $0020
j_write67:
	jp		write_67
;------------------------------------------------------------------------------;
	;org $0028
;------------------------------------------------------------------------------;
	;org $0030
;------------------------------------------------------------------------------;
	org $0038
; the IRQ belongs here.
j_IRQ:
	di
	jp		IRQ
;------------------------------------------------------------------------------;
	org $0040
; driver signature; subject to change.
driverSig:
	ascii	"freemlib NG(ROM)SoundDriver v000"
;------------------------------------------------------------------------------;
	org $0066
; NMI
; Inter-processor communications.

NMI:
	; save registers
	push	af
	push	bc
	push	de
	push	hl

	in		a,(0)			; Ack. NMI, get command from Port 0 (68K)
	ld		b,a				; load value into b for comparisons

	; "Commands $01 and $03 are always expected to be implemented as they
	; are used by the BIOSes for initialization purposes." - NeoGeoDev Wiki
	cp		#1				; Command 1 (Slot Switch)
	jp		Z,doCmd01
	cp		#3				; Command 3 (Soft Reset)
	jp		Z,doCmd03

	or		a				; check if Command is 0
	jp		Z,endNMI		; exit if Command 0

	; do NMI crap/handle communication...
	ld		(curCommand),a	; update curCommand

	; I'm not fully sure what to do yet.

	out		(0xC),a			; write something to 68k
endNMI:
	; restore registers
	pop		hl
	pop		de
	pop		bc
	pop		af
	retn

;==============================================================================;
; IRQ
; Handle an interrupt request.

IRQ:
	; save registers
	push	af
	push	bc
	push	de
	push	hl
	push	ix
	push	iy

	; do the IRQ crap.

endIRQ:
	; restore registers
	pop		iy
	pop		ix
	pop		hl
	pop		de
	pop		bc
	pop		af

	; enable interrupts and return
	ei
	ret						; was "reti", see note below.

; note:
; "In an IRQ, RETI is only useful if you have something like a Z80 PIO to support
; daisy-chaining: queuing interrupts. The PIO can detect that the routine has
; ended by the opcode of RETI, and let another device generate an interrupt."

;==============================================================================;
; EntryPoint
; The entry point for the sound driver.

EntryPoint:
	ld		sp,#0xFFFC		; Set stack pointer ($FFFD-$FFFE is used for other purposes)
	im		1				; Set Interrupt Mode 1 (IRQ at $38)
	xor		a				; make value in A = 0

	; Clear $F800-$FFFF
	ld		(0xF800),a		; set $F800 = 0
	ld		hl,#0xF800		; 00 value is at $F800
	ld		de,#0xF801		; write sequence begins at $F801
	ld		bc,#0x7FF		; end at $FFFF
	ldir					; clear out memory

	; Initialize variables
	ld		(dataMode),a	; data mode = 0 (default)

	; Silence SSG, FM(, and ADPCM?)
	call	fm_Silence
	call	ssg_Silence

	; write 1 to port $C0 (what is the purpose?)
	ld		a,#1
	out		(0xC0),a

	; continue setting up the hardware, etc.

	; Reset timers ($27,$30 to ports 4 and 5)
	ld		de,#0x2730
	write45					; write to ports 4 and 5
	; Reset ADPCM-B ($10,$01 to ports 4 and 5)
	ld		de,#0x1001
	write45					; write to ports 4 and 5
	; Unmask ADPCM-A and B flag controls ($1C,$00 to ports 4 and 5)
	ld		de,#0x1C00
	write45					; write to ports 4 and 5

	; Initialize more variables

	; Set default program banks
	call	SetDefaultBanks

	; More Timers ($27,$3F to ports 4 and 5)
	ld		de,#0x273F
	write45					; write to ports 4 and 5

	; Enable NMIs
	ld		a,#1
	out		(8),a			; Write to Port 8 (Enable NMI)

;------------------------------------------------------------------------------;
; MainLoop
; The primary code handling the sound driver, or something.
; I have no idea.

MainLoop:
	; alright, now it's your turn to handle the buffer!!! fuck.

	jp		MainLoop

;==============================================================================;
; write_45
; Writes data (from registers de) to ports 4 and 5. (YM2610 A1 line=0)

write_45:
	push	af
	ld		a,d
	out		(4),a			; write to port 4 (address 1)
	rst		8				; Write delay 1 (17 cycles)
	ld		a,e
	out		(5),a			; write to port 5 (data 1)
	rst		0x10			; Write delay 2 (83 cycles)
	pop		af
	ret

;------------------------------------------------------------------------------;
; write_67
; Writes data (from registers de) to ports 6 and 7. (YM2610 A1 line=1)

write_67:
	push	af
	ld		a,d
	out		(6),a			; write to port 6 (address 2)
	rst		8				; Write delay 1 (17 cycles)
	ld		a,e
	out		(7),a			; write to port 7 (data 2)
	rst		0x10			; Write delay 2 (83 cycles)
	pop		af
	ret

;------------------------------------------------------------------------------;
; portWriteDelayPart2
; Part 2 of the write delay for ports. (burn 17 cycles on YM2610)

portWriteDelayPart2:
	ret

;------------------------------------------------------------------------------;
; portWriteDelayPart4
; Part 4 of the write delay for ports. (burn 83 cycles on YM2610)

portWriteDelayPart4:
	push	bc
	push	de
	push	hl
	pop		hl
	pop		de
	pop		bc
	ret

;==============================================================================;
; doCmd01
; Performs setup work for Command $01 (Slot Change).

doCmd01:
	ld		a,#0
	out		(0xC),a			; write to port 0xC (Respond to 68K)
	out		(0),a			; write to port 0 (Clear sound code)
	ld		sp,#0xFFFC		; set stack pointer

	; call Command 01
	ld		hl,#command_01
	push	hl
	retn

;==============================================================================;
; doCmd03
; Performs setup work for Command $03 (Soft Reset).

doCmd03:
	ld		a,#0
	out		(0xC),a			; write to port 0xC (Respond to 68K)
	out		(0),a			; write to port 0 (Clear sound code)
	ld		sp,#0xFFFC		; set stack pointer

	; call Command 03
	ld		hl,#command_03
	push	hl
	retn

;==============================================================================;
; SetDefaultBanks
; Sets the default program banks.

SetDefaultBanks:
	SetBank	0x1E,8			; Set $F000-$F7FF bank to bank $1E (30 * 2K)
	SetBank	0xE,9			; Set $E000-$EFFF bank to bank $0E (14 * 4K)
	SetBank	6,0xA			; Set $C000-$DFFF bank to bank $06 ( 6 * 8K)
	SetBank	2,0xB			; Set $8000-$BFFF bank to bank $02 ( 2 * 16K)
	ret

;==============================================================================;
; fm_Silence
; Silences FM channels.

fm_Silence:
	; todo: something about being able to write the address byte once and
	; then the data bytes in succession, since I read it in the datasheet.

	ld		de,#0x2801		; FM Channel 1
	write45					; write to ports 4 and 5
	ld		de,#0x2802		; FM Channel 2
	write45					; write to ports 4 and 5
	ld		de,#0x2805		; FM Channel 3
	write45					; write to ports 4 and 5
	ld		de,#0x2806		; FM Channel 4
	write45					; write to ports 4 and 5
	ret

; "However, if you're accessing the same address multiple times, you may write
; the address first and procceed to write the data register multiple times."
; - translated from YM2610 Application Manual, Section 9

fm_Silence2:
	push	af
	ld		a,#0x28
	out		(4),a			; write to port 4 (address 1)
	rst		8				; Write delay 1 (17 cycles)
	ld		a,#0x01
	out		(5),a			; write to port 5 (data 1)
	rst		0x10			; Write delay 2 (83 cycles)
	ld		a,#0x02
	out		(5),a			; write to port 5 (data 1)
	rst		0x10			; Write delay 2 (83 cycles)
	ld		a,#0x05
	out		(5),a			; write to port 5 (data 1)
	rst		0x10			; Write delay 2 (83 cycles)
	ld		a,#0x06
	out		(5),a			; write to port 5 (data 1)
	rst		0x10			; Write delay 2 (83 cycles)
	pop		af
	ret

;==============================================================================;
; ssg_Silence
; Silences SSG channels.

ssg_Silence:
	ld		de,#0x0800		; SSG Channel A Volume/Mode
	write45					; write to ports 4 and 5
	ld		de,#0x0900		; SSG Channel B Volume/Mode
	write45					; write to ports 4 and 5
	ld		de,#0x0A00		; SSG Channel C Volume/Mode
	write45					; write to ports 4 and 5
	ld		de,#0x070F		; Disable all SSG channels
	write45					; write to ports 4 and 5
	ret

;==============================================================================;
; temporary command holding cell.
; These will be moved as I figure out what to do later.

; command_01
; Handles a slot switch.

command_01:
	di
	xor		a
	out		(0xC),a			; Write to port 0xC (Reply to 68K)
	out		(0),a			; Reset sound code

	; ...do bank initialization, etc...
	call	SetDefaultBanks

	; shut the damn sounds up.

	; set up infinite loop in RAM
	ld		hl,#0xFFFD
	ld		(hl),#0xC3		; Set 0xFFFD = 0xC3 ($C3 is opcode for "jp")
	ld		(#0xFFFE),hl	; Set 0xFFFE = 0xFFFD (making "jp $FFFD")
	ld		a,#1
	out		(0xC),a			; Write to port 0xC (Reply to 68K)
	jp		#0xFFFD			; jump to infinite loop in RAM

;------------------------------------------------------------------------------;
; command_02
; Plays the eyecatch music. (Typically $5F)

;------------------------------------------------------------------------------;
; command_03
; Handles a soft reset.

command_03:
	di
	ld		a,#0
	out		(0xC),a			; Write to port 0xC (Reply to 68K)
	out		(0),a			; Reset sound code
	ld		sp,#0xFFFF
	jp		Start			; Go back to the top.

;==============================================================================;
; Play ADPCM-A sample

;==============================================================================;
; Play ADPCM-B sample

;==============================================================================;
; Instrument Library

;==============================================================================;
; ADPCM-A Sample Library

;------------------------------------------------------------------------------;
; ADPCM-B Sample Library

;==============================================================================;
; RAM defines at $F800-$FFFF
	include "soundram.inc"

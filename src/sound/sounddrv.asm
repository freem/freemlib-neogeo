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
; Port Delay Write for Addresses
portWriteDelayPart1:
	jp		portWriteDelayPart2
;------------------------------------------------------------------------------;
	org $0010
; Port Delay Write for Data
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
; Keep checking the busy flag in Status 0 until it's clear.
; Code from smkdan's example M1 driver (adpcma_demo2/sound_M1.asm)

CheckBusyFlag:
	in		a,(4)			; read Status 0
	add		a
	jr		c,CheckBusyFlag
	ret
;------------------------------------------------------------------------------;
	;org $0030
;------------------------------------------------------------------------------;
	org $0038
; the IRQ belongs here.
j_IRQ:
	di
	jp		IRQ
;==============================================================================;
	org $0040
; driver signature; subject to change.
driverSig:
	ascii	"freemlib NG(ROM)SoundDriver v000"
;==============================================================================;
	org $0066
; NMI
; Inter-processor communications.

; In this driver, the NMI gets the command from the 68K and interprets it.

NMI:
	; save registers
	push	af
	push	bc
	push	de
	push	hl

	in		a,(0)			; Acknowledge NMI, get command from 68K via Port 0
	ld		b,a				; load value into b for comparisons

	; "Commands $01 and $03 are always expected to be implemented as they
	; are used by the BIOSes for initialization purposes." - NeoGeoDev Wiki
	cp		#1				; Command 1 (Slot Switch)
	jp		Z,doCmd01
	cp		#3				; Command 3 (Soft Reset)
	jp		Z,doCmd03

	or		a				; check if Command is 0
	jp		Z,endNMI		; exit if Command 0

	; do NMI crap/handle communication... I'm not fully sure what to do yet.
	ld		(curCommand),a	; update curCommand
	call	HandleCommand

	out		(0xC),a			; write something to 68k in the meantime.
endNMI:
	; restore registers
	pop		hl
	pop		de
	pop		bc
	pop		af
	retn

;==============================================================================;
; IRQ (called from $0038)
; Handle an interrupt request.

; In this driver, the IRQ is used for keeping the music playing.
; At least, as far as I can tell. I'm no expert. :s

IRQ:
	; save registers
	push	af
	push	bc
	push	de
	push	hl
	push	ix
	push	iy

	; do the things you do in the IRQ.
	; IRQs in SNK drivers are pretty large. (SM1/BIOS, MAKOTO v3.0)

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
	ld		sp,0xFFFC		; Set stack pointer ($FFFD-$FFFE is used for other purposes)
	im		1				; Set Interrupt Mode 1 (IRQ at $38)
	xor		a				; make value in A = 0

	; Clear RAM at $F800-$FFFF
	ld		(0xF800),a		; set $F800 = 0
	ld		hl,0xF800		; 00 value is at $F800
	ld		de,0xF801		; write sequence begins at $F801
	ld		bc,0x7FF		; end at $FFFF
	ldir					; clear out memory

	; Initialize variables
	ld		(dataMode),a	; data mode = 0 (default)

	; Silence SSG, FM(, and ADPCM?)
	call	fm_Silence
	; "various writes to ports 4/5 and 6/7"
	call	ssg_Silence

	; write 1 to port $C0 (what is the purpose?)
	ld		a,1
	out		(0xC0),a

	; continue setting up the hardware, etc.

	ld		de,0x2730		; Reset Timer flags, Disable Timer IRQs
	write45					; write to ports 4 and 5
	ld		de,0x1001		; Reset ADPCM-B
	write45					; write to ports 4 and 5
	ld		de,0x1C00		; Unmask ADPCM-A and B flag controls
	write45					; write to ports 4 and 5

	; Initialize more variables

	call	SetDefaultBanks	; Set default program banks

; this section subject to further review
;{
	; set timer values??

	; Start Timers ($27,$3F to ports 4 and 5)
	ld		de,0x273F		; Reset Timer flags, Enable Timer IRQs, Load Timers
	write45					; write to ports 4 and 5

	; (ADPCM-A shared volume)
	ld		de,0x013F		; Set ADPCM-A volume to Maximum
	write67					; write to ports 6 and 7
;}

	; (Enable NMIs)
	ld		a,1
	out		(8),a			; Write to Port 8 (Enable NMI)

;------------------------------------------------------------------------------;
; MainLoop
; The code that handles the command buffer. I have no idea how it's gonna work yet.

MainLoop:
	; now it's your turn to handle the buffer!!! fuck.

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
; Part 2 of the write delay for ports (address port 2/2). (burn 17 cycles on YM2610)

portWriteDelayPart2:
	ret

;------------------------------------------------------------------------------;
; portWriteDelayPart4
; Part 4 of the write delay for ports (data port 2/2). (burn 83 cycles on YM2610)

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
	out		(0xC),a			; write 0 to port 0xC (Respond to 68K)
	out		(0),a			; write to port 0 (Clear sound code)
	ld		sp,0xFFFC		; set stack pointer

	; call Command 01
	ld		hl,#command_01
	push	hl
	retn

;==============================================================================;
; doCmd03
; Performs setup work for Command $03 (Soft Reset).

doCmd03:
	ld		a,0
	out		(0xC),a			; write 0 to port 0xC (Respond to 68K)
	out		(0),a			; write to port 0 (Clear sound code)
	ld		sp,0xFFFC		; set stack pointer

	; call Command 03
	ld		hl,#command_03
	push	hl
	retn

;==============================================================================;
; SetDefaultBanks
; Sets the default program banks. This setup treats the M1 ROM as linear space.

SetDefaultBanks:
	SetBank	0x1E,8			; Set $F000-$F7FF bank to bank $1E (30 *  2K)
	SetBank	0xE,9			; Set $E000-$EFFF bank to bank $0E (14 *  4K)
	SetBank	6,0xA			; Set $C000-$DFFF bank to bank $06 ( 6 *  8K)
	SetBank	2,0xB			; Set $8000-$BFFF bank to bank $02 ( 2 * 16K)
	ret

;==============================================================================;
; fm_Silence
; Silences FM channels.

; Normal version you find in a few Neo-Geo sound drivers:
fm_Silence:
	ld		de,0x2801		; FM Channel 1
	write45					; write to ports 4 and 5
	;----------------------------------------------;
	ld		de,0x2802		; FM Channel 2
	write45					; write to ports 4 and 5
	;----------------------------------------------;
	ld		de,0x2805		; FM Channel 3
	write45					; write to ports 4 and 5
	;----------------------------------------------;
	ld		de,0x2806		; FM Channel 4
	write45					; write to ports 4 and 5
	ret

; "However, if you're accessing the same address multiple times, you may write
; the address first and procceed to write the data register multiple times."
; - translated from YM2610 Application Manual, Section 9

fm_Silence2:
	push	af
	ld		a,0x28			; Slot and Key On/Off
	out		(4),a			; write to port 4 (address 1)
	rst		8				; Write delay 1 (17 cycles)
	;---------------------------------------------------;
	ld		a,0x01			; FM Channel 1
	out		(5),a			; write to port 5 (data 1)
	rst		0x10			; Write delay 2 (83 cycles)
	;---------------------------------------------------;
	ld		a,0x02			; FM Channel 2
	out		(5),a			; write to port 5 (data 1)
	rst		0x10			; Write delay 2 (83 cycles)
	;---------------------------------------------------;
	ld		a,0x05			; FM Channel 3
	out		(5),a			; write to port 5 (data 1)
	rst		0x10			; Write delay 2 (83 cycles)
	;---------------------------------------------------;
	ld		a,0x06			; FM Channel 4
	out		(5),a			; write to port 5 (data 1)
	rst		0x10			; Write delay 2 (83 cycles)
	pop		af
	ret

;==============================================================================;
; ssg_Silence
; Silences SSG channels.

ssg_Silence:
	ld		de,0x0800		; SSG Channel A Volume/Mode
	write45					; write to ports 4 and 5
	;-------------------------------------------------;
	ld		de,0x0900		; SSG Channel B Volume/Mode
	write45					; write to ports 4 and 5
	;-------------------------------------------------;
	ld		de,0x0A00		; SSG Channel C Volume/Mode
	write45					; write to ports 4 and 5
	;-------------------------------------------------;
	ld		de,0x073F		; Disable all SSG channels (Tone and Noise)
	write45					; write to ports 4 and 5
	ret

;==============================================================================;
; HandleCommand
; Handles any command that isn't already dealt with separately (e.g. $01, $03).

HandleCommand:
	ld		a,(curCommand)	; get current command

HandleCommand_end:
	ret

;------------------------------------------------------------------------------;
; Relevant command pointers go here
sysCmdPointers:
	

;==============================================================================;
; temporary system command holding cell.
; These will be moved as I figure out what to do later.

;------------------------------------------------------------------------------;
; command_00
; Dudley do-nothing.

command_00:
	ret

;------------------------------------------------------------------------------;
; command_01
; Handles a slot switch.

command_01:
	di
	xor		a
	out		(0xC),a			; Write 0 to port 0xC (Reply to 68K)
	out		(0),a			; Reset sound code

	call	SetDefaultBanks	; initialize banks to default config

	; (FM) turn off Left/Right, AM Sense and PM Sense
	ld		de,#0xB500		; $B500: turn off for channels 1/3
	write45
	write67
	ld		de,#0xB600		; $B600: turn off for channels 2/4
	write45
	write67

	; (ADPCM-A, ADPCM-B) Reset ADPCM channels
	ld		de,#0x00BF		; $00BF: ADPCM-A Dump=1, all channels=1
	write67
	ld		de,#0x1001		; $1001: ADPCM-B Reset=1
	write45

	; (ADPCM-A, ADPCM-B) Poke ADPCM channel flags (write 1, then 0)
	ld		de,#0x1CBF		; $1CBF: Reset flags for ADPCM-A 1-6 and ADPCM-B
	write45
	ld		de,#0x1C00		; $1C00: Enable flags for ADPCM-A 1-6 and ADPCM-B
	write45

	; silence FM channels
	ld		de,#0x2801		; FM channel 1 (1/4)
	write45
	ld		de,#0x2802		; FM channel 2 (2/4)
	write45
	ld		de,#0x2805		; FM channel 5 (3/4)
	write45
	ld		de,#0x2806		; FM channel 6 (4/4)
	write45

	; silence SSG channels
	ld		de,#0x800		;SSG Channel A
	write45
	ld		de,#0x900		;SSG Channel B
	write45
	ld		de,#0xA00		;SSG Channel C
	write45

	; set up infinite loop in RAM
	ld		hl,0xFFFD
	ld		(hl),0xC3		; Set 0xFFFD = 0xC3 ($C3 is opcode for "jp")
	ld		(0xFFFE),hl	; Set 0xFFFE = 0xFFFD (making "jp $FFFD")
	ld		a,1
	out		(0xC),a			; Write 1 to port 0xC (Reply to 68K)
	jp		0xFFFD			; jump to infinite loop in RAM

;------------------------------------------------------------------------------;
; command_02
; Plays the eyecatch music. (Typically music code $5F)

;------------------------------------------------------------------------------;
; command_03
; Handles a soft reset.

command_03:
	di
	ld		a,0
	out		(0xC),a			; Write to port 0xC (Reply to 68K)
	out		(0),a			; Reset sound code
	ld		sp,0xFFFF
	jp		Start			; Go back to the top.

;==============================================================================;
; Play ADPCM-A sample

; (Params)
; d				ADPCM-A Channel Number
; e				ADPCM-A Sample Number

play_ADPCM_A:
	; check Status 1 for channel end?

	; set channel volume and left/right output ($08-$0D on ports 6/7)
	; * default is full volume and both channels

	; start address/256 LSB ($10-$15 on ports 6/7)
	; start address/256 MSB ($18-$1D on ports 6/7)
	; end address/256 LSB ($20-$25 on ports 6/7)
	; end address/256 MSB ($28-$2D on ports 6/7)

	; tell hardware to play channel
	; * $00xx on ports 6/7

	ret

;==============================================================================;
; Play ADPCM-B sample

; (Params)
; d				ADPCM-B Sample Number

play_ADPCM_B:
	; Start/Repeat/Reset ($10 on ports 4/5)

	; Left/Right Output ($11 on ports 4/5)

	; start address/256 LSB ($12 on ports 4/5)
	; start address/256 MSB ($13 on ports 4/5)
	; end address/256 LSB ($14 on ports 4/5)
	; end address/256 MSB ($15 on ports 4/5)

	; Delta-N Sampling Rate LSB ($19 on ports 4/5)
	; Delta-N Sampling Rate MSB ($1A on ports 4/5)
	; Channel Volume ($1B on ports 4/5)

	; Start/Repeat/Reset ($10 on ports 4/5)
	; Flag Control ($1C on ports 4/5)

	ret

;==============================================================================;
; FM Frequency Table (Calculated from A440)

; F-Number = (144 * fnote * 2^20 / M) / 2^B-1

; . fnote: pronounciation frequency (in Hertz)
; . M: master clock (8MHz = 8*10^6 = 8000000)
; . B: block data (octave)

; for the imaginary E#/Fb:
; (144 * 339.43 * 1048576 / 8000000) / 8
; (6406.52673024) / 8 = 800.81584128

; for the imaginary B#/Cb:
; (144 * 507.74 * 1048576 / 8000000) / 8
; (9583.27160832) / 8 = 1197.90895104

freqTable_FM:
	word	0x0269			; C4		261.63Hz
	word	0x028E			; C#4/Db4	277.18Hz
	word	0x02B5			; D4		293.66Hz
	word	0x02DE			; D#4/Eb4	311.13Hz
	word	0x0309			; E4		329.63Hz
	;word	0x0320			; imaginary E#/Fb (339.43Hz)
	word	0x0338			; F4		349.23Hz
	word	0x0369			; F#4/Gb4	369.99Hz
	word	0x039D			; G4		392.00Hz
	word	0x03D3			; G#4/Ab4	415.30Hz
	word	0x040E			; A4		440.00Hz
	word	0x044B			; A#4/Bb4	466.16Hz
	word	0x048D			; B4		493.88Hz
	;word	0x04AE 			; imaginary B#/Cb (507.74Hz)

;==[begin to edit stuff below this line]======================================;
; Instrument Data
; * FM instruments
instruments_FM:
	; 29 bytes per instrument

; * SSG instruments
instruments_SSG:
	; 3 bytes per instrument

; * ADPCM-B instruments
instruments_PCMB:
	; 5 bytes per instrument

;==============================================================================;
; ADPCM-A Sample Data
; format: Start and End address/256 in Words.

samples_PCMA:
	;word	startaddr,endaddr

;------------------------------------------------------------------------------;
; ADPCM-B Sample Data
; format:
; 2 words - Start and End address/256
; 2 words - Delta-N sampling rates

samples_PCMB:
	;word	startaddr,endaddr,samprateL,samprateH

;==============================================================================;
; Sound Effects Library
library_Effects:
	; pointers to sound effect data

;==============================================================================;
; Music Library
library_Music:
	; pointers to music data

;==[ok you can stop editing now]===============================================;

;==============================================================================;
; RAM defines at $F800-$FFFF
	include "soundram.inc"
;==============================================================================;
; Anything after this point requires explicit bankswitching, I believe.

; freemlib for Neo-Geo: Sound Driver (ROM)
; assemble with vasm z80 (oldstyle syntax)
;==============================================================================;
; Defines for RST usage, in case the locations change later.
rst_PortDelay1	= $08
rst_PortDelay2	= $10
rst_Write45		= $18
rst_Write67		= $20
rst_BusyWait	= $28
;==============================================================================;
	include "sounddef.inc"
	include "sysmacro.inc"
;==============================================================================;
	org $0000
; $0000: Disable interrupts and jump to the real entry point
Start:
	di						; Disable interrupts (Z80)
	jp		EntryPoint
;==============================================================================;
	org $0008
; Port Delay Write for Addresses
portWriteDelayPart1:
	jp		portWriteDelayPart2
;==============================================================================;
	org $0010
; Port Delay Write for Data
portWriteDelayPart3:
	jp		portWriteDelayPart4
;==============================================================================;
	org $0018
j_write45:
	jp		write_45
;==============================================================================;
	org $0020
j_write67:
	jp		write_67
;==============================================================================;
	org $0028
; Keep checking the busy flag in Status 0 until it's clear.

; Code from smkdan's example M1 driver (adpcma_demo2/sound_M1.asm), where he
; uses this instead of portWriteDelayPart2 and portWriteDelayPart4.
; It's noted that "MAME doesn't care". The hardware does, however.

CheckBusyFlag:
	in		a,(YM_Status0) ; read Status 0 (busy flag in bit 7)
	add		a
	jr		C,CheckBusyFlag
	ret
;==============================================================================;
	;org $0030
;==============================================================================;
	org $0038
; the IRQ belongs here.
j_IRQ:
	di
	jp		IRQ
;==============================================================================;
	org $0040
; driver signature; subject to change.
driverSig:
	asc "freemlib "
	ifd TARGET_CD
		asc	"Neo-CD"
	else
		asc	"NG-ROM"
	endif

	asc	" SoundDriver v000"
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
	ld		b,a				; save command into b for later

	; "Commands $01 and $03 are always expected to be implemented as they
	; are used by the BIOSes for initialization purposes." - NeoGeoDev Wiki
	cp		1				; Command 1 (Slot Switch)
	jp		Z,doCmd01
	cp		3				; Command 3 (Soft Reset)
	jp		Z,doCmd03
	or		a				; check if Command is 0
	jp		Z,endNMI		; exit if Command 0

	; do NMI crap/handle communication... I'm not fully sure what to do yet.
	ld		(curCommand),a	; update curCommand
	call	HandleCommand

	; update previous command
	ld		a,(curCommand)
	ld		(prevCommand),a

	out		(0xC),a			; Reply to 68K with something.
	out		(0),a			; Write to port 0 (Clear sound code)
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
; At least, that's the goal. Not sure how feasible it really is.

; Some other engines use the IRQ to poll the two status ports (6 and 4).

; IRQs in SNK drivers (e.g. Mr.Pac, MAKOTO v3.0) are pretty large.
; I want to avoid that, if at all possible. However, it might not be...

IRQ:
	; save registers
	push	af
	push	bc
	push	de
	push	hl
	push	ix
	push	iy

	; update internal Status 1 register
	in		a, (YM_Status1)
	ld		(intStatus1),a

	; check status of ADPCM channels
	;bit 7 - ADPCM-B
	;bit 5 - ADPCM-A 6
	;bit 4 - ADPCM-A 5
	;bit 3 - ADPCM-A 4
	;bit 2 - ADPCM-A 3
	;bit 1 - ADPCM-A 2
	;bit 0 - ADPCM-A 1

	; update internal Status 0 register
	in		a, (YM_Status0)
	ld		(intStatus0),a

	; Check Timer B
	; Check Timer A

	; keep the music and sound effects going.

	; FM Channel 1 (curPos_FM1)
	; FM Channel 2 (curPos_FM2)
	; FM Channel 3 (curPos_FM3)
	; FM Channel 4 (curPos_FM4)
	; SSG Channel A (curPos_SSG_A)
	; SSG Channel B (curPos_SSG_B)
	; SSG Channel C (curPos_SSG_C)

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

	; Clear RAM at $F800-$FFFF
	xor		a				; make value in A = 0
	ld		(0xF800),a		; set $F800 = 0
	ld		hl,0xF800		; 00 value is at $F800
	ld		de,0xF801		; write sequence begins at $F801
	ld		bc,0x7FF		; end at $FFFF
	ldir					; clear out memory

	;-------------------------------------------;
	; Initialize variables (todo)

	;-------------------------------------------;
	; Silence SSG, FM(, and ADPCM?)
	call	ssg_Silence
	call	fm_Silence
	; "various writes to ports 4/5 and 6/7"

	;-------------------------------------------;
	; write 1 to port $C0 (what is the purpose?)
	ld		a,1
	out		(0xC0),a

	;-------------------------------------------;
	; continue setting up the hardware, etc.

	ld		de,FM_TimerMode<<8|0x30		; Reset Timer flags, Disable Timer IRQs
	write45					; write to ports 4 and 5
	ld		de,PCMB_Control<<8|1	; Reset ADPCM-B
	write45					; write to ports 4 and 5
	ld		de,PCMB_Flags<<8|0		; Unmask ADPCM-A and B flag controls
	write45					; write to ports 4 and 5

	;-------------------------------------------;
	; Initialize more variables

	call	SetDefaultBanks	; Set default program banks

; this section subject to further review
;{
	; set timer values??

	; Start Timers ($27,$3F to ports 4 and 5)
	ld		de,FM_TimerMode<<8|0x3F		; Reset Timer flags, Enable Timer IRQs, Load Timers
	write45					; write to ports 4 and 5

	; (ADPCM-A shared volume)
	ld		de,PCMA_MasterVol<<8|0x3F	; Set ADPCM-A volume to Maximum
	write67					; write to ports 6 and 7
;}

	; (Enable interrupts)
	ei						; Enable interrupts (Z80)

	; execution continues into the main loop.
;------------------------------------------------------------------------------;
; MainLoop
; The code that handles the command buffer. I have no idea how it's gonna work yet.

MainLoop:
	; handle the buffer...
	jp		MainLoop

;==============================================================================;
; write_45
; Writes data (from registers de) to ports 4 and 5. (YM2610 A1 line=0)

write_45:
	push	af
	ld		a,d
	out		(4),a			; write to port 4 (address 1)
	rst		rst_PortDelay1	; Write delay 1 (17 cycles)
	ld		a,e
	out		(5),a			; write to port 5 (data 1)
	rst		rst_PortDelay2	; Write delay 2 (83 cycles)
	pop		af
	ret

;------------------------------------------------------------------------------;
; write_67
; Writes data (from registers de) to ports 6 and 7. (YM2610 A1 line=1)

write_67:
	push	af
	ld		a,d
	out		(6),a			; write to port 6 (address 2)
	rst		rst_PortDelay1	; Write delay 1 (17 cycles)
	ld		a,e
	out		(7),a			; write to port 7 (data 2)
	rst		rst_PortDelay2	; Write delay 2 (83 cycles)
	pop		af
	ret

;------------------------------------------------------------------------------;
; portWriteDelayPart2
; Part 2 of the write delay for ports (address port 2/2).
; (burns 17 cycles on YM2610)

portWriteDelayPart2:
	ret

;------------------------------------------------------------------------------;
; portWriteDelayPart4
; Part 4 of the write delay for ports (data port 2/2).
; (burns 83 cycles on YM2610)

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
	ld		a,0
	out		(0xC),a			; write 0 to port 0xC (Respond to 68K)
	out		(0),a			; write to port 0 (Clear sound code)
	ld		sp,0xFFFC		; set stack pointer

	; call Command 01
	ld		hl,command_01
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
	ld		hl,command_03
	push	hl
	retn

;==============================================================================;
; SetDefaultBanks
; Sets the default program banks.
; This setup treats the M1 ROM as linear space. (no bankswitching needed)

SetDefaultBanks:
	SetBank	0x1E,8			; Set $F000-$F7FF bank to bank $1E (30 *  2K)
	SetBank	0xE,9			; Set $E000-$EFFF bank to bank $0E (14 *  4K)
	SetBank	6,0xA			; Set $C000-$DFFF bank to bank $06 ( 6 *  8K)
	SetBank	2,0xB			; Set $8000-$BFFF bank to bank $02 ( 2 * 16K)
	ret

;==============================================================================;
; fm_Silence
; Silences all FM channels.

; "If you're accessing the same address multiple times, you may write the
; address first and procceed to write the data register multiple times."
; - translated from YM2610 Application Manual, Section 9

; todo: switch out the ld commands on 0x02 and 0x06 for "inc a" instead?
; 7->4 cycles for each switch.

fm_Silence:
	push	af

	ld		a,FM_KeyOnOff	; Slot and Key On/Off
	out		(4),a			; write to port 4 (address 1)
	rst		8				; Write delay 1 (17 cycles)
	;---------------------------------------------------;
	ld		a,FM_Chan1		; FM Channel 1
	out		(5),a			; write to port 5 (data 1)
	rst		0x10			; Write delay 2 (83 cycles)
	;---------------------------------------------------;
	ld		a,FM_Chan2		; FM Channel 2
	out		(5),a			; write to port 5 (data 1)
	rst		0x10			; Write delay 2 (83 cycles)
	;---------------------------------------------------;
	ld		a,FM_Chan3		; FM Channel 3
	out		(5),a			; write to port 5 (data 1)
	rst		0x10			; Write delay 2 (83 cycles)
	;---------------------------------------------------;
	ld		a,FM_Chan4		; FM Channel 4
	out		(5),a			; write to port 5 (data 1)
	rst		0x10			; Write delay 2 (83 cycles)

	pop		af
	ret

;------------------------------------------------------------------------------;
; Normal version you find in a few Neo-Geo sound drivers ("the long way"),
; except that I've replaced the last three direct loads of de with modifications
; of e only. This saves 15 cycles.

; Saving cycles this way is silly compared to using the above routine (which
; only has one address write versus the four in this one), but if you feel you
; want to silence the FM channels in the typical fashion, why not try this
; version out?

; Loads in original: 40 cycles
; Loads in new ver.: 25 cycles

	if 0
fm_Silence2:
	ld		de,FM_KeyOnOff<<8|FM_Chan1		; FM Channel 1
	write45					; write to ports 4 and 5
	;----------------------------------------------;
	; FM Channel 2
	inc		e				; 4 cycles (de = 0x2802)
	;ld		de,0x2802		; (10 cycles)
	write45					; write to ports 4 and 5
	;----------------------------------------------;
	; FM Channel 3
	ld		e,FM_Chan3		; 7 cycles (de = 0x2805)
	;ld		de,0x2805		; (10 cycles)
	write45					; write to ports 4 and 5
	;----------------------------------------------;
	; FM Channel 4
	inc		e				; 4 cycles (de = 0x2806)
	;ld		de,0x2806		; (10 cycles)
	write45					; write to ports 4 and 5
	ret
	endif

;==============================================================================;
; ssg_Silence
; Silences all SSG channels.

ssg_Silence:
	ld		de,SSG_VolumeA<<8|0
	write45

	ld		de,SSG_VolumeB<<8|0
	write45

	ld		de,SSG_VolumeC<<8|0
	write45
	ret

;==============================================================================;
; pcma_Silence
; Silences all ADPCM-A channels.

pcma_Silence:
	ret

;==============================================================================;
; pcmb_Silence
; Silences the ADPCM-B channel.

pcmb_Silence:
	; Force ADPCM-B to stop synthesizing with a $1001 write (set Reset bit)
	ld		de,PCMB_Control<<8|1	; $1001: ADPCM-B Control 1: Reset bit = 1
	write45

	; Stop ADPCM-B output by clearing the Reset bit ($1000 write)
	dec		e					; $1000: ADPCM-B Control 1: All bits = 0
	write45

	ret

;==============================================================================;
; all of these are timer-related writes to ports 4/5:
;------------------------------------------------------------------------------;
; timer_SetAll
; Set all Timer flags (0x273F)

timer_SetAll:
	ld		de,FM_TimerMode<<8|0x3F
	write45
	ret

;------------------------------------------------------------------------------;
; timer_ClearAll
; Clear all Timer flags (0x2700)

timer_ClearAll:
	ld		de,FM_TimerMode<<8|0
	write45
	ret

;------------------------------------------------------------------------------;
; timer_LoadEnable_B
; Reset A/B flags, Load and Enable Timer B (0x273A)

timer_LoadEnable_B:
	ld		de,FM_TimerMode<<8|0x3A
	write45
	ret

;------------------------------------------------------------------------------;
; timer_LoadEnable_A
; Reset A/B flags, Load and Enable Timer A (0x2735)

timer_LoadEnable_A:
	ld		de,FM_TimerMode<<8|0x35
	write45
	ret

;------------------------------------------------------------------------------;
; timer_Reset_A
; Reset Timer A flag, Enable and Load Timers A/B (0x271F)

timer_Reset_A:
	ld		de,FM_TimerMode<<8|0x1F
	write45
	ret

;------------------------------------------------------------------------------;
; timer_Reset_B
; Reset Timer B flag, Enable and Load Timers A/B (0x272F)

timer_Reset_B:
	ld		de,FM_TimerMode<<8|0x2F
	write45
	ret

;==============================================================================;
; HandleCommand
; Handles any command that isn't already dealt with separately (e.g. $01, $03).

HandleCommand:
	ld		a,(curCommand)	; get current command
	ld		b,a				; save in b

	; check what the command falls under
	; in SNK drivers, this is done using a table of values that map between 0-5:
	; 0=unused, 1=system, 2=music, 3=pcm?, 4=pcm?, 5=SSG

	; in the freemlib driver, this might be handled differently, since games
	; might want to have different configurations.

	; However, commands $00-$1F are always reserved for system use.
	cp		0x20
	jp		C,HandleSystemCommand

	; commands $20-$FF are up to you, for now...

HandleCommand_end:
	ret

;------------------------------------------------------------------------------;
; HandleSystemCommand
; Handles a system command (IDs $00-$1F).

HandleSystemCommand:
	; use command as index into tbl_SysCmdPointers
	ld		e,a
	ld		d,0
	ld		hl,tbl_SysCmdPointers
	add		hl,de
	add		hl,de

	; get routine location and jump to it
	ld		e,(hl)
	inc		hl
	ld		d,(hl)
	push	de
	pop		hl
	jp		(hl)

;------------------------------------------------------------------------------;
; Table of system command routine pointers
; Commands marked with a * are required by the BIOS

tbl_SysCmdPointers:
	word	command_00		; $00 - nop/do nothing
	word	command_01		; $01* - Slot switch
	word	command_02		; $02* - Play eyecatch music
	word	command_03		; $03* - Soft Reset
	word	command_04		; $04 - Disable All (Music & Sounds)
	word	command_05		; $05 - Disable Music
	word	command_06		; $06 - Disable Sounds
	word	command_07		; $07 - Enable All (Music & Sounds)
	word	command_08		; $08 - Enable Music
	word	command_09		; $09 - Enable Sounds
	word	command_0A		; $0A - Silence SSG channels
	word	fm_Silence		; $0B - Silence FM channels
	word	command_0C		; $0C - Stop all ADPCM-A samples
	word	pcmb_Silence	; $0D - Stop current ADPCM-B sample
	word	command_0E		; $0E - (tempo-related)
	word	command_0F		; $0F - (tempo-related)
	word	command_10		; $10 - Fade Out (1 argument; fade speed)
	word	command_11		; $11 - Stop Fade In/Out
	word	command_12		; $12 - Fade In (1 argument; fade speed)
	word	command_00		; $13 - (currently unassigned)
	word	command_00		; $14 - (currently unassigned)
	word	command_00		; $15 - (currently unassigned)
	word	command_00		; $16 - (currently unassigned)
	word	command_00		; $17 - (currently unassigned)
	word	command_00		; $18 - (currently unassigned)
	word	command_00		; $19 - (currently unassigned)
	word	command_00		; $1A - (currently unassigned)
	word	command_00		; $1B - (currently unassigned)
	word	command_00		; $1C - (currently unassigned)
	word	command_00		; $1D - (currently unassigned)
	word	command_00		; $1E - (currently unassigned)
	word	command_00		; $1F - (currently unassigned)

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
	ld		de,FM1_LeftRightAMPM<<8|0	; $B500: turn off for channels 1/3
	write45
	write67
	ld		de,FM2_LeftRightAMPM<<8|0	; $B600: turn off for channels 2/4
	write45
	write67

	; (ADPCM-A, ADPCM-B) Reset ADPCM channels
	ld		de,PCMA_Control<<8|0xBF		; $00BF: ADPCM-A Dump=1, all channels=1
	write67
	ld		de,PCMB_Control<<8|1	; $1001: ADPCM-B Reset=1
	write45

	; (ADPCM-A, ADPCM-B) Poke ADPCM channel flags (write 1, then 0)
	ld		de,PCMB_Flags<<8|0xBF	; $1CBF: Reset flags for ADPCM-A 1-6 and ADPCM-B
	write45
	ld		de,PCMB_Flags<<8|0		; $1C00: Enable flags for ADPCM-A 1-6 and ADPCM-B
	write45

	; silence FM channels
	ld		de,FM_KeyOnOff<<8|1		; FM channel 1 (1/4)
	write45
	ld		de,FM_KeyOnOff<<8|2		; FM channel 2 (2/4)
	write45
	ld		de,FM_KeyOnOff<<8|5		; FM channel 5 (3/4)
	write45
	ld		de,FM_KeyOnOff<<8|6		; FM channel 6 (4/4)
	write45

	; silence SSG channels
	ld		de,SSG_VolumeA<<8|0		;SSG Channel A
	write45
	ld		de,SSG_VolumeB<<8|0		;SSG Channel B
	write45
	ld		de,SSG_VolumeC<<8|0		;SSG Channel C
	write45

	; set up infinite loop in RAM
	ld		hl,0xFFFD
	ld		(hl),0xC3		; Set 0xFFFD = 0xC3 ($C3 is opcode for "jp")
	ld		(0xFFFE),hl		; Set 0xFFFE = 0xFFFD (making "jp $FFFD")
	ld		a,1
	out		(0xC),a			; Write 1 to port 0xC (Reply to 68K)
	jp		0xFFFD			; jump to infinite loop in RAM

;------------------------------------------------------------------------------;
; command_02
; Plays the eyecatch music. (Typically music code $5F)

command_02:
	ret

;------------------------------------------------------------------------------;
; command_03
; Handles a soft reset.

command_03:
	di
	xor		a
	out		(0xC),a			; Write to port 0xC (Reply to 68K)
	out		(0),a			; Reset sound code
	ld		sp,0xFFFF		; Set stack pointer location

	; disable FM channels
	ld		d, 0xB5
	ld		e, 0			; $B500: Clear L/R output, AM Sense, PM Sense
	call	write_45		; (for channel 1)
	call	write_67		; (for channel 3)
	ld		d, 0xB6		; $B600: Clear L/R output, AM Sense, PM Sense
	call	write_45		; (for channel 2)
	call	write_67		; (for channel 4)

	jp		Start			; Go back to the top.

;------------------------------------------------------------------------------;
; command_04
; Disable All (Music & Sounds)

command_04:
	;(musicToggle)
	;(soundToggle)
	ret

;------------------------------------------------------------------------------;
; command_05
; Disable Music

command_05:
	;(musicToggle)
	ret

;------------------------------------------------------------------------------;
; command_06
; Disable Sounds

command_06:
	;(soundToggle)
	ret

;------------------------------------------------------------------------------;
; command_07
; Enable All (Music & Sounds)

command_07:
	;(musicToggle)
	;(soundToggle)
	ret

;------------------------------------------------------------------------------;
; command_08
; Enable Music

command_08:
	;(musicToggle)
	ret

;------------------------------------------------------------------------------;
; command_09
; Enable Sounds

command_09:
	;(soundToggle)
	ret

;------------------------------------------------------------------------------;
; command_0A
; Stop SSG playback

command_0A:
	; xxx: deal with typeToggle?
	; xxx: ssg toggle register uses active low (e.g. 0=on)
	;xor		a
	;ld		(ssgToggle),a

	call	ssg_Silence
	ret

;------------------------------------------------------------------------------;
; command_0C
; Stop all ADPCM-A samples

command_0C:
	ret

;------------------------------------------------------------------------------;
; command_0E
; tempo change 1/2??

command_0E:
	ret

;------------------------------------------------------------------------------;
; command_0F
; tempo change 2/2??

command_0F:
	ret

;------------------------------------------------------------------------------;
; command_10
; Fade out

command_10:
	ret

;------------------------------------------------------------------------------;
; command_11
; Cancel fade in/fade out

command_11:
	ret

;------------------------------------------------------------------------------;
; command_12
; Fade in

command_12:
	ret

;==============================================================================;
; play_ADPCM_A
; Play an ADPCM-A sample.

; (Params)
; d				ADPCM-A Channel Number
; e				ADPCM-A Sample Number

play_ADPCM_A:
	; check Status 1 for channel end?

	; set channel volume and left/right output ($08-$0D on ports 6/7)
	; * default is full volume and both channels

	; get the following values from samples_PCMA table:
	; start address/256 LSB ($10-$15 on ports 6/7)
	; start address/256 MSB ($18-$1D on ports 6/7)
	; end address/256 LSB ($20-$25 on ports 6/7)
	; end address/256 MSB ($28-$2D on ports 6/7)

	; tell hardware to play channel
	; * $00xx on ports 6/7

	ret

;==============================================================================;
; ADPCM-A Channel masks
tbl_ChanMasksPCMA:
	byte ADPCMA_CH1
	byte ADPCMA_CH2
	byte ADPCMA_CH3
	byte ADPCMA_CH4
	byte ADPCMA_CH5
	byte ADPCMA_CH6

;==============================================================================;
; play_ADPCM_B
; Play an ADPCM-B sample.

; (Params)
; d				ADPCM-B Sample Number

play_ADPCM_B:
	; $1C80		; Flag Control ($1C on ports 4/5)
	; $1C00		; Flag Control ($1C on ports 4/5)
	; $1000		; Start/Repeat/Reset ($10 on ports 4/5)
	; Left/Right Output ($11 on ports 4/5)

	; get the following values from samples_PCMB table:
	; start address/256 LSB ($12 on ports 4/5)
	; start address/256 MSB ($13 on ports 4/5)
	; end address/256 LSB ($14 on ports 4/5)
	; end address/256 MSB ($15 on ports 4/5)

	; get these values from rates_PCMB table:
	; Delta-N Sampling Rate LSB ($19 on ports 4/5)
	; Delta-N Sampling Rate MSB ($1A on ports 4/5)

	; Channel Volume ($1B on ports 4/5)

	; Start/Repeat/Reset ($10 on ports 4/5)

	ret

;==============================================================================;
; chanEnd_ADPCMA
; Handles an ADPCM-A channel ending.

; (Params)
; ?				ADPCM-A channel number

chanEnd_ADPCMA:
	ret

;==============================================================================;
; Driver tables
	include "freqtables.inc"	; FM and SSG frequency tables

;==[begin to edit stuff below this line]======================================;
	include "instruments.inc"	; Instrument Data
	include "samples.inc"		; ADPCM Sample Data

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

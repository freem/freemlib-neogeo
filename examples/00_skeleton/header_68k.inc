; 68000 Header (set up for cart development)
	; Note: You must modify the "$????????" sections for your game.
	dc.l	$0010F300		; Initial Supervisor Stack Pointer (SSP)
	dc.l	$00C00402		; Initial PC			(BIOS $C00402)
	dc.l	$00C00408		; Bus error/Monitor		(BIOS $C00408)
	dc.l	$00C0040E		; Address error			(BIOS $C0040E)
	dc.l	$00C00414		; Illegal Instruction	(BIOS $C00414)
	dc.l	$????????		; Divide by 0
	dc.l	$????????		; CHK Instruction
	dc.l	$????????		; TRAPV Instruction
	dc.l	$00C0041A		; Privilege Violation	(BIOS $C0041A)
	dc.l	$00C00420		; Trace					(BIOS $C00420)
	dc.l	$????????		; Line 1010 Emulator
	dc.l	$????????		; Line 1111 Emulator
	dc.l	$00C00426		; Reserved
	dc.l	$00C00426		; Reserved
	dc.l	$00C00426		; Reserved

	ifd		TARGET_CD
		dc.l	$00C00522		; Reserved
		dc.l	$00C00528		; Reserved
		dc.l	$00C0052E		; Reserved
		dc.l	$00C00534		; Reserved
		dc.l	$00C0053A		; Reserved
		dc.l	$00C004F2		; Reserved
		dc.l	$00C004EC		; Reserved
		dc.l	$00C004E6		; Reserved
		dc.l	$00C004E0		; Spurious Interrupt
	else
		dc.l	$00C00426		; Reserved
		dc.l	$00C00426		; Reserved
		dc.l	$00C00426		; Reserved
		dc.l	$00C00426		; Reserved
		dc.l	$00C00426		; Reserved
		dc.l	$00C00426		; Reserved
		dc.l	$00C00426		; Reserved
		dc.l	$00C00426		; Reserved
		dc.l	$00C00432		; Spurious Interrupt
	endif

; Interrupts
	ifd		TARGET_CD		; (Interrupt levels 1 and 2 are swapped on CD systems.)
		dc.l	IRQ2		; Level 2 interrupt (HBlank)
		dc.l	VBlank		; Level 1 interrupt (VBlank)
	else
		dc.l	VBlank		; Level 1 interrupt (VBlank)
		dc.l	IRQ2		; Level 2 interrupt (HBlank)
	endif

	dc.l	$????????		; Level 3 interrupt
	dc.l	$????????		; Level 4 interrupt
	dc.l	$????????		; Level 5 interrupt
	dc.l	$????????		; Level 6 interrupt
	dc.l	$????????		; Level 7 interrupt (NMI)

; Traps
	dc.l	$FFFFFFFF		; TRAP #0 Instruction
	dc.l	$FFFFFFFF		; TRAP #1 Instruction
	dc.l	$FFFFFFFF		; TRAP #2 Instruction
	dc.l	$FFFFFFFF		; TRAP #3 Instruction
	dc.l	$FFFFFFFF		; TRAP #4 Instruction
	dc.l	$FFFFFFFF		; TRAP #5 Instruction
	dc.l	$FFFFFFFF		; TRAP #6 Instruction
	dc.l	$FFFFFFFF		; TRAP #7 Instruction
	dc.l	$FFFFFFFF		; TRAP #8 Instruction
	dc.l	$FFFFFFFF		; TRAP #9 Instruction
	dc.l	$FFFFFFFF		; TRAP #10 Instruction
	dc.l	$FFFFFFFF		; TRAP #11 Instruction
	dc.l	$FFFFFFFF		; TRAP #12 Instruction
	dc.l	$FFFFFFFF		; TRAP #13 Instruction
	dc.l	$FFFFFFFF		; TRAP #14 Instruction
	dc.l	$FFFFFFFF		; TRAP #15 Instruction

	dc.l	$FFFFFFFF		; Reserved
	dc.l	$FFFFFFFF		; Reserved
	dc.l	$FFFFFFFF		; Reserved
	dc.l	$FFFFFFFF		; Reserved
	dc.l	$FFFFFFFF		; Reserved
	dc.l	$FFFFFFFF		; Reserved
	dc.l	$FFFFFFFF		; Reserved
	dc.l	$FFFFFFFF		; Reserved
	dc.l	$FFFFFFFF		; Reserved
	dc.l	$FFFFFFFF		; Reserved
	dc.l	$FFFFFFFF		; Reserved
	dc.l	$FFFFFFFF		; Reserved
	dc.l	$FFFFFFFF		; Reserved
	dc.l	$FFFFFFFF		; Reserved
	dc.l	$FFFFFFFF		; Reserved
	dc.l	$FFFFFFFF		; Reserved

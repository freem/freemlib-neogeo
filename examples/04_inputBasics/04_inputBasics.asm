; freemlib for Neo-Geo Example 04: Input Basics
;==============================================================================;
	; defines
	include "../../src/inc/neogeo.inc"
	include "../../src/inc/ram_bios.inc"
	include "../../src/inc/mess_macro.inc"
	include "ram_user.inc"
;------------------------------------------------------------------------------;
	; headers
	include "header_68k.inc"
	ifd TARGET_CD
		include "header_cd.inc"
	else
		include "header_cart.inc"
	endif
;==============================================================================;
; USER
; Needs to perform actions according to the value in BIOS_USER_REQUEST.
; Must jump back to SYSTEM_RETURN at the end so the BIOS can have control.

USER:
	move.b	d0,REG_DIPSW		; kick watchdog
	lea		BIOS_WORKRAM,sp		; set stack pointer to BIOS_WORKRAM
	move.w	#0,LSPC_MODE		; Disable auto-animation, timer interrupts, set auto-anim speed to 0 frames
	move.w	#7,LSPC_IRQ_ACK		; ack. all IRQs

	move.w	#$2000,sr			; Enable VBlank interrupt, go Supervisor

	; Handle user request
	clr.l	d0
	move.b	(BIOS_USER_REQUEST).l,d0
	lsl.b	#2,d0				; shift value left to get offset into table
	lea		cmds_USER_REQUEST,a0
	movea.l	(a0,d0),a0
	jsr		(a0)

;------------------------------------------------------------------------------;
; BIOS_USER_REQUEST commands
cmds_USER_REQUEST:
	dc.l	userReq_StartupInit	; Command 0 (Initialize)
	dc.l	userReq_Eyecatch	; Command 1 (Custom eyecatch)
	dc.l	userReq_Game		; Command 2 (Demo Game/Game)
	dc.l	userReq_Game		; Command 3 (Title Display)

;------------------------------------------------------------------------------;
; userReq_StartupInit
; Initialize the backup work area.

userReq_StartupInit:
	move.b	d0,REG_DIPSW		; kick watchdog
	jmp		SYSTEM_RETURN

;------------------------------------------------------------------------------;
; userReq_Eyecatch
; Only to be fully coded if your game uses its own eyecatch (value at $114 is 1).
; Otherwise, jmp to SYSTEM_RETURN.

userReq_Eyecatch:
	move.b	d0,REG_DIPSW		; kick watchdog
	jmp		SYSTEM_RETURN

;------------------------------------------------------------------------------;
; userReq_Game
; This is the complex one. You might want to have BIOS_USER_REQUEST commands 2
; and 3 do different things. I'm not really sure.

userReq_Game:
	move.b	d0,REG_DIPSW		; kick watchdog

	; perform your initialization

	; set up palettes
	move.b	d0,PALETTE_BANK1	; use palette bank 1
	lea		paletteData,a0
	lea		PALETTES,a1
	move.l	#(16*NUM_PALETTES)-1,d7
.ldpal:
	move.w	(a0)+,(a1)+
	dbra	d7,.ldpal

	jsr		FIX_CLEAR			; clear fix layer, add borders on sides
	jsr		LSP_1st				; clear first sprite

	jsr		InitDisplay

; execution continues into main loop.
;------------------------------------------------------------------------------;
; mainLoop
; The game's main loop. This is where you run the actual game part.
; For this demo, everything is happening in vblank... for the time being.

mainLoop:
	move.b	d0,REG_DIPSW		; kick the watchdog
	jsr		WaitVBlank			; wait for the vblank
	jmp		mainLoop

;==============================================================================;
; PLAYER_START
; Called by the BIOS if one of the Start buttons is pressed while the player
; has enough credits (or if the the time runs out on the title menu?).

PLAYER_START:
	move.b	d0,REG_DIPSW		; kick the watchdog
	rts

;==============================================================================;
; DEMO_END
; Called by the BIOS when the Select button is pressed; ends the demo early.

DEMO_END:
	; if necessary, store any items in the (MVS) backup RAM.
	rts

;==============================================================================;
; COIN_SOUND
; Called by the BIOS when a coin is inserted; should play a coin drop sound.

COIN_SOUND:
	; Send a sound code
	rts

;==============================================================================;
; VBlank
; VBlank interrupt, run things we want to do every frame.

VBlank:
	; check if the BIOS wants to run its vblank
	btst	#7,BIOS_SYSTEM_MODE
	bne		.gamevbl
	; run BIOS vblank
	jmp		SYSTEM_INT1

	; run the game's vblank
.gamevbl
	movem.l d0-d7/a0-a6,-(sp)	; save registers
	move.w	#4,LSPC_IRQ_ACK		; acknowledge the vblank interrupt
	move.b	d0,REG_DIPSW		; kick the watchdog

	; do things in vblank

.endvbl:
	; If you do not call SYSTEM_IO, you will have to read the input registers and
	; handle them yourself. That's probably not a good idea for a simple demo.
	jsr		SYSTEM_IO

	; right after handling SYSTEM_IO, store the new values in our mirrors
	jsr		UpdateIOMirrors

	; then prepare our display updates for MESS_OUT
	jsr		UpdateDisplay

	jsr		MESS_OUT			; write any messages to the fix layer
	move.b	#0,flag_VBlank		; clear vblank flag so waitVBlank knows to stop
	movem.l (sp)+,d0-d7/a0-a6	; restore registers
	rte

;==============================================================================;
; IRQ2
; Level 2/timer interrupt, unused here. You could use it for effects, though.

IRQ2:
	move.w	#2,LSPC_IRQ_ACK		; ack. interrupt #2 (HBlank)
	move.b	d0,REG_DIPSW		; kick watchdog

	rte

;==============================================================================;
; WaitVBlank
; Waits for VBlank to finish (via a flag cleared at the end).

WaitVBlank:
	move.b	#1,flag_VBlank

.waitLoop
	tst.b	flag_VBlank
	bne.s	.waitLoop

	rts

;==============================================================================;
; include freemlib function files
	include "../../src/func/fix.asm"
	include "../../src/inc/input.inc"

;==============================================================================;
; InitDisplay
; Writes the initial display to the screen.

; <Notable tiles on fix page $03>
; $10-$16,$17-$1A: border pieces (boxed then curved; ul,u,ur,l,bl,b,br;ul,ur,bl,br)
; $40: circle/button
; $5B-$5E: up, down, left, right
; Shift down by $20 (e.g. lowercase letters) for a darker palette
; Darker numbers at $80-$89

InitDisplay:
	bset.b	#0,BIOS_MESS_BUSY	; MESS_OUT busy
	movea.l	BIOS_MESS_POINT,a0	; get current message pointer

	move.l	#msg_Header,(a0)+
	move.l	#msg_LabelsP1,(a0)+
	move.l	#msg_LabelsP2,(a0)+
	move.l	#msg_LabelsSystem,(a0)+

	move.l	a0,BIOS_MESS_POINT	; Update pointer
	bclr.b	#0,BIOS_MESS_BUSY	; tell MESS_OUT it can run again
	rts

;------------------------------------------------------------------------------;
; "freemlib Example 4: Input Basics" (all uppercase due to palette)
msg_Header:
	messmac_Format	0,$03FF
	messmac_SetIncr	$20
	messmac_SetAddr	$7083
	messmac_OutData
	dc.b	"FREEMLIB EXAMPLE 4: INPUT BASICS",$FF,$00

; static labels
msg_LabelsP1:
	messmac_Format	0,$13FF
	messmac_SetAddr	$7045
	messmac_OutData
	dc.b	"PLAYER 1",$FF,$00
	messmac_Format	0,$03FF
	messmac_AddAddr	$01
	messmac_OutPtr	str_Status
	messmac_AddAddr	$01
	messmac_OutPtr	str_Previous
	messmac_AddAddr	$01
	messmac_OutPtr	str_Current
	messmac_AddAddr	$01
	messmac_OutPtr	str_Change
	messmac_AddAddr	$01
	messmac_OutPtr	str_Repeat
	messmac_AddAddr	$01
	messmac_OutPtr	str_Timer
	dc.w	$0000

msg_LabelsP2:
	messmac_Format	0,$13FF
	messmac_SetAddr	$704D
	messmac_OutData
	dc.b	"PLAYER 2",$FF,$00
	messmac_Format	0,$03FF
	messmac_AddAddr	$01
	messmac_OutPtr	str_Status
	messmac_AddAddr	$01
	messmac_OutPtr	str_Previous
	messmac_AddAddr	$01
	messmac_OutPtr	str_Current
	messmac_AddAddr	$01
	messmac_OutPtr	str_Change
	messmac_AddAddr	$01
	messmac_OutPtr	str_Repeat
	messmac_AddAddr	$01
	messmac_OutPtr	str_Timer
	dc.w	$0000

msg_LabelsSystem:
	messmac_Format	0,$13FF
	messmac_SetAddr	$7055
	messmac_OutData
	dc.b	"SYSTEM",$FF,$00
	messmac_Format	0,$03FF
	messmac_AddAddr	$01
	messmac_OutData
	dc.b	"STATUS A",$FF,$00
	messmac_AddAddr	$01
	messmac_OutData
	dc.b	"STAT CUR",$FF,$00
	messmac_AddAddr	$01
	messmac_OutData
	dc.b	"STAT CHA",$FF,$00
	messmac_AddAddr	$01
	messmac_OutData
	dc.b	"INPUT T1",$FF,$00
	messmac_AddAddr	$01
	messmac_OutData
	dc.b	"INPUT T2",$FF,$00
	dc.w	$0000

; Strings for you!

str_Status:		dc.b "STATUS",$FF,$FF
str_Previous:	dc.b "PREV.",$FF
str_Current:	dc.b "CURRENT",$FF
str_Change:		dc.b "CHANGE",$FF,$FF
str_Repeat:		dc.b "REPEAT",$FF,$FF
str_Timer:		dc.b "TIMER",$FF

; "Start" +1
; "Select" +2

; (MVS stuff)
; hardware dipswitches (REG_DIPSW)

; test button ($300081 mask $80)
;str_TestOn:	dc.b "TEST",$FFFF
;str_TestOff:	dc.b "test",$FFFF

;==============================================================================;
; UpdateIOMirrors
; Updates our I/O mirror values.

UpdateIOMirrors:
	move.b	d0,REG_DIPSW		; kick watchdog

	; update player 1
	move.b	BIOS_P1STATUS,p1_Status
	move.b	BIOS_P1PREVIOUS,p1_Previous
	move.b	BIOS_P1CURRENT,p1_Current
	move.b	BIOS_P1CHANGE,p1_Change
	move.b	BIOS_P1REPEAT,p1_Repeat
	move.b	BIOS_P1TIMER,p1_Timer

	move.b	d0,REG_DIPSW		; kick watchdog

	; update player 2
	move.b	BIOS_P2STATUS,p2_Status
	move.b	BIOS_P2PREVIOUS,p2_Previous
	move.b	BIOS_P2CURRENT,p2_Current
	move.b	BIOS_P2CHANGE,p2_Change
	move.b	BIOS_P2REPEAT,p2_Repeat
	move.b	BIOS_P2TIMER,p2_Timer

	; future expansion: player 3 and 4 (good luck fitting them on the screen)

	move.b	d0,REG_DIPSW		; kick watchdog

	; update stat current and change first, because they're on all systems
	move.b	BIOS_STATCURNT_RAW,sys_StatCurrent
	move.b	BIOS_STATCHANGE_RAW,sys_StatChange

	; update input TT1 and TT2
	move.b	BIOS_INPUT_TT1,sys_InputTT1
	move.b	BIOS_INPUT_TT2,sys_InputTT2
	move.b	REG_STATUS_A,sys_StatusA

	move.b	d0,REG_DIPSW		; kick watchdog

	; check if we're on a MVS system before bothering to update sys_Dipswitches
	btst.b	#7,REG_STATUS_B
	beq.b	UpdateIOMirrors_Home

	; MVS; update sys_Dipswitches
	move.b	REG_DIPSW,sys_Dipswitches
	bra.b	UpdateIOMirrors_end

UpdateIOMirrors_Home:
	; Home system; do nothing.
	moveq	#0,d0
	move.b	d0,sys_Dipswitches

UpdateIOMirrors_end:
	rts

;==============================================================================;
; UpdateDisplay
; Reads from our I/O mirrors and prepares a message for MESS_OUT.

UpdateDisplay:
	; check if BIOS_MESS_BUSY first.
	tst.b	BIOS_MESS_BUSY
	bne		UpdateDisplay_end

	; if not, we can do it!
	bset.b	#0,BIOS_MESS_BUSY	; MESS_OUT busy
	movea.l	BIOS_MESS_POINT,a0	; get current message pointer

	clr.l	(a0)+				; raw commands

	; Command 01: set format (data in bytes, using end code $FF; upper byte $03)
	move.l	#$000103FF,(a0)+
	; Command 02: set vram increment (+1)
	move.w	#$2002,(a0)+

	; system display
	jsr		UpdateSystemDisplay

	; Player 2 display
	moveq	#1,d0
	jsr		UpdatePlayerDisplay

	; Player 1 display
	moveq	#0,d0
	jsr		UpdatePlayerDisplay

	clr.l	(a0)+				; end commands

	move.l	a0,BIOS_MESS_POINT	; Update pointer
	bclr.b	#0,BIOS_MESS_BUSY	; tell MESS_OUT it can run again

UpdateDisplay_end:
	rts

;==============================================================================;
; UpdateSystemDisplay

UpdateSystemDisplay:
	; System display (VRAM $7176)
	move.l	#$00037176,(a0)+
	move.w	#$0007,(a0)+

	; Status A
	move.b	sys_StatusA,d1
	jsr		sub_ByteToHex
	move.w	d3,(a0)+
	move.w	#$ff00,(a0)+

	move.l	#$00050001,(a0)+
	move.w	#$0007,(a0)+

	; Stat Current (Sl4,St4,Sl3,St3,Sl2,St2,Sl1,St1)
	move.b	sys_StatCurrent,d1
	jsr		sub_ByteToHex
	move.w	d3,(a0)+
	move.w	#$ff00,(a0)+

	move.l	#$00050001,(a0)+
	move.w	#$0007,(a0)+

	; Stat Change (Sl4,St4,Sl3,St3,Sl2,St2,Sl1,St1)
	move.b	sys_StatChange,d1
	jsr		sub_ByteToHex
	move.w	d3,(a0)+
	move.w	#$ff00,(a0)+

	move.l	#$00050001,(a0)+
	move.w	#$0007,(a0)+

	; Input TT1
	move.b	sys_InputTT1,d1
	jsr		sub_ByteToHex
	move.w	d3,(a0)+
	move.w	#$ff00,(a0)+

	move.l	#$00050001,(a0)+
	move.w	#$0007,(a0)+

	; Input TT2
	move.b	sys_InputTT2,d1
	jsr		sub_ByteToHex
	move.w	d3,(a0)+
	move.w	#$ff00,(a0)+

	rts

;==============================================================================;
; tbl_PlayerDisplayVRAM - VRAM display locations
tbl_PlayerDisplayVRAM:
	dc.w	$7166				; P1
	dc.w	$716E				; P2

; tbl_PlayerBaseInputVars - Location of first input variables in RAM
tbl_PlayerBaseInputVars:
	dc.l	p1_Status
	dc.l	p2_Status

;------------------------------------------------------------------------------;
; UpdatePlayerDisplay
; Updates each of the displays for the specified player.
; (I'm lazy and don't feel like writing the same code twice.)

; (display order: Status, Previous, Current, Change, Repeat, Timer)

; display DCBArldu after numbers for Prev, Current, Change, Repeat

; Params:
; d0			Player Number (0=P1, 1=P2)

UpdatePlayerDisplay:
	moveq	#0,d2
	moveq	#0,d6

	move.b	d0,d6				; copy player index
	; get base input mirror variable from tbl_PlayerBaseInputVars
	lsl.b	#2,d6
	lea		tbl_PlayerBaseInputVars,a2
	move.l	0(a2,d6),a2

	; get vram location from tbl_PlayerBaseInputVars
	lsl.b	#1,d0				; get index into table
	lea		tbl_PlayerDisplayVRAM,a1
	move.w	0(a1,d0),d2

	move.w	#$0003,(a0)+
	move.w	d2,(a0)+

	move.w	#$0007,(a0)+

	; <Status>
	move.b	(a2)+,d1
	jsr		sub_ByteToHex
	move.w	d3,(a0)+
	move.w	#$ff00,(a0)+

	move.l	#$00050001,(a0)+
	move.w	#$0007,(a0)+

	; <Previous>
	move.b	(a2)+,d1
	jsr		sub_ByteToHex
	move.w	d3,(a0)+
	jsr		sub_DisplayInputMain	; draw DCBArldu
	move.w	#$ff00,(a0)+

	move.l	#$00050001,(a0)+
	move.w	#$0007,(a0)+

	; <Current>
	move.b	(a2)+,d1
	jsr		sub_ByteToHex
	move.w	d3,(a0)+
	jsr		sub_DisplayInputMain	; draw DCBArldu
	move.w	#$ff00,(a0)+

	move.l	#$00050001,(a0)+
	move.w	#$0007,(a0)+

	; <Change>
	move.b	(a2)+,d1
	jsr		sub_ByteToHex
	move.w	d3,(a0)+
	jsr		sub_DisplayInputMain	; draw DCBArldu
	move.w	#$ff00,(a0)+

	move.l	#$00050001,(a0)+
	move.w	#$0007,(a0)+

	; <Repeat>
	move.b	(a2)+,d1
	jsr		sub_ByteToHex
	move.w	d3,(a0)+
	jsr		sub_DisplayInputMain	; draw DCBArldu
	move.w	#$ff00,(a0)+

	move.l	#$00050001,(a0)+
	move.w	#$0007,(a0)+

	; <Timer>
	move.b	(a2)+,d1
	jsr		sub_ByteToHex
	move.w	d3,(a0)+
	move.w	#$ff00,(a0)+

	rts

;==============================================================================;
; sub_ByteToHex
; Converts a byte to a hex ASCII representation.
; Probably excessively long for what it needs to do.

; Params:
; d1			Byte to print

; Returns:
; d3			Word with hex ASCII representation

sub_ByteToHex:
	; clear previous d2 and d3
	moveq	#0,d2
	moveq	#0,d3

	move.b	d1,d2				; make copy
	andi.b	#$f0,d2				; mask top nibble
	lsr.b	#4,d2				; shift nibble right
	cmpi	#9,d2				; check for A-F
	bgt.b	.topAlpha			; branch if found

	; 0-9, start from $30
	move.b	d2,d3
	addi.b	#$30,d3
	bra.b	.checkLow

.topAlpha:
	; A-F, start from $37 because lazy
	moveq	#$37,d3
	add.b	d2,d3

.checkLow:
	lsl.w	#8,d3				; shift byte left x8 ($??xx is now $xx00, we can continue)

	move.b	d1,d2				; re-copy value
	andi.b	#$0f,d2				; mask bottom nibble
	cmpi.b	#9,d2				; check for A-F
	bgt.b	.botAlpha			; branch if found

	; 0-9, start from $30
	addi.b	#$30,d2
	add.b	d2,d3
	bra.b	sub_ByteToHex_end

.botAlpha:
	; A-F, start from $37 because lazy
	addi.b	#$37,d2
	add.b	d2,d3

sub_ByteToHex_end:
	rts

;==============================================================================;
; characters for me being lazy

; DCBArldu (on)
char_InputOn_D:			dc.b 'D'
char_InputOn_C:			dc.b 'C'
char_InputOn_B:			dc.b 'B'
char_InputOn_A:			dc.b 'A'
char_InputOn_Right:		dc.b $5E	; '^'
char_InputOn_Left:		dc.b $5D	; ']'
char_InputOn_Down:		dc.b $5C	; '\\'
char_InputOn_Up:		dc.b $5B	; '['

; DCBArldu (off)
char_InputOff_D:		dc.b 'd'
char_InputOff_C:		dc.b 'c'
char_InputOff_B:		dc.b 'b'
char_InputOff_A:		dc.b 'a'
char_InputOff_Right:	dc.b $7E	; '~'
char_InputOff_Left:		dc.b $7D	; '}'
char_InputOff_Down:		dc.b $7C	; '|'
char_InputOff_Up:		dc.b $7B	; '{'

;------------------------------------------------------------------------------;
; sub_DisplayInputMain
; Converts a byte for DCBArldu input display and adds it to the MESS_OUT buffer.

; Params:
; d1			Byte with input data

sub_DisplayInputMain:
	; space the inputs away from the numbers
	move.w	#"  ",(a0)+

	; check D (bit 7)
	move.b	char_InputOff_D,d2
	btst.b	#7,d1
	beq.b	.writeD

	; D is pressed
	move.b	char_InputOn_D,d2

.writeD:
	move.b	d2,(a0)+

	; check C (bit 6)
	move.b	char_InputOff_C,d2
	btst.b	#6,d1
	beq.b	.writeC

	; C is pressed
	move.b	char_InputOn_C,d2

.writeC:
	move.b	d2,(a0)+

	; check B (bit 5)
	move.b	char_InputOff_B,d2
	btst.b	#5,d1
	beq.b	.writeB

	; B is pressed
	move.b	char_InputOn_B,d2

.writeB:
	move.b	d2,(a0)+

	; check A (bit 4)
	move.b	char_InputOff_A,d2
	btst.b	#4,d1
	beq.b	.writeA

	; A is pressed
	move.b	char_InputOn_A,d2

.writeA:
	move.b	d2,(a0)+

	; check Right (bit 3)
	move.b	char_InputOff_Right,d2
	btst.b	#3,d1
	beq.b	.writeRight

	; Right is pressed
	move.b	char_InputOn_Right,d2

.writeRight:
	move.b	d2,(a0)+

	; check Left (bit 2)
	move.b	char_InputOff_Left,d2
	btst.b	#2,d1
	beq.b	.writeLeft

	; Left is pressed
	move.b	char_InputOn_Left,d2

.writeLeft:
	move.b	d2,(a0)+

	; check Down (bit 1)
	move.b	char_InputOff_Down,d2
	btst.b	#1,d1
	beq.b	.writeDown

	; Down is pressed
	move.b	char_InputOn_Down,d2

.writeDown:
	move.b	d2,(a0)+

	; check Up (bit 0)
	move.b	char_InputOff_Up,d2
	btst.b	#0,d1
	beq.b	.writeUp

	; Up is pressed
	move.b	char_InputOn_Up,d2

.writeUp:
	move.b	d2,(a0)+

sub_DisplayInputMain_end:
	rts

;==============================================================================;
; palette data
	include "paldata.inc"

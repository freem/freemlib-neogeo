; freemlib for Neo-Geo Example 03: Palette Basics
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
; This is the complex one. For this demo, we're only going to treat it as a
; combination of initialization and main loop, but for a real game, you might
; want to have BIOS_USER_REQUEST commands 2 and 3 do different things.

userReq_Game:
	move.b	d0,REG_DIPSW		; kick watchdog

	; perform your initialization

	; set up palettes
	move.b	d0,PALETTE_BANK0	; use palette bank 0
	lea		paletteData,a0
	lea		PALETTES,a1
	move.l	#(16*NUM_PALETTES)-1,d7
.ldpal:
	move.w	(a0)+,(a1)+
	dbra	d7,.ldpal

	jsr		FIX_CLEAR			; clear fix layer, add borders on sides
	jsr		LSP_1st				; clear first sprite

	jsr		CreateDisplay		; create initial display

; execution continues into main loop.
;------------------------------------------------------------------------------;
; mainLoop
; The game's main loop. This is where you run the actual game part.

mainLoop:
	move.b	d0,REG_DIPSW		; kick the watchdog

	; do things like:
	;jsr		CheckInput			; check inputs
	jsr		WaitVBlank			; wait for the vblank
	; and other things that would normally happen in a game's main loop.

	jmp		mainLoop

;==============================================================================;
; PLAYER_START
; Called by the BIOS if one of the Start buttons is pressed while the player
; has enough credits (or if the the time runs out on the title menu?).
; We're not using this in this demo.

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
; We don't actually do anything here since this isn't meant to take coins.

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
	movem.l d0-d7/a0-a6,-(a7)	; save registers
	move.w	#4,LSPC_IRQ_ACK		; acknowledge the vblank interrupt
	move.b	d0,REG_DIPSW		; kick the watchdog

	; do things in vblank

.endvbl:
	jsr		SYSTEM_IO			; "Call SYSTEM_IO every 1/60 second."
	jsr		MESS_OUT			; Puzzle Bobble calls MESS_OUT just after SYSTEM_IO
	move.b	#0,flag_VBlank		; clear vblank flag so waitVBlank knows to stop
	movem.l (a7)+,d0-d7/a0-a6	; restore registers
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
	include "../../src/func/palette.inc"
	include "../../src/func/sprites.inc"
	include "../../src/inc/input.inc"

;==============================================================================;
; CreateDisplay
; Creates the display for this demonstration.

CreateDisplay:
	; write "Palette Basics" text on fix layer
	bset.b	#0,BIOS_MESS_BUSY	; tell MESS_OUT we're busy messing with the data
	movea.l	BIOS_MESS_POINT,a0	; get current message pointer
	move.l	#string_PaletteBasics,(a0)+	; add fix layer text
	move.l	a0,BIOS_MESS_POINT  ; Update pointer
	bclr.b	#0,BIOS_MESS_BUSY	; tell MESS_OUT it can run again

	rts

string_PaletteBasics:
	messmac_Format	0,$00FF		; command 01: bytes+end code; top byte $00, end code $FF
	messmac_SetIncr	$20			; command 02: vram auto-increment $20 (horiz.)
	messmac_SetAddr	$7022		; command 03: set vram addr to $7022
	messmac_OutData
	dc.b	"Palette Basics",$FF,$00

;==============================================================================;
; CheckInput
; Checks for any inputs and handles them.

CheckInput:
	; We're only checking Player 1's inputs here.
	move.b	BIOS_P1CURRENT,d0	; Player 1 current input
	move.b	BIOS_P1CHANGE,d1	; Player 1 input change

	; do a check to see if any of the buttons we're handling have been pressed

;------------------------------------------------------------------------------;
CheckInput_End:
	rts

;==============================================================================;
	include "paldata.inc"		; Palette Data

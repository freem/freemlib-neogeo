; freemlib for Neo-Geo Example 01: Hello World on the Fix Layer
;==============================================================================;
	; defines
	include "../../src/inc/neogeo.inc"
	include "../../src/inc/ram_bios.inc"
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
	moveq	#0,d0
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
	move.b	d0,PALETTE_BANK1	; use palette bank 1
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
	; Check Input
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
	movem.l d0-d7/a0-a6,-(sp)	; save registers
	move.w	#4,LSPC_IRQ_ACK		; acknowledge the vblank interrupt
	move.b	d0,REG_DIPSW		; kick the watchdog

	; do things in vblank

.endvbl:
	jsr		SYSTEM_IO			; "Call SYSTEM_IO every 1/60 second."
	jsr		MESS_OUT			; Puzzle Bobble calls MESS_OUT just after SYSTEM_IO
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
; IRQ3
; Level 3 IRQ, unused here. Might be used for something else on CD, though.
; (More research needed)

IRQ3:
	move.w  #1,LSPC_IRQ_ACK		; acknowledge interrupt 3
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
; CreateDisplay
; Creates the display for this demonstration.

CreateDisplay:
	jsr		Display_Raw			; Use LSPC registers
	jsr		Display_MessOut		; Use MESS_OUT
	rts

;------------------------------------------------------------------------------;
; Display_Raw
; Writes tiles to the fix layer with the LSPC registers.

Display_Raw:
	; tell MESS_OUT we're busy messing with the data
	; this is more of a safeguard; your program should probably have a flag
	; called LSPC_BUSY (or GPU_BUSY, VRAM_BUSY, whatever...) that's used in
	; situations like this instead.
	bset.b	#0,BIOS_MESS_BUSY

	move.w	#$7024,LSPC_ADDR	; set vram address to $7024
	move.w	#$20,LSPC_INCR		; set auto-increment to $20 (horizontal writing)

	; write string data
	lea		string_HelloRaw,a0	; load address of string_HelloRaw in a0
	move.l	#29-1,d7			; string length-1

	; loop that writes characters to the LSPC_DATA register.
.dispRaw_Loop:
	clr.w	d2
	move.b	(a0)+,d2			; get byte from string_HelloRaw
	or.w	#$0000,d0			; set upper byte (palette 0, page 0)
	move.w	d2,LSPC_DATA		; write data to VRAM
	dbra	d7,.dispRaw_Loop

	bclr.b	#0,BIOS_MESS_BUSY	; tell MESS_OUT it can run again
	rts

string_HelloRaw:
	dc.b	"Hello World (via LSPC writes)"
	even						; used to align data automatically

;------------------------------------------------------------------------------;
; Display_MessOut
; Writes tiles to the fix layer using MESS_OUT.

Display_MessOut:
	bset.b	#0,BIOS_MESS_BUSY	; tell MESS_OUT we're busy messing with the data
	movea.l	BIOS_MESS_POINT,a0	; get current message pointer

	move.l	#0,(a0)+			; raw commands

	; command 01: data format
	move.w	#$0001,(a0)+		; data in bytes, uses end code.
	move.w	#$10FF,(a0)+		; upper byte=$10, end code=$FF

	; command 02: VRAM auto-increment
	move.w	#$2002,(a0)+		; (xx02; xx=number of bytes)

	; command 03: VRAM address ($7000-$74FF ...bankswitching?)
	move.w	#$0003,(a0)+
	move.w	#$7046,(a0)+		; VRAM address $7046

	; 8x8 text (via sub-command list)
	move.w	#$000A,(a0)+
	move.l	#string_HelloMess8,(a0)+

	; command 05: add to VRAM address
	move.w	#$0005,(a0)+
	move.w	#$0022,(a0)+

	; 8x16 text (via sub-command list)
	move.w	#$000A,(a0)+
	move.l	#string_HelloMess16,(a0)+

	; add to vram address again
	move.w	#$0005,(a0)+
	move.w	#$0022,(a0)+

	; Japanese text (via sub-command list)
	move.w	#$000A,(a0)+
	move.l	#string_HelloMessJP,(a0)+

	move.l	#0,(a0)+			; end commands

	move.l	a0,BIOS_MESS_POINT  ; Update pointer
	bclr.b	#0,BIOS_MESS_BUSY	; tell MESS_OUT it can run again
	rts

string_HelloMess8:
	dc.w	$0007				; command 07: direct output (used for 8x8 tiles)
	dc.b	"Hello World (8x8 MESS OUT)",$FF
	dc.b	$00					; pad byte
	dc.w	$000B				; return to command list

string_HelloMess16:
	dc.w	$2108				; command 08: 8x16 output
	dc.b	"Hello World (8x16 MESS OUT)",$FF
	dc.w	$000B				; return to command list

string_HelloMessJP:
	dc.w	$3109				; command 09: 8x16 output (Japanese)
	dc.b	$D9,$EA,$F9,$EB,$F9,$E8,$6E," (8X16 MESS OUT ",$95,$9D,$AD,$04,")",$FF,$00
	dc.w	$000B				; return to command list

;==============================================================================;
; [Palettes]
NUM_PALETTES	equ 4		; used in palette loading loop

paletteData:
	; Palette Set $00 (Fix/Spr)
	dc.w	$8000			; reference color, must be $8000 black
	dc.w	$7FFF			; White
	dc.w	$0000			; normal Black
	dc.w	$0000
	dc.w	$0000
	dc.w	$0000
	dc.w	$0000
	dc.w	$0000
	dc.w	$0000
	dc.w	$0000
	dc.w	$0000
	dc.w	$0000
	dc.w	$0000
	dc.w	$0000
	dc.w	$0000
	dc.w	$0000
	;--------------------------------------------------------------------------;
	; Palette Set $01 (Fix/Spr)
	dc.w	$0000			; transparent color
	dc.w	$0F00			; Red
	dc.w	$0000			; Black
	dc.w	$0000
	dc.w	$0000
	dc.w	$0000
	dc.w	$0000
	dc.w	$0000
	dc.w	$0000
	dc.w	$0000
	dc.w	$0000
	dc.w	$0000
	dc.w	$0000
	dc.w	$0000
	dc.w	$0000
	dc.w	$0000
	;--------------------------------------------------------------------------;
	; Palette Set $02 (Fix/Spr)
	dc.w	$0000			; transparent color
	dc.w	$00F0			; Green
	dc.w	$0000			; Black
	dc.w	$0000
	dc.w	$0000
	dc.w	$0000
	dc.w	$0000
	dc.w	$0000
	dc.w	$0000
	dc.w	$0000
	dc.w	$0000
	dc.w	$0000
	dc.w	$0000
	dc.w	$0000
	dc.w	$0000
	dc.w	$0000
	;--------------------------------------------------------------------------;
	; Palette Set $03 (Fix/Spr)
	dc.w	$0000			; transparent color
	dc.w	$000F			; Blue
	dc.w	$0000			; Black
	dc.w	$0000
	dc.w	$0000
	dc.w	$0000
	dc.w	$0000
	dc.w	$0000
	dc.w	$0000
	dc.w	$0000
	dc.w	$0000
	dc.w	$0000
	dc.w	$0000
	dc.w	$0000
	dc.w	$0000
	dc.w	$0000
;==============================================================================;
	include "ram_user.inc"

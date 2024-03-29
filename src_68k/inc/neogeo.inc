; Neo-Geo hardware definitions
;==============================================================================;
; todo: more Neo-Geo CD stuff

; [(mostly) common BIOS thunk calls]
BIOSROM				equ $C00000 ; BIOS ROM begins at $C00000
SYSTEM_RESET		equ $C00402 ; 
SYSTEM_INT1			equ $C00438 ; System VBlank
SYSTEM_INT2			equ $C0043E ; System Int2 (Cart systems only)
SYSTEM_RETURN		equ $C00444 ; Returns from the game to the BIOS
SYSTEM_IO			equ $C0044A ; Reads player inputs (and cabinet if MVS)
CREDIT_CHECK		equ $C00450 ; Check a player's number of credits
CREDIT_DOWN			equ $C00456 ; Deduct credits
READ_CALENDAR		equ $C0045C ; Read values from uPD4990 chip (MVS-only)
SETUP_CALENDAR		equ $C00462 ; Sets up uPD4990 chip (MVS-only)
SYS_CARD			equ $C00468 ; Memory Card commands
SYS_CARD_ERROR		equ $C0046E ; Handle card errors and display message
;SYSTEM_HOW_TO_PLAY	equ $C00474 ; display old-style how to play. uncomment if you want to use it.
;CALC_CHECKSUM		equ $C0047A ; calc a checksum and loop forever
FIX_CLEAR			equ $C004C2 ; Clear Fix layer
LSP_1st				equ $C004C8 ; Clear SCB2-4, first SCB1 tilemap
MESS_OUT			equ $C004CE ; Fix layer message output
CONTROLLER_SETUP	equ $C004D4 ; Initializes controllers

;------------------------------------------------------------------------------;
; [CD systems-only BIOS thunk calls]
BIOSF_HBLANK		equ $C004DA ; HBlank handler (replaces SYSTEM_INT2)
BIOSF_UPLOAD		equ $C00546 ; Upload data to DRAM
;$C0054C ? (CDZ)
BIOSF_LOADFILE		equ $C00552 ; Load file from CD, with animation
;$C00558 ? (CDZ)
BIOSF_CDPLAYER		equ $C0055E ; Reset to CD Player
BIOSF_LOADFILEX		equ $C00564 ; Load file from CD, no animation
BIOSF_CDDACMD		equ $C0056A ; Issue CDDA command
BIOSF_VIDEOEN		equ $C00570 ; Enable/Disable video layers

;==============================================================================;
; [I/O Regs]
; All I/O registers are bytes, apparently.

REG_P1CNT			equ $300000 ; Player 1 Controls (DCBArldu)/Trackball data [active low]
;76543210
;||||||||
;|||||||+--- Up
;||||||+---- Down
;|||||+----- Left
;||||+------ Right
;|||+------- A
;||+-------- B
;|+--------- C
;+---------- D

; Trackball data uses counter values for X and Y movement.
; The active direction depends on the value of REG_POUTPUT:
; - If REG_POUTPUT bit 0 is 0, this is the X counter value.
; - If REG_POUTPUT bit 0 is 1, this is the Y counter value.

REG_DIPSW			equ $300001 ; Read Hardware DIPs [active low], Kick watchdog (a.k.a. "WATCH_DOG")
; Hardware DIPs
; 7654 3210
; ||||_||||
; ||| | ||+--- Settings/Service Mode
; ||| | |+---- Number of coin chutes (0=1 chute, 1=2 chutes)
; ||| | +----- Controller Type (0=normal, 1=mahjong)
; ||| +------- Communication ID code (00,01,10,11)
; ||+--------- Multiplayer enable
; |+---------- Free Play
; +----------- Freeze

REG_SYSTYPE			equ $300081 ; Read a normally-unpopulated set of dip switches on MV4 boards.
; "Used for system ID on other boards", though said boards are unidentified?
; 76543210
; |||____|
; ||  |
; ||  +------ ?
; |+--------- Type value; MAME: "If ACTIVE_LOW, MVS-6 slot detected, when ACTIVE_HIGH MVS-1 slot (AES) detected"
; +---------- Test switch (IN01; active low)

REG_STATUS_A		equ $320001 ; uPD4990 bits, Coin switches [switches active low]
; 76543210
; ||||||||
; |||||||+--- Coin 1
; ||||||+---- Coin 2
; |||||+----- Service
; ||||+------ Coin 3
; |||+------- Coin 4
; ||+-------- (0 on 4slot, 1 on 6slot)
; |+--------- NEC D4990 (RTC) time pulse
; +---------- NEC D4990 (RTC) data bit

REG_P2CNT			equ $340000 ; Player 2 Controls (DCBArldu) [active low]
; 76543210
; ||||||||
; |||||||+--- Up
; ||||||+---- Down
; |||||+----- Left
; ||||+------ Right
; |||+------- A
; ||+-------- B
; |+--------- C
; +---------- D

REG_STATUS_B		equ $380000 ; Aux inputs (Start/Select, Memory Card...) [active low]
; 76543210
; ||||||||
; |||||||+--- Start P1
; ||||||+---- Select P1
; |||||+----- Start P2
; ||||+------ Select P2
; ||++------- Memory Card inserted if both are 0
; |+--------- Memory Card write protected
; +---------- System Type (0: AES/Home, 1: MVS)

; (Writes)

REG_POUTPUT			equ $380001 ; Joypad port outputs
; 76543210
; |||_||_|
; || |  |
; || |  +--- P1 joypad output bits 0-2
; || +------ P2 joypad output bits 0-2
; ++-------- ?

REG_SLOT			equ $380021 ; Slot Number (MVS)/REG_POUTPUT mirror (home)
; 76543210
; |___||_|
;   |   |
;   |   +--- Slot number
;   +------- ?

REG_LEDLATCHES		equ $380031 ; LED Latches (latched on 1->0/falling edge transition)
; 76543210
; ||||||||
; |||||+++--- ?
; ||||+------ Latch Marquee data
; |||+------- Latch LED1 data
; ||+-------- Latch LED2 data
; ++--------- ?

REG_LEDDATA			equ $380041 ; LED/Marquee Output Data

REG_RTCCTRL			equ $380051 ; Strobe/Clock/DIN for uPD4990
; 76543210
; ||||||||
; |||||||+--- RTC DIN
; ||||||+---- RTC Clock
; |||||+----- RTC Strobe
; +++++------ ?

REG_COIN1COUNT_HI	equ $380061 ; Chute 1 coin counter -> High; REG_RESETCC1
REG_COIN2COUNT_HI	equ $380063 ; Chute 2 coin counter -> High; REG_RESETCC2
REG_COIN1LOCK_HI	equ $380065 ; Chute 1 coin lockout -> High; REG_RESETCL1
REG_COIN2LOCK_HI	equ $380067 ; Chute 2 coin lockout -> High; REG_RESETCL2

REG_RTCWRITE		equ $3800D1 ; Write to RTC

REG_COIN1COUNT_LO	equ $3800E1 ; Chute 1 coin counter -> Low; REG_SETCC1
REG_COIN2COUNT_LO	equ $3800E3 ; Chute 2 coin counter -> Low; REG_SETCC2
REG_COIN1LOCK_LO	equ $3800E5 ; Chute 1 coin lockout -> Low; REG_SETCL1
REG_COIN2LOCK_LO	equ $3800E7 ; Chute 2 coin lockout -> Low; REG_SETCL2

;==============================================================================;
; [Sound Reg]
REG_SOUND			equ $320000 ; (Byte) Send command to Z80, Read Z80 reply

;==============================================================================;
; [System Regs]
; Byte writes only.

SYS_NOSHADOW		equ $3A0001 ; Normal output (a.k.a. "SHADOW_OFF","REG_NOSHADOW")
SYS_SHADOW			equ $3A0011 ; Darkened output (a.k.a. "SHADOW_ON","REG_SHADOW")
SYS_BIOSVEC			equ $3A0003 ; Use BIOS vectors (a.k.a. "SYSTEM_ROM","REG_SWPBIOS")
SYS_CARTVEC			equ $3A0013 ; Use Cart vectors (a.k.a. "USER_ROM","REG_SWPROM")
SYS_BIOSFIX			equ $3A000B ; Use BIOS Fix tiles
SYS_CARTFIX			equ $3A001B ; Use Cart Fix tiles
SYS_CDFIX			equ $3A001B ; Use CD Fix tiles (alias for other lazy people)

;==============================================================================;
; [MVS Backup RAM]
; Byte writes only.

SYS_MVSBRAM_LOCK	equ $3A000D ; Write-protect MVS-only Backup RAM
SYS_MVSBRAM_UNLOCK	equ $3A001D ; Unprotect MVS-only Backup-RAM

;==============================================================================;
; [Memory Card]
MEMCARD_DATA		equ $800000 ; Memory Card Data (a.k.a. "IC_MEMORY")
;-----------------------------------;
CARD_ENABLE_1		equ $3A0005 ; Enable card writes (w/CARD_ENABLE_2). (a.k.a. "REG_CRDUNLOCK1","IC_WRITE_EI1")
CARD_ENABLE_2		equ $3A0017 ; Enable card writes (w/CARD_ENABLE_1). (a.k.a. "REG_CRDUNLOCK2","IC_WRITE_EI2")
CARD_DISABLE_1		equ $3A0007 ; Disable card writes (w/CARD_DISABLE_2). (a.k.a. "REG_CRDLOCK1","IC_WRITE_DI1")
CARD_DISABLE_2		equ $3A0015 ; Disable card writes (w/CARD_DISABLE_1). (a.k.a. "REG_CRDLOCK2","IC_WRITE_DI2")
CARD_SELECT			equ $3A0009 ; Enable card register select
CARD_NORMAL			equ $3A0019 ; Disable card register select
CARD_BANK			equ $380011 ; Memory Card bank select

;==============================================================================;
; [LSPC Regs]
; Natively words. "Byte writes only work on odd addresses and store the same
; data in the MSB and LSB."

LSPC_ADDR			equ $3C0000 ; VRAM Address
LSPC_DATA			equ $3C0002 ; VRAM Data
LSPC_INCR			equ $3C0004 ; VRAM Increment

LSPC_MODE			equ $3C0006 ; LSPC Mode
; (Read)
; FEDCBA9876543210
; |_______|000||_|
;     |       | |
;     |       | +--- Auto-animation counter
;     |       +----- NTSC (0)/PAL (1), on LSPC2 only
;     +------------- Raster line counter

; (Write)
; FEDCBA9876543210
; |______|||||||_|
;     |   ||||| |
;     |   ||||| +--- Unused
;     |   ||||+----- Disable auto-animation
;     |   |||+------ Timer interrupt enable
;     |   ||+------- Reload counter when writing to LSPC_TIMER_LO
;     |   |+-------- Reload counter at beginning of hblank of the first vblank line (start of each frame)
;     |   +--------- Reload counter when it reaches 0
;     +------------- Auto-animation speed (in frames)

LSPC_TIMER_HI		equ $3C0008 ; Timer MSB/16 high bits
LSPC_TIMER_LO		equ $3C000A ; Timer LSB/16 low bits

LSPC_IRQ_ACK		equ $3C000C ; Interrupt acknowlege
; (Write)
; 76543210
; |___||||
;   |  ||+--- IRQ3
;   |  |+---- IRQ2/Timer/"HBlank"
;   |  +----- IRQ1/VBlank
;   +-------- Unused

LSPC_TIMER_STOP		equ $3C000E ; When bit 0 is set, Stop timer for 32 lines in PAL mode? (LSPC2 only, apparently)

;==============================================================================;
; [Palette]
; Palette data is in words. You can use longs to write two entries at once.

PALETTES			equ $400000 ; $400000-$401FFF
PALETTE_REFERENCE	equ $400000 ; Reference Color (must be $8000)
PALETTE_BACKDROP	equ $401FFE ; Backdrop Color
PALETTE_BANK1		equ $3A000F ; (byte) Palette bank 1 register
PALETTE_BANK0		equ $3A001F ; (byte) Palette bank 0 register

;==============================================================================;
; CD system-specific
UPLOAD				equ $E00000 ; Upload Zone ($E00000-$EFFFFF)

;------------------------------------------------------------------------------;
; Registers ($FF0002-$FF01FE)
;$FF0000	(word) 
;$FF0002	(word) "NeoRaine load_files, really interrupt mask?"
;$FF0004	(word) 
;$FF0006	(word) 
;$FF0008	(word) 
;$FF000A	(word) 
;$FF000D	(byte) 
;$FF000E	(byte) 
;$FF000F	(byte) NeoCDIRQUpdate(byte)
; $FF0010??
;$FF0011	(byte) 
; $FF0012??
; $FF0013??
; $FF0014??
;$FF0015	(byte) 
; $FF0016??
;$FF0017	(byte) "nNeoCDMode"
;.......

; DMA-related
;$FF0061	(byte) Writing with bit 6 set executes DMA microcode
; $FF0062??
; $FF0063??
;$FF0064-$FF0073	Registers used by microcode (NeoRaine upload_param) (todo: split out)
;$FF007E-$FF008F	Microcode (16x9bit instructions ?)

;$FF0101	(byte) "nLC8951Register (4 LSB)"
; $FF0102??		start cd transfer when 0xF0 according to mess
;$FF0103	(byte) "nLC8951Register value" (read 4x)
; $FF0104??
;$FF0105	(byte) nActiveTransferArea = byteValue ("area selector")
; $FF0106??
; $FF0107??
;$FF0108	(word)
; $FF010A??
;$FF010C	(word)
; $FF010E??

; $FF0110??
REG_DISABLESPR		equ $FF0111 ; (byte) Disable Sprite toggle (1=disable,0=enable)
REG_DISABLEFIX		equ $FF0115 ; (byte) Disable Fix toggle (1=disable,0=enable) 
REG_ENVIDEO			equ $FF0119 ; (byte) Video output toggle (1=enable,0=disable)

REG_CDCONFIG		equ $FF011C ; (byte) read config
; FEDCBA9876543210
; |||||__||______|
; ||||  |     |
; ||||  |     +----- unknown
; ||||  +----------- "Configuration Jumpers" (system region)
; |||+-------------- Lid Status ("opposite on CDZ")
; ||+--------------- CD Mechanism (0=top loader and CDZ, 1=front loader)
; ++---------------- 1

; these values are from the neo geo dev wiki; ng_aes.c has them off by 1...
; which one is right??
REG_UPMAPSPR		equ $FF0121 ; (byte) Set upload zone to SPR DRAM
REG_UPMAPPCM		equ $FF0123 ; (byte) Set upload zone to PCM DRAM
REG_UPMAPZ80		equ $FF0127 ; (byte) Set upload zone to Z80 DRAM
REG_UPMAPFIX		equ $FF0129 ; (byte) Set upload zone to FIX DRAM
REG_UPUNMAPSPR		equ $FF0141 ; (byte) Unset SPR DRAM upload zone
REG_UPUNMAPPCM		equ $FF0143 ; (byte) Unset PCM DRAM upload zone
REG_UPUNMAPZ80		equ $FF0147 ; (byte) Unset Z80 DRAM upload zone
REG_UPUNMAPFIX		equ $FF0149 ; (byte) Unset FIX DRAM upload zone

;$FF0161	(byte) NeoCDCommsRead Status FIFO 10 values (4 bits) 
;$FF0163	(byte) NeoCDCommsWrite(byteValue) Command FIFO 10 values (4 bits) 
;$FF0165	(byte) NeoCDCommsControl(byteValue & 1, byteValue & 2); (clock,send) 
;$FF0167	(byte)
;$FF016D	(byte) MapVectorTable(!(byteValue == 0xFF)); 

REG_DISABLEIRQ equ $FF016F ; (byte)
;$FF0181	(byte) Enable/Disable (reset) CD assembly
REG_ENABLEZ80  equ $FF0183 ; (byte) Z80 enable/disable(reset)

; https://wiki.neogeodev.org/index.php?title=Reading_CDDA_sound_levels
REG_CDDALEFTLEV   equ $FF0188 ; (word) Read CDDA sound level (Left channel)
REG_CDDARIGHTTLEV equ $FF018A ; (word) Read CDDA sound level (Right channel)

REG_UPBANK_SPR equ $FF01A1 ; (byte) Upload zone 1MB SPR DRAM bank selection
REG_UPBANK_PCM equ $FF01A3 ; (byte) Upload zone 512KB PCM DRAM bank selection

;$FF01A7	(byte)
;$FF01FC	(word)
;$FF01FE	(word)

;==============================================================================;
; VRAM address aliases
SCB1 equ $0000 ; VRAM, Sprite tilemaps
SCB2 equ $8000 ; VRAM, Sprite shrink ratios
SCB3 equ $8200 ; VRAM, Sprite Y positions and sizes
SCB4 equ $8400 ; VRAM, Sprite X positions

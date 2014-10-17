; Neo-Geo hardware definitions
;==============================================================================;
; todo: more Neo-Geo CD stuff

; [BIOS thunk calls]
BIOSROM				equ $C00000		; BIOS ROM begins at $C00000
SYSTEM_RESET		equ $C00402		; 
SYSTEM_INT1			equ $C00438		; System VBlank
SYSTEM_INT2			equ $C0043E		; System Int2 (Cart systems only)
SYSTEM_RETURN		equ $C00444		; Returns from the game to the BIOS
SYSTEM_IO			equ $C0044A		; Reads player inputs (and cabinet if MVS)
CREDIT_CHECK		equ $C00450		; Check a player's number of credits
CREDIT_DOWN			equ $C00456		; Deduct credits
READ_CALENDAR		equ $C0045C		; Read values from uPD4990 chip (MVS-only)
SETUP_CALENDAR		equ $C00462		; Sets up uPD4990 chip (MVS-only)
SYS_CARD			equ $C00468		; Memory Card commands
SYS_CARD_ERROR		equ $C0046E		; Handle card errors and display message
FIX_CLEAR			equ $C004C2		; Clear Fix layer
LSP_1st				equ $C004C8		; Clear SCB2-4, first SCB1 tilemap
MESS_OUT			equ $C004CE		; Fix layer message output
CONTROLLER_SETUP	equ $C004D4		; Initializes controllers

;------------------------------------------------------------------------------;
; [CD systems-only BIOS calls]
BIOSF_HBLANK		equ $C004DA		; HBlank handler
BIOSF_LOADFILE		equ $C00522		; Load file from CD, with animation
BIOSF_UPLOAD		equ $C00546		; Upload data to DRAM
;$C0054C ? (CDZ)
;$C00552 ? (CDZ)
;$C00558 ? (CDZ)
BIOSF_CDPLAYER		equ $C0055E		; Reset to CD Player
BIOSF_LOADFILEX		equ $C00564		; Load file from CD, no animation
BIOSF_CDDACMD		equ $C0056A		; Issue CDDA command
BIOSF_VIDEOEN		equ $C00570		; Enable/Disable video layers

;==============================================================================;
; [I/O Regs]
REG_P1CNT			equ $300000		; Player 1 Controls (DCBArldu)/Trackball data [active low]
REG_DIPSW			equ $300001		; Read Hardware DIPs [active low], Kick watchdog (a.k.a. "WATCH_DOG")
REG_STATUS_A		equ $320001		; uPD4990 bits, Coin switches [switches active low]
REG_P2CNT			equ $340000		; Player 2 Controls (DCBArldu) [active low]
REG_STATUS_B		equ $380000		; Aux inputs (Start/Select, Memory Card...) [active low]

; (Writes)
REG_POUTPUT			equ $380001		; Joypad port outputs
REG_SLOT			equ $380021		; Slot Number (MVS)/REG_POUTPUT mirror (home)
REG_LEDLATCHES		equ $380031		; LED Latches (latched on 1->0/falling edge transition)
REG_LEDDATA			equ $380041		; LED Output Data
REG_RTCCTRL			equ $380051		; Strobe/Clock/DIN for uPD4990
; currently not included:
;REG_?????			equ $380061		; Chute 1 coin lockout -> High
;REG_?????			equ $380063		; Chute 2 coin lockout -> High
;REG_?????			equ $380065		; Chute 1 coin counter -> High
;REG_?????			equ $380067		; Chute 2 coin counter -> High
;REG_?????			equ $3800D1		; Write to RTC
;REG_?????			equ $3800E1		; Chute 1 coin lockout -> Low
;REG_?????			equ $3800E3		; Chute 2 coin lockout -> Low
;REG_?????			equ $3800E5		; Chute 1 coin counter -> Low
;REG_?????			equ $3800E7		; Chute 2 coin counter -> Low

; [Sound Reg]
REG_SOUND			equ $320000		; (Byte) Send command to Z80, Read Z80 reply

; [System Regs]
SYS_NOSHADOW		equ $3A0001		; Normal output (a.k.a. "SHADOW_OFF","REG_NOSHADOW")
SYS_SHADOW			equ $3A0011		; Darkened output (a.k.a. "SHADOW_ON","REG_SHADOW")
SYS_BIOSVEC			equ $3A0003		; Use BIOS vectors (a.k.a. "SYSTEM_ROM","REG_SWPBIOS")
SYS_CARTVEC			equ $3A0013		; Use Cart vectors (a.k.a. "USER_ROM","REG_SWPROM")
SYS_BIOSFIX			equ $3A000B		; Use BIOS Fix tiles
SYS_CARTFIX			equ $3A001B		; Use Cart Fix tiles

; [MVS Backup RAM]
SYS_MVSBRAM_LOCK	equ $3A000D		; Write-protect MVS-only Backup RAM
SYS_MVSBRAM_UNLOCK	equ $3A001D		; Unprotect MVS-only Backup-RAM

; [Memory Card]
MEMCARD_DATA		equ $800000		; Memory Card Data (a.k.a. "IC_MEMORY")
;-----------------------------------;
CARD_ENABLE_1		equ $3A0005		; Enable card writes (w/CARD_ENABLE_2). (a.k.a. "REG_CRDUNLOCK1","IC_WRITE_EI1")
CARD_ENABLE_2		equ $3A0017		; Enable card writes (w/CARD_ENABLE_1). (a.k.a. "REG_CRDUNLOCK2","IC_WRITE_EI2")
CARD_DISABLE_1		equ $3A0007		; Disable card writes (w/CARD_DISABLE_2). (a.k.a. "REG_CRDLOCK1","IC_WRITE_DI1")
CARD_DISABLE_2		equ $3A0015		; Disable card writes (w/CARD_DISABLE_1). (a.k.a. "REG_CRDLOCK2","IC_WRITE_DI2")
CARD_SELECT			equ $3A0009		; Enable card register select
CARD_NORMAL			equ $3A0019		; Disable card register select
CARD_BANK			equ $380011		; Memory Card bank select

; [LSPC Regs]
LSPC_ADDR			equ $3C0000		; VRAM Address
LSPC_DATA			equ $3C0002		; VRAM Data
LSPC_INCR			equ $3C0004		; VRAM Increment
LSPC_MODE			equ $3C0006		; LSPC Mode
LSPC_TIMER_HI		equ $3C0008		; Timer MSB
LSPC_TIMER_LO		equ $3C000A		; Timer LSB
LSPC_IRQ_ACK		equ $3C000C		; Interrupt acknowlege
LSPC_TIMER_STOP		equ $3C000E		; Stop timer for 32 lines in PAL mode? (LSPC2 only, apparently)

; [Palette]
PALETTES			equ $400000		; $400000-$401FFF
PALETTE_REFERENCE	equ $400000		; Reference Color (must be $8000)
PALETTE_BACKDROP	equ $401FFE		; Backdrop Color
PALETTE_BANK1		equ $3A000F		; Palette bank 1 register
PALETTE_BANK0		equ $3A001F		; Palette bank 0 register

;------------------------------------------------------------------------------;
; CD system-specific
UPLOAD				equ $E00000		; Upload Zone ($E00000-$EFFFFF)

; Registers ($FF0002-$FF01FE)
;$FF0002	(word) "NeoRaine load_files, really interrupt mask?"
;$FF0004	(word) 
;$FF0006	(word) 
;$FF0008	(word) 
;$FF000A	(word) 
;$FF000E	(byte) 
;$FF000F	(byte) 
;$FF0011	(byte) 
;$FF0017	(byte) 
;$FF0061	(byte) 

;$FF0064-$FF0073	Registers used by microcode (NeoRaine upload_param)
;$FF007E-$FF008F	Microcode (16x9bit instructions ?)

;$FF0101	(byte)
;$FF0103	(byte)
;$FF0105	(byte)
;$FF0108	(word)
;$FF010C	(word)

REG_DISABLESPR		equ $FF0111		; (byte) Disable Sprite toggle (1=disable,0=enable)
REG_DISABLEFIX		equ $FF0115		; (byte) Disable Fix toggle (1=disable,0=enable) 
REG_ENVIDEO			equ $FF0119		; (byte) Video output toggle (1=enable,0=disable)
REG_CDCONFIG		equ $FF011C		; (byte) read config
REG_UPMAPSPR		equ $FF0121		; (byte) Set upload zone to SPR DRAM
REG_UPMAPPCM		equ $FF0123		; (byte) Set upload zone to PCM DRAM
REG_UPMAPZ80		equ $FF0127		; (byte) Set upload zone to Z80 DRAM
REG_UPMAPFIX		equ $FF0129		; (byte) Set upload zone to FIX DRAM
REG_UPUNMAPSPR		equ $FF0141		; (byte) Unset SPR DRAM upload zone
REG_UPUNMAPPCM		equ $FF0143		; (byte) Unset PCM DRAM upload zone
REG_UPUNMAPZ80		equ $FF0147		; (byte) Unset Z80 DRAM upload zone
REG_UPUNMAPFIX		equ $FF0149		; (byte) Unset FIX DRAM upload zone

;$FF0161
;$FF0163
;$FF0165
;$FF016D

REG_DISABLEIRQ		equ $FF016F		; (byte)
;$FF0181	(byte) Enable/Disable (reset) CD assembly
REG_ENABLEZ80		equ $FF0183		; (byte) Z80 enable/disable(reset)

; https://wiki.neogeodev.org/index.php?title=Reading_CDDA_sound_levels
REG_CDDALEFTLEV		equ $FF0188		; (word) Read CDDA sound level (Left channel)
REG_CDDARIGHTTLEV	equ $FF018A		; (word) Read CDDA sound level (Right channel)

REG_UPBANK_SPR		equ $FF01A1		; (byte) Upload zone 1MB SPR DRAM bank selection
REG_UPBANK_PCM		equ $FF01A3		; (byte) Upload zone 512KB PCM DRAM bank selection


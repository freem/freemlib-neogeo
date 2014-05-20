; Neo-Geo hardware definitions

; [BIOS thunk calls]
BIOSROM				equ $C00000		; BIOS ROM begins at $C00000
SYSTEM_RESET		equ $C00402
SYSTEM_INT1			equ $C00438
SYSTEM_RETURN		equ $C00444
SYSTEM_IO			equ $C0044A
CREDIT_CHECK		equ $C00450
CREDIT_DOWN			equ $C00456
READ_CALENDAR		equ $C0045C
SETUP_CALENDAR		equ $C00462
SYS_CARD			equ $C00468
SYS_CARD_ERROR		equ $C0046E
FIX_CLEAR			equ $C004C2
LSP_1st				equ $C004C8
MESS_OUT			equ $C004CE

; [I/O Regs]
REG_P1CNT			equ $300000		; Player 1 Controls (DCBArldu)/Trackball data [active low]
REG_DIPSW			equ $300001		; Read Hardware DIPs [active low], Kick watchdog (a.k.a. "WATCH_DOG")
REG_STATUS_A		equ $320001
REG_P2CNT			equ $340000		; Player 2 Controls (DCBArldu) [active low]
REG_STATUS_B		equ $380000
REG_POUTPUT			equ $380001
REG_SLOT			equ $380021
REG_LEDLATCHES		equ $380031
REG_LEDDATA			equ $380041
REG_RTCCTRL			equ $380051

; [Sound Reg]
REG_SOUND			equ $320000		; (Byte) Send command to Z80, Read Z80 reply

; [System Regs]
SYS_NOSHADOW		equ $3A0001		; Normal output (a.k.a. "SHADOW_OFF","REG_NOSHADOW")
SYS_SHADOW			equ $3A0011		; Darkened output (a.k.a. "SHADOW_ON","REG_SHADOW")
SYS_BIOSVEC			equ $3A0003		; Use BIOS vectors (a.k.a. "SYSTEM_ROM","REG_SWPBIOS")
SYS_CARTVEC			equ $3A0013		; Use Cart vectors (a.k.a. "USER_ROM","REG_SWPROM")
SYS_BIOSFIX			equ $3A000B		; Use BIOS Fix tiles
SYS_CARTFIX			equ $3A001B		; Use Cart Fix tiles

; [Memory Card]
CARD_ENABLE_1		equ $3A0005		; Enable card writes (w/CARD_ENABLE_2). (a.k.a. "REG_CRDUNLOCK1","IC_WRITE_EI1")
CARD_ENABLE_2		equ $3A0017		; Enable card writes (w/CARD_ENABLE_1). (a.k.a. "REG_CRDUNLOCK2","IC_WRITE_EI2")
CARD_DISABLE_1		equ $3A0007		; Disable card writes (w/CARD_DISABLE_2). (a.k.a. "REG_CRDLOCK1","IC_WRITE_DI1")
CARD_DISABLE_2		equ $3A0015		; Disable card writes (w/CARD_DISABLE_1). (a.k.a. "REG_CRDLOCK2","IC_WRITE_DI2")
CARD_SELECT			equ $3A0009		; Enable card register select
CARD_NORMAL			equ $3A0019		; Disable card register select
CARD_BANK			equ $380011		; Memory Card bank select
MEMCARD_DATA		equ $800000		; Memory Card Data (a.k.a. "IC_MEMORY")

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
PALETTES			equ $400000		; $400000-$401FFF (Bank 0)
PALETTES2			equ $402000		; $402000-$403FFF (Bank 1)
PALETTE_BANK0		equ $3A001F		; Palette bank 0
PALETTE_BANK1		equ $3A000F		; Palette bank 1

; BIOS RAM usage (begins at $10F300)
;==============================================================================;
; [Quick Glossary]
; Byte	$00-$FF             (0-255)
; Word	$0000-$FFFF         (0-65535)
; Long	$00000000-$FFFFFFFF (0-4294967295)
;==============================================================================;
; todo: Neo-Geo CD uses some ram locations differently. Needs research.
; Anything between $10F300 and $10FD80 is typically unexamined, but double check
; the NeoGeo dev wiki and existing software/BIOSes first.
;==============================================================================;
BIOS_WORKRAM			equ $10F300

;SSP_END:					; supervisor stack
;	ds.b $900				; ends up at $10FC00
;	ds.b $180				; ends up at $10FD80

;===================================;
; $10F688 "decremented each time a sector is read until it's 0" on CD systems

;===================================;
; $10FC24	; (word)

; $10FC48	; (word?) ?? list of some sort? (used in eyecatch)

; $10FC6C	; (word) ?? (used in eyecatch)

; $10FC90	; (word?) ?? list of some sort? (used in eyecatch)

; $10FCB4	; (word) ?? (used in eyecatch)

; $10FCD8	; (word) eyecatch routine number to call next
; $10FCDA	; (word) ?? (used in eyecatch)
; $10FCDC	; (word) routine internal counter (used in eyecatch)
; $10FCDE	; (word) ?? (used in eyecatch)
; $10FCE0	; (word) ?? (used in eyecatch)
; $10FCE2	; (long) ?? (used in eyecatch)
; $10FCE6	; (word) ?? (used in eyecatch)
; $10FCE8	; (long) ?? (used in eyecatch)

; $10FCEE "Z80/M ROM check pass", set by game

; $10FCF2 ??

;===================================;
; $10FD40 ??
; $10FD44 ??
; $10FD48 ??
; $10FD4A ??

DBGBIOS_ERROR_CODE		equ $10FD4C	; (word) Debug BIOS: Error Recovery Code
	; $00		Bus Error/Monitor Startup
	; $04		Adddress Error
	; $08		Illegal Instruction
	; $0C		Divide by 0
	; $10		CHK
	; $14		TRAPV
	; $18		Privilege Violation
	; $1C		Trace

; $10FD4E ??

; $10FD74 ??
; $10FD76 ??
; $10FD78 ??

;==============================================================================;
BIOS_WORK0				equ $10FD80	; beginning of actual BIOS work RAM

BIOS_SYSTEM_MODE		equ $10FD80	; (byte) VBL for $00=system,$80=game
BIOS_SYSRET_STATUS		equ $10FD81	; (byte) Stores function code for SYSTEM_RETURN
BIOS_MVS_FLAG			equ $10FD82	; (byte) 0=Home/AES,1=MVS
BIOS_COUNTRY_CODE		equ $10FD83	; (byte) 0=Japan,1=USA,2=Europe/Export (xxx:Korea?)
BIOS_GAME_DIP			equ $10FD84	; $10FD84-$10FD93 (all bytes)

; individual game soft dips
BIOS_GAMEDIP_TIME1		equ $10FD84	; (word) timed option 1 (minutes and seconds in BCD)
BIOS_GAMEDIP_TIME2		equ $10FD86	; (word) timed option 2 (minutes and seconds in BCD)
BIOS_GAMEDIP_COUNT1		equ $10FD88	; (byte) counter option 1 (1-99; value here is default)
BIOS_GAMEDIP_COUNT2		equ $10FD89	; (byte) counter option 2 (WITHOUT, INFINITE, 1-99 TIMES)
;---------------------------------;
BIOS_GAMEDIP_01			equ $10FD8A	; (byte) Game soft dip 01
BIOS_GAMEDIP_02			equ $10FD8B	; (byte) Game soft dip 02
BIOS_GAMEDIP_03			equ $10FD8C	; (byte) Game soft dip 03
BIOS_GAMEDIP_04			equ $10FD8D	; (byte) Game soft dip 04
BIOS_GAMEDIP_05			equ $10FD8E	; (byte) Game soft dip 05
BIOS_GAMEDIP_06			equ $10FD8F	; (byte) Game soft dip 06
BIOS_GAMEDIP_07			equ $10FD90	; (byte) Game soft dip 07
BIOS_GAMEDIP_08			equ $10FD91	; (byte) Game soft dip 08
BIOS_GAMEDIP_09			equ $10FD92	; (byte) Game soft dip 09
BIOS_GAMEDIP_10			equ $10FD93	; (byte) Game soft dip 10

;-----------------------------------;
; INPUT_1
BIOS_P1STATUS			equ $10FD94	; (byte) Controller 1 status
BIOS_P1PREVIOUS			equ $10FD95	; (byte) Inputs from last frame
BIOS_P1CURRENT			equ $10FD96	; (byte) Inputs from current frame
BIOS_P1CHANGE			equ $10FD97	; (byte) Active-edge input
BIOS_P1REPEAT			equ $10FD98	; (byte) Auto-repeat flag
BIOS_P1TIMER			equ $10FD99	; (byte) Input repeat timer
;-----------------------------------;
; INPUT_2
BIOS_P2STATUS			equ $10FD9A	; (byte) Controller 2 status
BIOS_P2PREVIOUS			equ $10FD9B	; (byte) Inputs from last frame
BIOS_P2CURRENT			equ $10FD9C	; (byte) Inputs from current frame
BIOS_P2CHANGE			equ $10FD9D	; (byte) Active-edge input
BIOS_P2REPEAT			equ $10FD9E	; (byte) Auto-repeat flag
BIOS_P2TIMER			equ $10FD9F	; (byte) Input repeat timer
;-----------------------------------;
; INPUT_3
BIOS_P3STATUS			equ $10FDA0	; (byte) Controller 3 status
BIOS_P3PREVIOUS			equ $10FDA1	; (byte) Inputs from last frame
BIOS_P3CURRENT			equ $10FDA2	; (byte) Inputs from current frame
BIOS_P3CHANGE			equ $10FDA3	; (byte) Active-edge input
BIOS_P3REPEAT			equ $10FDA4	; (byte) Auto-repeat flag
BIOS_P3TIMER			equ $10FDA5	; (byte) Input repeat timer
;-----------------------------------;
; INPUT_4
BIOS_P4STATUS			equ $10FDA6	; (byte) Controller 4 status
BIOS_P4PREVIOUS			equ $10FDA7	; (byte) Inputs from last frame
BIOS_P4CURRENT			equ $10FDA8	; (byte) Inputs from current frame
BIOS_P4CHANGE			equ $10FDA9	; (byte) Active-edge input
BIOS_P4REPEAT			equ $10FDAA	; (byte) Auto-repeat flag
BIOS_P4TIMER			equ $10FDAB	; (byte) Input repeat timer
;-----------------------------------;
; INPUT_S
BIOS_STATCURNT			equ $10FDAC	; (byte) Start and Select from current frame (Select bits = 0 on MVS)
BIOS_STATCHANGE			equ $10FDAD	; (byte) Start and Select active-edge input (Select bits = 0 on MVS)
;-----------------------------------;
BIOS_USER_REQUEST		equ $10FDAE	; (byte) Command for USER ($122)
BIOS_USER_MODE			equ $10FDAF	; (byte) Current game status (0:init/boot, 1:title/demo, 2:game)
;-----------------------------------;
; Before calling CREDIT_CHECK and CREDIT_DOWN, set num credits here (0 for unjoined).
BIOS_CREDIT1_DEC		equ $10FDB0	; (byte) Credit decrement Player 1 (BCD)
BIOS_CREDIT2_DEC		equ $10FDB1	; (byte) Credit decrement Player 2 (BCD)
BIOS_CREDIT3_DEC		equ $10FDB2	; (byte) Credit decrement Player 3 (BCD)
BIOS_CREDIT4_DEC		equ $10FDB3	; (byte) Credit decrement Player 4 (BCD)
;-----------------------------------;
BIOS_START_FLAG			equ $10FDB4	; (byte) Player(s) starting the game on PLAYER_START call
;BIOS_??????????		equ $10FDB5	; (byte) START_FLAG part 2. purpose unknown?
;-----------------------------------;
; Status Values: 0=No play, 1=Playing, 2=Continue display, 3=Game Over
BIOS_PLAYER1_MODE		equ $10FDB6	; (byte) Player 1 Status (a.k.a. "BIOS_PLAYER_MOD1")
BIOS_PLAYER2_MODE		equ $10FDB7	; (byte) Player 2 Status
BIOS_PLAYER3_MODE		equ $10FDB8	; (byte) Player 3 Status
BIOS_PLAYER4_MODE		equ $10FDB9	; (byte) Player 4 Status
;-----------------------------------;
;???					equ $10FDBA	; (long)
BIOS_MESS_POINT			equ $10FDBE	; (long) pointer to MESS_OUT buffer
BIOS_MESS_BUSY			equ $10FDC2	; (word) 0=run MESS_OUT, 1=skip MESS_OUT
;-----------------------------------;
BIOS_CARD_COMMAND		equ $10FDC4	; (byte) Command to execute
BIOS_CARD_MODE			equ $10FDC5	; (byte) "command error job mode"
BIOS_CARD_ANSWER		equ $10FDC6	; (byte) answer code for command; set by BIOS
;BIOS_??????????		equ $10FDC7	; (byte) ?
BIOS_CARD_START			equ $10FDC8	; (long) Pointer to start of card data
BIOS_CARD_SIZE			equ $10FDCC	; (word) Size of data
BIOS_CARD_FCB			equ $10FDCE	; (word) Game NGH number
BIOS_CARD_SUB			equ $10FDD0	; (byte/word) Game sub number (0-15)
;-----------------------------------;
BIOS_DATE_TIME			equ $10FDD2	; DATE_TIME struct

BIOS_YEAR				equ $10FDD2	; (byte) 
BIOS_MONTH				equ $10FDD3	; (byte) 
BIOS_DAY				equ $10FDD4	; (byte) 
BIOS_WEEKDAY			equ $10FDD5	; (byte) 
BIOS_HOUR				equ $10FDD6	; (byte) 
BIOS_MINUTE				equ $10FDD7	; (byte) 
BIOS_SECOND				equ $10FDD8	; (byte) 
;BIOS_??????????		equ $10FDD9	; (byte) ?
;-----------------------------------;
BIOS_SELECT_TIMER		equ $10FDDA	; (word) (a.k.a. "BIOS_COMPULSION_TIMER")
BIOS_START_TEST			equ $10FDDC	; (word) ??
BIOS_COIN_LEVER			equ $10FDDE	; (word) ??

;-------------------------------------------------------------------;
; $10FDE0-$10FDFF unused on cart BIOS? (possibly used on CD though) ;
;===================================================================;
BIOS_WORK1				equ $10FE00

BIOS_CREDIT1			equ $10FE00	; (byte)
BIOS_CREDIT2			equ $10FE01	; (byte)
BIOS_CREDIT3			equ $10FE02	; (byte)
BIOS_CREDIT4			equ $10FE03	; (byte)
;-----------------------------------;
BIOS_SWITCH_STORE		equ $10FE04	; (long)
;-----------------------------------;
BIOS_UNDER_CREDIT1		equ $10FE08	; (byte)
BIOS_UNDER_CREDIT2		equ $10FE09	; (byte)
BIOS_UNDER_CREDIT3		equ $10FE0A	; (byte)
BIOS_UNDER_CREDIT4		equ $10FE0B	; (byte)
BIOS_UNDER_CREDIT5		equ $10FE0C	; (byte)
BIOS_UNDER_CREDIT6		equ $10FE0D	; (byte)
BIOS_UNDER_CREDIT7		equ $10FE0E	; (byte)
BIOS_UNDER_CREDIT8		equ $10FE0F	; (byte)
;-----------------------------------;
BIOS_COIN1_NOR_CRED		equ $10FE10	; (word)
BIOS_COIN2_NOR_CRED		equ $10FE12	; (word)
BIOS_COIN1_CONT_CRED	equ $10FE14	; (word)
BIOS_COIN2_CONT_CRED	equ $10FE16	; (word)
;-----------------------------------;
BIOS_SELECT_FREE		equ $10FE18	; (byte)
;???					equ $10FE19	; (byte)
BIOS_NON_LIMIT			equ $10FE1A	; (word)
BIOS_DEMO_SOUND			equ $10FE1C ; (byte)
BIOS_INIT_MARK			equ $10FE1E	; (word)
BIOS_SR_STORE			equ $10FE20	; (word)
BIOS_VERSION_BASE		equ $10FE22	; (long)
BIOS_GD_STORE			equ $10FE26	; (byte) 32 bytes

;???					equ $10FE35	; (byte?)
;???					equ $10FE37	; (byte?)
;???					equ $10FE38	; (word?)

;===================================;
BIOS_WORK2				equ $10FE80

BIOS_DEVMODE			equ $10FE80	; (byte)
;$10FE81-$10FE87 "Power on ID code"??; typically, code checks for "1streset"
BIOS_FRAMECOUNT			equ $10FE88	; (long) (a.k.a. "SYS_INT1_TIMER")
BIOS_SYS_STOPPER		equ $10FE8C	; (byte) "system stopper", actually BIOS VBlank flag
BIOS_Z80_BANK			equ $10FE8D	; (byte)
BIOS_SYSTEM_MODE2		equ $10FE8E	; (word)
;-----------------------------------;
BIOS_CARD_TIMER			equ $10FE90	; (word)
BIOS_CARD_START2		equ $10FE92	; (long)
BIOS_CARD_SIZE2			equ $10FE96	; (word)
BIOS_CARD_FCB2			equ $10FE98	; (word)
BIOS_CARD_SUB2			equ $10FE9A	; (word)
BIOS_DIR_BUFFER			equ $10FE9C	; (byte) 20 bytes
BIOS_DIR_NUMBER			equ $10FEB0	; (word) 5 words
;-----------------------------------;
BIOS_FIX_STORE_FLAG		equ $10FEBA	; (byte)
BIOS_LED_OFF			equ $10FEBB	; (byte)
BIOS_IN_TEST			equ $10FEBC	; (byte)
BIOS_INST_MODE			equ $10FEBD	; (byte)
BIOS_START_BUSY			equ $10FEBE	; (byte)
BIOS_BACKUP_MODE		equ $10FEBF	; (byte) (a.k.a. "BIOS_BRAM_USED")
;-----------------------------------;
BIOS_INST_RAD			equ $10FEC0	; (long)
BIOS_INST_RCO			equ $10FEC4	; (byte)
;-----------------------------------;
BIOS_TITLE_MODE			equ $10FEC5	; (byte) When set to 1, stops BIOS from calling command 3 twice after Game Over if credits are in the system. -paraphrasing Razoola, NeoGeo Development Wiki
BIOS_MESS_STACK			equ $10FEC6	; (long) 5 longs; first is the pointer to the data.
;BIOS_??????????		equ $10FECA	; 
;-----------------------------------;
; $10FEDA and $10FEDB are used differently on CD systems; see below.
;BIOS_??????????		equ $10FEDA
;BIOS_??????????		equ $10FEDB	; (byte)
;-----------------------------------;
BIOS_STATCURNT_RAW		equ $10FEDC	; (byte) raw version of BIOS_STATCURNT (includes Select on MVS) (a.k.a. "INPUT_SS")
BIOS_STATCHANGE_RAW		equ $10FEDD	; (byte) raw version of BIOS_STATCHANGE (includes Select on MVS)
BIOS_INPUT_TT1			equ $10FEDE	; (byte)
BIOS_INPUT_TT2			equ $10FEDF	; (byte)

BIOS_KYOUSEI_MODE		equ $10FEE0	; (byte) a.k.a. "KYOUSEI_MODE" (Game start compulsion?)
BIOS_SYS_STOP			equ $10FEE1	; (byte) (a.k.a. "BIOS_FRAME_SKIP","SYS_STOP")
BIOS_CS_REMAIN			equ $10FEE2	; (byte) (a.k.a. "CS_REMAIN")
BIOS_INT_OFF			equ $10FEE3	; (byte) (a.k.a. "BIOS_INT1_SKIP", "INT_OFF")
BIOS_INT1_TIMER2		equ $10FEE4	; (word) (a.k.a. "BIOS_INT1_FRAME_COUNTER", "INT1_TIMER2")
;-----------------------------------;
;INPUT_5
BIOS_P5STATUS			equ $10FEE8	; (byte) Input 5 status
BIOS_P5PREVIOUS			equ $10FEE9	; (byte) Inputs from last frame
BIOS_P5CURRENT			equ $10FEEA	; (byte) Inputs from current frame
BIOS_P5CHANGE			equ $10FEEB	; (byte) Active-edge input
BIOS_P5REPEAT			equ $10FEEC	; (byte) Auto-repeat flag
BIOS_P5TIMER			equ $10FEED	; (byte) Input repeat timer
;-----------------------------------;
;INPUT_6
BIOS_P6STATUS			equ $10FEEE	; (byte) Input 6 status
BIOS_P6PREVIOUS			equ $10FEEF	; (byte) Inputs from last frame
BIOS_P6CURRENT			equ $10FEF0	; (byte) Inputs from current frame
BIOS_P6CHANGE			equ $10FEF1	; (byte) Active-edge input
BIOS_P6REPEAT			equ $10FEF2	; (byte) Auto-repeat flag
BIOS_P6TIMER			equ $10FEF3	; (byte) Input repeat timer
;-----------------------------------;
BIOS_MESS_BUFFER		equ $10FF00	; 100 byte buffer

;==============================================================================;
; [Cart systems with 4-Player Compatible BIOS only]

BIOS_4P_REQUESTED		equ $10FEF8	; (bios) local copy of hard dip 2 (0=off; 2=on)
BIOS_4P_MODE			equ $10FEFA	; (bios) Main 4P flag (0=regular; $FF=4P ok)
BIOS_4P_PLUGGED			equ $10FEFB	; (bios) Is board present? (0=not found; $FF=plugged in)

;==============================================================================;
; [CD system-specific]

; $10FDDC	on NeoCD top 3-2: 1=Load file with animation, 0=No animation 

; $10FDE2 (at least CDZ)

; DRAM Uploading
BIOS_CD_UPZONE			equ $10FEDA	; (byte) zone (0=PRG/TXT, 1=FIX, 2=SPR, 3=Z80, 4=PCM, 5=PAT, 6=???, 7=OBJ, 8=A**)
BIOS_CD_UPBANK			equ $10FEDB	; (byte) bank
BIOS_CD_UPDEST			equ $10FEF4	; (long) destination address
BIOS_CD_UPSRC			equ $10FEF8	; (long) source address
BIOS_CD_UPSIZE			equ $10FEFC	; (long) size

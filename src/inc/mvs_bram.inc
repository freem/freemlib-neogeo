; MVS Backup RAM ($D00000-$D0FFFF)
BRAM_START				equ $D00000

BRAM_CREDIT_P1			equ $D0003A	; (byte) Coins needed for crediting player 1
BRAM_CREDIT_ADD_P1		equ $D0003B	; (byte) Credits added to player 1
BRAM_CREDIT_P2			equ $D0003C	; (byte) Coins needed for crediting player 2
BRAM_CREDIT_ADD_P2		equ $D0003D	; (byte) Credits added to player 2
BRAM_GAMESEL			equ $D00042	; (byte) Game select (1=free,0=need credit)
BRAM_COMPULSION			equ $D00043	; (byte) compulsion timer toggle (0=enable,1=disable)
BRAM_COMPULSION_TIME	equ $D00044	; (byte) compulsion timer value, BCD

BRAM_SOUND_STOP			equ $D00046	; (byte) demo sound toggle; disable sounds if nonzero
BRAM_SLOT_NUMBER		equ $D00047	; (byte) number of detected slots (2 for 1-slot machines)
BRAM_PLAY_TIME			equ $D00048	; (long) play time counter (in seconds, hex)
BRAM_PLAYTIME_TIMER		equ $D0004C	; (byte) timer used with BRAM_PLAY_TIME. counts down from $3C
BRAM_FRAME_TIMER		equ $D0005A	; (long) HHMMSSFF timer (hours*4,minutes,seconds,frame down)
BRAM_CUR_DATE			equ $D00104	; (long) YYMMDDdd date

BRAM_BOOKP_START_DETAIL	equ $D0010A	; (long) detailed game start book address
BRAM_BOOKP_START_TOTAL	equ $D0010E	; (long) total game start book address
BRAM_BOOKP_COIN_DETAIL	equ $D00112	; (long) detailed cabinet coin book address
BRAM_BOOKP_COIN_MONTH	equ $D00116	; (long) current month cabinet coin book address
BRAM_BOOKP_START_MONTH	equ $D001A4	; (long) Current month game start book (pointer?)

; slots (empty slots have NGH 0000 and ID $FFFF)
BRAM_SLOT1_ID			equ $D00124	; (long) Slot 1 NGH number, BRAM game block ID
BRAM_SLOT2_ID			equ $D00128	; (long) Slot 2 NGH number, BRAM game block ID
BRAM_SLOT3_ID			equ $D0012C	; (long) Slot 3 NGH number, BRAM game block ID
BRAM_SLOT4_ID			equ $D00130	; (long) Slot 4 NGH number, BRAM game block ID
BRAM_SLOT5_ID			equ $D00134	; (long) Slot 5 NGH number, BRAM game block ID
BRAM_SLOT6_ID			equ $D00138	; (long) Slot 6 NGH number, BRAM game block ID
BRAM_SLOT7_ID			equ $D0013C	; (long) Slot 7 NGH number, BRAM game block ID
BRAM_SLOT8_ID			equ $D00140	; (long) Slot 8 NGH number, BRAM game block ID
;-----------------------------------;
BRAM_SLOT1_CREATED		equ $D00144	; (long) creation date for Slot 1 book (YYMMDDdd)
BRAM_SLOT2_CREATED		equ $D00148	; (long) creation date for Slot 2 book (YYMMDDdd)
BRAM_SLOT3_CREATED		equ $D0014C	; (long) creation date for Slot 3 book (YYMMDDdd)
BRAM_SLOT4_CREATED		equ $D00150	; (long) creation date for Slot 4 book (YYMMDDdd)
BRAM_SLOT5_CREATED		equ $D00154	; (long) creation date for Slot 5 book (YYMMDDdd)
BRAM_SLOT6_CREATED		equ $D00158	; (long) creation date for Slot 6 book (YYMMDDdd)
BRAM_SLOT7_CREATED		equ $D0015C	; (long) creation date for Slot 7 book (YYMMDDdd)
BRAM_SLOT8_CREATED		equ $D00160	; (long) creation date for Slot 8 book (YYMMDDdd)
;-----------------------------------;
BRAM_SLOT1_NAME			equ $D002A0	; (16 bytes) Game name for BRAM Block 1
BRAM_SLOT2_NAME			equ $D002B0	; (16 bytes) Game name for BRAM Block 2
BRAM_SLOT3_NAME			equ $D002C0	; (16 bytes) Game name for BRAM Block 3
BRAM_SLOT4_NAME			equ $D002D0	; (16 bytes) Game name for BRAM Block 4
BRAM_SLOT5_NAME			equ $D002E0	; (16 bytes) Game name for BRAM Block 5
BRAM_SLOT6_NAME			equ $D002F0	; (16 bytes) Game name for BRAM Block 6
BRAM_SLOT7_NAME			equ $D00300	; (16 bytes) Game name for BRAM Block 7
BRAM_SLOT8_NAME			equ $D00310	; (16 bytes) Game name for BRAM Block 8
;-----------------------------------;
BRAM_SLOT1_DATA			equ $D00320	; ($1000 bytes) Save data for BRAM Block 1
BRAM_SLOT2_DATA			equ $D01320	; ($1000 bytes) Save data for BRAM Block 2
BRAM_SLOT3_DATA			equ $D02320	; ($1000 bytes) Save data for BRAM Block 3
BRAM_SLOT4_DATA			equ $D03320	; ($1000 bytes) Save data for BRAM Block 4
BRAM_SLOT5_DATA			equ $D04320	; ($1000 bytes) Save data for BRAM Block 5
BRAM_SLOT6_DATA			equ $D05320	; ($1000 bytes) Save data for BRAM Block 6
BRAM_SLOT7_DATA			equ $D06320	; ($1000 bytes) Save data for BRAM Block 7
BRAM_SLOT8_DATA			equ $D07320	; ($1000 bytes) Save data for BRAM Block 8

; Game Soft Dips ($D00220-$D0029F, 16*8)

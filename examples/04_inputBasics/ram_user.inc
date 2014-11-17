; normal RAM begins at $100000
RAMBEGIN			equ $100000

; USER RAM (begins at $100000)
USER_RAM			equ $100000

;==============================================================================;
flag_VBlank			equ $100000	; (byte) vblank flag

; copies of registers used for drawing updates
; [Player 1]
p1_Status			equ $100010	; (byte) Controller status
p1_Previous			equ $100011	; (byte) Previous frame's inputs (DCBArldu)
p1_Current			equ $100012	; (byte) Current frame's inputs (DCBArldu)
p1_Change			equ $100013	; (byte) Active edge inputs (DCBArldu)
p1_Repeat			equ $100014	; (byte) Auto-repeat flags (active edge, repeat every 8 frames after first 16 frames.)
p1_Timer			equ $100015	; (byte) Input repeat timer

; [Player 2]
p2_Status			equ $100020	; (byte) Controller status
p2_Previous			equ $100021	; (byte) Previous frame's inputs (DCBArldu)
p2_Current			equ $100022	; (byte) Current frame's inputs (DCBArldu)
p2_Change			equ $100023	; (byte) Active edge inputs (DCBArldu)
p2_Repeat			equ $100024	; (byte) Auto-repeat flags (active edge, repeat every 8 frames after first 16 frames.)
p2_Timer			equ $100025	; (byte) Input repeat timer

;-- (not used, but budgeted for future expansion) --;
; [Player 3]
p3_Status			equ $100030	; (byte) Controller status
p3_Previous			equ $100031	; (byte) Previous frame's inputs (DCBArldu)
p3_Current			equ $100032	; (byte) Current frame's inputs (DCBArldu)
p3_Change			equ $100033	; (byte) Active edge inputs (DCBArldu)
p3_Repeat			equ $100034	; (byte) Auto-repeat flags (active edge, repeat every 8 frames after first 16 frames.)
p3_Timer			equ $100035	; (byte) Input repeat timer

; [Player 4]
p4_Status			equ $100040	; (byte) Controller status
p4_Previous			equ $100041	; (byte) Previous frame's inputs (DCBArldu)
p4_Current			equ $100042	; (byte) Current frame's inputs (DCBArldu)
p4_Change			equ $100043	; (byte) Active edge inputs (DCBArldu)
p4_Repeat			equ $100044	; (byte) Auto-repeat flags (active edge, repeat every 8 frames after first 16 frames.)
p4_Timer			equ $100045	; (byte) Input repeat timer
;-- (end future expansion) --;

; [System Stuff]
sys_StatusA			equ $100050	; (byte) Coins (xxx43S21)
sys_StatCurrent		equ $100051	; (byte) Current frame's Select and Start (BIOS_STATCURNT_RAW)
sys_StatChange		equ $100052	; (byte) Active edge Select and Start (BIOS_STATCHANGE_RAW)
sys_InputTT1		equ $100053	; (byte) 
sys_InputTT2		equ $100054	; (byte) 
sys_Dipswitches		equ $100055	; (byte) (REG_DIPSW)

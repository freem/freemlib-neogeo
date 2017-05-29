; instruments.inc - Instrument Definitions file
;==============================================================================;
; [Instructions]
; Copy this file and edit me!

; Instrument structure is still under construction, however.
;==============================================================================;
; [FM instruments]
; FM instruments are 32 bytes each, and are closest to the .TYI format.

; table for FM instruments
instruments_FM:
	word instFM_01
	word instFM_02

;------------------------------------------------------------------------------;
; FM instrument definitions
; (The example instruments currently do not work. They will be replaced later.)

; example with regular byte defines
instFM_01:
	byte $00,$00,$00,$00 ; detune/multiple for ops 1-4
	byte $00,$00,$00,$00 ; total level for ops 1-4
	byte $00,$00,$00,$00 ; key scale/attack rate for ops 1-4
	byte $00,$00,$00,$00 ; am on/decay rate for ops 1-4
	byte $00,$00,$00,$00 ; sustain rate for ops 1-4
	byte $00,$00,$00,$00 ; sustain level/release rate for ops 1-4
	byte $00,$00,$00,$00 ; SSG-EG value for ops 1-4
	byte $00 ; Feedback/Algorithm
	byte $00 ; AM Sense/PM sense
	byte $00 ; (padding/future expansion)
	byte $00 ; (padding/future expansion)

;------------------------------------------------------------------------------;
; example with macros
instFM_02:
	fmInst_DetuneMult 0,0 ; operator 1
	fmInst_DetuneMult 0,0 ; operator 2
	fmInst_DetuneMult 0,0 ; operator 3
	fmInst_DetuneMult 0,0 ; operator 4
	;--------------------------;
	fmInst_TotalLevel 0
	fmInst_TotalLevel 0
	fmInst_TotalLevel 0
	fmInst_TotalLevel 0
	;--------------------------;
	fmInst_KeyScaleAtkRate 0,0
	fmInst_KeyScaleAtkRate 0,0
	fmInst_KeyScaleAtkRate 0,0
	fmInst_KeyScaleAtkRate 0,0
	;--------------------------;
	fmInst_AMOnDecayRate 0,0
	fmInst_AMOnDecayRate 0,0
	fmInst_AMOnDecayRate 0,0
	fmInst_AMOnDecayRate 0,0
	;--------------------------;
	fmInst_SustainRate 0
	fmInst_SustainRate 0
	fmInst_SustainRate 0
	fmInst_SustainRate 0
	;--------------------------;
	fmInst_SustLevelRelRate 0,0
	fmInst_SustLevelRelRate 0,0
	fmInst_SustLevelRelRate 0,0
	fmInst_SustLevelRelRate 0,0
	;--------------------------;
	fmInst_SSGEG 0
	fmInst_SSGEG 0
	fmInst_SSGEG 0
	fmInst_SSGEG 0
	;--------------------------;
	fmInst_FeedbackAlgo 0,0
	fmInst_AMSPMS 0,0
	byte $00 ; (padding/future expansion)
	byte $00 ; (padding/future expansion)

;==============================================================================;
; [SSG instruments]
; SSG instruments are ??????????????????????

; table for SSG instruments
instruments_SSG:
	;word instSSG_01

;==============================================================================;
; [ADPCM-B instruments]
; ADPCM-B instruments are currently four bytes.

instruments_PCMB: ; table for ADPCM-B instruments
	;word instPCMB_01

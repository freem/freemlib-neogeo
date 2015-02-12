; instruments.inc - ADPCM Sample Definitions file
;==============================================================================;
; [Instructions]
; Copy and edit me!
;==============================================================================;
; ADPCM-A Sample Data
; format: Start and End address/256 in Words.

samples_PCMA:
	;word	startaddr,endaddr

;------------------------------------------------------------------------------;
; ADPCM-B Sample Data
; format:
; 2 words - Start and End address/256
; 1 word  - Default Delta-N sampling rate

samples_PCMB:
	;word	startaddr,endaddr,samprate

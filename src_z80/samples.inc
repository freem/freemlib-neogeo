; instruments.inc - ADPCM Sample Definitions file
;==============================================================================;
; [Instructions]
; Copy and edit me! (or use Sailor VROM to generate a file like this instead)
;==============================================================================;
; ADPCM-A Sample Data
; format: Start and End address/256 in Words.

samples_PCMA:
	;word startaddr,endaddr

;------------------------------------------------------------------------------;
; ADPCM-B Sample Data
; format:
; 2 words - Start and End address/256

samples_PCMB:
	;word startaddr,endaddr

; ADPCM-B Sample Rate
; format:
; 1 word  - Default Delta-N sampling rate
rates_PCMB:
	;word samprate

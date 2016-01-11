; freqtables.inc - Frequency Table definitions
;==============================================================================;
; FM Frequency Table (Calculated from A440)

; F-Number = (144 * fnote * 2^20 / M) / 2^B-1

; . fnote: pronounciation frequency (in Hertz)
; . M: master clock (8MHz = 8*10^6 = 8000000)
; . B: block data (octave)

; for the imaginary E#/Fb:
; (144 * 339.43 * 1048576 / 8000000) / 8
; (6406.52673024) / 8 = 800.81584128

; for the imaginary B#/Cb:
; (144 * 507.74 * 1048576 / 8000000) / 8
; (9583.27160832) / 8 = 1197.90895104

	; table is arranged like this since the high byte *must* be written first.
freqTable_FM:
	byte 0x02,0x69 ; C4       261.63Hz
	byte 0x02,0x8E ; C#4/Db4  277.18Hz
	byte 0x02,0xB5 ; D4       293.66Hz
	byte 0x02,0xDE ; D#4/Eb4  311.13Hz
	byte 0x03,0x09 ; E4       329.63Hz
	;byte 0x03,0x20 ; imaginary E#/Fb4 (339.43Hz)
	byte 0x03,0x38 ; F4       349.23Hz
	byte 0x03,0x69 ; F#4/Gb4  369.99Hz
	byte 0x03,0x9D ; G4       392.00Hz
	byte 0x03,0xD3 ; G#4/Ab4  415.30Hz
	byte 0x04,0x0E ; A4       440.00Hz
	byte 0x04,0x4B ; A#4/Bb4  466.16Hz
	byte 0x04,0x8D ; B4       493.88Hz
	;byte 0x04,0xAE ; imaginary B#/Cb (507.74Hz)

	; For quick ORing with F-Num 2/high byte
blockTable_FM:
	;        --BBB---
	byte %00000000 ; Octave 0
	byte %00001000 ; Octave 1
	byte %00010000 ; Octave 2
	byte %00011000 ; Octave 3
	byte %00100000 ; Octave 4
	byte %00101000 ; Octave 5
	byte %00110000 ; Octave 6
	byte %00111000 ; Octave 7

;==============================================================================;
; SSG Frequency Table (B-0 to B-7; 85 notes)

freqTable_SSG:
	;     B-0
	word 0xFD1
	;------------------------------------------------------------------------------;
	;     C-1 , C#1 , D-1 , Eb1 , E-1 , F-1 , F#1 , G-1 , Ab1 , A-1 , Bb1 , B-1
	word 0xEEE,0xE17,0xD4D,0xC8E,0xBD9,0xB2F,0xA8E,0x9F7,0x967,0x8E0,0x861,0x7E8
	;------------------------------------------------------------------------------;
	;     C-2 , C#2 , D-2 , Eb2 , E-2 , F-2 , F#2 , G-2 , Ab2 , A-2 , Bb2 , B-2
	word 0x777,0x70B,0x6A6,0x647,0x5EC,0x597,0x547,0x4FB,0x4B3,0x470,0x430,0x3F4
	;------------------------------------------------------------------------------;
	;     C-3 , C#3 , D-3 , Eb3 , E-3 , F-3 , F#3 , G-3 , Ab3 , A-3 , Bb3 , B-3
	word 0x3BB,0x385,0x353,0x323,0x2F6,0x2CB,0x2A3,0x27D,0x259,0x238,0x218,0x1FA
	;------------------------------------------------------------------------------;
	;     C-4 , C#4 , D-4 , Eb4 , E-4 , F-4 , F#4 , G-4 , Ab4 , A-4 , Bb4 , B-4
	word 0x1DD,0x1C2,0x1A9,0x191,0x17B,0x165,0x151,0x13E,0x12C,0x11C,0x10C,0x0FD
	;------------------------------------------------------------------------------;
	;     C-5 , C#5 , D-5 , Eb5 , E-5 , F-5 , F#5 , G-5 , Ab5 , A-5 , Bb5 , B-5
	word 0x0EE,0x0E1,0x0D4,0x0C8,0x0BD,0x0B2,0x0A8,0x09F,0x096,0x08E,0x086,0x07E
	;------------------------------------------------------------------------------;
	;     C-6 , C#6 , D-6 , Eb6 , E-6 , F-6 , F#6 , G-6 , Ab6 , A-6 , Bb6 , B-6
	word 0x077,0x070,0x06A,0x064,0x05E,0x059,0x054,0x04F,0x04B,0x047,0x043,0x03F
	;------------------------------------------------------------------------------;
	;     C-7 , C#7 , D-7 , Eb7 , E-7 , F-7 , F#7 , G-7 , Ab7 , A-7 , Bb7 , B-7
	word 0x03B,0x038,0x035,0x032,0x02F,0x02C,0x02A,0x027,0x025,0x023,0x021,0x01F

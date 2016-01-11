	; setting up the soft dip (Japan)
softDips_Japan:
	dc.b "EXAMPLE SET J   " ; Game Name
	dc.w $FFFF ; Special Option 1
	dc.w $FFFF ; Special Option 2
	dc.b $FF ; Special Option 3
	dc.b $FF ; Special Option 4
	; Options
	dc.b $02 ; Option 1: 2 choices, default #0
	dc.b $00,$00,$00,$00,$00,$00,$00,$00,$00 ; filler
	dc.b "OPTION 1J   " ; Option 1 description
	dc.b "CHOICE1 J   " ; Option choices
	dc.b "CHOICE2 J   "

	; setting up the soft dip (USA)
softDips_USA:
	dc.b "EXAMPLE SET U   " ; Game Name
	dc.w $FFFF ; Special Option 1
	dc.w $FFFF ; Special Option 2
	dc.b $FF ; Special Option 3
	dc.b $FF ; Special Option 4
	; Options
	dc.b $02 ; Option 1: 2 choices, default #0
	dc.b $00,$00,$00,$00,$00,$00,$00,$00,$00 ; filler
	dc.b "OPTION 1U   " ; Option 1 description
	dc.b "CHOICE1 U   " ; Option choices
	dc.b "CHOICE2 U   "

	; setting up the soft dip (Europe)
softDips_Europe:
	dc.b "EXAMPLE SET E   " ; Game Name
	dc.w $FFFF ; Special Option 1
	dc.w $FFFF ; Special Option 2
	dc.b $FF ; Special Option 3
	dc.b $FF ; Special Option 4
	; Options
	dc.b $02 ; Option 1: 2 choices, default #0
	dc.b $00,$00,$00,$00,$00,$00,$00,$00,$00 ; filler
	dc.b "OPTION 1E   " ; Option 1 description
	dc.b "CHOICE1 E   " ; Option choices
	dc.b "CHOICE2 E   "

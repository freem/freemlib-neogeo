tools Directory
===============

adpcma/ (submodule)		ADPCM-A sample encoder
misc/					Unsorted programs
romwak/ (submodule)		ANSI C port of Jeff Kurtz's ROMWak tool
sailorvrom/				Sailor VROM, a V ROM/.PCM file builder
yy-chr_plugins/			Plugins for YY-CHR.NET (http://www.geocities.jp/yy_6502/yychr/index.html)
	NeoFix_yyplug/			NeoFixFormat plugin (.S1, .FIX files)

genSSGSquareTable.lua	Lua (5.1) script for generating a SSG tone period table.

================================================================================
[Notes]
Tools in here may have a different license than the main library.
I will try and be better about being consistent with licenses.

The ADPCM-A tool is deprecated, as superctr's "adpcm" tool can handle both
ADPCM-A and B within the same binary. See https://github.com/superctr/adpcm

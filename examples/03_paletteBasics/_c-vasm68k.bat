vasm68k -Fbin -m68000 -o palBasics_vasm68k.p -devpac 03_paletteBasics.asm
byteswap palBasics.p 202-p1.p1
pad 202-p1.p1 524288 255
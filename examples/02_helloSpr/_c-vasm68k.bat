vasm68k -Fbin -m68000 -o helloSpr_vasm68k.p -devpac 02_helloSpr.asm
byteswap helloSpr_vasm68k.p 202-p1.p1
pad 202-p1.p1 524288 255
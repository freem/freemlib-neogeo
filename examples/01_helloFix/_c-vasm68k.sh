#!/bin/sh
vasm68k -Fbin -o helloFix_vasm68k.p -devpac 01_helloFix.asm
byteswap helloFix_vasm68k.p 202-p1.p1
pad 202-p1.p1 524288 255
# makefile for compiling a Neo-Geo project with vasm (68k, motorola syntax)
################################################################################
# [Tool Settings]
# executable name for vasm (68k, motorola syntax); change as needed
VASM68K = vasm68k
# default flags for vasm (standard binary output, compile for 68000)
VASMFLAGS = -Fbin -m68000 -devpac

# executable name for byteswapping tool
BYTESWAP = byteswap
# flags for byteswapping tool (if required)
BYTESWAPFLAGS = 

# executable name for padding tool
PAD = pad
# flags for padding tool
PADFLAGS = 524288 255

# executable name for mkisofs
MKISOFS = mkisofs
# flags for mkisofs
MKISOFSFLAGS = -iso-level 1 -pad -N

# executable name for chdman
CHDMAN = chdman
# action for chdman
CHDMANACTION = createcd

################################################################################
# [Output Settings]

################################################################################
# [Makefile Targets]

# cart: compile game for cart (default build target)
cart: 01_helloFix.asm
	$(VASM68K) $(VASMFLAGS) -DTARGET_CART -o 01_helloFix.p 01_helloFix.asm
	$(BYTESWAP) 01_helloFix.p 202-p1.p1
	$(PAD) 202-p1.p1 $(PADFLAGS)

# cd: compile game for CD
cd: 01_helloFix.asm
	$(VASM68K) $(VASMFLAGS) -DTARGET_CD -o HELLOFIX.PRG 01_helloFix.asm
	$(MKISOFS) $(MKISOFSFLAGS) -o HelloFix.iso -V "HELLOFIX" ../../cdfiles/ABS.TXT ../../cdfiles/BIB.TXT ../../cdfiles/CPY.TXT HELLOFIX.PRG fixtiles/HELLOFIX.FIX sprtiles/HELLOFIX.SPR IPL.TXT TITLE_E.SYS TITLE_J.SYS TITLE_U.SYS

# chd: create CHD from CD for use with MAME/MESS
chd: cd
	$(CHDMAN) $(CHDMANACTION) -i HelloFix.iso -o HelloFix.chd

.PHONY: clean

# remove binaries and intermediates
clean:
	rm -f *.p *.p1 *.PRG *.iso *.chd

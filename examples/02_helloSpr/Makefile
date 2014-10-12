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
cart: 02_helloSpr.asm
	$(VASM68K) $(VASMFLAGS) -DTARGET_CART -o 02_helloSpr.p 02_helloSpr.asm
	$(BYTESWAP) 02_helloSpr.p 202-p1.p1
	$(PAD) 202-p1.p1 $(PADFLAGS)

# cd: compile game for CD
cd: 02_helloSpr.asm
	$(VASM68K) $(VASMFLAGS) -DTARGET_CD -o HELLOSPR.PRG 02_helloSpr.asm
#	$(PAD) HELLOSPR.PRG $(PADFLAGS)
	$(MKISOFS) $(MKISOFSFLAGS) -o HelloSpr.iso -V "HELLOSPR" HELLOSPR.PRG fixtiles/HELLOSPR.FIX sprtiles/HELLOSPR.SPR IPL.TXT ../../cdfiles/ABS.TXT ../../cdfiles/BIB.TXT ../../cdfiles/CPY.TXT

# chd: create CHD from CD for use with MAME/MESS
chd: cd
	$(CHDMAN) $(CHDMANACTION) -i HelloSpr.iso -o HelloSpr.chd

.PHONY: clean

# remove binaries and intermediates
clean:
	rm -f *.p *.p1 *.prg *.PRG

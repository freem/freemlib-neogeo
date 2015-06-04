# makefile for assembling a Neo-Geo project with vasm (68k, motorola syntax)
################################################################################
# [Input and Intermediate Settings]
# main file to assemble
INPUT_MAINSRCFILE = 00_skeleton.asm

# intermediate binary (for cart)
INTERMED_BINARY = 00_skeleton.p

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
# image/ISO name
IMAGENAME = skeleton

# disc label (8 characters maximum)
DISCLABEL = SKELETON

# final PRG and P1 output files
PRG_CART = 202-p1.p1
PRG_CD = SKELETON.PRG

# files to put on the CD
DISCFILES = \
	../../cdfiles/ABS.TXT \
	../../cdfiles/BIB.TXT \
	../../cdfiles/CPY.TXT \
	$(PRG_CD) \
	IPL.TXT

################################################################################
# [Makefile Targets]

# cart: compile game for cart (default build target)
cart: $(INPUT_MAINSRCFILE)
	$(VASM68K) $(VASMFLAGS) -DTARGET_CART -o $(INTERMED_BINARY) $(INPUT_MAINSRCFILE)
	$(BYTESWAP) $(INTERMED_BINARY) $(PRG_CART)
	$(PAD) $(PRG_CART) $(PADFLAGS)

# cd: compile game for CD
cd: $(INPUT_MAINSRCFILE)
	$(VASM68K) $(VASMFLAGS) -DTARGET_CD -o $(PRG_CD) $(INPUT_MAINSRCFILE)
	$(MKISOFS) $(MKISOFSFLAGS) -o $(IMAGENAME).iso -V "$(DISCLABEL)" $(DISCFILES)

# chd: create CHD from CD for use with MAME/MESS
chd: cd
	$(CHDMAN) $(CHDMANACTION) -i $(IMAGENAME).iso -o $(IMAGENAME).chd

.PHONY: all clean

# all: create cart, CD, and CHD versions. (CHD makes CD as a part of its build process)
all: cart chd

# clean: remove binaries and intermediates
clean:
	rm -f *.p *.p1 *.prg *.PRG *.iso *.chd

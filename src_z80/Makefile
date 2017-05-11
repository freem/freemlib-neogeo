# makefile for freemlib Neo-Geo sound driver; vasm (z80, oldstyle syntax)
################################################################################
# [Tool Settings]
# executable name for vasm (z80, oldstyle syntax); change as needed
VASMZ80 = vasmz80
# default flags for vasm z80
VASMZ80FLAGS = -Fvobj -nosym

# executable name for vlink
VLINK = vlink
# link script name
LINKSCRIPT = sounddrv.ld
# default flags for vlink
VLINKFLAGS = -b rawbin1 -T $(LINKSCRIPT)

# executable name for padding tool
PAD = pad
# flags for padding tool
PADFLAGS_M1 = 65536

################################################################################
# [Output Settings]

# intermediate file for linking
M1_INTERMEDIATE = sounddrv.vobj

# output file for cart
M1_CART = sounddrv.m1

# output file for CD
M1_CD   = SOUNDDRV.Z80

################################################################################
# [Makefile Targets]

.PHONY: all clean

# all: compile 'em all
all: cart cd

#====================================================#
# cart: Targeting Cart systems (M1 ROM, ADPCM-B; default build)
cart:
	$(VASMZ80) $(VASMZ80FLAGS) -DTARGET_CART -o $(M1_INTERMEDIATE) sounddrv.asm
	$(VLINK) $(VLINKFLAGS) -o $(M1_CART) $(M1_INTERMEDIATE)
	$(PAD) $(M1_CART) $(PADFLAGS_M1)

#====================================================#
# cd: Targeting CD systems (Z80 file, CDDA)
cd:
	$(VASMZ80) $(VASMZ80FLAGS) -DTARGET_CD -o $(M1_INTERMEDIATE) sounddrv.asm
	$(VLINK) $(VLINKFLAGS) -o $(M1_CD) $(M1_INTERMEDIATE)

#====================================================#
# remove binaries and intermediates
clean:
	rm -f $(M1_CART) $(M1_CD) $(M1_INTERMEDIATE)

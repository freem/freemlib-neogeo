# makefile for freemlib Neo-Geo sound driver; vasm (z80, oldstyle syntax)
################################################################################
# [Tool Settings]
# executable name for vasm (z80, oldstyle syntax); change as needed
VASMZ80 = vasmz80
# default flags for vasm z80 (standard binary output, no symbols)
VASMZ80FLAGS = -Fbin -nosym

# executable name for padding tool
PAD = pad
# flags for padding tool
PADFLAGS_M1 = 131072

################################################################################
# [Output Settings]

# output file for cart
M1_CART = sounddrv.m1

# output file for CD
M1_CD   = SOUNDDRV.Z80

################################################################################
# [Makefile Targets]

# cart: Targeting Cart systems (M1 ROM, ADPCM-B; default build)
cart:
	$(VASMZ80) $(VASMZ80FLAGS) -DTARGET_CART -o $(M1_CART) sounddrv.asm
	$(PAD) $(M1_CART) $(PADFLAGS_M1)

#====================================================#
# cd: Targeting CD systems (Z80 file, CDDA)
cd:
	$(VASMZ80) $(VASMZ80FLAGS) -DTARGET_CD -o $(M1_CD) sounddrv.asm

#====================================================#
# all: compile 'em all
all: cart cd

#====================================================#
.PHONY: all clean

# remove binaries and intermediates
clean:
	rm -f *.m1 *.Z80

# makefile for compiling a Neo-Geo project with vasm (68k, motorola syntax)
################################################################################

# executable name for vasm (68k, motorola syntax); change as needed
VASM68K = vasm68k
# default flags for vasm (standard binary output, compile for 68000)
VASMFLAGS = -Fbin -m68000

# executable name for byteswapping tool
BYTESWAP = byteswap
# flags for byteswapping tool (if required)
BYTESWAPFLAGS = 

# cart: compile game for cart (default build target)
cart: 00_skeleton.asm
	$(VASM68K) $(VASMFLAGS) -DTARGET_CART -o 00_skeleton.p 00_skeleton.asm

# cd: compile game for CD
cd: 00_skeleton.asm
	$(VASM68K) $(VASMFLAGS) -DTARGET_CD -o 00_skeleton-cd.prg 00_skeleton.asm

.PHONY: clean

# remove binaries and intermediates
clean:
	rm -f *.p *.p1 *.prg

freemlib for Neo-Geo Example 01: Hello World on the Fix Layer
================================================================================
[Introduction]
This first example isn't so much using the freemlib as it is setting up a basic
Neo-Geo program and writing some text to the screen on the Fix layer. The macros
in "mess_macro.inc" are not used here, so you can get a feel for how things
actually work (which is required for proper usage of the macros in mess_macro).

================================================================================
[Files]
(In the directory)
_c-asm68k.bat			Batch file for compiling with asm68k
_c-vasm68k.bat			Batch file for compiling with vasm (68k, mot syntax; executable renamed to "vasm86k")
_c-vasm68k.sh			Shell script for compiling with vasm (68k, mot syntax; executable renamed to "vasm86k")
01_helloFix.asm			Main file
header_68k.inc			68000 Vectors
header_cart.inc			Neo-Geo cartridge header
header_cd.inc			Neo-Geo CD header
IPL.TXT					Initial Program Load for Neo-Geo CD
Makefile				GNU Make makefile
ram_user.inc			User space RAM ($100000-$10F2FF) defines
readme.txt				This file!
TITLE_E.SYS				Title image for European Neo-Geo CDZ systems
TITLE_J.SYS				Title image for Japanese Neo-Geo CDZ systems
TITLE_U.SYS				Title image for USA Neo-Geo CDZ systems

(Sub-directories)
cdztitle/				raw PNG copies of Neo-Geo CDZ title cards
	TITLE_E.PNG			Title card for European systems
	TITLE_J.PNG			Title card for Japanese systems
	TITLE_U.PNG			Title card for United States systems
fixtiles/				fix layer tilesets
	202-s1.s1			Fix Layer S ROM (Cart)
	HELLOFIX.FIX		.FIX file for CD (same file, just me being lazy)
sprtiles/
	202-c1.c1			C ROM 1/2
	202-c2.c2			C ROM 2/2
	HELLOFIX.SPR		.SPR file for Neo-Geo CD
	in.smc				Source of C ROM (SNES format graphics; convert with recode16)
	TITLE_E.*			European Title image related files
	TITLE_J.*			Japanese Title image related files
	TITLE_U.*			USA Title image related files

(Included from outside the directory)
../../src/inc/neogeo.inc		Neo-Geo hardware defines
../../src/inc/ram_bios.inc		Neo-Geo BIOS RAM location defines

================================================================================
[Setup]

<Palette>
In order to see anything displayed on the screen, you'll need to set some color
values in the palette first. Since this demo is simple, we won't need to be too
complex when it comes to the palette.

The Neo-Geo has two banks of palette RAM, each holding 4096 colors worth of data.
The system's palette RAM lives at $400000-$401FFF, and the active palette page
can be swapped by writing to either the PALETTE_BANK0 register ($3A001F) or the
PALETTE_BANK1 register ($3A000F). Despite the names, values from PALETTE_BANK1
will appear first in MAME/MESS's palette viewer.

The palette RAM is divided into 256 sets of 16 colors (15 real, 1 transparent).
Of these 256 sets, only the first 16 sets can be used with the Fix Layer.
Sprites can use any color set.

In this example, we'll only be using 4 sets of palettes with 3 colors each.
One is considered transparent, and the other two are active colors.

Dealing with the palette colors is a bit complex, but for now, let's just treat
it as a 12-bit color with values of $0000 to $0FFF.
This maps to $0RGB, where R is Red, G is Green, and B is Blue.

The palette is explained in further detail in Example 03: Palette Basics.

<Fix Layer>
We must first understand the Fix Layer before we can draw to it. The Neo-Geo's
Fix Layer is a set of 8x8 pixel cells that display over everything else on
screen. As such, they're primarily used for game HUD elements.

In VRAM, the Fix layer lives from $7000-$7400. Tiles go vertically by default,
so the "normal order" may not be what you expect.

VRAM Addr.	Fix Tile Cell
-------------------------
$7000		x=0,y=0
$7001		x=0,y=1
$7020		x=1,y=0

The actual data for each cell consists of the following:
* Palette (0-F)
* Tile Number Upper Nibble (0-F)
* Tile Number Lower Byte (00-FF)

================================================================================
[Process]
There are two ways of writing tiles on the Fix Layer:
1) Doing it yourself with writes to the LSPC registers.
2) Letting the BIOS handle it via MESS_OUT.

This demo uses both methods of displaying tiles on the Fix Layer.

<LSPC Registers>
Writing directly to the LSPC registers may be a bit more familiar for those
coming off of programming other retro game consoles, as you end up setting
an address, the increment size, and then write the data to a register.

The key LSPC registers are as follows:

Address		Friendly Name	Description
-------------------------------------------
$3C0000		LSPC_ADDR		VRAM Address
$3C0002		LSPC_DATA		VRAM Data
$3C0004		LSPC_INCR		VRAM Increment

Since this seems to be the only reliable way to write to the sprite sections of
VRAM, you'll want to know how to write to the LSPC registers eventually.
But that's another story for another time...

When writing to the Fix layer, the value written to LSPC_ADDR will be between
$7000 and $73FF (unless you're using Fix bankswitching, which we're not).

LSPC_INCR can be many values, but the two most common are 1 (vertical writes)
and 0x20 (32 decimal; horizontal writes).

When LSPC_INCR and LSPC_ADDR are correctly set, you can just throw words at
LSPC_DATA to write them to VRAM.

<MESS_OUT>
The Neo-Geo BIOS has a function called MESS_OUT which outputs tiles on the Fix
layer. Compared to writing everything to the registers yourself, MESS_OUT
operates on a set of commands. Explaining MESS_OUT in full is beyond the scope
of this file; you will want to check the Neo-Geo Development Wiki's page on it:
https://wiki.neogeodev.org/index.php?title=MESS_OUT

In this example, we are writing directly to the buffer that MESS_OUT reads.
It's also possible to create a pre-made set of commands and use those as well.

The first thing that's done before we can write data for MESS_OUT is to set
the BIOS_MESS_BUSY flag. Then, BIOS_MESS_POINT is loaded into a0, which we will
use for adding data that MESS_OUT reads.

; writing data

Once we're finished writing the data, we update BIOS_MESS_POINT to point to the
new value of a0 (after all our additions), then clear the BIOS_MESS_BUSY flag.

MESS_OUT operates on a set of commands interspersed with data.
Some important commands that you'll want to know are as follows:
$0001		Data Format
$0002		Set VRAM increment			$0002, ($0001,$0020,etc.)
$0003		Set VRAM address			$0003, ($7000-$73FF)
$0005		Add to VRAM address			$0005, ($0001,$0020,etc.)
$0007		8x8 Output
$0008		8x16 Output

(Command 1: Data Format)
; todo

(Command 7: 8x8 Output)
Command $07 writes 8x8 tiles to the Fix layer.

(Command 8: 8x16 Output)
Command $08 writes 8x16 tiles to the Fix layer. The first tile is determined by
the index and page given, while the second tile is on the next page after that.

With MESS_OUT, there are two ways of displaying the result:
1) Doing a manual "jsr MESS_OUT".
2) Having MESS_OUT be called in the vblank/INT1.
This example uses the second method, so proper handling of the flags is needed.

================================================================================
[Emulator Compatibility]
I don't have real hardware to test on, so someone else is going to have to let
me know how that works out. Please do, if you get a chance.

<Cart>
In MAME, the game will work as long as you:
1) Have the game in the software list. An example softlist entry is provided.
2) Call the game properly:
	mame64 neogeo 01_helloFix				(Load example 1 in MVS mode)
	mame64 neogeo -cart1 01_helloFix		(Load example 1 in multi-slot MVS mode)
	mame64 aes 01_helloFix					(Load example 1 in AES mode)

<CD>
The ISO for the CD version is known to work on:
* Raine32 0.63.7-2
* NeoCD/SDL 0.3.1

MESS and Final Burn Alpha 0.2.97.29 treat the ISO the same; they can't load it.
Perhaps my image is messed up?


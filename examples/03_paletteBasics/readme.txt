freemlib for Neo-Geo Example 03: Palette Basics
================================================================================
[Introduction]
In the first two examples, we've glossed over the palettes, since we weren't
doing much with them. This example is dedicated to the palette, both on the
technical side and on the freemlib side.

================================================================================
[Files]
(In the directory)
readme.txt				This file!

(Sub-directories)
fixtiles/				fix layer tilesets
	202-s1.s1			Fix Layer S ROM
sprtiles/
	202-c1.c1			C ROM 1/2
	202-c2.c2			C ROM 2/2
	in.smc				Source of C ROM (SNES format graphics; convert with recode16)

(Included from outside the directory)
../../src/inc/neogeo.inc		Neo-Geo hardware defines
../../src/inc/ram_bios.inc		Neo-Geo BIOS RAM location defines
../../src/inc/mess_macro.inc	Macros for MESS_OUT
../../src/func/palette.inc		Palette-related Functions and Macros
../../src/func/sprites.inc		Sprite-related Functions and Macros

================================================================================
[Setup]

<Palette>
The entire point of this demo is the palette, so we're going to go into a little
more detail here.

In the very first example, we pretended that palette values were 12-bit,
ignoring the color's top nybble. This system was explained as "$0RGB". The way
the colors actually work on the Neo-Geo is different; you'll soon see why I had
you dealing with simplified colors.

A palette entry on the Neo-Geo takes the form of the following:
drgbRRRRGGGGBBBB
Where:
* d			"dark bit"/RGB-1, shared across all channels.
* r			Red, bit 0
* g			Green, bit 0
* b			Blue, bit 0
* RRRR		Red, bits 1-4
* GGGG		Green, bits 1-4
* BBBB		Blue, bits 1-4

When interpreted in this fashion, each channel has values between 0-31 without
taking the Dark Bit/RGB-1 into account. Accounting for the dark bit gives us 0-63
total values per channel. Since the Dark Bit subtracts 1 from all channels,
certain colors can not be shown on the Neo-Geo.

Up until recently (2014), emulators and tools treated the Neo-Geo color space as
a linear, continuous mapping. However, the real console doesn't treat the color
space in this way. Check this thread on yAronet for more information:
http://www.yaronet.com/posts.php?sl=0&s=163491&p=1&h=20#20

Through the first three examples, the palette setup has been passed over in terms
of a thorough explanation. However, each example has had the palette loading code
in userReq_Game, so let's take a look:
{
	; set up palettes
	move.b	d0,PALETTE_BANK1	; use palette bank 1
	lea		paletteData,a0
	lea		PALETTES,a1
	move.l	#(16*NUM_PALETTES)-1,d7
.ldpal:
	move.w	(a0)+,(a1)+
	dbra	d7,.ldpal
}

The first thing that's done is to tell the Neo-Geo we're using Palette Bank 1.
After that, the address of paletteData (defined in paldata.inc) is put into a0,
and the beginning of the Neo-Geo's Palette RAM is put into a1.

Getting the values into the palette is done with a loop. d7 is the register with
the loop counter, and it is set to (16*NUM_PALETTES)-1.

NUM_PALETTES is defined in paldata.inc; the value is multiplied by 16 since each
palette set has 16 colors. This could also be done with a left shift, but I'm lazy.
Finally, the loop counter is decremented by 1 to provide the necessary 0,n-1
range for dbra to work properly.

While all of this is done manually, there are some freemlib helpers available:

pal_LoadData loads raw color data into the palette RAM. The parameter list is
provided below; these registers will need to be set before calling pal_LoadData.
d7		Number of color entries-1
a0		Address to load palette data from
a1		Beginning palette address to load data into ($400000-$401FFE)

palmac_LoadData is also available, for even lazier people.
Macro parameters \1 through \3 are the same as pal_LoadData, so this code:

	palmac_LoadData		(16*NUM_PALETTES)-1,paletteData,PALETTES

would be equivalent to the loop above (assuming you have the palette functions
included before it's called).

================================================================================
[Process]
This example displays a number of sprites with different palettes.

Since I am lazy, the main sprite setup code (displaying 15 sprites horizontally)
is taken from my Palette Test Tool, which was written before most of the freemlib
for Neo-Geo.

; player input palette change

; palette actions from freemlib
; * color index cycling
; * color animations

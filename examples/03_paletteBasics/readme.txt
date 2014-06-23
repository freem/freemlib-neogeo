freemlib for Neo-Geo Example 03: Palette Basics
================================================================================
[Introduction]
In the first two examples, we've glossed over the palettes, since we weren't
doing much with them. This example is dedicated to the palette.

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

================================================================================
[Process]

freemlib for Neo-Geo Example 02: Hello World on the Sprite Layer
================================================================================
[Introduction]
After learning how to manipulate the fix layer, the next thing you'll want to
learn how to manipulate is sprites. On the Neo-Geo, sprites are pretty much
everything. There's a number of neat features included in the LSPC chip that I
can't recall existing on any other early to mid-1990s 2D-focused platform,
including automatic animation and sprite chaining capabilities.

Since sprites are not nearly as easy to deal with as the fix layer, we will be
using some of the freemlib functionality in this example.

================================================================================
[Files]
(In the directory)
_c-asm68k.bat			Batch file for compiling with asm68k
_c-vasm68k.bat			Batch file for compiling with vasm (68k, mot syntax; executable renamed to "vasm86k")
_c-vasm68k.sh			Shell script for compiling with vasm (68k, mot syntax; executable renamed to "vasm86k")
02_helloSpr.asm			Main file
header_68k.inc			68000 Vectors
header_cart.inc			Neo-Geo cartridge header
ram_user.inc			User space RAM ($100000-$10F2FF)
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
../../src/inc/sprites.inc		Sprite-related Functions and Macros

================================================================================
[Setup]

<Palette>
In order to see anything displayed on the screen, you'll need to set some color
values in the palette first. If that sentence seems familiar, that's because it
is. We're using the exact same palette as the first example because the graphics
I've provided are pretty simple.

<Fix Layer>
Remember how I said the fix layer displays over everything else? Well, with this
example, we can prove it. However, that requires being able to move the sprite
around, and for that, we need... input.

<Input>
Much like writing to the fix layer, there's two ways of handling input.
1) Handling everything yourself.
2) Calling SYSTEM_IO every vblank/INT1 and reading the BIOS RAM values.

I'm sure you'll guess which method is easier to deal with (and therefore which
method this example uses). If not, rest assured that SYSTEM_IO really is up to
the task of handling the system input.

We're only going to worry about Player 1's inputs in this example.
Here are the relevant BIOS RAM locations:

Address		Friendly Name		Description
----------------------------------------------------------------
$10FD94		BIOS_P1STATUS		(byte) Controller 1 status
$10FD95		BIOS_P1PREVIOUS		(byte) Inputs from last frame
$10FD96		BIOS_P1CURRENT		(byte) Inputs from current frame
$10FD97		BIOS_P1CHANGE		(byte) Active-edge input
$10FD98		BIOS_P1REPEAT		(byte) Auto-repeat flag
$10FD99		BIOS_P1TIMER		(byte) Input repeat timer
$10FDAC		BIOS_STATCURNT		(byte) Start and Select from current frame
$10FDAD		BIOS_STATCHANGE		(byte) Start and Select active-edge input

SNK was really nice and gave us a way to handle repeating input (BIOS_P1REPEAT),
so we're going to use that for moving the sprite. Pressing buttons to do things
would require a bit more sensitivity, so BIOS_P1CHANGE is the variable for the
job there.

<Sprites>
Sprite data also lives in VRAM; in fact, it takes up most of the VRAM space.
The primary sprite data is sectioned off into chunks called Sprite Control
Blocks, or "SCB" for short.

Address Range	Friendly Name	Description
------------------------------------------------------------------------
$0000-$6FFF		SCB1			Tilemaps, Palette, Auto-Anim., H/V Flip
$8000-$81FF		SCB2			Shrinking Coefficients
$8200-$83FF		SCB3			Y Position, Sticky Bit, Sprite Size
$8400-$85FF		SCB4			X Position
$8600-$867F		?				Sprite List Even Scanlines
$8680-$86FF		?				Sprite List Odd Scanlines

================================================================================
[Process]

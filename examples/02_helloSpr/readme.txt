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
../../src/func/sprites.inc		Sprite-related Functions and Macros
../../src/inc/input.inc			Input-related defines

================================================================================
[Setup]

<Palette>
In order to see anything displayed on the screen, you'll need to set some color
values in the palette first. If that sentence seems familiar, that's because it
is. We're using the exact same palette as the first example because the graphics
I've provided are pretty simple.

<Fix Layer>
Remember how I said the fix layer displays over everything else? Well, with this
example, we can prove it. However, to properly display that, we need to be able
to move the sprite around... Time to take a crash course in input.

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

While you might think BIOS_P1REPEAT will be the best choice for handling
continuous input, BIOS_P1CURRENT actually provides smoother movement, so we're
going to use that for moving the sprite. Pressing buttons to do things would
require a bit more sensitivity, so BIOS_P1CHANGE is the variable for the job there.

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
This demo uses multiple techniques to display sprites:
1) Manual writes to VRAM		"Hello"
2) freemlib spr_Load			Movable rectangle (single sprite)
3) freemlib mspr_Load			"World!!!" (metasprite)

The only way to properly learn how this system works is if you go through it in
order, as all parts build on the previous sections.

--------------------------------------------------------------------------------
<Manual VRAM Writes> a.k.a. "the long way"
To set up a sprite in the VRAM, you normally write values to the various parts
of VRAM, like you would when you put tiles on the fix layer.

Each sprite in SCB1 has $40 (64) bytes for tilemaps, so the first few sprites
map out to these VRAM addresses:

SCB1 Sprite 000		$0000 (You don't want to use sprite 0, however.)
SCB1 Sprite 001		$0040
SCB1 Sprite 002		$0080
SCB1 Sprite 003		$00C0
SCB1 Sprite 004		$0100
SCB1 Sprite 005		$0140
SCB1 Sprite 006		$0180
SCB1 Sprite 007		$01C0
SCB1 Sprite 008		$0200
SCB1 Sprite 009		$0240
SCB1 Sprite 010		$0280
SCB1 Sprite 011		$02C0
SCB1 Sprite 012		$0300

The data that goes into SCB1 consists of two words per tile.

Even words are the least significant byte of the tile numbers.

FEDCBA9876543210
||||||||||||||||
++++++++++++++++- Tile Number LSB

Odd words are the attributes, which includes the most significant bits of the
tile numbers.

FEDCBA9876543210
||||||||||||||||
|||||||||||||||+- Horizontal Flip
||||||||||||||+-- Vertical Flip
||||||||||||++--- Auto-Animation (2-bit, 3-bit; exclusive)
||||||||++++----- Tile Number MSB
++++++++--------- Palette index

SCB2-4 are a bit easier to deal with, as each sprite only has one corresponding
word in the VRAM.

SCB2 is the Shrinking Coefficient. As was mentioned, the Neo-Geo doesn't actually
zoom sprites; it can only shrink them.

Horizontal shrinking values are $0-$F. Vertical shrinking values are $00-$FF.
Note: Horizontal shrink values do not propagate through chained sprites.

FEDCBA9876543210
    ||||||||||||
    ||||++++++++- Vertical Shrink
    ++++--------- Horizontal Shrink

SCB3 is the most complex of the three secondary SCB sections, as it controls
three parameters. The Y value is offset from 496, for some reason I can't comprehend.

FEDCBA9876543210
||||||||||||||||
||||||||||++++++- Sprite Height in tiles (33=32 tiles; loops borders when shrinking)
|||||||||+------- Sticky Bit
+++++++++-------- Y value ((496-Y)<<7)

SCB4 is the X value shifted to the right 7 places.

FEDCBA9876543210
|||||||||
|||||||||
+++++++++-------- X value (X<<7)

After throwing about 30 lines of code in, you're probably wondering if there's a
better way of doing it. That's where the freemlib comes in.

--------------------------------------------------------------------------------
<spr_Load>
The spr_Load function is meant to load a single Sprite into the relevant VRAM
sections. It relies on two helper macros to put data in the binary, which we'll
cover in a second.

spr_Load takes two parameters:
	d0		Sprite Index (0-511; 0 is not recommended!)
	a0		Pointer to Sprite Data Block

Sprite Data Blocks are generated by the sprmac_SpriteData macro.

(sprmac_SpriteData)
sprmac_SpriteData is a macro that inserts Sprite Data Blocks into the binary.
The example uses this macro to construct the "World!!!" metasprite.

It takes in 6 parameters:
1) (word) Sprite Height (in tiles)
2) (word) X position (9 bits)
3) (word) Y position (9 bits)
4) (long) Pointer to SCB1 tilemap data
5) (byte) Horizontal Shrink ($0-$F)
6) (byte) Vertical Shrink ($00-$FF)

These values are then transformed into formats that the VRAM likes (aside from
SCB1 data, which is already in that format).

(sprmac_SCB1Data)
sprmac_SCB1Data is a macro that inserts SCB1 tilemap data into the binary.
These blocks are pointed to in Sprite Data Block definitions in order to provide
VRAM-friendly SCB1 data.

It takes in 5 parameters:
1) (long) Tile Number (20 bits)
2) (byte) Palette Number (8 bits)
3) (byte) Auto-Animation (valid values are 0=none, 4=2bit, 8=3bit)
4) (byte) Vertical Flip (0/1)
5) (byte) Horizontal Flip (0/1)

--------------------------------------------------------------------------------
<mspr_Load>
The combination of a Sprite Data Block and a SCB1 tilemap data section create a
single Sprite. Sometimes, though, you're going to need more than one Sprite to
create an object. That's where metasprites come in.

mspr_Load takes two parameters:
	d0		Metasprite starting sprite index
	a0		Pointer to Metasprite Data Block

The "metasprite starting sprite index" determines where the sprite goes in VRAM.

Metasprite Data Blocks are simple compared to the other Sprite-related blocks:

1) (word) Number of Sprites in Metasprite
2) (long) First Sprite Data pointer
..
end) (long) Last Sprite Data pointer

Where "end" is based on the value written to 1).

mspr_Load basically handles setting up multiple Sprites for you, as well as
setting the Sticky bit for Sprites that need it.

--------------------------------------------------------------------------------
Up to this point, we've covered getting Sprites on the screen, but not really
moving or changing them. Now's a good time to go over some input basics.

There's a quick input routine (CheckInput) hacked together to do two things:
1) Move the rectangular box sprite around with the Player 1 joystick.
2) Change the palette between 4 choices with the Player 1 A button.

In order to read the input values from the BIOS, we need to call SYSTEM_IO once
every frame. Having it in our VBlank (and having the VBlank interrupt enabled)
ensures this happens.

With the call to SYSTEM_IO in place, putting a call to a routine where you handle
input in the main loop is the next step. In this routine, you end up masking the
values from the BIOS against values from src/inc/input.inc in order to find out
if anything was pressed.

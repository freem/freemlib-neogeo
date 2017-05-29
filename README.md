freemlib for Neo-Geo
====================
The freemlib for Neo-Geo is a set of functions and tools for those who want to
develop for the system in assembly language. Adapting the functions into a library
for use with C is planned, but I won't be doing so myself until the codebase is
better developed and battle tested.

Status
------
The primary goal right now is to get the library coded, as well as provide
examples that use the library. Overall, the tasks can be broken down as follows:

(All percentage completions are estimates as of 2015/11/13. No project is ever truly finished. :wink:)

### Library ###
These elements form the core of the freemlib for Neo-Geo.

* **Animation** &ndash; Sprite animation. 0%.
* **Backgrounds** &ndash; Routines for background sprites. 0%.
* **Collision** &ndash; Most every game needs some sort of collision. 0%.
* **Fix** &ndash; Fix layer functionality. Still needs work, ~23%?
* **Memory Card** &ndash; Handle Memory Cards (also Neo-Geo CD Backup Memory). 5%, needs testing.
* **Palette** &ndash; Palette functionality. ~10%.
* **Sound** &ndash; Fully-featured (FM, SSG, both ADPCM types, CD/DA) Z80 sound engine. 4%.
* **Sprites** &ndash; General sprite functionality. ~15%?, with restructuring to come.
* **System** &ndash; Various system functions. 1%.

Am I missing anything? Please let me know. (Input routines for non-standard controllers
and for other purposes might be provided later.)

### Tools ###
Various tools to help you produce content for the Neo-Geo. Special consideration
should be made for Linux (and OS X) compatibility whenever possible.

#### Available and/or Finished ####
* **NeoFixFormat** &ndash; Fix format tiles plugin for YY-CHR.NET. 100%, unless a bug comes up.
* **Sailor VROM** &ndash; V ROM/.PCM file builder and manager. 25%, but usable. ([Lua version available](https://github.com/freem/freemlib-neogeo/tree/master/tools/sailorvrom/lua))
* **4BPP SMS/GG/WSC to Neo-Geo ".c0" Format tool** &ndash; 100% for the time being. ([project repository](https://github.com/freem/NeoSpriteConv))

#### WIP ###
* **FM Studio** &ndash; On-console utility for testing and developing FM sounds. 1% (earliest stages of development)
* **NeoGeoTracker** &ndash; On-console tracker and sound driver testbench. 0% (mockups and planning stage, might take a while)
* and others not listed here...
 * A tool for Fix layer layout, similar to Shiru's NES Screen Tool. 0%
 * A tool for animation data (various tools exist already, I'm aware.) 0%
 * A tool for converting Tiled map data. 0%
 * PC version of NeoGeoTracker. 0%
 * Various sound tools (ADPCM-A/B conversion; tools exist, but need unification.) ?%

### Documentation ###
The black sheep of any programming project, but also necessary because who the hell
is going to read a bunch of ASM to figure out the library? My main problem is that
I only really want to write it once.

* **Library Docs (text)** &ndash; The straight dope. See `doc/` folder.
* **Library Docs (HTML)** &ndash; The pretty version. Still very WIP.
* **Neo-Geo Programming Guide** &ndash; think of the Nerdy Nights (NES) tutorials,
but for Neo-Geo. The examples kind of cover this, but aren't nearly as accessible...

Navigation
----------
* `cdfiles/` &ndash; Files required for Neo-Geo CD games (aside from `IPL.TXT`)
* `doc/` &ndash; Documentation (both general and freemlib related)
* `examples/` &ndash; freemlib Usage Examples
* `src_68k/` &ndash; Main freemlib library code.
* `src_z80/` &ndash; freemlib sound engine code.
* `tools/` &ndash; Various tools.

You should read `doc/usage.txt` for how to setup a project with the freemlib.

Filing Bugs/Issues
------------------
Please use the [GitHub bug tracker](https://github.com/freem/freemlib-neogeo/issues)
to file any errors, issues, and/or feature requests.

License
-------
The freemlib for Neo-Geo is licensed under the [ISC License](http://opensource.org/licenses/ISC).
Full terms may be found in the "LICENSE" file.
Tools may be licensed differently from the main library, see each project for licensing details.

Contact
-------
The best way to reach me about this project is via IRC:
* chat.freenode.org &ndash; #neogeodev
* irc.clearimagery.net &ndash; #ssc

but if IRC isn't your thing, you might want to try one (or more) of these options:
* [Yaronet forums](http://www.yaronet.com/en/sujets.php?f=417)
* via e-mail: ajk187 at gmail (bad for attachments; contact me first without them
if you want to send any)

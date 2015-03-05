Sailor VROM (Lua version) | v0.11 by freem
================================================================================
Real coders would tell me to write this in C, but screw parsing text files in C.
(This script should work on Lua 5.1 and Lua 5.2; Lua 5.3 has not been tested.)
================================================================================
[Introduction]
Sailor VROM is a Neo-Geo V ROM/.PCM file builder.

No, this won't encode ADPCM samples for you.

An ADPCM-B encoder is available on the Internet, and I have it on good authority
that an open source and portable ADPCM-A encoder will be available as soon as
its output is verified working on hardware and produces good enough quality.
Don't ask me how I know.

================================================================================
[Sample Lists]
The sample lists that the program expects are simple text files, with one sound
path/filename per line.

The ADPCM-B sample list requires the sampling rate (between 1800Hz and 55500Hz)
as well each filename, being separated with a pipe character ('|').

An example of an ADPCM-B sample entry with a default sampling rate of 22050Hz:
example.pcmb|22050

================================================================================
[Usage]
lua svrom.lua (options)

[Options]
As of version 0.10, the program handles the command line differently.

Possible options you can pass to the program:

--pcma=(path to adpcm-a list)
Sets the ADPCM-A sample list. (required)

--pcmb=(path to adpcm-b list)
Sets the ADPCM-B sample list. Ignored if mode is set to cd. (optional)

--outname=(path to sound rom output file)
Sets the output path/filename for the V ROM/.PCM file. (optional)
(default "output.v" for cart, "output.pcm" for cd)

--samplelist=(path to sample list output file)
Sets the output path/filename for the sample list. (default "samples.inc")

--mode=("cart" or "cd" without the quotes)
Sets up the output type. (optional)
(default "cart")
 * CD mode will enforce the ignoring of ADPCM-B.
 * CD mode will eventually force an upper limit of 512KiB per .PCM file.

--slformat=("vasm", "tniasm", or "wla")
Sets the sample list to output in a specific format:
 * vasm:   word	0x0000,0x00CE (vasm oldstyle syntax)
 * tniasm: dw	$0000,$00CE   (tniasm syntax)
 * wla:    .dw	$0000,$00CE   (WLA syntax)

================================================================================
[Notes]
* This program will pad your samples with 0x80 (silence) if necessary, if your
  original ADPCM encoding tool hasn't done so already. As this happens only
  during processing, the original sample files are untouched.

* The PCM-B list _only_ accepts sampling rates in Hertz. If you enter "44.1"
  expecting 44.1KHz (instead of 44100), don't be surprised when everything
  sounds wrong (unless you re-calculate the Delta-N value yourself).

================================================================================
[To-Do]
Many things.
* TEST OUTPUT!
  I still haven't tested the output, even after jumping to v0.11.
  If you aren't me and you see this message, you should probably panic.

  However, I did a quick spot check using the data from smkdan's ADPCM-A demo,
  and the file and sample addresses checked out. (Still needs system testing.)

* Sample size checking (e.g. if something will be too big)

* Output size checking
 * .PCM files: max 512KiB
 * V ROMs: max 16MiB total (max configs: 4 x 4MiB [typical], 2 x 8MiB [ca.2002])

* Detecting sample boundary crossings and fixing them (rearranging samples)

================================================================================
[Future Options]
These might appear in a future version of the program.

--maxsize=(positive integer, "kilobytes" [actually kibibytes, value*1024])
Specifies the maximum size of a sound data output file.
(default: ????) (maximum on cart: 8192KiB (8MiB), maximum on cd: 512KiB)

================================================================================
[Output Configurations]
This is fun (not)

<Early Carts>
ADPCM-A and ADPCM-B in separate V ROMs

<PCM Chip Carts>
8192KiB (or more?) maximum per chip?

"On some Cartridge boards, V A20~V A22 can be used to select which of the 4
possible V ROMs to use" - NeoGeo Dev Wiki

<16 Megabytes>
* 4x4 MiB configuration
* 2x8 MiB configuration (only possible with NEO-PCM2?)

<NeoBitz PROGBITZ1>
Supposedly this board can support 32MiB (banked?) V ROMs, along with a more
conventional 16MiB. All of this without a NEO-PCM chip in sight, though the only
known game released on the board so far uses a single 8MiB chip.

<Neo-Geo CD>
Maximum File Size: 512KiB?
Banks: 2x512KiB (1 Megabyte total)

Sailor VROM (Lua version) | v0.02 by freem
================================================================================
Real coders would tell me to write this in C, but screw parsing text files in C.
================================================================================
[Introduction]
Sailor VROM is a Neo-Geo V ROM/.PCM file builder.

What this doesn't do:
* Sample encoding (out of scope)
* Pad samples with a non-power of two length (yet)

================================================================================
[Usage]
lua svrom.lua (pcmaList) [pcmbList] [outFile] [listFile]

pcmaList is a text file containing paths to ADPCM-A encoded samples.

pcmbList is a text file containing paths to ADPCM-B samples and their default
sampling rates (between 1800Hz-55500Hz), separated by a pipe character ('|').

An example of an ADPCM-B entry at 22050Hz:
example.pcmb|22050

outFile is the name of the output V ROM/.PCM file.

listFile is the name of the generated include file with the sample addresses.

--------------------------------------------------------------------------------
Yes this is cumbersome and I should really do proper options parsing, but this
is what you get with early versions/lazily coded software.

================================================================================
[To-Do]
Many things.
* TEST OUTPUT, I'm back, but still haven't tested it; if you aren't me and you
  see this message, panic.

* Pad non-power of two size samples with 0x80, in case your encoder doesn't.
* Sample size checking (e.g. if something will be too big)
* Output size checking (e.g. max 512KB per .PCM; max ?? per V ROM, 16MB total)
* Detecting sample boundary crossings and fixing them (rearranging samples)
* Support different syntaxes for sample list include file

Sailor VROM (Lua version) | v0.1 by freem
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
lua svrom.lua (pcmaList) [pcmbList] {outFile} {listFile}

pcmaList is a text file containing paths to ADPCM-A encoded samples.

pcmbList is a text file containing paths to ADPCM-B samples and their default
sampling rates (between 1800Hz-55500Hz), separated by a pipe character ('|').

An example of an ADPCM-B entry at 22050Hz:
example.pcmb|22050

Currently, there is no way to customize the output filenames, because I'm lazy
and this is a quickly rushed v0.1 release. Mentions of {outFile} and {listFile}
above are for my own documentation until I put them in the program.

================================================================================
[To-Do]
Many things.
* TEST OUTPUT, I'm quietly releasing this before I head out for a bit and don't
  have the time to actually test this until I get back; if you aren't me and you
  see this message, panic.

* Support for naming output files
* Pad non-power of two size samples with 0x80, in case your encoder doesn't
* Sample size checking (e.g. if something will be too big)
* Output size checking (e.g. max 512KB per .PCM; max ?? per V ROM, 16MB total)
* Detecting sample boundary crossings and fixing them (rearranging samples)
* Support different syntaxes for sample list include file

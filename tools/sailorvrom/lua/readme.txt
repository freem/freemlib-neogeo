Sailor VROM (Lua version) | v0.03 by freem
================================================================================
Real coders would tell me to write this in C, but screw parsing text files in C.
================================================================================
[Introduction]
Sailor VROM is a Neo-Geo V ROM/.PCM file builder.

No, this won't encode ADPCM samples for you.

An ADPCM-B encoder is available on the Internet, and I have it on good authority
that an open source and portable ADPCM-A encoder will be available as soon as
its output is verified working on hardware and produces good enough quality.
Don't ask me how I know.

================================================================================
[Usage]
lua svrom.lua (pcmaList) [pcmbList] [outFile] [listFile]

pcmaList is the path to a text file containing paths to ADPCM-A encoded samples,
one per line.

pcmbList is the path to a text file containing paths to ADPCM-B samples and
their default sampling rates (between 1800Hz-55500Hz), separated by a pipe
character ('|').

An example of an ADPCM-B entry (filename "example.pcmb") at 22050Hz:
example.pcmb|22050

outFile is the name of the output V ROM/.PCM file.

listFile is the name of the generated include file with the sample addresses.

--------------------------------------------------------------------------------
Yes, this is cumbersome, and I should really do proper options parsing,
but this is what you get with early versions of lazily coded software.

================================================================================
[Notes]
* This program will pad your samples with 0x80 (silence) if necessary, if your
  original ADPCM encoding tool hasn't done so already. As this happens only
  during processing, the original sample files are untouched.

* In order to pass in the "outFile" and "listFile" parameters, you will need to
  have the pcmbList option as well. Yes, I know this is awkward, see above.

* If the PCM-B list file does not exist, the program will continue in "CD mode",
  meaning the file will have a default extension of ".PCM" instead of ".V".
  CD mode is also meant to have an upper file size limit of 512KiB, but this is
  not yet implemented.

* The PCM-B list _only_ accepts sampling rates in Hertz. If you enter "44.1"
  expecting 44.1KHz (instead of 44100), don't be surprised when everything
  sounds wrong (unless you re-calculate the Delta-N value yourself).

================================================================================
[To-Do]
Many things.
* TEST OUTPUT, I still haven't tested the output, 0.03 versions in; if you
  aren't me and you see this message, you should panic.

* Sample size checking (e.g. if something will be too big)
* Output size checking (e.g. max 512KiB per .PCM; max ?? per V ROM, 16MiB total)
* Detecting sample boundary crossings and fixing them (rearranging samples)
* Support different syntaxes for sample list include file

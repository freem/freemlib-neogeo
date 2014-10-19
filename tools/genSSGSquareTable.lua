-- genSSGSquareTable for Lua 5.1 (code by freem)
-- Generates a text table of SSG tone periods from a table of hertz values.
-- usage: lua genSSGSquareTable.lua > outfile.txt
-- license: public domain/CC0/Unlicense/WTFPL/I explicitly do not give a fuck about my copyright on this code and invite you to feel the same way

-- todo: take inspiration from http://wiki.nesdev.com/w/index.php/APU_period_table

local hzValues = {
	16.352,   17.324,  18.354,  19.445,  20.602,  21.827,  23.125,  24.500,  25.957,  27.500,  29.135,  30.868,
	32.703,   34.648,  36.708,  38.891,  41.203,  43.654,  46.249,  48.999,  51.913,  55.000,  58.270,  61.735,
	65.406,   69.296,  73.416,  77.782,  82.407,  87.307,  92.499,  97.999,  103.83,  110.00,  116.54,  123.47,
	130.81,   138.59,  146.83,  155.56,  164.81,  174.61,  185.00,  196.00,  207.65,  220.00,  233.08,  246.94,
	261.63,   277.18,  293.66,  311.13,  329.63,  349.23,  369.99,  392.00,  415.30,  440.00,  466.16,  493.88,
	523.25,   554.37,  587.33,  622.25,  659.26,  698.46,  739.99,  783.99,  830.61,  880.00,  932.33,  987.77,
	1046.5,   1108.7,  1174.7,  1244.5,  1318.5,  1396.9,  1480.0,  1568.0,  1661.2,  1760.0,  1864.7,  1975.5,
	2093.0,   2217.5,  2349.3,  2489.0,  2637.0,  2793.8,  2960.0,  3136.0,  3322.4,  3520.0,  3729.3,  3951.1,
	4186.0,   4434.9,  4698.6,  4978.0,  5274.0,  5587.7,  5919.9,  6271.9,  6644.9,  7040.0,  7458.6,  7902.1,
	8372.0,   8869.8,  9397.3,  9956.1, 10548.1, 11175.3, 11839.8, 12543.9, 13289.8, 14080.0, 14917.2, 15804.3,
	16744.0, 17739.7, 18794.5, 19912.1, 21096.2, 22350.6, 23679.6, 25087.7, 26579.5, 28160.0, 29834.5, 31608.5
}

local noteNames = {
	"C-", "C#", "D-", "Eb", "E-", "F-", "F#", "G-", "Ab", "A-", "Bb", "B-"
}

local octave = 0
local masterClock = 8000000

print("Value\t\tEquation\t\t\tHertz\t\t\t\tClosest Note/Octave")
print("=======================================================================")

for i=1,#hzValues do
	local hertz = hzValues[i]
	local tp = (masterClock/(64*hertz))

	local noteIndex = noteNames[i%12]
	if not noteIndex then noteIndex = noteNames[12] end

	local note = string.format("%s%i",noteIndex,octave)

	-- add "valid value" separator
	-- (xxx: uses hardcoded values.
	-- you'll need to edit the "4048" number if you change the hertz values above.
	-- 4096 maps to $1000, which is the beginning of the invalid values.)
	if tp >= 4048 and tp < 4096 then
		print("===[begin valid values]================================")
	end

	-- fixing output (my tab width is 4)
	local tab1, tab2 = "",""
	if tp*64 < 100000 then tab1 = "\t"
	else tab1 = ""
	end
	if hertz > 10000 then tab2 = "\t\t"
	else tab2 = "\t\t\t"
	end

	-- main print line
	print(string.format("$%03X\t\t(8000000/%i)%s\t%f%s%s", tp,tp*64,tab1,hertz,tab2,note))

	-- octave separator
	if i % 12 == 0 then
		octave = octave + 1
		print("-------------------------------------------------------")
	end
end

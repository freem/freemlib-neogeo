-- Sailor VROM (Lua version) by freem
--============================================================================--
local verNum = 0.01
local pcmbSeparator = "|"
local args = {...}

local function sortBySize(c1,c2) return c1.Length < c2.Length end

print("Sailor VROM - Neo-Geo V ROM/.PCM File Builder (Lua version)");
print(string.format("v%.02f by freem",verNum))
print("===========================================================");

if not args then
	print("No arguments found.")
	print("usage: lua svrom.lua (pcmalist) [pcmblist]")
	return
end

--============================================================================--
local pcmaListFN = args[1]
local pcmbListFN = nil
local cdMode = false
local sizeWarn = ""

if #args > 1 then
	-- pcmb list passed in as well
	pcmbListFN = args[2]

	-- todo: check for other arguments (output file, listing file)
else
	-- no pcmb list, force cd mode on
	print("[Note] No ADPCM-B list provided; assuming .PCM creation for Neo-Geo CD\n")
	cdMode = true
end

--============================================================================--
-- adpcm-a
local pcmaFiles = {}

local pcmaListFile, pcmaFileError = io.open(pcmaListFN,"r")
if not pcmaListFile then
	print(string.format("Error attempting to open ADPCM-A list file %s",pcmaFileError))
	return
end

print("[ADPCM-A Samples]")
local pcmaTempFile, pcmaTempLen
local pcmaCount = 1

for s in pcmaListFile:lines() do
	-- try loading file
	pcmaTempFile, pcmaFileError = io.open(s,"rb")
	if not pcmaTempFile then
		print(string.format("Error attempting to load ADPCM-A sample %s",pcmaFileError))
		return
	end

	-- get file length
	pcmaTempLen, pcmaFileError = pcmaTempFile:seek("end")
	if not pcmaTempLen then
		print(string.format("Error attempting to get length of ADPCM-A sample %s",pcmaFileError))
		return
	end

	pcmaTempFile:seek("set")

	if pcmaTempLen % 256 ~= 0 then
		sizeWarn = "(size not a multiple of 2)"
	else
		sizeWarn = ""
	end

	print(string.format("(PCMA %03i) %s %s",pcmaCount,s,sizeWarn))

	table.insert(pcmaFiles,pcmaCount,{ ID = pcmaCount, File = s, Length = pcmaTempLen, Data = pcmaTempFile:read(pcmaTempLen) })
	pcmaCount = pcmaCount + 1
	pcmaTempFile:close()
end

print("")

--============================================================================--
-- adpcm-b
local pcmbFiles = {}
if not cdMode then
	local pcmbListFile, pcmbFileError = io.open(pcmbListFN,"r")
	if not pcmbListFile then
		print(string.format("Error attempting to open ADPCM-B list file %s",pcmbFileError))
		return
	end

	print("[ADPCM-B Samples]")
	local pcmbTempFile, pcmbTempLen, pcmbSampleRate, pcmbRealName
	local pcmbCount = 1
	for s in pcmbListFile:lines() do
		local rateSplitter = string.find(s,pcmbSeparator)
		if not rateSplitter then
			print(string.format("ADPCM-B sample %03i does not have a sample rate defined.",pcmbCount))
			return
		end

		pcmbRealName = string.sub(s,1,rateSplitter-1)

		pcmbSampleRate = tonumber(string.sub(s,rateSplitter+1))
		if not pcmbSampleRate then
			print(string.format("Error decoding sample rate from string '%s'",string.sub(s,rateSplitter+1)))
			return
		end
		if pcmbSampleRate < 1800 or pcmbSampleRate > 55500 then
			print(string.format("ADPCM-B sample %s has invalid sampling rate %dHz, must be between 1800Hz and 55500Hz",pcmbRealName,pcmbSampleRate))
			return
		end

		-- try loading file
		pcmbTempFile, pcmbFileError = io.open(pcmbRealName,"rb")
		if not pcmbTempFile then
			print(string.format("Error attempting to load ADPCM-B sample %s",pcmbFileError))
			return
		end

		-- get file length
		pcmbTempLen, pcmbFileError = pcmbTempFile:seek("end")
		if not pcmbTempLen then
			print(string.format("Error attempting to get length of ADPCM-B sample %s",pcmbFileError))
			return
		end

		pcmbTempFile:seek("set")

		if pcmaTempLen % 256 ~= 0 then
			sizeWarn = "(size not a multiple of 2)"
		else
			sizeWarn = ""
		end

		print(string.format("(PCMB %03i) %s (rate %d) %s",pcmbCount,pcmbRealName,pcmbSampleRate,sizeWarn))

		table.insert(pcmbFiles,pcmbCount,{ ID = pcmbCount, File = pcmbRealName, Length = pcmbTempLen, Rate = pcmbSampleRate, Data = pcmbTempFile:read(pcmbTempLen) })
		pcmbCount = pcmbCount + 1
		pcmbTempFile:close()
	end
end

--============================================================================--
-- todo: sort pcmaFiles and pcmbFiles with table.sort(sortBySize)?

-- debugging output or something, still need to process the data after this
print("")
print("===========================================================");
print("[ADPCM-A Sample Output]")
local sampleStart = 0
-- divining hand of aloozar, part I
for k,v in pairs(pcmaFiles) do
	local fixedLen = (v.Length/256)

	v.Start = sampleStart
	v.End = (sampleStart+fixedLen)-1

	print(string.format("[%s] %s\t Size: 0x%06X (0x%04X 0x%04X)",v.ID,v.File,v.Length,v.Start,v.End))
	sampleStart = sampleStart + fixedLen
end

if not cdMode then
	print("")
	print("[ADPCM-B Sample Output]")
	-- divining hand of aloozar, part II
	for k,v in pairs(pcmbFiles) do
		local fixedLen = (v.Length/256)
		v.DeltaN = (v.Rate/55500)*65536

		v.Start = sampleStart
		v.End = (sampleStart+fixedLen)-1

		print(string.format("[%s] %s\t Size: 0x%06X (0x%04X 0x%04X) Rate: 0x%04X",v.ID,v.File,v.Length,v.Start,v.End,v.DeltaN))
		sampleStart = sampleStart + fixedLen
	end
end

--============================================================================--
-- forge the merged sample rom and the sample address list
local outRom, outList, outError

local outName = "output" .. (cdMode and ".pcm" or ".v")
outRom, outError = io.open(outName,"w+b")
if not outRom then
	print(string.format("Error attempting to create output file %s",outError))
	return
end

for k,v in pairs(pcmaFiles) do
	outRom:write(v.Data)
end

if not cdMode then
	for k,v in pairs(pcmbFiles) do
		outRom:write(v.Data)
	end
end

outRom:close()

outList, outError = io.open("samples.inc","w+")
if not outList then
	print(string.format("Error attempting to create sample list file %s",outError))
	return
end

outList:write("; Sample list generated by Sailor VROM\n")
outList:write(";======================================;\n")
outList:write("\n")
outList:write("; [ADPCM-A Samples]\n")
outList:write("samples_pcma:\n")

for k,v in pairs(pcmaFiles) do
	outList:write(string.format("\tword\t0x%04X,0x%04X\t; Sample #%i (%s)\n",v.Start,v.End,v.ID,v.File))
end

outList:write("\n")
if not cdMode then
	outList:write("; [ADPCM-B Samples & Rates]\n")
	outList:write("samples_pcma:\n")

	for k,v in pairs(pcmbFiles) do
		outList:write(string.format("\tword\t0x%04X,0x%04X,0x%04X\t; Sample #%i (%s, %dHz)\n",v.Start,v.End,v.DeltaN,v.ID,v.File,v.Rate))
	end
end

outList:close()

-- final score: rom files 1, not rom files 0

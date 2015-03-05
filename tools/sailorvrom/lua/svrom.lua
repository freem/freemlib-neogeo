-- Sailor VROM (Lua version) by freem
-- Use of this tool (e.g. using the exported files) is free.
-- License is still undecided, but leaning towards public domain/unlicense/CC0.
--============================================================================--
local verNum = 0.11
local pcmbSeparator = "|"
local sizeWarnString = "(needs padding)"
local errorString = ""

local sampleListTypes = {
	["vasm"]	= { Directive="word",	Format="0x%04X" },
	["tniasm"]	= { Directive="dw",		Format="$%04X" }, -- could also use 0x%04X
	["wla"]		= { Directive=".dw",	Format="$%04X" },
}

--============================================================================--
-- Program startup (banner, basic argument check)
local args = {...}

print("Sailor VROM - Neo-Geo V ROM/.PCM File Builder (Lua version)");
print(string.format("v%.02f by freem",verNum))
print("===========================================================");

-- check arguments
if not args or not args[1] then
	print("No arguments found.")
	print("usage: lua svrom.lua (options)")
	print("===========================================================");
	print("Available options:")
	print("    --pcma=(path)         path/filename of ADPCM-A sample list file")
	print("    --pcmb=(path)         path/filename of ADPCM-B sample list file")
	print("    --outname=(path)      path/filename of sound data output")
	print("    --samplelist=(path)   path/filename of sample list output")
	print("    --mode=(mode)         'cd' or 'cart', without the quotes")
	print("    --slformat=(format)   'vasm', 'tniasm', or 'wla', all without quotes")
	return
end

--============================================================================--
-- parse command line parameters
local pcmaListFile, pcmbListFile	-- adpcm-a and adpcm-b sample list input files
local outSoundFile, outSampleFile	-- sound data and sample list output files
local pcmaListFN, pcmbListFN, outSoundFN, outSampleFN -- filenames for the above
local modeType = "cart"
local sampListType = "vasm"

local possibleParams = {
	["pcma"] = function(input) pcmaListFN = input end,
	["pcmb"] = function(input) pcmbListFN = input end,
	["outname"] = function(input) outSoundFN = input end,
	["samplelist"] = function(input) outSampleFN = input end,
	["mode"] = function(input)
		input = string.lower(input)
		if input ~= "cart" and input ~="cd" then
			error("Mode option must be 'cart' or 'cd'!")
		end
		modeType = input
	end,
	["slformat"] = function(input)
		local foundFormat = false
		input = string.lower(input)
		for t,f in pairs(sampleListTypes) do
			if not foundFormat then
				if input == t then
					sampListType = t
					foundFormat = true
				end
			end
		end
		if not foundFormat then
			print(string.format("Unknown slformat type '%s', using vasm instead.",input))
		end
	end,
}

local startDash, endDash, startEquals
for k,v in pairs(args) do
	-- something about searching for "--" at the beginning of a string and
	-- looking for a "=" somewhere inside of it.
	startDash,endDash = string.find(v,"--",1,true)
	if not startDash then
		print(string.format("Unrecognized option '%s'.",v))
		return
	end

	startEquals = string.find(v,"=",3,true)
	if not startEquals then
		print(string.format("Did not find equals to assign data in '%s'.",v))
		return
	end

	-- decode command and value
	local command = string.sub(v,endDash+1,startEquals-1)
	local value = string.sub(v,startEquals+1,-1)

	-- look for command
	local didCommand = false
	for c,f in pairs(possibleParams) do
		if c == command then
			f(value)
			didCommand = true
		end
	end
	if not didCommand then
		print(string.format("Sailor VROM doesn't recognize the command '%s'.",command))
	end
end

--============================================================================--
-- By this point, the commands are parsed. We should have values in the proper
-- variables if the user decided to actually enter some data. Of course, some
-- parameters are optional, so we also handle the fallback filenames here.

-- pcmaListFN is mandatory.
if not pcmaListFN then
	print("This program requires an ADPCM-A sample list in order to function.")
	return
end

print(string.format("Output Mode Type: %s",modeType))
print(string.format("ADPCM-A sample list file: '%s'",pcmaListFN))

-- pcmbListFN is not. however, if it's used on a CD system, we need to ignore it.
if pcmbListFN and modeType == "cd" then
	print("Neo-Geo CD does not support ADPCM-B playback. (Yes, we've tried.)")
	print("Ignoring ADPCM-B samples...")
	pcmbListFN = nil
end

if pcmbListFN then
	print(string.format("ADPCM-B sample list file: '%s'",pcmbListFN))
end

-- outSoundFN is not mandatory. (defaults to "output.v" or "output.pcm")
if not outSoundFN then
	outSoundFN = "output."..(modeType=="cd" and "pcm" or "v")
	print(string.format("Sound data output filename omitted, using '%s'.",outSoundFN))
else
	print(string.format("Sound data output: %s",outSoundFN))
end

-- outSampleFN is not mandatory either. (defaults to "samples.inc")
if not outSampleFN then
	outSampleFN = "samples.inc"
	print(string.format("Sample address output filename omitted, using '%s'.",outSampleFN))
else
	print(string.format("Sample address output: %s",outSampleFN))
end

print(string.format("sample list type: %s",sampListType))

print("")

--============================================================================--
-- Whew. That's a lot of checking. We're still not done yet, though, because if
-- those list files turn out to not exist, then I'm gonna get really mad!

pcmaListFile,errorString = io.open(pcmaListFN,"r")
if not pcmaListFile then
	print(string.format("Error attempting to open ADPCM-A list %s",errorString))
	return
end

--[[ Generic List Parsing Variables ]]--
local tempFile, tempLen, tempData
local padMe = false

--[[ ADPCM-A List Parsing ]]--
local pcmaFiles = {}
local pcmaCount = 1

print("")
print("==[ADPCM-A Input Sample List]==")
for l in pcmaListFile:lines() do
	-- try loading file
	tempFile,errorString = io.open(l,"rb")
	if not tempFile then
		print(string.format("Error attempting to load ADPCM-A sample %s",errorString))
		return
	end

	-- get file length
	tempLen,errorString = tempFile:seek("end")
	if not tempLen then
		print(string.format("Error attempting to get length of ADPCM-A sample %s",errorString))
		return
	end

	tempFile:seek("set")

	padMe = false
	if tempLen % 256 ~= 0 then
		sizeWarn = sizeWarnString
		padMe = true
	else
		sizeWarn = ""
	end

	tempData = tempFile:read(tempLen)
	tempFile:close()
	print(string.format("(PCMA %03i) %s %s",pcmaCount,l,sizeWarn))

	if padMe then
		-- pad the sample with 0x80
		local padBytes = 256-(tempLen%256)

		for i=1,padBytes do
			tempData = tempData .. string.char(128)
		end
		tempLen = tempLen + padBytes
	end

	table.insert(pcmaFiles,pcmaCount,{ID=pcmaCount,File=l,Length=tempLen,Data=tempData})
	pcmaCount = pcmaCount + 1
end

pcmaListFile:close()

--============================================================================--
-- Time for ADPCM-B, but only if we have it.

--[[ ADPCM-B List Parsing ]]--
local pcmbFiles = {}
local pcmbCount = 0
local tempRate, tempRealFileName

if pcmbListFN then
	pcmbCount = 1
	print("")
	print("==[ADPCM-B Input Sample List]==")

	-- try opening list file
	pcmbListFile,errorString = io.open(pcmbListFN,"r")
	if not pcmbListFile then
		print(string.format("Error attempting to open ADPCM-B list %s",errorString))
		return
	end

	for l in pcmbListFile:lines() do
		-- look for rate splitter character
		local rateSplitter = string.find(l,pcmbSeparator)
		if not rateSplitter then
			print(string.format("ADPCM-B sample %03i does not have a sample rate defined.",pcmbCount))
			return
		end

		-- get actual filename
		tempRealFileName = string.sub(l,1,rateSplitter-1)

		-- get sample rate
		tempRate = tonumber(string.sub(l,rateSplitter+1))
		if not tempRate then
			print(string.format("Error decoding sample rate from string '%s'",string.sub(l,rateSplitter+1)))
		end
		if tempRate < 1800 or tempRate > 55500 then
			print(string.format("ADPCM-B sample %s has invalid sampling rate %dHz, must be between 1800Hz and 55500Hz",tempRealFileName,tempRate))
			return
		end

		-- try loading file
		tempFile,errorString = io.open(tempRealFileName,"rb")
		if not tempFile then
			print(string.format("Error attempting to load ADPCM-B sample %s",errorString))
			return
		end

		-- get file length
		tempLen,errorString = tempFile:seek("end")
		if not tempLen then
			print(string.format("Error attempting to get length of ADPCM-B sample %s",errorString))
			return
		end

		tempFile:seek("set")

		padMe = false
		if tempLen % 256 ~= 0 then
			sizeWarn = sizeWarnString
			padMe = true
		else
			sizeWarn = ""
		end

		tempData = tempFile:read(tempLen)
		tempFile:close()
		print(string.format("(PCMB %03i) %s (rate %d) %s",pcmbCount,tempRealFileName,tempRate,sizeWarn))

		if padMe then
			-- pad the sample with 0x80
			local padBytes = 256-(tempLen%256)

			for i=1,padBytes do
				tempData = tempData .. string.char(128)
			end
			tempLen = tempLen + padBytes
		end

		table.insert(pcmbFiles,pcmbCount,{ID=pcmbCount,File=tempRealFileName,Length=tempLen,Rate=tempRate,Data=tempData})
		pcmbCount = pcmbCount + 1
	end

	pcmbListFile:close()
end

print("")

--============================================================================--
-- pcmaFiles (and pcmbFiles, if used) should have data.
-- Time to get the sample addresses.

local sampleStart = 0

print("Calculating sample addresses...")

-- ADPCM-A samples
for k,v in pairs(pcmaFiles) do
	local fixedLen = (v.Length/256)
	v.Start = sampleStart
	v.End = (sampleStart+fixedLen)-1
	sampleStart = sampleStart + fixedLen
end

-- ADPCM-B samples
if pcmbListFN then
	for k,v in pairs(pcmbFiles) do
		local fixedLen = (v.Length/256)
		v.Start = sampleStart
		v.End = (sampleStart+fixedLen)-1
		v.DeltaN = (v.Rate/55500)*65536
		sampleStart = sampleStart + fixedLen
	end
end

print("")

--============================================================================--
-- create the sample address list

print("Creating sample address list...")

outSampleFile,errorString = io.open(outSampleFN,"w+")
if not outSampleFile then
	print(string.format("Error attempting to create sample list file %s",errorString))
	return
end

local direc = sampleListTypes[sampListType].Directive
local valFormat = sampleListTypes[sampListType].Format

-- write header
outSampleFile:write("; Sample address list generated by Sailor VROM\n")
outSampleFile:write(";==============================================;\n")
outSampleFile:write("\n")

-- write ADPCM-A
outSampleFile:write("; [ADPCM-A Samples]\n")
outSampleFile:write("samples_pcma:\n")

-- todo: using hardcoded values
for k,v in pairs(pcmaFiles) do
	outSampleFile:write(string.format("\t%s\t"..valFormat..","..valFormat.."\t; Sample #%i (%s)\n",direc,v.Start,v.End,v.ID,v.File))
end
outSampleFile:write("\n")

-- write ADPCM-B, if applicable
if pcmbListFN then
	outSampleFile:write("; [ADPCM-B Samples & Rates]\n")
	outSampleFile:write("samples_pcmb:\n")

	for k,v in pairs(pcmbFiles) do
		outSampleFile:write(string.format("\t%s\t"..valFormat..","..valFormat..","..valFormat.."\t; Sample #%i (%s, %dHz)\n",direc,v.Start,v.End,v.DeltaN,v.ID,v.File,v.Rate))
	end
end
outSampleFile:write("\n")

outSampleFile:close()

print("")

--============================================================================--
-- Create the combined sample rom

print("Creating combined sample data...")

outSoundFile,errorString = io.open(outSoundFN,"w+b")
if not outSoundFile then
	print(string.format("Error attempting to create output file %s",errorString))
	return
end

for k,v in pairs(pcmaFiles) do outSoundFile:write(v.Data) end

if pcmbListFN then
	for k,v in pairs(pcmbFiles) do outSoundFile:write(v.Data) end
end

outSoundFile:close()

--============================================================================--
print("")
print("Build successful.")

-- See LICENSE for terms

local options
local mod_EmptyDumpSites
local mod_EmptyNewSol
local mod_EmptyNewHour

-- fired when settings are changed/init
local function ModOptions()
	mod_EmptyDumpSites = options.EmptyDumpSites
	mod_EmptyNewSol = options.EmptyNewSol
	mod_EmptyNewHour = options.EmptyNewHour
end

-- load default/saved settings
function OnMsg.ModsReloaded()
	options = CurrentModOptions
	ModOptions()
end

-- fired when option is changed
function OnMsg.ApplyModOptions(id)
	if id ~= CurrentModId then
		return
	end

	ModOptions()
end

local function EmptyAll()
	local objs = UICity.labels.WasteRockDumpSite or ""
	for i = 1, #objs do
		objs[i]:CheatEmpty()
	end
end

function OnMsg.NewDay()
	if mod_EmptyDumpSites and mod_EmptyNewSol then
		EmptyAll()
	end
end

function OnMsg.NewHour()
	if mod_EmptyDumpSites and mod_EmptyNewHour then
		EmptyAll()
	end
end

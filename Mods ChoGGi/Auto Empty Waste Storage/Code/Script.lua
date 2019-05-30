-- See LICENSE for terms

local mod_id = "ChoGGi_AutoEmptyWasteStorage"
local mod = Mods[mod_id]

local mod_EmptyDumpSites = mod.options and mod.options.EmptyDumpSites or true
local mod_EmptyNewSol = mod.options and mod.options.EmptyNewSol or true
local mod_EmptyNewHour = mod.options and mod.options.EmptyNewHour or false

local function ModOptions()
	mod_EmptyDumpSites = mod.options.EmptyDumpSites
	mod_EmptyNewSol = mod.options.EmptyNewSol
	mod_EmptyNewHour = mod.options.EmptyNewHour
end

-- fired when option is changed
function OnMsg.ApplyModOptions(id)
	if id ~= mod_id then
		return
	end

	ModOptions()
end

-- for some reason mod options aren't retrieved before this script is loaded...
OnMsg.CityStart = ModOptions
OnMsg.LoadGame = ModOptions

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

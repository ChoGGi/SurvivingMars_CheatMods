-- See LICENSE for terms

local mod_EmptyDumpSites
local mod_EmptyNewSol
local mod_EmptyNewHour

local function ModOptions(id)
	-- id is from ApplyModOptions
	if id and id ~= CurrentModId then
		return
	end

	mod_EmptyDumpSites = CurrentModOptions:GetProperty("EmptyDumpSites")
	mod_EmptyNewSol = CurrentModOptions:GetProperty("EmptyNewSol")
	mod_EmptyNewHour = CurrentModOptions:GetProperty("EmptyNewHour")
end
-- Load default/saved settings
OnMsg.ModsReloaded = ModOptions
-- Fired when Mod Options>Apply button is clicked
OnMsg.ApplyModOptions = ModOptions

local function EmptyAll()
	local objs = UIColony:GetCityLabels("WasteRockDumpSite")
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

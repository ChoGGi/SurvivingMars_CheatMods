-- See LICENSE for terms

local mod_EmptyDumpSites
local mod_EmptyNewSol
local mod_EmptyNewHour

-- fired when settings are changed/init
local function ModOptions()
	mod_EmptyDumpSites = CurrentModOptions:GetProperty("EmptyDumpSites")
	mod_EmptyNewSol = CurrentModOptions:GetProperty("EmptyNewSol")
	mod_EmptyNewHour = CurrentModOptions:GetProperty("EmptyNewHour")
end

-- load default/saved settings
OnMsg.ModsReloaded = ModOptions

-- fired when option is changed
function OnMsg.ApplyModOptions(id)
	if id == CurrentModId then
		ModOptions()
	end
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

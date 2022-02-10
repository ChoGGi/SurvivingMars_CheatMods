-- See LICENSE for terms

local mod_EnableMod

local function ModOptions(id)
	-- id is from ApplyModOptions
	if id and id ~= CurrentModId then
		return
	end

	mod_EnableMod = CurrentModOptions:GetProperty("EnableMod")
end
-- Load default/saved settings
OnMsg.ModsReloaded = ModOptions
-- Fired when Mod Options>Apply button is clicked
OnMsg.ApplyModOptions = ModOptions

local ChoOrig_Workplace_GatherConstructionStatuses = Workplace.GatherConstructionStatuses
function Workplace:GatherConstructionStatuses(statuses, ...)
	ChoOrig_Workplace_GatherConstructionStatuses(self, statuses, ...)
	if not mod_EnableMod then
		return
	end

	local idx = table.find(statuses, "text", ConstructionStatus.NoNearbyWorkers.text)
	if idx then
		table.remove(statuses, idx)
	end
end


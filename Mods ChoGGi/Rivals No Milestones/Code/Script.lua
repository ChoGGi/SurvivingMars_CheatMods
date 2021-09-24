-- See LICENSE for terms

local mod_EnableMod

local function ModOptions(id)
	-- id is from ApplyModOptions
	if id and id ~= CurrentModId then
		return
	end

	mod_EnableMod = CurrentModOptions:GetProperty("EnableMod")
end
-- load default/saved settings
OnMsg.ModsReloaded = ModOptions
-- fired when Mod Options>Apply button is clicked
OnMsg.ApplyModOptions = ModOptions


local function BlockRivalMileStones(func, ...)
	if not mod_EnableMod then
		return func(...)
	end
end

local ChoOrig_AIContestMilestone = AIContestMilestone
function AIContestMilestone(...)
	return BlockRivalMileStones(ChoOrig_AIContestMilestone, ...)
end
local ChoOrig_AIContestAnomaly = AIContestAnomaly
function AIContestAnomaly(...)
	return BlockRivalMileStones(ChoOrig_AIContestAnomaly, ...)
end
local ChoOrig_UpdateCompetitionItems = UpdateCompetitionItems
function UpdateCompetitionItems(...)
	return BlockRivalMileStones(ChoOrig_UpdateCompetitionItems, ...)
end

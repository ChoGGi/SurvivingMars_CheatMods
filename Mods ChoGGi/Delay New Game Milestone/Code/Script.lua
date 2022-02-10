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

local ChoOrig_MilestoneRestartThreads = MilestoneRestartThreads
function MilestoneRestartThreads(...)
	if not mod_EnableMod or UIColony and UIColony.day > 1 then
		return ChoOrig_MilestoneRestartThreads(...)
	else
		CreateGameTimeThread(function()
			WaitMsg("NewDay")
			return ChoOrig_MilestoneRestartThreads(...)
		end)
	end
end

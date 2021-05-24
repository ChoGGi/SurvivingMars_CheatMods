-- See LICENSE for terms

local mod_EnableMod

-- fired when settings are changed/init
local function ModOptions()
	mod_EnableMod = CurrentModOptions:GetProperty("EnableMod")
end

-- load default/saved settings
OnMsg.ModsReloaded = ModOptions

-- fired when Mod Options>Apply button is clicked
function OnMsg.ApplyModOptions(id)
	-- I'm sure it wouldn't be that hard to only call this msg for the mod being applied, but...
	if id == CurrentModId then
		ModOptions()
	end
end

local orig_MilestoneRestartThreads = MilestoneRestartThreads
function MilestoneRestartThreads()
	if not mod_EnableMod or UICity and UICity.day > 1 then
		return orig_MilestoneRestartThreads()
	else
		CreateGameTimeThread(function()
			WaitMsg("NewDay")
			return orig_MilestoneRestartThreads()
		end)
	end
end

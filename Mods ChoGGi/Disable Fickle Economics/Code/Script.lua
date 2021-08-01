-- See LICENSE for terms

local mod_EnableMod

local function UpdateStorybit()
	local bit = StoryBits.IncreaseResourceCost

	if mod_EnableMod then
		bit.EnableChance = 0
		bit.Enabled = false
	else
		bit.EnableChance = 15
		bit.Enabled = true
	end

end

-- fired when settings are changed/init
local function ModOptions()
	mod_EnableMod = CurrentModOptions:GetProperty("EnableMod")

	-- make sure we're in-game
	if not UICity then
		return
	end

	UpdateStorybit()
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

OnMsg.CityStart = UpdateStorybit
OnMsg.LoadGame = UpdateStorybit

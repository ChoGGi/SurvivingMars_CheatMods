-- See LICENSE for terms

local mod_FickleEconomics
local mod_RocketMalfunction

local function UpdateStorybit()
	local StoryBits = StoryBits

	local bit = StoryBits.IncreaseResourceCost
	if mod_FickleEconomics then
		bit.Enabled = false
	else
		bit.Enabled = true
	end

	local bit = StoryBits.BadRocketLanding
	if mod_RocketMalfunction then
		bit.Enabled = false
	else
		bit.Enabled = true
	end

end
OnMsg.CityStart = UpdateStorybit
OnMsg.LoadGame = UpdateStorybit

local function ModOptions(id)
	-- id is from ApplyModOptions
	if id and id ~= CurrentModId then
		return
	end

	mod_FickleEconomics = CurrentModOptions:GetProperty("FickleEconomics")
	mod_RocketMalfunction = CurrentModOptions:GetProperty("RocketMalfunction")

	-- make sure we're in-game
	if not UICity then
		return
	end

	UpdateStorybit()
end
-- load default/saved settings
OnMsg.ModsReloaded = ModOptions
-- fired when Mod Options>Apply button is clicked
OnMsg.ApplyModOptions = ModOptions

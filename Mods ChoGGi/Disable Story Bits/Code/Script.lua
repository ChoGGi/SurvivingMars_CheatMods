-- See LICENSE for terms

local mod_FickleEconomics
local mod_RocketMalfunction
local mod_RivalColoniesGrudge

local function UpdateStorybit()
	local StoryBits = StoryBits

	local bit = StoryBits.IncreaseResourceCost
	if mod_FickleEconomics then
		bit.Enabled = false
	else
		bit.Enabled = true
	end

	bit = StoryBits.BadRocketLanding
	if mod_RocketMalfunction then
		bit.Enabled = false
	else
		bit.Enabled = true
	end

	bit = StoryBits.Grudge
	if mod_RivalColoniesGrudge then
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
	mod_RivalColoniesGrudge = CurrentModOptions:GetProperty("RivalColoniesGrudge")

	-- make sure we're in-game
	if not UIColony then
		return
	end

	UpdateStorybit()
end
-- Load default/saved settings
OnMsg.ModsReloaded = ModOptions
-- Fired when Mod Options>Apply button is clicked
OnMsg.ApplyModOptions = ModOptions

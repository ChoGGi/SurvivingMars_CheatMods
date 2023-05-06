-- See LICENSE for terms

local mod_EnableMod

local function StartupCode()
	if not mod_EnableMod then
		return
	end

	local objs = UIColony:GetCityLabels("Colonist")
	for i = 1, #objs do
		local obj = objs[i]
		if obj.traits.DustSickness then
			obj:RemoveTrait("DustSickness")

			if obj.status_effects.StatusEffect_UnableToWork then
				obj:Affect("StatusEffect_UnableToWork", false)
			end
		end
	end
end

--~ -- New games
--~ OnMsg.CityStart = StartupCode
-- Saved ones
OnMsg.LoadGame = StartupCode

-- Update mod options
local function ModOptions(id)
	-- id is from ApplyModOptions
	if id and id ~= CurrentModId then
		return
	end

	mod_EnableMod = CurrentModOptions:GetProperty("EnableMod")

	-- Make sure we're in-game
	if not UIColony then
		return
	end

	StartupCode()
end
-- Load default/saved settings
OnMsg.ModsReloaded = ModOptions
-- Fired when Mod Options>Apply button is clicked
OnMsg.ApplyModOptions = ModOptions

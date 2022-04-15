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

local ChoOrig_RocketBase_PlaceEngineDecal = RocketBase.PlaceEngineDecal
function RocketBase.PlaceEngineDecal(...)
	if not mod_EnableMod then
		return ChoOrig_RocketBase_PlaceEngineDecal(...)
	end
end

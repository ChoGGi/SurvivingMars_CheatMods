-- See LICENSE for terms

if not g_AvailableDlc.armstrong then
	print(CurrentModDef.title, ": Green Planet DLC not installed! Abort!")
	return
end

local mod_EnableMod

local function StartupCode()
	if not mod_EnableMod then
		return
	end

	local defs = TerraformingParamDefs
  local idx

	-- blue skys
	idx = table.find(defs.Atmosphere.Threshold, "Id", "AtmosphereCleared")
	if idx then
		defs.Atmosphere.Threshold[idx].Threshold = 999
	end
	-- toxic rains
	idx = table.find(defs.Atmosphere.Threshold, "Id", "ToxicRainStop")
	if idx then
		defs.Atmosphere.Threshold[idx].Threshold = 999
	end
	-- cold waves
	idx = table.find(defs.Temperature.Threshold, "Id", "ColdWaveStop")
	if idx then
		defs.Temperature.Threshold[idx].Threshold = 999
	end

	-- Set all terraforming stats to 40
	TechDef.AncientTerraformingDevice[1].OnApplyEffect = function()
		-- TechDef.AncientTerraformingDevice.param1 is 20, but that doesn't do anything since game uses hardcoded value anyways...
		for name in pairs(defs) do
			SetTerraformParamPct(name, 40)
		end
	end
end

-- New games
OnMsg.CityStart = StartupCode
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

-- See LICENSE for terms

local mod_EnableMod

local function StartupCode()
	if not mod_EnableMod or not UICity or not g_ColdWave then
		return
	end

	-- it's always a missing map id isn't it?
	if not g_ColdWave.GetMapID then
		g_ColdWave.GetMapID = function()
			return MainCity.map_id
		end
	end

	StopColdWave()
	g_ColdWave = false
end


local function ModOptions(id)
	-- id is from ApplyModOptions
	if id and id ~= CurrentModId then
		return
	end

	mod_EnableMod = CurrentModOptions:GetProperty("EnableMod")

	StartupCode()
end
-- Load default/saved settings
OnMsg.ModsReloaded = ModOptions
-- Fired when Mod Options>Apply button is clicked
OnMsg.ApplyModOptions = ModOptions


OnMsg.CityStart = StartupCode
OnMsg.LoadGame = StartupCode
-- switch between different maps (happens before UICity)
OnMsg.ChangeMapDone = StartupCode

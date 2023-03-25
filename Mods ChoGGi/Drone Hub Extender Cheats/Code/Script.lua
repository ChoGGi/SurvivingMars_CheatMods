-- See LICENSE for terms

if not g_AvailableDlc.picard then
	print(CurrentModDef.title, ": Below & Beyond DLC not installed!")
	return
end

local mod_EnableMod

local function StartupCode()
	if not mod_EnableMod then
		return
	end

	local bt = BuildingTemplates.DroneHubExtender
	if bt then
		bt.construction_cost_PreciousMinerals = 0
		bt.construction_cost_PreciousMetals = 6000
		local ct = ClassTemplates.Building.DroneHubExtender
		ct.construction_cost_PreciousMinerals = 0
		ct.construction_cost_PreciousMetals = 6000
	end
end
OnMsg.CityStart = StartupCode
OnMsg.LoadGame = StartupCode

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

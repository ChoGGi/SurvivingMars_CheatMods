-- See LICENSE for terms

local mod_ResearchCost

-- some stuff checks one some other...
local SetConsts = ChoGGi_Funcs.Common.SetConsts

local function StartupCode()
	SetConsts("DiscoveryScanCost", mod_ResearchCost)
	BuildingTemplates.ReconCenter.consumption_max_storage = mod_ResearchCost
end
OnMsg.CityStart = StartupCode
OnMsg.LoadGame = StartupCode

-- Update mod options
local function ModOptions(id)
	-- id is from ApplyModOptions
	if id and id ~= CurrentModId then
		return
	end

	mod_ResearchCost = CurrentModOptions:GetProperty("ResearchCost") * const.ResearchPointsScale

	-- make sure we're in-game
	if not UIColony then
		return
	end
	StartupCode()
end
-- Load default/saved settings
OnMsg.ModsReloaded = ModOptions
-- Fired when Mod Options>Apply button is clicked
OnMsg.ApplyModOptions = ModOptions

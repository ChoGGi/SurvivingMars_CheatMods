-- See LICENSE for terms

local function ClearRestrictions(template)
	template.disabled_in_environment1 = ""
	template.disabled_in_environment2 = ""
	template.disabled_in_environment3 = ""
	template.disabled_in_environment4 = ""
end


local mod_EnableMod

local function UnlockBuildings()
	if not mod_EnableMod then
		return
	end

	local bt = BuildingTemplates

	ClearRestrictions(bt.TriboelectricScrubber)
	ClearRestrictions(bt.RCConstructorBuilding)
	ClearRestrictions(bt.RCDrillerBuilding)
	ClearRestrictions(bt.RCExplorerBuilding)
	ClearRestrictions(bt.RCHarvesterBuilding)
	ClearRestrictions(bt.RCRoverBuilding)
	ClearRestrictions(bt.RCSafariBuilding)
	ClearRestrictions(bt.RCSensorBuilding)
	ClearRestrictions(bt.RCSolarBuilding)
	ClearRestrictions(bt.RCTerraformerBuilding)
	ClearRestrictions(bt.RCTransportBuilding)

	ClearRestrictions(bt.ShuttleHub)
	ClearRestrictions(bt.JumperShuttleHub)

	ClearRestrictions(bt.StirlingGenerator)
	ClearRestrictions(bt.AdvancedStirlingGenerator)

--~ 	ClearRestrictions(bt.WindTurbine)
--~ 	ClearRestrictions(bt.WindTurbine_Large)

	ClearRestrictions(bt.LandscapeTerrace)

--~ 	ClearRestrictions(bt.XXXX)
end

local function ModOptions(id)
	-- id is from ApplyModOptions
	if id and id ~= CurrentModId then
		return
	end

	mod_EnableMod = CurrentModOptions:GetProperty("EnableMod")

	-- make sure we're in-game
	if not UICity then
		return
	end

	UnlockBuildings()
end
-- load default/saved settings
OnMsg.ModsReloaded = ModOptions
-- fired when Mod Options>Apply button is clicked
OnMsg.ApplyModOptions = ModOptions


OnMsg.CityStart = UnlockBuildings
OnMsg.LoadGame = UnlockBuildings

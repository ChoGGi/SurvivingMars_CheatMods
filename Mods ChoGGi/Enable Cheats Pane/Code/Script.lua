-- See LICENSE for terms

local mod_EnableMod

local function TogglePane()
	if mod_EnableMod then
		config.BuildingInfopanelCheats = true
	else
		config.BuildingInfopanelCheats = false
	end

	ReopenSelectionXInfopanel()
end
OnMsg.CityStart = StartupCode
OnMsg.LoadGame = StartupCode
-- switch between different maps (happens before UICity)
OnMsg.ChangeMapDone = StartupCode


local function ModOptions(id)
	-- id is from ApplyModOptions
	if id and id ~= CurrentModId then
		return
	end

	mod_EnableMod = CurrentModOptions:GetProperty("EnableMod")

	-- make sure we're in-game UIColony
	if not UICity then
		return
	end

	TogglePane()
end
-- load default/saved settings
OnMsg.ModsReloaded = ModOptions
-- fired when Mod Options>Apply button is clicked
OnMsg.ApplyModOptions = ModOptions

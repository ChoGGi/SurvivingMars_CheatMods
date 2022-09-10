-- See LICENSE for terms

-- using the CheatUpgrade func in the cheats pane with some mods == inf loop
local Building = Building
for i = 1, 3 do
	local name = "CheatUpgrade" .. i
	local ChoOrig_func = Building[name]
	Building[name] = function(...)
		CreateRealTimeThread(ChoOrig_func, ...)
	end
end

local mod_EnableMod

local function TogglePane()
	if mod_EnableMod then
		config.BuildingInfopanelCheats = true
	else
		config.BuildingInfopanelCheats = false
	end

	ReopenSelectionXInfopanel()
end
OnMsg.CityStart = TogglePane
OnMsg.LoadGame = TogglePane
-- switch between different maps (happens before UICity)
OnMsg.ChangeMapDone = TogglePane


local function ModOptions(id)
	-- id is from ApplyModOptions
	if id and id ~= CurrentModId then
		return
	end

	mod_EnableMod = CurrentModOptions:GetProperty("EnableMod")

	-- Make sure we're in-game UIColony
	if not MainCity then
		return
	end

	TogglePane()
end
-- Load default/saved settings
OnMsg.ModsReloaded = ModOptions
-- Fired when Mod Options>Apply button is clicked
OnMsg.ApplyModOptions = ModOptions

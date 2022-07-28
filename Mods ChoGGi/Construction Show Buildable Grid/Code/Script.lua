-- See LICENSE for terms

local mod_EnableMod

local function ModOptions(id)
	-- id is from ApplyModOptions
	if id and id ~= CurrentModId then
		return
	end

	mod_EnableMod = CurrentModOptions:GetProperty("Option1")

	local u = ChoGGi.UserSettings
	u.DebugGridOpacity = CurrentModOptions:GetProperty("DebugGridOpacity")
	u.DebugGridSize = CurrentModOptions:GetProperty("DebugGridSize")
	if ChoGGi.SettingFuncs.WriteSettings then
		ChoGGi.SettingFuncs.WriteSettings()
	end
end
-- Load default/saved settings
OnMsg.ModsReloaded = ModOptions
-- Fired when Mod Options>Apply button is clicked
OnMsg.ApplyModOptions = ModOptions

local grids_visible

local function ShowGrids()
	ChoGGi.ComFuncs.BuildableHexGrid(true)
	grids_visible = true
end
local function HideGrids()
	ChoGGi.ComFuncs.BuildableHexGrid(false)
	grids_visible = false
end

local ChoOrig_CursorBuilding_GameInit = CursorBuilding.GameInit
function CursorBuilding:GameInit(...)
	if mod_EnableMod and self.entity ~= "DomeGeoscape" then
		ShowGrids()
	end
	return ChoOrig_CursorBuilding_GameInit(self, ...)
end

local ChoOrig_CursorBuilding_Done = CursorBuilding.Done
function CursorBuilding.Done(...)
	HideGrids()
	return ChoOrig_CursorBuilding_Done(...)
end

-- add keybind for toggle
local Actions = ChoGGi.Temp.Actions
Actions[#Actions+1] = {ActionName = T(302535920011583, "Construction Show Hex Buildable Grid"),
	ActionId = "ChoGGi.ConstructionShowHexBuildableGrid.ToggleGrid",
	OnAction = function()
		if grids_visible then
			HideGrids()
		else
			ShowGrids()
		end
	end,
	ActionShortcut = "Numpad 0",
	replace_matching_id = true,
	ActionBindable = true,
}

-- See LICENSE for terms

local options
local mod_Option1

-- fired when settings are changed/init
local function ModOptions()
	mod_Option1 = options:GetProperty("Option1")
	local u = ChoGGi.UserSettings
	u.DebugGridOpacity = options:GetProperty("DebugGridOpacity")
	u.DebugGridSize = options:GetProperty("DebugGridSize")
	if ChoGGi.SettingFuncs.WriteSettings then
		ChoGGi.SettingFuncs.WriteSettings()
	end
end

-- load default/saved settings
function OnMsg.ModsReloaded()
	options = CurrentModOptions
	ModOptions()
end

-- fired when option is changed
function OnMsg.ApplyModOptions(id)
	if id ~= CurrentModId then
		return
	end

	ModOptions()
end

local grids_visible

local function ShowGrids()
	ChoGGi.ComFuncs.BuildableHexGrid(true)
	grids_visible = true
end
local function HideGrids()
	ChoGGi.ComFuncs.BuildableHexGrid(false)
	grids_visible = false
end

local orig_CursorBuilding_GameInit = CursorBuilding.GameInit
function CursorBuilding.GameInit(...)
	if mod_Option1 then
		ShowGrids()
	end
	return orig_CursorBuilding_GameInit(...)
end

local orig_CursorBuilding_Done = CursorBuilding.Done
function CursorBuilding.Done(...)
	HideGrids()
	return orig_CursorBuilding_Done(...)
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

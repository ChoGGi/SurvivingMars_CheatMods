-- See LICENSE for terms

local mod_Option1

local function ModOptions(id)
	-- id is from ApplyModOptions
	if id and id ~= CurrentModId then
		return
	end

	mod_Option1 = CurrentModOptions:GetProperty("Option1")
end
-- Load default/saved settings
OnMsg.ModsReloaded = ModOptions
-- Fired when Mod Options>Apply button is clicked
OnMsg.ApplyModOptions = ModOptions

local grids_visible

local function ShowGrids()
	SetPostProcPredicate("hexgrid", true)
	grids_visible = true
end
local function HideGrids()
	SetPostProcPredicate("hexgrid", false)
	grids_visible = false
end

local ChoOrig_CursorBuilding_GameInit = CursorBuilding.GameInit
function CursorBuilding.GameInit(...)
	if mod_Option1 then
		ShowGrids()
	end
	return ChoOrig_CursorBuilding_GameInit(...)
end

local ChoOrig_CursorBuilding_Done = CursorBuilding.Done
function CursorBuilding.Done(...)
	HideGrids()
	return ChoOrig_CursorBuilding_Done(...)
end

-- add keybind for toggle
local Actions = ChoGGi.Temp.Actions
Actions[#Actions+1] = {ActionName = T(302535920011570, "Construction Show Hex Range"),
	ActionId = "ChoGGi.ConstructionShowHexRange.ToggleGrid",
	OnAction = function()
		if grids_visible then
			HideGrids()
		else
			ShowGrids()
		end
	end,
	ActionShortcut = "Numpad 5",
	replace_matching_id = true,
	ActionBindable = true,
}

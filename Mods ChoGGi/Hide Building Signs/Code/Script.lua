-- See LICENSE for terms

local mod_EnableMod

-- edited from orig func to remove deposits
local function SetSignsVisible(visible)
	if visible then
		MapSetEnumFlags(const.efVisible, "map", "BuildingSign", "UnitSign", "ArrowTutorialBase", "SelectionArrow")
	else
		MapClearEnumFlags(const.efVisible, "map", "BuildingSign", "UnitSign", "ArrowTutorialBase", "SelectionArrow")
	end
end


local function SetBuildingSigns1()
	SetSignsVisible(not mod_EnableMod)
end
OnMsg.CityStart = SetBuildingSigns1
OnMsg.LoadGame = SetBuildingSigns1

local temp_vis = false
local function SetBuildingSigns2()
	temp_vis = not temp_vis
	SetSignsVisible(temp_vis)
end

local function ModOptions(id)
	-- id is from ApplyModOptions
	if id and id ~= CurrentModId then
		return
	end

	mod_EnableMod = CurrentModOptions:GetProperty("EnableMod")

	-- make sure we're in-game
	if not MainCity then
		return
	end

	SetBuildingSigns1()
end
-- Load default/saved settings
OnMsg.ModsReloaded = ModOptions
-- Fired when Mod Options>Apply button is clicked
OnMsg.ApplyModOptions = ModOptions

-- add keybind for toggle
local Actions = ChoGGi.Temp.Actions
Actions[#Actions+1] = {ActionName = T(302535920011687, "Hide Building Signs"),
	ActionId = "ChoGGi.HideBuildingSigns.ToggleSigns",
	OnAction = function()
		SetBuildingSigns2()
	end,
	ActionShortcut = "Numpad 8",
	replace_matching_id = true,
	ActionBindable = true,
}

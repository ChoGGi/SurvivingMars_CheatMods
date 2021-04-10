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

local temp_vis = false
local function SetBuildingSigns2()
	temp_vis = not temp_vis
	SetSignsVisible(temp_vis)
end

-- fired when settings are changed/init
local function ModOptions()
	mod_EnableMod = CurrentModOptions:GetProperty("EnableMod")

	-- make sure we're ingame
	if UICity then
		SetBuildingSigns1()
	end
end

-- load default/saved settings
OnMsg.ModsReloaded = ModOptions

-- fired when option is changed
function OnMsg.ApplyModOptions(id)
	if id == CurrentModId then
		ModOptions()
	end
end

OnMsg.CityStart = SetBuildingSigns1
OnMsg.LoadGame = SetBuildingSigns1

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

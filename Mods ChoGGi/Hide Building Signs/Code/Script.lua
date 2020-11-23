-- See LICENSE for terms

-- edited from orig func to remove deposits
local function SetSignsVisible(visible)
	if visible and not g_SignsVisible then
		MapSetEnumFlags(const.efVisible, "map", "BuildingSign", "UnitSign", "ArrowTutorialBase", "SelectionArrow")
		g_SignsVisible = true
	end
	if not visible and g_SignsVisible then
		MapClearEnumFlags(const.efVisible, "map", "BuildingSign", "UnitSign", "ArrowTutorialBase", "SelectionArrow")
		g_SignsVisible = false
	end
end

local mod_EnableMod

local function SetBuildingSigns1()
	SetSignsVisible(not mod_EnableMod)
end
local function SetBuildingSigns2()
	SetSignsVisible(not g_SignsVisible)
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
	if id ~= CurrentModId then
		return
	end

	ModOptions()
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

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

local function SetSigns(setting)
	SetSignsVisible(not setting)
end

local function SetSigns1()
	SetSigns(mod_EnableMod)
end
local function SetSigns2()
	SetSigns(g_SignsVisible)
end

-- fired when settings are changed/init
local function ModOptions()
	mod_EnableMod = CurrentModOptions:GetProperty("EnableMod")

	-- make sure we're ingame
	if not UICity then
		return
	end
	SetSigns1()
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

OnMsg.CityStart = SetSigns1
OnMsg.LoadGame = SetSigns1

-- add keybind for toggle
local Actions = ChoGGi.Temp.Actions
Actions[#Actions+1] = {ActionName = T(302535920011687, "Hide Building Signs"),
	ActionId = "ChoGGi.HideBuildingSigns.ToggleSigns",
	OnAction = function()
		SetSigns2()
	end,
	ActionShortcut = "Numpad 8",
	replace_matching_id = true,
	ActionBindable = true,
}

-- See LICENSE for terms

-- move cam to mouse pos
local ViewObjectRTS = ViewObjectRTS
local GetTerrainCursor = GetTerrainCursor
local function go_to_mouse()
	ViewObjectRTS(GetTerrainCursor())
end

-- unforbid binding some keys
local forbid = ForbiddenShortcutKeys
forbid.Lwin = nil
forbid.Rwin = nil
forbid.MouseL = nil
forbid.MouseR = nil
forbid.MouseM = nil

--~ local Strings = ChoGGi.Strings
local Actions = ChoGGi.Temp.Actions

Actions[#Actions+1] = {ActionName = T(302535920011058, [[Click To Move]]),
	ActionId = "ChoGGi_ClickToMove",
	ActionShortcut = "Shift-MouseL",
	ActionBindable = true,
}

-- update shortcut name for use below
local shortcut
function OnMsg.ShortcutsReloaded()
	local action = table.find_value(XShortcutsTarget.actions, "ActionId", "ChoGGi_ClickToMove")
	if action then
		shortcut = action.ActionShortcut
	end
end

-- override SelectionModeDialog clicking if it's our shortcut
local CreateRealTimeThread = CreateRealTimeThread
local MouseShortcut = MouseShortcut
local orig_SelectionModeDialog_OnMouseButtonDown = SelectionModeDialog.OnMouseButtonDown
function SelectionModeDialog:OnMouseButtonDown(pt, button, ...)
	if MouseShortcut(button) == shortcut then
		return CreateRealTimeThread(go_to_mouse)
	end
	return orig_SelectionModeDialog_OnMouseButtonDown(self, pt, button, ...)
end

local mod_id = "ChoGGi_ShiftClickToMove"
local mod = Mods[mod_id]

local edge_scrolling = true
function OnMsg.ApplyModOptions(id)
	if id ~= mod_id then
		return
	end

	edge_scrolling = mod.options.EdgeScrolling

	if edge_scrolling then
		cameraRTS.SetProperties(1, {ScrollBorder = 5})
	else
		cameraRTS.SetProperties(1, {ScrollBorder = 0})
	end
end

-- disable edge scrolling on load
local function StartupCode()
	if not edge_scrolling then
		cameraRTS.SetProperties(1, {ScrollBorder = 0})
	end
end

OnMsg.CityStart = StartupCode
OnMsg.LoadGame = StartupCode

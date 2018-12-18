-- See LICENSE for terms

-- tell people how to get my library mod (if needs be)
local fire_once
function OnMsg.ModsReloaded()
	if fire_once then
		return
	end
	fire_once = true

	-- version to version check with
	local min_version = 48
	local idx = table.find(ModsLoaded,"id","ChoGGi_Library")

	-- if we can't find mod or mod is less then min_version (we skip steam since it updates automatically)
	if not idx or idx and not Platform.steam and min_version > ModsLoaded[idx].version then
		CreateRealTimeThread(function()
			if WaitMarsQuestion(nil,"Error",string.format([[Click To Move requires ChoGGi's Library (at least v%s).
Press Ok to download it or check Mod Manager to make sure it's enabled.]],min_version)) == "ok" then
				OpenUrl("https://steamcommunity.com/sharedfiles/filedetails/?id=1504386374")
			end
		end)
	end
end

-- move cam to mouse pos
local ViewObjectRTS = ViewObjectRTS
local GetTerrainCursor = GetTerrainCursor
local function go_to_mouse()
	ViewObjectRTS(GetTerrainCursor())
end

-- generate is late enough that my library is loaded, but early enough to replace anything i need to
function OnMsg.ClassesGenerate()

	-- unforbid binding some keys
	local forbid = ForbiddenShortcutKeys
	forbid.Lwin = nil
	forbid.Rwin = nil
	forbid.MouseL = nil
	forbid.MouseR = nil
	forbid.MouseM = nil

	local S = ChoGGi.Strings
	local Actions = ChoGGi.Temp.Actions

	Actions[#Actions+1] = {ActionName = [[Click To Move]],
		ActionId = "ChoGGi_ClickToMove",
		ActionShortcut = "Shift-MouseL",
		ActionBindable = true,
	}

end

-- update shortcut name for use below
local shortcut
function OnMsg.ShortcutsReloaded()
	local action = table.find_value(XShortcutsTarget.actions,"ActionId","ChoGGi_ClickToMove")
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

-- disable edge scrolling
local function StartupCode()
	if not CtrlClickToMove.MouseScrolling then
		cameraRTS.SetProperties(1,{ScrollBorder = 0})
	end
end

function OnMsg.CityStart()
	StartupCode()
end

function OnMsg.LoadGame()
	StartupCode()
end

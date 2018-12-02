-- speed up/down actions
local orig_SetGameSpeedState = SetGameSpeedState
function SetGameSpeedState(speed,...)
	if speed == "pause" then
		speed = "play"
	end
	orig_SetGameSpeedState(speed,...)
end

local function NeverPause()
	local hud = GetHUD()
	if hud then
		hud.idPlay:Press()
	end
end

local function UpdateActions()
	local XShortcutsTarget = XShortcutsTarget
	local idx = table.find(XShortcutsTarget.actions,"ActionId","actionPauseGame")
	if idx then
		XShortcutsTarget.actions[idx].OnAction = NeverPause
	end
end

-- hide pause button when hud is added/change what spacebar does
function OnMsg.InGameInterfaceCreated()
	local hud = GetHUD()
	if hud then
		hud.idPause:SetVisible(false)
	end

	UpdateActions()
end

-- change spacebar pause when bindings change
function OnMsg.ShortcutsReloaded()
	UpdateActions()
end

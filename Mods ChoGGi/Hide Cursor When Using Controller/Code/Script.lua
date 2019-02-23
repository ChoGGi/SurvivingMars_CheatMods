-- See LICENSE for terms

-- local some globals
local IsMouseCursorHidden = IsMouseCursorHidden
local engineHideMouseCursor = engineHideMouseCursor
local engineShowMouseCursor = engineShowMouseCursor


local function Show()
	g_MouseConnected = true
	hr.EnablePreciseSelection = 1
	if next(ForceHideMouseReasons) == nil and next(ShowMouseReasons) then
		engineShowMouseCursor()
	end
end

local function Hide()
	g_MouseConnected = false
	hr.EnablePreciseSelection = 0
	engineHideMouseCursor()
	terminal.desktop:ResetMousePosTarget()
end

-- toggle visiblity on connection
OnMsg.OnXInputControllerConnected = Hide
OnMsg.OnXInputControllerDisconnected = Show

-- hide cursor on load if controller is active
function OnMsg.LoadGame()
	if XPlayerActive then
		Hide()
	end
end
-- update on alt-tab
function OnMsg.SystemActivate()
	-- always start off with showing it, so it doesn't show system cursor
	engineShowMouseCursor()

	if XPlayerActive then
		Hide()
	end
end

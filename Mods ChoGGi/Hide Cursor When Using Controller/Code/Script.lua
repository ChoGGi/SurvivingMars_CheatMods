-- See LICENSE for terms

-- local some globals
local IsMouseCursorHidden = IsMouseCursorHidden
local engineHideMouseCursor = engineHideMouseCursor
local engineShowMouseCursor = engineShowMouseCursor

-- hide cursor on load if controller is active
function OnMsg.LoadGame()
	if XPlayerActive then
		engineHideMouseCursor()
	end
end

-- toggle visiblity on connection
function OnMsg.OnXInputControllerConnected()
	engineHideMouseCursor()
end
function OnMsg.OnXInputControllerDisconnected()
	engineShowMouseCursor()
end

-- update on alt-tab
function OnMsg.SystemActivate()
	-- always start off with showing it, so it doesn't show system cursor
	engineShowMouseCursor()

	if XPlayerActive then
		engineHideMouseCursor()
	end
end

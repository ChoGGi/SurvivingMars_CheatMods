-- See LICENSE for terms

local table_find = table.find

local options
local lookup_pauses = {}

-- fired when settings are changed/init
local function ModOptions()
	local OnScreenNotificationPresets = OnScreenNotificationPresets
	for id in pairs(OnScreenNotificationPresets) do
		lookup_pauses[id] = options:GetProperty(id)
	end
end

-- load default/saved settings
function OnMsg.ModsReloaded()
	options = CurrentModOptions
	ModOptions()
end

-- fired when option is changed
function OnMsg.ApplyModOptions(id)
	if id ~= CurrentModId then
		return
	end

	ModOptions()
end

-- causes issues with loading new game (freeze)
local disable_pause = true
local function StartupCode()
	disable_pause = nil
end

OnMsg.CityStart = StartupCode
OnMsg.LoadGame = StartupCode

local function PauseGame(id, func, ...)
	if not disable_pause and lookup_pauses[id] and not table_find(g_ActiveOnScreenNotifications, 1, id) then
		UICity:SetGameSpeed(0)
		UISpeedState = "pause"
	end
	return func(id, ...)
end

-- pause when new notif happens
local orig_AddOnScreenNotification = AddOnScreenNotification
function AddOnScreenNotification(id, ...)
	return PauseGame(id, orig_AddOnScreenNotification, ...)
end

local orig_AddCustomOnScreenNotification = AddCustomOnScreenNotification
function AddCustomOnScreenNotification(id, ...)
	return PauseGame(id, orig_AddCustomOnScreenNotification, ...)
end

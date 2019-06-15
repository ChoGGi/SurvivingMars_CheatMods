-- See LICENSE for terms

local options
local lookup_skips = {}

-- fired when settings are changed and new/load
local function ModOptions()
	local OnScreenNotificationPresets = OnScreenNotificationPresets
	for id in pairs(OnScreenNotificationPresets) do
		lookup_skips[id] = options[id]
	end
end

-- load default/saved settings
function OnMsg.ModsReloaded()
	options = CurrentModOptions
	ModOptions()
end

-- fired when option is changed
function OnMsg.ApplyModOptions(id)
	if id ~= "ChoGGi_NotificationPause" then
		return
	end

	ModOptions()
end

local function PauseGame(id, func, ...)
	if lookup_skips[id] then
		SetGameSpeedState("pause")
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

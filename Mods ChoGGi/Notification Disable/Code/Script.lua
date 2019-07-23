-- See LICENSE for terms

local options
local lookup_disable = {}

-- fired when settings are changed/init
local function ModOptions()
	local OnScreenNotificationPresets = OnScreenNotificationPresets
	for id in pairs(OnScreenNotificationPresets) do
		lookup_disable[id] = options[id]
	end
end

-- load default/saved settings
function OnMsg.ModsReloaded()
	options = CurrentModOptions
	ModOptions()
end

-- fired when option is changed
function OnMsg.ApplyModOptions(id)
	if id ~= "ChoGGi_NotificationDisable" then
		return
	end

	ModOptions()
end

local function SkipNot(func, id, ...)
	if not lookup_disable[id] then
		return func(id, ...)
	end
end

-- pause when new notif happens
local orig_AddOnScreenNotification = AddOnScreenNotification
function AddOnScreenNotification(id, ...)
	return SkipNot(orig_AddOnScreenNotification, id, ...)
end

local orig_AddCustomOnScreenNotification = AddCustomOnScreenNotification
function AddCustomOnScreenNotification(id, ...)
	return SkipNot(orig_AddCustomOnScreenNotification, id, ...)
end

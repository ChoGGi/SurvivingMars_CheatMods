-- See LICENSE for terms

local lookup_disable = {}

-- fired when settings are changed/init
local function ModOptions()
	local options = CurrentModOptions
	local OnScreenNotificationPresets = OnScreenNotificationPresets
	for id in pairs(OnScreenNotificationPresets) do
		lookup_disable[id] = options:GetProperty(id)
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

local function SkipNot(func, id, ...)
	if not lookup_disable[id] then
		return func(id, ...)
	end
end

-- pause when new notif happens
local ChoOrig_AddOnScreenNotification = AddOnScreenNotification
function AddOnScreenNotification(id, ...)
	return SkipNot(ChoOrig_AddOnScreenNotification, id, ...)
end

local ChoOrig_AddCustomOnScreenNotification = AddCustomOnScreenNotification
function AddCustomOnScreenNotification(id, ...)
	return SkipNot(ChoOrig_AddCustomOnScreenNotification, id, ...)
end

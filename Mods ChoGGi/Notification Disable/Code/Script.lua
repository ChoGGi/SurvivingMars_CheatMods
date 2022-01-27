-- See LICENSE for terms

local lookup_disable = {}

local function ModOptions(id)
	-- id is from ApplyModOptions
	if id and id ~= CurrentModId then
		return
	end

	local options = CurrentModOptions
	local OnScreenNotificationPresets = OnScreenNotificationPresets
	for id in pairs(OnScreenNotificationPresets) do
		lookup_disable[id] = options:GetProperty(id)
	end
end
-- Load default/saved settings
OnMsg.ModsReloaded = ModOptions
-- Fired when Mod Options>Apply button is clicked
OnMsg.ApplyModOptions = ModOptions

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

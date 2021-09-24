-- See LICENSE for terms

local table = table

local lookup_pauses = {}

-- fired when settings are changed/init
local function ModOptions()
	local options = CurrentModOptions
	local OnScreenNotificationPresets = OnScreenNotificationPresets
	for id in pairs(OnScreenNotificationPresets) do
		lookup_pauses[id] = options:GetProperty(id)
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

-- causes issues with loading new game (freeze)
local disable_pause = true
local function StartupCode()
	disable_pause = nil
end

OnMsg.CityStart = StartupCode
OnMsg.LoadGame = StartupCode

local function PauseGame(id, func, ...)
	if not disable_pause and lookup_pauses[id] and not table.find(g_ActiveOnScreenNotifications, 1, id) then
		UIColony:SetGameSpeed(0)
		UISpeedState = "pause"
	end
	return func(id, ...)
end

-- pause when new notif happens
local ChoOrig_AddOnScreenNotification = AddOnScreenNotification
function AddOnScreenNotification(id, ...)
	return PauseGame(id, ChoOrig_AddOnScreenNotification, ...)
end

local ChoOrig_AddCustomOnScreenNotification = AddCustomOnScreenNotification
function AddCustomOnScreenNotification(id, ...)
	return PauseGame(id, ChoOrig_AddCustomOnScreenNotification, ...)
end

-- See LICENSE for terms

local table = table

local lookup_pauses = {}

local function ModOptions(id)
	-- id is from ApplyModOptions
	if id and id ~= CurrentModId then
		return
	end

	local options = CurrentModOptions
	local OnScreenNotificationPresets = OnScreenNotificationPresets
	for id in pairs(OnScreenNotificationPresets) do
		lookup_pauses[id] = options:GetProperty(id)
	end
end
-- Load default/saved settings
OnMsg.ModsReloaded = ModOptions
-- Fired when Mod Options>Apply button is clicked
OnMsg.ApplyModOptions = ModOptions

-- Causes issues with loading new game (freeze)
local disable_pause = true
local function StartupCode()
	disable_pause = false
end
OnMsg.CityStart = StartupCode
OnMsg.LoadGame = StartupCode

local function PauseGame(id, callback, params, func, ...)
	-- I shouldn't have to check for an id, as that's needed for picard update, but doesn't mean every mod is updated for picard
	if id then
		-- Not loading game and id in list
		local map_id = id .. UICity.map_id
--~ 		if not disable_pause and lookup_pauses[map_id] then
		if not disable_pause and lookup_pauses[id] then
				-- Don't pause for "0" notifications (eg: Buildings Not Working 0)
			if not params or params and (params.count or 0) > 0
				-- Don't pause for stuff already in onscreen notifactions list
				and not table.find(g_ActiveOnScreenNotifications, 1, map_id)
			then
				UIColony:SetGameSpeed(0)
				UISpeedState = "pause"
			end
		end
	end

	return func(id, callback, params, ...)
end

-- Pause when new notif happens
local ChoOrig_AddOnScreenNotification = AddOnScreenNotification
function AddOnScreenNotification(id, callback, params, ...)
	return PauseGame(id, callback, params, ChoOrig_AddOnScreenNotification, ...)
end

local ChoOrig_AddCustomOnScreenNotification = AddCustomOnScreenNotification
function AddCustomOnScreenNotification(id, callback, params, ...)
	return PauseGame(id, callback, params, ChoOrig_AddCustomOnScreenNotification, ...)
end

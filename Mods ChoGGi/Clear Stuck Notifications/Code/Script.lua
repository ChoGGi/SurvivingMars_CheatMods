-- See LICENSE for terms

local RemoveOnScreenNotification = RemoveOnScreenNotification

local mod_ClearMysteries
local mod_ClearAll
local mod_ClearMysteryLog

local function StartupCode()
	if not UICity then
		return
	end

	local OnScreenNotificationPresets = OnScreenNotificationPresets
	for id in pairs(OnScreenNotificationPresets) do
		if id == "MysteryLog" then
			if mod_ClearMysteryLog then
				RemoveOnScreenNotification("MysteryLog", UICity.map_id)
				RemoveOnScreenNotification("MysteryLog")
			end
		else
			if mod_ClearAll then
				RemoveOnScreenNotification(id, UICity.map_id)
				RemoveOnScreenNotification(id)
			elseif mod_ClearMysteries and id:sub(1, 7) == "Mystery" then
				RemoveOnScreenNotification(id, UICity.map_id)
				RemoveOnScreenNotification(id)
			end
		end
	end
end

OnMsg.CityStart = StartupCode
OnMsg.LoadGame = StartupCode
-- switch between different maps (happens before UICity)
OnMsg.ChangeMapDone = StartupCode

local function ModOptions(id)
	-- id is from ApplyModOptions
	if id and id ~= CurrentModId then
		return
	end

	mod_ClearMysteries = CurrentModOptions:GetProperty("ClearMysteries")
	mod_ClearAll = CurrentModOptions:GetProperty("ClearAll")
	mod_ClearMysteryLog = CurrentModOptions:GetProperty("ClearMysteryLog")

	-- make sure we're in-game UIColony
	if not UICity then
		return
	end

	StartupCode()
end
-- Load default/saved settings
OnMsg.ModsReloaded = ModOptions
-- Fired when Mod Options>Apply button is clicked
OnMsg.ApplyModOptions = ModOptions

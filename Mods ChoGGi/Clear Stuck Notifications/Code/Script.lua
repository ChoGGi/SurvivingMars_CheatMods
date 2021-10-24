-- See LICENSE for terms

local RemoveOnScreenNotification = RemoveOnScreenNotification

local mod_EnableMod
local mod_ClearAll

local function StartupCode()
	if not mod_EnableMod or not UICity then
		return
	end

	local OnScreenNotificationPresets = OnScreenNotificationPresets
	for id in pairs(OnScreenNotificationPresets) do
		if mod_ClearAll then
			RemoveOnScreenNotification(id, UICity.map_id)
			RemoveOnScreenNotification(id)
		elseif id ~= "MysteryLog" and id:sub(1, 7) == "Mystery" then
			RemoveOnScreenNotification(id, UICity.map_id)
			RemoveOnScreenNotification(id)
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

	mod_EnableMod = CurrentModOptions:GetProperty("EnableMod")
	mod_ClearAll = CurrentModOptions:GetProperty("ClearAll")

	-- make sure we're in-game UIColony
	if not UICity then
		return
	end

	StartupCode()
end
-- load default/saved settings
OnMsg.ModsReloaded = ModOptions
-- fired when Mod Options>Apply button is clicked
OnMsg.ApplyModOptions = ModOptions

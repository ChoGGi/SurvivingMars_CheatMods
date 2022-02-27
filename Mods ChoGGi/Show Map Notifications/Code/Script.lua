-- See LICENSE for terms

if not g_AvailableDlc.picard then
	print(CurrentModDef.title, ": Below & Beyond DLC not installed!")
	return
end

local mod_EnableMod

local table = table
local T = T

local ChoOrig_MapSwitch_GetEntries = MapSwitch.GetEntries
function MapSwitch:GetEntries(...)
	if not mod_EnableMod then
		return ChoOrig_MapSwitch_GetEntries(self, ...)
	end

	local g_ActiveOnScreenNotifications = g_ActiveOnScreenNotifications
	local OnScreenNotificationPresets = OnScreenNotificationPresets

	local realms = ChoOrig_MapSwitch_GetEntries(self, ...)
	for i = 1, #realms do
		local realm = realms[i]

		local map_notifications = table.ifilter(g_ActiveOnScreenNotifications, function(_, v)
			return v[5] == realm.Map
		end)

		if #map_notifications > 0 then
			local notifs_text = {}

			for j = 1, #map_notifications do
				local notif = map_notifications[j][3]

				-- ugly but good enough
				if notif.rollover_title then
					local count = ""
					if notif.count then
						count = ": " .. notif.count
					end
					notifs_text[j] = notif.rollover_title .. count
				else
					notifs_text[j] =  T{OnScreenNotificationPresets[notif.preset_id].text,
						count = notif.count or "",
					}
				end

			end

			realm.RolloverText = realm.RolloverText .. T("\n\n<green>") .. T(7582--[[Notifications]])
				.. T(":</green>\n") .. table.concat(notifs_text, "\n")
		end

	end

	return realms
end

local function ModOptions(id)
	-- id is from ApplyModOptions
	if id and id ~= CurrentModId then
		return
	end

	mod_EnableMod = CurrentModOptions:GetProperty("EnableMod")
end
-- Load default/saved settings
OnMsg.ModsReloaded = ModOptions
-- Fired when Mod Options>Apply button is clicked
OnMsg.ApplyModOptions = ModOptions

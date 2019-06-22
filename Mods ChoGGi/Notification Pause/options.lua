-- See LICENSE for terms

-- build sorted list of all notifications
local properties = {}
local c = 0
local OnScreenNotificationPresets = OnScreenNotificationPresets
for id, item in pairs(OnScreenNotificationPresets) do
	c = c + 1
	properties[c] = {
		default = item.priority and (item.priority:sub(1,8) == "Critical"
			or item.priority:sub(1,9) == "Important") or false,
		editor = "bool",
		id = id,
		-- max 40 chars
		name = id,
	}
end

local CmpLower = CmpLower
table.sort(properties, function(a, b)
	return CmpLower(a.name, b.name)
end)

DefineClass("ModOptions_ChoGGi_NotificationPause", {
	__parents = {
		"ModOptionsObject",
	},
	properties = properties,
})

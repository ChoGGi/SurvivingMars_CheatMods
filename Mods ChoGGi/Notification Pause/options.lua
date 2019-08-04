-- See LICENSE for terms

local T = T
-- build sorted list of all notifications
local properties = {}
local c = 0
local OnScreenNotificationPresets = OnScreenNotificationPresets
for id, item in pairs(OnScreenNotificationPresets) do
	local priority
	if item.priority then
		if item.priority:sub(1,8) == "Critical" then
			priority = 1
		elseif item.priority:sub(1,9) == "Important" then
			priority = 2
		end
	end

	-- add colour to some of them
	local name
	if priority then
		if priority == 1 then
			name = id .. " " .. "<red>" .. T(item.title) .. "</red>"
		elseif priority == 2 then
			name = id .. " " .. "<color 115 117 216>" .. T(item.title) .. "</color>"
		end
	else
		name = id .. " " .. T(item.title)
	end

	c = c + 1
	properties[c] = {
		default = priority and true or false,
		editor = "bool",
		id = id,
		-- max 40 chars
		name = T(name),
	}
end

local CmpLower = CmpLower
table.sort(properties, function(a, b)
	return CmpLower(a.id, b.id)
end)

DefineClass("ModOptions_ChoGGi_NotificationPause", {
	__parents = {
		"ModOptionsObject",
	},
	properties = properties,
})

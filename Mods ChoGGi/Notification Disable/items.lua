-- See LICENSE for terms

local table = table
local T = T

-- build sorted list of all notifications
local mod_options = {}
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
			name = "<red>" .. id .. "</red>"
		else
			name = "<color 115 117 216>" .. id .. "</color>"
		end
	else
		name = id
	end
	local voiced = ""
	if item.voiced_text and item.voiced_text ~= "" then
		voiced = "\n\n" .. T(item.voiced_text)
	end

	c = c + 1
	mod_options[c] = PlaceObj("ModItemOptionToggle", {
		"name", id,
		"DisplayName", T(name),
		"Help", table.concat(T(item.title) .. "\n" .. T(item.text) .. voiced
			.. "\n\n<image " .. item.image .. ">"),
		"DefaultValue", false,
	})

end

local CmpLower = CmpLower
table.sort(mod_options, function(a, b)
	return CmpLower(a.name, b.name)
end)

return mod_options

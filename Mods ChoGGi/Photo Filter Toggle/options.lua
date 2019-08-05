-- See LICENSE for terms

local properties = {}
local c = 0

local PhotoFilterPresetMap = PhotoFilterPresetMap
for id, item in pairs(PhotoFilterPresetMap) do
	if id ~= "None" then
		c = c + 1
		properties[c] = {
			default = false,
			editor = "bool",
			id = id,
			name = T(item.displayName),
		}
	end
end

local CmpLower = CmpLower
table.sort(properties, function(a, b)
	return CmpLower(a.id, b.id)
end)

-- max 40 chars
DefineClass("ModOptions_ChoGGi_PhotoFilterToggle", {
	__parents = {
		"ModOptionsObject",
	},
	properties = properties,
})

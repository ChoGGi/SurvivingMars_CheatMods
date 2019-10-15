-- See LICENSE for terms

local properties = {}
local c = 0

local PhotoFilterPresetMap = PhotoFilterPresetMap
for id, item in pairs(PhotoFilterPresetMap) do
	if id ~= "None" then
		c = c + 1
		properties[c] = PlaceObj("ModItemOptionToggle", {
			"name", id,
			"DisplayName", T(item.displayName),
			"Help", T(item.desc),
			"DefaultValue", false,
		})
	end
end

local CmpLower = CmpLower
local _InternalTranslate = _InternalTranslate
table.sort(properties, function(a, b)
	return CmpLower(_InternalTranslate(a.DisplayName), _InternalTranslate(b.DisplayName))
end)

return properties
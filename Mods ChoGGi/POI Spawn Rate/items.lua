-- See LICENSE for terms

local table_concat = table.concat
local T = T

local properties = {}
local c = 0

local POIPresets = POIPresets
for id, poi in pairs(POIPresets) do
	if poi.spawn_period then
		c = c + 1
		properties[c] = PlaceObj("ModItemOptionNumber", {
			"name", id .. "_Min",
			"DisplayName", table_concat(T(poi.display_name) .. " " .. T(302535920011382, "Min")),
			"Help", T(302535920011524, "WARNING: Make sure min isn't above max or it won't work correctly."),
			"DefaultValue", poi.spawn_period.from or 1,
			"MinValue", 1,
			"MaxValue", 100,
		})
		c = c + 1
		properties[c] = PlaceObj("ModItemOptionNumber", {
			"name", id .. "_Max",
			"DisplayName", table_concat(T(poi.display_name) .. " " .. T(8780, "MAX")),
			"Help", T(302535920011524, "WARNING: Make sure min isn't above max or it won't work correctly."),
			"DefaultValue", poi.spawn_period.to or 1,
			"MinValue", 1,
			"MaxValue", 100,
		})
	end
end

local CmpLower = CmpLower
local _InternalTranslate = _InternalTranslate
table.sort(properties, function(a, b)
	return CmpLower(_InternalTranslate(a.name), _InternalTranslate(b.name))
end)

return properties

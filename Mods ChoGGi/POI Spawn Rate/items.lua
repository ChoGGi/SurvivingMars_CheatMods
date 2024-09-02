-- See LICENSE for terms

local table = table
local T = T

local mod_options = {}
local c = #mod_options

local POIPresets = POIPresets
for id, poi in pairs(POIPresets) do
	if poi.spawn_period then
		c = c + 1
		mod_options[c] = PlaceObj("ModItemOptionNumber", {
			"name", id .. "_Min",
			"DisplayName", table.concat(T(poi.display_name) .. " " .. T(302535920011382, "Min")),
			"Help", T(302535920011524, "WARNING: Make sure min isn't above max or it won't work correctly."),
			"DefaultValue", poi.spawn_period.from or 1,
			"MinValue", 1,
			"MaxValue", 100,
		})
		c = c + 1
		mod_options[c] = PlaceObj("ModItemOptionNumber", {
			"name", id .. "_Max",
			"DisplayName", table.concat(T(poi.display_name) .. " " .. T(8780, "MAX")),
			"Help", T(302535920011524, "WARNING: Make sure min isn't above max or it won't work correctly."),
			"DefaultValue", poi.spawn_period.to or 1,
			"MinValue", 1,
			"MaxValue", 100,
		})
	end
end

local CmpLower = CmpLower
local _InternalTranslate = _InternalTranslate
table.sort(mod_options, function(a, b)
	return CmpLower(_InternalTranslate(a.name), _InternalTranslate(b.name))
end)

return mod_options

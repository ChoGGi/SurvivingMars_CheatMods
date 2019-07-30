-- See LICENSE for terms

local properties = {}
local c = 0

local POIPresets = POIPresets
for id, poi in pairs(POIPresets) do
	c = c + 1
	properties[c] = {
		default = poi.spawn_period.from or 1,
		max = 100,
		min = 1,
		editor = "number",
		id = id .. "_Min",
		name = T(poi.display_name),
	}
	c = c + 1
	properties[c] = {
		default = poi.spawn_period.to or 1,
		max = 100,
		min = 1,
		editor = "number",
		id = id .. "_Max",
		name = T(poi.display_name) .. " " .. T(8780, "MAX"),
	}
end
local CmpLower = CmpLower
local _InternalTranslate = _InternalTranslate
table.sort(properties, function(a, b)
	return CmpLower(_InternalTranslate(a.name), _InternalTranslate(b.name))
end)

-- max 40 chars
DefineClass("ModOptions_ChoGGi_POISpawnRate", {
	__parents = {
		"ModOptionsObject",
	},
	properties = properties,
})

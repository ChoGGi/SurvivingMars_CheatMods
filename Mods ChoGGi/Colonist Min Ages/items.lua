-- See LICENSE for terms

local PlaceObj = PlaceObj
local T = T
local table = table

local properties = {
	PlaceObj("ModItemOptionToggle", {
		"name", "EnableMod",
		"DisplayName", T(302535920011303, "<color ChoGGi_yellow>Enable Mod</color>"),
		"Help", T(302535920011793, "Disable mod without having to see missing mod msg."),
		"DefaultValue", true,
	}),
}
local c = 1

local Colonist = Colonist
local ColonistAgeGroups = const.ColonistAgeGroups
for id, item in pairs(ColonistAgeGroups) do
		c = c + 1
		properties[c] = PlaceObj("ModItemOptionNumber", {
			"name", id,
			"DisplayName", table.concat(T(3929, "Age Group") .. " " .. T(item.display_name)),
			"Help", T(item.description),
			"DefaultValue", Colonist:GetProperty("MinAge_" .. id),
			"MinValue", 0,
			"MaxValue", 250,
		})
end

local CmpLower = CmpLower
local _InternalTranslate = _InternalTranslate
table.sort(properties, function(a, b)
	return CmpLower(_InternalTranslate(a.DisplayName), _InternalTranslate(b.DisplayName))
end)

return properties

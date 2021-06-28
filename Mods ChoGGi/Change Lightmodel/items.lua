-- See LICENSE for terms

local PlaceObj = PlaceObj
local T = T

local properties = {}
local c = 0

local lightmodels = {
	"Terraformed",
	"TheMartian",
}
for i = 1, #lightmodels do
	local id = lightmodels[i]
		c = c + 1
		properties[c] = PlaceObj("ModItemOptionToggle", {
			"name", "mod_" .. id,
			"DisplayName", id,
			"DefaultValue", false,
		})
end

local CmpLower = CmpLower
local _InternalTranslate = _InternalTranslate
table.sort(properties, function(a, b)
	return CmpLower(_InternalTranslate(a.DisplayName), _InternalTranslate(b.DisplayName))
end)

table.insert(properties, 1, PlaceObj("ModItemOptionToggle", {
	"name", "EnableMod",
	"DisplayName", T(302535920011303, "<color ChoGGi_yellow>Enable Mod</color>"),
	"Help", T(302535920011793, "Disable mod without having to see missing mod msg."),
	"DefaultValue", true,
}))

return properties

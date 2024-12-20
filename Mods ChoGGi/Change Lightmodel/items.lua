-- See LICENSE for terms

local PlaceObj = PlaceObj
local T = T

local mod_options = {}
local c = #mod_options

local lightmodels = {
	"Terraformed",
	"TheMartian",

	"Asteroid",
	"ColdWave",
	"Curiosity",
	"Dreamers",
	"DustStorm",
	"GreatDustStorm",
	"ToxicRain",
	"WaterRain",
}
--~ LightmodelPresets
--~ LightmodelLists

for i = 1, #lightmodels do
	local id = lightmodels[i]
		c = c + 1
		mod_options[c] = PlaceObj("ModItemOptionToggle", {
			"name", "mod_" .. id,
			"DisplayName", id,
			"DefaultValue", false,
		})
end

local CmpLower = CmpLower
local _InternalTranslate = _InternalTranslate
table.sort(mod_options, function(a, b)
	return CmpLower(_InternalTranslate(a.DisplayName), _InternalTranslate(b.DisplayName))
end)

table.insert(mod_options, 1, PlaceObj("ModItemOptionToggle", {
	"name", "EnableMod",
	"DisplayName", T(302535920011303, "<color ChoGGi_yellow>Enable Mod</color>"),
	"Help", T(302535920011793, "Disable mod without having to see missing mod msg."),
	"DefaultValue", true,
}))

return mod_options

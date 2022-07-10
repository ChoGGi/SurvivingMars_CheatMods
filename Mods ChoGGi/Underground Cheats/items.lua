-- See LICENSE for terms

local properties = {
	PlaceObj("ModItemOptionToggle", {
		"name", "EnableMod",
		"DisplayName", T(302535920011303, "<color ChoGGi_yellow>Enable Mod</color>"),
		"Help", T(302535920011793, "Disable mod without having to see missing mod msg."),
		"DefaultValue", true,
	}),
	PlaceObj("ModItemOptionNumber", {
		"name", "LightTripodRadius",
		"DisplayName", T(0000, "Light Tripod Radius"),
		"DefaultValue", BuildingTemplates.LightTripod.reveal_range,
		"MinValue", 1,
		"MaxValue", 1000,
--~ 		"StepSize", 10,
	}),
	PlaceObj("ModItemOptionNumber", {
		"name", "SupportStrutRadius",
		"DisplayName", T(0000, "Support Strut Radius"),
		"DefaultValue", SupportStruts.work_radius,
		"MinValue", 1,
		"MaxValue", 500,
	}),
}

local c = 3

local wonder_desc = T(0000, "Turn on to let this wonder spawn underground.")

local bt = BuildingTemplates
local wonders = const.BuriedWonders
for i = 1, #wonders do
	c = c + 1
	local id = wonders[i]
	properties[c] = PlaceObj("ModItemOptionToggle", {
		"name", id,
		"DisplayName", table.concat(T(142--[[Wonder]]) .. ": " .. T(bt[id].display_name)),
		"Help", table.concat(wonder_desc .. "\n\n" .. T(bt[id].description)),
		"DefaultValue", true,
	})
end

local CmpLower = CmpLower
local _InternalTranslate = _InternalTranslate
table.sort(properties, function(a, b)
	return CmpLower(_InternalTranslate(a.DisplayName), _InternalTranslate(b.DisplayName))
end)

return properties

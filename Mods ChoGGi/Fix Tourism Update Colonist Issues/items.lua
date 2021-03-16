-- See LICENSE for terms

return {
	PlaceObj("ModItemOptionToggle", {
		"name", "EnableMod",
		"DisplayName", T(302535920011303, "Enable Mod"),
		"Help", T(302535920011793, "Disable mod without having to see missing mod msg."),
		"DefaultValue", true,
	}),
	PlaceObj("ModItemOptionNumber", {
		"name", "ExampleInt",
		"DisplayName", T(0000, "DisplayedName"),
		"Help", T(0000, "TooltipForOption"),
		"DefaultValue", 100,
		"MinValue", 0,
		"MaxValue", 500,
		"StepSize", 10,
	}),
	PlaceObj("ModItemOptionInputBox", {
		"name", "ExampleName",
		"DisplayName", T(0000, "DisplayedName"),
		"Help", T(0000, "freeform text input"),
		"DefaultValue", "255,70,70",
	}),
	PlaceObj('ModItemOptionChoice', {
		"name", "ExampleList",
		"DisplayName", T(0000, "DisplayedName"),
		"Help", T(0000, "TooltipForOption"),
		'DefaultValue', T(0000, "Option1"),
		'ChoiceList', {
			T(0000, "Option2"),
			T(0000, "Option1"),
		},
	}),
}


table.concat(T(0000, "MarkBuildings") .. " " .. T(0000, "MarkBuildings"))

-- See LICENSE for terms

local PlaceObj = PlaceObj
local T = T

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

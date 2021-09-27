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
	PlaceObj("ModItemOptionToggle", {
		"name", "SwitchMystery",
		"DisplayName", T(302535920012070, "<color ChoGGi_yellow>Switch Mystery</color>"),
		"Help", T(302535920012071, [[Turn this on to pick a new random mystery when you press Apply.

You will lose all progress in current mystery and it may cause unexpected issues!]]),
		"DefaultValue", false,
	}),
	PlaceObj("ModItemOptionToggle", {
		"name", "ShowMystery",
		"DisplayName", T(302535920012072, "<color ChoGGi_yellow>Show Popup Mystery</color>"),
		"Help", T(302535920012073, "The popup msg will show the name of the new mystery."),
		"DefaultValue", false,
	}),
	PlaceObj("ModItemOptionToggle", {
		"name", "ShowPopup",
		"DisplayName", T(302535920012076, "<color ChoGGi_yellow>Show Popup</color>"),
		"Help", T(302535920012077, "Show a popup msg when starting next mystery."),
		"DefaultValue", true,
	}),
	PlaceObj("ModItemOptionNumber", {
		"name", "MinSols",
		"DisplayName", T(302535920012078, "<color ChoGGi_yellow>Min Sols</color>"),
		"Help", T(302535920012077, "How many Sols to wait before starting next mystery."),
		"DefaultValue", 5,
		"MinValue", 0,
		"MaxValue", 100,
	}),
	PlaceObj("ModItemOptionNumber", {
		"name", "MaxSols",
		"DisplayName", T(302535920012079, "<color ChoGGi_yellow>Max Sols</color>"),
		"Help", T(302535920012080, "How many Sols to wait before starting next mystery."),
		"DefaultValue", 15,
		"MinValue", 0,
		"MaxValue", 100,
	}),
}
local c = 6

local mysteries = ClassDescendantsList("MysteryBase")
local g_Classes = g_Classes
for i = 1, #mysteries do
	local myst = g_Classes[mysteries[i]]

	c = c + 1
	properties[c] = PlaceObj("ModItemOptionToggle", {
		"name", "MysteryClass_" .. myst.class,
		"DisplayName", table.concat(T(3486, "Mystery") .. ": " .. myst.display_name),
		"Help", myst.description,
		"DefaultValue", true,
	})
end


local CmpLower = CmpLower
local _InternalTranslate = _InternalTranslate
table.sort(properties, function(a, b)
	return CmpLower(_InternalTranslate(a.DisplayName), _InternalTranslate(b.DisplayName))
end)

return properties

-- See LICENSE for terms

return {
	PlaceObj("ModItemOptionInputBox", {
		"name", "HexColour",
		"DisplayName", T(302535920011835, "Hex Colour"),
		"Help", T(302535920011836, "<color ChoGGi_red>R</color> <color ChoGGi_green>G</color> <color ChoGGi_blue>B</color> colour code, yellow example: 255,255,0 (range is 0-255)"),
		"DefaultValue", "255,70,70",
	}),
	PlaceObj("ModItemOptionToggle", {
		"name", "Option1",
		"DisplayName", T(302535920011364, "Show during construction"),
		"DefaultValue", true,
	}),
	PlaceObj("ModItemOptionToggle", {
		"name", "SelectDome",
		"DisplayName", table.concat(T(131775917427, "Select") .. " " .. T(1234, "Dome")),
		"DefaultValue", false,
	}),
	PlaceObj("ModItemOptionToggle", {
		"name", "SelectOutside",
		"DisplayName", table.concat(T(131775917427, "Select") .. " " .. T(885971788025, "Outside Buildings")),
		"DefaultValue", false,
	}),
	PlaceObj("ModItemOptionNumber", {
		"name", "GridOpacity",
		"DisplayName", T(302535920011365, "Grid Opacity"),
		"DefaultValue", 50,
		"MinValue", 0,
		"MaxValue", 100,
	}),
	PlaceObj("ModItemOptionNumber", {
		"name", "GridScale",
		"DisplayName", T(302535920011366, "Grid Scale"),
		"DefaultValue", 100,
		"MinValue", 0,
		"MaxValue", 100,
	}),
	PlaceObj("ModItemOptionNumber", {
		"name", "DistFromCursor",
		"DisplayName", T(302535920011367, "Dist From Cursor"),
		"DefaultValue", 50,
		"MinValue", 0,
		"MaxValue", 250,
	}),
}

-- See LICENSE for terms

return {
	PlaceObj("ModItemOptionInputBox", {
		"name", "HexColourDroneHub",
		"DisplayName", table.concat(T(302535920011835, "Hex Colour") .. " " .. T(3518,"Drone Hub")),
		"Help", T(302535920011836, "<color ChoGGi_red>R</color> <color ChoGGi_green>G</color> <color ChoGGi_blue>B</color> colour code, yellow example: 255,255,0 (range is 0-255)"),
		"DefaultValue", "0,255,255",
	}),
	PlaceObj("ModItemOptionInputBox", {
		"name", "HexColourRCRover",
		"DisplayName", table.concat(T(302535920011835, "Hex Colour") .. " " .. T(4828,"RC Commander")),
		"Help", T(302535920011836, "<color ChoGGi_red>R</color> <color ChoGGi_green>G</color> <color ChoGGi_blue>B</color> colour code, yellow example: 255,255,0 (range is 0-255)"),
		"DefaultValue", "255,255,0",
	}),
	PlaceObj("ModItemOptionInputBox", {
		"name", "HexColourSupplyRocket",
		"DisplayName", table.concat(T(302535920011835, "Hex Colour") .. " " .. T(1685,"Rocket")),
		"Help", T(302535920011836, "<color ChoGGi_red>R</color> <color ChoGGi_green>G</color> <color ChoGGi_blue>B</color> colour code, yellow example: 255,255,0 (range is 0-255)"),
		"DefaultValue", "0,255,0",
	}),
	PlaceObj("ModItemOptionToggle", {
		"name", "Option1",
		"DisplayName", T(302535920011364, "Show during construction"),
		"DefaultValue", true,
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

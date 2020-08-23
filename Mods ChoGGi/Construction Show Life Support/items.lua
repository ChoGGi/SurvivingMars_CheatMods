return {
	PlaceObj("ModItemOptionToggle", {
		"name", "EnableMod",
		"DisplayName", T(302535920011364, "Show during construction"),
		"DefaultValue", true,
	}),
	PlaceObj("ModItemOptionNumber", {
		"name", "HexOpacity",
		"DisplayName", T(302535920011723, "Hex Opacity"),
		"DefaultValue", 100,
		"MinValue", 0,
		"MaxValue", 100,
	}),
	PlaceObj("ModItemOptionNumber", {
		"name", "DistFromCursor",
		"DisplayName", T(302535920011367, "Dist From Cursor"),
		"DefaultValue", 25,
		"MinValue", 0,
		"MaxValue", 250,
	}),
}

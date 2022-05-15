-- See LICENSE for terms

return {
	PlaceObj("ModItemOptionNumber", {
		"name", "SeedRatio",
		"DisplayName", T(0000, "Seed Ratio"),
		"Help", T(0000, "Default seed:food ratio 6:1"),
		"DefaultValue", 6,
		"MinValue", 1,
		"MaxValue", 100,
	}),
	PlaceObj("ModItemOptionNumber", {
		"name", "HourlyDelay",
		"DisplayName", T(0000, "Hourly Delay"),
		"Help", T(0000, "How many hours per food cube."),
		"DefaultValue", 3,
		"MinValue", 1,
		"MaxValue", 100,
	}),
	PlaceObj("ModItemOptionToggle", {
		"name", "HelpVeganHit",
		"DisplayName", T(0000, "Help Vegan Hit"),
		"Help", T(0000, "When near domes with ranches, vegan comfort hit is halved."),
		"DefaultValue", true,
	}),
}

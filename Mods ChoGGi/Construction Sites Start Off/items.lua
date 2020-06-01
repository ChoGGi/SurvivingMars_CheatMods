-- See LICENSE for terms

return {
	PlaceObj("ModItemOptionToggle", {
		"name", "TurnOff",
		"DisplayName", T(302535920011666, "Turn Off"),
		"Help", T(302535920011667, "Disable this to place buildings normally."),
		"DefaultValue", true,
	}),
	PlaceObj("ModItemOptionToggle", {
		"name", "SkipGrids",
		"DisplayName", T(302535920011671, "Skip Grids"),
		"Help", T(302535920011672, "Don't turn off cables and pipes."),
		"DefaultValue", false,
	}),
	PlaceObj("ModItemOptionToggle", {
		"name", "SkipPassages",
		"DisplayName", T(302535920011673, "Skip Passages"),
		"Help", T(302535920011674, "Don't turn off passages."),
		"DefaultValue", false,
	}),
}

return {
	PlaceObj("ModItemOptionToggle", {
		"name", "ShowClock",
		"DisplayName", T(302535920011359, "Show Clock"),
		"DefaultValue", true,
	}),
	PlaceObj("ModItemOptionToggle", {
		"name", "TimeFormat",
		"DisplayName", T(302535920011361, "24/12 Display"),
		"DefaultValue", true,
	}),
	PlaceObj("ModItemOptionToggle", {
		"name", "Background",
		"DisplayName", T(302535920011363, "Show Background"),
		"DefaultValue", false,
	}),
	PlaceObj("ModItemOptionNumber", {
		"name", "TextStyle",
		"DisplayName", T(302535920011362, "Styles"),
		"DefaultValue", 1,
		"MinValue", 1,
		"MaxValue", 9,
	}),
}

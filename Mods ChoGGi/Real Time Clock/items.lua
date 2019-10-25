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
		"Help", T(302535920011553, "Add black background to clock."),
		"DefaultValue", false,
	}),
	PlaceObj("ModItemOptionNumber", {
		"name", "TextStyle",
		"DisplayName", T(302535920011362, "Styles"),
		"Help", T(302535920011552, [[1. Orange large
2. White small
3. Blue medium
4. White smaller
5. Blue large
6. White large
7. Red medium
8. Blue Darker medium
9. Red Large]]),
		"DefaultValue", 1,
		"MinValue", 1,
		"MaxValue", 9,
	}),
}

-- See LICENSE for terms

return {
	PlaceObj("ModItemOptionToggle", {
		"name", "Shift1",
		"DisplayName", T(0000, "Shift 1"),
		"Help", T(0000, "Pause game on shift 1 (Morning 6-14)."),
		"DefaultValue", true,
	}),
	PlaceObj("ModItemOptionToggle", {
		"name", "Shift2",
		"DisplayName", T(0000, "Shift 2"),
		"Help", T(0000, "Pause game on shift 2 (Afternoon 14-22)."),
		"DefaultValue", true,
	}),
	PlaceObj("ModItemOptionToggle", {
		"name", "Shift3",
		"DisplayName", T(0000, "Shift 3"),
		"Help", T(0000, "Pause game on shift 3 (Night 22-6)."),
		"DefaultValue", true,
	}),
}

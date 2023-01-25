-- See LICENSE for terms

return {
	PlaceObj("ModItemOptionNumber", {
		"name", "NotepadWidth",
		"DisplayName", T(0000, "Notepad Width"),
		"DefaultValue", 800,
		"MinValue", 1,
		"MaxValue", 5000,
	}),
	PlaceObj("ModItemOptionNumber", {
		"name", "NotepadHeight",
		"DisplayName", T(0000, "Notepad Height"),
		"DefaultValue", 600,
		"MinValue", 1,
		"MaxValue", 5000,
	}),
	PlaceObj("ModItemOptionToggle", {
		"name", "AutoOpenNote",
		"DisplayName", T(0000, "Auto Open Note"),
		"Help", T(0000, "By default notes will auto-open, turn this off to make notes stay closed when selected."),
		"DefaultValue", true,
	}),

}

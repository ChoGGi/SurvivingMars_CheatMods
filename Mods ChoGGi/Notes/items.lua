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
}

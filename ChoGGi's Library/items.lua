return {
	PlaceObj("ModItemLocTable", {
		"language", "English",
		"filename", "Locales/English.csv",
	}),
	PlaceObj("ModItemOptionToggle", {
		"name", "ModOptionsButton",
		"DisplayName", table.concat(T(1000867, "Mod Options") .. " " .. T(3833,"Button")),
		"Help", T(302535920001446, "Add Mod Options button to Game Options."),
		"DefaultValue", true,
	}),
}

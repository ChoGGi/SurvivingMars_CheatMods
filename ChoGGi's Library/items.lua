return {
	PlaceObj("ModItemOptionToggle", {
		"name", "ModOptionsButton",
		"DisplayName", T(1000867, "Mod Options"),
		"Help", T(302535920001446, "Add Mod Options button to Game Options."),
		"DefaultValue", true,
	}),
	PlaceObj("ModItemOptionToggle", {
		"name", "ModOptionsExpanded",
		"DisplayName", T(302535920001451, "Mod Options Expanded"),
		"Help", T(302535920001466, [[Some changes to the mod options:

Remove the 400 MaxWidth added to the text.
Buttons to adjust the number slider.
Green/Red for Boolean On/Off.]]),
		"DefaultValue", true,
	}),
	PlaceObj("ModItemLocTable", {
		"language", "English",
		"filename", "Locales/English.csv",
	}),
}

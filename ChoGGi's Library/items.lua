return {
	PlaceObj("ModItemLocTable", {
		"language", "English",
		"filename", "Locales/English.csv",
	}),
	PlaceObj("ModItemOptionToggle", {
		"name", "ModOptionsButton",
		"DisplayName", table.concat(T(1000867, "Mod Options") .. " " .. T(3833, "Button")),
		"Help", T(302535920001446, "Add Mod Options button to Game Options."),
		"DefaultValue", true,
	}),
	PlaceObj("ModItemOptionToggle", {
		"name", "IgnorePersistErrors",
		"DisplayName", T(302535920000044, "Ignore Persist Errors"),
		"Help", T(302535920001302, "This prevents persist errors from spamming the log."),
		"DefaultValue", true,
	}),
	PlaceObj("ModItemOptionToggle", {
		"name", "DisableDialogEscape",
		"DisplayName", T(302535920001669, "Disable Dialog Escape"),
		"Help", T(302535920001670, "Pressing Escape won't close dialog boxes."),
		"DefaultValue", true,
	}),
}

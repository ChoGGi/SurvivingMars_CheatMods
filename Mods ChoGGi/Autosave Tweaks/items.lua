-- See LICENSE for terms

return {
	PlaceObj("ModItemOptionToggle", {
		"name", "EnableMod",
		"DisplayName", T(302535920011303, "<color ChoGGi_yellow>Enable Mod</color>"),
		"Help", T(302535920011793, "Disable mod without having to see missing mod msg."),
		"DefaultValue", true,
	}),
	PlaceObj("ModItemOptionNumber", {
		"name", "AutosaveInterval",
		"DisplayName", T(0000, "Autosave Interval"),
		"Help", T(0000, "Time in minutes between autosaves (saves while paused)."),
		"DefaultValue", 10,
		"MinValue", 1,
		"MaxValue", 60,
	}),
	PlaceObj("ModItemOptionNumber", {
		"name", "MaxAutosaves",
		"DisplayName", T(0000, "Max Autosaves"),
		"Help", T(0000, "Overwrite old autosave once limit is met."),
		"DefaultValue", 5,
		"MinValue", 1,
		"MaxValue", 50,
	}),
}

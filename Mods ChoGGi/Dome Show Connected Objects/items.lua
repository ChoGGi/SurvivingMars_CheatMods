-- See LICENSE for terms

return {
	PlaceObj("ModItemOptionToggle", {
		"name", "EnableMod",
		"DisplayName", T(302535920011303, "Enable Mod"),
		"DefaultValue", true,
	}),
	PlaceObj("ModItemOptionToggle", {
		"name", "CleanUpInvalid",
		"DisplayName", T(302535920011769, "Clean Up Invalid"),
		"Help", T(302535920011770, "Remove any invalid objects stuck in the dome when you press the toggle connected objs button."),
		"DefaultValue", false,
	}),
}
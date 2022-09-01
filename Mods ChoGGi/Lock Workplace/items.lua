-- See LICENSE for terms

return {
	PlaceObj("ModItemOptionToggle", {
		"name", "NeverChange",
		"DisplayName", T(302535920011096, "Never Change"),
		"Help", T(302535920011579, "Workers will never change workplace (may cause issues)."),
		"DefaultValue", false,
	}),
	PlaceObj("ModItemOptionToggle", {
		"name", "SeniorsOverride",
		"DisplayName", T(0000, "Seniors Override"),
		"Help", T(0000, "Allow graceful retirement."),
		"DefaultValue", true,
	}),
}

-- See LICENSE for terms

return {
	PlaceObj("ModItemOptionToggle", {
		"name", "EnableVegetation",
		"DisplayName", T(302535920011694, "Enable Vegetation"),
		"Help", T(302535920011695, "Turn off to hide vegetation."),
		"DefaultValue", true,
	}),
	PlaceObj("ModItemOptionToggle", {
		"name", "ToggleBushes",
		"DisplayName", T(302535920011696, "Toggle Bushes"),
		"Help", T(302535920011697, "Also toggle bushes along with trees."),
		"DefaultValue", false,
	}),
}

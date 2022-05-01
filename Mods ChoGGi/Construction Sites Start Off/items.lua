-- See LICENSE for terms

return {
	PlaceObj("ModItemOptionToggle", {
		"name", "EnableMod",
		"DisplayName", T(302535920011303, "<color ChoGGi_yellow>Enable Mod</color>"),
		"Help", T(302535920011793, "Disable mod without having to see missing mod msg."),
		"DefaultValue", true,
	}),
	PlaceObj("ModItemOptionToggle", {
		"name", "SkipGrids",
		"DisplayName", T(302535920011671, "Skip Grids"),
		"Help", T(302535920011672, "Don't turn off cables and pipes."),
		"DefaultValue", false,
	}),
	PlaceObj("ModItemOptionToggle", {
		"name", "SkipPassages",
		"DisplayName", T(302535920011673, "Skip Passages"),
		"Help", T(302535920011674, "Don't turn off passages."),
		"DefaultValue", false,
	}),
	PlaceObj("ModItemOptionToggle", {
		"name", "TurnOffBuildings",
		"DisplayName", T(0000, "Turn Off Buildings"),
		"Help", T(0000, "Turn off newly placed buildings."),
		"DefaultValue", false,
	}),
}

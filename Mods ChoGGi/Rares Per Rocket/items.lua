-- See LICENSE for terms

return {
	PlaceObj("ModItemOptionToggle", {
		"name", "EnableMod",
		"DisplayName", T(302535920011303, "<color ChoGGi_yellow>Enable Mod</color>"),
		"Help", T(302535920011793, "Disable mod without having to see missing mod msg."),
		"DefaultValue", true,
	}),
	PlaceObj("ModItemOptionNumber", {
		"name", "AmountOfRares",
		"DisplayName", T(302535920011161, "Amount of rares"),
		"DefaultValue", 90,
		"MinValue", 30,
		"MaxValue", 300,
	}),
}

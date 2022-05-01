-- See LICENSE for terms

return {
	PlaceObj("ModItemOptionToggle", {
		"name", "EnableMod",
		"DisplayName", T(302535920011303, "<color ChoGGi_yellow>Enable Mod</color>"),
		"Help", T(302535920011793, "Disable mod without having to see missing mod msg."),
		"DefaultValue", true,
	}),
	PlaceObj("ModItemOptionNumber", {
		"name", "PercentDrop",
		"DisplayName", T(302535920011893, "Percent Drop"),
		"Help", T(302535920011894, "How much of full amount to drop."),
		"DefaultValue", 100,
		"MinValue", 0,
		"MaxValue", 100,
	}),
}

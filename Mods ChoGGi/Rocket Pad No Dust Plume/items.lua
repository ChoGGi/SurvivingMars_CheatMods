-- See LICENSE for terms

return {
	PlaceObj("ModItemOptionToggle", {
		"name", "EnableMod",
		"DisplayName", T(302535920011303, "<color ChoGGi_yellow>Enable Mod</color>"),
		"Help", T(302535920011793, "Disable mod without having to see missing mod msg."),
		"DefaultValue", true,
	}),
	PlaceObj("ModItemOptionToggle", {
		"name", "LessDust",
		"DisplayName", T(302535920011895, "Less Dust"),
		"Help", T(302535920011896, "Some dust not as much as the usual."),
		"DefaultValue", false,
	}),
}

-- See LICENSE for terms

return {
	PlaceObj("ModItemOptionToggle", {
		"name", "EnableMod",
		"DisplayName", T(302535920011303, "<color ChoGGi_yellow>Enable Mod</color>"),
		"Help", T(302535920011793, "Disable mod without having to see missing mod msg."),
		"DefaultValue", true,
	}),
	PlaceObj("ModItemOptionToggle", {
		"name", "NoNegative",
		"DisplayName", T(302535920011935, "No Negative"),
		"Help", T(302535920011936, "Remove all negative traits (almost like it's an actual breakthrough)."),
		"DefaultValue", false,
	}),
}

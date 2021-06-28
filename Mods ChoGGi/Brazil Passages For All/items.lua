-- See LICENSE for terms

return {
	PlaceObj("ModItemOptionToggle", {
		"name", "EnableMod",
		"DisplayName", T(302535920011303, "<color ChoGGi_yellow>Enable Mod</color>"),
		"Help", T(302535920011793, "Disable mod without having to see missing mod msg."),
		"DefaultValue", true,
	}),
	PlaceObj("ModItemOptionToggle", {
		"name", "InstantPassages",
		"DisplayName", T(10141, "Instant Passages"),
		"Help", T(10464, "Passages are built instantly and cost nothing when this is not 0"),
		"DefaultValue", false,
	}),
}

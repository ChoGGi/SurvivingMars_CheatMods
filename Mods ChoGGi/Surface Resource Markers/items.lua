-- See LICENSE for terms

return {
	PlaceObj("ModItemOptionToggle", {
		"name", "EnableMod",
		"DisplayName", T(302535920011303, "<color ChoGGi_yellow>Enable Mod</color>"),
		"Help", T(302535920011793, "Disable mod without having to see missing mod msg."),
		"DefaultValue", true,
	}),
	PlaceObj("ModItemOptionNumber", {
		"name", "MarkerScale",
		"DisplayName", T(0000, "Marker Scale"),
		"Help", T(0000, "How large to make the marker icon."),
		"DefaultValue", 25,
		"MinValue", 0,
		"MaxValue", 200,
	}),
}

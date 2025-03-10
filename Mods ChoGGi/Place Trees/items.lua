-- See LICENSE for terms

return {
	PlaceObj("ModItemOptionToggle", {
		"name", "EnableMod",
		"DisplayName", T(302535920011303, "<color ChoGGi_yellow>Enable Mod</color>"),
		"Help", T(302535920011793, "Disable mod without having to see missing mod msg."),
		"DefaultValue", true,
	}),
	PlaceObj("ModItemOptionToggle", {
		"name", "FreeFormPlacement",
		"DisplayName", T(0000, "Free Form Placement"),
		"Help", T(0000, "Turn on to place buildings outside of grid limits."),
		"DefaultValue", true,
	}),
--~ 	PlaceObj("ModItemOptionToggle", {
--~ 		"name", "FullRotation",
--~ 		"DisplayName", T(0000, "Full Rotation"),
--~ 		"Help", T(0000, "Turn on to have a finer degree of rotation."),
--~ 		"DefaultValue", true,
--~ 	}),
}

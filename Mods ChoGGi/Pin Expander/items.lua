-- See LICENSE for terms

return {
	PlaceObj("ModItemOptionToggle", {
		"name", "EnableMod",
		"DisplayName", T(302535920011303, "<color ChoGGi_yellow>Enable Mod</color>"),
		"Help", T(302535920011793, "Disable mod without having to see missing mod msg."),
		"DefaultValue", true,
	}),
	PlaceObj("ModItemOptionToggle", {
		"name", "ReverseCtrl",
		"DisplayName", T(0000, "Reverse Ctrl"),
		"Help", T(0000, "Chanes how the mod works: You have to have down Ctrl to see modded menu."),
		"DefaultValue", false,
	}),
}

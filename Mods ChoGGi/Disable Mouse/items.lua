return {
	PlaceObj("ModItemOptionToggle", {
		"name", "EnableMod",
		"DisplayName", T(302535920011303, "Enable Mod"),
		"Help", T(302535920011793, "Disable mod without having to see missing mod msg."),
		"DefaultValue", true,
	}),
	PlaceObj("ModItemOptionToggle", {
		"name", "DisableHUD",
		"DisplayName", T(302535920011594, "Hide Bottom HUD Buttons"),
		"Help", T(302535920011595, "Leaves the speed buttons, but removes the rest."),
		"DefaultValue", false,
	}),
}

return {
	PlaceObj("ModItemOptionToggle", {
		"name", "EnableMod",
		"DisplayName", table.concat(T(754117323318, "Enable") .. " " .. T(12360, "Mod")),
		"Help", T(302535920011593, "If you want to turn off the mod disable this option."),
		"DefaultValue", true,
	}),
	PlaceObj("ModItemOptionToggle", {
		"name", "DisableHUD",
		"DisplayName", T(302535920011594, "Hide Bottom HUD Buttons"),
		"Help", T(302535920011595, "Leaves the speed buttons, but removes the rest."),
		"DefaultValue", false,
	}),
}

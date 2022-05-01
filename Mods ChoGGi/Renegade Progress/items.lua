return {
	PlaceObj("ModItemOptionToggle", {
		"name", "DisableRenegades",
		"DisplayName", table.concat(T(12228, "Disable") .. " " .. T(7031, "Renegades")),
		"Help", T(302535920011533, "Anyone that gets the renegade trait will have it removed (does nothing for existing ones)."),
		"DefaultValue", false,
	}),
}

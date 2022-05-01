return {
	PlaceObj("ModItemOptionToggle", {
		"name", "SkipDelete",
		"DisplayName", table.concat(T(9428, "Skip") .. " " .. T(12071, "Delete")),
		"DefaultValue", false,
	}),
	PlaceObj("ModItemOptionToggle", {
		"name", "SalvageFullDepots",
		"DisplayName", T(302535920011996, "Salvage Full Depots"),
		"Help", T(302535920011997, "If a mechanical depot has resources it in they'll be removed!"),
		"DefaultValue", false,
	}),
}

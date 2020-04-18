return {
	PlaceObj("ModItemOptionToggle", {
		"name", "Enable",
		"DisplayName", T(302535920011067, "Show during construction"),
		"DefaultValue", true,
	}),
	PlaceObj("ModItemOptionNumber", {
		"name", "AdjustLineLength",
		"DisplayName", T(302535920011351, "Adjust Line Length"),
		-- removed 5 for the angles passages (may) need
		"DefaultValue", 5,
		"MinValue", 0,
		"MaxValue", 20,
	}),
}
